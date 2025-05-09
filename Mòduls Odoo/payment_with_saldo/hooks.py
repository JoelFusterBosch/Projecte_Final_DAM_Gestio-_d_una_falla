from odoo import SUPERUSER_ID, api

def post_init_hook(cr, registry):
    env = api.Environment(cr, SUPERUSER_ID, {})

    journal = env['account.journal'].search([('code', '=', 'BNK1')], limit=1)
    if not journal:
        journal = env['account.journal'].create({
            'name': 'BancFalla',
            'code': 'BNK1',
            'type': 'bank',
            'company_id': env.company.id,
            'currency_id': env.company.currency_id.id,
        })

    # Assegura't que té entrada a ir.model.data per a poder referenciar-lo en XML
    if not env['ir.model.data'].search([
        ('model', '=', 'account.journal'),
        ('res_id', '=', journal.id),
        ('module', '=', 'payment_with_saldo'),
        ('name', '=', 'account_journal_bancfalla')
    ]):
        env['ir.model.data'].create({
            'name': 'account_journal_bancfalla',
            'model': 'account.journal',
            'module': 'payment_with_saldo',
            'res_id': journal.id,
        })
