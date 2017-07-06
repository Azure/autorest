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

"""
This file needs to be modified everytime other tests are updated. This is
because unittest:TestLoader:discover() loads file in the order of last
modified timestamp. We need a better way of sorting the test files.
"""
import unittest
import sys
import datetime
import os
from uuid import uuid4
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
log_level = int(os.environ.get('PythonLogLevel', 30))

import fixtures # Ensure that fixtures is loaded on old python before the next line
tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.modules['fixtures'].__path__.append(join(tests, "AzureReport", "fixtures"))

from msrest.exceptions import DeserializationError

from fixtures.acceptancetestsazurereport import AutoRestReportServiceForAzure
from msrest.authentication import BasicTokenAuthentication


class AcceptanceTests(unittest.TestCase):


    def test_ensure_coverage(self):

        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        client = AutoRestReportServiceForAzure(cred, base_url="http://localhost:3000")
        report = client.get_report()

        skipped = [k for k, v in report.items() if v == 0]

        for s in skipped:
            print("SKIPPED {0}".format(s))

        totalTests = len(report)
        print("The test coverage is {0}/{1}.".format(totalTests - len(skipped), totalTests))
        self.assertEqual(0, len(skipped))

if __name__ == '__main__':
    unittest.main()
