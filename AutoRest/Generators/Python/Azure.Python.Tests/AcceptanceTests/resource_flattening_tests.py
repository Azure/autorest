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

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "ResourceFlattening"))

from msrest.serialization import Deserializer
from msrest.exceptions import DeserializationError
from msrest.authentication import BasicTokenAuthentication

from auto_rest_resource_flattening_test_service import AutoRestResourceFlatteningTestService, AutoRestResourceFlatteningTestServiceConfiguration
from auto_rest_resource_flattening_test_service.models import FlattenedProduct, ErrorException, ResourceCollection


class ResourceFlatteningTests(unittest.TestCase):

    def setUp(self):
        cred = BasicTokenAuthentication({"access_token" :str(uuid4())})
        config = AutoRestResourceFlatteningTestServiceConfiguration(cred, base_url="http://localhost:3000")
        config.log_level = 10
        self.client = AutoRestResourceFlatteningTestService(config)

        return super(ResourceFlatteningTests, self).setUp()

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
                FlattenedProduct(
                    location = "West US",
                    tags = {"tag1":"value1", "tag2":"value3"}),
                FlattenedProduct(
                    location = "Building 44")]

        self.client.put_array(resourceArray)
        pass

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
                "Resource1": FlattenedProduct(
                    location = "West US",
                    tags = {"tag1":"value1", "tag2":"value3"},
                    pname = "Product1",
                    flattened_product_type = "Flat"),
                "Resource2": FlattenedProduct(
                    location = "Building 44",
                    pname = "Product2",
                    flattened_product_type = "Flat")}
        #TODO: serializer need to handle flatten resources
        #self.client.put_dictionary(resourceDictionary)
        pass

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
        #TODO: serializer need to handle flatten resources
        #self.client.put_resource_collection(resourceComplexObject)
        pass

if __name__ == '__main__':
    unittest.main()