// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public class AzureResourceSchemaCodeGenerator : CodeGenerator
    {
        public AzureResourceSchemaCodeGenerator(Settings settings)
            : base(settings)
        {
        }

        public string SchemaPath
        {
            get
            {
                string defaultSchemaFileName = Path.GetFileNameWithoutExtension(Settings.Input) + ".schema.json";
                return Path.Combine(Settings.OutputDirectory, Settings.OutputFileName ?? defaultSchemaFileName);
            }
        }

        public override string Description
        {
            get { return "Azure Resource Schema generator"; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".json"; }
        }

        public override string Name
        {
            get { return "AzureResourceSchema"; }
        }

        public override string UsageInstructions
        {
            get { return "Your Azure Resource Schema can be found at " + SchemaPath; }
        }

        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
        }

        public override async Task Generate(ServiceClient serviceClient)
        {
            ResourceSchema schema = ResourceSchema.Parse(serviceClient);

            StringWriter stringWriter = new StringWriter();
            using (JsonTextWriter writer = new JsonTextWriter(stringWriter))
            {
                writer.Formatting = Formatting.Indented;
                writer.Indentation = 2;
                writer.IndentChar = ' ';
                writer.QuoteChar = '\"';

                WriteResourceSchema(writer, schema);
            }

            await Write(stringWriter.ToString(), SchemaPath);
        }

        private static void WriteResourceSchema(JsonTextWriter writer, ResourceSchema schema)
        {
            WriteObject(writer, () =>
            {
                WriteJsonStringProperty(writer, "id", schema.Id);
                WriteJsonStringProperty(writer, "$schema", schema.Schema);
                WriteJsonStringProperty(writer, "title", schema.Title);
                WriteJsonStringProperty(writer, "description", schema.Description);
                WriteJsonObjectProperty(writer, "resourceDefinitions", () =>
                {
                    foreach (Resource resource in schema.Resources)
                    {
                        WriteResource(writer, resource, schema.Definitions.Keys);
                    }
                });

                if (schema.Definitions.Count() > 0)
                {
                    WriteJsonObjectProperty(writer, "definitions", () =>
                    {
                        foreach (Definition definition in schema.Definitions.Values.OrderBy(definition => definition.Name))
                        {
                            WriteJsonObjectProperty(writer, definition.Name, null, definition, schema.Definitions.Keys);
                        }
                    });
                }
            });
        }

        private static void WriteJsonStringProperty(JsonTextWriter writer, string propertyName, string propertyValue)
        {
            writer.WritePropertyName(propertyName);
            writer.WriteValue(propertyValue);
        }

        private static void WriteJsonObjectProperty(JsonTextWriter writer, string propertyName, string propertyDescription, Definition propertyDefinition, IEnumerable<string> schemaDefinitionNames)
        {
            WriteJsonObjectProperty(writer, propertyName, () =>
            {
                Debug.Assert(!String.IsNullOrWhiteSpace(propertyDefinition.DefinitionType));
                WriteJsonStringProperty(writer, "type", propertyDefinition.DefinitionType);

                if (propertyDefinition.ArrayElement != null)
                {
                    WriteJsonObjectProperty(writer, "items", null, propertyDefinition.ArrayElement, schemaDefinitionNames);
                }

                if (propertyDefinition.AllowedValues != null)
                {
                    WriteArrayProperty(writer, "enum", propertyDefinition.AllowedValues);
                }

                if (propertyDefinition.AdditionalProperties != null)
                {
                    WriteJsonObjectProperty(writer, "additionalProperties", null, propertyDefinition.AdditionalProperties, schemaDefinitionNames);
                }

                if (propertyDefinition.Properties != null)
                {
                    WriteJsonObjectProperty(writer, "properties", () =>
                    {
                        foreach (SchemaProperty definitionProperty in propertyDefinition.Properties)
                        {
                            WriteResourceProperty(writer, definitionProperty, schemaDefinitionNames);
                        }
                    });

                    if (propertyDefinition.RequiredPropertyNames != null)
                    {
                        WriteArrayProperty(writer, "required", propertyDefinition.RequiredPropertyNames);
                    }
                }

                if (propertyDescription != null)
                {
                    WriteJsonStringProperty(writer, "description", propertyDescription);
                }
                else if (propertyDefinition.Description != null)
                {
                    WriteJsonStringProperty(writer, "description", propertyDefinition.Description);
                }
            });
        }

        private static void WriteResource(JsonTextWriter writer, Resource resource, IEnumerable<string> schemaDefinitionNames)
        {
            WriteJsonObjectProperty(writer, resource.Name, () =>
            {
                WriteJsonStringProperty(writer, "type", "object");

                // Root level properties of the resource
                WriteJsonObjectProperty(writer, "properties", () =>
                {
                    WriteJsonObjectProperty(writer, "type", () =>
                    {
                        WriteJsonStringProperty(writer, "type", "string");
                        WriteArrayProperty(writer, "enum", new string[] { resource.ResourceType });
                    });

                    WriteJsonObjectProperty(writer, "apiVersion", () =>
                    {
                        WriteJsonStringProperty(writer, "type", "string");
                        WriteArrayProperty(writer, "enum", resource.ApiVersions);
                    });

                    if (resource.Properties != null)
                    {
                        foreach (SchemaProperty property in resource.Properties)
                        {
                            WriteResourceProperty(writer, property, schemaDefinitionNames);
                        }
                    }
                });
                WriteArrayProperty(writer, "required", resource.RequiredPropertyNames);
                WriteJsonStringProperty(writer, "description", resource.Description);
            });
        }

        private static void WriteResourceProperty(JsonTextWriter writer, SchemaProperty property, IEnumerable<string> schemaDefinitionNames)
        {
            Definition definition = property.Definition;
            //if (!property.ShouldFlatten)
            {
                if (schemaDefinitionNames.Contains(definition.Name))
                {
                    WriteJsonObjectProperty(writer, property.Name, () =>
                    {
                        WriteJsonStringProperty(writer, "$ref", "#/definitions/" + definition.Name);
                        if (property.Description != null)
                        {
                            WriteJsonStringProperty(writer, "description", property.Description);
                        }
                    });
                }
                else
                {
                    WriteJsonObjectProperty(writer, property.Name, property.Description, definition, schemaDefinitionNames);
                }
            }
            //else
            //{
            //    Debug.Assert(property.Name == "properties");
            //    WriteObjectProperty(writer, "properties", () =>
            //    {
            //        foreach (SchemaProperty definitionProperty in definition.Properties)
            //        {
            //            WriteResourceProperty(writer, definitionProperty, schemaDefinitionNames);
            //        }
            //    });
            //}
        }

        //private static void WriteObjectOrExpression(JsonTextWriter writer, Action writeObjectContents)
        //{
        //    writer.WritePropertyName("oneOf");
        //    writer.WriteStartArray();

        //    WriteObject(writer, writeObjectContents);

        //    WriteObject(writer, () =>
        //    {
        //        WriteStringProperty(writer, "$ref", "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#/definitions/expression");
        //    });

        //    writer.WriteEndArray();
        //}

        private static void WriteArrayProperty(JsonTextWriter writer, string propertyName, IEnumerable<string> writeArrayContents)
        {
            writer.WritePropertyName(propertyName);
            writer.WriteStartArray();

            if (writeArrayContents != null)
            {
                foreach (string value in writeArrayContents)
                {
                    writer.WriteValue(value);
                }
            }

            writer.WriteEndArray();
        }

        private static void WriteJsonObjectProperty(JsonTextWriter writer, string propertyName, Action writeObjectContents)
        {
            writer.WritePropertyName(propertyName);
            WriteObject(writer, writeObjectContents);
        }

        private static void WriteObject(JsonTextWriter writer, Action writeObjectContents)
        {
            writer.WriteStartObject();

            writeObjectContents.Invoke();

            writer.WriteEndObject();
        }
    }
}
