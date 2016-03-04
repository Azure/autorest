# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class UsageName(Model):
    """
    The Usage Names.

    :param str value: Gets a string describing the resource name.
    :param str localized_value: Gets a localized string describing the
     resource name.
    """ 

    _attribute_map = {
        'value': {'key': 'value', 'type': 'str'},
        'localized_value': {'key': 'localizedValue', 'type': 'str'},
    }

    def __init__(self, value=None, localized_value=None, **kwargs):
        self.value = value
        self.localized_value = localized_value
