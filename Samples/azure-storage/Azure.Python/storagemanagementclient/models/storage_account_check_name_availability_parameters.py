# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class StorageAccountCheckNameAvailabilityParameters(Model):
    """StorageAccountCheckNameAvailabilityParameters

    :param str name:
    :param str type:  Default value: "Microsoft.Storage/storageAccounts" .
    """ 

    _validation = {
        'name': {'required': True},
    }

    _attribute_map = {
        'name': {'key': 'name', 'type': 'str'},
        'type': {'key': 'type', 'type': 'str'},
    }

    def __init__(self, name, type="Microsoft.Storage/storageAccounts", **kwargs):
        self.name = name
        self.type = type
