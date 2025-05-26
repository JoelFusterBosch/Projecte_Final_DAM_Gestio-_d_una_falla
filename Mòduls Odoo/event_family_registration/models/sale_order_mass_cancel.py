import logging
from odoo import models

_logger = logging.getLogger(__name__)

class SaleOrder(models.Model):
    _inherit = 'sale.order'

    def action_cancel_massive(self):
        for order in self:
            _logger.info(f"🔍 Revisant comanda {order.name} (estat: {order.state})")
            if order.state in ['cancel', 'done']:
                _logger.info(f"⛔ Comanda {order.name} ja estava cancel·lada o finalitzada")
                continue

            _logger.info(f"→ Forçant cancel·lació de la comanda: {order.name}")
            try:
                order.sudo().write({'state': 'cancel'})
                order.message_post(body="⚠️ Comanda cancel·lada automàticament de manera forçada.")
                _logger.info(f"✅ Estat després del write: {order.state}")
            except Exception as e:
                _logger.error(f"💥 Error forçant cancel·lació de {order.name}: {str(e)}")
