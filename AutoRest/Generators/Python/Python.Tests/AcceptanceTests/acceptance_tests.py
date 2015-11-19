import unittest
import subprocess
import sys
from os.path import dirname, realpath, sep, pardir

sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + "ClientRuntimes" + sep + "Python" + sep + "msrest")
sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + "Expected" + sep + "AcceptanceTests" + sep + "BodyArray")
sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + "Expected" + sep + "AcceptanceTests" + sep + "BodyBoolean")
sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + "Expected" + sep + "AcceptanceTests" + sep + "BodyComplex")
sys.path.append(dirname(realpath(__file__)) + sep + pardir + sep + "Expected" + sep + "AcceptanceTests" + sep + "Report")

from msrest.exceptions import DeserializationError

from auto_rest_bool_test_service import AutoRestBoolTestService, AutoRestBoolTestServiceConfiguration
from auto_rest_swagger_bat_array_service import AutoRestSwaggerBATArrayService, AutoRestSwaggerBATArrayServiceConfiguration
from auto_rest_complex_test_service import AutoRestComplexTestService, AutoRestComplexTestServiceConfiguration
from auto_rest_report_service import AutoRestReportService, AutoRestReportServiceConfiguration

from auto_rest_bool_test_service.models import ErrorException as BoolException
from auto_rest_complex_test_service.models import CMYKColors, Basic, IntWrapper, LongWrapper, FloatWrapper, DoubleWrapper, BooleanWrapper, StringWrapper, DatetimeWrapper, DateWrapper, DurationWrapper, Datetimerfc1123Wrapper

def sort_test(_, x, y):

    if x == 'test_ensure_coverage' :
        return 1
    if y == 'test_ensure_coverage' :
        return -1
    return (x > y) - (x < y)

unittest.TestLoader.sortTestMethodsUsing = sort_test

class AcceptanceTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):

        cls.server = subprocess.Popen("node ../../../../AutoRest/TestServer/server/startup/www.js")

    @classmethod
    def tearDownClass(cls):

        cls.server.kill()

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
        self.assertListEqual([], client.array.get_array_empty())
        self.assertIsNone(client.array.get_array_null())
        pass

    def test_complex(self):
        """
        BASIC COMPLEX TYPE TESTS
        """
        config = AutoRestComplexTestServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestComplexTestService(config)
        # GET basic/valid
        basic_result = client.basicOperations.get_valid()
        self.assertEqual(2, basic_result.id)
        self.assertEqual("abc", basic_result.name);
        self.assertEqual(CMYKColors.yellow, basic_result.color);
        # PUT basic/valid
        basic_result = Basic
        basic_result.id = 2
        basic_result.name = "abc"
        basic_result.color = CMYKColors.magenta
        client.basicOperations.put_valid(basic_result)
        # GET basic/empty
        basic_result = client.basicOperations.get_empty()
        self.assertIsNone(basic_result.id)
        self.assertIsNone(basic_result.name)
        # GET basic/null
        basic_result = client.basicOperations.get_null()
        self.assertIsNone(basic_result.id)
        self.assertIsNone(basic_result.name)
        # GET basic/notprovided
        basic_result = client.basicOperations.get_not_provided()
        # TODO: investigage!!!
        #self.assertIsNone(basic_result)
        # GET basic/invalid
        with self.assertRaises(DeserializationError):
            client.basicOperations.get_invalid()

        """
        COMPLEX TYPE WITH PRIMITIVE PROPERTIES
        """
        # GET primitive/integer
        intResult = client.primitive.get_int();
        self.assertEqual(-1, intResult.field1)
        self.assertEqual(2, intResult.field2)
        # PUT primitive/integer
        intRequest = IntWrapper
        intRequest.field1 = -1
        intRequest.field2 = 2
        client.primitive.put_int(intRequest)
        # GET primitive/long
        longResult = client.primitive.get_long();
        self.assertEqual(1099511627775, longResult.field1)
        self.assertEqual(-999511627788, longResult.field2)
        # PUT primitive/long
        longRequest = LongWrapper
        longRequest.field1 = 1099511627775
        longRequest.field2 = -999511627788
        client.primitive.put_long(longRequest)
        # GET primitive/float
        floatResult = client.primitive.get_float()
        self.assertEqual(1.05, floatResult.field1)
        self.assertEqual(-0.003, floatResult.field2)
        # PUT primitive/float
        floatRequest = FloatWrapper
        floatRequest.field1 = 1.05
        floatRequest.field2 = -0.003
        client.primitive.put_float(floatRequest)
        # GET primitive/double
        doubleResult = client.primitive.get_double()
        self.assertEqual(3e-100, doubleResult.field1)
        self.assertEqual(-5e-57, doubleResult.field_56_zeros_after_the_dot_and_negative_zero_before_dot_and_this_is_a_long_field_name_on_purpose)
        # PUT primitive/double
        doubleRequest = DoubleWrapper
        doubleRequest.field1 = 3e-100
        doubleRequest.field_56_zeros_after_the_dot_and_negative_zero_before_dot_and_this_is_a_long_field_name_on_purpose = -5e-57
        client.primitive.put_double(doubleRequest);
        # GET primitive/bool
        boolResult = client.primitive.get_bool()
        self.assertTrue(boolResult.field_true)
        self.assertFalse(boolResult.field_false)
        # PUT primitive/bool
        boolRequest = BooleanWrapper
        boolRequest.field_true = True
        boolRequest.field_false = False
        client.primitive.put_bool(boolRequest);
        # GET primitive/string
        stringResult = client.primitive.get_string();
        self.assertEqual("goodrequest", stringResult.field)
        self.assertEqual("", stringResult.empty)
        self.assertIsNone(stringResult.null)
        # PUT primitive/string
        stringRequest = StringWrapper
        stringRequest.null = None
        stringRequest.empty = ""
        stringRequest.field = 'goodrequest'
        # TODO: investigate !!! empty is not set
        #client.primitive.put_string(stringRequest);
        # GET primitive/date
        dateResult = client.primitive.get_date()
        self.assertEqual(u"0001-01-01", dateResult.field)
        self.assertEqual(u"2016-02-29", dateResult.leap)
        dateRequest = DateWrapper
        dateRequest.field = u'0001-01-01'
        dateRequest.leap = u'2016-02-29'
        client.primitive.put_date(dateRequest)
        # GET primitive/datetime
        # TODO: investigage!!!
        #datetimeResult = client.primitive.get_date_time()
        #Assert.Equal(DateTime.MinValue, datetimeResult.Field);
        #datetimeRequest = DatetimeWrapper(field : d
        #client.primitive.put_date_time(new DatetimeWrapper
        #{
        #    Field = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc),
        #    Now = new DateTime(2015, 05, 18, 18, 38, 0, DateTimeKind.Utc)
        #});
        # GET primitive/datetimerfc1123
        #datetimeRfc1123Result = client.primitive.get_date_time_rfc1123()
        #Assert.Equal(DateTime.MinValue, datetimeRfc1123Result.Field);
        #client.primitive.PutDateTimeRfc1123(new Datetimerfc1123Wrapper()
        #{
        #    Field = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc),
        #    Now = new DateTime(2015, 05, 18, 11, 38, 0, DateTimeKind.Utc)
        #});
        # GET primitive/duration
        #TimeSpan expectedDuration = new TimeSpan(123, 22, 14, 12, 11);
        durationResult = client.primitive.get_duration();
        self.assertEqual(123, durationResult.field.days)
        self.assertEqual(80052, durationResult.field.seconds)
        self.assertEqual(11000, durationResult.field.microseconds)
        from datetime import timedelta
        durationRequest = DurationWrapper
        durationRequest.field = timedelta(days = 123, hours = 22, minutes = 14, seconds = 12, milliseconds = 11)
        client.primitive.put_duration(durationRequest);
        # GET primitive/byte
        byteResult = client.primitive.get_byte()
        # TODO: investigage!!!
        #var bytes = new byte[] {0x0FF, 0x0FE, 0x0FD, 0x0FC, 0x000, 0x0FA, 0x0F9, 0x0F8, 0x0F7, 0x0F6};
        #Assert.Equal(bytes, byteResult.Field);
        # PUT primitive/byte
        #client.Primitive.PutByte(bytes);

        """
        COMPLEX TYPE WITH ARRAY PROPERTIES
        """
        # GET array/valid
        #var arrayResult = client.Array.GetValid();
        #Assert.Equal(5, arrayResult.Array.Count);
        #List<string> arrayValue = new List<string>
        #{
        #    "1, 2, 3, 4",
        #    "",
        #    null,
        #    "&S#$(*Y",
        #    "The quick brown fox jumps over the lazy dog"
        #};
        #for (int i = 0; i < 5; i++)
        #{
        #    Assert.Equal(arrayValue[i], arrayResult.Array[i]);
        #}
        # PUT array/valid
        #client.Array.PutValid(arrayValue);
        # GET array/empty
        #arrayResult = client.Array.GetEmpty();
        #Assert.Equal(0, arrayResult.Array.Count);
        # PUT array/empty
        #arrayValue.Clear();
        #client.Array.PutEmpty(arrayValue);
        # Get array/notprovided
        #arrayResult = client.Array.GetNotProvided();
        #Assert.Null(arrayResult.Array);

        """
        COMPLEX TYPE WITH DICTIONARY PROPERTIES
        """
        # GET dictionary/valid
        #var dictionaryResult = client.Dictionary.GetValid();
        #Assert.Equal(5, dictionaryResult.DefaultProgram.Count);
        #Dictionary<string, string> dictionaryValue = new Dictionary<string, string>
        #{
        #    {"txt", "notepad"},
        #    {"bmp", "mspaint"},
        #    {"xls", "excel"},
        #    {"exe", ""},
        #    {"", null}
        #};
        #Assert.Equal(dictionaryValue, dictionaryResult.DefaultProgram);
        # PUT dictionary/valid
        #client.Dictionary.PutValid(dictionaryValue);
        # GET dictionary/empty
        #dictionaryResult = client.Dictionary.GetEmpty();
        #Assert.Equal(0, dictionaryResult.DefaultProgram.Count);
        # PUT dictionary/empty
        #client.Dictionary.PutEmpty(new Dictionary<string, string>());
        # GET dictionary/null
        #Assert.Null(client.Dictionary.GetNull().DefaultProgram);
        # GET dictionary/notprovided
        #Assert.Null(client.Dictionary.GetNotProvided().DefaultProgram);

        """
        COMPLEX TYPES THAT INVOLVE INHERITANCE
        """
        # GET inheritance/valid
        inheritanceResult = client.inheritance.get_valid()
        self.assertEqual(2, inheritanceResult.id)
        self.assertEqual("Siameeee", inheritanceResult.name)
        #TODO:investigate!!!
        #self.assertEqual(-1, inheritanceResult.hates[1].id)
        #self.assertEqual("Tomato", inheritanceResult.hates[1].name)

        pass

    def test_ensure_coverage(self):

        config = AutoRestReportServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestReportService(config)
        report = client.get_report()
        skipped = [k for k, v in report.items() if v == 0]

        for s in skipped:
            print "SKIPPED {0}".format(s)

        totalTests = len(report)
        print ("The test coverage is {0}/{1}.".format(totalTests - len(skipped), totalTests))
        self.assertEqual(0, len(skipped))

if __name__ == '__main__':
    unittest.main()
