from openupgradelib import openupgrade

def migrate(cr, version):
    openupgrade.add_field(
        'res.partner',
        'familia_id',
        'many2one',
        comodel_name='familia',
        string='Familia',
        ondelete='set null'
    )
