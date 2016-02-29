# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountRegenerateKeyParameters(Model):
    """StorageAccountRegenerateKeyParameters

    :param str key_name:
    """

    _required = ['key_name']

    _attribute_map = {
        'key_name': {'key': 'keyName', 'type': 'str'},
    }

    def __init__(self, key_name):
        self.key_name = key_name
