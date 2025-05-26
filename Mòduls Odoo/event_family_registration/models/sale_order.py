from odoo import models, fields, api, _
from odoo.exceptions import UserError, ValidationError
from datetime import datetime, timedelta, timezone
import logging

_logger = logging.getLogger(__name__)

def calculate_default_ticket_deadline(event_date):
    """
    Calcula la data límit segons el tipus d'event:
    - Si és entre 16 i 19 de març: segon diumenge de febrer.
    - Si no: dos dies abans de l'event a les 23:59.
    """
    if event_date.month == 3 and 16 <= event_date.day <= 19:
        # Falles ➔ segon diumenge de febrer
        february = datetime(event_date.year, 2, 1)
        sundays = [february + timedelta(days=i) for i in range(28) if (february + timedelta(days=i)).weekday() == 6]
        if len(sundays) >= 2:
            return sundays[1].replace(hour=23, minute=59, second=0, microsecond=0)
        else:
            raise ValueError("No s'ha trobat el segon diumenge de febrer.")
    else:
        # Regla general ➔ dos dies abans del dia de l'event
        deadline = (event_date - timedelta(days=2)).replace(hour=23, minute=59, second=0, microsecond=0)
        return deadline


class SaleOrder(models.Model):
    _inherit = 'sale.order'

    payment_in_progress = fields.Boolean(
        string="Pagament en marxa",
        help="Es marca com a cert quan l'usuari ha iniciat el procés de pagament per evitar cancel·lacions automàtiques."
    )

    expiration_datetime = fields.Datetime(
        string="Expira el",
        help="Data i hora d'expiració automàtica del pressupost."
    )

    event_id = fields.Many2one('event.event', string='Esdeveniment')

    @api.model
    def create(self, vals):
        if self.env.context.get('cron_expiring'):
            _logger.warning("🚫 Intent de creació de pressupost durant el cron bloquejat.")
            raise ValidationError(_("No es pot crear un pressupost durant la cancel·lació automàtica."))

        partner_id = vals.get('partner_id')
        if partner_id:
            recent_cancelled = self.search_count([
                ('partner_id', '=', partner_id),
                ('state', '=', 'cancel'),
                ('create_date', '>=', fields.Datetime.to_string(datetime.now() - timedelta(minutes=2)))
            ])
            if recent_cancelled:
                _logger.warning("🚫 Intent de duplicació immediata per part del partner %s", partner_id)
                raise ValidationError(_("Ja hi ha un pressupost cancel·lat fa poc. Torna-ho a intentar en uns minuts."))

        # 🔥 Buscar dates de tiquets directament en vals['order_line']
        ticket_dates = []
        order_lines = vals.get('order_line', [])
        for command in order_lines:
            if isinstance(command, (list, tuple)) and len(command) > 2:
                data = command[2]
                if data.get('product_id'):
                    product = self.env['product.product'].browse(data['product_id'])
                    if hasattr(product, 'event_ticket_id') and product.event_ticket_id and product.event_ticket_id.date_end:
                        ticket_dates.append(product.event_ticket_id.date_end)

        if ticket_dates:
            min_date = min(ticket_dates)
            vals['validity_date'] = min_date
            vals['expiration_datetime'] = min_date
            _logger.info(f"🗓️ Assignant validity_date i expiration_datetime a {min_date} segons data de venda de tiquets.")
        elif vals.get('event_id'):
            event = self.env['event.event'].browse(vals['event_id'])
            if event.date_begin:
                min_date = calculate_default_ticket_deadline(event.date_begin)
                vals['validity_date'] = min_date
                vals['expiration_datetime'] = min_date
                _logger.info(f"🗓️ Assignant validity_date i expiration_datetime per regla especial segons data de l'event: {min_date}")
            else:
                _logger.warning(f"❗ Event {vals['event_id']} sense data d'inici definida.")
        else:
            _logger.warning(f"❗ No s'ha pogut assignar una data d'expiració.")

        order = super().create(vals)
        return order

    def write(self, vals):
        for order in self:
            if 'validity_date' in vals:
                vals['expiration_datetime'] = vals['validity_date']
        return super().write(vals)

    @api.onchange('validity_date')
    def _onchange_validity_date_expiration(self):
        for order in self:
            if order.validity_date:
                order.expiration_datetime = order.validity_date

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
        """Permet al client rebutjar un pressupost des del portal."""
        for order in self:
            _logger.info(f"Intentant rebutjar el pressupost {order.id} en estat {order.state}.")

            if order.state == 'sent':
                cancel_context = self.env.context.copy()
                cancel_context['disable_cancel_warning'] = True
                order.with_context(cancel_context).action_cancel()
                _logger.info(f"Presupost {order.id} cancel·lat exitosament.")

                registrations = self.env['event.registration'].sudo().search([
                    ('sale_order_id', '=', order.id)
                ])
                if registrations:
                    _logger.info(f"Eliminant {len(registrations)} registres d'assistents associats a la comanda {order.id}.")
                    registrations.unlink()
                else:
                    _logger.info("No s'han trobat registres d'assistents per eliminar.")
            else:
                _logger.warning(f"No s'ha pogut cancel·lar el pressupost {order.id} perquè no està en estat 'sent'. Estat actual: {order.state}")
                raise UserError(_("Només es poden rebutjar pressupostos en estat 'Enviat'."))

        return True

    def update_event_order_lines(self, ticket_lines):
        """Actualitza les línies de tiquets d'una comanda d'event."""
        self.ensure_one()

        tickets_map = {product.id: qty for product, qty in ticket_lines}

        for line in self.order_line:
            product_id = line.product_id.id
            if product_id in tickets_map:
                new_qty = tickets_map[product_id]
                line.sudo().write({'product_uom_qty': new_qty})
                tickets_map.pop(product_id)
            else:
                if self.state in ('sale', 'done'):
                    line.sudo().write({'product_uom_qty': 0})
                else:
                    line.sudo().unlink()

        for product_id, qty in tickets_map.items():
            if qty > 0:
                product = self.env['product.product'].sudo().browse(product_id)
                self.env['sale.order.line'].sudo().create({
                    'order_id': self.id,
                    'product_id': product.id,
                    'product_uom_qty': qty,
                    'price_unit': product.lst_price,
                    'name': product.name,
                })
