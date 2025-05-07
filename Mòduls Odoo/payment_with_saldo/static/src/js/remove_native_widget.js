odoo.define('payment_with_saldo.remove_native_widget', function (require) {
    "use strict";
    const publicWidget = require('web.public.widget');

    if (publicWidget.registry.WebsiteSalePaymentForm) {
        delete publicWidget.registry.WebsiteSalePaymentForm;
        console.log("🧹 [SALDO] Widget natiu WebsiteSalePaymentForm eliminat.");
    } else {
        console.warn("⚠️ [SALDO] Widget natiu WebsiteSalePaymentForm no trobat (potser ja s'ha eliminat?).");
    }
});
