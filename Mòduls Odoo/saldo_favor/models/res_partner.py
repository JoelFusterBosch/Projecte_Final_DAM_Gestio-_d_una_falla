from odoo import models, fields

class ResPartner(models.Model):
    _inherit = 'res.partner'

    saldo_a_favor = fields.Float(string='Saldo a Favor')
