import unittest
import sys
import uuid
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))

sys.path.append(cwd + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + "ClientRuntimes" + sep + "Python" + sep + "msrest")
sys.path.append(cwd + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + "ClientRuntimes" + sep + "Python" + sep + "msrestazure")

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))

sys.path.append(join(tests, "AzureParameterGrouping"))
sys.path.append(join(tests, "SubscriptionIdApiVersion"))
sys.path.append(join(tests, "AzureReport"))

from msrest.exceptions import DeserializationError
from msrest.authentication import TokenAuthentication

from auto_rest_parameter_grouping_test_service import AutoRestParameterGroupingTestServiceConfiguration, AutoRestParameterGroupingTestService
from microsoft_azure_test_url import MicrosoftAzureTestUrl, MicrosoftAzureTestUrlConfiguration
from auto_rest_report_service_for_azure import AutoRestReportServiceForAzureConfiguration, AutoRestReportServiceForAzure

from auto_rest_parameter_grouping_test_service.models import ParameterGroupingPostMultipleParameterGroupsSecondParameterGroup, ParameterGroupingPostOptionalParameters, ParameterGroupingPostRequiredParameters


class AcceptanceTests(unittest.TestCase):

    def test_parameter_grouping(self):

        bodyParameter = 1234
        headerParameter = 'header'
        queryParameter = 21
        pathParameter = 'path'

        config = AutoRestParameterGroupingTestServiceConfiguration(None, "http://localhost:3000")
        config.log_level = 10
        client = AutoRestParameterGroupingTestService(config)

        # Valid required parameters
        requiredParameters = ParameterGroupingPostRequiredParameters(body = bodyParameter, path = pathParameter, custom_header = headerParameter, query = queryParameter)
        client.parameter_grouping.post_required(requiredParameters)

        #Required parameters but null optional parameters
        requiredParameters = ParameterGroupingPostRequiredParameters(body = bodyParameter, path = pathParameter)
        client.parameter_grouping.post_required(requiredParameters)

        #Required parameters object is not null, but a required property of the object is
        requiredParameters = ParameterGroupingPostRequiredParameters(body = None, path = pathParameter)
        with self.assertRaises(ValueException):
            client.parameter_grouping.post_required(requiredParameters)
        with self.assertRaises(ValueException):
            client.parameter_grouping.post_required(None)
        pass

    def test_url(self):
        cred = TokenAuthentication("client_id", {"my_token":123})
        config = MicrosoftAzureTestUrlConfiguration(None, str(uuid.uuid1()), "http://localhost:3000")
        config.log_level = 10
        client = MicrosoftAzureTestUrl(config)
        group = client.group.get_sample_resource_group("testgroup101")
        self.assertEqual("testgroup101", group.name)
        self.assertEqual("West US", group.location)
        pass

    def test_ensure_coverage(self):

        config = AutoRestReportServiceForAzureConfiguration(None, "http://localhost:3000")
        config.log_level = 10
        client = AutoRestReportServiceForAzure(config)
        report = client.get_report()
        skipped = [k for k, v in report.items() if v == 0]

        for s in skipped:
            print "SKIPPED {0}".format(s)

        totalTests = len(report)
        print ("The test coverage is {0}/{1}.".format(totalTests - len(skipped), totalTests))
        self.assertEqual(0, len(skipped))

if __name__ == '__main__':
    unittest.main()
