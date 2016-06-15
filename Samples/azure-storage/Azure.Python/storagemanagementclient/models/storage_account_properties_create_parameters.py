# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountPropertiesCreateParameters(Model):
    """StorageAccountPropertiesCreateParameters

    :param account_type: Gets or sets the account type. Possible values
     include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
     'Standard_RAGRS', 'Premium_LRS'
    :type account_type: str or :class:`AccountType
     <storagemanagementclient.models.AccountType>`
    """ 

    _validation = {
        'account_type': {'required': True},
    }

    _attribute_map = {
        'account_type': {'key': 'accountType', 'type': 'AccountType'},
    }

    def __init__(self, account_type):
        self.account_type = account_type
