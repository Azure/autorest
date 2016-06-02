// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public static class ResourceSchemaWriter
    {
        public static void Write(TextWriter writer, ResourceSchema resourceSchema)
        {
            if (writer == null)
            {
                throw new ArgumentNullException("writer");
            }
            if (resourceSchema == null)
            {
                throw new ArgumentNullException("resourceSchema");
            }

            using (JsonTextWriter jsonWriter = new JsonTextWriter(writer))
            {
                jsonWriter.Formatting = Formatting.Indented;
                jsonWriter.Indentation = 2;
                jsonWriter.IndentChar = ' ';
                jsonWriter.QuoteChar = '\"';

                Write(jsonWriter, resourceSchema);
            }
        }

        public static void Write(JsonWriter writer, ResourceSchema resourceSchema)
        {
            if (writer == null)
            {
                throw new ArgumentNullException("writer");
            }
            if (resourceSchema == null)
            {
                throw new ArgumentNullException("resourceSchema");
            }

            writer.WriteStartObject();

            WriteProperty(writer, "id", resourceSchema.Id);
            WriteProperty(writer, "$schema", resourceSchema.Schema);
            WriteProperty(writer, "title", resourceSchema.Title);
            WriteProperty(writer, "description", resourceSchema.Description);

            WriteDefinitionMap(writer, "resourceDefinitions", resourceSchema.ResourceDefinitions, sortDefinitions: true);

            WriteDefinitionMap(writer, "definitions", resourceSchema.Definitions, sortDefinitions: true);

            writer.WriteEndObject();
        }

        private static void WriteDefinitionMap(JsonWriter writer, string definitionMapName, IDictionary<string,JsonSchema> definitionMap, bool sortDefinitions = false, bool addExpressionReferences = false)
        {
            if (definitionMap != null && definitionMap.Count > 0)
            {
                writer.WritePropertyName(definitionMapName);
                writer.WriteStartObject();

                IEnumerable<string> definitionNames = definitionMap.Keys;
                if (sortDefinitions)
                {
                    definitionNames = definitionNames.OrderBy(key => key);
                }

                foreach (string definitionName in definitionNames)
                {
                    JsonSchema definition = definitionMap[definitionName];

                    bool shouldAddExpressionReference = addExpressionReferences &&
                                                        (definition.JsonType != "string" ||
                                                            (definition.Enum != null &&
                                                             definition.Enum.Count() > 0 &&
                                                             definitionName != "type" &&
                                                             definitionName != "apiVersion"));

                    if (!shouldAddExpressionReference)
                    {
                        WriteDefinition(writer, definitionName, definition);
                    }
                    else
                    {
                        string definitionDescription = null;

                        writer.WritePropertyName(definitionName);
                        writer.WriteStartObject();

                        writer.WritePropertyName("oneOf");
                        writer.WriteStartArray();

                        if (definition.Description != null)
                        {
                            definitionDescription = definition.Description;

                            definition = definition.Clone();
                            definition.Description = null;
                        }
                        WriteDefinition(writer, definition);

                        WriteDefinition(writer, new JsonSchema()
                        {
                            Ref = "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#/definitions/expression"
                        });

                        writer.WriteEndArray();

                        WriteProperty(writer, "description", definitionDescription);
                        writer.WriteEndObject();
                    }
                }
                writer.WriteEndObject();
            }
        }

        public static void WriteDefinition(JsonWriter writer, string resourceName, JsonSchema definition)
        {
            if (writer == null)
            {
                throw new ArgumentNullException("writer");
            }

            if (definition != null)
            {
                writer.WritePropertyName(resourceName);
                WriteDefinition(writer, definition);
            }
        }

        private static void WriteDefinition(JsonWriter writer, JsonSchema definition)
        {
            if (definition == null)
            {
                throw new ArgumentNullException("definition");
            }

            writer.WriteStartObject();

            WriteProperty(writer, "type", definition.JsonType);
            WriteStringArray(writer, "enum", definition.Enum);
            WriteProperty(writer, "format", definition.Format);
            WriteProperty(writer, "$ref", definition.Ref);
            WriteDefinition(writer, "items", definition.Items);
            WriteDefinition(writer, "additionalProperties", definition.AdditionalProperties);
            WriteDefinitionMap(writer, "properties", definition.Properties, addExpressionReferences: true);
            WriteDefinitionArray(writer, "resources", definition.Resources);
            WriteStringArray(writer, "required", definition.Required);
            WriteProperty(writer, "description", definition.Description);

            writer.WriteEndObject();
        }

        private static void WriteStringArray(JsonWriter writer, string arrayName, IEnumerable<string> arrayValues)
        {
            if (arrayValues != null && arrayValues.Count() > 0)
            {
                writer.WritePropertyName(arrayName);
                writer.WriteStartArray();
                foreach (string arrayValue in arrayValues)
                {
                    writer.WriteValue(arrayValue);
                }
                writer.WriteEndArray();
            }
        }

        private static void WriteDefinitionArray(JsonWriter writer, string arrayName, IEnumerable<JsonSchema> arrayDefinitions)
        {
            if (arrayDefinitions != null && arrayDefinitions.Count() > 0)
            {
                writer.WritePropertyName(arrayName);
                writer.WriteStartObject();

                WriteProperty(writer, "type", "array");

                writer.WritePropertyName("items");
                writer.WriteStartObject();

                writer.WritePropertyName("oneOf");
                writer.WriteStartArray();
                foreach (JsonSchema definition in arrayDefinitions)
                {
                    WriteDefinition(writer, definition);
                }
                writer.WriteEndArray();

                writer.WriteEndObject();

                writer.WriteEndObject();
            }
        }

        public static void WriteProperty(JsonWriter writer, string propertyName, string propertyValue)
        {
            if (writer == null)
            {
                throw new ArgumentNullException("writer");
            }
            if (string.IsNullOrWhiteSpace(propertyName))
            {
                throw new ArgumentException("propertyName cannot be null or whitespace", "propertyName");
            }

            if (!string.IsNullOrWhiteSpace(propertyValue))
            {
                writer.WritePropertyName(propertyName);
                writer.WriteValue(propertyValue);
            }
        }
    }
}
