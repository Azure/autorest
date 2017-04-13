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
sys.path.append(join(tests, "ModelFlattening"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError

from auto_rest_resource_flattening_test_service import AutoRestResourceFlatteningTestService
from auto_rest_resource_flattening_test_service.models import (
    FlattenedProduct,
    ErrorException,
    ResourceCollection,
    SimpleProduct,
    FlattenParameterGroup)

class ModelFlatteningTests(unittest.TestCase):

    def setUp(self):
        self.client = AutoRestResourceFlatteningTestService(base_url="http://localhost:3000")
        return super(ModelFlatteningTests, self).setUp()

    def test_flattening_array(self):

        #Array
        result = self.client.get_array()
        self.assertEqual(3, len(result))
        # Resource 1
        self.assertEqual("1", result[0].id)
        self.assertEqual("OK", result[0].provisioning_state_values)
        self.assertEqual("Product1", result[0].pname)
        self.assertEqual("Flat", result[0].flattened_product_type)
        self.assertEqual("Building 44", result[0].location)
        self.assertEqual("Resource1", result[0].name)
        self.assertEqual("Succeeded", result[0].provisioning_state)
        self.assertEqual("Microsoft.Web/sites", result[0].type)
        self.assertEqual("value1", result[0].tags["tag1"])
        self.assertEqual("value3", result[0].tags["tag2"])
        # Resource 2
        self.assertEqual("2", result[1].id)
        self.assertEqual("Resource2", result[1].name)
        self.assertEqual("Building 44", result[1].location)
        # Resource 3
        self.assertEqual("3", result[2].id)
        self.assertEqual("Resource3", result[2].name)

        resourceArray = [
                {
                    'location': "West US",
                    'tags': {"tag1":"value1", "tag2":"value3"}},
                {
                    'location': "Building 44"}]

        self.client.put_array(resourceArray)

    def test_flattening_dictionary(self):

        #Dictionary
        resultDictionary = self.client.get_dictionary()
        self.assertEqual(3, len(resultDictionary))
        # Resource 1
        self.assertEqual("1", resultDictionary["Product1"].id)
        self.assertEqual("OK", resultDictionary["Product1"].provisioning_state_values)
        self.assertEqual("Product1", resultDictionary["Product1"].pname)
        self.assertEqual("Flat", resultDictionary["Product1"].flattened_product_type)
        self.assertEqual("Building 44", resultDictionary["Product1"].location)
        self.assertEqual("Resource1", resultDictionary["Product1"].name)
        self.assertEqual("Succeeded", resultDictionary["Product1"].provisioning_state)
        self.assertEqual("Microsoft.Web/sites", resultDictionary["Product1"].type)
        self.assertEqual("value1", resultDictionary["Product1"].tags["tag1"])
        self.assertEqual("value3", resultDictionary["Product1"].tags["tag2"])
        # Resource 2
        self.assertEqual("2", resultDictionary["Product2"].id)
        self.assertEqual("Resource2", resultDictionary["Product2"].name)
        self.assertEqual("Building 44", resultDictionary["Product2"].location)
        # Resource 3
        self.assertEqual("3", resultDictionary["Product3"].id)
        self.assertEqual("Resource3", resultDictionary["Product3"].name)

        resourceDictionary = {
                "Resource1": {
                    'location': "West US",
                    'tags': {"tag1":"value1", "tag2":"value3"},
                    'pname': "Product1",
                    'flattened_product_type': "Flat"},
                "Resource2": {
                    'location': "Building 44",
                    'pname': "Product2",
                    'flattened_product_type': "Flat"}}

        self.client.put_dictionary(resourceDictionary)

    def test_flattening_complex_object(self):

        #ResourceCollection
        resultResource = self.client.get_resource_collection()

        #dictionaryofresources
        self.assertEqual(3, len(resultResource.dictionaryofresources))
        # Resource 1
        self.assertEqual("1", resultResource.dictionaryofresources["Product1"].id)
        self.assertEqual("OK", resultResource.dictionaryofresources["Product1"].provisioning_state_values)
        self.assertEqual("Product1", resultResource.dictionaryofresources["Product1"].pname)
        self.assertEqual("Flat", resultResource.dictionaryofresources["Product1"].flattened_product_type)
        self.assertEqual("Building 44", resultResource.dictionaryofresources["Product1"].location)
        self.assertEqual("Resource1", resultResource.dictionaryofresources["Product1"].name)
        self.assertEqual("Succeeded", resultResource.dictionaryofresources["Product1"].provisioning_state)
        self.assertEqual("Microsoft.Web/sites", resultResource.dictionaryofresources["Product1"].type)
        self.assertEqual("value1", resultResource.dictionaryofresources["Product1"].tags["tag1"])
        self.assertEqual("value3", resultResource.dictionaryofresources["Product1"].tags["tag2"])
        # Resource 2
        self.assertEqual("2", resultResource.dictionaryofresources["Product2"].id)
        self.assertEqual("Resource2", resultResource.dictionaryofresources["Product2"].name)
        self.assertEqual("Building 44", resultResource.dictionaryofresources["Product2"].location)
        # Resource 3
        self.assertEqual("3", resultResource.dictionaryofresources["Product3"].id)
        self.assertEqual("Resource3", resultResource.dictionaryofresources["Product3"].name)

        #arrayofresources
        self.assertEqual(3, len(resultResource.arrayofresources))
        # Resource 1
        self.assertEqual("4", resultResource.arrayofresources[0].id)
        self.assertEqual("OK", resultResource.arrayofresources[0].provisioning_state_values)
        self.assertEqual("Product4", resultResource.arrayofresources[0].pname)
        self.assertEqual("Flat", resultResource.arrayofresources[0].flattened_product_type)
        self.assertEqual("Building 44", resultResource.arrayofresources[0].location)
        self.assertEqual("Resource4", resultResource.arrayofresources[0].name)
        self.assertEqual("Succeeded", resultResource.arrayofresources[0].provisioning_state)
        self.assertEqual("Microsoft.Web/sites", resultResource.arrayofresources[0].type)
        self.assertEqual("value1", resultResource.arrayofresources[0].tags["tag1"])
        self.assertEqual("value3", resultResource.arrayofresources[0].tags["tag2"])
        # Resource 2
        self.assertEqual("5", resultResource.arrayofresources[1].id)
        self.assertEqual("Resource5", resultResource.arrayofresources[1].name)
        self.assertEqual("Building 44", resultResource.arrayofresources[1].location)
        # Resource 3
        self.assertEqual("6", resultResource.arrayofresources[2].id)
        self.assertEqual("Resource6", resultResource.arrayofresources[2].name)

        #productresource
        self.assertEqual("7", resultResource.productresource.id)
        self.assertEqual("Resource7", resultResource.productresource.name)

        resourceDictionary = {
                "Resource1": FlattenedProduct(
                    location = "West US",
                    tags = {"tag1":"value1", "tag2":"value3"},
                    pname = "Product1",
                    flattened_product_type = "Flat"),
                "Resource2": FlattenedProduct(
                    location = "Building 44",
                    pname = "Product2",
                    flattened_product_type = "Flat")}

        resourceComplexObject = ResourceCollection(
                dictionaryofresources = resourceDictionary,
                arrayofresources = [
                    FlattenedProduct(
                        location = "West US",
                        tags = {"tag1":"value1", "tag2":"value3"},
                        pname = "Product1",
                        flattened_product_type = "Flat"),
                    FlattenedProduct(
                        location = "East US",
                        pname = "Product2",
                        flattened_product_type = "Flat")],
                productresource = FlattenedProduct(
                    location = "India",
                    pname = "Azure",
                    flattened_product_type = "Flat"))

        self.client.put_resource_collection(resourceComplexObject)

    def test_model_flattening_simple(self):

        simple_prduct = SimpleProduct(
            product_id = "123",
            description = "product description",
            max_product_display_name = "max name",
            odatavalue = "http://foo",
            generic_value = "https://generic"
            )

        result = self.client.put_simple_product(simple_prduct)
        self.assertEqual(result, simple_prduct)

    def test_model_flattening_with_parameter_flattening(self):

        simple_product = SimpleProduct(
            product_id = "123",
            description = "product description",
            max_product_display_name = "max name",
            odatavalue = "http://foo"
            )

        result = self.client.post_flattened_simple_product("123", "max name", "product description", None, "http://foo")
        self.assertEqual(result, simple_product)

    def test_model_flattening_with_grouping(self):

        simple_prduct = SimpleProduct(
            product_id = "123",
            description = "product description",
            max_product_display_name = "max name",
            odatavalue = "http://foo"
            )

        group = FlattenParameterGroup(
            product_id = "123",
            description = "product description",
            max_product_display_name="max name",
            odatavalue="http://foo",
            name="groupproduct")

        result = self.client.put_simple_product_with_grouping(group)
        self.assertEqual(result, simple_prduct)

if __name__ == '__main__':
    unittest.main()
