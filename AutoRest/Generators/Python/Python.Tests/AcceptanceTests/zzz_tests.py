﻿# --------------------------------------------------------------------------
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
import isodate
import subprocess
import sys
import datetime
import os
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir, pardir))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrest"))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Report"))


from autorestreportservice import (
    AutoRestReportService, 
    AutoRestReportServiceConfiguration)


class AcceptanceTests(unittest.TestCase):
    def test_ensure_coverage(self):

        config = AutoRestReportServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestReportService(config)
        report = client.get_report()

        not_supported = {
            'getIntegerOverflow': 1,
            'getIntegerUnderflow': 1,
            'getLongOverflow': 1,
            'getLongUnderflow': 1,
            'getDateInvalid': 1,
            'getDictionaryNullkey': 1,
            'HttpRedirect300Get': 1,
        }

        # TODO: Support ignore readonly property in http put
        missing_features_or_bugs = {
            'putComplexReadOnlyPropertyValid': 1,
        }

        report.update(not_supported)
        report.update(missing_features_or_bugs)
        failed = [k for k, v in report.items() if v == 0]

        for s in not_supported.keys():
            print("IGNORING {0}".format(s))

        for s in missing_features_or_bugs.keys():
            print("PENDING {0}".format(s))

        for s in failed:
            print("FAILED TO EXECUTE {0}".format(s))

        totalTests = len(report)
        print ("The test coverage is {0}/{1}.".format(totalTests - len(failed), totalTests))
        
        self.assertEqual(0, len(failed))

if __name__ == '__main__':
    unittest.main()
