from odoo import http, fields
from odoo.http import request
import logging
import json

_logger = logging.getLogger(__name__)

class PaymentWithSaldoController(http.Controller):

    @http.route('/shop/payment/validate', type='json', auth='public', csrf=False)
    def validate_payment(self, order_id=None, payment_option_id=None, **kwargs):
        try:
            _logger.info("📥 [SALDO] Inici de la ruta /shop/payment/validate")
            _logger.info(f"📅 [SALDO] Rebut: order_id={order_id}, payment_option_id={payment_option_id}")

            # request_data = request.jsonrequest
            # _logger.info(f"📅 [SALDO] JSON data: {request_data}")


            # order_id = request_data.get('order_id')
            # payment_option_id = request_data.get('payment_option_id')

            if not order_id or not payment_option_id:
                _logger.warning("⚠️ [SALDO] Falten dades: order_id o payment_option_id")
                return {
                    'status': 'error',
                    'message': f"Falten dades per al pagament: {'order_id' if not order_id else ''}{' i ' if not order_id and not payment_option_id else ''}{'payment_option_id' if not payment_option_id else ''}",
                    'processingValues': {
                        'return_url': "/my/orders"
                    }
                }

            order_id = int(order_id)
            payment_option_id = int(payment_option_id)
            _logger.info(f"🔢 [SALDO] Order ID: {order_id}, Payment Option ID: {payment_option_id}")

            order = request.env['sale.order'].sudo().browse(order_id)
            if not order.exists():
                _logger.error(f"❌ [SALDO] La comanda {order_id} no existeix!")
                raise ValueError(f"La comanda {order_id} no existeix!")

            client = order.partner_id
            _logger.info(f"✅ [SALDO] Comanda trobada. Client: {client.name} (ID {client.id})")

            if payment_option_id == 20:
                _logger.info("💰 [SALDO] Pagament amb saldo detectat. Iniciant validacions...")

                # if client.saldo_a_favor < order.amount_total:
                #     _logger.warning(f"⚠️ [SALDO] Saldo insuficient! Client té {client.saldo_a_favor}, cost és {order.amount_total}")
                #     return {
                #         'status': 'error',
                #         'message': f'Saldo insuficient. Tens {client.saldo_a_favor:.2f}€, però la comanda costa {order.amount_total:.2f}€.',
                #         'redirect_url': f"/my/orders/{order.id}",
                #         'processingValues': {
                #             'return_url': f"/my/orders/{order.id}"
                #         }
                #     }
                if client.saldo_a_favor < order.amount_total:
                    _logger.warning(f"⚠️ [SALDO] Saldo insuficient! Client té {client.saldo_a_favor}, cost és {order.amount_total}")
                    # S'accepta igualment el pagament, però es deixarà saldo negatiu (ja ha estat confirmat al frontend)


                reference = f"{order.name}-{order.id}"
                existing_transaction = request.env['payment.transaction'].sudo().search([('reference', '=', reference)], limit=1)
                if existing_transaction:
                    _logger.warning(f"⚠️ [SALDO] Transacció ja existent: ID {existing_transaction.id}, estat {existing_transaction.state}")
                    return {
                        'status': 'error',
                        'message': 'Ja s’ha processat el pagament',
                        'redirect_url': f"/my/orders/{order.id}",
                        'processingValues': {
                            'return_url': f"/my/orders/{order.id}"
                        }
                    }

                try:
                    with request.env.cr.savepoint():
                        _logger.info("🔍 [SALDO] Buscant payment provider per ref XML...")
                        payment_provider = request.env.ref('payment_with_saldo.payment_provider_saldo').sudo()

                        _logger.info("📘 [SALDO] Buscant journal amb codi BNK1")
                        journal_saldo = request.env['account.journal'].sudo().search([('code', '=', 'BNK1')], limit=1)
                        if not journal_saldo:
                            raise ValueError("No s'ha trobat el diari de pagament correcte (BNK1)!")

                        _logger.info("📘 [SALDO] Buscant línia de mètode de pagament per codi 'saldo' i journal 'BNK1'")
                        payment_method_line = request.env['account.payment.method.line'].sudo().search([
                            ('payment_method_id.code', '=', 'saldo'),
                            ('journal_id.code', '=', 'BNK1')
                        ], limit=1)
                        if not payment_method_line:
                            raise ValueError("No s'ha trobat cap línia de mètode de pagament amb saldo vàlida!")

                        _logger.info(f"✅ [SALDO] Línia trobada: {payment_method_line.name} ({payment_method_line.payment_method_id.name})")

                        _logger.info("🧾 [SALDO] Creant transacció...")
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
                            'payment_option_id': payment_option_id
                        })

                        _logger.info(f"✅ [SALDO] Transacció creada: {payment_transaction.id}")
                        payment_transaction.sudo()._set_done()
                        _logger.info("📦 [SALDO] Transacció marcada com a 'done'")

                        order.sudo().write({
                            'transaction_ids': [(4, payment_transaction.id)],
                            'invoice_status': 'invoiced'
                        })
                        _logger.info("📌 [SALDO] Transacció vinculada amb la comanda")

                        payment_transaction.sudo()._post_process_after_done()
                        _logger.info("✅ [SALDO] Post-processament de la transacció complet")

                        payment_vals = {
                            'partner_id': client.id,
                            'amount': order.amount_total,
                            'payment_type': 'inbound',
                            'partner_type': 'customer',
                            'journal_id': journal_saldo.id,
                            'payment_method_line_id': payment_method_line.id,
                            'ref': f"Pagament amb saldo per a comanda {order.name}",
                            'date': fields.Date.context_today(request.env.user),
                        }
                        payment = request.env['account.payment'].sudo().create(payment_vals)
                        payment.action_post()

                        _logger.info(f"🧾 [SALDO] Pagament comptable creat i registrat (ID {payment.id})")

                        new_saldo = client.saldo_a_favor - order.amount_total
                        client.sudo().write({'saldo_a_favor': new_saldo})
                        _logger.info(f"💳 [SALDO] Saldo client actualitzat a {new_saldo}€")

                        if not hasattr(order, 'event_id'):
                            _logger.info("🟢 [SALDO] Confirmant comanda (no és esdeveniment)")
                            order.sudo().action_confirm()
                        else:
                            _logger.info("📅 [SALDO] La comanda és d'un esdeveniment, no es confirma manualment.")

                        order.message_post(body="💰 [SALDO] Pagament realitzat amb saldo.")
                        _logger.info("📨 [SALDO] Missatge registrat a la comanda.")

                        return {
                            'status': 'success',
                            'message': 'Pagament realitzat correctament!',
                            'redirect_url': f"/my/orders/{order.id}",
                            'processingValues': {
                                'return_url': f"/my/orders/{order.id}"
                            }
                        }

                except Exception as e:
                    import traceback
                    _logger.error("❌ [SALDO] Error intern:\n" + traceback.format_exc())
                    return {
                        'status': 'error',
                        'message': f"Error en processar el pagament: {str(e)}",
                        'redirect_url': f"/my/orders/{order.id}",
                        'processingValues': {
                            'return_url': f"/my/orders/{order.id}"
                        }
                    }

            _logger.warning("⚠️ [SALDO] Mètode de pagament desconegut.")
            return {
                'status': 'error',
                'message': 'Mètode de pagament no reconegut',
                'processingValues': {
                    'return_url': f"/my/orders/{order.id}"
                }
            }

        except Exception as e:
            import traceback
            _logger.error("❌ [SALDO] Error general:\n" + traceback.format_exc())
            return {
                'status': 'error',
                'message': 'Error inesperat en el procés de pagament.',
                'redirect_url': "/my/orders",
                'processingValues': {
                    'return_url': "/my/orders"
                }
            }
