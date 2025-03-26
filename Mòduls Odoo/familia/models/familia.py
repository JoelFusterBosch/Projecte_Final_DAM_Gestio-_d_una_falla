from odoo import models, fields

class Familia(models.Model):
    _name = 'familia'
    _description = 'Familia'

    name = fields.Char(string='Nombre', required=True)
    saldo_total = fields.Float(string='Saldo Total', readonly=True)
    miembros_ids = fields.One2many('familia.miembro', 'familia_id', string="Miembros")
