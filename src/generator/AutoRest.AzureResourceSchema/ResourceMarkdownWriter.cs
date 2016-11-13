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

    public class ResourceMarkdownWriter
    {
        private const string RequiredFalse = "No";
        private const string RequiredTrue = "Yes";

        private MarkdownWriter _writer;
        private ResourceSchema _schema;

        private ResourceMarkdownWriter(TextWriter writer, ResourceSchema resourceSchema)
        {
            _writer = new MarkdownWriter(writer);
            _schema = resourceSchema;
        }

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

            var mdWriter = new ResourceMarkdownWriter(writer, resourceSchema);
            mdWriter.Generate();
        }

        private void Generate()
        {
            _writer.WriteLine(new Header("{0} template schema", _schema.Title));
            _writer.WriteLine(new Paragraph("Creates a {0} resource.", _schema.Title));

            WriteSchemaFormatSection();
            WriteValuesSection();
        }

        /// <summary>
        /// Generates the "schema format" section.
        /// </summary>
        private void WriteSchemaFormatSection()
        {
            _writer.WriteLine(new Header(2, "Schema format"));
            _writer.WriteLine(new Paragraph("To create a {0}, add the following schema to the resources section of your template.", _schema.Title));

            foreach (var resDefName in _schema.ResourceDefinitions.Keys)
            {
                using (var stringWriter = new StringWriter())
                {
                    using (var json = new JsonTextWriter(stringWriter))
                    {
                        json.Formatting = Formatting.Indented;
                        var resDef = _schema.ResourceDefinitions[resDefName];
                        var root = new JObject();

                        foreach (var prop in resDef.Properties)
                        {
                            // omit non-required objects
                            if (resDef.Required != null && !resDef.Required.Contains(prop.Key))
                                continue;

                            root.Add(JsonSchemaToJToken(prop.Key, prop.Value));
                        }

                        root.WriteTo(json);
                    }

                    // put each resource definition into its own code block
                    _writer.WriteLine(new Codeblock(stringWriter.ToString()));
                }
            }
        }

        /// <summary>
        /// Generates the "values" section; this contains tables describing all of the JSON types.
        /// </summary>
        private void WriteValuesSection()
        {
            _writer.WriteLine(new Header(2, "Values"));
            _writer.Write(new Paragraph("The following tables describe the values you need to set in the schema."));

            foreach (var resDefName in _schema.ResourceDefinitions.Keys)
            {
                var resDef = _schema.ResourceDefinitions[resDefName];
                Debug.Assert(resDef.JsonType == "object");
                var table = CreateTable(resDefName, resDef);
                _writer.Write(table);
            }

            foreach (var defName in _schema.Definitions.Keys)
            {
                var def = _schema.Definitions[defName];

                // there are a handful of objects with null properties because the properties
                // are all read-only.  for now just skip them to avoid a crash during table creation.
                if (def.Properties == null)
                    continue;

                var table = CreateTable(defName, def);
                _writer.Write(table);
            }
        }

        /// <summary>
        /// Creates a markdown table that describes the specified JSON schema.
        /// </summary>
        /// <param name="header">The markdown header to place before the table.</param>
        /// <param name="jsonSchema">The JSON schema that is to be described by the table.</param>
        /// <param name="tableQueue">A queue containing the JSON schemas to be converted to table format.</param>
        /// <returns>A formatted table with sub-header.</returns>
        private MarkdownElement CreateTable(string header, JsonSchema jsonSchema)
        {
            if (string.IsNullOrEmpty(header))
                throw new ArgumentException(nameof(header));
            if (jsonSchema == null)
                throw new ArgumentNullException(nameof(jsonSchema));

            Debug.Assert(jsonSchema.Properties != null);

            // write the table header
            var paragraph = new Paragraph();
            paragraph.Append(new Anchor(header));
            paragraph.Append(Environment.NewLine);
            paragraph.Append(new Header(2, "{0} object", header));
            paragraph.Append(Environment.NewLine);

            var table = new Table(new[] { "Name", "Required", "Value" });

            // add a table row for each property in the schema
            foreach (var prop in jsonSchema.Properties)
            {
                // build the content that will appear in the value column.  it looks
                // something like the following (each entry is separated by a line break):

                // type name
                // values (might not be present depending on the type)
                // description

                // type name
                var sb = new StringBuilder();
                sb.Append(GetValueTypeName(prop.Value));
                sb.Append(new LineBreak());

                // required/optional
                var required = RequiredFalse;
                if (jsonSchema.Required != null && jsonSchema.Required.Contains(prop.Key))
                    required = RequiredTrue;

                // valuess
                var values = GetPossibleValues(prop.Value);
                if (values.Count > 0)
                {
                    if (values.Count == 1)
                        sb.Append(new Strong(values[0]));
                    else if (values.Count == 2)
                        sb.Append(string.Join(" or ", values.Select(v => { return new Strong(v); })));
                    else
                        sb.Append(string.Join(", ", values.Select(v => { return new Strong(v); })));
                    sb.Append(new LineBreak());
                }
                else if ((values = GetPossibleValueObjects(prop.Value)).Count > 0)
                {
                    if (values.Count == 1)
                        sb.AppendFormat(new InlineLink(values[0], "{0} object", values[0]).ToString());
                    else
                        sb.Append(string.Join(new LineBreak().ToString(), values.Select(
                            v =>
                            {
                                return new InlineLink(v, "{0} object", v).ToString();
                            })));

                    sb.Append(new LineBreak());
                }

                // description
                if (!string.IsNullOrWhiteSpace(prop.Value.Description))
                {
                    sb.Append(new LineBreak());
                    sb.Append(prop.Value.Description);
                }

                table.AddRow(new[] { prop.Key, required, sb.ToString() });
            }

            paragraph.Append(table);
            return paragraph;
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
        private IReadOnlyList<string> GetPossibleValueObjects(JsonSchema jsonSchema)
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
                    var js = ResolveDefinitionRef(o.Ref);
                    if (js.JsonType == "object")
                    {
                        Debug.Assert(!string.IsNullOrEmpty(js.ResourceType));
                        values.Add(js.ResourceType);
                    }
                    else
                    {
                        Debug.Assert(false, "unhandled case");
                    }
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
                if (jsonSchema.Properties != null)
                {
                    foreach (var prop in jsonSchema.Properties)
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
                jarr.Add(JsonSchemaToJTokenImpl(null, jsonSchema.Items, stack));

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
    }
}
