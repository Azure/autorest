# --------------------------------------------------------------------------
#
# Copyright (c) Microsoft Corporation. All rights reserved.
#
# The MIT License (MIT)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the ""Software""), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
# --------------------------------------------------------------------------

import sys

from requests import RequestException

from . import logger


def raise_with_traceback(exception, message="", *args):
    """Raise exception with a specified traceback.

    :param Exception exception: Error type to be raised.
    :param str message: Message to include with error, empty by default.
    :param args: Any additional args to be included with exception.
    """
    exc_type, exc_value, exc_traceback = sys.exc_info()
    exc_msg = "{}, {}: {}".format(message, exc_type.__name__, exc_value)
    error = exception(exc_msg, *args)
    try:
        raise error.with_traceback(exc_traceback)
    except AttributeError:
        error.__traceback__ = exc_traceback
        raise error


class ClientException(Exception):
    """Base exception for all Client Runtime exceptions."""

    def __init__(self, message, inner_exception=None, *args):
        self.inner_exception = inner_exception
        logger.LOGGER.debug(message)
        super(ClientException, self).__init__(message, *args)


class SerializationError(ClientException):
    """Error raised during request serialization."""
    pass


class DeserializationError(ClientException):
    """Error raised during response deserialization."""
    pass


class TokenExpiredError(ClientException):
    """OAuth token expired, request failed."""
    pass


class ClientRequestError(ClientException):
    """Client request failed."""
    pass


class AuthenticationError(ClientException):
    """Client request failed to authentication."""
    pass


class HttpOperationError(ClientException):
    """Client request failed due to server-specificed HTTP operation error.
    Attempts to deserialize response into specific error object.

    :param Deserializer deserialize: Deserializer with data on custom
     error objects.
    :param requests.Response response: Server response
    :param str resp_type: Objects type to deserialize response.
    :param args: Additional args to pass to exception object.
    """

    def __str__(self):
        return str(self.message)

    def __init__(self, deserialize, response, resp_type=None, *args):
        self.error = None
        self.message = None
        self.response = response
        try:
            if resp_type:
                self.error = deserialize(resp_type, response)
                if self.error is None:
                    self.error = deserialize.dependencies[resp_type]()
                self.message = self.error.message
        except (DeserializationError, AttributeError, KeyError):
            pass

        if not self.error or not self.message:
            try:
                response.raise_for_status()
            except RequestException as err:
                if not self.error:
                    self.error = err

                if not self.message:
                    msg = "Operation returned an invalid status code {!r}"
                    self.message = msg.format(response.reason)
            else:
                if not self.error:
                    self.error = response

                if not self.message:
                    self.message = "Unknown error"

        super(HttpOperationError, self).__init__(
            self.message, self.error, *args)
