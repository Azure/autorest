# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class Usage(Model):
    """
    Describes Storage Resource Usage.

    :param unit: Gets the unit of measurement. Possible values include:
     'Count', 'Bytes', 'Seconds', 'Percent', 'CountsPerSecond',
     'BytesPerSecond'
    :type unit: str or :class:`UsageUnit
     <storagemanagementclient.models.UsageUnit>`
    :param current_value: Gets the current count of the allocated resources
     in the subscription.
    :type current_value: int
    :param limit: Gets the maximum count of the resources that can be
     allocated in the subscription.
    :type limit: int
    :param name: Gets the name of the type of usage.
    :type name: :class:`UsageName <petstore.models.UsageName>`
    """ 

    _validation = {
        'unit': {'required': True},
        'current_value': {'required': True},
        'limit': {'required': True},
        'name': {'required': True},
    }

    _attribute_map = {
        'unit': {'key': 'unit', 'type': 'UsageUnit'},
        'current_value': {'key': 'currentValue', 'type': 'int'},
        'limit': {'key': 'limit', 'type': 'int'},
        'name': {'key': 'name', 'type': 'UsageName'},
    }

    def __init__(self, unit, current_value, limit, name):
        self.unit = unit
        self.current_value = current_value
        self.limit = limit
        self.name = name
