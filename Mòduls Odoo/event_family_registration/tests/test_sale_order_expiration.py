from odoo.tests.common import TransactionCase
from datetime import datetime

class TestSaleOrderExpiration(TransactionCase):

    def setUp(self):
        super().setUp()
        # Crear un partner de prova
        self.partner = self.env['res.partner'].create({
            'name': 'Partner de Test',
        })

    def test_validity_date_from_event_default(self):
        """Comprovar que aplica la regla general: divendres abans del diumenge."""
        event = self.env['event.event'].create({
            'name': 'Event Normal',
            'date_begin': datetime(2025, 10, 20, 14, 0, 0),
            'date_end': datetime(2025, 10, 20, 20, 0, 0),
        })

        product = self.env['product.product'].create({
            'name': 'Tiquet Normal',
        })

        sale_order = self.env['sale.order'].create({
            'partner_id': self.partner.id,   # 👈 Ara usem el partner creat al setUp
            'order_line': [(0, 0, {
                'product_id': product.id,
                'product_uom_qty': 1,
                'price_unit': 10.0,
            })],
            'event_id': event.id,
        })

        expected_deadline = datetime(2025, 10, 18, 23, 59, 0)


        self.assertEqual(
            sale_order.validity_date,
            expected_deadline.date(),
            "La validity_date no ha aplicat correctament la regla general."
        )
        self.assertEqual(
            sale_order.expiration_datetime.replace(microsecond=0),
            expected_deadline.replace(microsecond=0),
            "La expiration_datetime no ha aplicat correctament la regla general."
        )

    def test_validity_date_falles(self):
        """Comprovar que calcula el segon diumenge de febrer si és Falles."""
        event = self.env['event.event'].create({
            'name': 'Falles 2026',
            'date_begin': datetime(2026, 3, 18, 14, 0, 0),
            'date_end': datetime(2026, 3, 18, 20, 0, 0),
        })

        product = self.env['product.product'].create({
            'name': 'Tiquet Falles',
        })

        sale_order = self.env['sale.order'].create({
            'partner_id': self.partner.id,   # 👈 També usem el partner creat
            'order_line': [(0, 0, {
                'product_id': product.id,
                'product_uom_qty': 1,
                'price_unit': 10.0,
            })],
            'event_id': event.id,
        })

        expected_deadline = datetime(2026, 2, 8, 23, 59, 0)

        self.assertEqual(
            sale_order.validity_date,
            expected_deadline.date(),
            "La validity_date no és el segon diumenge de febrer com hauria de ser."
        )
        self.assertEqual(
            sale_order.expiration_datetime.replace(microsecond=0),
            expected_deadline.replace(microsecond=0),
            "La expiration_datetime no és el segon diumenge de febrer com hauria de ser."
        )
