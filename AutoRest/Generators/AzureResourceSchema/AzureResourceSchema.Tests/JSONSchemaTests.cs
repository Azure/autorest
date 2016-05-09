// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.AzureResourceSchema;
using System;
using System.Collections.Generic;
using Xunit;

namespace AutoRest.Generator.AzureResourceSchema.Tests
{
    public class JSONSchemaTests
    {
        [Fact]
        public void AddPropertyWithNullPropertyName()
        {
            JSONSchema jsonSchema = new JSONSchema();
            Assert.Throws<ArgumentException>(() => { jsonSchema.AddProperty(null, null); });
        }

        [Fact]
        public void AddPropertyWithEmptyPropertyName()
        {
            JSONSchema jsonSchema = new JSONSchema();
            Assert.Throws<ArgumentException>(() => { jsonSchema.AddProperty("", null); });
        }

        [Fact]
        public void AddPropertyWithWhitespacePropertyName()
        {
            JSONSchema jsonSchema = new JSONSchema();
            Assert.Throws<ArgumentException>(() => { jsonSchema.AddProperty("     ", null); });
        }

        [Fact]
        public void AddRequiredWithOneValueWhenPropertyDoesntExist()
        {
            JSONSchema jsonSchema = new JSONSchema();
            Assert.Throws<ArgumentException>(() => { jsonSchema.AddRequired("a"); });
            Assert.Null(jsonSchema.Properties);
            Assert.Null(jsonSchema.Required);
        }

        [Fact]
        public void AddRequiredWithTwoValuesWhenSecondPropertyDoesntExist()
        {
            JSONSchema jsonSchema = new JSONSchema();
            jsonSchema.AddProperty("a", new JSONSchema());
            Assert.Throws<ArgumentException>(() => { jsonSchema.AddRequired("a", "b"); });
        }

        [Fact]
        public void AddRequiredWithThreeValuesWhenAllPropertiesExist()
        {
            JSONSchema jsonSchema = new JSONSchema();
            jsonSchema.AddProperty("a", new JSONSchema());
            jsonSchema.AddProperty("b", new JSONSchema());
            jsonSchema.AddProperty("c", new JSONSchema());

            jsonSchema.AddRequired("a", "b", "c");

            Assert.Equal(new List<string>() { "a", "b", "c" }, jsonSchema.Required);
        }
    }
}
