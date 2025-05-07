odoo.define('event_family_registration.event_registration_status', function (require) {
    "use strict";

    console.log("🧪 event_registration_status.js carregat");

    const publicWidget = require('web.public.widget');

    // Injectem estils per a la cinta en diagonal
    const style = document.createElement('style');
    style.innerHTML = `
        .event-ribbon {
            position: absolute;
            top: 28px;
            left: -28px;
            transform: rotate(-45deg);
            width: 160px;
            text-align: center;
            background-color: #28a745;
            color: white;
            font-weight: bold;
            padding: 5px 0;
            font-size: 0.75rem;
            box-shadow: 0 0 4px rgba(0, 0, 0, 0.2);
            z-index: 20;
            pointer-events: none;
        }

        .event-ribbon.bg-warning {
            background-color: #ffc107;
        }

        .event-ribbon.bg-danger {
            background-color: #dc3545;
        }

        /* Oculta el badge original d’Odoo per sempre */
        small.o_wevent_participating {
            display: none !important;
        }
    `;
    document.head.appendChild(style);

    publicWidget.registry.EventStatusBadge = publicWidget.Widget.extend({
        selector: '.o_wevent_events_list',

        start: function () {
            const articles = this.el.querySelectorAll('article.card');

            articles.forEach(article => {
                const container = article.querySelector('[data-res-id]');
                const eventId = container?.getAttribute('data-res-id');
                if (!eventId) return;

                this._rpc({
                    route: '/event/registration_status',
                    params: { event_id: parseInt(eventId) },
                }).then(data => {
                    // 🔄 Elimina qualsevol cinta anterior
                    article.querySelectorAll('.event-ribbon').forEach(el => el.remove());

                    // 👉 Només si hi ha estat definit
                    if (data.label && data.color && data.status !== 'cap') {
                        const ribbon = document.createElement('div');
                        ribbon.className = `event-ribbon bg-${data.color}`;

                        // Icona segons l'estat
                        let icon = '';
                        if (data.status === 'pagat') icon = '✅ ';
                        else if (data.status === 'registrat') icon = '📩 ';
                        else if (data.status === 'pressupostat') icon = '📝 ';

                        ribbon.innerText = `${icon}${data.label}`;

                        // 🖼️ Inserim la cinta dins del contenidor de la imatge
                        const imageContainer = article.querySelector('.card-img-top')?.parentElement || article;
                        imageContainer.style.position = 'relative';
                        imageContainer.appendChild(ribbon);
                    }
                }).catch(error => {
                    console.error(`⚠️ Error AJAX per a event ID ${eventId}:`, error);
                });
            });

            return this._super.apply(this, arguments);
        },
    });

    return publicWidget.registry.EventStatusBadge;
});
