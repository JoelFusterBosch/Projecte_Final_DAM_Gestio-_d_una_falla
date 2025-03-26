odoo.define('event_family_registration.custom_registration', function (require) {
    'use strict';

    var ajax = require('web.ajax');
    var core = require('web.core');
    var publicWidget = require('web.public.widget');

    publicWidget.registry.CustomEventRegistration = publicWidget.Widget.extend({
        selector: '.register-btn',
        events: {
            'click': '_onRegisterClick',
            'change .ticket-quantity': '_onTicketQuantityChange',
            'change select[name^="nb_register-"]': '_onSelectChange',
        },

        _onRegisterClick: function (ev) {
            ev.preventDefault();

            // Obtener el CSRF token
            var csrf_token = core.csrf_token;

            // Obtener el partner_id y event_id desde el botón
            var partner_id = $(ev.currentTarget).data('partner-id');
            var event_id = $(ev.currentTarget).data('event-id');

            // Recoger los datos de los tickets seleccionados
            var ticket_quantities = {};
            $('.ticket-quantity').each(function () {
                var ticket_id = parseInt($(this).data('ticket-id'));
                var quantity = parseInt($(this).val());

                if (quantity > 0) {
                    ticket_quantities[ticket_id] = quantity;
                    console.log("Ticket ID: ", ticket_id, "Cantidad: ", quantity);
                }
            });

            // Validar si no se han seleccionado tickets
            if ($.isEmptyObject(ticket_quantities)) {
                alert('No has seleccionado ningún tiquet.');
                return;
            }

            // Enviar los datos vía AJAX, incluyendo el CSRF token
            ajax.jsonRpc('/event/' + event_id + '/register', 'call', {
                partner_id: partner_id,
                ticket_quantities: ticket_quantities,
                csrf_token: csrf_token
            }).then(function (response) {
                if (response.status === 'success') {
                    console.log("Registro completado: " + response.message);
                    alert('Registro completado.');

                    // Redirigir al usuario a la página del presupuesto
                    if (response.sale_order_id) {
                        window.location.href = '/my/orders/' + response.sale_order_id;
                    }
                } else {
                    alert('Error en el registro: ' + response.message);
                }
            }).catch(function (error) {
                console.error("Error en la solicitud AJAX: ", error);
                alert('Error en el registro.');
            });
        },

        _onTicketQuantityChange: function (ev) {
            var quantity = $(ev.currentTarget).val();
            console.log("Cantidad seleccionada: ", quantity);
        },

        _onSelectChange: function (ev) {
            var selectedValue = $(ev.currentTarget).val();
            console.log("Valor seleccionado en el select: ", selectedValue);
        }
    });
});
