// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.AzureResourceSchema;
using Newtonsoft.Json;
using System;
using System.IO;
using Xunit;

namespace AutoRest.Generator.AzureResourceSchema.Tests
{
    public class ResourceSchemaWriterTests
    {
        [Fact]
        public void WriteWithNullJsonTextWriter()
        {
            JsonTextWriter writer = null;
            ResourceSchemaModel resourceSchema = new ResourceSchemaModel();
            Assert.Throws<ArgumentNullException>(() => { ResourceSchemaWriter.Write(writer, resourceSchema); });
        }

        [Fact]
        public void WriteWithJsonTextWriterAndNullResourceSchema()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            ResourceSchemaModel resourceSchema = null;
            Assert.Throws<ArgumentNullException>(() => { ResourceSchemaWriter.Write(writer, resourceSchema); });
        }

        [Fact]
        public void WriteWithEmptyResourceSchema()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            ResourceSchemaModel resourceSchema = new ResourceSchemaModel();
            ResourceSchemaWriter.Write(writer, resourceSchema);
            Assert.Equal("{}", stringWriter.ToString());
        }

        [Fact]
        public void WriteWithId()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            ResourceSchemaModel resourceSchema = new ResourceSchemaModel();
            resourceSchema.Id = "MockId";

            ResourceSchemaWriter.Write(writer, resourceSchema);
            Assert.Equal("{'id':'MockId'}", stringWriter.ToString());
        }

        [Fact]
        public void WriteWithSchema()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            ResourceSchemaModel resourceSchema = new ResourceSchemaModel();
            resourceSchema.Id = "MockId";
            resourceSchema.Schema = "MockSchema";

            ResourceSchemaWriter.Write(writer, resourceSchema);
            Assert.Equal("{'id':'MockId','$schema':'MockSchema'}", stringWriter.ToString());
        }

        [Fact]
        public void WriteWithTitle()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            ResourceSchemaModel resourceSchema = new ResourceSchemaModel();
            resourceSchema.Schema = "MockSchema";
            resourceSchema.Title = "MockTitle";

            ResourceSchemaWriter.Write(writer, resourceSchema);
            Assert.Equal("{'$schema':'MockSchema','title':'MockTitle'}", stringWriter.ToString());
        }

        [Fact]
        public void WriteWithDescription()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            ResourceSchemaModel resourceSchema = new ResourceSchemaModel();
            resourceSchema.Title = "MockTitle";
            resourceSchema.Description = "MockDescription";

            ResourceSchemaWriter.Write(writer, resourceSchema);
            Assert.Equal("{'title':'MockTitle','description':'MockDescription'}", stringWriter.ToString());
        }

        [Fact]
        public void WriteWithOneResourceDefinition()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            ResourceSchemaModel resourceSchema = new ResourceSchemaModel();
            resourceSchema.Description = "MockDescription";
            resourceSchema.AddResourceDefinition("mockResource", new JSONSchema());

            ResourceSchemaWriter.Write(writer, resourceSchema);
            Assert.Equal("{'description':'MockDescription','resourceDefinitions':{'mockResource':{}}}", stringWriter.ToString());
        }

        [Fact]
        public void WriteWithOneDefinition()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            ResourceSchemaModel resourceSchema = new ResourceSchemaModel();
            resourceSchema.AddResourceDefinition("mockResource", new JSONSchema());
            resourceSchema.AddDefinition("mockDefinition", new JSONSchema());

            ResourceSchemaWriter.Write(writer, resourceSchema);
            Assert.Equal("{'resourceDefinitions':{'mockResource':{}},'definitions':{'mockDefinition':{}}}", stringWriter.ToString());
        }




        [Fact]
        public void WriteDefinitionWithEmptyDefinition()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string definitionName = "mockDefinition";
            JSONSchema definition = new JSONSchema();

            ResourceSchemaWriter.WriteDefinition(writer, definitionName, definition);
            Assert.Equal("'mockDefinition':{}", stringWriter.ToString());
        }

        [Fact]
        public void WriteDefinitionWithType()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string definitionName = "mockDefinition";
            JSONSchema definition = new JSONSchema();
            definition.JSONType = "MockType";

            ResourceSchemaWriter.WriteDefinition(writer, definitionName, definition);
            Assert.Equal("'mockDefinition':{'type':'MockType'}", stringWriter.ToString());
        }

        [Fact]
        public void WriteDefinitionWithTypeAndEnum()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string definitionName = "mockDefinition";
            JSONSchema definition = new JSONSchema();
            definition.JSONType = "MockType";
            definition.Enum = new string[] { "MockEnum1", "MockEnum2" };

            ResourceSchemaWriter.WriteDefinition(writer, definitionName, definition);
            Assert.Equal("'mockDefinition':{'type':'MockType','enum':['MockEnum1','MockEnum2']}", stringWriter.ToString());
        }

        [Fact]
        public void WriteDefinitionWithEnumAndUnrequiredProperty()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string definitionName = "mockDefinition";
            JSONSchema definition = new JSONSchema();
            definition.Enum = new string[] { "MockEnum1", "MockEnum2" };
            definition.AddProperty("mockPropertyName", new JSONSchema());

            ResourceSchemaWriter.WriteDefinition(writer, definitionName, definition);
            Assert.Equal("'mockDefinition':{'enum':['MockEnum1','MockEnum2'],'properties':{'mockPropertyName':{}}}", stringWriter.ToString());
        }

        [Fact]
        public void WriteDefinitionWithEnumAndRequiredProperty()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string definitionName = "mockDefinition";
            JSONSchema definition = new JSONSchema();
            definition.Enum = new string[] { "MockEnum1", "MockEnum2" };
            definition.AddProperty("mockPropertyName", new JSONSchema(), true);

            ResourceSchemaWriter.WriteDefinition(writer, definitionName, definition);
            Assert.Equal("'mockDefinition':{'enum':['MockEnum1','MockEnum2'],'properties':{'mockPropertyName':{}},'required':['mockPropertyName']}", stringWriter.ToString());
        }

        [Fact]
        public void WriteDefinitionWithRequiredPropertyAndDescription()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string definitionName = "mockDefinition";
            JSONSchema definition = new JSONSchema();
            definition.AddProperty("mockPropertyName", new JSONSchema(), true);
            definition.Description = "MockDescription";

            ResourceSchemaWriter.WriteDefinition(writer, definitionName, definition);
            Assert.Equal("'mockDefinition':{'properties':{'mockPropertyName':{}},'required':['mockPropertyName'],'description':'MockDescription'}", stringWriter.ToString());
        }







        [Fact]
        public void WritePropertyWithNullWriter()
        {
            JsonTextWriter writer = null;
            const string propertyName = "mockPropertyName";
            const string propertyValue = "mockPropertyValue";
            Assert.Throws<ArgumentNullException>(() => { ResourceSchemaWriter.WriteProperty(writer, propertyName, propertyValue); });
        }

        [Fact]
        public void WritePropertyWithNullPropertyName()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string propertyName = null;
            const string propertyValue = "mockPropertyValue";

            Assert.Throws<ArgumentException>(() => { ResourceSchemaWriter.WriteProperty(writer, propertyName, propertyValue); });
        }

        [Fact]
        public void WritePropertyWithNullPropertyValue()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string propertyName = "mockPropertyName";
            const string propertyValue = null;

            ResourceSchemaWriter.WriteProperty(writer, propertyName, propertyValue);

            Assert.Equal("", stringWriter.ToString());
        }

        [Fact]
        public void WritePropertyWithEmptyPropertyValue()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string propertyName = "mockPropertyName";
            const string propertyValue = "";

            ResourceSchemaWriter.WriteProperty(writer, propertyName, propertyValue);

            Assert.Equal("", stringWriter.ToString());
        }

        [Fact]
        public void WritePropertyWithWhitespacePropertyValue()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string propertyName = "mockPropertyName";
            const string propertyValue = "   ";

            ResourceSchemaWriter.WriteProperty(writer, propertyName, propertyValue);

            Assert.Equal("", stringWriter.ToString());
        }

        [Fact]
        public void WritePropertyWithNonWhitespacePropertyValue()
        {
            StringWriter stringWriter = new StringWriter();
            JsonTextWriter writer = new JsonTextWriter(stringWriter);
            writer.QuoteChar = '\'';

            const string propertyName = "mockPropertyName";
            const string propertyValue = "mockPropertyValue";

            ResourceSchemaWriter.WriteProperty(writer, propertyName, propertyValue);

            Assert.Equal("'mockPropertyName':'mockPropertyValue'", stringWriter.ToString());
        }
    }
}
