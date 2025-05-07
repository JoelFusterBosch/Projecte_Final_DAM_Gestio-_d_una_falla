odoo.define('event_family_registration.custom_registration', function (require) {
    'use strict';

    var ajax = require('web.ajax');
    var core = require('web.core');
    var publicWidget = require('web.public.widget');
    var Dialog = require('web.Dialog');

    publicWidget.registry.CustomEventRegistration = publicWidget.Widget.extend({
        selector: '.register-btn',
        events: {
            'click': '_onRegisterClick',
            'change .ticket-quantity': '_onTicketQuantityChange',
            'change select[name^="nb_register-"]': '_onSelectChange',
        },

        start: function () {
            this._super.apply(this, arguments);

            var partner_id = $('button.register-btn').data('partner-id');
            var event_id = $('button.register-btn').data('event-id');

            if (partner_id && event_id) {
                ajax.jsonRpc('/event/' + event_id + '/max_faller_limits', 'call', {
                    partner_id: partner_id
                }).then(function (limits) {
                    $('.ticket-quantity').each(function () {
                        var $input = $(this);
                        var ticket_id = $input.data('ticket-id');
                        var ticket_max = parseInt($input.data('ticket-max'));

                        var familia_limit = limits[ticket_id];
                        var final_max = ticket_max;

                        if (familia_limit !== undefined) {
                            final_max = isNaN(ticket_max) ? familia_limit : Math.min(ticket_max, familia_limit);
                        }

                        if (!isNaN(final_max)) {
                            $input.attr('max', final_max);
                            if (parseInt($input.val()) > final_max) {
                                $input.val(final_max);
                            }
                            console.log(`Límit per al tiquet ${ticket_id}: ${final_max}`);
                        }
                    });
                }).catch(function (error) {
                    console.error("Error obtenint límits de tiquets:", error);
                });
            }
        },

        _onRegisterClick: function (ev) {
            ev.preventDefault();

            var csrf_token = core.csrf_token;
            var partner_id = $(ev.currentTarget).data('partner-id');
            var event_id = $(ev.currentTarget).data('event-id');

            var ticket_quantities = {};
            $('.ticket-quantity').each(function () {
                var ticket_id = parseInt($(this).data('ticket-id'));
                var quantity = parseInt($(this).val());

                if (quantity > 0) {
                    ticket_quantities[ticket_id] = quantity;
                    console.log("Tiquet ID: ", ticket_id, "Quantitat: ", quantity);
                }
            });

            if ($.isEmptyObject(ticket_quantities)) {
                Dialog.alert(this, "No has seleccionat cap tiquet.");
                return;
            }

            ajax.jsonRpc('/event/' + event_id + '/register', 'call', {
                partner_id: partner_id,
                ticket_quantities: ticket_quantities,
                csrf_token: csrf_token
            }).then(function (response) {
                if (response.status === 'success') {
                    console.log("Registre completat: " + response.message);
                    Dialog.alert(this, "Registre completat.");

                    if (response.sale_order_id) {
                        window.location.href = '/my/orders/' + response.sale_order_id;
                    }
                } else {
                    Dialog.alert(this, 'Error en el registre: ' + response.message);
                }
            }.bind(this)).catch(function (error) {
                console.error("Error en la sol·licitud AJAX: ", error);
                Dialog.alert(this, 'Error en el registre.');
            }.bind(this));
        },

        _onTicketQuantityChange: function (ev) {
            var quantity = $(ev.currentTarget).val();
            console.log("Quantitat seleccionada: ", quantity);
        },

        _onSelectChange: function (ev) {
            var selectedValue = $(ev.currentTarget).val();
            console.log("Valor seleccionat en el select: ", selectedValue);
        }
    });
});
