from odoo.tests.common import TransactionCase

class TestReuseOrderFamily(TransactionCase):
    def setUp(self):
        super().setUp()
        self.Partner = self.env['res.partner']
        self.Event = self.env['event.event']
        self.Ticket = self.env['event.event.ticket']
        self.Product = self.env['product.product']
        self.SaleOrder = self.env['sale.order']

        self.partner = self.Partner.create({'name': 'Test Partner Reuse'})
        self.event = self.Event.create({
            'name': 'Test Event Reuse',
            'allow_family_registration': True,
            'event_cost': 5.0,
        })

        self.product1 = self.Product.create({
            'name': 'Producte Ticket 1',
            'type': 'service',
            'list_price': 5.0,
        })

        self.ticket1 = self.Ticket.create({
            'name': 'Ticket 1',
            'event_id': self.event.id,
            'price': 5.0,
            'product_id': self.product1.id,
        })

    def test_reuse_order_if_exists(self):
        """Test que reutilitza la comanda si ja existix."""

        # Primer registre: crea la comanda
        ticket_quantities = {self.ticket1.id: 1}
        sale_order_id = self.event.register_family(
            partner_id=self.partner.id,
            event_id=self.event.id,
            ticket_quantities=ticket_quantities
        )
        order = self.SaleOrder.browse(sale_order_id)

        self.assertTrue(order.exists(), "La primera comanda hauria d'existir.")
        self.assertEqual(order.state, 'sent', "La primera comanda hauria d'estar en estat 'sent'.")

        # Confirmar la comanda simulant pagament
        order.action_confirm()
        self.assertEqual(order.state, 'sale', "La comanda hauria d'estar confirmada (state='sale').")

        # Segon registre: intentar reutilitzar la comanda
        ticket_quantities_new = {self.ticket1.id: 2}  # Afegim més tickets

        sale_order_id_2 = self.event.register_family(
            partner_id=self.partner.id,
            event_id=self.event.id,
            ticket_quantities=ticket_quantities_new,
            order_id=order.id
        )
        order2 = self.SaleOrder.browse(sale_order_id_2)

        # Comprovar que no s'ha creat nova comanda
        self.assertEqual(order.id, order2.id, "La mateixa comanda hauria de ser reutilitzada, no una nova.")

        # Comprovar que la quantitat de la nova línia és correcta
        qtys = order2.order_line.mapped('product_uom_qty')
        self.assertIn(2, qtys, "S'hauria d'haver registrat una línia amb quantitat 2.")

