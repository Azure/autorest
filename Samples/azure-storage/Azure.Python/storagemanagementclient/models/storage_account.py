# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from .resource import Resource


class StorageAccount(Resource):
    """
    The storage account.

    :param id: Resource Id
    :type id: str
    :param name: Resource name
    :type name: str
    :param type: Resource type
    :type type: str
    :param location: Resource location
    :type location: str
    :param tags: Resource tags
    :type tags: dict
    :param properties:
    :type properties: :class:`StorageAccountProperties
     <petstore.models.StorageAccountProperties>`
    """ 

    _validation = {
        '_id': {'readonly': True},
        '_name': {'readonly': True},
        '_type': {'readonly': True},
    }

    _attribute_map = {
        '_id': {'key': 'id', 'type': 'str'},
        '_name': {'key': 'name', 'type': 'str'},
        '_type': {'key': 'type', 'type': 'str'},
        'location': {'key': 'location', 'type': 'str'},
        'tags': {'key': 'tags', 'type': '{str}'},
        'properties': {'key': 'properties', 'type': 'StorageAccountProperties'},
    }

    def __init__(self, location=None, tags=None, properties=None):
        super(StorageAccount, self).__init__(location=location, tags=tags)
        self.properties = properties
