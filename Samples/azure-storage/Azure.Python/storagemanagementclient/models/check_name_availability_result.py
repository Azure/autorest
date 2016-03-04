# coding=utf-8
# --------------------------------------------------------------------------
# --------------------------------------------------------------------------

from msrest.serialization import Model


class CheckNameAvailabilityResult(Model):
    """
    The CheckNameAvailability operation response.

    :param bool name_available: Gets a boolean value that indicates whether
     the name is available for you to use. If true, the name is available. If
     false, the name has already been taken or invalid and cannot be used.
    :param str reason: Gets the reason that a storage account name could not
     be used. The Reason element is only returned if NameAvailable is false.
     Possible values include: 'AccountNameInvalid', 'AlreadyExists'
    :param str message: Gets an error message explaining the Reason value in
     more detail.
    """ 

    _attribute_map = {
        'name_available': {'key': 'nameAvailable', 'type': 'bool'},
        'reason': {'key': 'reason', 'type': 'Reason'},
        'message': {'key': 'message', 'type': 'str'},
    }

    def __init__(self, name_available=None, reason=None, message=None, **kwargs):
        self.name_available = name_available
        self.reason = reason
        self.message = message
