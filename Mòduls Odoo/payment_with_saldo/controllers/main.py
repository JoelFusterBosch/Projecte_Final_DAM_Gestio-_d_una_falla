from odoo import http
from odoo.http import request
import logging
import json

_logger = logging.getLogger(__name__)

class PaymentWithSaldoController(http.Controller):

    @http.route('/shop/payment/validate', type='json', auth='public', csrf=False)
    def validate_payment(self):
        try:
            raw_data = request.httprequest.data.decode('utf-8')
            request_data = json.loads(raw_data) if raw_data else {}
            _logger.info(f"📥 [SALDO] Request data: {request_data}")

            order_id = request_data.get('order_id')
            payment_option_id = request_data.get('payment_option_id')

            if not order_id or not payment_option_id:
                return {
                    'status': 'error',
                    'message': f"Falten dades per al pagament: {'order_id' if not order_id else ''}{' i ' if not order_id and not payment_option_id else ''}{'payment_option_id' if not payment_option_id else ''}"
                }

            order_id = int(order_id)
            payment_option_id = int(payment_option_id)
            order = request.env['sale.order'].sudo().browse(order_id)

            if not order.exists():
                raise ValueError(f"La comanda {order_id} no existeix!")

            client = order.partner_id
            _logger.info(f"✅ [SALDO] Comanda {order_id} trobada per al client {client.id}")

            if payment_option_id == 20:  # Pagament amb saldo
                _logger.info(f"💰 [SALDO] Iniciant procés de pagament amb saldo.")

                if client.saldo_a_favor < order.amount_total:
                    _logger.warning(f"⚠️ [SALDO] Saldo insuficient per al client {client.id}! (Té {client.saldo_a_favor:.2f}€, necessita {order.amount_total:.2f}€)")
                    return {
                        'status': 'error',
                        'message': f'Saldo insuficient. Tens {client.saldo_a_favor:.2f}€, però la comanda costa {order.amount_total:.2f}€.',
                        'redirect_url': f"/my/orders/{order.id}"
                    }

                reference = f"{order.name}-{order.id}"
                existing_transaction = request.env['payment.transaction'].sudo().search([('reference', '=', reference)], limit=1)

                if existing_transaction:
                    _logger.warning(f"⚠️ [SALDO] La transacció {existing_transaction.id} ja existeix i està en estat {existing_transaction.state}!")
                    return {
                        'status': 'error',
                        'message': 'Ja s’ha processat el pagament',
                        'redirect_url': f"/my/orders/{order.id}"
                    }

                try:
                    with request.env.cr.savepoint():
                        _logger.info(f"🟢 [SALDO] Comprovant condicions del pagament.")

                        payment_provider = request.env['payment.provider'].sudo().search([('id', '=', 20)], limit=1)

                        _logger.info(f"🔍 [SALDO] Payment Provider trobat: {payment_provider.id if payment_provider else 'No trobat'}")

                        if not payment_provider:
                            raise ValueError("❌ [SALDO] Proveïdor de pagament no trobat")

                        payment_method_line = request.env['account.payment.method.line'].sudo().search([('provider_id', '=', payment_provider.id)], limit=1)

                        if not payment_method_line:
                            raise ValueError("❌ [SALDO] No s'ha trobat cap línia de mètode de pagament vàlida!")

                        journal_saldo = request.env['account.journal'].sudo().search([('name', '=', 'BancFalla')], limit=1)
                        if not journal_saldo:
                            raise ValueError("❌ [SALDO] No s'ha trobat el diari de pagament correcte!")

                        payment_transaction = request.env['payment.transaction'].sudo().create({
                            'amount': order.amount_total,
                            'currency_id': order.currency_id.id,
                            'provider_id': payment_provider.id,
                            'partner_id': order.partner_id.id,
                            'reference': reference,
                            'sale_order_ids': [(6, 0, [order.id])],
                            'state': 'pending',
                            'provider_code': 'saldo',
                            'payment_method_line_id': payment_method_line.id,
                            #'journal_id': journal_saldo.id,  # 🔹 Assignació directa del diari correcte
                            'payment_option_id': payment_option_id
                        })
                        _logger.info(f"✅ [SALDO] Transacció creada amb ID: {payment_transaction.id}")

                        payment_transaction.sudo()._set_done()
                        _logger.info(f"✅ [SALDO] Transacció {payment_transaction.id} marcada com a 'done'")
                        # ✅ Vincular la transacció a la comanda
                        order.sudo().write({
                        'transaction_ids': [(4, payment_transaction.id)],  # Assigna la transacció a la comanda
                        'invoice_status': 'invoiced'  # Marca la comanda com pagada
                        })
                        _logger.info(f"✅ [SALDO] Comanda {order.id} vinculada amb la transacció {payment_transaction.id}")

                        # ✅ Processar correctament la transacció
                        payment_transaction.sudo()._post_process_after_done()
                        _logger.info(f"✅ [SALDO] Transacció {payment_transaction.id} processada correctament.")

                        # ✅ Ara sí descomptem el saldo
                        new_saldo = client.saldo_a_favor - order.amount_total
                        client.sudo().write({'saldo_a_favor': new_saldo})
                        _logger.info(f"🔹 [SALDO] Saldo del client {client.id} actualitzat a {new_saldo}€")

                        #order.sudo().action_confirm()
                        # 🚨 Evitem confirmar la comanda des del mòdul de pagament si el sistema ho fa automàticament.
                        if not hasattr(order, 'event_id'):  # Si l'ordre NO és d'un esdeveniment, la confirmem.
                            order.sudo().action_confirm()
                        else:
                            _logger.info(f"🔹 [SALDO] No confirmem l'ordre {order.id} perquè està vinculada a un esdeveniment.")

                        order.message_post(body="💰 [SALDO] Pagament realitzat amb saldo.")
                        _logger.info(f"✅ [SALDO] Comanda {order.id} confirmada correctament.")

                        if payment_transaction.state == 'done':
                            order.sudo().write({'state': 'sale', 'invoice_status': 'invoiced'})
                            _logger.info(f"✅ [SALDO] Comanda {order.id} confirmada i marcada com facturada.")


                        return {
                            'status': 'success',
                            'message': 'Pagament realitzat correctament!',
                            'redirect_url': f"/my/orders/{order.id}"
                        }

                except Exception as e:
                    _logger.error(f"❌ [SALDO] Error durant el pagament: {str(e)}")
                    return {
                        'status': 'error',
                        'message': f'Error en processar el pagament: {str(e)}',
                        'redirect_url': f"/my/orders/{order.id}"
                    }

            return {
                'status': 'error',
                'message': 'Mètode de pagament no vàlid',
                'redirect_url': f"/my/orders/{order.id}"
            }

        except Exception as e:
            _logger.error(f"❌ [SALDO] Error general: {str(e)}")
            return {
                'status': 'error',
                'message': 'Error inesperat en el procés de pagament.',
                'redirect_url': "/my/orders"
            }
