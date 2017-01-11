# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountProperties(Model):
    """StorageAccountProperties.

    :param provisioning_state: Gets the status of the storage account at the
     time the operation was called. Possible values include: 'Creating',
     'ResolvingDNS', 'Succeeded'
    :type provisioning_state: str or :class:`ProvisioningState
     <petstore.models.ProvisioningState>`
    :param account_type: Gets the type of the storage account. Possible values
     include: 'Standard_LRS', 'Standard_ZRS', 'Standard_GRS', 'Standard_RAGRS',
     'Premium_LRS'
    :type account_type: str or :class:`AccountType
     <petstore.models.AccountType>`
    :param primary_endpoints: Gets the URLs that are used to perform a
     retrieval of a public blob, queue or table object.Note that StandardZRS
     and PremiumLRS accounts only return the blob endpoint.
    :type primary_endpoints: :class:`Endpoints <petstore.models.Endpoints>`
    :param primary_location: Gets the location of the primary for the storage
     account.
    :type primary_location: str
    :param status_of_primary: Gets the status indicating whether the primary
     location of the storage account is available or unavailable. Possible
     values include: 'Available', 'Unavailable'
    :type status_of_primary: str or :class:`AccountStatus
     <petstore.models.AccountStatus>`
    :param last_geo_failover_time: Gets the timestamp of the most recent
     instance of a failover to the secondary location. Only the most recent
     timestamp is retained. This element is not returned if there has never
     been a failover instance. Only available if the accountType is StandardGRS
     or StandardRAGRS.
    :type last_geo_failover_time: datetime
    :param secondary_location: Gets the location of the geo replicated
     secondary for the storage account. Only available if the accountType is
     StandardGRS or StandardRAGRS.
    :type secondary_location: str
    :param status_of_secondary: Gets the status indicating whether the
     secondary location of the storage account is available or unavailable.
     Only available if the accountType is StandardGRS or StandardRAGRS.
     Possible values include: 'Available', 'Unavailable'
    :type status_of_secondary: str or :class:`AccountStatus
     <petstore.models.AccountStatus>`
    :param creation_time: Gets the creation date and time of the storage
     account in UTC.
    :type creation_time: datetime
    :param custom_domain: Gets the user assigned custom domain assigned to
     this storage account.
    :type custom_domain: :class:`CustomDomain <petstore.models.CustomDomain>`
    :param secondary_endpoints: Gets the URLs that are used to perform a
     retrieval of a public blob, queue or table object from the secondary
     location of the storage account. Only available if the accountType is
     StandardRAGRS.
    :type secondary_endpoints: :class:`Endpoints <petstore.models.Endpoints>`
    """

    _attribute_map = {
        'provisioning_state': {'key': 'provisioningState', 'type': 'ProvisioningState'},
        'account_type': {'key': 'accountType', 'type': 'AccountType'},
        'primary_endpoints': {'key': 'primaryEndpoints', 'type': 'Endpoints'},
        'primary_location': {'key': 'primaryLocation', 'type': 'str'},
        'status_of_primary': {'key': 'statusOfPrimary', 'type': 'AccountStatus'},
        'last_geo_failover_time': {'key': 'lastGeoFailoverTime', 'type': 'iso-8601'},
        'secondary_location': {'key': 'secondaryLocation', 'type': 'str'},
        'status_of_secondary': {'key': 'statusOfSecondary', 'type': 'AccountStatus'},
        'creation_time': {'key': 'creationTime', 'type': 'iso-8601'},
        'custom_domain': {'key': 'customDomain', 'type': 'CustomDomain'},
        'secondary_endpoints': {'key': 'secondaryEndpoints', 'type': 'Endpoints'},
    }

    def __init__(self, provisioning_state=None, account_type=None, primary_endpoints=None, primary_location=None, status_of_primary=None, last_geo_failover_time=None, secondary_location=None, status_of_secondary=None, creation_time=None, custom_domain=None, secondary_endpoints=None):
        self.provisioning_state = provisioning_state
        self.account_type = account_type
        self.primary_endpoints = primary_endpoints
        self.primary_location = primary_location
        self.status_of_primary = status_of_primary
        self.last_geo_failover_time = last_geo_failover_time
        self.secondary_location = secondary_location
        self.status_of_secondary = status_of_secondary
        self.creation_time = creation_time
        self.custom_domain = custom_domain
        self.secondary_endpoints = secondary_endpoints
