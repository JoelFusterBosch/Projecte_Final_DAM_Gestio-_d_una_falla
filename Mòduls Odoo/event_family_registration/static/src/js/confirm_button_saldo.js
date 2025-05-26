odoo.define('event_family_registration.confirm_button_saldo', function (require) {
    'use strict';

    const ajax = require('web.ajax');
    const Dialog = require('web.Dialog');

    $(document).ready(function () {
        $('#confirm_button').on('click', function (ev) {
            ev.preventDefault();
            ev.stopImmediatePropagation();

            const $btn = $(this);
            const saldo = parseFloat($btn.data('partner-saldo')) || 0;
            const total = parseFloat($btn.data('order-total')) || 0;
            const orderId = $btn.data('order-id');
            const paymentOptionId = $("input[name='payment_option_id']").val();

            if (!orderId || !paymentOptionId) {
                Dialog.alert(null, "❌ Error: Falten dades per al pagament.");
                return;
            }

            const processPayment = function () {
                console.log("📦 [SALDO] Iniciant AJAX a /shop/payment/validate amb:", {
                    order_id: parseInt(orderId),
                    payment_option_id: parseInt(paymentOptionId)
                });

                ajax.jsonRpc('/shop/payment/validate', 'call', {
                    order_id: parseInt(orderId),
                    payment_option_id: parseInt(paymentOptionId)
                }).then(function (response) {
                    if (response.status === 'success') {
                        console.log("✅ [SALDO] Pagament realitzat, redirigint...");
                        window.location.href = response.redirect_url || `/my/orders/${orderId}`;
                    } else {
                        console.warn("❌ [SALDO] Error en el pagament:", response.message);
                        Dialog.alert(null, response.message || "No s'ha pogut confirmar el pagament.");
                    }
                }).catch(function (error) {
                    console.error("❌ [SALDO] Error AJAX:", error);
                    Dialog.alert(null, "Error inesperat en la comunicació amb el servidor.");
                });
            };

            if (saldo < total) {
                Dialog.confirm(null, "⚠️ El teu saldo és insuficient i quedaràs en negatiu. Vols continuar igualment?", {
                    confirm_callback: processPayment,
                    cancel_callback: function () {
                        console.log("🚫 L'usuari ha cancel·lat el pagament.");
                    }
                });
            } else {
                processPayment();
            }
        });
    });
});
