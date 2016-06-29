// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using Xunit;

namespace AutoRest.AzureResourceSchema.Tests
{
    public class JSONSchemaTests
    {
        [Fact]
        public void AddPropertyWithNullPropertyName()
        {
            JsonSchema jsonSchema = new JsonSchema();
            Assert.Throws<ArgumentException>(() => { jsonSchema.AddProperty(null, null); });
        }

        [Fact]
        public void AddPropertyWithEmptyPropertyName()
        {
            JsonSchema jsonSchema = new JsonSchema();
            Assert.Throws<ArgumentException>(() => { jsonSchema.AddProperty("", null); });
        }

        [Fact]
        public void AddPropertyWithWhitespacePropertyName()
        {
            JsonSchema jsonSchema = new JsonSchema();
            Assert.Throws<ArgumentException>(() => { jsonSchema.AddProperty("     ", null); });
        }

        [Fact]
        public void AddRequiredWithOneValueWhenPropertyDoesntExist()
        {
            JsonSchema jsonSchema = new JsonSchema();
            Assert.Throws<ArgumentException>(() => { jsonSchema.AddRequired("a"); });
            Assert.Null(jsonSchema.Properties);
            Assert.Null(jsonSchema.Required);
        }

        [Fact]
        public void AddRequiredWithTwoValuesWhenSecondPropertyDoesntExist()
        {
            JsonSchema jsonSchema = new JsonSchema();
            jsonSchema.AddProperty("a", new JsonSchema());
            Assert.Throws<ArgumentException>(() => { jsonSchema.AddRequired("a", "b"); });
        }

        [Fact]
        public void AddRequiredWithThreeValuesWhenAllPropertiesExist()
        {
            JsonSchema jsonSchema = new JsonSchema();
            jsonSchema.AddProperty("a", new JsonSchema());
            jsonSchema.AddProperty("b", new JsonSchema());
            jsonSchema.AddProperty("c", new JsonSchema());

            jsonSchema.AddRequired("a", "b", "c");

            Assert.Equal(new List<string>() { "a", "b", "c" }, jsonSchema.Required);
        }

        [Fact]
        public void EqualsWithNull()
        {
            JsonSchema lhs = new JsonSchema();
            Assert.False(lhs.Equals(null));
        }

        [Fact]
        public void EqualsWithString()
        {
            JsonSchema lhs = new JsonSchema();
            Assert.False(lhs.Equals("Not Equal"));
        }
    }
}
