from typing import Optional

import msrest.serialization

class Error(msrest.serialization.Model):
    """Error.

    :param status:
    :type status: int
    :param message:
    :type message: str
    """

    _attribute_map = {
        'status': {'key': 'status', 'type': 'int'},
        'message': {'key': 'message', 'type': 'str'},
    }

    def __init__(
        self,
        *,
        status: Optional[int] = None,
        message: Optional[str] = None,
        **kwargs
    ):
        super(Error, self).__init__(**kwargs)
        self.status = status
        self.message = message


class RefColorConstant(msrest.serialization.Model):
    """RefColorConstant.

    Variables are only populated by the server, and will be ignored when sending a request.

    All required parameters must be populated in order to send to Azure.

    :ivar color_constant: Required. Referenced Color Constant Description. Default value: "green-
     color".
    :vartype color_constant: str
    :param field1: Sample string.
    :type field1: str
    """

    color_constant = "green-color"

    def __init__(
        self,
        *,
        field1: Optional[str] = None,
        **kwargs
    ):
        super(RefColorConstant, self).__init__(**kwargs)
        self.field1 = field1
