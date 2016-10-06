// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using AutoRest.Core.Model;
using Xunit;

namespace AutoRest.Core.Tests
{
    public class FakeCodeNamer : CodeNamer
    {
        public override IModelType NormalizeTypeReference(IModelType type)
        {
            throw new System.NotImplementedException();
        }

        public override IModelType NormalizeTypeDeclaration(IModelType type)
        {
            throw new System.NotImplementedException();
        }

        public override string EscapeDefaultValue(string value, IModelType type)
        {
            throw new NotImplementedException();
        }
    }

    public class CodeNamingFrameworkTests
    {
        [Theory]
        [InlineData("Id", "id")]
        [InlineData("EX", "EX")]
        [InlineData("CatDog", "catDog")]
        [InlineData("", "")]
        [InlineData(null, null)]
        public void PascalCase(string expected, string value)
        {
            var result = CodeNamer.Instance.PascalCase(value);
            Assert.Equal(expected, result);
        }

        [Theory]
        [InlineData("id", "id")]
        [InlineData("ex", "EX")]
        [InlineData("catDog", "catDog")]
        [InlineData("", "")]
        [InlineData(null, null)]
        public void CamelCase(string expected, string value)
        {
            var result = CodeNamer.Instance.CamelCase(value);
            Assert.Equal(expected, result);
        }

        [Fact]
        public void SpecialCharacterGetReplacedWithTheirNames()
        {
            var codeNameing= new FakeCodeNamer();

            Assert.Equal(
                "AsteriskAsteriskSpaceAsteriskAsteriskPercentSignCircumflexAccentSpaceCircumflexAccentCircumflexAccentDollarSignSpaceNumberSignNumberSignDollarSign",
                codeNameing.GetEnumMemberName("** **%^ ^^$ ##$"));

            Assert.Equal("_asterisk", codeNameing.GetFieldName("*"));

            Assert.Equal(
                "OneTwoThreeProperty",
                codeNameing.GetPropertyName("123Property"));
        }
    }
}
