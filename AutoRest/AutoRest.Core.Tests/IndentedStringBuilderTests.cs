// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.Utilities;
using Xunit;

namespace Microsoft.Rest.Generator.Test
{
    [Collection("AutoRest Tests")]
    public class IndentedStringBuilderTests
    {
        [Theory]
        [InlineData("test")]
        [InlineData("  test  ")]
        [InlineData("")]
        public void AppendDoesNotAddIndentation(string input)
        {
            IndentedStringBuilder sb = new IndentedStringBuilder();
            var expected = input;
            var result = sb.Indent().Append(input);
            Assert.Equal(expected, result.ToString());
        }

        [Theory]
        [InlineData("test", "{0}", new[] { "test" })]
        public void AppendFormatSupportsDifferentDataTypes(string expected, string format, object[] parameters)
        {
            IndentedStringBuilder sb = new IndentedStringBuilder();
            var result = sb.AppendFormat(format, parameters);
            Assert.Equal(expected, result.ToString());
        }

        [Fact]
        public void AppendWorksWithNull()
        {
            IndentedStringBuilder sb = new IndentedStringBuilder();
            var expected = "";
            var result = sb.Indent().Append(null);
            Assert.Equal(expected, result.ToString());
        }

        [Fact]
        public void AppendMultilinePreservesIndentation()
        {
            IndentedStringBuilder sb = new IndentedStringBuilder();
            var expected = "start\r\n    line2\r\n        line31\n        line32\r\n";
            var result = sb
                .AppendLine("start").Indent()
                    .AppendLine("line2").Indent()
                    .AppendLine("line31\nline32");
            Assert.Equal(expected, result.ToString());

            sb = new IndentedStringBuilder();
            expected = "start\r\n    line2\r\n        line31\r\n        line32\r\n";
            result = sb
                .AppendLine("start").Indent()
                    .AppendLine("line2").Indent()
                    .AppendLine("line31\r\nline32");
            Assert.Equal(expected, result.ToString());
        }
    }
}