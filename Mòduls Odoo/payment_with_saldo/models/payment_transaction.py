import logging
from odoo import models, fields, api

_logger = logging.getLogger(__name__)  # 🔹 Definim el logger aquí

class PaymentTransaction(models.Model):
    _inherit = 'payment.transaction'

    payment_option_id = fields.Integer(
        string="Payment Option ID",
        help="Opció de pagament seleccionada pel client"
    )

    payment_method_line_id = fields.Many2one(
        'account.payment.method.line',
        string="Payment Method Line",
        help="Línia del mètode de pagament seleccionat"
    )

    def _post_process_after_done(self):
        """
        🚀 Aquest mètode es crida automàticament quan la transacció es marca com 'done'.
        """
        for transaction in self:
            _logger.info(f"✅ [SALDO] Post-processament de la transacció {transaction.id} després de marcar-la com 'done'.")

            if transaction.provider_id and transaction.provider_id.code == 'custom':
                _logger.info(f"🔍 [SALDO] Processant post-pagament per {transaction.reference} (Custom Provider).")

                # Actualitzar estat de la comanda associada
                for order in transaction.sale_order_ids:
                    _logger.info(f"🔹 [SALDO] Confirmant la comanda {order.id}...")
                    order.sudo().write({'state': 'sale'})  # Confirmem la comanda

                    # Afegeix un missatge a l'historial de la comanda
                    order.sudo().message_post(body="💰 [SALDO] Pagament realitzat correctament.")

        return True  # ✅ Retornem True perquè el procés continue sense errors
