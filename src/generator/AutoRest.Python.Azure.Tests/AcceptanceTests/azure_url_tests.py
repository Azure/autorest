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
sys.modules['fixtures'].__path__.append(join(tests, "SubscriptionIdApiVersion", "fixtures"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrest.authentication import BasicTokenAuthentication

from fixtures.acceptancetestssubscriptionidapiversion import MicrosoftAzureTestUrl

from fixtures.acceptancetestssubscriptionidapiversion.models import ErrorException, SampleResourceGroup

class AzureUrlTests(unittest.TestCase):

    def test_azure_url(self):

        sub_id = str(uuid4())
        client_id = str(uuid4())

        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        client = MicrosoftAzureTestUrl(cred, sub_id, base_url="http://localhost:3000")

        group = client.group.get_sample_resource_group("testgoup101")
        self.assertEqual(group.name, "testgroup101")
        self.assertEqual(group.location, "West US")


if __name__ == '__main__':
    unittest.main()
