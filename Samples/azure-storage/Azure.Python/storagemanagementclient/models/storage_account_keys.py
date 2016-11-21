# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountKeys(Model):
    """The access keys for the storage account.

    :param key1: Gets the value of key 1.
    :type key1: str
    :param key2: Gets the value of key 2.
    :type key2: str
    """

    _attribute_map = {
        'key1': {'key': 'key1', 'type': 'str'},
        'key2': {'key': 'key2', 'type': 'str'},
    }

    def __init__(self, key1=None, key2=None):
        self.key1 = key1
        self.key2 = key2
