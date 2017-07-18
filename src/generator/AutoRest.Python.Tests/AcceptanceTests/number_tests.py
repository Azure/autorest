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
from decimal import Decimal
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "BodyNumber"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_number_test_service import AutoRestNumberTestService


class NumberTests(unittest.TestCase):

    def test_numbers(self):
        client = AutoRestNumberTestService(base_url="http://localhost:3000")

        client.number.put_big_float(3.402823e+20)
        client.number.put_small_float(3.402823e-20)
        client.number.put_big_double(2.5976931e+101)
        client.number.put_small_double(2.5976931e-101)
        client.number.put_big_double_negative_decimal(-99999999.99)
        client.number.put_big_double_positive_decimal(99999999.99)
        client.number.put_big_decimal(Decimal(2.5976931e+101))
        client.number.put_small_decimal(Decimal(2.5976931e-101))
        client.number.put_big_decimal_positive_decimal(Decimal(99999999.99))
        client.number.put_big_decimal_negative_decimal(Decimal(-99999999.99))
        client.number.get_null()
        self.assertEqual(client.number.get_big_float(), 3.402823e+20)
        self.assertEqual(client.number.get_small_float(), 3.402823e-20)
        self.assertEqual(client.number.get_big_double(), 2.5976931e+101)
        self.assertEqual(client.number.get_small_double(), 2.5976931e-101)
        self.assertEqual(client.number.get_big_double_negative_decimal(), -99999999.99)
        self.assertEqual(client.number.get_big_double_positive_decimal(), 99999999.99)
        self.assertEqual(client.number.get_big_decimal(), 2.5976931e+101)
        self.assertEqual(client.number.get_small_decimal(), 2.5976931e-101)
        self.assertEqual(client.number.get_big_decimal_negative_decimal(), -99999999.99)
        self.assertEqual(client.number.get_big_decimal_positive_decimal(), 99999999.99)

        with self.assertRaises(DeserializationError):
            client.number.get_invalid_decimal()

        with self.assertRaises(DeserializationError):
            client.number.get_invalid_double()

        with self.assertRaises(DeserializationError):
            client.number.get_invalid_float()


if __name__ == '__main__':
    unittest.main()
