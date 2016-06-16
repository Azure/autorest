# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountRegenerateKeyParameters(Model):
    """StorageAccountRegenerateKeyParameters.

    :param key_name:
    :type key_name: str
    """ 

    _validation = {
        'key_name': {'required': True},
    }

    _attribute_map = {
        'key_name': {'key': 'keyName', 'type': 'str'},
    }

    def __init__(self, key_name):
        self.key_name = key_name
