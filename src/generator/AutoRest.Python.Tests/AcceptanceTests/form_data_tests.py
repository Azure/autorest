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
import io
import isodate
import os
import tempfile
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "BodyFormData"))

from msrest.exceptions import DeserializationError

from auto_rest_swagger_bat_form_data_service import AutoRestSwaggerBATFormDataService

class FormDataTests(unittest.TestCase):

    def setUp(self):
        with tempfile.NamedTemporaryFile(mode='w', delete=False) as dummy:
            self.dummy_file = dummy.name
            dummy.write("Test file")

        return super(FormDataTests, self).setUp()

    def test_file_upload_stream(self):

        def test_callback(data, response, progress = [0]):
            self.assertTrue(len(data) > 0)
            progress[0] += len(data)
            total = float(response.headers.get('Content-Length', 100))
            print("Progress... {}%".format(int(progress[0]*100/total)))
            self.assertIsNotNone(response)

        client = AutoRestSwaggerBATFormDataService(base_url="http://localhost:3000")
        client.config.connection.data_block_size = 2

        test_string = "Upload file test case"
        test_bytes = bytearray(test_string, encoding='utf-8')
        result = io.BytesIO()
        with io.BytesIO(test_bytes) as stream_data:
            resp = client.formdata.upload_file(stream_data, "UploadFile.txt", callback=test_callback)
            for r in resp:
                result.write(r)
            self.assertEqual(result.getvalue().decode(), test_string)

    def test_file_upload_stream_raw(self):

        def test_callback(data, response, progress = [0]):
            self.assertTrue(len(data) > 0)
            progress[0] += len(data)
            total = float(response.headers['Content-Length'])
            print("Progress... {}%".format(int(progress[0]*100/total)))
            self.assertIsNotNone(response)

        client = AutoRestSwaggerBATFormDataService(base_url="http://localhost:3000")
        client.config.connection.data_block_size = 2

        test_string = "Upload file test case"
        test_bytes = bytearray(test_string, encoding='utf-8')
        result = io.BytesIO()
        with io.BytesIO(test_bytes) as stream_data:
            resp = client.formdata.upload_file(stream_data, "UploadFile.txt", raw=True)
            for r in resp.output:
                result.write(r)
            self.assertEqual(result.getvalue().decode(), test_string)

    def test_file_upload_file_stream(self):

        def test_callback(data, response, progress = [0]):
            self.assertTrue(len(data) > 0)
            progress[0] += len(data)
            total = float(response.headers.get('Content-Length', 100))
            print("Progress... {}%".format(int(progress[0]*100/total)))
            self.assertIsNotNone(response)

        client = AutoRestSwaggerBATFormDataService(base_url="http://localhost:3000")
        client.config.connection.data_block_size = 2

        name = os.path.basename(self.dummy_file)
        result = io.BytesIO()
        with open(self.dummy_file, 'rb') as upload_data:
            resp = client.formdata.upload_file(upload_data, name, callback=test_callback)
            for r in resp:
                result.write(r)
            self.assertEqual(result.getvalue().decode(), "Test file")

    def test_file_upload_file_stream_raw(self):

        def test_callback(data, response, progress = [0]):
            self.assertTrue(len(data) > 0)
            progress[0] += len(data)
            total = float(response.headers['Content-Length'])
            print("Progress... {}%".format(int(progress[0]*100/total)))
            self.assertIsNotNone(response)

        client = AutoRestSwaggerBATFormDataService(base_url="http://localhost:3000")
        client.config.connection.data_block_size = 2

        name = os.path.basename(self.dummy_file)
        result = io.BytesIO()
        with open(self.dummy_file, 'rb') as upload_data:
            resp = client.formdata.upload_file(upload_data, name, raw=True, callback=test_callback)
            for r in resp.output:
                result.write(r)
            self.assertEqual(result.getvalue().decode(), "Test file")

    def test_file_body_upload(self):

        test_string = "Upload file test case"
        test_bytes = bytearray(test_string, encoding='utf-8')

        def test_callback(data, response, progress = [0]):
            self.assertTrue(len(data) > 0)
            progress[0] += len(data)
            total = float(len(test_bytes))
            if response:
                print("Downloading... {}%".format(int(progress[0]*100/total)))
            else:
                print("Uploading... {}%".format(int(progress[0]*100/total)))

        client = AutoRestSwaggerBATFormDataService(base_url="http://localhost:3000")
        client.config.connection.data_block_size = 2

        result = io.BytesIO()
        with io.BytesIO(test_bytes) as stream_data:
            resp = client.formdata.upload_file_via_body(stream_data, callback=test_callback)
            for r in resp:
                result.write(r)
            self.assertEqual(result.getvalue().decode(), test_string)

        result = io.BytesIO()
        with open(self.dummy_file, 'rb') as upload_data:
            resp = client.formdata.upload_file_via_body(upload_data, callback=test_callback)
            for r in resp:
                result.write(r)
            self.assertEqual(result.getvalue().decode(), "Test file")

    def test_file_body_upload_raw(self):
        client = AutoRestSwaggerBATFormDataService(base_url="http://localhost:3000")

        test_string = "Upload file test case"
        test_bytes = bytearray(test_string, encoding='utf-8')
        result = io.BytesIO()
        with io.BytesIO(test_bytes) as stream_data:
            resp = client.formdata.upload_file_via_body(stream_data)
            for r in resp:
                result.write(r)
            self.assertEqual(result.getvalue().decode(), test_string)

        result = io.BytesIO()
        with open(self.dummy_file, 'rb') as upload_data:
            resp = client.formdata.upload_file_via_body(upload_data, raw=True)
            for r in resp.output:
                result.write(r)
            self.assertEqual(result.getvalue().decode(), "Test file")

    def tearDown(self):
        os.remove(self.dummy_file)
        return super(FormDataTests, self).tearDown()

if __name__ == '__main__':
    unittest.main()
