#--------------------------------------------------------------------------
#
# Copyright (c) Microsoft Corporation. All rights reserved. 
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the ""Software""), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#--------------------------------------------------------------------------

import sys
from . import logger

def raise_with_traceback(exception, message="", *args):
    exc_type, exc_value, exc_traceback = sys.exc_info()
    exc_msg = " {}: {}".format(exc_type.__class__.__name__, exc_value)

    error = exception(str(message) + exc_msg, *args)

    try:
        raise error.with_traceback(exc_traceback)

    except AttributeError:
        error.__traceback__ = exc_traceback
        raise error

   
class ClientException(Exception):
    
    def __init__(self, message, inner_exception=None, *args):

        self.inner_exception = inner_exception

        logger.LOGGER.debug(message)
        super(ClientException, self).__init__(message, *args)


class SerializationError(ClientException):
    pass


class DeserializationError(ClientException):
    pass


class ResponseStatusError(ClientException):
    pass


class TokenExpiredError(ClientException):
    pass


class ClientRequestError(ClientException):
    pass


class AuthenticationError(ClientException):
    pass