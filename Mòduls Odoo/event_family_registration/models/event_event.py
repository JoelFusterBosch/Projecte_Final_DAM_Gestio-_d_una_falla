from odoo import models, fields, api
from odoo.exceptions import ValidationError
from datetime import datetime, timedelta, timezone

from typing import Dict
import logging
_logger = logging.getLogger(__name__)


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

    # def _find_or_create_sale_order(self, partner, ticket_quantities: Dict[int, int], order_id: int=None) -> 'sale.order':
    #     SaleOrder = self.env['sale.order'].sudo()

    #     sale_order = False

    #     if order_id:
    #         candidate = SaleOrder.browse(order_id)
    #         if candidate.exists() and candidate.partner_id.id == partner.id and candidate.event_id.id == self.id:
    #             sale_order = candidate
    #             _logger.info(f"[MV-DEBUG] Reutilitzant la comanda passada {sale_order.name} (ID {order_id}).")
    #         else:
    #             _logger.warning(f"[MV-DEBUG] L'order_id rebut ({order_id}) no és vàlid per a aquest partner/event.")

    #     if not sale_order:
    #         sale_order = SaleOrder.search([
    #             ('partner_id', '=', partner.id),
    #             ('state', 'in', ['draft', 'sent', 'sale', 'done']),
    #             ('event_id', '=', self.id)
    #         ], limit=1)
    #         if sale_order:
    #             _logger.info(f"[MV-DEBUG] Reutilitzant la comanda {sale_order.name} trobada automàticament.")

    #     if sale_order:
    #         if sale_order.state in ['sent', 'sale', 'done']:
    #             _logger.info(f"[MV-DEBUG] Tornant {sale_order.name} a 'draft' per poder reutilitzar.")
    #             sale_order.sudo().action_draft()

    #         # 🧹 Eliminar línies antigues (o posar quantitat a 0 si està confirmada)
    #         lines_to_remove = sale_order.order_line.filtered(lambda l: l.event_id == self)
    #         for line in lines_to_remove:
    #             if line.order_id.state in ['sale', 'done']:
    #                 _logger.info(f"[MV-DEBUG] No podem esborrar línia {line.id}, posant quantitat 0 perquè la comanda està en estat '{line.order_id.state}'.")
    #                 line.sudo().write({'product_uom_qty': 0})
    #             else:
    #                 _logger.info(f"[MV-DEBUG] Eliminant línia {line.id} de comanda {line.order_id.name}.")
    #                 line.sudo().unlink()
    #     else:
    #         _logger.info("[MV-DEBUG] Creant nova comanda perquè no n'hi ha cap existent o s'ha cancel·lat.")
    #         expiration = (datetime.now(timezone.utc) + timedelta(minutes=2)).replace(tzinfo=None)
    #         sale_order = SaleOrder.create({
    #             'partner_id': partner.id,
    #             'order_line': [],
    #             'state': 'draft',
    #             'expiration_datetime': expiration,
    #             'event_id': self.id,
    #         })

    #     # El codi per afegir línies de tickets seguiria a partir d'ací...   


    # ### Vol

    #     # sale_order = self.env['sale.order'].sudo().search([
    #     #     ('partner_id', '=', partner.id),
    #     #     ('state', 'in', ['draft', 'sent', 'sale', 'done']),
    #     #     ('event_id', '=', self.id)
    #     # ], limit=1)

    #     if sale_order:
    #         _logger.info(f"[MV-DEBUG] Reutilitzant la comanda {sale_order.name} encara que estiga en estat '{sale_order.state}'.")
    #         if sale_order.state in ['sent', 'sale', 'done']:
    #             _logger.info(f"[MV-DEBUG] Tornant {sale_order.name} a 'draft' per poder reutilitzar.")
    #             sale_order.sudo().action_draft()

    #         # 🧹 Eliminar línies antigues (o posar quantitat a 0 si està confirmada)
    #         lines_to_remove = sale_order.order_line.filtered(lambda l: l.event_id == self)
    #         for line in lines_to_remove:
    #             if line.order_id.state in ['sale', 'done']:
    #                 _logger.info(f"[MV-DEBUG] No podem esborrar línia {line.id}, posant quantitat 0 perquè la comanda està en estat '{line.order_id.state}'.")
    #                 line.sudo().write({'product_uom_qty': 0})
    #             else:
    #                 _logger.info(f"[MV-DEBUG] Eliminant línia {line.id} de comanda {line.order_id.name}.")
    #                 line.sudo().unlink()
    #     else:
    #         _logger.info("[MV-DEBUG] Creant nova comanda perquè no n'hi ha cap existent o s'ha cancel·lat.")
    #         expiration = (datetime.now(timezone.utc) + timedelta(minutes=2)).replace(tzinfo=None)
    #         sale_order = self.env['sale.order'].sudo().create({
    #             'partner_id': partner.id,
    #             'order_line': [],
    #             'state': 'draft',
    #             'expiration_datetime': expiration,
    #             'event_id': self.id,
    #         })

    #     # 🧹 Eliminar inscripcions anteriors amb altres tiquets del mateix esdeveniment
    #     old_regs = self.env['event.registration'].sudo().search([
    #         ('partner_id', '=', partner.id),
    #         ('event_id', '=', self.id),
    #         ('ticket_id', 'not in', list(ticket_quantities.keys())),
    #     ])

    #     for reg in old_regs:
    #         if reg.sale_order_id:
    #             old_order = reg.sale_order_id
    #             _logger.info(f"[MV-DEBUG] Cancel·lant inscripció antiga: ticket_id={reg.ticket_id.id} (comanda {old_order.name})")

    #             if old_order.state in ['draft', 'sent']:
    #                 old_order.sudo().action_cancel()
    #                 old_order.sudo().unlink()
    #             elif old_order.state in ['sale']:
    #                 _logger.warning(f"[MV-DEBUG] La comanda {old_order.name} ja està venuda. No podem cancel·lar, però desvinculem la inscripció.")

    #         reg.sudo().unlink()

    #     # ➡️ Crear o afegir les noves línies per als tickets actuals
    #     for ticket_id, qty in ticket_quantities.items():
    #         ticket = self.env['event.event.ticket'].sudo().browse(ticket_id)

    #         if not ticket.product_id:
    #             product = self.env['product.product'].sudo().create({
    #                 'name': f"Ticket {ticket.name} per a {self.name}",
    #                 'type': 'service',
    #                 'list_price': ticket.price,
    #                 'sale_ok': True,
    #             })
    #             ticket.product_id = product.id
    #         else:
    #             product = ticket.product_id

    #         sale_order.sudo().write({
    #             'order_line': [(0, 0, {
    #                 'product_id': product.id,
    #                 'product_uom_qty': qty,
    #                 'price_unit': ticket.price,
    #                 'name': product.name,
    #                 'event_id': self.id,
    #             })]
    #         })

    #     if sale_order.order_line:
    #         _logger.info(f"[MV-DEBUG] Comanda {sale_order.name} té {len(sale_order.order_line)} línies.")
    #         sale_order.sudo().action_quotation_send()
    #         sale_order.state = 'sent'
    #     else:
    #         _logger.info(f"[MV-DEBUG] Comanda {sale_order.name} sense línies: cancel·lant...")
    #         sale_order.sudo().action_cancel()
    #         sale_order.unlink()
    #         sale_order = False

    #     return sale_order

    def _find_or_create_sale_order(self, partner, ticket_quantities: Dict[int, int], order_id: int=None) -> 'sale.order':
        SaleOrder = self.env['sale.order'].sudo()
        
        sale_order = None

        # 1. Primer, si ve order_id, intentar reusar-lo
        if order_id:
            candidate = SaleOrder.browse(order_id)
            if candidate.exists() and candidate.partner_id.id == partner.id and candidate.event_id.id == self.id:
                sale_order = candidate
                _logger.info(f"[MV-DEBUG] Reutilitzant comanda passada {sale_order.name} (ID {order_id}).")
            else:
                _logger.warning(f"[MV-DEBUG] order_id rebut ({order_id}) no vàlid per aquest partner/event.")

        # 2. Si no hi ha sale_order, buscar-ne una existent
        if not sale_order:
            sale_order = SaleOrder.search([
                ('partner_id', '=', partner.id),
                ('event_id', '=', self.id),
                ('state', 'in', ['draft', 'sent', 'sale', 'done']),
            ], limit=1)
            if sale_order:
                _logger.info(f"[MV-DEBUG] Reutilitzant comanda existent {sale_order.name}.")

        
        # 🔁 Cancel·lem i eliminem comandes anteriors EXCEPTE la que volem reutilitzar
        old_orders = self.env['sale.order'].sudo().search([
            ('partner_id', '=', partner.id),
            ('event_id', '=', self.id),
            ('state', 'in', ['draft', 'sent']),
        ])
        for old in old_orders:
            # Si és la comanda que volem reutilitzar, la deixem estar
            if sale_order and old.id == sale_order.id:
                _logger.info(f"[MV-DEBUG] Conservant la comanda actual: {old.name}")
                continue

            _logger.info(f"[MV-DEBUG] Revisant i eliminant comanda antiga: {old.name}")

            # Eliminem inscripcions vinculades
            registrations = self.env['event.registration'].sudo().search([
                ('sale_order_id', '=', old.id),
            ])
            for reg in registrations:
                if reg.state != 'cancel':
                    _logger.info(f"[MV-DEBUG] Cancel·lant inscripció {reg.id} vinculada a {old.name}")
                    reg.sudo().write({'state': 'cancel'})
                reg.sudo().unlink()

            # Cancel·lem i eliminem la comanda
            old.sudo().action_cancel()
            old.sudo().unlink()

 
        
        # 3. Si encara no hi ha res, crear una nova
        if not sale_order:
            _logger.info("[MV-DEBUG] Creant nova comanda perquè no n'hi ha cap.")
            expiration = (datetime.now(timezone.utc) + timedelta(minutes=2)).replace(tzinfo=None)
            sale_order = SaleOrder.create({
                'partner_id': partner.id,
                'order_line': [],
                'state': 'draft',
                'expiration_datetime': expiration,
                'event_id': self.id,
            })

        # 🔵 Ara ja tens una comanda vàlida

        # 🧹 Netegem línies antigues (o posem quantitat 0 si ja està venuda)
        lines_to_remove = sale_order.order_line.filtered(lambda l: l.event_id == self)
        for line in lines_to_remove:
            if sale_order.state in ['sale', 'done']:
                line.sudo().write({'product_uom_qty': 0})
            else:
                line.sudo().unlink()

        # ➡️ Afegir noves línies de tiquets
        for ticket_id, qty in ticket_quantities.items():
            ticket = self.env['event.event.ticket'].sudo().browse(ticket_id)

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

            sale_order.sudo().write({
                'order_line': [(0, 0, {
                    'product_id': product.id,
                    'product_uom_qty': qty,
                    'price_unit': ticket.price,
                    'name': product.name,
                    'event_id': self.id,
                })]
            })

        # Si té línies, enviar pressupost
        if sale_order.order_line:
            if sale_order.state == 'draft':
                sale_order.sudo().action_quotation_send()
                sale_order.state = 'sent'
        else:
            _logger.info(f"[MV-DEBUG] Comanda {sale_order.name} sense línies: cancel·lant...")
            sale_order.sudo().action_cancel()
            sale_order.unlink()
            sale_order = False

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


    def register_family(self, partner_id: int, event_id: int, ticket_quantities: Dict[int, int], use_saldo: bool=False, order_id: int=None) -> int:

        partner = self.env['res.partner'].sudo().browse(partner_id)
        event = self.browse(event_id)

        self._validate_family_tickets(partner, ticket_quantities)
        total_tickets = sum(ticket_quantities.values())
        self._calculate_total_amount_due(total_tickets)

        sale_order = self._find_or_create_sale_order(partner, ticket_quantities, order_id=order_id)


        _logger.info(f"[MV-DEBUG] Partner ID: {partner_id}, Event ID: {event_id}")
        _logger.info(f"[MV-DEBUG] Tiquets rebuts: {ticket_quantities}")

        for ticket_id, qty in ticket_quantities.items():
            _logger.info(f"[MV-DEBUG] Gestionant ticket_id={ticket_id}, qty={qty}")

            self.env['event.registration'].sudo().add_or_update_registration(
                partner_id=partner.id,
                event_id=event.id,
                ticket_id=ticket_id,
                ticket_qty=qty,
                sale_order_id=sale_order.id
            )

        if sale_order and sale_order.state == 'draft':
            sale_order.sudo().action_quotation_send()
            sale_order.state = 'sent'
        elif sale_order and sale_order.state == 'sale':
            _logger.info(f"[MV-DEBUG] La comanda {sale_order.name} ja està confirmada, no es torna a enviar ni es canvia l'estat.")


        return sale_order.id
