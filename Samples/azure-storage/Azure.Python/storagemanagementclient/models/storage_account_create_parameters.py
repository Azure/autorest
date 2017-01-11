# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountCreateParameters(Model):
    """The parameters to provide for the account.

    :param location: Resource location
    :type location: str
    :param tags: Resource tags
    :type tags: dict
    :param properties:
    :type properties: :class:`StorageAccountPropertiesCreateParameters
     <petstore.models.StorageAccountPropertiesCreateParameters>`
    """

    _validation = {
        'location': {'required': True},
    }

    _attribute_map = {
        'location': {'key': 'location', 'type': 'str'},
        'tags': {'key': 'tags', 'type': '{str}'},
        'properties': {'key': 'properties', 'type': 'StorageAccountPropertiesCreateParameters'},
    }

    def __init__(self, location, tags=None, properties=None):
        self.location = location
        self.tags = tags
        self.properties = properties
