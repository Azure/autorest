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

    _attribute_map = {
        'id': {'key': 'id', 'type': 'str'},
        'name': {'key': 'name', 'type': 'str'},
        'type': {'key': 'type', 'type': 'str'},
        'location': {'key': 'location', 'type': 'str'},
        'tags': {'key': 'tags', 'type': '{str}'},
    }

    def __init__(self, id=None, name=None, type=None, location=None, tags=None, **kwargs):
        self.id = id
        self.name = name
        self.type = type
        self.location = location
        self.tags = tags
