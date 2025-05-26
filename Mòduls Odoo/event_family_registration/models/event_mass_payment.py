from odoo import models, api, exceptions, _
import logging

_logger = logging.getLogger(__name__)

class EventMassPayment(models.TransientModel):
    _name = 'event.mass.payment'
    _description = 'Processar pagaments massius per esdeveniments'

    @api.model
    def process_mass_payments(self):
        SaleOrder = self.env['sale.order'].sudo()
        orders = SaleOrder.search([('state', 'in', ['draft', 'sent'])])
        processed = 0
        skipped = 0

        for order in orders:
            partner = order.partner_id
            if partner.saldo >= order.amount_total:
                # Descomptar saldo i confirmar comanda
                partner.sudo().write({'saldo': partner.saldo - order.amount_total})
                order.sudo().action_confirm()
                order.message_post(body=_("Comanda confirmada i pagada amb saldo a favor."))
                processed += 1
                _logger.info(f"Confirmada comanda {order.name} per al client {partner.name}.")
            else:
                skipped += 1
                order.message_post(body=_("No s'ha pogut confirmar la comanda: saldo insuficient."))
                _logger.warning(f"Comanda {order.name} no confirmada: saldo insuficient per a {partner.name}.")

        return {
            'type': 'ir.actions.client',
            'tag': 'display_notification',
            'params': {
                'title': _('Pagaments massius completats'),
                'message': _('Comandes confirmades: %s | Omeses per saldo insuficient: %s') % (processed, skipped),
                'type': 'success',
                'sticky': False,
            }
        }
