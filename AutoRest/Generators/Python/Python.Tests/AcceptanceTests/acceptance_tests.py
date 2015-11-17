import unittest
import sys
import subprocess

#sys.path.append("D:\\Github\\autorest\\ClientRuntimes\\Python\\msrest")
#sys.path.append("D:\\Github\\autorest\\AutoRest\\Generators\\Python\\Python.Tests\\Expected\\AcceptanceTests")

from auto_rest_bool_test_service import (
    AutoRestBoolTestService,
    AutoRestBoolTestServiceConfiguration
    )

from auto_rest_swagger_bat_array_service import AutoRestSwaggerBATArrayService, AutoRestSwaggerBATArrayServiceConfiguration

from auto_rest_bool_test_service.models import ErrorException
from msrest.exceptions import DeserializationError

class AcceptanceTests(unittest.TestCase):
    def setUp(self):
        subprocess.call("node startup/www.js", shell=True)
        return super(Test_test1, self).setUp()

    def BoolTest(self):

        config = AutoRestBoolTestServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestBoolTestService(None, config)
        self.assertTrue(client.bool_model.get_true())
        self.assertFalse(client.bool_model.get_false())
        client.bool_model.get_null()
        client.bool_model.put_false(False)
        client.bool_model.put_true(True)
        with self.assertRaises(ErrorException):
            client.bool_model.put_true(False)
        with self.assertRaises(DeserializationError):
            client.bool_model.get_invalid()

    def ArrayTest(self):

        config = AutoRestSwaggerBATArrayServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestSwaggerBATArrayService(config)
        self.assertListEqual([], client.array.get_array_empty())
        self.assertIsNone(client.array.get_array_null())

if __name__ == '__main__':
    unittest.main()
