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

    _attribute_map = {
        'id': {'key': 'id', 'type': 'str'},
        'name': {'key': 'name', 'type': 'str'},
        'type': {'key': 'type', 'type': 'str'},
        'location': {'key': 'location', 'type': 'str'},
        'tags': {'key': 'tags', 'type': '{str}'},
        'properties': {'key': 'properties', 'type': 'StorageAccountProperties'},
    }

    def __init__(self, id=None, name=None, type=None, location=None, tags=None, properties=None):
        super(StorageAccount, self).__init__(id=id, name=name, type=type, location=location, tags=tags)
        self.properties = properties
