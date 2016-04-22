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
            try
            {
                StringWriter stringWriter = new StringWriter();
                using (JsonTextWriter writer = new JsonTextWriter(stringWriter))
                {
                    writer.Formatting = Formatting.Indented;
                    writer.Indentation = 2;
                    writer.IndentChar = ' ';

                    ResourceSchema schema = ResourceSchema.Parse(serviceClient);

                    WriteSchema(writer, schema);
                }

                await Write(stringWriter.ToString(), SchemaPath);
            }
            catch (Exception)
            {
                Debugger.Break();
            }
        }

        private static void WriteSchema(JsonTextWriter writer, ResourceSchema schema)
        {
            WriteObject(writer, () =>
            {
                WriteProperty(writer, "id", schema.Id);
                WriteProperty(writer, "$schema", "http://json-schema.org/draft-04/schema#");
                WriteProperty(writer, "title", schema.Title);
                WriteProperty(writer, "description", schema.Description);
                WriteProperty(writer, "resourceDefinitions", () =>
                {
                    foreach (Resource resource in schema.Resources)
                    {
                        WriteResource(writer, resource);
                    }
                });
            });
        }

        private static void WriteResource(JsonTextWriter writer, Resource resource)
        {
            WriteProperty(writer, resource.Name, () =>
            {
                WriteProperty(writer, "type", "object");
                WriteProperty(writer, "properties", () =>
                {
                    WriteProperty(writer, "type", () =>
                    {
                        WriteProperty(writer, "enum", new string[]
                        {
                            resource.ResourceType
                        });
                    });

                    WriteProperty(writer, "apiVersion", () =>
                    {
                        WriteProperty(writer, "enum", resource.ApiVersions);
                    });

                    WriteProperty(writer, "properties", () =>
                    {
                        WriteObjectOrExpression(writer, () =>
                        {
                            WriteProperty(writer, "type", "object");
                            WriteProperty(writer, "properties", () =>
                            {
                                foreach (ResourceProperty property in resource.Properties)
                                {
                                    WriteResourceProperty(writer, property);
                                }
                            });
                            WriteProperty(writer, "required", resource.RequiredPropertyNames);
                        });
                    });
                });
                WriteProperty(writer, "required", new string[]
                {
                    "type",
                    "apiVersion",
                    "properties",
                    "location"
                });
                WriteProperty(writer, "description", resource.Description);
            });
        }

        private static void WriteResourceProperty(JsonTextWriter writer, ResourceProperty resourceProperty)
        {
            WriteProperty(writer, resourceProperty.Name, () =>
            {
                WriteObjectOrExpression(writer, () =>
                {
                    if (resourceProperty.PropertyType != null)
                    {
                        WriteProperty(writer, "type", resourceProperty.PropertyType);
                    }

                    if (resourceProperty.AllowedValues != null)
                    {
                        WriteProperty(writer, "allowedValues", resourceProperty.AllowedValues);
                    }
                });
                WriteProperty(writer, "description", resourceProperty.Description);
            });
        }

        private static void WriteObject(JsonTextWriter writer, Action writeObjectContents)
        {
            writer.WriteStartObject();

            writeObjectContents.Invoke();

            writer.WriteEndObject();
        }

        private static void WriteExpressionReference(JsonTextWriter writer)
        {
            WriteObject(writer, () =>
            {
                WriteProperty(writer, "$ref", "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#/definitions/expression");
            });
        }

        private static void WriteObjectOrExpression(JsonTextWriter writer, Action writeObjectContents)
        {
            writer.WritePropertyName("oneOf");
            writer.WriteStartArray();

            WriteObject(writer, writeObjectContents);

            WriteExpressionReference(writer);

            writer.WriteEndArray();
        }

        private static void WriteProperty(JsonTextWriter writer, string propertyName, string propertyValue)
        {
            writer.WritePropertyName(propertyName);
            writer.WriteValue(propertyValue);
        }

        private static void WriteProperty(JsonTextWriter writer, string propertyName, Action writeObjectContents)
        {
            writer.WritePropertyName(propertyName);
            WriteObject(writer, writeObjectContents);
        }

        private static void WriteProperty(JsonTextWriter writer, string propertyName, IEnumerable<string> writeArrayContents)
        {
            writer.WritePropertyName(propertyName);
            writer.WriteStartArray();

            foreach (string value in writeArrayContents)
            {
                writer.WriteValue(value);
            }

            writer.WriteEndArray();
        }
    }
}
