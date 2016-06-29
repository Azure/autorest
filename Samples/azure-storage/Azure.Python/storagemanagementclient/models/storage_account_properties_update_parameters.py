# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountPropertiesUpdateParameters(Model):
    """StorageAccountPropertiesUpdateParameters.

    :param account_type: Gets or sets the account type. Note that StandardZRS
     and PremiumLRS accounts cannot be changed to other account types, and
     other account types cannot be changed to StandardZRS or PremiumLRS.
     Possible values include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS',
     'Standard_RAGRS', 'Premium_LRS'
    :type account_type: str or :class:`AccountType
     <petstore.models.AccountType>`
    :param custom_domain: User domain assigned to the storage account. Name
     is the CNAME source. Only one custom domain is supported per storage
     account at this time. To clear the existing custom domain, use an empty
     string for the custom domain name property.
    :type custom_domain: :class:`CustomDomain <petstore.models.CustomDomain>`
    """ 

    _attribute_map = {
        'account_type': {'key': 'accountType', 'type': 'AccountType'},
        'custom_domain': {'key': 'customDomain', 'type': 'CustomDomain'},
    }

    def __init__(self, account_type=None, custom_domain=None):
        self.account_type = account_type
        self.custom_domain = custom_domain
