from odoo import models, fields, api
from odoo.exceptions import ValidationError
import logging

_logger = logging.getLogger(__name__)

class MiembroFamilia(models.Model):
    _name = 'familia.miembro'
    _description = 'Miembro de la Familia'

    partner_id = fields.Many2one('res.partner', string='Cliente', required=True)
    familia_id = fields.Many2one('familia.familia', string='Familia', ondelete='cascade', required=True)
    saldo = fields.Float(string='Saldo', readonly=True, compute='_compute_saldo', store=True)
    tiene_limite = fields.Boolean(string='Tiene Límite de Gasto', default=False)
    limite_gasto = fields.Float(string='Límite de Gasto')
    es_administrador = fields.Boolean(string='Es Administrador')

    @api.depends('familia_id.saldo_total')
    def _compute_saldo(self):
        for miembro in self:
            miembro.saldo = miembro.familia_id.saldo_total

    @api.model
    def create(self, vals):
        existing_member = self.env['familia.miembro'].search([('partner_id', '=', vals.get('partner_id'))])
        if existing_member:
            raise ValidationError("Este miembro ya pertenece a una familia y no puede ser añadido a otra.")

        partner = self.env['res.partner'].browse(vals['partner_id'])
        saldo_miembro = partner.saldo_a_favor or 0.0
        familia = self.env['familia.familia'].browse(vals['familia_id'])

        if familia:
            if saldo_miembro > 0.0:
                nuevo_saldo_familia = familia.saldo_total + saldo_miembro
                familia.sudo().write({'saldo_total': nuevo_saldo_familia})
                _logger.info(f"Transferit {saldo_miembro}€ de {partner.name} a la família {familia.name}. Nou saldo total: {nuevo_saldo_familia}")
            else:
                nuevo_saldo_familia = familia.saldo_total

            partner.sudo().write({'saldo_a_favor': nuevo_saldo_familia})

        miembro = super(MiembroFamilia, self).create(vals)

        # 🔁 Actualitzem saldo de tots els membres
        if familia:
            familia.sudo().actualitzar_saldo_membres()
            body = f"El membre <strong>{partner.name}</strong> s'ha unit a la família."
            if saldo_miembro > 0.0:
                body += f" Ha aportat {saldo_miembro:.2f} € al saldo familiar."
            familia.message_post(subject="Nou membre", body=body)

        return miembro

    def unlink(self):
        for miembro in self:
            cliente = miembro.partner_id
            familia = miembro.familia_id
            cliente.with_context(skip_saldo=True).sudo().write({'saldo_a_favor': 0.0})
            _logger.info(f"Saldo del client {cliente.name} posat a 0 després d'abandonar la família")

            if familia:
                familia.message_post(
                    body=f"El membre <strong>{cliente.name}</strong> ha eixit de la família.",
                    subject="Baixa de membre"
                )

        return super(MiembroFamilia, self).unlink()
