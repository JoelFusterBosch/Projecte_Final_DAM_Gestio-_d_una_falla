from odoo import http
from odoo.http import request

class SaleOrderPaymentStatusController(http.Controller):

   @http.route('/sale/payment/start', type='json', auth='public', csrf=False)
   def mark_payment_in_progress(self, order_id):
        order = request.env['sale.order'].sudo().browse(int(order_id))
        if order.exists() and order.state in ['draft', 'sent'] and not order.payment_in_progress:
            order.write({'payment_in_progress': True})
            return {'status': 'ok'}
        return {'status': 'error', 'message': 'Order not found or already in progress or invalid state'}

