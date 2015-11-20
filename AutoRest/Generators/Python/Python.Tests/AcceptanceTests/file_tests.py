import unittest
import subprocess
import sys
import isodate
import tempfile
from datetime import date, datetime, timedelta
import os
from os.path import dirname, realpath, sep, pardir

sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + "Expected" + sep + "AcceptanceTests" + sep + "BodyFile")

from msrest.exceptions import DeserializationError

from auto_rest_swagger_bat_file_service import AutoRestSwaggerBATFileService, AutoRestSwaggerBATFileServiceConfiguration
from auto_rest_swagger_bat_file_service.models import ErrorException


def sort_test(_, x, y):

    if x == 'test_ensure_coverage' :
        return 1
    if y == 'test_ensure_coverage' :
        return -1
    return (x > y) - (x < y)

unittest.TestLoader.sortTestMethodsUsing = sort_test

class FileTests(unittest.TestCase):

    #@classmethod
    #def setUpClass(cls):

    #    cls.server = subprocess.Popen("node ../../../../AutoRest/TestServer/server/startup/www.js")

    #@classmethod
    #def tearDownClass(cls):

    #    cls.server.kill()
    def test_files(self):

        config = AutoRestSwaggerBATFileServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestSwaggerBATFileService(config)

        temp_file = tempfile.mktemp()
        file_length = 0
        with open(temp_file, mode='wb') as file_handle:

            stream = client.files.get_file()

            for data in stream:
                file_length += len(data)
                file_handle.write(data)

            self.assertNotEqual(file_length, 0)

        sample_file = dirname(realpath(__file__)) + sep + pardir + sep + \
            pardir + sep + pardir + sep + "NodeJS" + sep + "NodeJS.Tests"\
            + sep + "AcceptanceTests" + sep + "sample.png"

        with open(sample_file, 'rb') as data:
            sample_data = hash(data.read())

        with open(temp_file, 'rb') as data:
            result_data = hash(data.read())

        self.assertEqual(sample_data, result_data)
        os.remove(temp_file)

        temp_file = tempfile.mktemp()
        file_length = 0
        with open(temp_file, mode='wb') as file_handle:

            stream = client.files.get_empty_file()

            for data in stream:
                file_length += len(data)
                file_handle.write(data)

            self.assertEqual(file_length, 0)

        os.remove(temp_file)
            
        #[Fact]
        #public void FileTests()
        #{
        #    SwaggerSpecHelper.RunTests<CSharpCodeGenerator>(
        #        SwaggerPath("body-file.json"), ExpectedPath("BodyFile"));
        #    using (var client = new AutoRestSwaggerBATFileService(Fixture.Uri))
        #    {
        #        var stream = client.Files.GetFile();
        #        Assert.NotEqual(0, stream.Length);
        #        byte[] buffer = new byte[16 * 1024];
        #        using (MemoryStream ms = new MemoryStream())
        #        {
        #            int read;
        #            while ((read = stream.Read(buffer, 0, buffer.Length)) > 0)
        #            {
        #                ms.Write(buffer, 0, read);
        #            }
        #            Assert.Equal(File.ReadAllBytes("sample.png"), ms.ToArray());
        #        }

        #        var emptyStream = client.Files.GetEmptyFile();
        #        Assert.Equal(0, emptyStream.Length);
        #    }
        #}


if __name__ == '__main__':
    unittest.main()