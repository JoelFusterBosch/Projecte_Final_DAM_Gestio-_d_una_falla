from odoo import models, fields, api

class SaldoFavorWizard(models.TransientModel):
    _name = 'saldo.favor.wizard'
    _description = 'Ingreso de Saldo a Favor'

    partner_id = fields.Many2one('res.partner', string='Cliente', required=True)
    amount = fields.Float(string='Monto', required=True)

    def action_confirm(self):
        self.ensure_one()
        # Actualizar el saldo a favor del cliente
        self.partner_id.saldo_a_favor += self.amount
        # Crear el recibo
        self.env['saldo.favor.receipt'].create({
            'partner_id': self.partner_id.id,
            'amount': self.amount,
            'date': fields.Datetime.now(),
        })
        return {'type': 'ir.actions.act_window_close'}

