from odoo import http
from odoo.http import request, Response
import logging
import json

_logger = logging.getLogger(__name__)

class SalePortalExtend(http.Controller):

    @http.route(['/my/orders/<int:order_id>/transaction'], type='http', auth='public', website=True, csrf=False)
    def portal_order_transaction(self, order_id, **kwargs):
        try:
            order = request.env['sale.order'].sudo().browse(order_id)
            if not order.exists():
                _logger.error(f"[SALDO] Comanda amb ID {order_id} no trobada.")
                return Response(
                    json.dumps({
                        "result": {
                            'status': 'error',
                            'message': 'Comanda no trobada',
                            'processingValues': {
                                'return_url': f"/my/orders"
                            }
                        }
                    }),
                    content_type='application/json'
                )

            payment_option_id = kwargs.get('payment_option_id') or request.params.get('payment_option_id')
            if not payment_option_id:
                _logger.error("[SALDO] Falta `payment_option_id` al crear la transacció.")
                return Response(
                    json.dumps({
                        "result": {
                            'status': 'error',
                            'message': 'Falta payment_option_id',
                            'processingValues': {
                                'return_url': f"/my/orders/{order_id}"
                            }
                        }
                    }),
                    content_type='application/json'
                )

            _logger.info(f"[SALDO] Creant transacció per a la comanda {order.name} amb payment_option_id {payment_option_id}")

            tx = request.env['payment.transaction'].sudo()._create({
                'amount': order.amount_total,
                'currency_id': order.currency_id.id,
                'acquirer_id': int(payment_option_id),
                'partner_id': order.partner_id.id,
                'reference': order.name,
                'sale_order_ids': [(6, 0, [order.id])],
            })

            _logger.info(f"[SALDO] Transacció {tx.id} creada correctament per a {order.name}")

            return Response(
                json.dumps({
                    "result": {
                        "status": "success",
                        "message": "Transacció iniciada",
                        "redirect_url": "/shop/payment/validate",
                        "processingValues": {
                            "redirect_url": "/shop/payment/validate",
                            "params": {
                                "csrf_token": request.csrf_token(),
                                "access_token": request.params.get("access_token"),
                                "order_id": order.id,
                                "payment_option_id": int(payment_option_id),
                            },
                            "method": "POST"
                        }
                    }
                }),
                content_type='application/json'
            )

        except Exception as e:
            _logger.exception("[SALDO] Error inesperat al crear la transacció.")
            return Response(
                json.dumps({
                    "result": {
                        'status': 'error',
                        'message': str(e),
                        'processingValues': {
                            'return_url': "/my/orders"
                        }
                    }
                }),
                content_type='application/json'
            )
