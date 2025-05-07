from odoo import models, fields, api
import logging
from datetime import date

_logger = logging.getLogger(__name__)


class ResPartnerFaller(models.Model):
    _inherit = 'res.partner'

    codifaller = fields.Integer(string='CodFaller')
    vat = fields.Char(string='DNI')
    nom_faller = fields.Char(string='Nombre')
    cognoms_faller = fields.Char(string='Apellidos')
    street = fields.Char(string='Direccion')
    city = fields.Char(string='Poblacion')
    zip = fields.Char(string='CP')
    provincia = fields.Char(string='Provincia')
    phone = fields.Char(string='Telefono')
    mobile = fields.Char(string='TMovil')
    email = fields.Char(string='MAIL')

    data_naixement = fields.Date(string='FechaNacimiento')
    sexe = fields.Selection([
        ('home', 'Home'),
        ('dona', 'Dona'),
    ], string='HomeDona')

    codi_postal_personalitzat = fields.Char(string='CodiP')
    alta = fields.Boolean(string='Alta')
    data_alta = fields.Date(string='FechaAlta')
    data_baixa = fields.Date(string='FechaBaja')
    numero_familia = fields.Char(string='NºFamilia')

    es_regina_major = fields.Boolean(string='Regina Major')
    fallera_major_infantil = fields.Boolean(string='Fallera Major Infantil')
    regina_infantil = fields.Boolean(string='Regina Infantil')
    regina_o_major = fields.Boolean(string='Regina/o Major')
    regina_o_infantil = fields.Boolean(string='Regina/o Infantil')

    baremacio = fields.Boolean(string='Baremacio')
    comentari = fields.Text(string='Comentari')
    antiguitat_previa = fields.Integer(string='AntiguitatPrevia')
    n_comissions = fields.Integer(string='NComissions')
    # display_name_with_title = fields.Char(
    #     string="Nom complet amb títol",
    #     compute="_compute_display_name_with_title",
    #     store=True,
    # )

    # @api.depends('title', 'name')
    # def _compute_display_name_with_title(self):
    #     for rec in self:
    #         title = rec.title.name if rec.title else ''
    #         rec.display_name_with_title = (title + ' ' + rec.name).strip()
    display_name_with_title = fields.Char(
        string="Nom amb títol",
        compute="_compute_display_name_with_title",
        store=True,
    )

    @api.depends('title', 'name')
    def _compute_display_name_with_title(self):
        for rec in self:
            title = rec.title.name if rec.title else ''
            rec.display_name_with_title = (title + ' ' + rec.name).strip()

    categoria_faller = fields.Selection([
        ('infantil', 'Infantil'),
        ('major', 'Majors')
    ], string="Categoria", compute='_compute_categoria_faller', store=True)

    @api.depends('data_naixement')
    def _compute_categoria_faller(self):
        for partner in self:
            if partner.data_naixement:
                any_actual = date.today().year
                data_falla = date(any_actual, 3, 19)  # 19 de març de l'any actual
                quinze_anys = date(partner.data_naixement.year + 15, partner.data_naixement.month, partner.data_naixement.day)

                # Són majors si fan 15 anys **abans o el mateix dia** de la falla
                if quinze_anys <= data_falla:
                    partner.categoria_faller = 'major'
                else:
                    partner.categoria_faller = 'infantil'
            else:
                partner.categoria_faller = 'major'


    @api.model
    def crear_membres_familia_des_de_numero(self):
        for partner in self.search([('numero_familia', '!=', False)]):
            familia = self.env['familia.familia'].search([
                ('numero_familia', '=', partner.numero_familia)
            ], limit=1)

            if not familia:
                familia = self.env['familia.familia'].create({
                    'name': f"Família {partner.numero_familia}",
                    'numero_familia': partner.numero_familia,
                })
                _logger.info(f"Creada família {familia.name} amb número {familia.numero_familia}")

            existeix = self.env['familia.miembro'].search([
                ('partner_id', '=', partner.id)
            ])
            if not existeix:
                self.env['familia.miembro'].create({
                    'partner_id': partner.id,
                    'familia_id': familia.id,
                })
                _logger.info(f"Afegit {partner.name} a la família {familia.numero_familia}")

    @api.onchange('nom_faller', 'cognoms_faller')
    def _onchange_nom_cognoms(self):
        self.name = f"{self.nom_faller or ''} {self.cognoms_faller or ''}".strip()

    def _get_titol_per_defecte(self, sexe, name):
        vocals = ['A', 'E', 'I', 'O', 'U', 'À', 'È', 'É', 'Í', 'Ó', 'Ò', 'Ú']
        if name:
            primera_lletra = name.strip()[0].upper()
            if primera_lletra in vocals:
                ref = self.env.ref('familia.res_partner_title_n_apostrof', raise_if_not_found=False)
            elif sexe == 'home':
                ref = self.env.ref('familia.res_partner_title_en', raise_if_not_found=False)
            elif sexe == 'dona':
                ref = self.env.ref('familia.res_partner_title_na', raise_if_not_found=False)
            else:
                ref = False

            _logger.info(f"Calculant títol per sexe={sexe} → {ref.name if ref else 'Cap'}")

            return ref


        return False

    @api.onchange('sexe', 'name')
    def _onchange_sexe_set_title(self):
        _logger.info(f"ONCHANGE sexe={self.sexe}, name={self.name}")
        _logger.info(f"Nom complet brut: {self.nom_faller=} {self.cognoms_faller=} | self.name={self.name}")
        if self.name:
            title = self._get_titol_per_defecte(self.sexe, self.name)
            if title:
                self.title = False
                self.title = title

    @api.model
    def create(self, vals):
        if 'sexe' in vals and 'name' in vals and not vals.get('title'):
            title = self._get_titol_per_defecte(vals['sexe'], vals['name'])
            if title:
                vals['title'] = title.id
        return super().create(vals)

    def write(self, vals):
        for record in self:
            sexe = vals.get('sexe', record.sexe)
            name = vals.get('name', record.name)
            if (('sexe' in vals or 'name' in vals) and not vals.get('title')):
                title = self._get_titol_per_defecte(sexe, name)
                if title:
                    vals['title'] = title.id
        return super().write(vals)
