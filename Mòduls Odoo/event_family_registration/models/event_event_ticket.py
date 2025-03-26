from odoo import models, fields

class EventEventTicket(models.Model):
    _inherit = 'event.event.ticket'

    product_id = fields.Many2one(
        'product.product',
        string='Producto',
        help='Producto asociado al tipo de ticket.'
    )

    max_faller = fields.Boolean(
        string="Máximo Fallers",
        help="Restringir la cantidad de este tipo de ticket a la cantidad de miembros de la familia"
    )

    event_id = fields.Many2one(
        'event.event',
        string="Evento",
        required=True,
        ondelete='cascade'
    )

    registration_ids = fields.One2many(
        'event.registration',
        'ticket_id',
        string="Registros del Evento"
    )
