# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class Usage(Model):
    """
    Describes Storage Resource Usage.

    :param str unit: Gets the unit of measurement. Possible values include:
     'Count', 'Bytes', 'Seconds', 'Percent', 'CountsPerSecond',
     'BytesPerSecond'
    :param int current_value: Gets the current count of the allocated
     resources in the subscription.
    :param int limit: Gets the maximum count of the resources that can be
     allocated in the subscription.
    :param UsageName name: Gets the name of the type of usage.
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

    def __init__(self, unit, current_value, limit, name, **kwargs):
        self.unit = unit
        self.current_value = current_value
        self.limit = limit
        self.name = name
