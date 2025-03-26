odoo.define('payment_with_saldo.payment', function (require) {
    "use strict";
    var globalPaymentOptionId = "saldo";  // Inicialitzada per defecte
    var publicWidget = require('web.public.widget');

    publicWidget.registry.PaymentWithSaldo = publicWidget.Widget.extend({
        selector: 'form.o_payment_form',
        events: {
            'submit': '_onSubmit',
            'change input[name="o_payment_checkbox"]': '_onPaymentOptionChange',
        },

        start: function () {
            this._super.apply(this, arguments);
            console.log("✅ [SALDO] JavaScript de pago con saldo cargado correctamente.");

            var self = this;
            $(document).ready(function () {
                self._initializePaymentOption();
                self._injectOrderId();  // 🆕 Afegim `order_id` al formulari si no hi és
                self._forceSubmitHandler();
            });
        },

        _setDefaultPaymentOption: function () {
            var $saldoOption = this.$('input[type="radio"][value="saldo"]');
            if ($saldoOption.length) {
                $saldoOption.prop('checked', true);
                console.log("Opción de pago con saldo seleccionada por defecto");
        
                var $paymentOptionIdInput = this.$('input[name="payment_option_id"]');
                if ($paymentOptionIdInput.length) {
                    $paymentOptionIdInput.val(20);  // Forzar el ID correcto
                    console.log("Estableciendo `payment_option_id`: " + $paymentOptionIdInput.val());
                } else {
                    console.error("Campo `payment_option_id` no encontrado en el DOM.");
                }
            } else {
                console.error("No se encontró la opción de pago con saldo en la lista de métodos de pago.");
            }
        },
        
        _initializePaymentOption: function () {
            var $saldoCheckbox = $('#payment_saldo');
            var $paymentOptionIdInput = $('input[name="payment_option_id"]');
            var $payButton = $('button[name="o_payment_submit_button"]');

            if ($saldoCheckbox.length) {
                console.log("✅ [SALDO] Opción de pago con saldo detectada.");

                // 🔹 NO el marquem per defecte si vols que l'usuari ho seleccione manualment
                // console.log("✅ [SALDO] Checkbox trobat, esperant selecció de l'usuari.");
                // ✅ 🔹 SELECCIONAR AUTOMÀTICAMENT EL CHECKBOX
                $saldoCheckbox.prop('checked', true).trigger('change');

                if ($paymentOptionIdInput.length) {
                    // ✅ 🔹 ASSEGURAR-SE QUE EL `payment_option_id` ESTÀ ESTABLERT CORRECTAMENT
                    $paymentOptionIdInput.val("20");
                    console.log("✅ [SALDO] `payment_option_id` establit a 20.");
                } else {
            console.error("❌ [SALDO] Campo `payment_option_id` no encontrado en el DOM.");
                }

                // ✅ 🔹 HABILITAR EL BOTÓ DE PAGAMENT AUTOMÀTICAMENT
                $payButton.prop('disabled', false);
                console.log("✅ [SALDO] Botó de pagament habilitat per defecte.");
            } else {
        console.warn("⚠️ [SALDO] No se encontró la opción de pago con saldo.");
            }  


            // 🔹 Esdeveniment per canviar l'estat del botó i assegurar-se que s'actualitza correctament
            $saldoCheckbox.on('change', function () {
                if ($(this).is(':checked')) {
                    $payButton.prop('disabled', false);
                    $paymentOptionIdInput.val("20");  // 🔹 Ara sí que assignem el valor correcte
                    console.log("✅ [SALDO] `payment_option_id` establit a 20.");
                } else {
                    $payButton.prop('disabled', true);
                    $paymentOptionIdInput.val("");
                    console.log("⚠️ [SALDO] `payment_option_id` eliminat.");
                }
            });
        },



        _injectOrderId: function () {
            let urlParams = new URLSearchParams(window.location.search);
            let orderIdFromUrl = urlParams.get("order_id");

            // Si no trobem `order_id` a la URL, intentem obtenir-lo de la ruta
            if (!orderIdFromUrl) {
                let orderIdMatch = window.location.pathname.match(/\/my\/orders\/(\d+)/);
                if (orderIdMatch) {
                    orderIdFromUrl = orderIdMatch[1];
                    console.log("🔍 [SALDO] `order_id` detectat en la URL:", orderIdFromUrl);
                }
            }

            // Si encara no tenim `order_id`, intentem obtenir-lo des del formulari
            if (!orderIdFromUrl) {
                let orderIdFromForm = $('form.o_payment_form').data('order-id');
                if (orderIdFromForm) {
                    orderIdFromUrl = orderIdFromForm;
                    console.log("🔍 [SALDO] `order_id` detectat en el DOM:", orderIdFromUrl);
                }
            }

            if (orderIdFromUrl) {
                let $existingOrderIdInput = $('input[name="order_id"]');
                if ($existingOrderIdInput.length === 0) {
                    $('form.o_payment_form').append(`<input type="hidden" name="order_id" value="${orderIdFromUrl}"/>`);
                    console.log("✅ [SALDO] `order_id` afegit al formulari:", orderIdFromUrl);
                } else {
                    console.log("✅ [SALDO] `order_id` ja estava definit:", $existingOrderIdInput.val());
                }
            } else {
                console.error("❌ [SALDO] No s'ha pogut obtenir `order_id`. Això impedirà el pagament.");
                alert("Error: No s'ha trobat l'ID de la comanda. Si us plau, refresca la pàgina i torna a intentar-ho.");
            }
        },



        _onPaymentOptionChange: function (event) {
            var selectedOption = $(event.target).is(':checked') ? $(event.target).val() : null;
            console.log("🔄 [SALDO] Método de pago cambiado a: " + selectedOption);

            var $paymentOptionIdInput = $('input[name="payment_option_id"]');
            var $payButton = $('button[name="o_payment_submit_button"]');

            if ($paymentOptionIdInput.length) {
                $paymentOptionIdInput.val(selectedOption || '');
                globalPaymentOptionId = selectedOption || '';
                console.log("✅ [SALDO] `payment_option_id` actualizado a: " + globalPaymentOptionId);

                if (selectedOption) {
                    console.log("✅ [SALDO] Habilitant el botó de pagament...");
                    $payButton.prop('disabled', false);
                } else {
                    console.log("⚠️ [SALDO] Deshabilitant el botó de pagament...");
                    $payButton.prop('disabled', true);
                }
            } else {
                console.error("❌ [SALDO] Campo `payment_option_id` no encontrado en el DOM.");
            }
        },


        _forceSubmitHandler: function () {
            var self = this;
            var $form = $('form.o_payment_form');
            var $button = $('button[name="o_payment_submit_button"]');

            if ($form.length) {
                console.log("✅ [SALDO] Formulari `.o_payment_form` trobat.");
                $button.off('click').on('click', function (event) {
                    event.preventDefault();
                    console.log("🖱️ [SALDO] Click detectat en el botó de pagament.");

                    var formElement = document.querySelector("form.o_payment_form");
                    if (formElement) {
                        console.log("✅ [SALDO] Fent scroll al formulari...");
                        formElement.scrollIntoView({ behavior: "smooth", block: "start" });
                    } else {
                        console.warn("⚠️ [SALDO] No s'ha trobat el formulari per fer scroll.");
                    }

                    console.log("🔄 [SALDO] Forçant `submit()` manualment...");
                    $form.trigger('submit');
                });

                $form.off('submit').on('submit', function (event) {
                    console.log("📩 [SALDO] Event `submit` detectat en `form.o_payment_form`! Executant `_onSubmit()`...");
                    self._onSubmit(event);
                });
            } else {
                console.error("❌ [SALDO] Formulari `.o_payment_form` NO trobat.");
            }
        },

        _onSubmit: function (event) {
            event.preventDefault();

            var $form = $(event.currentTarget);
            var transactionRoute = $form.attr('action');
            var orderId = parseInt($form.find('input[name="order_id"]').val(), 10);
            var paymentOptionInput = parseInt($form.find('input[name="payment_option_id"]').val(), 10);
            var $saldoCheckbox = $('#payment_saldo');
            var $hiddenPaymentOption = $form.find('input[name="payment_option_id"]');
            if (!$hiddenPaymentOption.length) {
                console.warn("⚠️ [SALDO] Afegint manualment `payment_option_id` al formulari...");
                $form.append('<input type="hidden" name="payment_option_id" value="20"/>');
            }


            // 🔹 Assegurar que el valor correcte de orderId s'estableix abans d'enviar
            if (!orderId) {
                let orderIdFromForm = $form.data('order-id');
                if (orderIdFromForm) {
                    orderId = orderIdFromForm;
                    console.log("✅ [SALDO] `order_id` recuperat del DOM:", orderId);
                } else {
                    console.error("❌ [SALDO] Error: No s'ha trobat `order_id`.");
                    alert("Error: No s'ha trobat l'ID de la comanda. Si us plau, refresca la pàgina i torna a intentar-ho.");
                    return;
                }
            }

            // 🔹 Assegurar que el valor correcte s'estableix abans d'enviar
            if ($saldoCheckbox.is(':checked')) {
                paymentOptionInput = "20";
                $form.find('input[name="payment_option_id"]').val(paymentOptionInput);
            } else {
                console.error("❌ [SALDO] Error: No s'ha seleccionat cap `payment_option_id`.");
                alert("Error: Has de seleccionar un mètode de pagament.");
                return;
            }

            console.log("🔍 [SALDO] Dades del formulari abans d'enviar:", {
                payment_option_id: paymentOptionInput,
                transactionRoute: transactionRoute,
                orderId: orderId
            });

            if (!orderId || !transactionRoute) {
                console.error("❌ [SALDO] Error: Falten dades necessàries per completar el pagament.");
                alert("Error: Falta informació per completar el pagament.");
                return;
            }

            $.ajax({
                url: transactionRoute,
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                data: JSON.stringify({
                    order_id: parseInt(orderId),
                    payment_option_id: parseInt(paymentOptionInput)  // 🔹 Assegurar que és un enter
                }),
                success: function (response) {
                    console.log("📩 [SALDO] Resposta completa del servidor: ", response);
                    
                    if (response.result) {
                        console.log("📩 [SALDO] Resultat del servidor: ", response.result);
                    }
                    
                    if (response.result && response.result.status === 'success') {
                        console.log("✅ [SALDO] Pagament realitzat amb èxit. Redirigint...");
                        window.location.href = response.result.redirect_url;
                    } else {
                        console.error("❌ [SALDO] Error en el pagament: ", response.result ? response.result.message : "Missatge no definit");
                        alert("Error en el pagament: " + (response.result ? response.result.message : "Missatge no definit"));
                    }
                }
                ,
                error: function (xhr) {
                    console.error("❌ [SALDO] Error AJAX:", xhr.responseText);
                    alert("Error al processar el pagament: " + xhr.responseText);
                }
            });
        }


    });
    return publicWidget.registry.PaymentWithSaldo;
});