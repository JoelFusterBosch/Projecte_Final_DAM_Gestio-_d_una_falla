from odoo import models, fields, api
from odoo.exceptions import ValidationError
import logging

_logger = logging.getLogger(__name__)

class MiembroFamilia(models.Model):
    _name = 'familia.miembro'
    _description = 'Miembro de la Familia'

    partner_id = fields.Many2one('res.partner', string='Cliente', required=True)
    familia_id = fields.Many2one('familia', string='Familia', ondelete='cascade', required=True)
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
        # Verificar si el miembro ya pertenece a otra familia
        existing_member = self.env['familia.miembro'].search([('partner_id', '=', vals.get('partner_id'))])
        if existing_member:
            raise ValidationError("Este miembro ya pertenece a una familia y no puede ser añadido a otra.")

        # Obtener el saldo del nuevo miembro antes de crearlo
        saldo_miembro = self.env['res.partner'].browse(vals['partner_id']).saldo_a_favor

        familia = self.env['familia'].browse(vals['familia_id'])

        if familia and saldo_miembro:
            # Sumar el saldo del nuevo miembro al saldo total de la familia antes de añadir el miembro
            familia.saldo_total += saldo_miembro
            _logger.info(f"Saldo total de la familia {familia.name} actualizado a {familia.saldo_total}")

        # Ahora creamos el miembro, con el saldo total ya actualizado
        miembro = super(MiembroFamilia, self).create(vals)

        return miembro

    def unlink(self):
        for miembro in self:
            cliente = miembro.partner_id  # Obtener el cliente asociado al miembro

            super(MiembroFamilia, self).unlink()  # Eliminar el miembro de la familia

            # Luego de eliminar el miembro, ponemos a cero el saldo del cliente
            cliente.with_context(avoid_recursion=True).write({'saldo_a_favor': 0.0})
            _logger.info(f"Saldo del cliente {cliente.name} inicializado a 0.0 después de abandonar la familia")

        return True
