{
    'name': "Stap Custom module",
    'licence': 'GPL-3',
    'version': '18.0.1.0',
    'depends': ['contacts'],
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
