odoo.define('event_family_registration.event_status_ribbon', function (require) {
    "use strict";

    const publicWidget = require('web.public.widget');
    const ajax = require('web.ajax');

    // Injectem CSS per a la cinta diagonal
    const style = document.createElement('style');
    style.innerHTML = `
        .event-ribbon {
            position: absolute;
            top: 2rem;
            left: -3.2rem;
            transform: rotate(-45deg);
            background-color: #007bff;
            color: white;
            padding: 0.4em 2em;
            font-size: 0.75rem;
            font-weight: bold;
            z-index: 999;
            box-shadow: 0 0 6px rgba(0,0,0,0.3);
            pointer-events: none;
        }
    `;
    document.head.appendChild(style);

    publicWidget.registry.EventStatusRibbon = publicWidget.Widget.extend({
        selector: '.o_wevent_event_title',

        start: function () {
            const eventId = $("button.register-btn").data("event-id");
            if (!eventId) return;

            // Oculta l'etiqueta original
            this.el.querySelectorAll(".o_wevent_badge").forEach(e => e.style.display = "none");

            ajax.jsonRpc('/event/registration_status', 'call', {
                event_id: parseInt(eventId),
            }).then(data => {
                if (data.label && data.color) {
                    const ribbon = document.createElement("div");
                    ribbon.className = "event-ribbon bg-" + data.color;
                    ribbon.innerText = data.label;

                    const parent = this.el.closest(".o_record_cover_container");
                    if (parent) {
                        parent.style.position = "relative";
                        parent.appendChild(ribbon);
                    }
                }
            }).catch(err => {
                console.warn("❌ Error carregant estat d'inscripció:", err);
            });

            return this._super.apply(this, arguments);
        }
    });

    return publicWidget.registry.EventStatusRibbon;
});
