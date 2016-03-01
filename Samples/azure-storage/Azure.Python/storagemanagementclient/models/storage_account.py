# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from .resource import Resource


class StorageAccount(Resource):
    """
    The storage account.

    :param str id: Resource Id
    :param str name: Resource name
    :param str type: Resource type
    :param str location: Resource location
    :param dict tags: Resource tags
    :param StorageAccountProperties properties:
    """

    _required = []

    _attribute_map = {
        'properties': {'key': 'properties', 'type': 'StorageAccountProperties'},
    }

    def __init__(self, id=None, name=None, type=None, location=None, tags=None, properties=None):
        super(StorageAccount, self).__init__(id=id, name=name, type=type, location=location, tags=tags)
        self.properties = properties
