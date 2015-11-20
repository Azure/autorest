import unittest
import subprocess
import sys
import isodate
import tempfile
from datetime import date, datetime, timedelta
import os
from os.path import dirname, pardir, join, realpath

cwd = dirname(realpath(__file__))
tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))
sys.path.append(join(tests, "Url"))

from msrest.exceptions import DeserializationError

from auto_rest_url_test_service import AutoRestUrlTestService, AutoRestUrlTestServiceConfiguration


class UrlTests(unittest.TestCase):

    def test_url_path(self):

        config = AutoRestUrlTestServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestUrlTestService(config)

        #client.paths.byte_empty(bytearray())

        with self.assertRaises(ValueError):
            client.paths.byte_null(None)

        client.paths.double_decimal_negative(-9999999.999)

#client.Paths.ByteEmpty(new byte[0]);
#                Assert.Throws<ValidationException>(() => client.Paths.ByteNull(null));
#                client.Paths.ByteMultiByte(Encoding.UTF8.GetBytes("??????????"));
#                // appropriately disallowed:client.Paths.DateNull(null);
#                // appropriately disallowed: client.Paths.DateTimeNull(null);
#                client.Paths.DateTimeValid(new DateTime(2012, 1, 1, 1, 1, 1, DateTimeKind.Utc));
#                client.Paths.DateValid(new DateTime(2012, 1, 1, 0, 0, 0, DateTimeKind.Utc));
#                client.Paths.DoubleDecimalNegative(-9999999.999);
#                client.Paths.DoubleDecimalPositive(9999999.999);
#                client.Paths.FloatScientificNegative(-1.034e-20);
#                client.Paths.FloatScientificPositive(1.034e+20);
#                client.Paths.GetBooleanFalse(false);
#                client.Paths.GetBooleanTrue(true);
#                client.Paths.GetIntNegativeOneMillion(-1000000);
#                client.Paths.GetIntOneMillion(1000000);
#                client.Paths.GetNegativeTenBillion(-10000000000);
#                client.Paths.GetTenBillion(10000000000);
#                client.Paths.StringEmpty("");
#                Assert.Throws<ValidationException>(() => client.Paths.StringNull(null));
#                client.Paths.StringUrlEncoded(@"begin!*'();:@ &=+$,/?#[]end");
#                client.Paths.EnumValid(UriColor.Greencolor);
#                Assert.Throws<ValidationException>(() => client.Paths.EnumNull(null));

if __name__ == '__main__':
    unittest.main()