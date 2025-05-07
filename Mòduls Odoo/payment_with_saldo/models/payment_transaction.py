import logging
from odoo import models, fields, _, api

_logger = logging.getLogger(__name__)

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
        for transaction in self:
            _logger.info(f"✅ [SALDO] Post-processament de la transacció {transaction.id} després de marcar-la com 'done'.")

            if transaction.provider_id and transaction.provider_id.code == 'custom':
                _logger.info(f"🔍 [SALDO] Processant post-pagament per {transaction.reference} (Custom Provider).")

                partner = transaction.partner_id
                currency = transaction.currency_id or self.env.company.currency_id

                journal = self.env['account.journal'].sudo().search([('code', '=', 'BNK1')], limit=1)
                if not journal:
                    _logger.error("❌ No s'ha trobat el journal 'BancFalla'")
                    continue

                payment_method_line = self.env['account.payment.method.line'].sudo().search([
                    ('journal_id', '=', journal.id),
                    ('payment_method_id.code', '=', 'saldo'),
                    ('payment_method_id.payment_type', '=', 'inbound'),
                ], limit=1)

                if not payment_method_line:
                    _logger.warning("⚠️ [SALDO] No s'ha trobat la línia per 'saldo'... intentant recuperar via `env.ref()`.")
                    try:
                        payment_method_line = self.env.ref('payment_with_saldo.payment_method_line_saldo')
                        _logger.info(f"✅ [SALDO] S'ha trobat via env.ref amb ID {payment_method_line.id}")
                    except ValueError:
                        _logger.error("❌ [SALDO] No existeix la referència XML 'payment_with_saldo.payment_method_line_saldo'")
                        continue

                transaction.payment_method_line_id = payment_method_line.id

                payment = self.env['account.payment'].sudo().create({
                    'partner_id': partner.id,
                    'amount': transaction.amount,
                    'payment_type': 'inbound',
                    'partner_type': 'customer',
                    'journal_id': journal.id,
                    'payment_method_line_id': payment_method_line.id,
                    'payment_transaction_id': transaction.id,
                    'currency_id': currency.id,
                })
                _logger.info(f"💸 [SALDO] Payment creat amb ID {payment.id}, validant...")

                payment.action_post()

                for order in transaction.sale_order_ids:
                    _logger.info(f"🔹 [SALDO] Confirmant la comanda {order.id}...")
                    order.sudo().write({'state': 'sale'})
                    order.sudo().message_post(body="💰 [SALDO] Pagament realitzat correctament.")

        return True

    def _create_payment(self):
        _logger.info(f"⚠️ [SALDO] S'ha ignorat _create_payment per a la transacció {self.reference}")
        return
