
# ✅ Millora del comportament del botó de confirmació amb saldo (Odoo)

## 🎯 Objectiu
Evitar que es mostre una finestra nativa del navegador (`alert()`) quan el saldo és insuficient, i substituir-ho per un missatge visual d'estil Odoo amb `alert alert-danger`.

---

## 🧩 Context

- El botó `Confirmar` és gestionat pel mòdul `event_family_registration`, no per `payment_with_saldo`.
- Aquest mòdul feia una crida AJAX amb `ajax.jsonRpc` i mostrava els errors amb `alert()`.

---

## 🔧 Solució aplicada

### 1. Substituir el bloc `.then(...)` del JS per:

```javascript
ajax.jsonRpc('/shop/payment/validate', 'call', {
    order_id: parseInt(orderId),
    payment_option_id: parseInt(paymentOptionId)
}).then(function (response) {
    if (response.status === 'success') {
        window.location.href = response.redirect_url || `/my/orders/${orderId}`;
    } else {
        $('#saldo-alert').remove();  // Eliminar alertes anteriors
        const alertHtml = `
            <div class="alert alert-danger mt-3 text-center" role="alert" id="saldo-alert">
                ❌ Error: ${response.message || "No s'ha pogut confirmar el pagament."}
            </div>`;
        $('.o_portal_wrap').prepend(alertHtml);
    }
}).catch(function (error) {
    console.error("❌ [SALDO] Error AJAX:", error);
    $('#saldo-alert').remove();
    const alertHtml = `
        <div class="alert alert-danger mt-3 text-center" role="alert" id="saldo-alert">
            ❌ Error inesperat en la comunicació amb el servidor.
        </div>`;
    $('.o_portal_wrap').prepend(alertHtml);
});
```

### 2. Resultat visual

- El missatge es mostra dins del portal, estilitzat.
- No es bloqueja la navegació amb alertes natives.

---

## ✅ Estat final

- JS funcionant correctament.
- Errors mostrats amb `alert alert-danger`.
- Interfície coherent amb el disseny del portal.

---

## 📁 Fitxer afectat

```plaintext
event_family_registration/static/src/js/payment_confirmation.js
```

---

## ✨ Bonus

Si el botó no està dins `form.o_payment_form`, aquest enfocament funciona igual i no requereix adaptar `payment_with_saldo.js`.

