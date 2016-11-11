# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class Pet(Model):
    """A pet.

    A group of properties representing a pet.

    :param id: The id of the pet. A more detailed description of the id of
     the pet.
    :type id: long
    :param category:
    :type category: :class:`Category <petstore.models.Category>`
    :param name:
    :type name: str
    :param photo_urls:
    :type photo_urls: list of str
    :param tags:
    :type tags: list of :class:`Tag <petstore.models.Tag>`
    :param status: pet status in the store. Possible values include:
     'available', 'pending', 'sold'
    :type status: str
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

    def __init__(self, name, photo_urls, id=None, category=None, tags=None, status=None):
        self.id = id
        self.category = category
        self.name = name
        self.photo_urls = photo_urls
        self.tags = tags
        self.status = status
