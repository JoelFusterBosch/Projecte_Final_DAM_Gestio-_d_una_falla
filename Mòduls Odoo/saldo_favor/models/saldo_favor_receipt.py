from odoo import models, fields

class SaldoFavorReceipt(models.Model):
    _name = 'saldo.favor.receipt'
    _description = 'Recibo de Saldo a Favor'

    partner_id = fields.Many2one('res.partner', string='Cliente', required=True)
    amount = fields.Float(string='Monto', required=True)
    date = fields.Datetime(string='Fecha', default=fields.Datetime.now, required=True)
