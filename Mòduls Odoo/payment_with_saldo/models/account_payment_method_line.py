from odoo import models, fields

class AccountPaymentMethodLine(models.Model):
    _inherit = 'account.payment.method.line'

    provider_id = fields.Many2one('payment.provider', string="Proveedor de pago", ondelete='cascade')
