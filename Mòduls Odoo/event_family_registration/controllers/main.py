# -*- coding: utf-8 -*-
from odoo import http
from odoo.http import request
from odoo.exceptions import ValidationError
from datetime import datetime
import logging

_logger = logging.getLogger(__name__)

class EventRegistrationController(http.Controller):

    # @http.route('/event/<model("event.event"):event>/register', type='http', auth='public', website=True)
    # def redirect_register_event_form(self, event, **kwargs):
    #     """Redirigeix la ruta estàndard al nostre formulari personalitzat"""
    #     return request.redirect(f'/event/{event.id}/register_form')
    @http.route('/event/registration_status', type='json', auth='public')
    def registration_status(self, event_id=None, partner_id=None, **kwargs):
        if not event_id or not partner_id:
            return {}

        event = request.env['event.event'].sudo().browse(int(event_id))
        partner = request.env['res.partner'].sudo().browse(int(partner_id))

        order = request.env['sale.order'].sudo().search([
            ('partner_id', '=', partner.id),
            ('event_id', '=', event.id),
            ('state', 'in', ['draft', 'sent', 'sale', 'done']),
        ], limit=1)

        selected_ticket_quantities = {}
        order_id = None
        if order:
            order_id = order.id
            for line in order.order_line:
                ticket = request.env['event.event.ticket'].sudo().search([
                    ('product_id', '=', line.product_id.id),
                    ('event_id', '=', event.id),
                ], limit=1)
                if ticket:
                    selected_ticket_quantities[ticket.id] = line.product_uom_qty

        return {
            'ticket_quantities': selected_ticket_quantities,
            'order_id': order_id,  # 🆕 Retornem també l'order_id
        }

    # Ruta per a mostrar el ribbon en la FITXA d'un event (individual)
    @http.route('/event/ribbon_status', type='json', auth='public')
    def ribbon_status(self, event_id=None, **kwargs):
        if not event_id:
            return {}

        event = request.env['event.event'].sudo().browse(int(event_id))
        if not event.exists():
            return {}

        label = "Inscripció oberta" if event.date_begin and event.date_begin > datetime.now() else "Inscripció tancada"
        color = "success" if (hasattr(event, 'state') and event.state == 'draft') else "danger"

        return {
            'label': label,
            'color': color,
        }


    # Ruta per a mostrar el ribbon en el LLISTAT d'events
    @http.route('/event/registration_info', type='json', auth='public')
    def registration_info(self, event_id=None, partner_id=None, **kwargs):
        if not event_id:
            return {}

        # 🧠 Agafem el partner
        partner = request.env.user.partner_id

        # 🧠 Busquem la comanda associada a aquest partner i event
        order = request.env['sale.order'].sudo().search([
            ('partner_id', '=', partner.id),
            ('event_id', '=', int(event_id)),
            ('state', 'in', ['draft', 'sent', 'sale', 'done', 'cancel'])
        ], limit=1)

        if not order:
            return {
                'status': 'cap',
                'label': '',
                'color': '',
            }

        # 🧠 Mapegem l'estat
        status = order.state

        if status == 'draft':
            label = "Esborrany"
            color = "secondary"
        elif status == 'sent':
            label = "Pagament pendent"
            color = "warning"
        elif status == 'sale':
            label = "Registrat"
            color = "success"
        elif status == 'done':
            label = "Pagat"
            color = "success"
        elif status == 'cancel':
            label = "Cancel·lat"
            color = "danger"
        else:
            label = ""
            color = ""

        return {
            'status': status,
            'label': label,
            'color': color,
        }

    @http.route('/event/<model("event.event"):event>/register', type='json', auth='public', methods=['POST'], csrf=True)
    def register_event(self, event, partner_id=None, ticket_quantities=None, csrf_token=None, order_id=None):
        # Validar el token CSRF
        if not request.validate_csrf(csrf_token):
            return {'status': 'error', 'message': 'Token CSRF inválido o ausente.'}
        else:
            print("Token CSRF válido.")

        # Validar que existan los parámetros necesarios
        if not partner_id or not ticket_quantities:
            return {
                'status': 'error',
                'message': 'Faltan parámetros requeridos',
            }

        try:
            # Convertir IDs a enteros para asegurar consistencia
            partner_id = int(partner_id)
            ticket_quantities = {int(ticket_id): int(quantity) for ticket_id, quantity in ticket_quantities.items()}

            # Obtener el partner y asegurarse que existe
            partner = request.env['res.partner'].sudo().browse(partner_id)

            if not partner.exists():
                return {
                    'status': 'error',
                    'message': 'Partner no encontrado.',
                }

            # Registrar tickets respetando las restricciones de familia
            # order = request.env['sale.order'].sudo().search([
            #     ('partner_id', '=', partner_id),
            #     ('event_id', '=', event.id),
            #     ('state', 'in', ['draft', 'sent', 'sale', 'done']),
            # ], limit=1)

            sale_order_id = event.register_family(
                partner_id,
                event.id,
                ticket_quantities,
                order_id=order_id
            )


            return {
                'status': 'success',
                'message': 'Registro completado correctamente.',
                'sale_order_id': sale_order_id  # Enviar el ID del presupuesto al frontend
            }

        except ValidationError as e:
            return {
                'status': 'error',
                'message': str(e),
            }

        except Exception as e:
            print(f'Error inesperado: {str(e)}')
            return {
                'status': 'error',
                'message': 'Ha ocurrido un error inesperado: ' + str(e),
            }

    @http.route(['/my/orders/<int:order_id>/decline'], type='http', auth="user", website=True)
    def decline_order(self, order_id, **kwargs):
        """
        Controlador para rechazar un presupuesto desde el portal del cliente.
        """
        order = request.env['sale.order'].sudo().browse(order_id)
        if order:
            _logger.info(f"El cliente {request.env.user.partner_id.id} está rechazando el presupuesto {order_id}.")
            order.action_reject_quotation()
            _logger.info(f"Presupuesto {order_id} rechazado correctamente.")
        else:
            _logger.warning(f"No se pudo encontrar el presupuesto {order_id} para rechazar.")
        
        # Redirigir al cliente de vuelta a la página de pedidos
        return request.redirect('/my/orders')


    @http.route('/event/<int:event_id>/max_faller_limits', type='json', auth='public')
    def get_max_faller_limits(self, event_id, partner_id):
        event = request.env['event.event'].sudo().browse(event_id)
        partner = request.env['res.partner'].sudo().browse(partner_id)

        miembro_familia = request.env['familia.miembro'].sudo().search([
            ('partner_id', '=', partner.id)
        ], limit=1)

        if not miembro_familia:
            return {}  # No hi ha límit si no és membre de família

        family_member_count = len(miembro_familia.familia_id.miembros_ids)

        limits = {}
        for ticket in event.ticket_ids:
            if ticket.max_faller:
                limits[ticket.id] = family_member_count
        return limits


    @http.route('/event/<model("event.event"):event>/register_form', type='http', auth='public', website=True)
    def register_event_form(self, event, **kwargs):
        partner = request.env.user.partner_id

        order = request.env['sale.order'].sudo().search([
            ('partner_id', '=', partner.id),
            ('event_id', '=', event.id),
            ('state', 'in', ['draft', 'sent', 'sale', 'done']),
        ], limit=1)

        selected_ticket_quantities = {}
        if order:
            for line in order.order_line:
                ticket = request.env['event.event.ticket'].sudo().search([
                    ('product_id', '=', line.product_id.id),
                    ('event_id', '=', event.id),
                ], limit=1)
                if ticket:
                    selected_ticket_quantities[ticket.id] = line.product_uom_qty

        _logger.info(f"✅ Quantitats de tiquets per a l'usuari {request.env.user.partner_id.name}: {selected_ticket_quantities}")

        return request.render('event_family_registration.custom_family_registration_form', {
            'event': event,
            'order': order,
            'selected_ticket_quantities': selected_ticket_quantities or {},
        })
