from odoo import models, fields, api

class EventRegistration(models.Model):
    _inherit = 'event.registration'

    ticket_qty = fields.Integer(string="Cantidad de Tickets", default=1)

    ticket_id = fields.Many2one(
        'event.event.ticket',
        string='Ticket del Evento',
        required=True,
        ondelete='cascade'
    )

    price_total = fields.Float(string="Precio Total", compute="_compute_price_total", store=True)

    payment_status = fields.Selection([
        ('paid', 'Pagado'),
        ('pending', 'Pendiente'),
    ], string='Estado de Pago', default='pending')

    sale_order_id = fields.Many2one('sale.order', string='Orden de Venta')

    state = fields.Selection([
        ('draft', 'Borrador'),
        ('confirmed', 'Confirmado'),
        ('done', 'Hecho'),
        ('cancelled', 'Cancelado')
    ], string='Estado', default='draft')

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
        """
        existing_registration = self.sudo().search([
            ('partner_id', '=', partner_id),
            ('event_id', '=', event_id),
            ('ticket_id', '=', ticket_id)
        ], limit=1)

        if existing_registration:
            existing_registration.sudo().write({
                'ticket_qty': existing_registration.ticket_qty + ticket_qty,
                'sale_order_id': sale_order_id or existing_registration.sale_order_id.id
            })
        else:
            self.sudo().create({
                'partner_id': partner_id,
                'event_id': event_id,
                'ticket_id': ticket_id,
                'ticket_qty': ticket_qty,
                'sale_order_id': sale_order_id,
                'payment_status': 'pending',
            })

        return True

   