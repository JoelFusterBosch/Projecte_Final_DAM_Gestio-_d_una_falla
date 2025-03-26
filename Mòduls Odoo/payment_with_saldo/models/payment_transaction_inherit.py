from odoo import models, fields

class PaymentTransactionInherit(models.Model):
    _inherit = 'payment.transaction'

    payment_option_id = fields.Integer(string="Payment Option ID")

    def _create_transaction(self, order, payment_option_id=None):
        """ Estenem `_create_transaction()` perquè accepti `payment_option_id` """
        tx = super()._create_transaction(order)  # 🔹 Cridem la funció original
        if payment_option_id:
            tx.payment_option_id = payment_option_id  # ✅ Assignem `payment_option_id`
        return tx
