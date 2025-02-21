from odoo import models, fields

class Partner(models.Model):
    _inherit = "res.partner"

    xx_is_speler = fields.Boolean(string="Speler")