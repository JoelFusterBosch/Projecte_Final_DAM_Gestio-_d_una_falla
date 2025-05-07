odoo.define('payment_with_saldo.error_handling', function (require) {
    "use strict";

    const publicWidget = require('web.public.widget');

    publicWidget.registry.PaymentErrorFix = publicWidget.Widget.extend({
        selector: '.o_payment_form',
        start: function () {
            // Captura errors globals
            window.addEventListener("error", function (e) {
                if (typeof e.message === "string" && e.message.includes("scrollIntoView")) {
                    console.warn("⚠️ Error ignorat: scrollIntoView d'un element indefinit.");
                    e.preventDefault();
                }
            });

            window.addEventListener("unhandledrejection", function (e) {
                if (e.reason && (
                    (typeof e.reason === "string" && e.reason.includes("scrollIntoView")) ||
                    (typeof e.reason.message === "string" && e.reason.message.includes("scrollIntoView"))
                )) {
                    console.warn("⚠️ Promise rebutjada per error amb scrollIntoView.");
                    e.preventDefault();
                }
            });
        }
    });
});
