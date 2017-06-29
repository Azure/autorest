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
sys.modules['fixtures'].__path__.append(join(tests, "AzureParameterGrouping", "fixtures"))
sys.modules['fixtures'].__path__.append(join(tests, "SubscriptionIdApiVersion", "fixtures"))
sys.modules['fixtures'].__path__.append(join(tests, "AzureBodyDuration", "fixtures"))
sys.modules['fixtures'].__path__.append(join(tests, "AzureSpecials", "fixtures"))

from msrest.exceptions import DeserializationError, ValidationError

from fixtures.acceptancetestsazureparametergrouping import AutoRestParameterGroupingTestService
from fixtures.acceptancetestssubscriptionidapiversion import MicrosoftAzureTestUrl
from fixtures.acceptancetestsazurebodyduration import AutoRestDurationTestService
from fixtures.acceptancetestsazurespecials import AutoRestAzureSpecialParametersTestClient

from fixtures.acceptancetestsazureparametergrouping.models import (
    ParameterGroupingPostMultiParamGroupsSecondParamGroup,
    ParameterGroupingPostOptionalParameters,
    ParameterGroupingPostRequiredParameters,
    FirstParameterGroup)

from msrest.authentication import BasicTokenAuthentication



class ParameterTests(unittest.TestCase):

    def test_parameter_grouping(self):

        bodyParameter = 1234
        headerParameter = 'header'
        queryParameter = 21
        pathParameter = 'path'

        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        client = AutoRestParameterGroupingTestService(cred, base_url="http://localhost:3000")

        # Valid required parameters
        requiredParameters = ParameterGroupingPostRequiredParameters(body=bodyParameter, path=pathParameter, custom_header=headerParameter, query=queryParameter)
        client.parameter_grouping.post_required(requiredParameters)

        #Required parameters but null optional parameters
        requiredParameters = ParameterGroupingPostRequiredParameters(body=bodyParameter, path=pathParameter, query=None)
        client.parameter_grouping.post_required(requiredParameters)

        #Required parameters object is not null, but a required property of the object is
        requiredParameters = ParameterGroupingPostRequiredParameters(body = None, path = pathParameter)

        with self.assertRaises(ValidationError):
            client.parameter_grouping.post_required(requiredParameters)
        with self.assertRaises(ValidationError):
            client.parameter_grouping.post_required(None)

        #Valid optional parameters
        optionalParameters = ParameterGroupingPostOptionalParameters(custom_header = headerParameter, query = queryParameter)
        client.parameter_grouping.post_optional(optionalParameters)

        #null optional paramters
        client.parameter_grouping.post_optional(None)

        #Multiple grouped parameters
        firstGroup = FirstParameterGroup(header_one = headerParameter, query_one = queryParameter)
        secondGroup = ParameterGroupingPostMultiParamGroupsSecondParamGroup(header_two = "header2", query_two = 42)

        client.parameter_grouping.post_multi_param_groups(firstGroup, secondGroup)

        #Multiple grouped parameters -- some optional parameters omitted
        firstGroup = FirstParameterGroup(header_one = headerParameter)
        secondGroup = ParameterGroupingPostMultiParamGroupsSecondParamGroup(query_two = 42)

        client.parameter_grouping.post_multi_param_groups(firstGroup, secondGroup)
        client.parameter_grouping.post_shared_parameter_group_object(firstGroup)

    def test_azure_special_parameters(self):

        validSubscription = '1234-5678-9012-3456'
        validApiVersion = '2.0'
        unencodedPath = 'path1/path2/path3'
        unencodedQuery = 'value1&q2=value2&q3=value3'
        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        client = AutoRestAzureSpecialParametersTestClient(cred, validSubscription, base_url="http://localhost:3000")

        client.subscription_in_credentials.post_method_global_not_provided_valid()
        client.subscription_in_credentials.post_method_global_valid()
        client.subscription_in_credentials.post_path_global_valid()
        client.subscription_in_credentials.post_swagger_global_valid()
        client.subscription_in_method.post_method_local_valid(validSubscription)
        client.subscription_in_method.post_path_local_valid(validSubscription)
        client.subscription_in_method.post_swagger_local_valid(validSubscription)
        with self.assertRaises(ValidationError):
            client.subscription_in_method.post_method_local_null(None)

        client.api_version_default.get_method_global_not_provided_valid()
        client.api_version_default.get_method_global_valid()
        client.api_version_default.get_path_global_valid()
        client.api_version_default.get_swagger_global_valid()
        client.api_version_local.get_method_local_valid()
        client.api_version_local.get_method_local_null()
        client.api_version_local.get_path_local_valid()
        client.api_version_local.get_swagger_local_valid()

        client.skip_url_encoding.get_method_path_valid(unencodedPath)
        client.skip_url_encoding.get_path_path_valid(unencodedPath)
        client.skip_url_encoding.get_swagger_path_valid()
        client.skip_url_encoding.get_method_query_valid(unencodedQuery)
        client.skip_url_encoding.get_path_query_valid(unencodedQuery)
        client.skip_url_encoding.get_swagger_query_valid()
        client.skip_url_encoding.get_method_query_null()
        client.skip_url_encoding.get_method_query_null(None)

    def test_azure_odata(self):

        validSubscription = '1234-5678-9012-3456'
        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        client = AutoRestAzureSpecialParametersTestClient(cred, validSubscription, base_url="http://localhost:3000")
        client.odata.get_with_filter(filter="id gt 5 and name eq 'foo'", top=10, orderby="id")


if __name__ == '__main__':
    unittest.main()
