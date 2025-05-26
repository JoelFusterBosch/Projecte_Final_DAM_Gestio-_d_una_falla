odoo.define('event_family_registration.payment_confirmation', function (require) {
    "use strict";

    const ajax = require('web.ajax');
    const publicWidget = require('web.public.widget');

    console.log("✅ [SALDO] JS payment_confirmation carregat");

    publicWidget.registry.PaymentConfirmationButton = publicWidget.Widget.extend({
        selector: '#confirm_button',
        events: {
            'click': '_onClickConfirm',
        },

        _onClickConfirm: function (e) {
            e.preventDefault();

            const orderId = this.$el.data('order-id');
            const paymentOptionId = $("input[name='payment_option_id']").val();

            if (!orderId || !paymentOptionId) {
                alert("❌ Error: Falten dades per al pagament: order_id o payment_option_id");
                return;
            }

            console.log("📦 [SALDO] Iniciant AJAX amb:", {
                order_id: parseInt(orderId),
                payment_option_id: parseInt(paymentOptionId)
            });

            ajax.jsonRpc('/shop/payment/validate', 'call', {
                order_id: parseInt(orderId),
                payment_option_id: parseInt(paymentOptionId)
            }).then(function (response) {
                if (response.status === 'success') {
                    console.log("✅ [SALDO] Pagament confirmat, redirigint...");
                    window.location.href = response.redirect_url || `/my/orders/${orderId}`;
                } else {
                    console.warn("❌ [SALDO] Error en el pagament", response.message);
                    $('#saldo-alert').remove(); // elimina alerta anterior si n’hi ha
                        const alertHtml = `
                            <div class="alert alert-danger mt-3 text-center" role="alert" id="saldo-alert">
                                ❌ Error: ${response.message || "No s'ha pogut confirmar el pagament."}
                            </div>`;
                        $('.o_portal_wrap').prepend(alertHtml);

                }
            }).catch(function (error) {
                console.error("❌ [SALDO] Error AJAX:", error);
                alert("Error inesperat en la comunicació amb el servidor.");
            });
        },
    });

    return publicWidget.registry.PaymentConfirmationButton;
});
