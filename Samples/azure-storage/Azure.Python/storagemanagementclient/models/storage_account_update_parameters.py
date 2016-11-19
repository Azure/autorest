# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountUpdateParameters(Model):
    """The parameters to update on the account.

    :param tags: Resource tags
    :type tags: dict
    :param properties:
    :type properties: :class:`StorageAccountPropertiesUpdateParameters
     <petstore.models.StorageAccountPropertiesUpdateParameters>`
    """

    _attribute_map = {
        'tags': {'key': 'tags', 'type': '{str}'},
        'properties': {'key': 'properties', 'type': 'StorageAccountPropertiesUpdateParameters'},
    }

    def __init__(self, tags=None, properties=None):
        self.tags = tags
        self.properties = properties
