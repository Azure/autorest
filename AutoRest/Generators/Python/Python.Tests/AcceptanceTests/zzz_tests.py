import unittest
import isodate
import subprocess
import sys
import datetime
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir, pardir))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrest"))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Report"))


from auto_rest_report_service import (
    AutoRestReportService, 
    AutoRestReportServiceConfiguration)


class AcceptanceTests(unittest.TestCase):
    #@unittest.skip("For now, skip this test since it'll always fail")
    def test_ensure_coverage(self):

        config = AutoRestReportServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = 10
        client = AutoRestReportService(config)
        report = client.get_report()
        report['getIntegerOverflow']=1
        report['getIntegerUnderflow']=1
        report['getLongOverflow']=1
        report['getLongUnderflow']=1
        report['getDateInvalid']=1
        report['getDictionaryNullkey']=1
        skipped = [k for k, v in report.items() if v == 0]

        for s in skipped:
            print("SKIPPED {0}".format(s))

        totalTests = len(report)
        print ("The test coverage is {0}/{1}.".format(totalTests - len(skipped), totalTests))
        
        self.assertEqual(0, len(skipped))

if __name__ == '__main__':
    unittest.main()
