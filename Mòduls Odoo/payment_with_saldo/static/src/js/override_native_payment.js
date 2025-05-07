odoo.define('payment_with_saldo.remove_native_widget', function (require) {
    "use strict";

    const publicWidget = require('web.public.widget');

    if (publicWidget.registry.WebsiteSalePaymentForm) {
        console.log("🧹 [SALDO] Eliminant widget de pagament natiu Odoo...");
        delete publicWidget.registry.WebsiteSalePaymentForm;
    } else {
        console.warn("⚠️ [SALDO] Widget natiu WebsiteSalePaymentForm no trobat.");
    }
});
