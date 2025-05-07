# payment_with_saldo/controllers/account_payment_controller.py

from odoo.addons.account_payment.controllers.payment import AccountPaymentController
from odoo.http import request
from odoo import http
import logging

_logger = logging.getLogger(__name__)


class AccountPaymentControllerWithSaldo(AccountPaymentController):
    def _create_transaction(self, order, payment_option_id, **kwargs):
        _logger.info(f"[SALDO] Creando transacción para order {order.name} con payment_option_id {payment_option_id}")
        return super()._create_transaction(order, payment_option_id, **kwargs)
