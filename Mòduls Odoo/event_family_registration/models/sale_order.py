from odoo import models, fields, api, _
from odoo.exceptions import UserError, ValidationError
from datetime import datetime, timedelta, timezone
import logging

_logger = logging.getLogger(__name__)

class SaleOrder(models.Model):
    _inherit = 'sale.order'

    payment_in_progress = fields.Boolean(
        string="Pagament en marxa",
        help="Es marca com a cert quan l'usuari ha iniciat el procés de pagament per evitar cancel·lacions automàtiques."
    )

    # 🔧 Duració del temps abans que expire el pressupost (en minuts)
    _EXPIRATION_MINUTES = 1

    expiration_datetime = fields.Datetime(
        string="Expira el",
        help="Data i hora d'expiració automàtica del pressupost."
    )

    event_id = fields.Many2one('event.event', string='Evento')

    @api.model
    def create(self, vals):
        # Bloquejar creacions durant el cron si ve amb context especial
        if self.env.context.get('cron_expiring'):
            _logger.warning("🚫 Intent de creació de pressupost durant el cron bloquejat.")
            raise ValidationError(_("No es pot crear un pressupost durant la cancel·lació automàtica."))

        partner_id = vals.get('partner_id')
        if partner_id:
            # Bloquejar duplicacions immediates del mateix client
            recent_cancelled = self.search_count([
                ('partner_id', '=', partner_id),
                ('state', '=', 'cancel'),
                ('create_date', '>=', fields.Datetime.to_string(datetime.now() - timedelta(minutes=2)))
            ])
            if recent_cancelled:
                _logger.warning("🚫 Intent de duplicació immediata per part del partner %s", partner_id)
                raise ValidationError(_("Ja hi ha un pressupost cancel·lat fa poc. Torna-ho a intentar en uns minuts."))

        if not vals.get('expiration_datetime'):
            expiration_dt = datetime.now() + timedelta(minutes=self._EXPIRATION_MINUTES)
            vals['expiration_datetime'] = fields.Datetime.to_string(expiration_dt)

        return super().create(vals)

    def write(self, vals):
        for order in self:
            if 'validity_date' in vals and 'expiration_datetime' not in vals:
                expiration_dt = datetime.now() + timedelta(minutes=self._EXPIRATION_MINUTES)
                vals['expiration_datetime'] = fields.Datetime.to_string(expiration_dt)
        return super().write(vals)

    @api.constrains('validity_date')
    def _set_expiration_on_validity_date(self):
        for order in self:
            if not order.expiration_datetime:
                expiration_dt = datetime.now() + timedelta(minutes=self._EXPIRATION_MINUTES)
                order.expiration_datetime = expiration_dt

    @api.onchange('validity_date')
    def _onchange_validity_date_expiration(self):
        for order in self:
            if order.validity_date:
                expiration_dt = datetime.now() + timedelta(minutes=self._EXPIRATION_MINUTES)
                order.expiration_datetime = expiration_dt

    def set_expiration_datetime(self):
        for order in self:
            if not order.expiration_datetime:
                expiration_dt = datetime.now() + timedelta(minutes=self._EXPIRATION_MINUTES)
                order.expiration_datetime = expiration_dt

    @api.model
    def cron_expire_unpaid_orders(self):
        """Cancel·la pressupostos caducats que no estan pagats ni confirmats, i elimina registres associats."""
        now_utc = datetime.now(timezone.utc).replace(tzinfo=None)

        expired_orders = self.search([
            ('state', 'in', ['draft', 'sent']),
            ('expiration_datetime', '<=', now_utc),
            ('payment_in_progress', '=', False),
            ('signature', '=', False)

        ])

        if not expired_orders:
            _logger.info("✅ No s'han trobat pressupostos caducats.")
            return

        _logger.info(f"🔄 S'han trobat {len(expired_orders)} pressupostos caducats.")

        for order in expired_orders:
            is_paid = self.env['account.payment'].sudo().search_count([
                ('ref', '=', order.name),
                ('state', '=', 'posted')
            ]) > 0

            if is_paid:
                _logger.info(f"⏭️ Ometent {order.name} perquè ja té un pagament realitzat.")
                continue

            try:
                registrations = self.env['event.registration'].sudo().search([
                    ('sale_order_id', '=', order.id)
                ])
                if registrations:
                    _logger.info(f"🗑️ Eliminant {len(registrations)} registres d'assistents per {order.name}")
                    registrations.unlink()

                order.message_post(body="⚠️ Pressupost cancel·lat automàticament per inactivitat.")
                order.with_context(force_cancel=True, cron_expiring=True).action_cancel()

                if order.state != 'cancel':
                    order.write({'state': 'cancel'})
                    _logger.info(f"🛑 Pressupost {order.name} forçat a cancel·lat.")

                _logger.info(f"🔍 Estat després de cancel·lar: {order.state}")

            except Exception as e:
                _logger.error(f"❌ Error al processar {order.name}: {str(e)}")

    def action_reject_quotation(self):
        """
        Permite al cliente rechazar un presupuesto desde el portal. Cancela el presupuesto y
        elimina los registros de asistentes asociados.
        """
        for order in self:
            _logger.info(f"Intentando rechazar el presupuesto {order.id} en estado {order.state}.")

            if order.state == 'sent':
                cancel_context = self.env.context.copy()
                cancel_context['disable_cancel_warning'] = True

                order.with_context(cancel_context).action_cancel()
                _logger.info(f"Presupuesto {order.id} cancelado exitosamente.")

                registrations = self.env['event.registration'].sudo().search([
                    ('sale_order_id', '=', order.id)
                ])
                if registrations:
                    _logger.info(f"Eliminando {len(registrations)} registros de asistentes asociados a la orden {order.id}.")
                    registrations.unlink()
                else:
                    _logger.info("No se encontraron registros de asistentes para eliminar.")
            else:
                _logger.warning(f"No se pudo cancelar el presupuesto {order.id} porque no está en estado 'sent'. Estado actual: {order.state}")
                raise UserError(_("Solo los presupuestos en estado 'Enviado' pueden ser rechazados."))

        return True
