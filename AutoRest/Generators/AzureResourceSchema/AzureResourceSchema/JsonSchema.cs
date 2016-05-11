// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    /// <summary>
    /// An object representing a JSON schema. Each property of a JSON schema ($schema, title, and
    /// description are metadata, not properties) is also a JSON schema, so the class is recursive.
    /// </summary>
    public class JsonSchema
    {
        private IList<string> enumList;
        private IDictionary<string, JsonSchema> properties;
        private IList<string> requiredList;

        /// <summary>
        /// The $schema metadata that points to a URL or file location where this schema's schema is stored.
        /// </summary>
        public string Schema { get; set; }

        /// <summary>
        /// The title metadata for this schema.
        /// </summary>
        public string Title { get; set; }

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
        /// The description metadata that describes this schema.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// The type metadata of this schema that describes what type matching JSON values must be.
        /// </summary>
        public string JsonType { get; set; }

        /// <summary>
        /// The schema that matches additional properties that have not been specified in the
        /// Properties dictionary.
        /// </summary>
        public JsonSchema AdditionalProperties { get; set; }

        /// <summary>
        /// An enumeration of values that will match this JSON schema. Any value not in this
        /// enumeration will not match this schema.
        /// </summary>
        public IEnumerable<string> Enum
        {
            get { return enumList; }
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
                throw new ArgumentException("No property exists with the provided requiredPropertyName (" + requiredPropertyName + ")", "requiredPropertyName");
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

        public override bool Equals(object obj)
        {
            bool result = false;

            JsonSchema rhs = obj as JsonSchema;
            if (rhs != null)
            {
                result = Equals(Schema, rhs.Schema) &&
                         Equals(Title, rhs.Title) &&
                         Equals(Ref, rhs.Ref) &&
                         Equals(Items, rhs.Items) &&
                         Equals(JsonType, rhs.JsonType) &&
                         Equals(AdditionalProperties, rhs.AdditionalProperties) &&
                         Equals(Enum, rhs.Enum) &&
                         Equals(Properties, rhs.Properties) &&
                         Equals(Required, rhs.Required);
            }

            return result;
        }

        public override int GetHashCode()
        {
            return GetHashCode(GetType()) ^
                   GetHashCode(Schema) ^
                   GetHashCode(Title) ^
                   GetHashCode(Ref) ^
                   GetHashCode(Items) ^
                   GetHashCode(Description) ^
                   GetHashCode(JsonType) ^
                   GetHashCode(AdditionalProperties) ^
                   GetHashCode(Enum) ^
                   GetHashCode(Properties) ^
                   GetHashCode(Required);
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
    }
}
