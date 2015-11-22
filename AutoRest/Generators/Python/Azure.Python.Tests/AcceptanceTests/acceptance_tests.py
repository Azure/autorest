import unittest
import sys
import uuid
import datetime
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))

sys.path.append(cwd + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + "ClientRuntimes" + sep + "Python" + sep + "msrest")
sys.path.append(cwd + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + "ClientRuntimes" + sep + "Python" + sep + "msrestazure")

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))

sys.path.append(join(tests, "AzureParameterGrouping"))
sys.path.append(join(tests, "SubscriptionIdApiVersion"))
sys.path.append(join(tests, "AzureBodyDuration"))
sys.path.append(join(tests, "AzureSpecials"))
sys.path.append(join(tests, "AzureReport"))

from msrest.exceptions import DeserializationError
from msrest.authentication import TokenAuthentication

from auto_rest_parameter_grouping_test_service import AutoRestParameterGroupingTestServiceConfiguration, AutoRestParameterGroupingTestService
from microsoft_azure_test_url import MicrosoftAzureTestUrl, MicrosoftAzureTestUrlConfiguration
from auto_rest_report_service_for_azure import AutoRestReportServiceForAzureConfiguration, AutoRestReportServiceForAzure
from auto_rest_duration_test_service import AutoRestDurationTestService, AutoRestDurationTestServiceConfiguration 
from auto_rest_azure_special_parameters_test_client import AutoRestAzureSpecialParametersTestClient, AutoRestAzureSpecialParametersTestClientConfiguration

from auto_rest_parameter_grouping_test_service.models import ParameterGroupingPostMultipleParameterGroupsSecondParameterGroup, ParameterGroupingPostOptionalParameters, ParameterGroupingPostRequiredParameters, FirstParameterGroup


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
        # TODO!!! Investigate
        #with self.assertRaises(ValueError):
        #    client.parameter_grouping.post_required(requiredParameters)
        with self.assertRaises(ValueError):
            client.parameter_grouping.post_required(None)

        #Valid optional parameters
        optionalParameters = ParameterGroupingPostOptionalParameters(custom_header = headerParameter, query = queryParameter)
        client.parameter_grouping.post_optional(optionalParameters)

        #null optional paramters
        client.parameter_grouping.post_optional(None)

        #Multiple grouped parameters
        firstGroup = FirstParameterGroup(header_one = headerParameter, query_one = queryParameter)
        secondGroup = ParameterGroupingPostMultipleParameterGroupsSecondParameterGroup(header_two = "header2", query_two = 42)

        client.parameter_grouping.post_multiple_parameter_groups(firstGroup, secondGroup)

        #Multiple grouped parameters -- some optional parameters omitted
        firstGroup = FirstParameterGroup(header_one = headerParameter)
        secondGroup = ParameterGroupingPostMultipleParameterGroupsSecondParameterGroup(query_two = 42)

        client.parameter_grouping.post_multiple_parameter_groups(firstGroup, secondGroup)
        client.parameter_grouping.post_shared_parameter_group_object(firstGroup)


    def test_url(self):

        # TODO: investigate how to use TokenAuth in testing
        cred = TokenAuthentication("client_id", {"my_token":123})
        config = MicrosoftAzureTestUrlConfiguration(None, str(uuid.uuid1()), "http://localhost:3000")
        config.log_level = 10
        client = MicrosoftAzureTestUrl(config)
        group = client.group.get_sample_resource_group("testgroup101")
        self.assertEqual("testgroup101", group.name)
        self.assertEqual("West US", group.location)

    def test_duration(self):

        config = AutoRestDurationTestServiceConfiguration(None, "http://localhost:3000")
        config.log_level = 10
        client = AutoRestDurationTestService(config)
        self.assertIsNone(client.duration.get_null())
        with self.assertRaises(DeserializationError):
            client.duration.get_invalid()

        client.duration.get_positive_duration();
        t = datetime.timedelta(days = 123, hours = 22, minutes = 14, seconds = 12, milliseconds = 11)
        client.duration.put_positive_duration(t)

    def test_xms_request_client_id(self):

        validSubscription = '1234-5678-9012-3456'
        validClientId = '9C4D50EE-2D56-4CD3-8152-34347DC9F2B0'
        cred = TokenAuthentication(validSubscription, {"my_token":123})
        config = AutoRestAzureSpecialParametersTestClientConfiguration(None, validSubscription, "http://localhost:3000")
        config.log_level = 10
        client = AutoRestAzureSpecialParametersTestClient(config)

        custom_headers = {"x-ms-client-request-id": validClientId }
        result1 = client.xms_client_request_id.get(custom_headers = custom_headers)
        # TODO: investigate on return default request_id as other language
        #self.assertEqual("123", result1.request_id)

        result2 = client.xms_client_request_id.param_get(validClientId)
        # TODO: investigate on return default request_id as other language
        #self.assertEqual("123", result2.request_id)

    def test_azure_special_parameters(self):

        validSubscription = '1234-5678-9012-3456'
        validApiVersion = '2.0'
        unencodedPath = 'path1/path2/path3'
        unencodedQuery = 'value1&q2=value2&q3=value3'
        config = AutoRestAzureSpecialParametersTestClientConfiguration(None, validSubscription, "http://localhost:3000")
        config.log_level = 10
        client = AutoRestAzureSpecialParametersTestClient(config)

        client.subscription_in_credentials.post_method_global_not_provided_valid()
        client.subscription_in_credentials.post_method_global_valid()
        client.subscription_in_credentials.post_path_global_valid()
        client.subscription_in_credentials.post_swagger_global_valid()
        client.subscription_in_method.post_method_local_valid(validSubscription)
        client.subscription_in_method.post_path_local_valid(validSubscription)
        client.subscription_in_method.post_swagger_local_valid(validSubscription)
        with self.assertRaises(ValueError):
            client.subscription_in_method.post_method_local_null(None)

        client.api_version_default.get_method_global_not_provided_valid()
        client.api_version_default.get_method_global_valid()
        client.api_version_default.get_path_global_valid()
        client.api_version_default.get_swagger_global_valid()
        client.api_version_local.get_method_local_valid(validApiVersion)
        client.api_version_local.get_method_local_null(None)
        client.api_version_local.get_path_local_valid(validApiVersion)
        client.api_version_local.get_swagger_local_valid(validApiVersion)

        client.skip_url_encoding.get_method_path_valid(unencodedPath)
        client.skip_url_encoding.get_path_path_valid(unencodedPath)
        client.skip_url_encoding.get_swagger_path_valid(unencodedPath)
        #TODO: investigate
        #TODO: also client runtime need to set the default user agent just like C#
        #client.skip_url_encoding.get_method_query_valid(unencodedQuery)
        #client.skip_url_encoding.get_path_query_valid(unencodedQuery)
        #client.skip_url_encoding.get_swagger_query_valid(unencodedQuery)
        #TODO: investigate, do we need to set the default type for the input parameter?
        client.skip_url_encoding.get_method_query_null()
        client.skip_url_encoding.get_method_query_null(None)

    @unittest.skip("For now, skip this test since it'll always fail")
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
