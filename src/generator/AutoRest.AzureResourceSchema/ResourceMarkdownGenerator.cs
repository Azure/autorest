// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.AzureResourceSchema.Markdown;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;

using TableQueueEntry = System.Tuple<string, AutoRest.AzureResourceSchema.JsonSchema>;

namespace AutoRest.AzureResourceSchema
{
    using TableQueue = Queue<TableQueueEntry>;

    public class ResourceMarkdownGenerator
    {
        public class Markdown
        {
            public Markdown(string type, string md)
            {
                Type = type;
                Content = md;
            }

            /// <summary>
            /// Gets the name of the type described in the markdown.
            /// </summary>
            public string Type { get; }

            /// <summary>
            /// Gets the markdown text.
            /// </summary>
            public string Content { get; }
        }

        private const string RequiredFalse = "No";
        private const string RequiredTrue = "Yes";

        private MarkdownWriter _writer;
        private ResourceSchema _schema;

        private ResourceMarkdownGenerator(TextWriter writer, ResourceSchema resourceSchema)
        {
            _writer = new MarkdownWriter(writer);
            _schema = resourceSchema;
        }

        public static Markdown[] Generate(ResourceSchema resourceSchema)
        {
            if (resourceSchema == null)
            {
                throw new ArgumentNullException("resourceSchema");
            }

            var mds = new Markdown[resourceSchema.ResourceDefinitions.Keys.Count];
            int index = 0;

            foreach (var resDefName in resourceSchema.ResourceDefinitions.Keys)
            {
                var resDef = resourceSchema.ResourceDefinitions[resDefName];

                var writer = new StringWriter();
                var mdWriter = new ResourceMarkdownGenerator(writer, resourceSchema);
                mdWriter.Generate(resDef);

                mds[index] = new Markdown(resDefName, writer.ToString());
                ++index;
            }

            return mds;
        }

        private void Generate(JsonSchema schema)
        {
            _writer.WriteLine(new Header("{0} template reference", schema.Description));

            if (schema.Properties.Keys.Contains("apiVersion"))
            {
                _writer.WriteLine("API Version: {0}", schema.Properties["apiVersion"].Enum[0]);
            }

            WriteSchemaFormatSection(schema);
            WriteValuesSection(schema);
        }

        /// <summary>
        /// Generates the "schema format" section.
        /// </summary>
        private void WriteSchemaFormatSection(JsonSchema schema)
        {
            _writer.WriteLine(new Header(2, "Template format"));
            _writer.WriteLine(new Paragraph("To create a {0} resource, add the following JSON to the resources section of your template.", schema.Description));

            using (var stringWriter = new StringWriter())
            {
                using (var json = new JsonTextWriter(stringWriter))
                {
                    json.Formatting = Formatting.Indented;
                    var root = new JObject();

                    foreach (var prop in schema.Properties)
                    {
                        root.Add(JsonSchemaToJToken(prop.Key, prop.Value));
                    }

                    root.WriteTo(json);
                }

                // put each resource definition into its own code block
                _writer.WriteLine(new Codeblock("json", stringWriter.ToString()));
            }
        }

        /// <summary>
        /// Generates the "values" section; this contains tables describing all of the JSON types.
        /// </summary>
        private void WriteValuesSection(JsonSchema schema)
        {
            _writer.WriteLine(new Header(2, "Property values"));
            _writer.Write(new Paragraph("The following tables describe the values you need to set in the schema."));

            var table = CreateTables(schema.Description, schema);
            _writer.Write(table);
        }

        /// <summary>
        /// Creates one or more markdown tables that describes the specified JSON schema.
        /// </summary>
        /// <param name="header">The markdown header to place before the table.</param>
        /// <param name="jsonSchema">The JSON schema that is to be described by the table.</param>
        /// <param name="tableQueue">A queue containing the JSON schemas to be converted to table format.</param>
        /// <returns>A formatted table with sub-header.</returns>
        private IReadOnlyList<MarkdownElement> CreateTables(string header, JsonSchema jsonSchema)
        {
            if (jsonSchema == null)
                throw new ArgumentNullException(nameof(jsonSchema));

            Debug.Assert(jsonSchema.Properties != null);

            var tables = new List<MarkdownElement>();
            var schemas = new TableQueue();
            schemas.Enqueue(new Tuple<string, JsonSchema>(header, jsonSchema));

            var visited = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            while (schemas.Count > 0)
            {
                var schema = schemas.Dequeue();

                // write the table header
                var paragraph = new Paragraph();
                paragraph.Append(new Anchor(schema.Item1));
                paragraph.Append(Environment.NewLine);
                paragraph.Append(new Header(3, "{0} object", schema.Item1));
                paragraph.Append(Environment.NewLine);

                var table = new Table(new[] { "Name", "Type", "Required", "Value" });

                // add a table row for each property in the schema
                var props = FlattenProperties(schema.Item2);
                foreach (var prop in props)
                {
                    // type name
                    var typeName = GetValueTypeName(prop.Value);

                    // required/optional
                    var required = RequiredFalse;
                    if (schema.Item2.Required != null && schema.Item2.Required.Contains(prop.Key))
                        required = RequiredTrue;

                    var sb = new StringBuilder();

                    // description
                    bool hasDescr = false;
                    if (!string.IsNullOrWhiteSpace(prop.Value.Description))
                    {
                        sb.Append(prop.Value.Description.Replace("\n", ""));
                        hasDescr = true;
                    }

                    // values
                    var values = GetPossibleValues(prop.Value);
                    if (values.Count > 0)
                    {
                        if (hasDescr)
                            sb.Append(" - ");

                        if (values.Count == 1)
                            sb.Append(values[0]);
                        else if (values.Count == 2)
                            sb.Append(string.Join(" or ", values));
                        else
                            sb.Append(string.Join(", ", values));
                    }
                    else if ((values = GetPossibleValueRefs(prop.Value)).Count > 0)
                    {
                        if (hasDescr)
                            sb.Append(" - ");

                        for (int i = 0; i < values.Count; ++i)
                        {
                            sb.AppendFormat(CreateInlineLink(values[i]).ToString());
                            if (i + 1 < values.Count)
                            {
                                sb.Append(" ");
                            }

                            var refSchema = _schema.Definitions[values[i]];

                            // there are a handful of objects with null properties because the properties
                            // are all read-only.  for now just skip them to avoid a crash during table creation.
                            // omit tables for child resources as they will be created in their own md file.
                            if (HasAdditionalProps(refSchema) && !visited.Contains(values[i]) && !values[i].EndsWith("_childResource"))
                            {
                                // add type to the queue so a table for the type is generated
                                schemas.Enqueue(new TableQueueEntry(values[i], refSchema));

                                // track the types that have already been queued for generation
                                visited.Add(values[i]);
                            }
                        }
                    }

                    table.AddRow(new[] { prop.Key, typeName, required, sb.ToString() });
                }

                paragraph.Append(table);
                tables.Add(paragraph);
            }

            return tables;
        }

        private InlineLink CreateInlineLink(string destination)
        {
            if (!destination.EndsWith("_childResource"))
            {
                return new InlineLink($"#{destination}", "{0} object", destination);
            }
            // construct the child directory
            destination = destination.Replace("_childResource", "");
            var parts = destination.Split(new char[] { '_' });
            if (parts.Length > 2)
            {
                // take the last two elements (the subdir and the file name)
                parts = parts.Skip(parts.Length - 2).Take(2).ToArray();
            }
            return new InlineLink($"./{string.Join("/", parts)}.md", $"{parts[parts.Length - 1]}");
        }

        /// <summary>
        /// Returns true if a schema contains properties.
        /// </summary>
        /// <param name="jsonSchema">The JSON schema.</param>
        /// <returns>True if the schema contains properties.</returns>
        private bool HasAdditionalProps(JsonSchema jsonSchema)
        {
            return
                jsonSchema.AllOf != null ||
                jsonSchema.AnyOf != null ||
                jsonSchema.Properties != null;
        }

        /// <summary>
        /// Returns the name of the specified JSON type.
        /// </summary>
        /// <param name="jsonSchema">The schema object for which to return the type name.</param>
        /// <returns>The name of the type contained in the specified schema.</returns>
        private string GetValueTypeName(JsonSchema jsonSchema)
        {
            if (jsonSchema == null)
                throw new ArgumentNullException(nameof(jsonSchema));

            if (jsonSchema.Enum != null)
                return "enum";
            else if (jsonSchema.Ref != null)
                return "object";
            else
                return jsonSchema.JsonType;
        }

        /// <summary>
        /// Returns the list of values for the specified schema.
        /// E.g. for enums the list would contain all of the enum values.
        /// The returned list can be empty (typically for integral types).
        /// </summary>
        /// <param name="jsonSchema">The schema object for which to return the list of values.</param>
        /// <returns>A list of possible values; can be an empty list.</returns>
        private IReadOnlyList<string> GetPossibleValues(JsonSchema jsonSchema)
        {
            if (jsonSchema == null)
                throw new ArgumentNullException(nameof(jsonSchema));

            var values = new List<string>();

            if (jsonSchema.Enum != null)
            {
                foreach (var e in jsonSchema.Enum)
                    values.Add(e);
            }
            else if (jsonSchema.Items != null && jsonSchema.Items.Ref == null)
            {
                if (jsonSchema.Items.Enum != null)
                {
                    foreach (var e in jsonSchema.Items.Enum)
                        values.Add(e);
                }
                else if (jsonSchema.Items.JsonType != null)
                {
                    values.Add(jsonSchema.Items.JsonType);
                }
            }
            else if (jsonSchema.Format == "uuid")
            {
                values.Add("globally unique identifier");
            }

            return values;
        }

        /// <summary>
        /// Returns the list of object type names that can be values for the specified schema.
        /// The returned list can be empty (i.e. the return values aren't objects).
        /// </summary>
        /// <param name="jsonSchema">The schema object for which to return the list of object type names.</param>
        /// <returns>A list of possible object names; can be an empty list.</returns>
        private IReadOnlyList<string> GetPossibleValueRefs(JsonSchema jsonSchema)
        {
            if (jsonSchema == null)
                throw new ArgumentNullException(nameof(jsonSchema));

            var values = new List<string>();

            if (jsonSchema.Ref != null)
            {
                values.Add(GetDefNameFromPointer(jsonSchema.Ref));
            }
            else if (jsonSchema.JsonType == "array" && jsonSchema.Items.Ref != null)
            {
                values.Add(GetDefNameFromPointer(jsonSchema.Items.Ref));
            }
            else if (jsonSchema.Items != null && jsonSchema.Items.OneOf != null)
            {
                foreach (var o in jsonSchema.Items.OneOf)
                {
                    values.Add(GetDefNameFromPointer(o.Ref));
                }
            }

            return values;
        }

        /// <summary>
        /// Returns the name of the item referenced in the specified JSON pointer.
        /// </summary>
        /// <param name="jsonPointer">A JSON pointer that points to an item in the list of definitions.</param>
        /// <returns>A string containing the name of the item referenced.</returns>
        private string GetDefNameFromPointer(string jsonPointer)
        {
            if (string.IsNullOrEmpty(jsonPointer))
                throw new ArgumentException(nameof(jsonPointer));
            if (jsonPointer[0] != '#')
                throw new ArgumentException(string.Format("Invalid argument '{0}', value must be a JSON pointer.", jsonPointer));

            return jsonPointer.Substring(jsonPointer.LastIndexOf('/') + 1);
        }

        /// <summary>
        /// Returns a schema object for the specified JSON pointer.
        /// </summary>
        /// <param name="jsonPointer">The JSON pointer for which to return a schema object.</param>
        /// <returns>A JsonSchema object for the specified type.</returns>
        private JsonSchema ResolveDefinitionRef(string jsonPointer)
        {
            if (string.IsNullOrEmpty(jsonPointer))
                throw new ArgumentException(nameof(jsonPointer));

            var defName = GetDefNameFromPointer(jsonPointer);
            if (!_schema.Definitions.ContainsKey(defName))
                throw new InvalidOperationException(string.Format("Didn't find a definition for '{0}'", jsonPointer));

            return _schema.Definitions[defName];
        }

        /// <summary>
        /// Creates a JToken hierarchy for the specified JsonSchema object.
        /// </summary>
        /// <param name="propName">The property name or null if the specified schema object is not a property.</param>
        /// <param name="jsonSchema">The schema object to transform into a JToken object.</param>
        /// <returns>A JToken object.</returns>
        private JToken JsonSchemaToJToken(string propName, JsonSchema jsonSchema)
        {
            return JsonSchemaToJTokenImpl(propName, jsonSchema, new Stack<string>());
        }

        /// <summary>
        /// Recursively creates a JToken hierarchy for the specified JsonSchema object (call JsonSchemaToJToken instead of this).
        /// </summary>
        /// <param name="propName">The property name or null if the specified schema object is not a property.</param>
        /// <param name="jsonSchema">The schema object to transform into a JToken object.</param>
        /// <param name="stack">Stack object used to detect cycles in the graph that would cause infinite recursion.</param>
        /// <returns>A JToken object.</returns>
        private JToken JsonSchemaToJTokenImpl(string propName, JsonSchema jsonSchema, Stack<string> stack)
        {
            if (jsonSchema == null)
                throw new ArgumentNullException(nameof(jsonSchema));

            if (jsonSchema.Ref != null)
            {
                // some definitions contain cycles which will lead to infinite recursion.
                // in this case return a JToken object with the referenced definition name.
                if (!stack.Contains(jsonSchema.Ref))
                {
                    stack.Push(jsonSchema.Ref);
                    var def = ResolveDefinitionRef(jsonSchema.Ref);
                    var result = JsonSchemaToJTokenImpl(propName, def, stack);
                    var popped = stack.Pop();
                    Debug.Assert(string.Compare(popped, jsonSchema.Ref, StringComparison.OrdinalIgnoreCase) == 0);
                    return result;
                }
                else
                {
                    var defName = GetDefNameFromPointer(jsonSchema.Ref);
                    if (propName != null)
                        return new JProperty(propName, defName);
                    else
                        return new JValue(defName);
                }
            }
            else if (jsonSchema.JsonType == "object")
            {
                var jobj = new JObject();
                var props = FlattenProperties(jsonSchema);
                foreach (var prop in props)
                {
                    jobj.Add(JsonSchemaToJTokenImpl(prop.Key, prop.Value, stack));
                }

                if (propName != null)
                    return new JProperty(propName, jobj);
                else
                    return jobj;
            }
            else if (jsonSchema.JsonType == "array")
            {
                Debug.Assert(jsonSchema.Items != null);
                var jarr = new JArray();

                // special-case the resources element so it always has an empty array
                if (propName != "resources")
                {
                    jarr.Add(JsonSchemaToJTokenImpl(null, jsonSchema.Items, stack));
                }

                return new JProperty(propName, jarr);
            }
            else
            {
                string val = null;
                if (jsonSchema.Enum != null && jsonSchema.Enum.Count == 1)
                    val = jsonSchema.Enum[0];
                else
                    val = jsonSchema.JsonType;

                if (propName != null)
                    return new JProperty(propName, val);
                else
                    return new JValue(val);
            }
        }

        /// <summary>
        /// Flattens properties in the AllOf and Properties sections into one list.
        /// </summary>
        /// <param name="jsonSchema">The JSON schema.</param>
        /// <returns>A dictionary of all possible properties.</returns>
        private IDictionary<string, JsonSchema> FlattenProperties(JsonSchema jsonSchema)
        {
            var merged = new Dictionary<string, JsonSchema>();
            FlattenPropertiesImpl(merged, new[] { jsonSchema });

            return merged;
        }

        /// <summary>
        /// Recursively flattens properties in the AllOf and Properties sections into one list (don't call this one call FlattenProperties).
        /// </summary>
        /// <param name="merged">The dictionary to contain the merged content.</param>
        /// <param name="items">The items to merge into the dictionary.</param>
        private void FlattenPropertiesImpl(Dictionary<string, JsonSchema> merged, IEnumerable<JsonSchema> items)
        {
            foreach (var item in items)
            {
                if (item.AllOf != null)
                {
                    FlattenPropertiesImpl(merged, item.AllOf);
                }
                else if (item.Properties != null)
                {
                    foreach (var prop in item.Properties)
                    {
                        merged.Add(prop.Key, prop.Value);
                    }
                }
                else if (item.Ref != null)
                {
                    var schema = ResolveDefinitionRef(item.Ref);
                    FlattenPropertiesImpl(merged, new[] { schema });
                }
            }
        }
    }
}
