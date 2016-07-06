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
import io
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))
root = realpath(join(cwd , pardir, pardir, pardir, pardir))
sys.path.append(join(root, "src" , "client" , "Python", "msrest"))
log_level = int(os.environ.get('PythonLogLevel', 30))

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "BodyFile"))

from msrest.exceptions import DeserializationError

from autorestswaggerbatfileservice import AutoRestSwaggerBATFileService
from autorestswaggerbatfileservice.models import ErrorException


class FileTests(unittest.TestCase):

    def test_files(self):
        client = AutoRestSwaggerBATFileService(base_url="http://localhost:3000")
        client.config.connection.data_block_size = 1000

        def test_callback(data, response, progress=[0]):
            self.assertTrue(len(data) > 0)
            self.assertIsNotNone(response)
            self.assertFalse(response._content_consumed)
            total = float(response.headers['Content-Length'])
            if total < 4096:
                progress[0] += len(data)
                print("Downloading... {}%".format(int(progress[0]*100/total)))

        file_length = 0
        with io.BytesIO() as file_handle:
            stream = client.files.get_file(callback=test_callback)

            for data in stream:
                file_length += len(data)
                file_handle.write(data)

            self.assertNotEqual(file_length, 0)

            sample_file = realpath(
                join(cwd, pardir, pardir, 
                     "AutoRest.NodeJS.Tests", "AcceptanceTests", "sample.png"))

            with open(sample_file, 'rb') as data:
                sample_data = hash(data.read())
            self.assertEqual(sample_data, hash(file_handle.getvalue()))

        client.config.connection.data_block_size = 4096
        file_length = 0
        with io.BytesIO() as file_handle:
            stream = client.files.get_empty_file(callback=test_callback)

            for data in stream:
                file_length += len(data)
                file_handle.write(data)

            self.assertEqual(file_length, 0)

        def add_headers(adapter, request, response, *args, **kwargs):
            response.headers['Content-Length'] = str(3000 * 1024 * 1024)

        file_length = 0
        client._client.add_hook('response', add_headers)
        stream = client.files.get_file_large(callback=test_callback)
        #for data in stream:
        #    file_length += len(data)

        #self.assertEqual(file_length, 3000 * 1024 * 1024)

    def test_files_raw(self):

        def test_callback(data, response, progress=[0]):
            self.assertTrue(len(data) > 0)
            self.assertIsNotNone(response)
            self.assertFalse(response._content_consumed)
            total = float(response.headers.get('Content-Length', 0))
            if total:
                progress[0] += len(data)
                print("Downloading... {}%".format(int(progress[0]*100/total)))

        client = AutoRestSwaggerBATFileService(base_url="http://localhost:3000")

        file_length = 0
        with io.BytesIO() as file_handle:
            response = client.files.get_file(raw=True, callback=test_callback)
            stream = response.output

            for data in stream:
                file_length += len(data)
                file_handle.write(data)

            self.assertNotEqual(file_length, 0)

            sample_file = realpath(
                join(cwd, pardir, pardir, 
                     "AutoRest.NodeJS.Tests", "AcceptanceTests", "sample.png"))

            with open(sample_file, 'rb') as data:
                sample_data = hash(data.read())
            self.assertEqual(sample_data, hash(file_handle.getvalue()))

        file_length = 0
        with io.BytesIO() as file_handle:
            response = client.files.get_empty_file(raw=True, callback=test_callback)
            stream = response.output

            for data in stream:
                file_length += len(data)
                file_handle.write(data)

            self.assertEqual(file_length, 0)

if __name__ == '__main__':
    unittest.main()