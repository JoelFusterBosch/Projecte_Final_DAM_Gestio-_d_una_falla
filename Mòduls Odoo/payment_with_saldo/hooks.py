from odoo import api, SUPERUSER_ID
import logging

_logger = logging.getLogger(__name__)

def archive_default_shop(cr, registry):
    _logger.warning("🔥 Executant hook archive_default_shop")
    env = api.Environment(cr, SUPERUSER_ID, {})
    shop_pos = env['pos.config'].search([('name', '=', 'Shop')], limit=1)
    if shop_pos:
        shop_pos.write({'active': False})
        _logger.warning("✅ HOOK: TPV 'Shop' arxivat.")
    else:
        _logger.warning("⚠️ HOOK: No s'ha trobat cap TPV amb nom 'Shop'.")
