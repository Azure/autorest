import unittest
import subprocess
import sys
import isodate
import os
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir, pardir))
sys.path.append(join(root, "ClientRuntimes" , "Python", "msrest"))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "BodyFormData"))

from msrest.exceptions import DeserializationError

from auto_rest_swagger_bat_form_data_service import AutoRestSwaggerBATFormDataService, AutoRestSwaggerBATFormDataServiceConfiguration

class FormDataTests(unittest.TestCase):

    def test_file_upload_stream(self):

        config = AutoRestSwaggerBATFormDataServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestSwaggerBATFormDataService(config)

    def test_file_upload_file_stream(self):

        config = AutoRestSwaggerBATFormDataServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestSwaggerBATFormDataService(config)

    def test_file_upload(self):

        config = AutoRestSwaggerBATFormDataServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestSwaggerBATFormDataService(config)

if __name__ == '__main__':
    unittest.main()