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
            StringWriter stringWriter = new StringWriter();
            using (JsonTextWriter writer = new JsonTextWriter(stringWriter))
            {
                writer.Formatting = Formatting.Indented;
                writer.Indentation = 2;
                writer.IndentChar = ' ';
                writer.QuoteChar = '\"';

                ResourceSchema schema = ResourceSchema.Parse(serviceClient);

                WriteSchema(writer, schema);
            }

            await Write(stringWriter.ToString(), SchemaPath);
        }

        private static void WriteSchema(JsonTextWriter writer, ResourceSchema schema)
        {
            WriteObject(writer, () =>
            {
                WriteStringProperty(writer, "id", schema.Id);
                WriteStringProperty(writer, "$schema", "http://json-schema.org/draft-04/schema#");
                WriteStringProperty(writer, "title", schema.Title);
                WriteStringProperty(writer, "description", schema.Description);
                WriteObjectProperty(writer, "resourceDefinitions", () =>
                {
                    foreach (Resource resource in schema.Resources)
                    {
                        WriteResource(writer, resource, schema.Definitions.Keys);
                    }
                });

                if (schema.Definitions.Count() > 0)
                {
                    WriteObjectProperty(writer, "definitions", () =>
                    {
                        foreach (Definition definition in schema.Definitions.Values.OrderBy(definition => definition.Name))
                        {
                            WriteObjectProperty(writer, definition.Name, null, definition, schema.Definitions.Keys);
                        }
                    });
                }
            });
        }

        private static void WriteResource(JsonTextWriter writer, Resource resource, IEnumerable<string> schemaDefinitionNames)
        {
            WriteObjectProperty(writer, resource.Name, () =>
            {
                WriteStringProperty(writer, "type", "object");

                // Root level properties of the resource
                WriteObjectProperty(writer, "properties", () =>
                {
                    WriteObjectProperty(writer, "type", () =>
                    {
                        WriteArrayProperty(writer, "enum", new string[] { resource.ResourceType });
                    });

                    WriteObjectProperty(writer, "apiVersion", () =>
                    {
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
                WriteStringProperty(writer, "description", resource.Description);
            });
        }

        private static void WriteResourceProperty(JsonTextWriter writer, SchemaProperty property, IEnumerable<string> schemaDefinitionNames)
        {
            Definition definition = property.Definition;
            if (schemaDefinitionNames.Contains(definition.Name))
            {
                WriteObjectProperty(writer, property.Name, () =>
                {
                    WriteStringProperty(writer, "$ref", "#/definitions/" + definition.Name);
                    if (property.Description != null)
                    {
                        WriteStringProperty(writer, "description", property.Description);
                    }
                });
            }
            else
            {
                WriteObjectProperty(writer, property.Name, property.Description, definition, schemaDefinitionNames);
            }
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

        private static void WriteStringProperty(JsonTextWriter writer, string propertyName, string propertyValue)
        {
            writer.WritePropertyName(propertyName);
            writer.WriteValue(propertyValue);
        }

        private static void WriteObjectProperty(JsonTextWriter writer, string propertyName, string propertyDescription, Definition propertyDefinition, IEnumerable<string> schemaDefinitionNames)
        {
            WriteObjectProperty(writer, propertyName, () =>
            {
                Debug.Assert(!String.IsNullOrWhiteSpace(propertyDefinition.DefinitionType));
                WriteStringProperty(writer, "type", propertyDefinition.DefinitionType);

                if (propertyDefinition.ArrayElement != null)
                {
                    WriteObjectProperty(writer, "items", null, propertyDefinition.ArrayElement, schemaDefinitionNames);
                }

                if (propertyDefinition.AllowedValues != null)
                {
                    WriteArrayProperty(writer, "enum", propertyDefinition.AllowedValues);
                }

                if (propertyDefinition.AdditionalProperties != null)
                {
                    WriteObjectProperty(writer, "additionalProperties", null, propertyDefinition.AdditionalProperties, schemaDefinitionNames);
                }

                if (propertyDefinition.Properties != null)
                {
                    WriteObjectProperty(writer, "properties", () =>
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
                    WriteStringProperty(writer, "description", propertyDescription);
                }
                else if (propertyDefinition.Description != null)
                {
                    WriteStringProperty(writer, "description", propertyDefinition.Description);
                }
            });
        }

        private static void WriteObjectProperty(JsonTextWriter writer, string propertyName, Action writeObjectContents)
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
