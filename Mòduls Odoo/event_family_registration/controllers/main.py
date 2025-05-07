from odoo import http
from odoo.http import request
from odoo.exceptions import ValidationError
import logging

_logger = logging.getLogger(__name__)

class EventRegistrationController(http.Controller):

    @http.route('/event/<model("event.event"):event>/register', type='json', auth='public', methods=['POST'], csrf=True)
    def register_event(self, event, partner_id=None, ticket_quantities=None, csrf_token=None):
        # Validar el token CSRF
        if not request.validate_csrf(csrf_token):
            return {'status': 'error', 'message': 'Token CSRF inválido o ausente.'}
        else:
            print("Token CSRF válido.")

        # Validar que existan los parámetros necesarios
        if not partner_id or not ticket_quantities:
            return {
                'status': 'error',
                'message': 'Faltan parámetros requeridos',
            }

        try:
            # Convertir IDs a enteros para asegurar consistencia
            partner_id = int(partner_id)
            ticket_quantities = {int(ticket_id): int(quantity) for ticket_id, quantity in ticket_quantities.items()}

            # Obtener el partner y asegurarse que existe
            partner = request.env['res.partner'].sudo().browse(partner_id)

            if not partner.exists():
                return {
                    'status': 'error',
                    'message': 'Partner no encontrado.',
                }

            # Registrar tickets respetando las restricciones de familia
            sale_order_id = event.register_family(partner_id, event.id, ticket_quantities)

            return {
                'status': 'success',
                'message': 'Registro completado correctamente.',
                'sale_order_id': sale_order_id  # Enviar el ID del presupuesto al frontend
            }

        except ValidationError as e:
            return {
                'status': 'error',
                'message': str(e),
            }

        except Exception as e:
            print(f'Error inesperado: {str(e)}')
            return {
                'status': 'error',
                'message': 'Ha ocurrido un error inesperado: ' + str(e),
            }

    @http.route(['/my/orders/<int:order_id>/decline'], type='http', auth="user", website=True)
    def decline_order(self, order_id, **kwargs):
        """
        Controlador para rechazar un presupuesto desde el portal del cliente.
        """
        order = request.env['sale.order'].sudo().browse(order_id)
        if order:
            _logger.info(f"El cliente {request.env.user.partner_id.id} está rechazando el presupuesto {order_id}.")
            order.action_reject_quotation()
            _logger.info(f"Presupuesto {order_id} rechazado correctamente.")
        else:
            _logger.warning(f"No se pudo encontrar el presupuesto {order_id} para rechazar.")
        
        # Redirigir al cliente de vuelta a la página de pedidos
        return request.redirect('/my/orders')


    @http.route('/event/<int:event_id>/max_faller_limits', type='json', auth='public')
    def get_max_faller_limits(self, event_id, partner_id):
        event = request.env['event.event'].sudo().browse(event_id)
        partner = request.env['res.partner'].sudo().browse(partner_id)

        miembro_familia = request.env['familia.miembro'].sudo().search([
            ('partner_id', '=', partner.id)
        ], limit=1)

        if not miembro_familia:
            return {}  # No hi ha límit si no és membre de família

        family_member_count = len(miembro_familia.familia_id.miembros_ids)

        limits = {}
        for ticket in event.ticket_ids:
            if ticket.max_faller:
                limits[ticket.id] = family_member_count
        return limits
