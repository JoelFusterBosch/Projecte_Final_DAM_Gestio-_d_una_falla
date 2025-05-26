import logging
from odoo import models

_logger = logging.getLogger(__name__)

class AccountMove(models.Model):
    _inherit = 'account.move'

    def action_cancel_and_delete_massive(self):
        for invoice in self:
            _logger.info(f"📎 Revisant factura {invoice.name} (estat: {invoice.state})")
            try:
                if invoice.state == 'posted':
                    _logger.info(f"→ Anul·lant factura publicada: {invoice.name}")
                    invoice.sudo().button_cancel()
                    _logger.info(f"✅ Anul·lada: {invoice.name}")

                # Desconciliar línies abans d'intentar eliminar
                for line in invoice.line_ids:
                    if line.reconciled:
                        _logger.info(f"🔓 Desconciliant línia: {line.name} (ID: {line.id})")
                        line.remove_move_reconcile()

                if invoice.state in ['draft', 'cancel']:
                    _logger.info(f"🗑️ Eliminant factura: {invoice.name}")
                    invoice.sudo().unlink()
                else:
                    _logger.warning(f"⚠️ No es pot eliminar la factura {invoice.name} en estat {invoice.state}")
            except Exception as e:
                _logger.error(f"💥 Error amb la factura {invoice.name}: {str(e)}")
                if invoice.line_ids:
                    _logger.error(f"ℹ️ Línies afectades: {','.join(str(l.id) for l in invoice.line_ids)}")
