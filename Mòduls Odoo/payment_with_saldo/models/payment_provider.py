from odoo import models, fields, api, _
from odoo.exceptions import UserError
import logging

_logger = logging.getLogger(__name__)

class PaymentProviderSaldo(models.Model):
    _inherit = 'payment.provider'

    code = fields.Selection(
        selection_add=[('custom', 'Saldo personal')],
        ondelete={'custom': 'cascade'}
    )

    saldo_payment_type = fields.Selection(
        [('saldo', 'Pago con saldo')],
        string="Tipo de Pago con Saldo",
        default='saldo'
    )

    def process_saldo_payment(self, partner_id, amount, order_id):
        partner = self.env['res.partner'].browse(partner_id)

        # Buscar membre i família
        miembro = self.env['familia.miembro'].search([('partner_id', '=', partner.id)], limit=1)
        if not miembro or not miembro.familia_id:
            raise UserError(_('Este cliente no pertenece a ninguna familia.'))
        else:
            _logger.info(f"👤 Membre trobat: {miembro.name} amb ID: {miembro.id}")
            familia = miembro.familia_id

            # Validar saldo
            if familia.saldo_total < amount:
                raise UserError(_('No hay suficiente saldo en la familia para realizar este pago.'))
            else:
                _logger.info(f"💳 Pagament amb saldo familiar: {amount} € per a {partner.name}")
                # Descomptar saldo
                nuevo_saldo = familia.saldo_total - amount
                familia.sudo().write({'saldo_total': nuevo_saldo})
                _logger.info(f"💳 Descompte de saldo: {amount} €. Nou saldo: {nuevo_saldo}")
                # 🔁 Sincronitzar saldo a tots els membres
                familia.actualitzar_saldo_membres()


                # ✏️ Registre al *chatter*
                familia.message_post(
                    body=_("El membre %s ha fet un pagament de %s €. Nou saldo familiar: %s €") % (
                        partner.name, amount, nuevo_saldo),
                    subject=_("Pagament amb saldo familiar")
                )

                # Crear la transacció
                transaction = self.env['payment.transaction'].create({
                    'provider_id': self.id,
                    'partner_id': partner.id,
                    'amount': amount,
                    'currency_id': self.env.company.currency_id.id,
                    'reference': order_id,
                    'state': 'done',
                    'operation': 'direct',
                    'payment_option_id': self.id
                })

                return {
                    'status': 'success',
                    'message': _('Pago realizado con éxito mediante saldo familiar.'),
                    'transaction_id': transaction.id,
                }
