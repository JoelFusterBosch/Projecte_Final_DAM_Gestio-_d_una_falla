odoo.define('payment_with_saldo.payment', function (require) {
    "use strict";

    const publicWidget = require('web.public.widget');

    delete publicWidget.registry.WebsiteSalePaymentForm;

    publicWidget.registry.PaymentWithSaldo = publicWidget.Widget.extend({
        selector: 'form.o_payment_form',
        events: {
            'submit': '_onSubmit',
            'change input[name="o_payment_radio"]': '_onPaymentOptionChange',
        },

        start: function () {
            this._super.apply(this, arguments);

            delete publicWidget.registry.WebsiteSalePaymentForm;
            $('form.o_payment_form').off('submit');
            $('button[name="o_payment_submit_button"]').off('click');

            console.log("✅ [SALDO] JS carregat correctament");

            var self = this;
            $(document).ready(function () {
                self._initializePaymentOption();
                self._injectOrderId();
                self._forceSubmitHandler();
            });

            $(document).on('submit', 'form.o_payment_form', function (e) {
                e.preventDefault();
                e.stopImmediatePropagation();
            });
        },

        _initializePaymentOption: function () {
            const $saldoCheckbox = $('#payment_saldo');
            const $paymentOptionIdInput = $('input[name="payment_option_id"]');
            const $payButton = $('button[name="o_payment_submit_button"]');

            if ($saldoCheckbox.length) {
                console.log("✅ [SALDO] Opción de pago con saldo detectada.");
                $saldoCheckbox.prop('checked', true).trigger('change');
                $paymentOptionIdInput.val("20");
                $payButton.prop('disabled', false);
            } else {
                console.warn("⚠️ [SALDO] No es troba l’opció de saldo.");
            }

            $saldoCheckbox.on('change', function () {
                if ($(this).is(':checked')) {
                    $payButton.prop('disabled', false);
                    $paymentOptionIdInput.val("20");
                } else {
                    $payButton.prop('disabled', true);
                    $paymentOptionIdInput.val("");
                }
            });
        },

        _injectOrderId: function () {
            let orderId = null;
            const urlParams = new URLSearchParams(window.location.search);
            orderId = urlParams.get("order_id");

            if (!orderId) {
                const match = window.location.pathname.match(/\/my\/orders\/(\d+)/);
                if (match) orderId = match[1];
            }

            if (!orderId) {
                orderId = $('form.o_payment_form').data('order-id');
            }

            if (orderId) {
                if ($('input[name="order_id"]').length === 0) {
                    $('form.o_payment_form').append(`<input type="hidden" name="order_id" value="${orderId}"/>`);
                    console.log("✅ [SALDO] order_id afegit:", orderId);
                }
            } else {
                console.error("❌ [SALDO] No s'ha trobat order_id!");
                alert("Error: No s'ha trobat l'ID de la comanda.");
            }
        },

        _onPaymentOptionChange: function (event) {
            const selected = $(event.target).val();
            $('input[name="payment_option_id"]').val(selected || '');
            $('button[name="o_payment_submit_button"]').prop('disabled', !selected);
        },

        _forceSubmitHandler: function () {
            const self = this;
            const $form = $('form.o_payment_form');
            const $button = $('button[name="o_payment_submit_button"]');

            $button.off('click').on('click', function (e) {
                e.preventDefault();
                e.stopImmediatePropagation();
                $form.trigger('submit');
            });

            $form.off('submit').on('submit', function (e) {
                e.preventDefault();
                e.stopImmediatePropagation();
                self._onSubmit(e);
            });
        },

        _showSpinner: function () {
            const spinnerHtml = `
                <div id="saldo-spinner" style="margin-top:1rem;text-align:center;">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Cargando...</span>
                    </div>
                </div>`;
            $('.o_payment_form').append(spinnerHtml);
        },

        _showMessage: function (msg, type='success') {
            $('#saldo-alert').remove(); // Elimina missatge anterior si existeix
            const alertHtml = `
                <div class="alert alert-${type} mt-3 text-center" role="alert" id="saldo-alert">
                    ${msg}
                </div>`;
            $('.o_payment_form').prepend(alertHtml); // millor a dalt de tot
        },


        _onSubmit: function (event) {
            if (this._submitted) return;
            this._submitted = true;
            event.preventDefault();
            event.stopImmediatePropagation();

            const $form = $(event.currentTarget);
            const $button = $form.find('button[name="o_payment_submit_button"]');
            $button.prop('disabled', true);
            this._showSpinner();

            const transactionRoute = $form.attr('action');
            const orderId = parseInt($form.find('input[name="order_id"]').val());
            const paymentOptionId = parseInt($form.find('input[name="payment_option_id"]').val());

            if (!orderId || !paymentOptionId || !transactionRoute) {
                alert("Error: Falten dades per completar el pagament.");
                return;
            }

            console.log("📦 [SALDO] Enviant AJAX amb:", { orderId, paymentOptionId });

            $.ajax({
                url: transactionRoute,
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                headers: { "X-Requested-With": "XMLHttpRequest" },
                data: JSON.stringify({
                    order_id: orderId,
                    csrf_token: odoo.csrf_token,
                    payment_option_id: paymentOptionId
                }),
                success: function (response) {
                    console.log("📩 [SALDO] Resposta:", response);

                    if (response.status === 'success') {
                        $(".spinner-border").remove();
                        this._showMessage("✅ Pagament amb saldo realitzat correctament! Redirigint...", 'success');
                        $('form.o_payment_form').off('submit');  // 👉 DESACTIVA el 'submit' per evitar doble enviament
                        setTimeout(function () {
                            window.location.href = response.redirect_url;
                        }, 500);
                    } else if (response.status === 'error') {
                        $(".spinner-border").remove();
                        this._showMessage("❌ Error en el pagament: " + (response.message || "Desconegut"), 'danger');
                        $button.prop('disabled', false);
                    } else {
                        $(".spinner-border").remove();
                        this._showMessage("❌ Error desconegut.", 'danger');
                        $button.prop('disabled', false);
                    }

                }.bind(this),
                error: function (xhr) {
                    $(".spinner-border").remove(); // elimina spinner
                    this._showMessage("❌ Error AJAX: " + xhr.responseText, 'danger');
                    $button.prop('disabled', false);
                }.bind(this)
            });
        }
    });

    return publicWidget.registry.PaymentWithSaldo;
});
