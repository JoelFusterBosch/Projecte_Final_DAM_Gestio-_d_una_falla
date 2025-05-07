odoo.define('payment_with_saldo.disable_native_redirect', function (require) {
    "use strict";

    const PaymentForm = require('payment.payment_form');
    const core = require('web.core');

    console.log("🔧 [SALDO] Sobreescrivint _processRedirectPayment per evitar error de redirect...");

    PaymentForm.include({
        _processRedirectPayment: function ($form, processingValues) {
            console.log("🚫 [SALDO] Evitant redirect natiu d’Odoo. Redirigint manualment.");
            if (processingValues && processingValues.redirect_url) {
                setTimeout(function () {
                    window.location.href = processingValues.redirect_url;
                }, 1000);
            } else {
                console.warn("⚠️ [SALDO] No hi ha redirect_url definit.");
            }
        },
    });
});
