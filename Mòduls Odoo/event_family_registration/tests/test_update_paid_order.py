from odoo.tests.common import TransactionCase

class TestUpdatePaidOrder(TransactionCase):
    """
    Test funcional per validar que es pot actualitzar una comanda ja pagada
    sense crear una nova comanda en registrar nous tiquets familiars.
    """

    def setUp(self):
        super(TestUpdatePaidOrder, self).setUp()

        self.Partner = self.env['res.partner']
        self.Event = self.env['event.event']
        self.Ticket = self.env['event.event.ticket']
        self.Product = self.env['product.product']
        self.SaleOrder = self.env['sale.order']

        self.partner = self.Partner.create({'name': 'Test Partner'})

        self.event = self.Event.create({
            'name': 'Test Event',
            'event_cost': 10.0,
            'allow_family_registration': True,
        })

        # Crear el primer producte associat al ticket
        self.product1 = self.Product.create({
            'name': 'Producte Ticket 1',
            'type': 'service',
            'list_price': 10.0,
        })

        self.ticket1 = self.Ticket.create({
            'name': 'Ticket 1',
            'event_id': self.event.id,
            'price': 10.0,
            'product_id': self.product1.id,  # 👉 Associar el producte
        })


    def test_update_existing_order_after_payment(self):
        """
        Test:
        - Crear una comanda amb 1 ticket i pagar-la.
        - Tornar a registrar més tiquets i comprovar que es reutilitza la mateixa comanda,
        i que la línia antiga queda anul·lada (quantitat 0).
        """

        # Pas 1: Registrar un ticket
        ticket_quantities = {self.ticket1.id: 1}
        sale_order_id = self.event.register_family(
            partner_id=self.partner.id,
            event_id=self.event.id,
            ticket_quantities=ticket_quantities
        )
        order = self.SaleOrder.browse(sale_order_id)

        # Confirmar la comanda com a pagada
        order.action_confirm()
        self.assertEqual(order.state, 'sale', "La comanda hauria d'estar confirmada (state='sale').")

        # Pas 2: Crear un nou producte i un nou ticket associat
        product2 = self.Product.create({
            'name': 'Producte Ticket 2',
            'type': 'service',
            'list_price': 15.0,
        })

        ticket2 = self.Ticket.create({
            'name': 'Ticket 2',
            'event_id': self.event.id,
            'price': 15.0,
            'product_id': product2.id,
        })

        # Tornar a registrar amb el nou ticket
        new_ticket_quantities = {ticket2.id: 2}

        updated_sale_order_id = self.event.register_family(
            partner_id=self.partner.id,
            event_id=self.event.id,
            ticket_quantities=new_ticket_quantities
        )
        updated_order = self.SaleOrder.browse(updated_sale_order_id)

        # Comprovacions bàsiques
        self.assertEqual(
            order.id, updated_order.id,
            "La comanda actualitzada hauria de ser la mateixa, no una de nova."
        )

        ticket_names = updated_order.order_line.mapped('name')
        self.assertIn('Producte Ticket 2', ticket_names, "La nova línia de tiquet no existeix.")

        # Comprovar que la línia antiga té quantitat 0
        producte_ticket1_line = updated_order.order_line.filtered(lambda l: l.name == 'Producte Ticket 1')
        self.assertTrue(producte_ticket1_line, "No s'ha trobat la línia del primer tiquet.")
        self.assertEqual(producte_ticket1_line.product_uom_qty, 0, "La línia antiga no té quantitat zero com hauria de tindre.")

        # Comprovar que la línia nova té quantitat correcta
        producte_ticket2_line = updated_order.order_line.filtered(lambda l: l.name == 'Producte Ticket 2')
        self.assertTrue(producte_ticket2_line, "No s'ha trobat la línia del nou tiquet.")
        self.assertEqual(producte_ticket2_line.product_uom_qty, 2, "La nova línia no té la quantitat correcta.")

        # Comprovar que només hi ha dues línies: una activa i una anul·lada
        self.assertEqual(len(updated_order.order_line), 2, "La comanda hauria de tindre exactament 2 línies.")

        # Comprovar que l'ordre continua sent vàlida i no està cancel·lada
        self.assertIn(updated_order.state, ['sent', 'sale'], "La comanda hauria de seguir sent vàlida (sent o sale).")
