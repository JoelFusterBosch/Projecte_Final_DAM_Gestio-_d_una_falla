from odoo import http
from odoo.http import request
import logging

_logger = logging.getLogger(__name__)

class EventStatusController(http.Controller):

    @http.route(['/event/registration_status'], type='json', auth="user")
    def registration_status(self, event_id=None):
        _logger.warning("💣 [INICI] Comprovant estat de registre | Event ID: %s | Partner ID: %s ",
                        event_id, request.env.user.partner_id.id)

        domain = [
            ('partner_id', '=', request.env.user.partner_id.id),
            ('event_id', '=', int(event_id)),
        ]
        orders = request.env['sale.order'].sudo().search(domain, order="id desc")
        _logger.info("📋 Total comandes del partner %s: %s ",
                     request.env.user.partner_id.id, len(orders))

        for order in orders:
            _logger.info("🧾 Comanda %s - Estat: %s - Event ID: %s - Signature: %s",
                         order.name, order.state, order.event_id.id, bool(order.signature))

            # 🔍 Nova comprovació: ignorar comandes sense registres d'assistents
            registrations = request.env['event.registration'].sudo().search([
                ('sale_order_id', '=', order.id),
                ('partner_id', '=', request.env.user.partner_id.id),
            ])

            if not registrations:
                _logger.info("⚠️ La comanda %s no té registres d’assistent per al partner %s. Ignorada.",
                            order.name, request.env.user.partner_id.id)
                continue

            # Mostrar l’estat segons la comanda
            if order.state in ['sale', 'done']:
                return {
                    'status': 'pagat',
                    'label': 'Pagat',
                    'color': 'success',
                }
            elif order.state == 'sent':
                if order.signature:
                    return {
                        'status': 'registrat',
                        'label': 'Registrat',
                        'color': 'warning',
                    }
                else:
                    return {
                        'status': 'pressupostat',
                        'label': 'Pressupostat',
                        'color': 'danger',
                    }

        _logger.warning("❌ Cap comanda vinculada vàlida trobada → retornant \"cap\" ")
        return {
            'status': 'cap',
            'label': '',
            'color': '',
        }
