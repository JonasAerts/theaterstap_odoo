{
    'name': "Stap Custom module",
    'version': '18.0.1.0',
    'depends': ['partner'],
    'author': "Jonas Aerts",
    'category': 'Partner',
    # data files always loaded at installation
    'data': [
        "views/res_partner_views.xml",
    ],
    "installable": True,
    "application": True,
    "auto_install": False,
}
