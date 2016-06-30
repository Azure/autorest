// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using AutoRest.Core.Utilities;
using Xunit;

namespace AutoRest.Core.Tests
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
            var expected = string.Format("start{0}    line2{0}        line31{0}        line32{0}", Environment.NewLine);
            var result = sb
                .AppendLine("start").Indent()
                    .AppendLine("line2").Indent()
                    .AppendLine(string.Format("line31{0}line32", Environment.NewLine));
            Assert.Equal(expected, result.ToString());

            sb = new IndentedStringBuilder();
            expected = string.Format("start{0}    line2{0}        line31{0}        line32{0}", Environment.NewLine);
            result = sb
                .AppendLine("start").Indent()
                    .AppendLine("line2").Indent()
                    .AppendLine(string.Format("line31{0}line32", Environment.NewLine));
            Assert.Equal(expected, result.ToString());
        }
    }
}
