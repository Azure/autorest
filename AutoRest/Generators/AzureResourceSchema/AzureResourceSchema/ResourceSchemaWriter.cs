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

        internal static void Write(JsonTextWriter writer, ResourceSchema resourceSchema)
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

        private static void WriteDefinitionMap(JsonTextWriter writer, string definitionMapName, IDictionary<string,JsonSchema> definitionMap, bool sortDefinitions = false)
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
                    WriteDefinition(writer, definitionName, definition);
                }
                writer.WriteEndObject();
            }
        }

        internal static void WriteDefinition(JsonTextWriter writer, string resourceName, JsonSchema definition)
        {
            if (definition != null)
            {
                writer.WritePropertyName(resourceName);
                writer.WriteStartObject();

                WriteProperty(writer, "type", definition.JsonType);
                WriteStringArray(writer, "enum", definition.Enum);
                WriteProperty(writer, "$ref", definition.Ref);
                WriteDefinition(writer, "additionalProperties", definition.AdditionalProperties);
                WriteDefinitionMap(writer, "properties", definition.Properties);
                WriteStringArray(writer, "required", definition.Required);
                WriteProperty(writer, "description", definition.Description);

                writer.WriteEndObject();
            }
        }

        private static void WriteStringArray(JsonTextWriter writer, string arrayName, IEnumerable<string> arrayValues)
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

        internal static void WriteProperty(JsonTextWriter writer, string propertyName, string propertyValue)
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
