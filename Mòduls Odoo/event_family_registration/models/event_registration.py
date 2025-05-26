from odoo import models, fields, api

class EventRegistration(models.Model):
    _inherit = 'event.registration'

    ticket_qty = fields.Integer(string="Cantidad de Tickets", default=1)

    ticket_id = fields.Many2one(
        'event.event.ticket',
        string='Ticket del Evento',
        required=False,
        ondelete='cascade'
    )

    price_total = fields.Float(string="Precio Total", compute="_compute_price_total", store=True)

    payment_status = fields.Selection([
        ('paid', 'Pagado'),
        ('pending', 'Pendiente'),
    ], string='Estat del Pagament', default='pending')

    sale_order_id = fields.Many2one('sale.order', string='Orden de Venta')

    state = fields.Selection(selection_add=[
        ('draft', 'Borrador'),
        ('confirmed', 'Confirmado'),
        ('done', 'Hecho'),
        ('cancelled', 'Cancelado')
    ], string='Estado', default='draft')

    def action_cancel(self):
        for record in self:
            record.write({'state': 'cancelled'})


    @api.depends('ticket_qty', 'ticket_id.price')
    def _compute_price_total(self):
        for record in self:
            if record.ticket_id:
                record.price_total = record.ticket_qty * record.ticket_id.price
            else:
                record.price_total = 0.0


    @api.model
    def add_or_update_registration(self, partner_id, event_id, ticket_id, ticket_qty, sale_order_id=None):
        """
        Agrega o actualiza el registro de inscripción del asistente.
        Si se proporciona una 'sale_order_id', vincula el registro con esa orden de venta.
        Si la venta ya está pagada, genera un reembolso automático si baja la cantidad,
        y torna saldo a la família si aplica.
        També cancel·la altres registres antics del mateix esdeveniment amb altres tiquets.
        """
        order = self.env['sale.order'].sudo().browse(sale_order_id) if sale_order_id else None
        partner = self.env['res.partner'].sudo().browse(partner_id)

        # 🔁 Comprovar altres inscripcions del mateix esdeveniment i eliminar-les
        old_regs = self.sudo().search([
            ('partner_id', '=', partner_id),
            ('event_id', '=', event_id),
            ('ticket_id', '!=', ticket_id),
        ])
        for reg in old_regs:
            old_order = reg.sale_order_id
            if old_order and old_order.state in ['draft', 'sale', 'done']:
                refund_amount = reg.ticket_qty * reg.ticket_id.price
                familia_membre = self.env['familia.miembro'].search([('partner_id', '=', partner.id)], limit=1)
                familia = familia_membre.familia_id if familia_membre else None

                if refund_amount > 0 and familia:
                    familia.sudo().write({'saldo_total': familia.saldo_total + refund_amount})
                    familia.actualitzar_saldo_membres()
                    event = reg.event_id
                    event_name = event.name if event else 'esdeveniment desconegut'
                    familia.message_post(
                        body=f"S'ha retornat {refund_amount:.2f} € al saldo de la família per cancel·lació d'inscripció anterior a **{event_name}**."
                    )

                if old_order.state in ['draft', 'sale']:
                    old_order.action_cancel()

            reg.sudo().unlink()

        # 🔎 Buscar si existeix ja inscripció amb el mateix tiquet
        existing_registration = self.sudo().search([
            ('partner_id', '=', partner_id),
            ('event_id', '=', event_id),
            ('ticket_id', '=', ticket_id)
        ], limit=1)

        if existing_registration:
            old_qty = existing_registration.ticket_qty
            existing_registration.sudo().write({
                'ticket_qty': ticket_qty,
                'sale_order_id': sale_order_id or existing_registration.sale_order_id.id
            })

            # Si la venda està pagada i redueix la quantitat
            if order and order.state in ['draft', 'sale', 'done'] and ticket_qty < old_qty:
                price_unit = existing_registration.ticket_id.price
                diff_qty = old_qty - ticket_qty
                refund_amount = diff_qty * price_unit

                if refund_amount > 0:
                    familia_membre = self.env['familia.miembro'].search([('partner_id', '=', partner.id)], limit=1)
                    familia = familia_membre.familia_id if familia_membre else None

                    if familia:
                        familia.sudo().write({'saldo_total': familia.saldo_total + refund_amount})
                        familia.actualitzar_saldo_membres()
                        event = existing_registration.event_id
                        event_name = event.name if event else 'esdeveniment desconegut'
                        familia.message_post(
                            body=f"S'ha retornat {refund_amount:.2f} € al saldo familiar per reducció de tiquets a **{event_name}**."
                        )

                    if order.state in ['draft', 'sale']:
                        order.action_cancel()

                    refund_order = self.env['sale.order'].sudo().create({
                        'partner_id': partner.id,
                        'origin': order.name,
                        'order_line': [(0, 0, {
                            'product_id': existing_registration.ticket_id.product_id.id,
                            'product_uom_qty': diff_qty,
                            'price_unit': -price_unit,
                        })],
                        'note': 'Devolució automàtica per reducció de tiquets',
                    })
                    refund_order.action_confirm()

        else:
            # 🆕 Crear nova inscripció
            self.sudo().create({
                'partner_id': partner_id,
                'event_id': event_id,
                'ticket_id': ticket_id,
                'ticket_qty': ticket_qty,
                'sale_order_id': sale_order_id,
                'payment_status': 'pending',
            })

        return True


    # @api.model
    # def add_or_update_registration(self, partner_id, event_id, ticket_id, ticket_qty, sale_order_id=None):
    #     """
    #     Agrega o actualiza el registro de inscripción del asistente.
    #     Si se proporciona una 'sale_order_id', vincula el registro con esa orden de venta.
    #     """
    #     existing_registration = self.sudo().search([
    #         ('partner_id', '=', partner_id),
    #         ('event_id', '=', event_id),
    #         ('ticket_id', '=', ticket_id)
    #     ], limit=1)

    #     if existing_registration:
    #         existing_registration.sudo().write({
    #             'ticket_qty': existing_registration.ticket_qty + ticket_qty,
    #             'sale_order_id': sale_order_id or existing_registration.sale_order_id.id
    #         })
    #     else:
    #         self.sudo().create({
    #             'partner_id': partner_id,
    #             'event_id': event_id,
    #             'ticket_id': ticket_id,
    #             'ticket_qty': ticket_qty,
    #             'sale_order_id': sale_order_id,
    #             'payment_status': 'pending',
    #         })

    #     return True

   
