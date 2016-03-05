# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class Category(Model):
    """Category

    :param long id:
    :param str name:
    """ 

    _attribute_map = {
        'id': {'key': 'id', 'type': 'long'},
        'name': {'key': 'name', 'type': 'str'},
    }

    def __init__(self, id=None, name=None, **kwargs):
        self.id = id
        self.name = name
