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

from .serialization import Deserializer
try:
    from urlparse import urlparse

except ImportError:
    from urllib.parse import urlparse


class Paged(object):

    def __init__(self, response, command, classes):
        """
        A collection for paged REST responses.
        """
        self.next_link = None
        self.items = []

        self.derserializer = Deserializer(classes)
        self.derserializer(self, response)

        self.command = command

    def __iter__(self):
        for i in self.items:
            yield i

        while self.next_link is not None:
            self._validate_url()
            response = self.command(self.next_link)
            self.derserializer(self, response)

            for i in self.items:
                yield i

    def __len__(self):
        return len(self.items)

    def __getitem__(self, index):
        return self.items[index]

    def _validate_url(self):
        parsed = urlparse(self.next_link)
        if not parsed.scheme or not parsed.netloc:
            raise ValueError("Invalid URL: {}".format(self.next_link))
