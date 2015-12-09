// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

// TODO: file length is getting excessive.
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using AutoRest.Generator.CSharp.Tests.Utilities;
using Fixtures.AcceptanceTestsBodyArray;
using Fixtures.AcceptanceTestsBodyArray.Models;
using Fixtures.AcceptanceTestsBodyBoolean;
using Fixtures.AcceptanceTestsBodyByte;
using Fixtures.AcceptanceTestsBodyComplex;
using Fixtures.AcceptanceTestsBodyComplex.Models;
using Fixtures.AcceptanceTestsBodyDate;
using Fixtures.AcceptanceTestsBodyDateTime;
using Fixtures.AcceptanceTestsBodyDateTimeRfc1123;
using Fixtures.AcceptanceTestsBodyDictionary;
using Fixtures.AcceptanceTestsBodyDictionary.Models;
using Fixtures.AcceptanceTestsBodyDuration;
using Fixtures.AcceptanceTestsBodyFile;
using Fixtures.AcceptanceTestsBodyInteger;
using Fixtures.AcceptanceTestsBodyNumber;
using Fixtures.AcceptanceTestsBodyString;
using Fixtures.AcceptanceTestsBodyString.Models;
using Fixtures.AcceptanceTestsHeader;
using Fixtures.AcceptanceTestsHeader.Models;
using Fixtures.AcceptanceTestsHttp;
using Fixtures.AcceptanceTestsHttp.Models;
using Fixtures.AcceptanceTestsReport;
using Fixtures.AcceptanceTestsRequiredOptional;
using Fixtures.AcceptanceTestsUrl;
using Fixtures.AcceptanceTestsUrl.Models;
using Fixtures.AcceptanceTestsValidation;
using Microsoft.Rest.Serialization;
using Newtonsoft.Json;
using Xunit;
using Xunit.Abstractions;
using Error = Fixtures.AcceptanceTestsHttp.Models.Error;


namespace Microsoft.Rest.Generator.CSharp.Tests
{
    [Collection("AutoRest Tests")]
    [TestCaseOrderer("Microsoft.Rest.Generator.CSharp.Tests.AcceptanceTestOrderer",
        "AutoRest.Generator.CSharp.Tests")]
    public class AcceptanceTests : IClassFixture<ServiceController>
    {
        private static readonly TestTracingInterceptor _interceptor;

        static AcceptanceTests()
        {
            _interceptor = new TestTracingInterceptor();
            ServiceClientTracing.AddTracingInterceptor(_interceptor);
        }

        public AcceptanceTests(ServiceController data)
        {
            this.Fixture = data;
            this.Fixture.TearDown = EnsureTestCoverage;
            ServiceClientTracing.IsEnabled = false;
        }

        public ServiceController Fixture { get; set; }

        private static string ExpectedPath(string file)
        {
            return Path.Combine("Expected", "AcceptanceTests", file);
        }

        private static string SwaggerPath(string file)
        {
            return Path.Combine("Swagger", file);
        }

        [Fact]
        public void ValidationTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("validation.json"),
                ExpectedPath("Validation"));
            var client = new AutoRestValidationTest(Fixture.Uri);
            client.SubscriptionId = "abc123";
            client.ApiVersion = "12-34-5678";
            var exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("1", 100));
            Assert.Equal(ValidationRules.MinLength, exception.Rule);
            Assert.Equal("resourceGroupName", exception.Target);
            exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("1234567890A", 100));
            Assert.Equal(ValidationRules.MaxLength, exception.Rule);
            Assert.Equal("resourceGroupName", exception.Target);
            exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("!@#$", 100));
            Assert.Equal(ValidationRules.Pattern, exception.Rule);
            Assert.Equal("resourceGroupName", exception.Target);
            exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("123", 105));
            Assert.Equal(ValidationRules.MultipleOf, exception.Rule);
            Assert.Equal("id", exception.Target);
            exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("123", 0));
            Assert.Equal(ValidationRules.InclusiveMinimum, exception.Rule);
            Assert.Equal("id", exception.Target);
            exception = Assert.Throws<ValidationException>(() => client.ValidationOfMethodParameters("123", 2000));
            Assert.Equal(ValidationRules.InclusiveMaximum, exception.Rule);
            Assert.Equal("id", exception.Target);

            exception = Assert.Throws<ValidationException>(() => client.ValidationOfBody("123", 150, new Fixtures.AcceptanceTestsValidation.Models.Product
            {
                Capacity = 0
            }));
            Assert.Equal(ValidationRules.ExclusiveMinimum, exception.Rule);
            Assert.Equal("Capacity", exception.Target);
            exception = Assert.Throws<ValidationException>(() => client.ValidationOfBody("123", 150, new Fixtures.AcceptanceTestsValidation.Models.Product
            {
                Capacity = 100
            }));
            Assert.Equal(ValidationRules.ExclusiveMaximum, exception.Rule);
            Assert.Equal("Capacity", exception.Target);
            exception = Assert.Throws<ValidationException>(() => client.ValidationOfBody("123", 150, new Fixtures.AcceptanceTestsValidation.Models.Product
            {
                DisplayNames = new List<string>
                {
                    "item1","item2","item3","item4","item5","item6","item7"
                }
            }));
            Assert.Equal(ValidationRules.MaxItems, exception.Rule);
            Assert.Equal("DisplayNames", exception.Target);

            var client2 = new AutoRestValidationTest(Fixture.Uri);
            client2.SubscriptionId = "abc123";
            client2.ApiVersion = "abc";
            exception = Assert.Throws<ValidationException>(() => client2.ValidationOfMethodParameters("123", 150));
            Assert.Equal(ValidationRules.Pattern, exception.Rule);
            Assert.Equal("ApiVersion", exception.Target);
        }

        [Fact]
        public void BoolTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-boolean.json"),
                ExpectedPath("BodyBoolean"));
            var client = new AutoRestBoolTestService(Fixture.Uri);
            Assert.False(client.BoolModel.GetFalse());
            Assert.True(client.BoolModel.GetTrue());
            client.BoolModel.PutTrue(true);
            client.BoolModel.PutFalse(false);
            client.BoolModel.GetNull();
            Assert.Throws<RestException>(() => client.BoolModel.GetInvalid());
        }

        [Fact]
        public void IntegerTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-integer.json"),
                ExpectedPath("BodyInteger"));
            var client = new AutoRestIntegerTestService(Fixture.Uri);
            client.IntModel.PutMax32(Int32.MaxValue);
            client.IntModel.PutMin32(Int32.MinValue);
            client.IntModel.PutMax64(Int64.MaxValue);
            client.IntModel.PutMin64(Int64.MinValue);
            client.IntModel.GetNull();
            Assert.Throws<RestException>(() => client.IntModel.GetInvalid());
            Assert.Throws<RestException>(() => client.IntModel.GetOverflowInt32());
            Assert.Throws<RestException>(() => client.IntModel.GetOverflowInt64());
            Assert.Throws<RestException>(() => client.IntModel.GetUnderflowInt32());
            Assert.Throws<RestException>(() => client.IntModel.GetUnderflowInt64());
        }

        [Fact]
        public void NumberTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-number.json"), ExpectedPath("BodyNumber"));
            var client = new AutoRestNumberTestService(Fixture.Uri);
            client.Number.PutBigFloat(3.402823e+20);
            client.Number.PutSmallFloat(3.402823e-20);
            client.Number.PutBigDouble(2.5976931e+101);
            client.Number.PutSmallDouble(2.5976931e-101);
            client.Number.PutBigDoubleNegativeDecimal(-99999999.99);
            client.Number.PutBigDoublePositiveDecimal(99999999.99);
            client.Number.GetNull();
            Assert.Equal(3.402823e+20, client.Number.GetBigFloat());
            Assert.Equal(3.402823e-20, client.Number.GetSmallFloat());
            Assert.Equal(2.5976931e+101, client.Number.GetBigDouble());
            Assert.Equal(2.5976931e-101, client.Number.GetSmallDouble());
            Assert.Equal(-99999999.99, client.Number.GetBigDoubleNegativeDecimal());
            Assert.Equal(99999999.99, client.Number.GetBigDoublePositiveDecimal());
            Assert.Throws<RestException>(() => client.Number.GetInvalidDouble());
            Assert.Throws<RestException>(() => client.Number.GetInvalidFloat());
        }

        [Fact]
        public void StringTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-string.json"), ExpectedPath("BodyString"));
            using (var client = new AutoRestSwaggerBATService(Fixture.Uri))
            {
                Assert.Null(client.StringModel.GetNull());
                client.StringModel.PutNull(null);
                Assert.Equal(string.Empty, client.StringModel.GetEmpty());
                client.StringModel.PutEmpty("");
                Assert.Equal("啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€",
                    client.StringModel.GetMbcs());
                client.StringModel.PutMbcs("啊齄丂狛狜隣郎隣兀﨩ˊ〞〡￤℡㈱‐ー﹡﹢﹫、〓ⅰⅹ⒈€㈠㈩ⅠⅫ！￣ぁんァヶΑ︴АЯаяāɡㄅㄩ─╋︵﹄︻︱︳︴ⅰⅹɑɡ〇〾⿻⺁䜣€");
                Assert.Equal("    Now is the time for all good men to come to the aid of their country    ",
                    client.StringModel.GetWhitespace());
                client.StringModel.PutWhitespace(
                    "    Now is the time for all good men to come to the aid of their country    ");
                Assert.Null(client.StringModel.GetNotProvided());
                Assert.Equal(Colors.Redcolor, client.EnumModel.GetNotExpandable());
                client.EnumModel.PutNotExpandable(Colors.Redcolor);
            }
        }

        [Fact]
        public void ByteTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-byte.json"), ExpectedPath("BodyByte"));
            using (var client = new AutoRestSwaggerBATByteService(Fixture.Uri))
            {
                var bytes = new byte[] {0x0FF, 0x0FE, 0x0FD, 0x0FC, 0x0FB, 0x0FA, 0x0F9, 0x0F8, 0x0F7, 0x0F6};
                client.ByteModel.PutNonAscii(bytes);
                Assert.Equal(bytes, client.ByteModel.GetNonAscii());
                Assert.Null(client.ByteModel.GetNull());
                Assert.Empty(client.ByteModel.GetEmpty());
                Assert.Throws<System.FormatException>(() => client.ByteModel.GetInvalid());
            }
        }

        [Fact]
        public void FileTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-file.json"), ExpectedPath("BodyFile"));
            using (var client = new AutoRestSwaggerBATFileService(Fixture.Uri))
            {
                var stream = client.Files.GetFile();
                Assert.NotEqual(0, stream.Length);
                byte[] buffer = new byte[16 * 1024];
                using (MemoryStream ms = new MemoryStream())
                {
                    int read;
                    while ((read = stream.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        ms.Write(buffer, 0, read);
                    }
                    Assert.Equal(8725, ms.Length);
                }

                var emptyStream = client.Files.GetEmptyFile();
                Assert.Equal(0, emptyStream.Length);
            }
        }

        [Fact]
        public void DateTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-date.json"), ExpectedPath("BodyDate"));
            using (var client = new AutoRestDateTestService(Fixture.Uri))
            {
                //We need to configure the Json.net serializer to only send date on the wire. This can be done
                //by setting the {DateFormatString = "yyyy-MM-dd"} of the serializer. The tricky part is to
                //do this only for parameters/properties of format "date" but not "date-time".
                client.Date.PutMaxDate(DateTime.MaxValue);
                client.Date.PutMinDate(DateTime.MinValue);
                client.Date.GetMaxDate();
                client.Date.GetMinDate();
                client.Date.GetNull();
                Assert.Throws<FormatException>(() => client.Date.GetInvalidDate());
                Assert.Throws<FormatException>(() => client.Date.GetOverflowDate());
                Assert.Throws<FormatException>(() => client.Date.GetUnderflowDate());
            }
        }

        [Fact]
        public void DateTimeTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-datetime.json"), ExpectedPath("BodyDateTime"));
            using (var client = new AutoRestDateTimeTestService(Fixture.Uri))
            {
                client.Datetime.GetUtcLowercaseMaxDateTime();
                client.Datetime.GetUtcUppercaseMaxDateTime();
                client.Datetime.GetUtcMinDateTime();
                client.Datetime.GetLocalNegativeOffsetMinDateTime();
                //overflow-for-dotnet
                Assert.Throws<RestException>(() => client.Datetime.GetLocalNegativeOffsetLowercaseMaxDateTime());
                client.Datetime.GetLocalNegativeOffsetUppercaseMaxDateTime();
                //underflow-for-dotnet
                client.Datetime.GetLocalPositiveOffsetMinDateTime();
                client.Datetime.GetLocalPositiveOffsetLowercaseMaxDateTime();
                client.Datetime.GetLocalPositiveOffsetUppercaseMaxDateTime();
                client.Datetime.GetNull();
                client.Datetime.GetOverflow();
                Assert.Throws<RestException>(() => client.Datetime.GetInvalid());
                Assert.Throws<RestException>(() => client.Datetime.GetUnderflow());
                //The following two calls fail as datetimeoffset are always sent as local time i.e (+00:00) and not Z
                client.Datetime.PutUtcMaxDateTime(DateTime.MaxValue.ToUniversalTime());
                client.Datetime.PutUtcMinDateTime(DateTime.Parse("0001-01-01T00:00:00Z",
                    CultureInfo.InvariantCulture, DateTimeStyles.AdjustToUniversal));
                //underflow-for-dotnet
                client.Datetime.PutLocalPositiveOffsetMinDateTime(DateTime.Parse("0001-01-01T00:00:00+14:00",
                    CultureInfo.InvariantCulture));
                client.Datetime.PutLocalNegativeOffsetMinDateTime(DateTime.Parse("0001-01-01T00:00:00-14:00",
                    CultureInfo.InvariantCulture));
                //overflow-for-dotnet
                Assert.Throws<FormatException>(
                    () =>
                        client.Datetime.PutLocalNegativeOffsetMaxDateTime(
                            DateTime.Parse("9999-12-31T23:59:59.9999999-14:00",
                                CultureInfo.InvariantCulture)));
            }
        }

        [Fact]
        public void DateTimeRfc1123Tests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-datetime-rfc1123.json"), ExpectedPath("BodyDateTimeRfc1123"));
            using (var client = new AutoRestRFC1123DateTimeTestService(Fixture.Uri))
            {
                Assert.Null(client.Datetimerfc1123.GetNull());
                Assert.Throws<RestException>(() => client.Datetimerfc1123.GetInvalid());
                Assert.Throws<RestException>(() => client.Datetimerfc1123.GetUnderflow());
                Assert.Throws<RestException>(() => client.Datetimerfc1123.GetOverflow());
                client.Datetimerfc1123.GetUtcLowercaseMaxDateTime();
                client.Datetimerfc1123.GetUtcUppercaseMaxDateTime();
                client.Datetimerfc1123.GetUtcMinDateTime();

                client.Datetimerfc1123.PutUtcMaxDateTime(DateTime.MaxValue.ToUniversalTime());
                client.Datetimerfc1123.PutUtcMinDateTime(DateTime.Parse("0001-01-01T00:00:00Z",
                    CultureInfo.InvariantCulture, DateTimeStyles.AdjustToUniversal));
            }
        }
        
        [Fact]
        public void DurationTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-duration.json"), ExpectedPath("BodyDuration"));
            using (var client = new AutoRestDurationTestService(Fixture.Uri))
            {
                Assert.Null(client.Duration.GetNull());
                Assert.Throws<FormatException>(() => client.Duration.GetInvalid());

                client.Duration.GetPositiveDuration();
                client.Duration.PutPositiveDuration(new TimeSpan(123, 22, 14, 12, 11));
            }
        }

        [Fact]
        public void ArrayTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-array.json"), ExpectedPath("BodyArray"));
            using (var client =
                new AutoRestSwaggerBATArrayService(Fixture.Uri))
            {
                Assert.Empty(client.Array.GetEmpty());
                Assert.Null(client.Array.GetNull());
                client.Array.PutEmpty(new List<string>());
                Assert.True(new List<bool?> {true, false, false, true}.SequenceEqual(client.Array.GetBooleanTfft()));
                client.Array.PutBooleanTfft(new List<bool?> {true, false, false, true});
                Assert.True(new List<int?> {1, -1, 3, 300}.SequenceEqual(client.Array.GetIntegerValid()));
                client.Array.PutIntegerValid(new List<int?> {1, -1, 3, 300});
                Assert.True(new List<long?> {1L, -1, 3, 300}.SequenceEqual(client.Array.GetLongValid()));
                client.Array.PutLongValid(new List<long?> {1, -1, 3, 300});
                Assert.True(new List<double?> {0, -0.01, -1.2e20}.SequenceEqual(client.Array.GetFloatValid()));
                client.Array.PutFloatValid(new List<double?> {0, -0.01, -1.2e20});
                Assert.True(new List<double?> {0, -0.01, -1.2e20}.SequenceEqual(client.Array.GetDoubleValid()));
                client.Array.PutDoubleValid(new List<double?> {0, -0.01, -1.2e20});
                Assert.True(new List<string> {"foo1", "foo2", "foo3"}.SequenceEqual(client.Array.GetStringValid()));
                client.Array.PutStringValid(new List<string> {"foo1", "foo2", "foo3"});
                Assert.True(new List<string> {"foo", null, "foo2"}.SequenceEqual(client.Array.GetStringWithNull()));
                Assert.True(new List<string> {"foo", "123", "foo2"}.SequenceEqual(client.Array.GetStringWithInvalid()));
                var date1 = new DateTimeOffset(2000, 12, 01, 0, 0, 0, TimeSpan.Zero).UtcDateTime;
                var date2 = new DateTimeOffset(1980, 1, 2, 0, 0, 0, TimeSpan.Zero).UtcDateTime;
                var date3 = new DateTimeOffset(1492, 10, 12, 0, 0, 0, TimeSpan.Zero).UtcDateTime;
                var datetime1 = new DateTimeOffset(2000, 12, 01, 0, 0, 1, TimeSpan.Zero).UtcDateTime;
                var datetime2 = new DateTimeOffset(1980, 1, 2, 0, 11, 35, TimeSpan.Zero).UtcDateTime;
                var datetime3 = new DateTimeOffset(1492, 10, 12, 10, 15, 1, TimeSpan.Zero).UtcDateTime;
                var dateArray = client.Array.GetDateValid();
                var duration1 = new TimeSpan(123, 22, 14, 12, 11);
                var duration2 = new TimeSpan(5, 1, 0, 0, 0);

                Assert.Equal(new List<DateTime?> {date1, date2, date3}, dateArray);
                client.Array.PutDateValid(new List<DateTime?> {date1, date2, date3});
                Assert.Equal(
                    new List<DateTime?> {datetime1, datetime2, datetime3}, client.Array.GetDateTimeValid());
                client.Array.PutDateTimeValid(new List<DateTime?> {datetime1, datetime2, datetime3});
                dateArray = client.Array.GetDateTimeRfc1123Valid();
                Assert.Equal(new List<DateTime?> { datetime1, datetime2, datetime3 }, dateArray);
                client.Array.PutDateTimeRfc1123Valid(dateArray);
                Assert.Equal(new List<TimeSpan?> { duration1, duration2 }, client.Array.GetDurationValid());
                client.Array.PutDurationValid(new List<TimeSpan?> { duration1, duration2 });
                var bytes1 = new byte[] {0x0FF, 0x0FF, 0x0FF, 0x0FA};
                var bytes2 = new byte[] {0x01, 0x02, 0x03};
                var bytes3 = new byte[] {0x025, 0x029, 0x043};
                var bytes4 = new byte[] {0x0AB, 0x0AC, 0x0AD};
                client.Array.PutByteValid(new List<byte[]> {bytes1, bytes2, bytes3});
                var bytesResult = client.Array.GetByteValid();
                Assert.True(new List<byte[]> {bytes1, bytes2, bytes3}.SequenceEqual(bytesResult,
                    new ByteArrayEqualityComparer()));
                bytesResult = client.Array.GetByteInvalidNull();
                Assert.True(new List<byte[]> {bytes4, null}.SequenceEqual(bytesResult, new ByteArrayEqualityComparer()));
                var testProduct1 = new Product {Integer = 1, StringProperty = "2"};
                var testProduct2 = new Product {Integer = 3, StringProperty = "4"};
                var testProduct3 = new Product {Integer = 5, StringProperty = "6"};
                var testList1 = new List<Product> {testProduct1, testProduct2, testProduct3};
                Assert.Null(client.Array.GetComplexNull());
                Assert.Empty(client.Array.GetComplexEmpty());
                client.Array.PutComplexValid(testList1);
                Assert.True(testList1.SequenceEqual(client.Array.GetComplexValid(), new ProductEqualityComparer()));
                var listList = new List<IList<string>>
                {
                    new List<string> {"1", "2", "3"},
                    new List<string> {"4", "5", "6"},
                    new List<string> {"7", "8", "9"}
                };

                client.Array.PutArrayValid(listList);
                Assert.True(listList.SequenceEqual(client.Array.GetArrayValid(), new ListEqualityComparer<string>()));
                var listDictionary = new List<IDictionary<string, string>>
                {
                    new Dictionary<string, string> {{"1", "one"}, {"2", "two"}, {"3", "three"}},
                    new Dictionary<string, string> {{"4", "four"}, {"5", "five"}, {"6", "six"}},
                    new Dictionary<string, string> {{"7", "seven"}, {"8", "eight"}, {"9", "nine"}}
                };
                client.Array.PutDictionaryValid(listDictionary);
                Assert.True(listDictionary.SequenceEqual(client.Array.GetDictionaryValid(),
                    new DictionaryEqualityComparer<string>()));
                Assert.Null(client.Array.GetComplexNull());
                Assert.Empty(client.Array.GetComplexEmpty());
                var productList2 = new List<Product> {testProduct1, null, testProduct3};
                Assert.True(productList2.SequenceEqual(client.Array.GetComplexItemNull(), new ProductEqualityComparer()));
                var productList3 = new List<Product> {testProduct1, new Product(), testProduct3};
                var emptyComplex = client.Array.GetComplexItemEmpty();
                Assert.True(productList3.SequenceEqual(emptyComplex, new ProductEqualityComparer()));
                Assert.Null(client.Array.GetArrayNull());
                Assert.Empty(client.Array.GetArrayEmpty());
                var listList2 = new List<List<string>>
                {
                    new List<string> {"1", "2", "3"},
                    null,
                    new List<string> {"7", "8", "9"}
                };
                Assert.True(listList2.SequenceEqual(client.Array.GetArrayItemNull(), new ListEqualityComparer<string>()));
                var listList3 = new List<List<string>>
                {
                    new List<string> {"1", "2", "3"},
                    new List<string>(0),
                    new List<string> {"7", "8", "9"}
                };
                Assert.True(listList3.SequenceEqual(client.Array.GetArrayItemEmpty(), new ListEqualityComparer<string>()));
                Assert.Null(client.Array.GetDictionaryNull());
                Assert.Empty(client.Array.GetDictionaryEmpty());
                var listDictionary2 = new List<Dictionary<string, string>>
                {
                    new Dictionary<string, string> {{"1", "one"}, {"2", "two"}, {"3", "three"}},
                    null,
                    new Dictionary<string, string> {{"7", "seven"}, {"8", "eight"}, {"9", "nine"}}
                };
                Assert.True(listDictionary2.SequenceEqual(client.Array.GetDictionaryItemNull(),
                    new DictionaryEqualityComparer<string>()));
                var listDictionary3 = new List<Dictionary<string, string>>
                {
                    new Dictionary<string, string> {{"1", "one"}, {"2", "two"}, {"3", "three"}},
                    new Dictionary<string, string>(0),
                    new Dictionary<string, string> {{"7", "seven"}, {"8", "eight"}, {"9", "nine"}}
                };
                Assert.True(listDictionary3.SequenceEqual(client.Array.GetDictionaryItemEmpty(),
                    new DictionaryEqualityComparer<string>()));

                Assert.Null(client.Array.GetArrayNull());
                Assert.Throws<RestException>(() => client.Array.GetInvalid());
                Assert.True(client.Array.GetBooleanInvalidNull().SequenceEqual(new List<bool?> {true, null, false}));
                Assert.Throws<RestException>(() => client.Array.GetBooleanInvalidString());
                Assert.True(client.Array.GetIntInvalidNull().SequenceEqual(new List<int?> {1, null, 0}));
                Assert.Throws<RestException>(() => client.Array.GetIntInvalidString());
                Assert.True(client.Array.GetLongInvalidNull().SequenceEqual(new List<long?> {1, null, 0}));
                Assert.Throws<RestException>(() => client.Array.GetLongInvalidString());
                Assert.True(client.Array.GetFloatInvalidNull().SequenceEqual(new List<double?> {0.0, null, -1.2e20}));
                Assert.Throws<RestException>(() => client.Array.GetFloatInvalidString());
                Assert.True(client.Array.GetDoubleInvalidNull().SequenceEqual(new List<double?> {0.0, null, -1.2e20}));
                Assert.Throws<RestException>(() => client.Array.GetDoubleInvalidString());
                Assert.True(client.Array.GetStringWithInvalid().SequenceEqual(new List<string> {"foo", "123", "foo2"}));
                var dateNullArray = client.Array.GetDateInvalidNull();
                Assert.True(dateNullArray.SequenceEqual(new List<DateTime?>
                {
                    DateTime.Parse("2012-01-01",
                        CultureInfo.InvariantCulture),
                    null,
                    DateTime.Parse("1776-07-04", CultureInfo.InvariantCulture)
                }));
                Assert.Throws<RestException>(() => client.Array.GetDateInvalidChars());
                var dateTimeNullArray = client.Array.GetDateTimeInvalidNull();
                Assert.True(dateTimeNullArray.SequenceEqual(new List<DateTime?>
                {
                    DateTime.Parse("2000-12-01t00:00:01z",
                        CultureInfo.InvariantCulture).ToUniversalTime(),
                    null
                }));
                Assert.Throws<RestException>(() => client.Array.GetDateTimeInvalidChars());
            }
        }

        [Fact]
        public void DictionaryTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-dictionary.json"), ExpectedPath("BodyDictionary"));
            using (var client =
                new AutoRestSwaggerBATdictionaryService(Fixture.Uri))
            {
                TestBasicDictionaryParsing(client);
                TestDictionaryPrimitiveTypes(client);
                TestDictionaryComposedTypes(client);
            }
        }

        private static void TestDictionaryComposedTypes(AutoRestSwaggerBATdictionaryService client)
        {
            var testProduct1 = new Widget {Integer = 1, StringProperty = "2"};
            var testProduct2 = new Widget {Integer = 3, StringProperty = "4"};
            var testProduct3 = new Widget {Integer = 5, StringProperty = "6"};
            var testDictionary1 = new Dictionary<string, Widget>
            {
                {"0", testProduct1},
                {"1", testProduct2},
                {"2", testProduct3}
            };
            // GET complex/null
            Assert.Null(client.Dictionary.GetComplexNull());
            // GET complex/empty
            Assert.Empty(client.Dictionary.GetComplexEmpty());
            // PUT complex/valid
            client.Dictionary.PutComplexValid(testDictionary1);
            // GET complex/valid
            var complexResult = client.Dictionary.GetComplexValid();
            foreach (var key in testDictionary1.Keys)
            {
                Assert.True(complexResult.ContainsKey(key));
                Assert.Equal(testDictionary1[key], complexResult[key], new WidgetEqualityComparer());
            }
            var listDictionary = new Dictionary<string, IList<string>>
            {
                {"0", new List<string> {"1", "2", "3"}},
                {"1", new List<string> {"4", "5", "6"}},
                {"2", new List<string> {"7", "8", "9"}}
            };
            // PUT array/valid
            client.Dictionary.PutArrayValid(listDictionary);
            // GET array/valid
            var arrayResult = client.Dictionary.GetArrayValid();
            foreach (var key in listDictionary.Keys)
            {
                Assert.True(arrayResult.ContainsKey(key));
                Assert.Equal(listDictionary[key], arrayResult[key], new ListEqualityComparer<string>());
            }
            var dictionaryDictionary = new Dictionary<string, IDictionary<string, string>>
            {
                {"0", new Dictionary<string, string> {{"1", "one"}, {"2", "two"}, {"3", "three"}}},
                {"1", new Dictionary<string, string> {{"4", "four"}, {"5", "five"}, {"6", "six"}}},
                {"2", new Dictionary<string, string> {{"7", "seven"}, {"8", "eight"}, {"9", "nine"}}}
            };
            // PUT dictionary/valid
            client.Dictionary.PutDictionaryValid(dictionaryDictionary);
            // GET dictionary/valid
            var dictionaryResult = client.Dictionary.GetDictionaryValid();
            foreach (var key in dictionaryDictionary.Keys)
            {
                Assert.True(dictionaryResult.ContainsKey(key));
                Assert.Equal(dictionaryDictionary[key], dictionaryResult[key],
                    new DictionaryEqualityComparer<string>());
            }
            // GET dictionary/null
            Assert.Null(client.Dictionary.GetComplexNull());
            // GET dictionary/empty
            Assert.Empty(client.Dictionary.GetComplexEmpty());
            var productDictionary2 = new Dictionary<string, Widget>
            {
                {"0", testProduct1},
                {"1", null},
                {"2", testProduct3}
            };
            // GET complex/itemnull
            complexResult = client.Dictionary.GetComplexItemNull();
            foreach (var key in productDictionary2.Keys)
            {
                Assert.True(complexResult.ContainsKey(key));
                Assert.Equal(productDictionary2[key], complexResult[key], new WidgetEqualityComparer());
            }
            // GET complex/itemempty
            var productList3 = new Dictionary<string, Widget>
            {
                {"0", testProduct1},
                {"1", new Widget()},
                {"2", testProduct3}
            };
            complexResult = client.Dictionary.GetComplexItemEmpty();
            foreach (var key in productList3.Keys)
            {
                Assert.True(complexResult.ContainsKey(key));
                Assert.Equal(productList3[key], complexResult[key], new WidgetEqualityComparer());
            }
            // GET array/null
            Assert.Null(client.Dictionary.GetArrayNull());
            // GET array/empty
            Assert.Empty(client.Dictionary.GetArrayEmpty());
            listDictionary = new Dictionary<string, IList<string>>
            {
                {"0", new List<string> {"1", "2", "3"}},
                {"1", null},
                {"2", new List<string> {"7", "8", "9"}}
            };
            // GET array/itemnull
            arrayResult = client.Dictionary.GetArrayItemNull();
            foreach (var key in listDictionary.Keys)
            {
                Assert.True(arrayResult.ContainsKey(key));
                Assert.Equal(listDictionary[key], arrayResult[key], new ListEqualityComparer<string>());
            }
            listDictionary = new Dictionary<string, IList<string>>
            {
                {"0", new List<string> {"1", "2", "3"}},
                {"1", new List<string>(0)},
                {"2", new List<string> {"7", "8", "9"}}
            };
            // GET array/itemempty
            arrayResult = client.Dictionary.GetArrayItemEmpty();
            foreach (var key in listDictionary.Keys)
            {
                Assert.True(arrayResult.ContainsKey(key));
                Assert.Equal(listDictionary[key], arrayResult[key], new ListEqualityComparer<string>());
            }
            // GET dictionary/null
            Assert.Null(client.Dictionary.GetDictionaryNull());
            // GET dictionary/empty
            Assert.Empty(client.Dictionary.GetDictionaryEmpty());
            dictionaryDictionary = new Dictionary<string, IDictionary<string, string>>
            {
                {"0", new Dictionary<string, string> {{"1", "one"}, {"2", "two"}, {"3", "three"}}},
                {"1", null},
                {"2", new Dictionary<string, string> {{"7", "seven"}, {"8", "eight"}, {"9", "nine"}}}
            };
            // GET dictionary/itemnull
            dictionaryResult = client.Dictionary.GetDictionaryItemNull();
            foreach (var key in dictionaryDictionary.Keys)
            {
                Assert.True(dictionaryResult.ContainsKey(key));
                Assert.Equal(dictionaryDictionary[key], dictionaryResult[key],
                    new DictionaryEqualityComparer<string>());
            }
            dictionaryDictionary = new Dictionary<string, IDictionary<string, string>>
            {
                {"0", new Dictionary<string, string> {{"1", "one"}, {"2", "two"}, {"3", "three"}}},
                {"1", new Dictionary<string, string>(0)},
                {"2", new Dictionary<string, string> {{"7", "seven"}, {"8", "eight"}, {"9", "nine"}}}
            };
            // GET dictionary/itemempty
            dictionaryResult = client.Dictionary.GetDictionaryItemEmpty();
            foreach (var key in dictionaryDictionary.Keys)
            {
                Assert.True(dictionaryResult.ContainsKey(key));
                Assert.Equal(dictionaryDictionary[key], dictionaryResult[key],
                    new DictionaryEqualityComparer<string>());
            }
        }

        private static void TestDictionaryPrimitiveTypes(AutoRestSwaggerBATdictionaryService client)
        {
            var tfft = new Dictionary<string, bool?> {{"0", true}, {"1", false}, {"2", false}, {"3", true}};
            // GET prim/boolean/tfft
            Assert.Equal(tfft, client.Dictionary.GetBooleanTfft());
            // PUT prim/boolean/tfft
            client.Dictionary.PutBooleanTfft(tfft);
            var invalidNullDict = new Dictionary<string, bool?>
            {
                {"0", true},
                {"1", null},
                {"2", false}
            };

            Assert.Equal(invalidNullDict, client.Dictionary.GetBooleanInvalidNull());
            Assert.Throws<RestException>(() => client.Dictionary.GetBooleanInvalidString());
            var intValid = new Dictionary<string, int?> {{"0", 1}, {"1", -1}, {"2", 3}, {"3", 300}};
            // GET prim/integer/1.-1.3.300
            Assert.Equal(intValid, client.Dictionary.GetIntegerValid());
            // PUT prim/integer/1.-1.3.300
            client.Dictionary.PutIntegerValid(intValid);
            var intNullDict = new Dictionary<string, int?> {{"0", 1}, {"1", null}, {"2", 0}};
            Assert.Equal(intNullDict, client.Dictionary.GetIntInvalidNull());
            Assert.Throws<RestException>(() => client.Dictionary.GetIntInvalidString());

            var longValid = new Dictionary<string, long?> {{"0", 1L}, {"1", -1}, {"2", 3}, {"3", 300}};
            // GET prim/long/1.-1.3.300
            Assert.Equal(longValid, client.Dictionary.GetLongValid());
            // PUT prim/long/1.-1.3.300
            client.Dictionary.PutLongValid(longValid);
            var longNullDict = new Dictionary<string, long?> {{"0", 1}, {"1", null}, {"2", 0}};
            Assert.Equal(longNullDict, client.Dictionary.GetLongInvalidNull());
            Assert.Throws<RestException>(() => client.Dictionary.GetLongInvalidString());

            var floatValid = new Dictionary<string, double?> {{"0", 0}, {"1", -0.01}, {"2", -1.2e20}};
            // GET prim/float/0--0.01-1.2e20
            Assert.Equal(floatValid, client.Dictionary.GetFloatValid());
            // PUT prim/float/0--0.01-1.2e20
            client.Dictionary.PutFloatValid(floatValid);
            var floatNullDict = new Dictionary<string, double?> {{"0", 0.0}, {"1", null}, {"2", -1.2e20}};
            Assert.Equal(floatNullDict, client.Dictionary.GetFloatInvalidNull());
            Assert.Throws<RestException>(() => client.Dictionary.GetFloatInvalidString());
            var doubleValid = new Dictionary<string, double?> {{"0", 0}, {"1", -0.01}, {"2", -1.2e20}};
            // GET prim/double/0--0.01-1.2e20
            Assert.Equal(doubleValid, client.Dictionary.GetDoubleValid());
            // PUT prim/double/0--0.01-1.2e20
            client.Dictionary.PutDoubleValid(doubleValid);
            floatNullDict = new Dictionary<string, double?> {{"0", 0.0}, {"1", null}, {"2", -1.2e20}};
            Assert.Equal(floatNullDict, client.Dictionary.GetDoubleInvalidNull());
            Assert.Throws<RestException>(() => client.Dictionary.GetDoubleInvalidString());
            var stringValid = new Dictionary<string, string> {{"0", "foo1"}, {"1", "foo2"}, {"2", "foo3"}};
            // GET prim/string/foo1.foo2.foo3
            Assert.Equal(stringValid, client.Dictionary.GetStringValid());
            // PUT prim/string/foo1.foo2.foo3
            client.Dictionary.PutStringValid(stringValid);
            var stringNullDict = new Dictionary<string, string> {{"0", "foo"}, {"1", null}, {"2", "foo2"}};
            var stringInvalidDict = new Dictionary<string, string> {{"0", "foo"}, {"1", "123"}, {"2", "foo2"}};
            Assert.Equal(stringNullDict, client.Dictionary.GetStringWithNull());
            Assert.Equal(stringInvalidDict, client.Dictionary.GetStringWithInvalid());
            var date1 = new DateTimeOffset(2000, 12, 01, 0, 0, 0, TimeSpan.FromHours(0)).UtcDateTime;
            var date2 = new DateTimeOffset(1980, 1, 2, 0, 0, 0, TimeSpan.FromHours(0)).UtcDateTime;
            var date3 = new DateTimeOffset(1492, 10, 12, 0, 0, 0, TimeSpan.FromHours(0)).UtcDateTime;
            var datetime1 = new DateTimeOffset(2000, 12, 01, 0, 0, 1, TimeSpan.Zero).UtcDateTime;
            var datetime2 = new DateTimeOffset(1980, 1, 2, 0, 11, 35, TimeSpan.FromHours(1)).UtcDateTime;
            var datetime3 = new DateTimeOffset(1492, 10, 12, 10, 15, 1, TimeSpan.FromHours(-8)).UtcDateTime;
            var rfcDatetime1 = new DateTimeOffset(2000, 12, 01, 0, 0, 1, TimeSpan.Zero).UtcDateTime;
            var rfcDatetime2 = new DateTimeOffset(1980, 1, 2, 0, 11, 35, TimeSpan.Zero).UtcDateTime;
            var rfcDatetime3 = new DateTimeOffset(1492, 10, 12, 10, 15, 1, TimeSpan.Zero).UtcDateTime;
            var duration1 = new TimeSpan(123, 22, 14, 12, 11);
            var duration2 = new TimeSpan(5, 1, 0, 0, 0);

            // GET prim/date/valid
            var dateDictionary = client.Dictionary.GetDateValid();
            Assert.Equal(new Dictionary<string, DateTime?> {{"0", date1}, {"1", date2}, {"2", date3}},
                dateDictionary);
            client.Dictionary.PutDateValid(new Dictionary<string, DateTime?>
            {
                {"0", date1},
                {"1", date2},
                {"2", date3}
            });
            var dateNullDict = new Dictionary<string, DateTime?>
            {
                {"0", new DateTime(2012, 1, 1, 0, 0, 0, DateTimeKind.Utc)},
                {"1", null},
                {"2", new DateTime(1776, 7, 4, 0, 0, 0, DateTimeKind.Utc)}
            };
            Assert.Equal(dateNullDict, client.Dictionary.GetDateInvalidNull());
            Assert.Throws<RestException>(() => client.Dictionary.GetDateInvalidChars());
            // GET prim/datetime/valid
            Assert.Equal(new Dictionary<string, DateTime?> {{"0", datetime1}, {"1", datetime2}, {"2", datetime3}},
                client.Dictionary.GetDateTimeValid());
            client.Dictionary.PutDateTimeValid(new Dictionary<string, DateTime?>
            {
                {"0", datetime1},
                {"1", datetime2},
                {"2", datetime3}
            });
            var datetimeNullDict = new Dictionary<string, DateTime?>
            {
                {"0", new DateTime(2000, 12, 1, 0, 0, 1, DateTimeKind.Utc)},
                {"1", null}
            };
            Assert.Equal(datetimeNullDict, client.Dictionary.GetDateTimeInvalidNull());
            Assert.Throws<RestException>(() => client.Dictionary.GetDateTimeInvalidChars());
            // GET prim/datetimerfc1123/valid
            Assert.Equal(new Dictionary<string, DateTime?> { { "0", rfcDatetime1 }, { "1", rfcDatetime2 }, { "2", rfcDatetime3 } },
                client.Dictionary.GetDateTimeRfc1123Valid());
            client.Dictionary.PutDateTimeRfc1123Valid(new Dictionary<string, DateTime?>
            {
                {"0", rfcDatetime1},
                {"1", rfcDatetime2},
                {"2", rfcDatetime3}
            });
            // GET prim/duration/valid
            Assert.Equal(new Dictionary<string, TimeSpan?> { {"0", duration1}, {"1", duration2 }}, client.Dictionary.GetDurationValid());
            client.Dictionary.PutDurationValid(new Dictionary<string, TimeSpan?>
                {
                    {"0", duration1},
                    {"1", duration2},
                });
            var bytes1 = new byte[] {0x0FF, 0x0FF, 0x0FF, 0x0FA};
            var bytes2 = new byte[] {0x01, 0x02, 0x03};
            var bytes3 = new byte[] {0x025, 0x029, 0x043};
            var bytes4 = new byte[] {0x0AB, 0x0AC, 0x0AD};
            // PUT prim/byte/valid
            var bytesValid = new Dictionary<string, byte[]> {{"0", bytes1}, {"1", bytes2}, {"2", bytes3}};
            client.Dictionary.PutByteValid(bytesValid);
            // GET prim/byte/valid
            var bytesResult = client.Dictionary.GetByteValid();
            foreach (var key in bytesValid.Keys)
            {
                Assert.True(bytesResult.ContainsKey(key));
                Assert.Equal(bytesValid[key], bytesResult[key], new ByteArrayEqualityComparer());
            }
            // GET prim/byte/invalidnull
            var bytesNull = new Dictionary<string, byte[]> {{"0", bytes4}, {"1", null}};
            bytesResult = client.Dictionary.GetByteInvalidNull();
            foreach (var key in bytesNull.Keys)
            {
                Assert.True(bytesResult.ContainsKey(key));
                Assert.Equal(bytesNull[key], bytesResult[key], new ByteArrayEqualityComparer());
            }
        }

        private static void TestBasicDictionaryParsing(AutoRestSwaggerBATdictionaryService client)
        {
// GET empty
            Assert.Empty(client.Dictionary.GetEmpty());
            // PUT empty
            client.Dictionary.PutEmpty(new Dictionary<string, string>());
            // GET null
            Assert.Null(client.Dictionary.GetNull());
            // GET invalid
            Assert.Throws<RestException>(() => client.Dictionary.GetInvalid());
            // GET nullkey
            Assert.Equal(new Dictionary<string, string> {{"null", "val1"}}, client.Dictionary.GetNullKey());
            // GET nullvalue
            Assert.Equal(new Dictionary<string, string> {{"key1", null}}, client.Dictionary.GetNullValue());
            // GET keyemptyString
            Assert.Equal(new Dictionary<string, string> {{"", "val1"}}, client.Dictionary.GetEmptyStringKey());
        }

        [Fact]
        public void ComplexTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("body-complex.json"), ExpectedPath("BodyComplex"));
            using (var client = new AutoRestComplexTestService(Fixture.Uri))
            {

                /* BASIC COMPLEX TYPE TESTS */
                // GET basic/valid
                var basicResult = client.BasicOperations.GetValid();
                Assert.Equal(2, basicResult.Id);
                Assert.Equal("abc", basicResult.Name);
                Assert.Equal(CMYKColors.YELLOW, basicResult.Color);
                // PUT basic/valid
                var basicRequest = new Basic {Id = 2, Name = "abc", Color = CMYKColors.Magenta};
                client.BasicOperations.PutValid(basicRequest);
                // GET basic/empty
                basicResult = client.BasicOperations.GetEmpty();
                Assert.Equal(null, basicResult.Id);
                Assert.Equal(null, basicResult.Name);
                // GET basic/null
                client.BasicOperations.GetNull();
                Assert.Equal(null, basicResult.Id);
                Assert.Equal(null, basicResult.Name);
                // GET basic/notprovided
                client.BasicOperations.GetNotProvided();
                Assert.Equal(null, basicResult.Id);
                Assert.Equal(null, basicResult.Name);
                // GET basic/invalid
                Assert.Throws<RestException>(() => client.BasicOperations.GetInvalid());

                /* COMPLEX TYPE WITH PRIMITIVE PROPERTIES */
                // GET primitive/integer
                var intResult = client.Primitive.GetInt();
                Assert.Equal(-1, intResult.Field1);
                Assert.Equal(2, intResult.Field2);
                // PUT primitive/integer
                var intRequest = new IntWrapper {Field1 = -1, Field2 = 2};
                client.Primitive.PutInt(intRequest);
                // GET primitive/long
                var longResult = client.Primitive.GetLong();
                Assert.Equal(1099511627775, longResult.Field1);
                Assert.Equal(-999511627788, longResult.Field2);
                // PUT primitive/long
                var longRequest = new LongWrapper {Field1 = 1099511627775, Field2 = -999511627788};
                client.Primitive.PutLong(longRequest);
                // GET primitive/float
                var floatResult = client.Primitive.GetFloat();
                Assert.Equal(1.05, floatResult.Field1);
                Assert.Equal(-0.003, floatResult.Field2);
                // PUT primitive/float
                var floatRequest = new FloatWrapper {Field1 = 1.05, Field2 = -0.003};
                client.Primitive.PutFloat(floatRequest);
                // GET primitive/double
                var doubleResult = client.Primitive.GetDouble();
                Assert.Equal(3e-100, doubleResult.Field1);
                Assert.Equal(-0.000000000000000000000000000000000000000000000000000000005,
                    doubleResult.Field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose);
                // PUT primitive/double
                var doubleRequest = new DoubleWrapper
                {
                    Field1 = 3e-100,
                    Field56ZerosAfterTheDotAndNegativeZeroBeforeDotAndThisIsALongFieldNameOnPurpose
                        = -0.000000000000000000000000000000000000000000000000000000005
                };
                client.Primitive.PutDouble(doubleRequest);
                // GET primitive/bool
                var boolResult = client.Primitive.GetBool();
                Assert.Equal(true, boolResult.FieldTrue);
                Assert.Equal(false, boolResult.FieldFalse);
                // PUT primitive/bool
                var boolRequest = new BooleanWrapper {FieldFalse = false, FieldTrue = true};
                client.Primitive.PutBool(boolRequest);
                // GET primitive/string
                var stringResult = client.Primitive.GetString();
                Assert.Equal("goodrequest", stringResult.Field);
                Assert.Equal("", stringResult.Empty);
                Assert.Equal(null, stringResult.NullProperty);
                // PUT primitive/string
                var stringRequest = new StringWrapper {NullProperty = null, Empty = "", Field = "goodrequest"};
                client.Primitive.PutString(stringRequest);
                // GET primitive/date
                client.Primitive.GetDate();
                client.Primitive.PutDate(new DateWrapper
                {
                    Field = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc),
                    Leap = new DateTime(2016, 2, 29, 0, 0, 0, 0, DateTimeKind.Utc)
                });
                // GET primitive/datetime
                var datetimeResult = client.Primitive.GetDateTime();
                Assert.Equal(DateTime.MinValue, datetimeResult.Field);
                client.Primitive.PutDateTime(new DatetimeWrapper
                {
                    Field = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc),
                    Now = new DateTime(2015, 05, 18, 18, 38, 0, DateTimeKind.Utc)
                });
                // GET primitive/datetimerfc1123
                var datetimeRfc1123Result = client.Primitive.GetDateTimeRfc1123();
                Assert.Equal(DateTime.MinValue, datetimeRfc1123Result.Field);
                client.Primitive.PutDateTimeRfc1123(new Datetimerfc1123Wrapper()
                {
                    Field = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc),
                    Now = new DateTime(2015, 05, 18, 11, 38, 0, DateTimeKind.Utc)
                });
                //GET primitive/duration
                TimeSpan expectedDuration = new TimeSpan(123, 22, 14, 12, 11);
                var durationResult = client.Primitive.GetDuration();
                Assert.Equal(expectedDuration, durationResult.Field);
                client.Primitive.PutDuration(expectedDuration);

                // GET primitive/byte
                var byteResult = client.Primitive.GetByte();
                var bytes = new byte[] {0x0FF, 0x0FE, 0x0FD, 0x0FC, 0x000, 0x0FA, 0x0F9, 0x0F8, 0x0F7, 0x0F6};
                Assert.Equal(bytes, byteResult.Field);
                // PUT primitive/byte
                client.Primitive.PutByte(bytes);

                /* COMPLEX TYPE WITH ARRAY PROPERTIES */
                // GET array/valid
                var arrayResult = client.Array.GetValid();
                Assert.Equal(5, arrayResult.Array.Count);
                List<string> arrayValue = new List<string>
                {
                    "1, 2, 3, 4",
                    "",
                    null,
                    "&S#$(*Y",
                    "The quick brown fox jumps over the lazy dog"
                };
                for (int i = 0; i < 5; i++)
                {
                    Assert.Equal(arrayValue[i], arrayResult.Array[i]);
                }
                // PUT array/valid
                client.Array.PutValid(arrayValue);
                // GET array/empty
                arrayResult = client.Array.GetEmpty();
                Assert.Equal(0, arrayResult.Array.Count);
                // PUT array/empty
                arrayValue.Clear();
                client.Array.PutEmpty(arrayValue);
                // Get array/notprovided
                arrayResult = client.Array.GetNotProvided();
                Assert.Null(arrayResult.Array);

                /* COMPLEX TYPE WITH DICTIONARY PROPERTIES */
                // GET dictionary/valid
                var dictionaryResult = client.Dictionary.GetValid();
                Assert.Equal(5, dictionaryResult.DefaultProgram.Count);
                Dictionary<string, string> dictionaryValue = new Dictionary<string, string>
                {
                    {"txt", "notepad"},
                    {"bmp", "mspaint"},
                    {"xls", "excel"},
                    {"exe", ""},
                    {"", null}
                };
                Assert.Equal(dictionaryValue, dictionaryResult.DefaultProgram);
                // PUT dictionary/valid
                client.Dictionary.PutValid(dictionaryValue);
                // GET dictionary/empty
                dictionaryResult = client.Dictionary.GetEmpty();
                Assert.Equal(0, dictionaryResult.DefaultProgram.Count);
                // PUT dictionary/empty
                client.Dictionary.PutEmpty(new Dictionary<string, string>());
                // GET dictionary/null
                Assert.Null(client.Dictionary.GetNull().DefaultProgram);
                // GET dictionary/notprovided
                Assert.Null(client.Dictionary.GetNotProvided().DefaultProgram);

                /* COMPLEX TYPES THAT INVOLVE INHERITANCE */
                // GET inheritance/valid
                var inheritanceResult = client.Inheritance.GetValid();
                Assert.Equal(2, inheritanceResult.Id);
                Assert.Equal("Siameeee", inheritanceResult.Name);
                Assert.Equal(-1, inheritanceResult.Hates[1].Id);
                Assert.Equal("Tomato", inheritanceResult.Hates[1].Name);
                // PUT inheritance/valid
                var inheritanceRequest = new Siamese
                {
                    Id = 2,
                    Name = "Siameeee",
                    Color = "green",
                    Breed = "persian",
                    Hates = new List<Dog>
                    {
                        new Dog {Id = 1, Name = "Potato", Food = "tomato"},
                        new Dog {Id = -1, Name = "Tomato", Food = "french fries"}
                    }
                };
                client.Inheritance.PutValid(inheritanceRequest);

                /* COMPLEX TYPES THAT INVOLVE POLYMORPHISM */
                // GET polymorphism/valid
                var polymorphismResult = client.Polymorphism.GetValid() as Salmon;
                Assert.NotNull(polymorphismResult);
                Assert.Equal("alaska", polymorphismResult.Location);
                Assert.Equal(3, polymorphismResult.Siblings.Count);
                Assert.IsType(typeof(Shark), polymorphismResult.Siblings[0]);
                Assert.IsType(typeof(Sawshark), polymorphismResult.Siblings[1]);
                Assert.IsType(typeof(Goblinshark), polymorphismResult.Siblings[2]);
                Assert.Equal(6, ((Shark) polymorphismResult.Siblings[0]).Age);
                Assert.Equal(105, ((Sawshark) polymorphismResult.Siblings[1]).Age);
                Assert.Equal(1, ((Goblinshark)polymorphismResult.Siblings[2]).Age);
                // PUT polymorphism/valid
                var polymorphismRequest = new Salmon
                {
                    Iswild = true,
                    Length = 1,
                    Location = "alaska",
                    Species = "king",
                    Siblings = new List<Fish>
                    {
                        new Shark
                        {
                            Age = 6,
                            Length = 20,
                            Species = "predator",
                            Birthday = new DateTime(2012, 1, 5, 1, 0, 0, DateTimeKind.Utc)
                        },
                        new Sawshark
                        {
                            Age = 105,
                            Length = 10,
                            Species = "dangerous",
                            Birthday = new DateTime(1900, 1, 5, 1, 0, 0, DateTimeKind.Utc),
                            Picture = new byte[] {255, 255, 255, 255, 254}
                        },
                        new Goblinshark()
                        {
                            Age = 1,
                            Length = 30,
                            Species = "scary",
                            Birthday = new DateTime(2015, 8, 8, 0, 0, 0, DateTimeKind.Utc),
                            Jawsize = 5
                        }
                    }
                };
                client.Polymorphism.PutValid(polymorphismRequest);

                var badRequest = new Salmon
                {
                    Iswild = true,
                    Length = 1,
                    Location = "alaska",
                    Species = "king",
                    Siblings = new List<Fish>
                    {
                        new Shark
                        {
                            Age = 6,
                            Length = 20,
                            Species = "predator",
                            Birthday = new DateTime(2012, 1, 5, 1, 0, 0, DateTimeKind.Utc)
                        },
                        new Sawshark
                        {
                            Age = 105,
                            Length = 10,
                            Species = "dangerous",
                            Picture = new byte[] {255, 255, 255, 255, 254}
                        }
                    }
                };
                var missingRequired =
                    Assert.Throws<ValidationException>(() => client.Polymorphism.PutValidMissingRequired(badRequest));
                Assert.Equal("Birthday", missingRequired.Target);
                /* COMPLEX TYPES THAT INVOLVE RECURSIVE REFERENCE */
                // GET polymorphicrecursive/valid
                var recursiveResult = client.Polymorphicrecursive.GetValid();
                Assert.True(recursiveResult is Salmon);
                Assert.True(recursiveResult.Siblings[0] is Shark);
                Assert.True(recursiveResult.Siblings[0].Siblings[0] is Salmon);
                Assert.Equal("atlantic", ((Salmon) recursiveResult.Siblings[0].Siblings[0]).Location);
                // PUT polymorphicrecursive/valid
                var recursiveRequest = new Salmon
                {
                    Iswild = true,
                    Length = 1,
                    Species = "king",
                    Location = "alaska",
                    Siblings = new List<Fish>
                    {
                        new Shark
                        {
                            Age = 6,
                            Length = 20,
                            Species = "predator",
                            Siblings = new List<Fish>
                            {
                                new Salmon
                                {
                                    Iswild = true,
                                    Length = 2,
                                    Location = "atlantic",
                                    Species = "coho",
                                    Siblings = new List<Fish>
                                    {
                                        new Shark
                                        {
                                            Age = 6,
                                            Length = 20,
                                            Species = "predator",
                                            Birthday = new DateTime(2012, 1, 5, 1, 0, 0, DateTimeKind.Utc)
                                        },
                                        new Sawshark
                                        {
                                            Age = 105,
                                            Length = 10,
                                            Species = "dangerous",
                                            Birthday = new DateTime(1900, 1, 5, 1, 0, 0, DateTimeKind.Utc),
                                            Picture = new byte[] {255, 255, 255, 255, 254}
                                        }
                                    }
                                },
                                new Sawshark
                                {
                                    Age = 105,
                                    Length = 10,
                                    Species = "dangerous",
                                    Siblings = new List<Fish>(),
                                    Birthday = new DateTime(1900, 1, 5, 1, 0, 0, DateTimeKind.Utc),
                                    Picture = new byte[] {255, 255, 255, 255, 254}
                                }
                            },
                            Birthday = new DateTime(2012, 1, 5, 1, 0, 0, DateTimeKind.Utc)
                        },
                        new Sawshark
                        {
                            Age = 105,
                            Length = 10,
                            Species = "dangerous",
                            Siblings = new List<Fish>(),
                            Birthday = new DateTime(1900, 1, 5, 1, 0, 0, DateTimeKind.Utc),
                            Picture = new byte[] {255, 255, 255, 255, 254}
                        }
                    }
                };
                client.Polymorphicrecursive.PutValid(recursiveRequest);
            }
        }

        [Fact]
        public void UrlPathTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("url.json"), ExpectedPath("Url"));
            using (var client = new AutoRestUrlTestService(Fixture.Uri))
            {
                client.Paths.ByteEmpty(new byte[0]);
                Assert.Throws<ValidationException>(() => client.Paths.ByteNull(null));
                client.Paths.ByteMultiByte(Encoding.UTF8.GetBytes("啊齄丂狛狜隣郎隣兀﨩"));
                // appropriately disallowed:client.Paths.DateNull(null);
                // appropriately disallowed: client.Paths.DateTimeNull(null);
                client.Paths.DateTimeValid(new DateTime(2012, 1, 1, 1, 1, 1, DateTimeKind.Utc));
                client.Paths.DateValid(new DateTime(2012, 1, 1, 0, 0, 0, DateTimeKind.Utc));
                client.Paths.DoubleDecimalNegative(-9999999.999);
                client.Paths.DoubleDecimalPositive(9999999.999);
                client.Paths.FloatScientificNegative(-1.034e-20);
                client.Paths.FloatScientificPositive(1.034e+20);
                client.Paths.GetBooleanFalse(false);
                client.Paths.GetBooleanTrue(true);
                client.Paths.GetIntNegativeOneMillion(-1000000);
                client.Paths.GetIntOneMillion(1000000);
                client.Paths.GetNegativeTenBillion(-10000000000);
                client.Paths.GetTenBillion(10000000000);
                client.Paths.StringEmpty("");
                Assert.Throws<ValidationException>(() => client.Paths.StringNull(null));
                client.Paths.StringUrlEncoded(@"begin!*'();:@ &=+$,/?#[]end");
                client.Paths.EnumValid(UriColor.Greencolor);
                Assert.Throws<ValidationException>(() => client.Paths.EnumNull(null));
            }
        }

        [Fact]
        public void HeaderTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("header.json"), ExpectedPath("Header"));
            using (var client = new AutoRestSwaggerBATHeaderService(Fixture.Uri))
            {
                // POST param/prim/integer
                client.Header.ParamInteger("positive", 1);
                client.Header.ParamInteger("negative", -2);
                
                // POST response/prim/integer
                var responseInteger = client.Header.ResponseIntegerWithHttpMessagesAsync("positive").Result;
                Assert.Equal(1, int.Parse(responseInteger.Response.Headers.GetValues("value").FirstOrDefault(),
                    CultureInfo.InvariantCulture));
                Assert.Equal(1, responseInteger.Headers.Value);

                responseInteger = client.Header.ResponseIntegerWithHttpMessagesAsync("negative").Result;
                Assert.Equal(-2, int.Parse(responseInteger.Response.Headers.GetValues("value").FirstOrDefault(),
                    CultureInfo.InvariantCulture));
                Assert.Equal(-2, responseInteger.Headers.Value);

                // POST param/prim/long
                client.Header.ParamLong("positive", 105);
                client.Header.ParamLong("negative", -2);

                // POST response/prim/long
                var responseLong = client.Header.ResponseLongWithHttpMessagesAsync("positive").Result;
                Assert.Equal(105, long.Parse(responseLong.Response.Headers.GetValues("value").FirstOrDefault(),
                    CultureInfo.InvariantCulture));
                Assert.Equal(105, responseLong.Headers.Value);

                responseLong = client.Header.ResponseLongWithHttpMessagesAsync("negative").Result;
                Assert.Equal(-2, long.Parse(responseLong.Response.Headers.GetValues("value").FirstOrDefault(),
                    CultureInfo.InvariantCulture));
                Assert.Equal(-2, responseLong.Headers.Value);

                // POST param/prim/float
                client.Header.ParamFloat("positive", 0.07);
                client.Header.ParamFloat("negative", -3.0);
                
                // POST response/prim/float
                var responseFloat = client.Header.ResponseFloatWithHttpMessagesAsync("positive").Result;
                Assert.True(Math.Abs(0.07 - float.Parse(responseFloat.Response.Headers.GetValues("value").FirstOrDefault(),
                    CultureInfo.InvariantCulture)) < 0.00001);
                Assert.True(Math.Abs(0.07 - responseFloat.Headers.Value.Value) < 0.00001);

                responseFloat = client.Header.ResponseFloatWithHttpMessagesAsync("negative").Result;
                Assert.True(Math.Abs(-3 - float.Parse(responseFloat.Response.Headers.GetValues("value").FirstOrDefault(),
                    CultureInfo.InvariantCulture)) < 0.00001);
                Assert.True(Math.Abs(-3 - responseFloat.Headers.Value.Value) < 0.00001);

                // POST param/prim/double
                client.Header.ParamDouble("positive", 7e120);
                client.Header.ParamDouble("negative", -3.0);

                // POST response/prim/double
                var responseDouble = client.Header.ResponseDoubleWithHttpMessagesAsync("positive").Result;
                Assert.Equal(7e120, double.Parse(responseDouble.Response.Headers.GetValues("value").FirstOrDefault(),
                    CultureInfo.InvariantCulture));
                Assert.Equal(7e120, responseDouble.Headers.Value);

                responseDouble = client.Header.ResponseDoubleWithHttpMessagesAsync("negative").Result;
                Assert.Equal(-3, double.Parse(responseDouble.Response.Headers.GetValues("value").FirstOrDefault(),
                    CultureInfo.InvariantCulture));
                Assert.Equal(-3, responseDouble.Headers.Value);

                // POST param/prim/bool
                client.Header.ParamBool("true", true);
                client.Header.ParamBool("false", false);

                // POST response/prim/bool
                var responseBool = client.Header.ResponseBoolWithHttpMessagesAsync("true").Result;
                Assert.Equal(true, bool.Parse(responseBool.Response.Headers.GetValues("value").FirstOrDefault()));
                Assert.Equal(true, responseBool.Headers.Value);

                responseBool = client.Header.ResponseBoolWithHttpMessagesAsync("false").Result;
                Assert.Equal(false, bool.Parse(responseBool.Response.Headers.GetValues("value").FirstOrDefault()));
                Assert.Equal(false, responseBool.Headers.Value);

                // POST param/prim/string
                client.Header.ParamString("valid", "The quick brown fox jumps over the lazy dog");
                client.Header.ParamString("null", null);
                client.Header.ParamString("empty", "");

                // POST response/prim/string
                var responseString = client.Header.ResponseStringWithHttpMessagesAsync("valid").Result;
                Assert.Equal("The quick brown fox jumps over the lazy dog",
                    responseString.Response.Headers.GetValues("value").FirstOrDefault());
                Assert.Equal("The quick brown fox jumps over the lazy dog", responseString.Headers.Value);

                responseString = client.Header.ResponseStringWithHttpMessagesAsync("null").Result;
                Assert.Equal("null", responseString.Response.Headers.GetValues("value").FirstOrDefault());
                Assert.Equal("null", responseString.Headers.Value);

                responseString = client.Header.ResponseStringWithHttpMessagesAsync("empty").Result;
                Assert.Equal("", responseString.Response.Headers.GetValues("value").FirstOrDefault());
                Assert.Equal("", responseString.Headers.Value);

                // POST param/prim/enum
                client.Header.ParamEnum("valid", GreyscaleColors.GREY);
                client.Header.ParamEnum("null", null);

                // POST response/prim/enum
                var responseEnum = client.Header.ResponseEnumWithHttpMessagesAsync("valid").Result;
                Assert.Equal("GREY", responseEnum.Response.Headers.GetValues("value").FirstOrDefault());
                Assert.Equal(GreyscaleColors.GREY, responseEnum.Headers.Value);

                responseEnum = client.Header.ResponseEnumWithHttpMessagesAsync("null").Result;
                
                Assert.Equal("", responseEnum.Response.Headers.GetValues("value").FirstOrDefault());
                Assert.Equal(null, responseEnum.Headers.Value);

                // POST param/prim/date
                client.Header.ParamDate("valid", new DateTime(2010, 1, 1, 0, 0, 0, DateTimeKind.Utc));
                client.Header.ParamDate("min", DateTime.MinValue);

                // POST response/prim/date
                var responseDate = client.Header.ResponseDateWithHttpMessagesAsync("valid").Result;
                Assert.Equal(new DateTimeOffset(new DateTime(2010, 1, 1, 0, 0, 0, DateTimeKind.Local)),
                    JsonConvert.DeserializeObject<DateTimeOffset>(
                        "\"" + responseDate.Response.Headers.GetValues("value").FirstOrDefault() + "\""));
                Assert.Equal(new DateTime(2010, 1, 1, 0, 0, 0, DateTimeKind.Local), responseDate.Headers.Value);
                
                responseDate = client.Header.ResponseDateWithHttpMessagesAsync("min").Result;
                Assert.Equal(DateTime.MinValue,
                    JsonConvert.DeserializeObject<DateTime>(
                        "\"" + responseDate.Response.Headers.GetValues("value").FirstOrDefault() + "\""));
                Assert.Equal(DateTime.MinValue, responseDate.Headers.Value);

                // POST param/prim/datetime
                client.Header.ParamDatetime("valid", new DateTime(2010, 1, 1, 12, 34, 56, DateTimeKind.Utc));
                client.Header.ParamDatetime("min", DateTime.MinValue);

                // POST response/prim/datetime
                var responseDateTime = client.Header.ResponseDatetimeWithHttpMessagesAsync("valid").Result;
                Assert.Equal(new DateTimeOffset(new DateTime(2010, 1, 1, 12, 34, 56, DateTimeKind.Utc)),
                    JsonConvert.DeserializeObject<DateTimeOffset>(
                        "\"" + responseDateTime.Response.Headers.GetValues("value").FirstOrDefault() + "\""));
                Assert.Equal(new DateTime(2010, 1, 1, 12, 34, 56, DateTimeKind.Utc), responseDateTime.Headers.Value);

                responseDateTime = client.Header.ResponseDatetimeWithHttpMessagesAsync("min").Result;
                Assert.Equal(DateTimeOffset.MinValue,
                    JsonConvert.DeserializeObject<DateTimeOffset>(
                        "\"" + responseDateTime.Response.Headers.GetValues("value").FirstOrDefault() + "\""));
                Assert.Equal(DateTime.MinValue, responseDateTime.Headers.Value);

                // POST param/prim/datetimerfc1123
                client.Header.ParamDatetimeRfc1123("valid", new DateTime(2010, 1, 1, 12, 34, 56, DateTimeKind.Utc));
                client.Header.ParamDatetimeRfc1123("min", DateTime.MinValue);

                //POST response/prim/datetimerfc1123
                var responseDateTimeRfc1123 = client.Header.ResponseDatetimeRfc1123WithHttpMessagesAsync("valid").Result;
                Assert.Equal(new DateTimeOffset(new DateTime(2010, 1, 1, 12, 34, 56, DateTimeKind.Utc)),
                    JsonConvert.DeserializeObject<DateTimeOffset>(
                        "\"" + responseDateTimeRfc1123.Response.Headers.GetValues("value").FirstOrDefault() + "\""));
                Assert.Equal(new DateTime(2010, 1, 1, 12, 34, 56, DateTimeKind.Utc),
                    responseDateTimeRfc1123.Headers.Value);

                responseDateTimeRfc1123 = client.Header.ResponseDatetimeRfc1123WithHttpMessagesAsync("min").Result;
                Assert.Equal(DateTimeOffset.MinValue,
                    JsonConvert.DeserializeObject<DateTimeOffset>(
                        "\"" + responseDateTimeRfc1123.Response.Headers.GetValues("value").FirstOrDefault() + "\""));
                Assert.Equal(DateTime.MinValue,
                    responseDateTimeRfc1123.Headers.Value);

                // POST param/prim/duration
                client.Header.ParamDuration("valid", new TimeSpan(123, 22, 14, 12, 11));

                // POST response/prim/duration
                var responseDuration = client.Header.ResponseDurationWithHttpMessagesAsync("valid").Result;
                Assert.Equal(new TimeSpan(123, 22, 14, 12, 11),
                    JsonConvert.DeserializeObject<TimeSpan?>(
                    "\"" + responseDuration.Response.Headers.GetValues("value").FirstOrDefault() + "\"", 
                    new Iso8601TimeSpanConverter()));
                Assert.Equal(new TimeSpan(123, 22, 14, 12, 11),
                    responseDuration.Headers.Value);

                // POST param/prim/string
                client.Header.ParamByte("valid", Encoding.UTF8.GetBytes("啊齄丂狛狜隣郎隣兀﨩"));

                // POST response/prim/byte
                var responseByte = client.Header.ResponseByteWithHttpMessagesAsync("valid").Result;
                Assert.Equal(Encoding.UTF8.GetBytes("啊齄丂狛狜隣郎隣兀﨩"),
                    JsonConvert.DeserializeObject<Byte[]>(
                        "\"" + responseByte.Response.Headers.GetValues("value").FirstOrDefault() + "\""));
                Assert.Equal(Encoding.UTF8.GetBytes("啊齄丂狛狜隣郎隣兀﨩"),
                    responseByte.Headers.Value);

                // POST param/existingkey
                client.Header.ParamExistingKey("overwrite");

                // POST response/existingkey
                var responseExistingKey = client.Header.ResponseExistingKeyWithHttpMessagesAsync().Result;
                Assert.Equal("overwrite", responseExistingKey.Response.Headers.GetValues("User-Agent").FirstOrDefault());
                Assert.Equal("overwrite", responseExistingKey.Headers.UserAgent);

                // POST param/existingkey
                Assert.Throws<InvalidOperationException>(() => client.Header.ParamProtectedKey("text/html"));

                // POST response/protectedkey
                var responseProtectedKey = client.Header.ResponseProtectedKeyWithHttpMessagesAsync().Result;
                Assert.False(responseProtectedKey.Response.Headers.Any(header => header.Key == "Content-Type"));

                var customHeader = new Dictionary<string, List<string>>
                {
                    {
                        "x-ms-client-request-id", new List<string> {"9C4D50EE-2D56-4CD3-8152-34347DC9F2B0"}
                    }
                };

                Assert.Equal(HttpStatusCode.OK, client.Header.CustomRequestIdWithHttpMessagesAsync(customHeader).Result.Response.StatusCode);

            }
        }

        [Fact]
        public void UrlQueryTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("url.json"), ExpectedPath("Url"));
            using (var client = new AutoRestUrlTestService(Fixture.Uri))
            {
                client.Queries.ByteEmpty(new byte[0]);
                client.Queries.ByteMultiByte(Encoding.UTF8.GetBytes("啊齄丂狛狜隣郎隣兀﨩"));
                client.Queries.ByteNull();
                client.Queries.DateNull();
                client.Queries.DateTimeNull();
                client.Queries.DateTimeValid(new DateTime(2012, 1, 1, 1, 1, 1, DateTimeKind.Utc));
                client.Queries.DateValid(new DateTime(2012, 1, 1, 0, 0, 0, DateTimeKind.Utc));
                client.Queries.DoubleNull();
                client.Queries.DoubleDecimalNegative(-9999999.999);
                client.Queries.DoubleDecimalPositive(9999999.999);
                client.Queries.FloatScientificNegative(-1.034e-20);
                client.Queries.FloatScientificPositive(1.034e20);
                client.Queries.FloatNull();
                client.Queries.GetBooleanFalse(false);
                client.Queries.GetBooleanTrue(true);
                client.Queries.GetBooleanNull();
                client.Queries.GetIntNegativeOneMillion(-1000000);
                client.Queries.GetIntOneMillion(1000000);
                client.Queries.GetIntNull();
                client.Queries.GetNegativeTenBillion(-10000000000);
                client.Queries.GetTenBillion(10000000000);
                client.Queries.GetLongNull();
                client.Queries.StringEmpty("");
                client.Queries.StringNull();
                client.Queries.StringUrlEncoded("begin!*'();:@ &=+$,/?#[]end");
                client.Queries.EnumValid(UriColor.Greencolor);
                client.Queries.EnumNull();
                client.Queries.ArrayStringCsvEmpty(new List<string>(0));
                client.Queries.ArrayStringCsvNull();
                var testArray = new List<string> {"ArrayQuery1", @"begin!*'();:@ &=+$,/?#[]end", null, ""};
                client.Queries.ArrayStringCsvValid(testArray);
                client.Queries.ArrayStringPipesValid(testArray);
                client.Queries.ArrayStringSsvValid(testArray);
                client.Queries.ArrayStringTsvValid(testArray);
            }
        }

        [Fact]
        public void UrlMixedTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("url.json"), ExpectedPath("Url"));
            using (var client = new AutoRestUrlTestService(Fixture.Uri))
            {
                client.GlobalStringPath = "globalStringPath";
                client.GlobalStringQuery = "globalStringQuery";
                client.PathItems.GetAllWithValues("localStringPath", "pathItemStringPath",
                     "localStringQuery", "pathItemStringQuery");
                client.GlobalStringQuery = null;
                client.PathItems.GetGlobalAndLocalQueryNull("localStringPath", "pathItemStringPath",
                    null, "pathItemStringQuery");
                client.PathItems.GetGlobalQueryNull("localStringPath", "pathItemStringPath",
                    "localStringQuery", "pathItemStringQuery");
                client.GlobalStringQuery = "globalStringQuery";
                client.PathItems.GetLocalPathItemQueryNull("localStringPath", "pathItemStringPath",
                    null, null);
            }
        }

        [Fact]
        public void HttpInfrastructureTests()
        {
            SwaggerSpecRunner.RunTests(
               SwaggerPath("httpInfrastructure.json"), ExpectedPath("Http"));
            using (var client = new AutoRestHttpInfrastructureTestService(Fixture.Uri))
            {
                TestSuccessStatusCodes(client);
                TestRedirectStatusCodes(client);
                TestClientErrorStatusCodes(client);
                TestServerErrorStatusCodes(client);
                TestResponseModeling(client);
            }
        }

        private static void TestResponseModeling(AutoRestHttpInfrastructureTestService client)
        {
            Assert.Equal<string>("200", client.MultipleResponses.Get200Model204NoModelDefaultError200Valid().StatusCode);
            EnsureThrowsWithStatusCode(HttpStatusCode.Created,
                () => client.MultipleResponses.Get200Model204NoModelDefaultError201Invalid());
            EnsureThrowsWithStatusCode(HttpStatusCode.Accepted,
                () => client.MultipleResponses.Get200Model204NoModelDefaultError202None());
            Assert.Null(client.MultipleResponses.Get200Model204NoModelDefaultError204Valid());
            EnsureThrowsWithStatusCodeAndError(HttpStatusCode.BadRequest,
                () => client.MultipleResponses.Get200Model204NoModelDefaultError400Valid(), "client error");
            Assert.Equal("200", client.MultipleResponses.Get200Model201ModelDefaultError200Valid().StatusCode);
            var bModel = client.MultipleResponses.Get200Model201ModelDefaultError201Valid() as B;
            Assert.NotNull(bModel);
            Assert.Equal(bModel.StatusCode, "201");
            Assert.Equal(bModel.TextStatusCode, "Created");
            EnsureThrowsWithStatusCodeAndError(HttpStatusCode.BadRequest,
                () => client.MultipleResponses.Get200Model201ModelDefaultError400Valid(), "client error");
            var aModel = client.MultipleResponses.Get200ModelA201ModelC404ModelDDefaultError200Valid() as A;
            Assert.NotNull(aModel);
            Assert.Equal("200", aModel.StatusCode);
            var cModel = client.MultipleResponses.Get200ModelA201ModelC404ModelDDefaultError201Valid() as C;
            Assert.NotNull(cModel);
            Assert.Equal("201", cModel.HttpCode);
            var dModel = client.MultipleResponses.Get200ModelA201ModelC404ModelDDefaultError404Valid() as D;
            Assert.NotNull(dModel);
            Assert.Equal("404", dModel.HttpStatusCode);
            EnsureThrowsWithStatusCodeAndError(HttpStatusCode.BadRequest,
                () => client.MultipleResponses.Get200ModelA201ModelC404ModelDDefaultError400Valid(), "client error");
            client.MultipleResponses.Get202None204NoneDefaultError202None();
            client.MultipleResponses.Get202None204NoneDefaultError204None();
            EnsureThrowsWithStatusCodeAndError(HttpStatusCode.BadRequest,
                () => client.MultipleResponses.Get202None204NoneDefaultError400Valid(), "client error");
            client.MultipleResponses.Get202None204NoneDefaultNone202Invalid();
            client.MultipleResponses.Get202None204NoneDefaultNone204None();
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest,
                () => client.MultipleResponses.Get202None204NoneDefaultNone400None());
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest,
                () => client.MultipleResponses.Get202None204NoneDefaultNone400Invalid());
            Assert.Equal("200", client.MultipleResponses.GetDefaultModelA200Valid().StatusCode);
            Assert.Null(client.MultipleResponses.GetDefaultModelA200None());
            client.MultipleResponses.GetDefaultModelA200Valid();
            client.MultipleResponses.GetDefaultModelA200None();
            EnsureThrowsWithErrorModel<A>(HttpStatusCode.BadRequest,
                () => client.MultipleResponses.GetDefaultModelA400Valid(), (e) => Assert.Equal("400", e.StatusCode));
            EnsureThrowsWithErrorModel<A>(HttpStatusCode.BadRequest,
                () => client.MultipleResponses.GetDefaultModelA400None(), Assert.Null);
            client.MultipleResponses.GetDefaultNone200Invalid();
            client.MultipleResponses.GetDefaultNone200None();
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, client.MultipleResponses.GetDefaultNone400Invalid);
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, client.MultipleResponses.GetDefaultNone400None);
            Assert.Null(client.MultipleResponses.Get200ModelA200None());
            Assert.Equal("200", client.MultipleResponses.Get200ModelA200Valid().StatusCode);
            Assert.Null(client.MultipleResponses.Get200ModelA200Invalid().StatusCode);
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, () => client.MultipleResponses.Get200ModelA400None());
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, () => client.MultipleResponses.Get200ModelA400Valid());
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, () => client.MultipleResponses.Get200ModelA400Invalid());
            EnsureThrowsWithStatusCode(HttpStatusCode.Accepted, () => client.MultipleResponses.Get200ModelA202Valid());
        }

        private static void TestServerErrorStatusCodes(AutoRestHttpInfrastructureTestService client)
        {
            EnsureThrowsWithStatusCode(HttpStatusCode.NotImplemented, () => client.HttpServerFailure.Head501());
            EnsureThrowsWithStatusCode(HttpStatusCode.NotImplemented, () => client.HttpServerFailure.Get501());
            EnsureThrowsWithStatusCode(HttpStatusCode.HttpVersionNotSupported, () => client.HttpServerFailure.Post505(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.HttpVersionNotSupported, () => client.HttpServerFailure.Delete505(true));
            client.HttpRetry.Head408();
            //TODO: Retry logic is flakey on Unix under DNX
            //client.HttpRetry.Get502();            
            //client.HttpRetry.Get502();
            //client.HttpRetry.Put500(true);
            //TODO, 4042586: Support options operations in swagger modeler
            //client.HttpRetry.Options429();
            //client.HttpRetry.Patch500(true);
            //client.HttpRetry.Post503(true);
            //client.HttpRetry.Delete503(true);
            //client.HttpRetry.Put504(true);
            //client.HttpRetry.Patch504(true);
        }

        private static void TestClientErrorStatusCodes(AutoRestHttpInfrastructureTestService client)
        {
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, () => client.HttpClientFailure.Head400());
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, () => client.HttpClientFailure.Get400());
            //TODO, 4042586: Support options operations in swagger modeler
            //EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, () => client.HttpClientFailure.Options400());
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, () => client.HttpClientFailure.Put400(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, () => client.HttpClientFailure.Patch400(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, () => client.HttpClientFailure.Post400(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.BadRequest, () => client.HttpClientFailure.Delete400(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.Unauthorized, () => client.HttpClientFailure.Head401());
            EnsureThrowsWithStatusCode(HttpStatusCode.PaymentRequired, () => client.HttpClientFailure.Get402());
            //TODO, 4042586: Support options operations in swagger modeler
            //EnsureThrowsWithStatusCode(HttpStatusCode.Forbidden, () => client.HttpClientFailure.Options403());
            EnsureThrowsWithStatusCode(HttpStatusCode.Forbidden, () => client.HttpClientFailure.Get403());
            EnsureThrowsWithStatusCode(HttpStatusCode.NotFound, () => client.HttpClientFailure.Put404(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.MethodNotAllowed, () => client.HttpClientFailure.Patch405(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.NotAcceptable, () => client.HttpClientFailure.Post406(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.Conflict, () => client.HttpClientFailure.Put409(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.Gone, () => client.HttpClientFailure.Head410());
            EnsureThrowsWithStatusCode(HttpStatusCode.LengthRequired, () => client.HttpClientFailure.Get411());
            //TODO, 4042586: Support options operations in swagger modeler
            //EnsureThrowsWithStatusCode(HttpStatusCode.PreconditionFailed, () => client.HttpClientFailure.Options412());
            EnsureThrowsWithStatusCode(HttpStatusCode.PreconditionFailed, () => client.HttpClientFailure.Get412());
            EnsureThrowsWithStatusCode(HttpStatusCode.RequestEntityTooLarge, () => client.HttpClientFailure.Put413(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.RequestUriTooLong, () => client.HttpClientFailure.Patch414(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.UnsupportedMediaType, () => client.HttpClientFailure.Post415(true));
            EnsureThrowsWithStatusCode(HttpStatusCode.RequestedRangeNotSatisfiable, () => client.HttpClientFailure.Get416());
            EnsureThrowsWithStatusCode(HttpStatusCode.ExpectationFailed, () => client.HttpClientFailure.Delete417(true));
            EnsureThrowsWithStatusCode((HttpStatusCode) 429, () => client.HttpClientFailure.Head429());
        }

        private static void TestRedirectStatusCodes(AutoRestHttpInfrastructureTestService client)
        {
#if !PORTABLE
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Head300WithHttpMessagesAsync());
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Get300WithHttpMessagesAsync());
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Head302WithHttpMessagesAsync());
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Head301WithHttpMessagesAsync());
#endif
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Get301WithHttpMessagesAsync());
            //TODO, 4048201: http client incorrectly redirects non-get/head requests when receiving a 301 or 302 response
            //EnsureStatusCode(HttpStatusCode.MovedPermanently, () => client.HttpRedirects.Put301WithHttpMessagesAsync(true));
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Get302WithHttpMessagesAsync());
            //TODO, 4048201: http client incorrectly redirects non-get/head requests when receiving a 301 or 302 response
            //EnsureStatusCode(HttpStatusCode.Found, () => client.HttpRedirects.Patch302WithHttpMessagesAsync(true));
#if !PORTABLE // this is caused because of https://github.com/mono/mono/blob/master/mcs/class/System/System.Net/HttpWebRequest.cs#L1107
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Post303WithHttpMessagesAsync(true));
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Head307WithHttpMessagesAsync());
#endif
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Get307WithHttpMessagesAsync());
            //TODO, 4042586: Support options operations in swagger modeler
            //EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Options307WithHttpMessagesAsync());
#if !PORTABLE // this is caused because of https://github.com/mono/mono/blob/master/mcs/class/System/System.Net/HttpWebRequest.cs#L1107
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Put307WithHttpMessagesAsync(true));
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Post307WithHttpMessagesAsync(true));
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Patch307WithHttpMessagesAsync(true));
            EnsureStatusCode(HttpStatusCode.OK, () => client.HttpRedirects.Delete307WithHttpMessagesAsync(true));
#endif
        }

        private static void TestSuccessStatusCodes(AutoRestHttpInfrastructureTestService client)
        {
            var ex = Assert.Throws<Fixtures.AcceptanceTestsHttp.Models.ErrorException>(() => client.HttpFailure.GetEmptyError());
            Assert.Equal("Operation returned an invalid status code 'BadRequest'", ex.Message);
            client.HttpSuccess.Head200();
            Assert.True(client.HttpSuccess.Get200());
            client.HttpSuccess.Put200(true);
            client.HttpSuccess.Post200(true);
            client.HttpSuccess.Patch200(true);
            client.HttpSuccess.Delete200(true);
            //TODO, 4042586: Support options operations in swagger modeler
            //Assert.True(client.HttpSuccess.Options200();
            client.HttpSuccess.Put201(true);
            client.HttpSuccess.Post201(true);
            client.HttpSuccess.Put202(true);
            client.HttpSuccess.Post202(true);
            client.HttpSuccess.Patch202(true);
            client.HttpSuccess.Delete202(true);
            client.HttpSuccess.Head204();
            client.HttpSuccess.Put204(true);
            client.HttpSuccess.Post204(true);
            client.HttpSuccess.Delete204(true);
            client.HttpSuccess.Head404();
            client.HttpSuccess.Patch204(true);
        }

        [Fact]
        public void RequiredOptionalNegativeTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("required-optional.json"), ExpectedPath("RequiredOptional"));
            using (var client = new AutoRestRequiredOptionalTestService(Fixture.Uri))
            {

                Assert.Throws<ValidationException>(() =>
                    client.ImplicitModel.GetRequiredPath(null));
                Assert.Throws<ValidationException>(() =>
                    client.ExplicitModel.PostRequiredStringHeader(null));
                Assert.Throws<ValidationException>(() =>
                    client.ExplicitModel.PostRequiredStringParameter(null));
                Assert.Throws<ValidationException>(() =>
                    client.ExplicitModel.PostRequiredStringProperty(null));
                Assert.Throws<ValidationException>(() =>
                    client.ExplicitModel.PostRequiredArrayHeader(null));
                Assert.Throws<ValidationException>(() =>
                    client.ExplicitModel.PostRequiredArrayParameter(null));
                Assert.Throws<ValidationException>(() =>
                    client.ExplicitModel.PostRequiredArrayProperty(null));
                Assert.Throws<ValidationException>(() =>
                    client.ExplicitModel.PostRequiredClassParameter(null));
                Assert.Throws<ValidationException>(() =>
                    client.ExplicitModel.PostRequiredClassProperty(null));
                Assert.Throws<ValidationException>(() =>
                    client.ImplicitModel.GetRequiredGlobalPath());
                Assert.Throws<ValidationException>(() =>
                    client.ImplicitModel.GetRequiredGlobalQuery());
            }
        }

        [Fact]
        public void RequiredOptionalTests()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("required-optional.json"), ExpectedPath("RequiredOptional"));
            using (var client = new AutoRestRequiredOptionalTestService(Fixture.Uri))
            {

                Assert.Equal(HttpStatusCode.OK,
                    client.ImplicitModel.PutOptionalQueryWithHttpMessagesAsync(null).Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ImplicitModel.PutOptionalBodyWithHttpMessagesAsync(null).Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ImplicitModel.PutOptionalHeaderWithHttpMessagesAsync(null).Result.Response.StatusCode);
                // This is wrong! Global parameters not working...
                Assert.Equal(HttpStatusCode.OK,
                    client.ImplicitModel.GetOptionalGlobalQueryWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);

                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalIntegerParameterWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalIntegerPropertyWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalIntegerHeaderWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalStringParameterWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalStringPropertyWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalStringHeaderWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalClassParameterWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalClassPropertyWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalArrayParameterWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalArrayPropertyWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
                Assert.Equal(HttpStatusCode.OK,
                    client.ExplicitModel.PostOptionalArrayHeaderWithHttpMessagesAsync(null)
                        .Result.Response.StatusCode);
            }
        }

        public void EnsureTestCoverage()
        {
            SwaggerSpecRunner.RunTests(
                SwaggerPath("report.json"), ExpectedPath("Report"));
            using (var client =
                new AutoRestReportService(Fixture.Uri))
            {
                var report = client.GetReport();
                //TODO, 4048201: http client incorrectly redirects non-get/head requests when receiving a 301 or 302 response
                report["HttpRedirect301Put"] = 1;
                report["HttpRedirect302Patch"] = 1;
                var skipped = report.Where(p => p.Value == 0).Select(p => p.Key);
                foreach(var item in skipped)
                {
                    Trace.WriteLine(string.Format(CultureInfo.CurrentCulture, "SKIPPED {0}.", item));
                }
#if PORTABLE
                float totalTests = report.Count - 7;  // there are 7 tests that fail in DNX
#else
                float totalTests = report.Count;
#endif
                float executedTests = report.Values.Count(v => v > 0);
                Trace.WriteLine(string.Format(CultureInfo.CurrentCulture, "The test coverage is {0}/{1}.",
                    executedTests, totalTests));
                Assert.Equal(totalTests, executedTests);
            }
        }

        private static void EnsureStatusCode(HttpStatusCode expectedStatusCode, Func<Task<HttpOperationResponse>> operation)
        {
            var response = operation().GetAwaiter().GetResult();
            Assert.Equal(response.Response.StatusCode, expectedStatusCode);
        }

        private static void EnsureStatusCode<TBody, THeader>(HttpStatusCode expectedStatusCode, Func<Task<HttpOperationResponse<TBody, THeader>>> operation)
        {
            var response = operation().GetAwaiter().GetResult();
            Assert.Equal(response.Response.StatusCode, expectedStatusCode);
        }

        private static void EnsureStatusCode<THeader>(HttpStatusCode expectedStatusCode, Func<Task<HttpOperationHeaderResponse<THeader>>> operation)
        {
            var response = operation().GetAwaiter().GetResult();
            Assert.Equal(response.Response.StatusCode, expectedStatusCode);
        }

        private static void EnsureThrowsWithStatusCode(HttpStatusCode expectedStatusCode,
            Action operation, Action<Error> errorValidator = null)
        {
            EnsureThrowsWithErrorModel<Error>(expectedStatusCode, operation, errorValidator);
        }

        private static void EnsureThrowsWithErrorModel<T>(HttpStatusCode expectedStatusCode,
            Action operation, Action<T> errorValidator = null) where T : class
        {
            try
            {
                operation();
                throw new InvalidOperationException("Operation did not throw as expected");
            }
            catch (Fixtures.AcceptanceTestsHttp.Models.ErrorException exception)
            {
                Assert.Equal(expectedStatusCode, exception.Response.StatusCode);
                if (errorValidator != null)
                {
                    errorValidator(exception.Body as T);
                }
            }
            catch (MyException exception1)
            {
                Assert.Equal(expectedStatusCode, exception1.Response.StatusCode);
                if (errorValidator != null)
                {
                    errorValidator(exception1.Body as T);
                }
            }
            catch (HttpOperationException exception2)
            {
                Assert.Equal(expectedStatusCode, exception2.Response.StatusCode);
                if (errorValidator != null)
                {
                    errorValidator(exception2.Body as T);
                }
            }
        }

        private static Action<Error> GetDefaultErrorValidator(int code, string message)
        {
            return (e) =>
            {
                Assert.Equal(code, e.Status);
                Assert.Equal(message, e.Message);
            };
        }

        private static void EnsureThrowsWithStatusCodeAndError(HttpStatusCode expectedStatusCode,
            Action operation, string expectedMessage)
        {
            EnsureThrowsWithStatusCode(expectedStatusCode, operation, GetDefaultErrorValidator((int)expectedStatusCode, expectedMessage));
        }
    }
}
