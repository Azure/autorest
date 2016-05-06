// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.AzureResourceSchema;
using Xunit;

namespace AutoRest.Generator.AzureResourceSchema.Tests
{
    public class JSONSchemaTests
    {
        [Fact]
        public void AddProperty()
        {
            JSONSchema schema = new JSONSchema();
            JSONSchema age = new JSONSchema()
            {
                Type = "number"
            };
            schema.AddProperty("age", age);
            Assert.Same(age, schema.Properties["age"]);
        }
    }
}
