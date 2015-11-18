import unittest
import subprocess
import sys
from os.path import dirname, realpath, sep, pardir

unittest.TestLoader.sortTestMethodsUsing = lambda _, x, y: cmp(y, x)

sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + "ClientRuntimes" + sep + "Python" + sep + "msrest")
sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + "Expected" + sep + "AcceptanceTests" + sep + "BodyArray")
sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + "Expected" + sep + "AcceptanceTests" + sep + "BodyBoolean")
sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + "Expected" + sep + "AcceptanceTests" + sep + "BodyComplex")

from msrest.exceptions import DeserializationError

from auto_rest_bool_test_service import AutoRestBoolTestService, AutoRestBoolTestServiceConfiguration
from auto_rest_swagger_bat_array_service import AutoRestSwaggerBATArrayService, AutoRestSwaggerBATArrayServiceConfiguration
from auto_rest_complex_test_service import AutoRestComplexTestService, AutoRestComplexTestServiceConfiguration

from auto_rest_bool_test_service.models import ErrorException as BoolException
from auto_rest_complex_test_service.models import CMYKColors

class AcceptanceTests(unittest.TestCase):
    def setUp(self):
        #subprocess.call("node startup/www.js", shell=True)
        #return super(Test_test1, self).setUp()
        pass

    def test_bool(self):

        config = AutoRestBoolTestServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestBoolTestService(config)
        self.assertTrue(client.bool_model.get_true())
        self.assertFalse(client.bool_model.get_false())
        client.bool_model.get_null()
        client.bool_model.put_false(False)
        client.bool_model.put_true(True)
        with self.assertRaises(BoolException):
            client.bool_model.put_true(False)
        with self.assertRaises(DeserializationError):
            client.bool_model.get_invalid()
        pass

    def test_array(self):

        config = AutoRestSwaggerBATArrayServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestSwaggerBATArrayService(config)
        self.assertListEqual([], list(client.array.get_array_empty()))
        #self.assertIsNone(list(client.array.get_array_null()))

    def test_complex(self):

        config = AutoRestComplexTestServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestComplexTestService(config)
        basic_result = client.basicOperations.get_valid()
        self.assertEqual(2, basic_result.id)
        self.assertEqual("abc", basic_result.name);
        self.assertEqual(CMYKColors.yellow, basic_result.color);

if __name__ == '__main__':
    unittest.main()
