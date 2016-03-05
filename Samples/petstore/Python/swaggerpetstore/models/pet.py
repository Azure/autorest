# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class Pet(Model):
    """Pet

    :param long id:
    :param Category category:
    :param str name:
    :param list photo_urls:
    :param list tags:
    :param str status: pet status in the store. Possible values include:
     'available', 'pending', 'sold'
    """ 

    _validation = {
        'name': {'required': True},
        'photo_urls': {'required': True},
    }

    _attribute_map = {
        'id': {'key': 'id', 'type': 'long'},
        'category': {'key': 'category', 'type': 'Category'},
        'name': {'key': 'name', 'type': 'str'},
        'photo_urls': {'key': 'photoUrls', 'type': '[str]'},
        'tags': {'key': 'tags', 'type': '[Tag]'},
        'status': {'key': 'status', 'type': 'str'},
    }

    def __init__(self, name, photo_urls, id=None, category=None, tags=None, status=None, **kwargs):
        self.id = id
        self.category = category
        self.name = name
        self.photo_urls = photo_urls
        self.tags = tags
        self.status = status
