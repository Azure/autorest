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
            Test("bool_spec.rb", "body-boolean.json", "boolean");
        }

        [Fact]
        public void DictionaryTests()
        {
            Test("dictionary_spec.rb", "body-dictionary.json", "dictionary");
        }

        [Fact]
        public void ComplexTests()
        {
            Test("complex_spec.rb", "body-complex.json", "complex");
        }

        [Fact]
        public void IntegerTests()
        {
            Test("integer_spec.rb", "body-integer.json", "integer");
        }

        [Fact]
        public void NumberTests()
        {
            Test("number_spec.rb", "body-number.json", "number");
        }

        [Fact]
        public void StringTests()
        {
            Test("string_spec.rb", "body-string.json", "string");
        }

        [Fact]
        public void ByteTests()
        {
            Test("byte_spec.rb", "body-byte.json", "byte");
        }

        [Fact]
        public void UrlPathTests()
        {
            Test("path_spec.rb", "url.json", "url");
        }

        [Fact]
        public void UrlQeruiesTests()
        {
            Test("query_spec.rb", "url.json", "url_query");
        }

        [Fact]
        public void UrlItemsTests()
        {
            Test("path_items_spec.rb", "url.json", "url_items");
        }

        [Fact]
        public void DateTimeTests()
        {
            Test("datetime_spec.rb", "body-datetime.json", "datetime");
        }

        [Fact]
        public void DateTests()
        {
            Test("date_spec.rb", "body-date.json", "date");
        }

        [Fact]
        public void ArrayTests()
        {
            Test("array_spec.rb", "body-array.json", "array");
        }

        [Fact]
        public void HeaderTests()
        {
            Test("header_spec.rb", "header.json", "header");
        }

        [Fact]
        public void HttpInfrastructureTests()
        {
            Test("http_infrastructure_spec.rb", "httpInfrastructure.json", "http_infrastructure");
        }

        [Fact]
        public void RequiredOptionalTests()
        {
            Test("required_optional_spec.rb", "required-optional.json", "required_optional");
        }

        [Trait("Report", "true")]
        [Fact]
        public void EnsureTestCoverage()
        {
            Test("report_spec.rb", "report.json", "report");
        }
    }
}
