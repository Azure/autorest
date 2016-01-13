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

try:
    from urlparse import urlparse
except ImportError:
    from urllib.parse import urlparse

from .serialization import Deserializer
from .pipeline import ClientRawResponse


class Paged(object):
    """A container for paged REST responses."""

    def __init__(self, command, classes, raw_headers={}):
        """Paged response.

        :param requests.Response response: server response object.
        :param callable command: Function to retrieve the next page of items.
        :param dict classes: A dictionary of class dependencies for
         deserialization.
        """
        self.next_link = ""
        self.items = []
        self._derserializer = Deserializer(classes)
        self._get_next = command
        self._response = None
        self._raw_headers = raw_headers

    def __iter__(self):
        """Iterate over response items, automatically retrieves
        next page.
        """
        for i in self.items:
            yield i

        while self.next_link is not None:
            for i in self.next():
                yield i

    def __len__(self):
        """Returnds length of items in current page."""
        return len(self.items)

    def __getitem__(self, index):
        """Get indexed item on current page."""
        return self.items[index]

    def _validate_url(self):
        """Validate next page URL."""
        if self.next_link:
            parsed = urlparse(self.next_link)
            if not parsed.scheme or not parsed.netloc:
                raise ValueError("Invalid URL: " + self.next_link)

    @property
    def raw(self):
        raw = ClientRawResponse(self.items, self._response)
        raw.add_headers(self._raw_headers)
        return raw

    def get(self, url):
        """Get arbitrary page.

        :param str url: URL to arbitrary page results.
        """
        self.next_link = url
        return self.next()

    def reset(self):
        """Reset iterator to first page."""
        self.next_link = ""
        self.items = []

    def next(self):
        """Get next page."""
        if self.next_link is None:
            raise GeneratorExit("End of paging")
        self._validate_url()
        self._response = self._get_next(self.next_link)
        self._derserializer(self, self._response)
        return self.items
