# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountCreateParameters(Model):
    """
    The parameters to provide for the account.

    :param str location: Resource location
    :param dict tags: Resource tags
    :param StorageAccountPropertiesCreateParameters properties:
    """ 

    _validation = {
        'location': {'required': True},
    }

    _attribute_map = {
        'location': {'key': 'location', 'type': 'str'},
        'tags': {'key': 'tags', 'type': '{str}'},
        'properties': {'key': 'properties', 'type': 'StorageAccountPropertiesCreateParameters'},
    }

    def __init__(self, location, tags=None, properties=None, **kwargs):
        self.location = location
        self.tags = tags
        self.properties = properties
