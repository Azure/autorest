# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountUpdateParameters(Model):
    """
    The parameters to update on the account.

    :param dict tags: Resource tags
    :param str account_type: Gets or sets the account type. Note that
     StandardZRS and PremiumLRS accounts cannot be changed to other account
     types, and other account types cannot be changed to StandardZRS or
     PremiumLRS. Possible values include: 'Standard_LRS', 'Standard_ZRS',
     'Standard_GRS', 'Standard_RAGRS', 'Premium_LRS'
    :param CustomDomain custom_domain: User domain assigned to the storage
     account. Name is the CNAME source. Only one custom domain is supported
     per storage account at this time. To clear the existing custom domain,
     use an empty string for the custom domain name property.
    """

    _required = []

    _attribute_map = {
        'tags': {'key': 'tags', 'type': '{str}'},
        'account_type': {'key': 'properties.accountType', 'type': 'AccountType', 'flatten': True},
        'custom_domain': {'key': 'properties.customDomain', 'type': 'CustomDomain', 'flatten': True},
    }

    def __init__(self, tags=None, account_type=None, custom_domain=None):
        self.tags = tags
        self.account_type = account_type
        self.custom_domain = custom_domain
