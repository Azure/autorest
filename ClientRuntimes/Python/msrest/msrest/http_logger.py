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

import logging
import re
import types


_LOGGER = logging.getLogger(__name__)


def log_request(adapter, request, *args, **kwargs):
    """Log a client request.

    :param ClientHTTPAdapter adapter: Adapter making the request.
    :param requests.Request request: The request object.
    """
    try:
        _LOGGER.debug("Request URL: %r", request.url)
        _LOGGER.debug("Request method: %r", request.method)
        _LOGGER.debug("Request headers:")
        for header, value in request.headers.items():
            _LOGGER.debug("    %r: %r", header, value)
        _LOGGER.debug("Request body:")

        # We don't want to log the binary data of a file upload.
        if isinstance(request.body, types.GeneratorType):
            _LOGGER.debug("File upload")
        else:
            _LOGGER.debug(str(request.body))
    except Exception as err:
        _LOGGER.debug("Failed to log request: %r", err)


def log_response(adapter, request, response, *args, **kwargs):
    """Log a server response.

    :param ClientHTTPAdapter adapter: Adapter making the request.
    :param requests.Request request: The request object.
    :param requests.Response response: The response object.
    """
    try:
        result = kwargs['result']
        _LOGGER.debug("Response status: %r", result.status_code)
        _LOGGER.debug("Response headers:")
        for header, value in result.headers.items():
            _LOGGER.debug("    %r: %r", header, value)

        # We don't want to log binary data if the response is a file.
        _LOGGER.debug("Response content:")
        pattern = re.compile(r'attachment; ?filename=["\w.]+', re.IGNORECASE)
        header = result.headers.get('content-disposition')

        if header and pattern.match(header):
            filename = header.partition('=')[2]
            _LOGGER.debug("File attachments: " + filename)
        elif result.headers.get("content-type", "").endswith("octet-stream"):
            _LOGGER.debug("Body contains binary data.")
        elif result.headers.get("content-type", "").startswith("image"):
            _LOGGER.debug("Body contains image data.")
        elif result.headers.get("transfer-encoding") == 'chunked':
            _LOGGER.debug("Body contains chunked data.")
        else:
            _LOGGER.debug(str(result.content))
        return result
    except Exception as err:
        _LOGGER.debug("Failed to log response: " + repr(err))
        return kwargs['result']
