from odoo import models, fields, api

class SaleOrder(models.Model):
    _inherit = 'sale.order'

    aplicar_saldo_a_favor = fields.Boolean(string='Aplicar Saldo a Favor')
    saldo_a_favor_cliente = fields.Float(string='Saldo a Favor del Cliente', related='partner_id.saldo_a_favor', readonly=True)

    @api.onchange('aplicar_saldo_a_favor')
    def _onchange_aplicar_saldo_a_favor(self):
        if self.aplicar_saldo_a_favor and self.partner_id.saldo_a_favor > 0:
            saldo = self.partner_id.saldo_a_favor
            for line in self.order_line:
                if saldo <= 0:
                    break
                if saldo >= line.price_total:
                    saldo -= line.price_total
                else:
                    saldo = 0

    def _create_invoices(self, grouped=False, final=False):
        invoices = super(SaleOrder, self)._create_invoices(grouped=grouped, final=final)
        if self.aplicar_saldo_a_favor and self.partner_id.saldo_a_favor > 0:
            for invoice in invoices:
                saldo_a_favor = self.partner_id.saldo_a_favor
                amount_to_apply = 0
                for line in invoice.invoice_line_ids:
                    if saldo_a_favor <= 0:
                        break
                    if saldo_a_favor >= line.price_subtotal:
                        saldo_a_favor -= line.price_subtotal
                        amount_to_apply += line.price_subtotal
                    else:
                        amount_to_apply += saldo_a_favor
                        saldo_a_favor = 0
                
                if amount_to_apply > 0:
                    self.partner_id.saldo_a_favor -= amount_to_apply
                    invoice.write({
                        'invoice_line_ids': [(0, 0, {
                            'name': 'Descuento de Saldo a Favor',
                            'quantity': 1,
                            'price_unit': -amount_to_apply,
                        })]
                    })
        return invoices
