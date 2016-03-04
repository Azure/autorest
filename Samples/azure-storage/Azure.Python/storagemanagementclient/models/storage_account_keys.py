# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountKeys(Model):
    """
    The access keys for the storage account.

    :param str key1: Gets the value of key 1.
    :param str key2: Gets the value of key 2.
    """ 

    _attribute_map = {
        'key1': {'key': 'key1', 'type': 'str'},
        'key2': {'key': 'key2', 'type': 'str'},
    }

    def __init__(self, key1=None, key2=None, **kwargs):
        self.key1 = key1
        self.key2 = key2
