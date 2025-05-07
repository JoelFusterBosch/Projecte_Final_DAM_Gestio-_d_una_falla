from odoo import http
from odoo.http import request
import logging

_logger = logging.getLogger(__name__)

class QRScanController(http.Controller):

    @http.route('/qr_scan/<string:order_name>', type='http', auth="user")
    def process_qr_scan(self, order_name):
        user = request.env.user
        order = request.env['sale.order'].sudo().search([('name', '=', order_name)], limit=1)

        if not order:
            return request.render("payment_with_saldo.qr_not_found", {"order_name": order_name})

        # Comprovar si l'usuari té permisos per servir comandes
        if not user.has_group('payment_with_saldo.group_order_manager'):
            return request.redirect(f"/web#id={order.id}&model=sale.order&view_type=form")

        # Restar unitats servides fins a completar la comanda
        all_served = True
        for line in order.order_line:
            if line.qty_delivered < line.product_uom_qty:
                line.sudo().write({"qty_delivered": line.qty_delivered + 1})
                all_served = False
                break  # Només restem una unitat per cada escaneig

        if all_served:
            order.sudo().write({"state": "done"})  # Marquem la comanda com a servida

        return request.render("payment_with_saldo.qr_success", {"order": order})
