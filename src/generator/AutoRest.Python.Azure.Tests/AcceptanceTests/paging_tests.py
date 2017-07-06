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

import unittest
import subprocess
import sys
import isodate
import tempfile
import json
from uuid import uuid4
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
log_level = int(os.environ.get('PythonLogLevel', 30))

import fixtures # Ensure that fixtures is loaded on old python before the next line
tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.modules['fixtures'].__path__.append(join(tests, "Paging", "fixtures"))

# Import mock from Autorest.Python.Tests
mockfiles = realpath(join(cwd, pardir, pardir, "AutoRest.Python.Tests", "AcceptanceTests"))
sys.path.append(mockfiles)

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrestazure.azure_exceptions import CloudError
from msrest.authentication import BasicTokenAuthentication

from fixtures.acceptancetestspaging import AutoRestPagingTestService
from fixtures.acceptancetestspaging.models import PagingGetMultiplePagesWithOffsetOptions

from http_tests import TestAuthentication

class PagingTests(unittest.TestCase):

    def setUp(self):
        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        self.client = AutoRestPagingTestService(cred, base_url="http://localhost:3000")
        self.client._client.creds = TestAuthentication()
        return super(PagingTests, self).setUp()

    def test_paging_happy_path(self):

        pages = self.client.paging.get_single_pages()
        items = [i for i in pages]
        self.assertIsNone(pages.next_link)
        self.assertEqual(len(items), 1)

        self.assertEqual(items[0].properties.id, 1)
        self.assertEqual(items[0].properties.name, "Product")

        pages = self.client.paging.get_multiple_pages()
        self.assertIsNotNone(pages.next_link)
        items = [i for i in pages]
        self.assertIsNone(pages.next_link)
        self.assertEqual(len(items), 10)

        pages.reset()
        more_items = [i for i in pages]
        eq = [e for e in items if e not in more_items]
        self.assertEqual(len(eq), 0)

        with self.assertRaises(StopIteration):
            next(pages)

        pages = self.client.paging.get_odata_multiple_pages()
        self.assertIsNotNone(pages.next_link)
        items = [i for i in pages]
        self.assertIsNone(pages.next_link)
        self.assertEqual(len(items), 10)

        pages = self.client.paging.get_multiple_pages_retry_first()
        self.assertIsNotNone(pages.next_link)
        items = [i for i in pages]
        self.assertIsNone(pages.next_link)
        self.assertEqual(len(items), 10)

        pages = self.client.paging.get_multiple_pages_retry_second()
        self.assertIsNotNone(pages.next_link)
        items = [i for i in pages]
        self.assertIsNone(pages.next_link)
        self.assertEqual(len(items), 10)

        pages = self.client.paging.get_single_pages(raw=True)
        items = [i for i in pages]
        self.assertIsNone(pages.next_link)
        self.assertEqual(len(items), 1)
        self.assertEqual(items, pages.raw.output)

        pages = self.client.paging.get_multiple_pages(raw=True)
        self.assertIsNotNone(pages.next_link)
        items = [i for i in pages]
        self.assertEqual(len(items), 10)
        self.assertIsNotNone(pages.raw.response)

        options = PagingGetMultiplePagesWithOffsetOptions(100)
        pages = self.client.paging.get_multiple_pages_with_offset(paging_get_multiple_pages_with_offset_options=options)
        self.assertIsNotNone(pages.next_link)
        items = [i for i in pages]
        self.assertEqual(len(items), 10)
        self.assertEqual(items[-1].properties.id, 110)

        pages = self.client.paging.get_multiple_pages_retry_first(raw=True)
        self.assertIsNotNone(pages.next_link)
        items = [i for i in pages]
        self.assertEqual(len(items), 10)

        pages = self.client.paging.get_multiple_pages_retry_second(raw=True)
        self.assertIsNotNone(pages.next_link)
        items = [i for i in pages]
        self.assertEqual(len(items), 10)

    def test_paging_sad_path(self):

        pages = self.client.paging.get_single_pages_failure()
        with self.assertRaises(CloudError):
            items = [i for i in pages]

        pages = self.client.paging.get_multiple_pages_failure()
        self.assertIsNotNone(pages.next_link)

        with self.assertRaises(CloudError):
            items = [i for i in pages]

        pages = self.client.paging.get_multiple_pages_failure_uri()

        with self.assertRaises(CloudError):
            items = [i for i in pages]

        pages = self.client.paging.get_single_pages_failure(raw=True)
        with self.assertRaises(CloudError):
            items = [i for i in pages]

        pages = self.client.paging.get_multiple_pages_failure(raw=True)
        self.assertIsNotNone(pages.next_link)

        with self.assertRaises(CloudError):
            items = [i for i in pages]

        pages = self.client.paging.get_multiple_pages_failure_uri(raw=True)

        with self.assertRaises(CloudError):
            items = [i for i in pages]

    def test_paging_fragment_path(self):

        pages = self.client.paging.get_multiple_pages_fragment_next_link("1.6", "test_user")
        items = [i for i in pages]
        self.assertIsNone(pages.next_link)
        self.assertEqual(len(items), 10)

        with self.assertRaises(AttributeError):
            self.client.paging.get_multiple_pages_fragment_next_link_next()


if __name__ == '__main__':
    unittest.main()
