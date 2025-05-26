from odoo import http
from odoo.http import request

class SalePortalAcceptOverride(http.Controller):

    @http.route(['/my/orders/<int:order_id>/accept'], type='http', auth='public', website=True)
    def override_accept_order(self, order_id, **post):
        order = request.env['sale.order'].sudo().browse(order_id)
        if not order.exists():
            return request.not_found()

        # Si ja està en estat 'sent' i té registres, no fer res més
        registrations = request.env['event.registration'].sudo().search([
            ('sale_order_id', '=', order.id),
        ])
        if registrations:
            return request.redirect(f'/shop/payment/validate?order_id={order_id}')

        # Si no té registres, millor mostrar un error
        return request.render('website.404')  # o un missatge més elegant
