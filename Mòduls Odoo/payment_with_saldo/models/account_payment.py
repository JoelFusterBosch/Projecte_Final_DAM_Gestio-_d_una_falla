from odoo import models, fields, exceptions, _

class AccountPaymentMethodSaldo(models.Model):
    _inherit = 'account.payment'

    payment_method_type = fields.Selection(
        selection=[('saldo', 'Pago con saldo'), ('cash', 'En metálico')],
        string="Tipo de Método de Pago",
        required=True,
        default='saldo'
    )

    payment_option_id = fields.Many2one(
        'payment.provider',
        string="Opción de pago",
        help="Método de pago seleccionado"
    )

    def action_post(self):
        for record in self:
            if record.payment_method_type == 'saldo':
                cliente = record.partner_id
                if cliente.saldo < record.amount:
                    raise exceptions.UserError(_('Saldo insuficiente para completar el pago.'))

                # Descomptar el saldo
                cliente.saldo -= record.amount
                cliente.sudo().write({'saldo': cliente.saldo})

                # Assignar el diari de pagament
                journal_saldo = self.env['account.journal'].search([('code', '=', 'BF')], limit=1)
                if journal_saldo:
                    record.write({'journal_id': journal_saldo.id})

                # 🔥 **ASSEGURAR QUE `payment_option_id` ESTÀ ASSIGNAT**
                if not record.payment_option_id:
                    provider_saldo = self.env['payment.provider'].search([('code', '=', 'custom')], limit=1)
                    if provider_saldo:
                        record.payment_option_id = provider_saldo
                    else:
                        raise exceptions.UserError(_("No s'ha trobat el proveïdor de pagament per saldo."))

                # 🔥 **CREAR LA TRANSACTIÓ I ASSEGURAR-SE QUE `payment_option_id` ES REGISTRA**
                transaction = self.env['payment.transaction'].create({
                    'provider_id': record.payment_option_id.id,
                    'partner_id': cliente.id,
                    'amount': record.amount,
                    'currency_id': record.currency_id.id or self.env.company.currency_id.id,
                    'reference': record.name or self.env['ir.sequence'].next_by_code('payment.transaction'),
                    'state': 'done',
                    'operation': 'direct',
                    'payment_option_id': record.payment_option_id.id,  # ✅ **ARA ASSIGNEM `payment_option_id`**
                })

                transaction._set_done()
                transaction._reconcile_after_done()

        return super(AccountPaymentMethodSaldo, self).action_post()
