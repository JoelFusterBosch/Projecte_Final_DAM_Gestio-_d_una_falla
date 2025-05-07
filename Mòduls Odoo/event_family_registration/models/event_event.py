# from odoo import models, fields, api
# from odoo.exceptions import ValidationError
# from datetime import datetime, timedelta, timezone

# from typing import Tuple, Dict

# class EventEvent(models.Model):
#     _inherit = 'event.event'

#     product_id = fields.Many2one(
#         'product.product',
#         string="Producto Asociado",
#         help="El producto que representa este evento o tickets de este evento."
#     )

#     event_cost = fields.Float(
#         string="Coste del Evento",
#         help="Este campo representa el coste del evento por ticket.",
#         default=0.0
#     )

#     ticket_ids = fields.One2many(
#         'event.event.ticket', 'event_id', string="Tickets"
#     )

#     button_state = fields.Selection([
#         ('enabled', 'Enabled'),
#         ('disabled', 'Disabled')
#     ], string="Button State", compute="_get_custom_button_state")

#     allow_family_registration = fields.Boolean(string="Permitir Registro Familiar")

    

#     def _get_custom_button_state(self):
#         for event in self:
#             if event.allow_family_registration and event.state != 'done':
#                 event.button_state = 'enabled'
#             else:
#                 event.button_state = 'disabled'

#     def _calculate_total_amount_due(self, total_tickets_selected: int) -> float:
#         return self.event_cost * total_tickets_selected

#     def _find_or_create_sale_order(self, partner, ticket_quantities: Dict[int, int]) -> 'sale.order':
#         """
#         Encuentra una orden de venta en estado 'draft' o 'sent' para el partner, relacionada con el evento,
#         o crea una nueva si no existe.
#         """
#         # Buscar si ya existe una orden de venta para el partner en estado 'draft' o 'sent', vinculada a este evento
#         sale_order = self.env['sale.order'].sudo().search([
#             ('partner_id', '=', partner.id),
#             ('state', 'in', ['draft', 'sent']),  # Estado 'draft' o 'sent'
#             ('order_line.event_id', '=', self.id)  # Filtrar por el evento actual
#         ], limit=1)

#         if not sale_order:
#             # Si no existe, crear una nueva orden de venta
#             sale_order = self.env['sale.order'].sudo().create({
#                 'partner_id': partner.id,
#                 'order_line': [],  # Inicialmente sin líneas, se añadirán después
#                 'state': 'draft',  # Inicialmente en borrador
#             })

#         # Validar límit global seats_max per cada tiquet
#         for ticket_id, qty in ticket_quantities.items():
#             ticket = self.env['event.event.ticket'].sudo().browse(ticket_id)
#             total_reserved = sum(ticket.registration_ids.mapped('ticket_qty'))

#             if ticket.seats_max and total_reserved + qty > ticket.seats_max:
#                 available = ticket.seats_max - total_reserved
#                 if available <= 0:
#                     raise ValidationError(
#                         f"No queden places disponibles per al tiquet '{ticket.name}'. El límit màxim de {ticket.seats_max} ja s'ha assolit."
#                     )
#                 raise ValidationError(
#                     f"Només queden {available} places per al tiquet '{ticket.name}', però estàs intentant registrar {qty}. El màxim permés és {ticket.seats_max}."
#                 )


#         # Actualizar o agregar las líneas de productos para los tickets seleccionados
#         for ticket_id, qty in ticket_quantities.items():
#             ticket = self.env['event.event.ticket'].sudo().browse(ticket_id)
#             if not ticket.product_id:
#                 # Crear un producto asociado al ticket si no existe
#                 product_name = f"Ticket {ticket.name} para {self.name}"
#                 product = self.env['product.product'].sudo().create({
#                     'name': product_name,
#                     'type': 'service',
#                     'list_price': ticket.price,
#                     'sale_ok': True,
#                 })
#                 ticket.product_id = product.id
#             else:
#                 product = ticket.product_id

#             # Buscar si ya existe una línea de pedido para este producto y evento en el presupuesto
#             existing_order_line = sale_order.order_line.filtered(lambda line: line.product_id == product and line.event_id == self)

#             if existing_order_line:
#                 # Si ya existe una línea para este producto, actualizar la cantidad
#                 existing_order_line.sudo().write({
#                     'product_uom_qty': existing_order_line.product_uom_qty + qty
#                 })
#             else:
#                 # Si no existe, agregar una nueva línea de pedido
#                 sale_order.sudo().write({
#                     'order_line': [(0, 0, {
#                         'product_id': product.id,
#                         'product_uom_qty': qty,
#                         'price_unit': ticket.price,
#                         'name': product.name,
#                         'event_id': self.id  # Vincular la línea de pedido con el evento actual
#                     })]
#                 })

#         # Cambiar el estado a 'sent' (enviado) si está en borrador
#         if sale_order.state == 'draft':
#             sale_order.sudo().action_quotation_send()

#         return sale_order

#     def _validate_family_tickets(self, partner, ticket_quantities: Dict[int, int]) -> None:
#         EventTicket = self.env['event.event.ticket'].sudo()

#         # Filtra només els tiquets amb max_faller=True
#         max_faller_ticket_ids = [
#             ticket_id for ticket_id in ticket_quantities
#             if EventTicket.browse(ticket_id).max_faller
#         ]

#         if not max_faller_ticket_ids:
#             # Si no hi ha cap tiquet amb max_faller, no cal fer cap validació familiar
#             return

#         # Validació: ha de ser membre d'una família
#         miembro_familia = self.env['familia.miembro'].sudo().search([
#             ('partner_id', '=', partner.id)
#         ], limit=1)

#         if not miembro_familia:
#             raise ValidationError("No puedes seleccionar tiquets con restricción de familia ('Máximo Fallers') ya que no perteneces a una familia.")

#         # Comptar membres familiars
#         family_member_count = len(miembro_familia.familia_id.miembros_ids)

#         # Comptar ja registrats amb max_faller
#         registered_tickets = self.env['event.registration'].sudo().search([
#             ('partner_id', '=', partner.id),
#             ('event_id', '=', self.id),
#             ('ticket_id.max_faller', '=', True)
#         ])
#         total_registered_tickets = sum(reg.ticket_qty for reg in registered_tickets)

#         # Comptar els nous seleccionats amb max_faller
#         total_new_tickets_selected = sum(
#             qty for ticket_id, qty in ticket_quantities.items()
#             if EventTicket.browse(ticket_id).max_faller
#         )

#         if total_registered_tickets + total_new_tickets_selected > family_member_count:
#             raise ValidationError(
#                 f"No pots seleccionar més de {family_member_count} tiquets amb la restricció de 'Membre de la Falla'. "
#                 f"Com a membre de la teua falla, el nombre màxim de tiquets ha de coincidir amb els membres registrats de la família. "
#                 f"Ja tens {total_registered_tickets} registrats i estàs intentant afegir {total_new_tickets_selected} més."
#             )



#     def register_family(self, partner_id: int, event_id: int, ticket_quantities: Dict[int, int], use_saldo: bool=False) -> int:
#         partner = self.env['res.partner'].sudo().browse(partner_id)
#         event = self.browse(event_id)

#         self._validate_family_tickets(partner, ticket_quantities)
#         total_tickets_selected = sum(ticket_quantities.values())
#         total_amount_due = self._calculate_total_amount_due(total_tickets_selected)
#         # Al crear la comanda
#         expiration = (datetime.now(timezone.utc) + timedelta(hours=0, minutes=2)).replace(tzinfo=None)
#         sale_order = self.env['sale.order'].sudo().create({
#             'partner_id': partner.id,
#             'order_line': [],
#             'state': 'draft',
#             'expiration_datetime': expiration,
#         })

#         # Buscar o crear una orden de venta (presupuesto) y actualizarla
#         sale_order = self._find_or_create_sale_order(partner, ticket_quantities)

#         sale_order_id = sale_order.id  # Obtener el ID de la orden de venta

#         for ticket_id, qty in ticket_quantities.items():
#             # Buscar si ya existe un registro para este partner y ticket
#             existing_registration = self.env['event.registration'].sudo().search([
#                 ('event_id', '=', event.id),
#                 ('partner_id', '=', partner.id),
#                 ('ticket_id', '=', ticket_id)
#             ], limit=1)

#             if existing_registration:
#                 # Si ya existe, actualizar la cantidad de tickets
#                 existing_registration.sudo().write({
#                     'ticket_qty': existing_registration.ticket_qty + qty
#                 })
#             else:
#                 # Si no existe, crear uno nuevo
#                 self.env['event.registration'].sudo().create({
#                     'event_id': event.id,
#                     'partner_id': partner.id,
#                     'ticket_id': ticket_id,
#                     'payment_status': 'pending',  # Estado inicial de pago pendiente
#                     'sale_order_id': sale_order.id,
#                     'ticket_qty': qty,
#                 })

#         # Cambiar el estado a 'sent' si no se ha enviado para permitir la firma
#         if sale_order.state == 'draft':
#             sale_order.sudo().action_quotation_send()

#         # Marcar el estado como enviado para permitir firmar o rechazar
#         sale_order.state = 'sent'

#         return sale_order_id  # Retornar el ID de la orden de venta


from odoo import models, fields, api
from odoo.exceptions import ValidationError
from datetime import datetime, timedelta, timezone

from typing import Dict

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
        sale_order = self.env['sale.order'].sudo().search([
            ('partner_id', '=', partner.id),
            ('state', 'in', ['draft', 'sent']),
            ('order_line.event_id', '=', self.id)
        ], limit=1)

        if not sale_order:
            expiration = (datetime.now(timezone.utc) + timedelta(minutes=2)).replace(tzinfo=None)
            sale_order = self.env['sale.order'].sudo().create({
                'partner_id': partner.id,
                'order_line': [],
                'state': 'draft',
                'expiration_datetime': expiration,
                'event_id': self.id,
            })
        elif not sale_order.expiration_datetime:
            sale_order.expiration_datetime = datetime.now(timezone.utc) + timedelta(minutes=2)

        for ticket_id, qty in ticket_quantities.items():
            ticket = self.env['event.event.ticket'].sudo().browse(ticket_id)
            total_reserved = sum(ticket.registration_ids.mapped('ticket_qty'))

            if ticket.seats_max and total_reserved + qty > ticket.seats_max:
                available = ticket.seats_max - total_reserved
                if available <= 0:
                    raise ValidationError(
                        f"No queden places disponibles per al tiquet '{ticket.name}'. El límit màxim de {ticket.seats_max} ja s'ha assolit."
                    )
                raise ValidationError(
                    f"Només queden {available} places per al tiquet '{ticket.name}', però estàs intentant registrar {qty}."
                )

            if not ticket.product_id:
                product = self.env['product.product'].sudo().create({
                    'name': f"Ticket {ticket.name} per a {self.name}",
                    'type': 'service',
                    'list_price': ticket.price,
                    'sale_ok': True,
                })
                ticket.product_id = product.id
            else:
                product = ticket.product_id

            existing_line = sale_order.order_line.filtered(lambda line: line.product_id == product and line.event_id == self)
            if existing_line:
                existing_line.sudo().write({
                    'product_uom_qty': existing_line.product_uom_qty + qty
                })
            else:
                sale_order.sudo().write({
                    'order_line': [(0, 0, {
                        'product_id': product.id,
                        'product_uom_qty': qty,
                        'price_unit': ticket.price,
                        'name': product.name,
                        'event_id': self.id
                    })]
                })

        if sale_order.state == 'draft':
            sale_order.sudo().action_quotation_send()

        return sale_order

    def _validate_family_tickets(self, partner, ticket_quantities: Dict[int, int]) -> None:
        EventTicket = self.env['event.event.ticket'].sudo()

        max_faller_ticket_ids = [
            ticket_id for ticket_id in ticket_quantities
            if EventTicket.browse(ticket_id).max_faller
        ]

        if not max_faller_ticket_ids:
            return

        miembro_familia = self.env['familia.miembro'].sudo().search([
            ('partner_id', '=', partner.id)
        ], limit=1)

        if not miembro_familia:
            raise ValidationError("No pots seleccionar tiquets amb restricció de família perquè no estàs associat a cap família.")

        family_member_count = len(miembro_familia.familia_id.miembros_ids)

        registered_tickets = self.env['event.registration'].sudo().search([
            ('partner_id', '=', partner.id),
            ('event_id', '=', self.id),
            ('ticket_id.max_faller', '=', True)
        ])
        total_registered = sum(reg.ticket_qty for reg in registered_tickets)
        total_new = sum(qty for ticket_id, qty in ticket_quantities.items()
                        if EventTicket.browse(ticket_id).max_faller)

        if total_registered + total_new > family_member_count:
            raise ValidationError(
                f"El nombre total de tiquets amb restricció familiar ({total_registered + total_new}) excedix els {family_member_count} membres de la teua família."
            )

    def register_family(self, partner_id: int, event_id: int, ticket_quantities: Dict[int, int], use_saldo: bool=False) -> int:
        partner = self.env['res.partner'].sudo().browse(partner_id)
        event = self.browse(event_id)

        self._validate_family_tickets(partner, ticket_quantities)
        total_tickets = sum(ticket_quantities.values())
        self._calculate_total_amount_due(total_tickets)

        sale_order = self._find_or_create_sale_order(partner, ticket_quantities)

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

        return sale_order.id
