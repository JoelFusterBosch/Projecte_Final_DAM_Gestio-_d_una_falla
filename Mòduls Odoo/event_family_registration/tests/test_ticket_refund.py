from odoo.tests.common import TransactionCase

class TestTicketRefund(TransactionCase):
    """
    Test funcional per validar la devolució automàtica de tiquets d'esdeveniments
    i l'actualització del saldo familiar quan es redueix la quantitat de tiquets
    en una inscripció d'esdeveniment.
    """

    def setUp(self):
        """
        Configura l'entorn de proves:
        - Crea models necessaris (event, partner, família, membre, producte, ticket).
        - Assigna valors inicials per simular una situació real.
        """
        super(TestTicketRefund, self).setUp()
        # Referències als models Odoo utilitzats
        self.Event = self.env['event.event']
        self.Registration = self.env['event.registration']
        self.SaleOrder = self.env['sale.order']
        self.Partner = self.env['res.partner']
        self.Ticket = self.env['event.event.ticket']
        self.Product = self.env['product.product']
        self.Familia = self.env['familia.familia']
        self.Miembro = self.env['familia.miembro']

        # Crear un partner de prova
        self.partner = self.Partner.create({'name': 'Test Partner'})

        # Crear una família fictícia amb saldo inicial
        self.familia = self.Familia.create({
            'name': 'Família Test',
            'saldo_total': 100.0,
        })

        # Crear un membre associat a la família i al partner
        self.miembro = self.Miembro.create({
            'partner_id': self.partner.id,
            'familia_id': self.familia.id,
        })

        # Actualitzar la cache del partner
        self.partner.flush()
        self.partner.invalidate_cache()

        # Crear un producte que serà el ticket de l'esdeveniment
        self.product = self.Product.create({
            'name': 'Ticket Test Product',
            'type': 'service',
            'list_price': 10.0,
        })

        # Crear un esdeveniment fictici
        self.event = self.Event.create({
            'name': 'Event Test',
        })

        # Crear un ticket vinculat a l'esdeveniment i al producte
        self.ticket = self.Ticket.create({
            'event_id': self.event.id,
            'product_id': self.product.id,
            'price': 10.0,
        })

    def test_ticket_refund_on_quantity_update(self):
        """
        Test:
        - Simula la compra de 5 tiquets per a un esdeveniment.
        - Redueix la quantitat de tiquets a 2.
        - Comprova que es genera una devolució automàtica per la diferència.
        - Valida que el saldo de la família s'actualitza correctament.
        """

        # Crear una venda inicial amb 5 tiquets
        sale_order = self.SaleOrder.create({
            'partner_id': self.partner.id,
            'event_id': self.event.id,
            'order_line': [(0, 0, {
                'product_id': self.product.id,
                'product_uom_qty': 5,
                'price_unit': 10.0,
            })],
        })

        # Confirmar la venda i forçar l'estat a 'sale'
        sale_order.action_confirm()
        sale_order.write({'state': 'sale'})  # Força estat si cal

        # Simular que el saldo familiar baixa després de pagar amb saldo
        self.familia.sudo().write({'saldo_total': self.familia.saldo_total - 5 * 10.0})
        self.familia.actualitzar_saldo_membres()

        # Crear una inscripció inicial amb 5 tiquets
        self.Registration.create({
            'partner_id': self.partner.id,
            'event_id': self.event.id,
            'ticket_id': self.ticket.id,
            'ticket_qty': 5,
            'sale_order_id': sale_order.id,
            'payment_status': 'paid',
        })

        # Actualitzar la inscripció per reduir a 2 tiquets
        self.Registration.add_or_update_registration(
            partner_id=self.partner.id,
            event_id=self.event.id,
            ticket_id=self.ticket.id,
            ticket_qty=2,
            sale_order_id=sale_order.id,
        )

        # Comprovar que la inscripció s'ha actualitzat correctament
        registration = self.Registration.search([
            ('partner_id', '=', self.partner.id),
            ('event_id', '=', self.event.id),
            ('ticket_id', '=', self.ticket.id)
        ], limit=1)
        self.assertEqual(
            registration.ticket_qty,
            2,
            "La quantitat de tickets no s'ha actualitzat correctament."
        )

        # Buscar la devolució automàtica generada per la reducció de tiquets
        refund_order = self.SaleOrder.search([
            ('partner_id', '=', self.partner.id),
            ('note', 'ilike', 'Devolució automàtica%')
        ], limit=1)

        self.assertTrue(
            refund_order,
            "No s'ha generat cap ordre de devolució automàtica."
        )

        # Comprovar que l'import de la devolució és correcte (3 tiquets * 10€)
        expected_refund_amount = (5 - 2) * 10.0
        actual_refund_amount = abs(refund_order.amount_total)

        self.assertEqual(
            actual_refund_amount,
            expected_refund_amount,
            "L'import de la devolució no és correcte."
        )

        # Comprovar que el saldo familiar s'ha actualitzat correctament després de la devolució
        expected_final_saldo = 100.0 - (5 * 10.0) + (3 * 10.0)  # Saldo inicial - compra + devolució
        self.assertAlmostEqual(
            self.familia.saldo_total,
            expected_final_saldo,
            msg="El saldo de la família no s'ha actualitzat correctament després de la devolució."
        )
