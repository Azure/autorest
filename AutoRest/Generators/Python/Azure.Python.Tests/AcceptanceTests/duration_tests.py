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
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir, pardir))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrest"))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrestazure"))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "AzureBodyDuration"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrest.authentication import BasicTokenAuthentication

from auto_rest_duration_test_service import (
    AutoRestDurationTestService, 
    AutoRestDurationTestServiceConfiguration)


class DurationTests(unittest.TestCase):

    def test_duration(self):

        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        config = AutoRestDurationTestServiceConfiguration(cred, base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestDurationTestService(config)

        self.assertIsNone(client.duration.get_null())

        with self.assertRaises(DeserializationError):
            client.duration.get_invalid()

        client.duration.get_positive_duration()
        delta = timedelta(days=123, hours=22, minutes=14, seconds=12, milliseconds=11)
        client.duration.put_positive_duration(delta)


if __name__ == '__main__':
    unittest.main()