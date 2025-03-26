from odoo import models, fields, api, _
from odoo.exceptions import UserError

class PaymentProviderSaldo(models.Model):
    _inherit = 'payment.provider'

    saldo_payment_type = fields.Selection(
        [('saldo', 'Pago con saldo')],
        string="Tipo de Pago con Saldo",
        default='saldo'
    )

    def process_saldo_payment(self, partner_id, amount, order_id):
        partner = self.env['res.partner'].browse(partner_id)
        if partner.saldo < amount:
            raise UserError(_('No tienes suficiente saldo para realizar este pago.'))

        # Descontamos saldo al cliente
        partner.saldo -= amount
        partner.sudo().write({'saldo': partner.saldo})

        # ✅ CREAR TRANSACCIÓN Y ASIGNAR `payment_option_id`
        transaction = self.env['payment.transaction'].create({
            'provider_id': self.id,
            'partner_id': partner.id,
            'amount': amount,
            'currency_id': self.env.company.currency_id.id,
            'reference': order_id,
            'state': 'done',
            'operation': 'direct',
            'payment_option_id': self.id  # ✅ Asegurar que se guarda el método de pago
        })

        return {
            'status': 'success',
            'message': _('Pago realizado con éxito mediante saldo.'),
            'transaction_id': transaction.id,
        }
