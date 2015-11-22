import unittest
import isodate
import subprocess
import sys
import datetime
from os.path import dirname, pardir, join, realpath, sep, pardir

cwd = dirname(realpath(__file__))

sys.path.append(cwd + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + pardir + sep + "ClientRuntimes" + sep + "Python" + sep + "msrest")

tests = realpath(join(cwd, pardir, "Expected", "AcceptanceTests"))

sys.path.append(join(tests, "BodyArray"))
sys.path.append(join(tests, "BodyBoolean"))
sys.path.append(join(tests, "BodyComplex"))
sys.path.append(join(tests, "Report"))

from msrest.exceptions import DeserializationError

from auto_rest_bool_test_service import AutoRestBoolTestService, AutoRestBoolTestServiceConfiguration
from auto_rest_swagger_bat_array_service import AutoRestSwaggerBATArrayService, AutoRestSwaggerBATArrayServiceConfiguration
from auto_rest_complex_test_service import AutoRestComplexTestService, AutoRestComplexTestServiceConfiguration
from auto_rest_report_service import AutoRestReportService, AutoRestReportServiceConfiguration

from auto_rest_bool_test_service.models import ErrorException as BoolException
from auto_rest_complex_test_service.models import (
    CMYKColors, Basic, IntWrapper, LongWrapper, FloatWrapper,
    DoubleWrapper, BooleanWrapper, StringWrapper, DatetimeWrapper,
    DateWrapper, DurationWrapper, Datetimerfc1123Wrapper, ByteWrapper, ArrayWrapper, DictionaryWrapper, 
    Siamese, Dog, Salmon, Shark, Sawshark, Goblinshark, Fish)



class UTC(datetime.tzinfo): 
    def utcoffset(self,dt): 
        return datetime.timedelta(hours=0,minutes=0) 

    def tzname(self,dt): 
        return "Z" 

    def dst(self,dt): 
        return datetime.timedelta(0) 

class AcceptanceTests(unittest.TestCase):
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

    def test_array(self):

        config = AutoRestSwaggerBATArrayServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestSwaggerBATArrayService(config)
        self.assertListEqual([], client.array.get_array_empty())
        self.assertIsNone(client.array.get_array_null())

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
        self.assertIsNone(basic_result)
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

        client.primitive.put_string(stringRequest);
        # GET primitive/date
        dateResult = client.primitive.get_date()
        self.assertEqual(isodate.parse_date("0001-01-01"), dateResult.field)
        self.assertEqual(isodate.parse_date("2016-02-29"), dateResult.leap)
        dateRequest = DateWrapper
        dateRequest.field = isodate.parse_date('0001-01-01')
        dateRequest.leap = isodate.parse_date('2016-02-29')
        client.primitive.put_date(dateRequest)
        # GET primitive/datetime
        datetimeResult = client.primitive.get_date_time()
        min_date = datetime.datetime.min
        min_date = min_date.replace(tzinfo=UTC())
        self.assertEqual(min_date, datetimeResult.field)
        
        datetime_request = DatetimeWrapper(
            field=isodate.parse_datetime("0001-01-01T00:00:00Z"),
            now=isodate.parse_datetime("2015-05-18T18:38:00Z"))
        client.primitive.put_date_time(datetime_request)
        
        # GET primitive/datetimerfc1123
        datetimeRfc1123Result = client.primitive.get_date_time_rfc1123()
        self.assertEqual(min_date, datetimeRfc1123Result.field)

        datetime_request = Datetimerfc1123Wrapper(
            field=isodate.parse_datetime("0001-01-01T00:00:00Z"),
            now=isodate.parse_datetime("2015-05-18T11:38:00Z"))
        client.primitive.put_date_time_rfc1123(datetime_request)

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
        valid_bytes = bytearray([0x0FF, 0x0FE, 0x0FD, 0x0FC, 0x000, 0x0FA, 0x0F9, 0x0F8, 0x0F7, 0x0F6])
        self.assertEqual(valid_bytes, byteResult.field)
        # PUT primitive/byte
        byte_body = ByteWrapper(field=valid_bytes)
        client.primitive.put_byte(byte_body)

        """
        COMPLEX TYPE WITH ARRAY PROPERTIES
        """
        # GET array/valid
        arrayResult = client.array.get_valid();
        self.assertEqual(5, len(arrayResult.array))
        arrayValue = [
            '1, 2, 3, 4',
            '',
            None,
            '&S#$(*Y',
            'The quick brown fox jumps over the lazy dog' ]
        for x in range(0, 4):
            self.assertEqual(arrayValue[x], arrayResult.array[x])
        # PUT array/valid
        arrayWrapper = ArrayWrapper
        arrayWrapper.array = arrayValue
        #TODO: investigate
        #client.array.put_valid(arrayWrapper)
        # GET array/empty
        arrayResult = client.array.get_empty()
        self.assertEqual(0, len(arrayResult.array))
        # PUT array/empty
        arrayValue = []
        arrayWrapper.array = arrayValue
        #TODO: investigate
        #client.array.put_empty(arrayValue)
        # Get array/notprovided
        arrayResult = client.array.get_not_provided()
        self.assertIsNone(arrayResult.array)

        """
        COMPLEX TYPE WITH DICTIONARY PROPERTIES
        """
        # GET dictionary/valid
        dictionaryResult = client.dictionary.get_valid()
        self.assertEqual(5, len(dictionaryResult.default_program))
        dictionaryValue = {
            u"txt": "notepad",
            u"bmp": "mspaint",
            u"xls": "excel",
            u"exe": "",
            u"": None
        }
        self.assertEqual(dictionaryValue, dictionaryResult.default_program)
        # PUT dictionary/valid
        dictionaryWrapper = DictionaryWrapper(default_program = dictionaryValue)
        #TODO: investigate
        #client.dictionary.put_valid(dictionaryWrapper)
        # GET dictionary/empty
        dictionaryResult = client.dictionary.get_empty()
        self.assertEqual(0, len(dictionaryResult.default_program))
        # PUT dictionary/empty
        dictionaryWrapper = DictionaryWrapper(default_program = {})
        #TODO: investigate
        #client.dictionary.put_empty(dictionaryWrapper)
        # GET dictionary/null
        dictionaryResult = client.dictionary.get_null()
        self.assertIsNone(dictionaryResult.default_program)
        # GET dictionary/notprovided
        dictionaryResult = client.dictionary.get_not_provided()
        self.assertIsNone(dictionaryResult.default_program)

        """
        COMPLEX TYPES THAT INVOLVE INHERITANCE
        """
        # GET inheritance/valid
        inheritanceResult = client.inheritance.get_valid()
        self.assertEqual(2, inheritanceResult.id)
        self.assertEqual("Siameeee", inheritanceResult.name)
        self.assertEqual(-1, inheritanceResult.hates[1].id)
        self.assertEqual("Tomato", inheritanceResult.hates[1].name)
        # PUT inheritance/valid
        inheritanceRequest = Siamese(id = 2, name = 'Siameeee', color = 'green', breed = 'persian')
        inheritanceRequest.hates = [ Dog(id = 1, name = 'Potato', food = 'tomato'), Dog(id = -1, name = 'Tomato', food = 'french fries') ]
        client.inheritance.put_valid(inheritanceRequest)

        """
        COMPLEX TYPES THAT INVOLVE POLYMORPHISM
        """
        # GET polymorphism/valid
        polymorphismResult = Salmon(client.polymorphism.get_valid()) 
        #TODO: investigate???
        self.assertIsNotNone(polymorphismResult)
        #self.assertEqual("alaska", polymorphismResult.location)
        #self.assertEqual(3, len(polymorphismResult.siblings))
        #self.assertIsInstance(Shark, polymorphismResult.siblings[0])
        #self.assertIsInstance(Sawshark, polymorphismResult.siblings[1])
        #self.assertIsInstance(Goblinshark, polymorphismResult.siblings[2])
        #Assert.Equal(6, ((Shark) polymorphismResult.Siblings[0]).Age);
        #Assert.Equal(105, ((Sawshark) polymorphismResult.Siblings[1]).Age);
        #Assert.Equal(1, ((Goblinshark)polymorphismResult.Siblings[2]).Age);
        #// PUT polymorphism/valid
        #var polymorphismRequest = new Salmon
        #{
        #    Iswild = true,
        #    Length = 1,
        #    Location = "alaska",
        #    Species = "king",
        #    Siblings = new List<Fish>
        #    {
        #        new Shark
        #        {
        #            Age = 6,
        #            Length = 20,
        #            Species = "predator",
        #            Birthday = new DateTime(2012, 1, 5, 1, 0, 0, DateTimeKind.Utc)
        #        },
        #        new Sawshark
        #        {
        #            Age = 105,
        #            Length = 10,
        #            Species = "dangerous",
        #            Birthday = new DateTime(1900, 1, 5, 1, 0, 0, DateTimeKind.Utc),
        #            Picture = new byte[] {255, 255, 255, 255, 254}
        #        },
        #        new Goblinshark()
        #        {
        #            Age = 1,
        #            Length = 30,
        #            Species = "scary",
        #            Birthday = new DateTime(2015, 8, 8, 0, 0, 0, DateTimeKind.Utc),
        #            Jawsize = 5
        #        }
        #    }
        #};
        #client.Polymorphism.PutValid(polymorphismRequest);

        #var badRequest = new Salmon
        #{
        #    Iswild = true,
        #    Length = 1,
        #    Location = "alaska",
        #    Species = "king",
        #    Siblings = new List<Fish>
        #    {
        #        new Shark
        #        {
        #            Age = 6,
        #            Length = 20,
        #            Species = "predator",
        #            Birthday = new DateTime(2012, 1, 5, 1, 0, 0, DateTimeKind.Utc)
        #        },
        #        new Sawshark
        #        {
        #            Age = 105,
        #            Length = 10,
        #            Species = "dangerous",
        #            Picture = new byte[] {255, 255, 255, 255, 254}
        #        }
        #    }
        #};
        #var missingRequired =
        #    Assert.Throws<ValidationException>(() => client.Polymorphism.PutValidMissingRequired(badRequest));
        #Assert.Equal("Birthday", missingRequired.Target);
        """
        COMPLEX TYPES THAT INVOLVE RECURSIVE REFERENCE
        """
        # GET polymorphicrecursive/valid
        recursiveResult = client.polymorphicrecursive.get_valid()
        #TODO: investigate???
        #self.assertIsInstance(recursiveResult, Salmon)
        #Assert.True(recursiveResult.Siblings[0] is Shark);
        #Assert.True(recursiveResult.Siblings[0].Siblings[0] is Salmon);
        #Assert.Equal("atlantic", ((Salmon) recursiveResult.Siblings[0].Siblings[0]).Location);
        # PUT polymorphicrecursive/valid
        recursiveRequest = Salmon(iswild = True, length = 1, species = 'king', location = 'alaska')
        recursiveRequest.siblings = [
                Shark(age = 6, length = 20, species = 'predator', siblings = [
                    Salmon(iswild = True, length = 2, species = 'coho', location = 'atlantic', siblings = [
                        Shark(age = 6, length = 20, species = 'predator', birthday = isodate.parse_datetime("2012-01-05T10:00:00Z")),
                        Sawshark(age = 105, length = 10, species = 'dangerous', birthday = isodate.parse_datetime("1900-01-05T10:00:00Z"), picture = bytearray([255, 255, 255, 255, 254])) ]),
                    Sawshark(age = 105, length = 10, species = 'dangerous', siblings=[], birthday = isodate.parse_datetime("1900-01-05T10:00:00Z"), picture = bytearray([255, 255, 255, 255, 254]))],
                      birthday = isodate.parse_datetime("2012-01-05T10:00:00Z")),
                Sawshark(age = 105, length = 10, species = 'dangerous', siblings=[], birthday = isodate.parse_datetime("1900-01-05T10:00:00Z"), picture = bytearray([255, 255, 255, 255, 254])) ]
        #TODO: investigate???
        #client.polymorphicrecursive.put_valid(recursiveRequest)
        pass

    def test_ensure_coverage(self):

        config = AutoRestReportServiceConfiguration("http://localhost:3000")
        config.log_level = 10
        client = AutoRestReportService(config)
        report = client.get_report()
        skipped = [k for k, v in report.items() if v == 0]

        for s in skipped:
            print("SKIPPED {0}".format(s))

        totalTests = len(report)
        print ("The test coverage is {0}/{1}.".format(totalTests - len(skipped), totalTests))
        
        self.assertEqual(0, len(skipped))

if __name__ == '__main__':
    unittest.main()
