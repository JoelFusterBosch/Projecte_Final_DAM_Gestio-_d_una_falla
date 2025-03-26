from odoo import models, fields, api
from odoo.exceptions import ValidationError
from typing import Tuple, Dict

class EventEvent(models.Model):
    _inherit = 'event.event'

    product_id = fields.Many2one(
        'product.product',
        string="Producto Asociado",
        help="El producto que representa este evento o tickets de este evento."
    )

    event_cost = fields.Float(
        string="Coste del Evento",
        help="Este campo representa el coste del evento por ticket.",
        default=0.0
    )

    ticket_ids = fields.One2many(
        'event.event.ticket', 'event_id', string="Tickets"
    )

    button_state = fields.Selection([
        ('enabled', 'Enabled'),
        ('disabled', 'Disabled')
    ], string="Button State", compute="_get_custom_button_state")

    allow_family_registration = fields.Boolean(string="Permitir Registro Familiar")

    def _get_custom_button_state(self):
        for event in self:
            if event.allow_family_registration and event.state != 'done':
                event.button_state = 'enabled'
            else:
                event.button_state = 'disabled'

    def _calculate_total_amount_due(self, total_tickets_selected: int) -> float:
        return self.event_cost * total_tickets_selected

    def _find_or_create_sale_order(self, partner, ticket_quantities: Dict[int, int]) -> 'sale.order':
        """
        Encuentra una orden de venta en estado 'draft' o 'sent' para el partner, o crea una nueva si no existe.
        Solo agrega tickets si el presupuesto no está firmado ni cancelado.
        """
        sale_order = self.env['sale.order'].sudo().search([
            ('partner_id', '=', partner.id),
            ('state', 'in', ['draft', 'sent']),
        ], limit=1)

        if not sale_order:
            sale_order = self.env['sale.order'].sudo().create({
                'partner_id': partner.id,
                'order_line': [],
                'state': 'draft',
            })

        for ticket_id, qty in ticket_quantities.items():
            ticket = self.env['event.event.ticket'].sudo().browse(ticket_id)
            if not ticket.product_id:
                product_name = f"Ticket {ticket.name} para {self.name}"
                product = self.env['product.product'].sudo().create({
                    'name': product_name,
                    'type': 'service',
                    'list_price': ticket.price,
                    'sale_ok': True,
                })
                ticket.product_id = product.id
            else:
                product = ticket.product_id

            existing_order_line = sale_order.order_line.filtered(lambda line: line.product_id == product)

            if existing_order_line:
                existing_order_line.sudo().write({
                    'product_uom_qty': existing_order_line.product_uom_qty + qty
                })
            else:
                sale_order.sudo().write({
                    'order_line': [(0, 0, {
                        'product_id': product.id,
                        'product_uom_qty': qty,
                        'price_unit': ticket.price,
                        'name': product.name,
                    })]
                })

        if sale_order.state == 'draft':
            sale_order.sudo().action_quotation_send()

        return sale_order

    def _validate_family_tickets(self, partner, ticket_quantities: Dict[int, int]) -> None:
        miembro_familia = self.env['familia.miembro'].sudo().search([('partner_id', '=', partner.id)], limit=1)
        if not miembro_familia:
            raise ValidationError("No puedes seleccionar tiquets con restricción de familia ('Máximo Fallers') ya que no perteneces a una familia.")

        family_member_count = len(miembro_familia.familia_id.miembros_ids)

        registered_tickets = self.env['event.registration'].sudo().search([
            ('partner_id', '=', partner.id),
            ('event_id', '=', self.id),
            ('ticket_id.max_faller', '=', True),
            ('state', '!=', 'cancelled')  # Excluir los tickets cancelados
        ])
        total_registered_tickets = sum(registration.ticket_qty for registration in registered_tickets)

        total_new_tickets_selected = sum(qty for ticket_id, qty in ticket_quantities.items() if self.env['event.event.ticket'].browse(ticket_id).max_faller)
        
        if total_registered_tickets + total_new_tickets_selected > family_member_count:
            raise ValidationError(f"No puedes seleccionar más de {family_member_count} tickets con la restricción de 'Máximo Fallers'. Ya tienes {total_registered_tickets} registrados.")

    def register_family(self, partner_id: int, event_id: int, ticket_quantities: Dict[int, int], use_saldo: bool=False) -> int:
        partner = self.env['res.partner'].sudo().browse(partner_id)
        event = self.browse(event_id)

        self._validate_family_tickets(partner, ticket_quantities)
        total_tickets_selected = sum(ticket_quantities.values())
        total_amount_due = self._calculate_total_amount_due(total_tickets_selected)

        sale_order = self._find_or_create_sale_order(partner, ticket_quantities)

        sale_order_id = sale_order.id

        for ticket_id, qty in ticket_quantities.items():
            existing_registration = self.env['event.registration'].sudo().search([
                ('event_id', '=', event.id),
                ('partner_id', '=', partner.id),
                ('ticket_id', '=', ticket_id)
            ], limit=1)

            if existing_registration:
                existing_registration.sudo().write({
                    'ticket_qty': existing_registration.ticket_qty + qty
                })
            else:
                self.env['event.registration'].sudo().create({
                    'event_id': event.id,
                    'partner_id': partner.id,
                    'ticket_id': ticket_id,
                    'payment_status': 'pending',
                    'sale_order_id': sale_order.id,
                    'ticket_qty': qty,
                })

        if sale_order.state == 'draft':
            sale_order.sudo().action_quotation_send()

        sale_order.state = 'sent'

        return sale_order_id
