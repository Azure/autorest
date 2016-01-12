import unittest
import subprocess
import sys
import io
import isodate
import os
import tempfile
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

    def setUp(self):
        with tempfile.NamedTemporaryFile(mode='w', delete=False) as dummy:
            self.dummy_file = dummy.name
            dummy.write("Test file")

        return super(FormDataTests, self).setUp()

    def test_file_upload_stream(self):

        config = AutoRestSwaggerBATFormDataServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestSwaggerBATFormDataService(config)

        test_string = "Upload file test case"
        test_bytes = bytearray(test_string)
        with io.BytesIO(test_bytes) as stream_data:
            resp = client.formdata.upload_file(stream_data, "UploadFile.txt")
            self.assertEqual(resp, test_string)

    def test_file_upload_file_stream(self):

        config = AutoRestSwaggerBATFormDataServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestSwaggerBATFormDataService(config)

        name = os.path.basename(self.dummy_file)
        with open(self.dummy_file, 'rb') as upload_data:
            resp = client.formdata.upload_file(upload_data, name)
            self.assertEqual(resp, "Test file")

    def test_file_body_upload(self):

        config = AutoRestSwaggerBATFormDataServiceConfiguration(base_url="http://localhost:3000")
        config.log_level = log_level
        client = AutoRestSwaggerBATFormDataService(config)

        test_string = "Upload file test case"
        test_bytes = bytearray(test_string)
        with io.BytesIO(test_bytes) as stream_data:
            resp = client.formdata.upload_file_via_body(stream_data, "UploadFile.txt")
            self.assertEqual(resp, test_string)

        name = os.path.basename(self.dummy_file)
        with open(self.dummy_file, 'rb') as upload_data:
            resp = client.formdata.upload_file_via_body(upload_data, name)
            self.assertEqual(resp, "Test file")

    def tearDown(self):
        os.remove(self.dummy_file)
        return super(FormDataTests, self).tearDown()

if __name__ == '__main__':
    unittest.main()