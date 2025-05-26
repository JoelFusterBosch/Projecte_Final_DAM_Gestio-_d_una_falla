from odoo import models, api, _
from odoo.exceptions import UserError

class PosPayment(models.Model):
    _inherit = 'pos.payment'

    @api.model
    def create(self, vals):
        payment_method = self.env['pos.payment.method'].browse(vals.get('payment_method_id'))
        order = self.env['pos.order'].browse(vals.get('pos_order_id'))

        if payment_method.name == 'Saldo' and order.partner_id:
            partner = order.partner_id
            amount = vals.get('amount', 0.0)

            # Intenta usar saldo familiar si existeix
            miembro = self.env['familia.miembro'].sudo().search([('partner_id', '=', partner.id)], limit=1)
            if miembro and miembro.familia_id:
                familia = miembro.familia_id
                if familia.saldo_total < amount:
                    raise UserError(_('Saldo insuficient en la família per completar el pagament.'))
                familia.sudo().write({'saldo_total': familia.saldo_total - amount})
                familia.sudo().actualitzar_saldo_membres()
            else:
                # Fallback al saldo individual (si no està en una família)
                if partner.saldo_a_favor < amount:
                    raise UserError(_('Saldo insuficient per completar el pagament.'))
                partner.sudo().write({'saldo_a_favor': partner.saldo_a_favor - amount})

        return super().create(vals)
