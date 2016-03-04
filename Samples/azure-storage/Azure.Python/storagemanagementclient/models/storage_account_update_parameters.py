# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountUpdateParameters(Model):
    """
    The parameters to update on the account.

    :param dict tags: Resource tags
    :param StorageAccountPropertiesUpdateParameters properties:
    """ 

    _attribute_map = {
        'tags': {'key': 'tags', 'type': '{str}'},
        'properties': {'key': 'properties', 'type': 'StorageAccountPropertiesUpdateParameters'},
    }

    def __init__(self, tags=None, properties=None, **kwargs):
        self.tags = tags
        self.properties = properties
