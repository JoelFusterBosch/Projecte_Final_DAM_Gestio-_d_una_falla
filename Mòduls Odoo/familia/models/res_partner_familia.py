from odoo import models, fields, api

class ResPartnerFamilia(models.Model):
    _inherit = 'res.partner'

    saldo_a_favor = fields.Float(string='Saldo a Favor', compute='_compute_saldo_a_favor', store=False)

    def _compute_saldo_a_favor(self):
        for partner in self:
            miembro = self.env['familia.miembro'].search([('partner_id', '=', partner.id)], limit=1)
            if miembro and miembro.familia_id:
                # Si es miembro de una familia, su saldo a favor es el saldo total de la familia
                partner.saldo_a_favor = miembro.familia_id.saldo_total
            else:
                # Si no es miembro de una familia, el saldo es cero
                partner.saldo_a_favor = 0.0

    def write(self, vals):
        if 'saldo_a_favor' in vals:
            for partner in self:
                miembro = self.env['familia.miembro'].search([('partner_id', '=', partner.id)], limit=1)
                if miembro and miembro.familia_id:
                    familia = miembro.familia_id
                    diferencia = partner.saldo_a_favor - vals['saldo_a_favor']
                    # Disminuir el saldo total de la familia en la misma medida que el saldo personal del miembro
                    familia.saldo_total -= diferencia

        return super(ResPartnerFamilia, self).write(vals)
