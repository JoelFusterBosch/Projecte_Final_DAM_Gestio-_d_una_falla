from odoo import models, api

class AccountMove(models.Model):
    _inherit = 'account.move'

    @api.model
    def create(self, vals):
        move = super(AccountMove, self).create(vals)
        if move.move_type == 'out_invoice':
            saldo_usado = 0
            for line in move.invoice_line_ids:
                if line.product_id.name == 'Saldo a Favor':
                    saldo_usado += line.price_unit * line.quantity
            if saldo_usado > 0:
                move.partner_id.saldo_a_favor -= saldo_usado
        return move
