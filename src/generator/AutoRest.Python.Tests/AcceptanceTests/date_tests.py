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
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "BodyDate"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_date_test_service import AutoRestDateTestService


class DateTests(unittest.TestCase):

    def test_date(self):
        client = AutoRestDateTestService(base_url="http://localhost:3000")

        max_date = isodate.parse_date("9999-12-31T23:59:59.999999Z")
        min_date = isodate.parse_date("0001-01-01T00:00:00Z")
        client.date_model.put_max_date(max_date)
        client.date_model.put_min_date(min_date)

        self.assertEqual(max_date, client.date_model.get_max_date())
        self.assertEqual(min_date, client.date_model.get_min_date())
        self.assertIsNone(client.date_model.get_null())

        # Python isodate.parse support too wild input, and won't raise error
        #with self.assertRaises(DeserializationError):
        #    client.date_model.get_invalid_date()

        with self.assertRaises(DeserializationError):
            client.date_model.get_overflow_date()

        with self.assertRaises(DeserializationError):
            client.date_model.get_underflow_date()

if __name__ == '__main__':
    unittest.main()
