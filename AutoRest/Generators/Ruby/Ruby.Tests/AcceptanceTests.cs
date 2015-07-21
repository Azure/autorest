// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.CSharp.Tests;
using Xunit;
using Xunit.Abstractions;

namespace Microsoft.Rest.Generator.Ruby.Tests
{
    public class AcceptanceTests : AcceptanceTestsBase, IClassFixture<ServiceController>
    {
        public AcceptanceTests(ServiceController data, ITestOutputHelper output) : base(data, output, "Ruby") { }

        [Fact]
        public void BoolTests()
        {
            Test("bool_spec.rb", "body-boolean.json", "Boolean");
        }

        [Fact]
        public void DictionaryTests()
        {
            Test("dictionary_spec.rb", "body-dictionary.json", "Dictionary");
        }

        [Fact(Skip = "Inheritance isn't completely implemented yet")]
        public void ComplexTests()
        {
            Test("complex_spec.rb", "body-complex.json", "Complex");
        }

        [Fact]
        public void IntegerTests()
        {
            Test("integer_spec.rb", "body-integer.json", "Integer");
        }

        [Fact]
        public void NumberTests()
        {
            Test("number_spec.rb", "body-number.json", "Number");
        }

        [Fact]
        public void StringTests()
        {
            Test("string_spec.rb", "body-string.json", "String");
        }

        [Fact]
        public void ByteTests()
        {
            Test("byte_spec.rb", "body-byte.json", "Byte");
        }

        [Fact]
        public void UrlPathTests()
        {
            Test("path_spec.rb", "url.json", "Url");
        }

        [Fact]
        public void UrlQeruiesTests()
        {
            Test("query_spec.rb", "url.json", "UrlQuery");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void UrlItemsTests()
        {
            Test("path_items_spec.rb", "url.json", "UrlItems");
        }

        [Fact]
        public void DateTimeTests()
        {
            Test("datetime_spec.rb", "body-datetime.json", "DateTime");
        }

        [Fact]
        public void DateTests()
        {
            Test("date_spec.rb", "body-date.json", "Date");
        }

        [Fact]
        public void ArrayTests()
        {
            Test("array_spec.rb", "body-array.json", "Array");
        }

        [Fact]
        public void HeaderTests()
        {
            Test("header_spec.rb", "header.json", "Header");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void HttpInfrastructureTests()
        {
            Test("header_spec.rb", "httpInfrastructure.json", "HttpInfrastructure");
        }

        [Fact(Skip = "not completely implemented yet")]
        public void RequiredOptionalTests()
        {
            Test("header_spec.rb", "required-optional.json", "RequiredOptional");
        }

        [Trait("Report", "true")]
        [Fact(Skip = "quality bar isn't high enough")]
        public void EnsureTestCoverage()
        {
            Test("report_spec.rb", "report.json", "Report");
        }
    }
}
