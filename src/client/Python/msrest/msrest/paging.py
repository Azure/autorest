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

import collections
try:
    from urlparse import urlparse
except ImportError:
    from urllib.parse import urlparse

from .serialization import Deserializer
from .pipeline import ClientRawResponse


class Paged(collections.Iterable):
    """A container for paged REST responses.

    :param requests.Response response: server response object.
    :param callable command: Function to retrieve the next page of items.
    :param dict classes: A dictionary of class dependencies for
     deserialization.
    """
    _validation = {}
    _attribute_map = {}

    def __init__(self, command, classes, raw_headers=None):
        self.next_link = ""
        self.current_page = []
        self._derserializer = Deserializer(classes)
        self._get_next = command
        self._response = None
        self._raw_headers = raw_headers

    def __iter__(self):
        """Iterate over response items in current page, automatically
        retrieves next page.
        """
        for i in self.current_page:
            yield i

        while self.next_link is not None:
            for i in self.next():
                yield i

    @classmethod
    def _get_subtype_map(cls):
        """Required for parity to Model object for deserialization."""
        return {}

    @property
    def raw(self):
        raw = ClientRawResponse(self.current_page, self._response)
        if self._raw_headers:
            raw.add_headers(self._raw_headers)
        return raw

    def _validate_url(self):
        """Validate next page URL."""
        if self.next_link:
            parsed = urlparse(self.next_link)
            if not parsed.scheme or not parsed.netloc:
                raise ValueError("Invalid URL: " + self.next_link)

    def get(self, url):
        """Get arbitrary page.

        :param str url: URL to arbitrary page results.
        """
        self.next_link = url
        return self.next()

    def reset(self):
        """Reset iterator to first page."""
        self.next_link = ""
        self.current_page = []

    def next(self):
        """Get next page."""
        if self.next_link is None:
            raise GeneratorExit("End of paging")
        self._validate_url()
        self._response = self._get_next(self.next_link)
        self._derserializer(self, self._response)
        return self.current_page
