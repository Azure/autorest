# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class Resource(Model):
    """Resource

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
    }

    def __init__(self, location=None, tags=None):
        self._id = None
        self._name = None
        self._type = None
        self.location = location
        self.tags = tags

    @property
    def id(self):
        return self._id

    @property
    def name(self):
        return self._name

    @property
    def type(self):
        return self._type
