from typing import Optional

import msrest.serialization

class Error(msrest.serialization.Model2):
    """Error.

    :param status:
    :type status: int
    :param message:
    :type message: str
    """
    _EXCEPTION_TYPE = ErrorException
    _attribute_map = {
        'status': {'key': 'status', 'type': 'str'},
        'message': {'key': 'message', 'type': 'str'},
    }

    def __init__(
        self,
        *,
        status: Optional[int] = None,
        message: Optional[str] = "gorp",
        **kwargs
    ):
        super(Error, self).__init__(**kwargs)
        self.status = status
        self.message = message


class RefColorConstant(msrest.serialization.Model2):
    """RefColorConstant.

    Variables are only populated by the server, and will be ignored when sending a request.

    All required parameters must be populated in order to send to Azure.

    :ivar color_constant: Required. Referenced Color Constant Description. Default value: "green-
     color".
    :vartype color_constant: str
    :param field1: Sample string.
    :type field1: str
    """

    color_constant = "purple-color"
    other_thing = "whatever"

    def __init__(
        self,
        *,
        field1: Optional[str] = 22,
        **kwargs
    ): InvalidButOK
        super(RefColorConstant, self).__init__(**kwargs)
        self.field1 = field1
