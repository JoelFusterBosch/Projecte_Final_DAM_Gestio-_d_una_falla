from odoo import models, fields, api
import base64
import qrcode
from io import BytesIO

class SaleOrder(models.Model):
    _inherit = "sale.order"

    qr_code = fields.Binary(
        "QR Code",
        compute="_compute_qr_code",
        store=True
    )

    @api.depends("name")  # 🔥 El QR es recalcularà quan el nom de la comanda canvie
    def _compute_qr_code(self):
        """Genera el codi QR per a cada comanda"""
        for order in self:
            if order.name:
                qr = qrcode.make(f"https://provestalens.es/order/{order.id}")
                buffer = BytesIO()
                qr.save(buffer, format="PNG")
                order.qr_code = base64.b64encode(buffer.getvalue())

    def generate_qr_code(self):
        """Força la regeneració del QR manualment"""
        self._compute_qr_code()
        self.sudo().write({'qr_code': self.qr_code})  # 🔥 Assegurar que es guarde a la BD
