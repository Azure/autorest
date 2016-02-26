# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountCreateParameters(Model):
    """
    The parameters to provide for the account.

    :param str location: Resource location
    :param dict tags: Resource tags
    :param str account_type: Gets or sets the account type. Possible values
     include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
     'Standard_RAGRS', 'Premium_LRS'
    """

    _required = ['location', 'account_type']

    _attribute_map = {
        'location': {'key': 'location', 'type': 'str'},
        'tags': {'key': 'tags', 'type': '{str}'},
        'account_type': {'key': 'properties.accountType', 'type': 'AccountType', 'flatten': True},
    }

    def __init__(self, location, account_type, tags=None):
        self.location = location
        self.tags = tags
        self.account_type = account_type
