// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.AzureResourceSchema
{
    /// <summary>
    /// An object representing a JSON schema. Each property of a JSON schema ($schema, title, and
    /// description are metadata, not properties) is also a JSON schema, so the class is recursive.
    /// </summary>
    public class JsonSchema
    {
        private string resourceType;
        private IList<string> enumList;
        private IDictionary<string, JsonSchema> properties;
        private IList<string> requiredList;
        private IList<JsonSchema> oneOfList;

        /// <summary>
        /// A reference to the location in the parent schema where this schema's definition can be
        /// found.
        /// </summary>
        public string Ref { get; set; }

        /// <summary>
        /// The JSONSchema that will be applied to the elements of this schema, assuming this
        /// schema is an array schema type.
        /// </summary>
        public JsonSchema Items { get; set; }

        /// <summary>
        /// The format of the value that matches this schema. This only applies to string values.
        /// </summary>
        public string Format { get; set; }

        /// <summary>
        /// The description metadata that describes this schema.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// The type metadata of this schema that describes what type matching JSON values must be.
        /// For example, this value will be either "object", "string", "array", "integer",
        /// "number", or "boolean".
        /// </summary>
        public string JsonType { get; set; }

        /// <summary>
        /// Gets or sets the resource type of this JsonSchema.
        /// </summary>
        public string ResourceType
        {
            get
            {
                return resourceType;
            }
            set
            {
                resourceType = value;
                if (Properties != null && Properties.ContainsKey("type"))
                {
                    // update the value of the type enum.  we have to be careful though that we don't
                    // stomp over some other enum that happens to have the name "type".  this code path
                    // is typically hit when building a child resource definition from a cloned parent.
                    if (Properties["type"].enumList.Count > 1)
                        throw new InvalidOperationException("Attempt to update 'type' enum that contains more than one member (possible collision).");
                    if (!Properties["type"].enumList[0].EndsWith(value))
                        throw new InvalidOperationException($"The updated type value '{value}' is not a child of type value '{Properties["type"].enumList[0]}'");

                    Properties["type"].enumList[0] = value;
                }
            }
        }

        /// <summary>
        /// The minimum value that a numeric value matching this schema can have.
        /// </summary>
        public double? Minimum { get; set; }

        /// <summary>
        /// The maximum value that a numeric value matching this schema can have.
        /// </summary>
        public double? Maximum { get; set; }

        /// <summary>
        /// The regular expression pattern that a string value matching this schema must match.
        /// </summary>
        public string Pattern { get; set; }

        /// <summary>
        /// The minimum length that a string or an array matching this schema can have.
        /// </summary>
        public double? MinLength { get; set; }

        /// <summary>
        /// The maximum length that a string or an array matching this schema can have.
        /// </summary>
        public double? MaxLength { get; set; }

        /// <summary>
        /// The schema that matches additional properties that have not been specified in the
        /// Properties dictionary.
        /// </summary>
        public JsonSchema AdditionalProperties { get; set; }

        /// <summary>
        /// An enumeration of values that will match this JSON schema. Any value not in this
        /// enumeration will not match this schema.
        /// </summary>
        public IList<string> Enum
        {
            get { return enumList; }
        }

        /// <summary>
        /// The list of oneOf options that exist for this JSON schema.
        /// </summary>
        public IList<JsonSchema> OneOf
        {
            get { return oneOfList; }
        }

        /// <summary>
        /// The schemas that describe the properties of a matching JSON value.
        /// </summary>
        public IDictionary<string,JsonSchema> Properties
        {
            get { return properties; }
        }

        /// <summary>
        /// The names of the properties that are required for a matching JSON value.
        /// </summary>
        public IList<string> Required
        {
            get { return requiredList; }
        }

        /// <summary>
        /// Add a new value (or values) to this JsonSchema's enum list. This JsonSchema (with the
        /// new value(s)) is then returned so that additional changes can be chained together.
        /// </summary>
        /// <param name="enumValue"></param>
        /// <param name="extraEnumValues"></param>
        /// <returns></returns>
        public JsonSchema AddEnum(string enumValue, params string[] extraEnumValues)
        {
            if (string.IsNullOrWhiteSpace(enumValue))
            {
                throw new ArgumentException("enumValue cannot be null or whitespace", "enumValue");
            }

            if (enumList == null)
            {
                enumList = new List<string>();
            }

            if (enumList.Contains(enumValue))
            {
                throw new ArgumentException("enumValue (" + enumValue + ") already exists in the list of allowed values.", "enumValue");
            }
            enumList.Add(enumValue);

            if (extraEnumValues != null && extraEnumValues.Length > 0)
            {
                foreach (string extraEnumValue in extraEnumValues)
                {
                    if (enumList.Contains(extraEnumValue))
                    {
                        throw new ArgumentException("extraEnumValue (" + extraEnumValue + ") already exists in the list of allowed values.", "extraEnumValues");
                    }
                    enumList.Add(extraEnumValue);
                }
            }

            return this;
        }

        /// <summary>
        /// Add a new property to this JsonSchema, and then return this JsonSchema so that
        /// additional changes can be chained together.
        /// </summary>
        /// <param name="propertyName">The name of the property to add.</param>
        /// <param name="propertyDefinition">The JsonSchema definition of the property to add.</param>
        /// <returns></returns>
        public JsonSchema AddProperty(string propertyName, JsonSchema propertyDefinition)
        {
            return AddProperty(propertyName, propertyDefinition, false);
        }

        /// <summary>
        /// Add a new property to this JsonSchema, and then return this JsonSchema so that
        /// additional changes can be chained together.
        /// </summary>
        /// <param name="propertyName">The name of the property to add.</param>
        /// <param name="propertyDefinition">The JsonSchema definition of the property to add.</param>
        /// <param name="isRequired">Whether this property is required or not.</param>
        /// <returns></returns>
        public JsonSchema AddProperty(string propertyName, JsonSchema propertyDefinition, bool isRequired)
        {
            if (string.IsNullOrWhiteSpace(propertyName))
            {
                throw new ArgumentException("propertyName cannot be null or whitespace", "propertyName");
            }
            if (propertyDefinition == null)
            {
                throw new ArgumentNullException("propertyDefinition");
            }
            
            if (properties == null)
            {
                properties = new Dictionary<string, JsonSchema>();
            }

            if (properties.ContainsKey(propertyName))
            {
                throw new ArgumentException("A property with the name \"" + propertyName + "\" already exists in this JSONSchema", "propertyName");
            }

            properties[propertyName] = propertyDefinition;

            if (isRequired)
            {
                AddRequired(propertyName);
            }

            return this;
        }

        /// <summary>
        /// Add the provided required property names to this JSON schema's list of required property names.
        /// </summary>
        /// <param name="requiredPropertyName"></param>
        /// <param name="extraRequiredPropertyNames"></param>
        public JsonSchema AddRequired(string requiredPropertyName, params string[] extraRequiredPropertyNames)
        {
            if (Properties == null || !Properties.ContainsKey(requiredPropertyName))
            {
                throw new ArgumentException("No property exists with the provided requiredPropertyName (" + requiredPropertyName + ")", nameof(requiredPropertyName));
            }

            if (requiredList == null)
            {
                requiredList = new List<string>();
            }

            if (requiredList.Contains(requiredPropertyName))
            {
                throw new ArgumentException("'" + requiredPropertyName + "' is already a required property.", "requiredPropertyName");
            }
            requiredList.Add(requiredPropertyName);

            if (extraRequiredPropertyNames != null)
            {
                foreach (string extraRequiredPropertyName in extraRequiredPropertyNames)
                {
                    if (Properties == null || !Properties.ContainsKey(extraRequiredPropertyName))
                    {
                        throw new ArgumentException("No property exists with the provided extraRequiredPropertyName (" + extraRequiredPropertyName + ")", "extraRequiredPropertyNames");
                    }
                    if (requiredList.Contains(extraRequiredPropertyName))
                    {
                        throw new ArgumentException("'" + extraRequiredPropertyName + "' is already a required property.", "extraRequiredPropertyNames");
                    }
                    requiredList.Add(extraRequiredPropertyName);
                }
            }

            return this;
        }

        /// <summary>
        /// Add the provided JSON schema as an option for the oneOf property of this JSON schema.
        /// </summary>
        /// <param name="oneOfOption"></param>
        /// <returns></returns>
        public JsonSchema AddOneOf(JsonSchema oneOfOption)
        {
            if (oneOfOption == null)
            {
                throw new ArgumentNullException(nameof(oneOfOption));
            }

            if (oneOfList == null)
            {
                oneOfList = new List<JsonSchema>();
            }

            oneOfList.Add(oneOfOption);

            return this;
        }

        /// <summary>
        /// Create a new JsonSchema that is an exact copy of this one.
        /// </summary>
        /// <returns></returns>
        public JsonSchema Clone()
        {
            JsonSchema result = new JsonSchema();
            result.Ref = Ref;
            result.Items = Clone(Items);
            result.Description = Description;
            result.JsonType = JsonType;
            result.AdditionalProperties = Clone(AdditionalProperties);
            result.Minimum = Minimum;
            result.Maximum = Maximum;
            result.Pattern = Pattern;
            result.enumList = Clone(Enum);
            result.properties = Clone(Properties);
            result.requiredList = Clone(Required);
            result.oneOfList = Clone(OneOf);
            return result;
        }

        private static JsonSchema Clone(JsonSchema toClone)
        {
            JsonSchema result = null;

            if (toClone != null)
            {
                result = toClone.Clone();
            }

            return result;
        }

        private static IList<string> Clone(IList<string> toClone)
        {
            IList<string> result = null;

            if (toClone != null)
            {
                result = new List<string>(toClone);
            }

            return result;
        }

        private static IList<JsonSchema> Clone(IList<JsonSchema> toClone)
        {
            IList<JsonSchema> result = null;

            if (toClone != null)
            {
                result = new List<JsonSchema>();
                foreach (JsonSchema schema in toClone)
                {
                    result.Add(Clone(schema));
                }
            }

            return result;
        }

        private static IDictionary<string,JsonSchema> Clone(IDictionary<string,JsonSchema> toClone)
        {
            IDictionary<string, JsonSchema> result = null;

            if (toClone != null)
            {
                result = new Dictionary<string, JsonSchema>();
                foreach (string key in toClone.Keys)
                {
                    result.Add(key, Clone(toClone[key]));
                }
            }

            return result;
        }

        public override bool Equals(object obj)
        {
            bool result = false;

            JsonSchema rhs = obj as JsonSchema;
            if (rhs != null)
            {
                result = Equals(Ref, rhs.Ref) &&
                         Equals(Items, rhs.Items) &&
                         Equals(JsonType, rhs.JsonType) &&
                         Equals(AdditionalProperties, rhs.AdditionalProperties) &&
                         Equals(Enum, rhs.Enum) &&
                         Equals(Properties, rhs.Properties) &&
                         Equals(Required, rhs.Required) &&
                         Equals(Description, rhs.Description) &&
                         Equals(Minimum, rhs.Minimum) &&
                         Equals(Maximum, rhs.Maximum) &&
                         Equals(Pattern, rhs.Pattern);
            }

            return result;
        }

        public override int GetHashCode()
        {
            return GetHashCode(GetType()) ^
                   GetHashCode(Ref) ^
                   GetHashCode(Items) ^
                   GetHashCode(Description) ^
                   GetHashCode(JsonType) ^
                   GetHashCode(AdditionalProperties) ^
                   GetHashCode(Enum) ^
                   GetHashCode(Properties) ^
                   GetHashCode(Required) ^
                   GetHashCode(Description) ^
                   GetHashCode(Minimum) ^
                   GetHashCode(Maximum) ^
                   GetHashCode(Pattern);
        }

        private static int GetHashCode(object value)
        {
            return value == null ? 0 : value.GetHashCode();
        }

        private static bool Equals(IEnumerable<string> lhs, IEnumerable<string> rhs)
        {
            bool result = lhs == rhs;

            if (!result &&
                lhs != null &&
                rhs != null &&
                lhs.Count() == rhs.Count())
            {
                result = true;

                IEnumerator<string> lhsEnumerator = lhs.GetEnumerator();
                IEnumerator<string> rhsEnumerator = rhs.GetEnumerator();
                while (lhsEnumerator.MoveNext() && rhsEnumerator.MoveNext())
                {
                    if (!Equals(lhsEnumerator.Current, rhsEnumerator.Current))
                    {
                        result = false;
                        break;
                    }
                }
            }

            return result;
        }

        private static bool Equals(IDictionary<string, JsonSchema> lhs, IDictionary<string, JsonSchema> rhs)
        {
            bool result = lhs == rhs;

            if (!result &&
                lhs != null &&
                rhs != null &&
                lhs.Count == rhs.Count)
            {
                result = true;

                foreach (string key in lhs.Keys)
                {
                    if (rhs.ContainsKey(key) == false ||
                        !Equals(lhs[key], rhs[key]))
                    {
                        result = false;
                        break;
                    }
                }
            }

            return result;
        }

        public static JsonSchema CreateStringEnum(string enumValue, params string[] extraEnumValues)
        {
            JsonSchema result = new JsonSchema() { JsonType = "string" };
            result.AddEnum(enumValue);
            if (extraEnumValues != null)
            {
                foreach (string extraEnumValue in extraEnumValues)
                {
                    result.AddEnum(extraEnumValue);
                }
            }
            return result;
        }
    }
}
