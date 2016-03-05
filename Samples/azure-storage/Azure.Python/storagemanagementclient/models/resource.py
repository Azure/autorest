# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class Resource(Model):
    """Resource

    :param str id: Resource Id
    :param str name: Resource name
    :param str type: Resource type
    :param str location: Resource location
    :param dict tags: Resource tags
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
