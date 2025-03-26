from odoo import models, fields, api, _
from odoo.exceptions import UserError
import logging

_logger = logging.getLogger(__name__)

class SaleOrder(models.Model):
    _inherit = 'sale.order'

    event_id = fields.Many2one('event.event', string='Evento')

    def action_reject_quotation(self):
        """
        Permite al cliente rechazar un presupuesto desde el portal. Cancela el presupuesto y
        elimina los registros de asistentes asociados.
        """
        for order in self:
            _logger.info(f"Intentando rechazar el presupuesto {order.id} en estado {order.state}.")
            
            # Verificar si el estado es 'sent' y proceder a cancelar
            if order.state == 'sent':
                # Crear un contexto extendido para omitir el asistente de cancelación
                cancel_context = self.env.context.copy()
                cancel_context['disable_cancel_warning'] = True

                # Ejecutar la cancelación con el contexto extendido
                order.with_context(cancel_context).action_cancel()
                _logger.info(f"Presupuesto {order.id} cancelado exitosamente.")
                
                # Buscar y eliminar registros de asistentes asociados
                registrations = self.env['event.registration'].sudo().search([
                    ('sale_order_id', '=', order.id)
                ])
                if registrations:
                    _logger.info(f"Eliminando {len(registrations)} registros de asistentes asociados a la orden {order.id}.")
                    registrations.unlink()
                else:
                    _logger.info("No se encontraron registros de asistentes para eliminar.")
            else:
                _logger.warning(f"No se pudo cancelar el presupuesto {order.id} porque no está en estado 'sent'. Estado actual: {order.state}")
                raise UserError(_("Solo los presupuestos en estado 'Enviado' pueden ser rechazados."))

        return True
