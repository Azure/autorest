# coding=utf-8
# --------------------------------------------------------------------------
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is
# regenerated.
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountCreateParameters(Model):
    """The parameters to provide for the account.

    :param location: Resource location
    :type location: str
    :param tags: Resource tags
    :type tags: dict
    :param account_type: Gets or sets the account type. Possible values
     include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS',
     'Premium_LRS'
    :type account_type: str or :class:`AccountType
     <storage.models.AccountType>`
    """

    _validation = {
        'location': {'required': True},
        'account_type': {'required': True},
    }

    _attribute_map = {
        'location': {'key': 'location', 'type': 'str'},
        'tags': {'key': 'tags', 'type': '{str}'},
        'account_type': {'key': 'properties.accountType', 'type': 'AccountType'},
    }

    def __init__(self, location, account_type, tags=None):
        self.location = location
        self.tags = tags
        self.account_type = account_type
