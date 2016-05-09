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
    public class JSONSchema
    {
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
        public JSONSchema Items { get; set; }

        /// <summary>
        /// The description metadata that describes this schema.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// The type metadata of this schema that describes what type matching JSON values must be.
        /// </summary>
        public string JSONType { get; set; }

        /// <summary>
        /// The schema that matches additional properties that have not been specified in the
        /// Properties dictionary.
        /// </summary>
        public JSONSchema AdditionalProperties { get; set; }

        /// <summary>
        /// An enumeration of values that will match this JSON schema. Any value not in this
        /// enumeration will not match this schema.
        /// </summary>
        public IList<string> Enum { get; set; }

        /// <summary>
        /// The schemas that describe the properties of a matching JSON value.
        /// </summary>
        public IDictionary<string,JSONSchema> Properties { get; set; }

        /// <summary>
        /// The names of the properties that are required for a matching JSON value.
        /// </summary>
        public IList<string> Required { get; set; }

        public void AddEnum(string enumValue)
        {
            if (string.IsNullOrWhiteSpace(enumValue))
            {
                throw new ArgumentException("enumValue cannot be null or whitespace", "enumValue");
            }

            if (Enum == null)
            {
                Enum = new List<string>();
            }

            if (Enum.Contains(enumValue))
            {
                throw new ArgumentException("enumValue (" + enumValue + ") already exists in the list of allowed values.");
            }

            Enum.Add(enumValue);
        }

        public void AddProperty(string propertyName, JSONSchema propertyDefinition, bool isRequired = false)
        {
            if (string.IsNullOrWhiteSpace(propertyName))
            {
                throw new ArgumentException("propertyName cannot be null or whitespace", "propertyName");
            }
            if (propertyDefinition == null)
            {
                throw new ArgumentNullException("propertyDefinition");
            }
            
            if (Properties == null)
            {
                Properties = new Dictionary<string, JSONSchema>();
            }

            if (Properties.ContainsKey(propertyName))
            {
                throw new ArgumentException("A property with the name \"" + propertyName + "\" already exists in this JSONSchema", "propertyName");
            }

            Properties[propertyName] = propertyDefinition;

            if (isRequired)
            {
                AddRequired(propertyName);
            }
        }

        /// <summary>
        /// Add the provided required property names to this JSON schema's list of required property names.
        /// </summary>
        /// <param name="requiredPropertyName"></param>
        /// <param name="extraRequiredPropertyNames"></param>
        public void AddRequired(string requiredPropertyName, params string[] extraRequiredPropertyNames)
        {
            if (Properties == null || !Properties.ContainsKey(requiredPropertyName))
            {
                throw new ArgumentException("No property exists with the provided requiredPropertyName (" + requiredPropertyName + ")", "requiredPropertyName");
            }

            if (Required == null)
            {
                Required = new List<string>();
            }

            Required.Add(requiredPropertyName);

            if (extraRequiredPropertyNames != null)
            {
                foreach (string extraRequiredPropertyName in extraRequiredPropertyNames)
                {
                    if (Properties == null || !Properties.ContainsKey(extraRequiredPropertyName))
                    {
                        throw new ArgumentException("No property exists with the provided extraRequiredPropertyName (" + extraRequiredPropertyName + ")", "extraRequiredPropertyNames");
                    }
                    Required.Add(extraRequiredPropertyName);
                }
            }
        }

        public override bool Equals(object obj)
        {
            bool result = false;

            JSONSchema rhs = obj as JSONSchema;
            if (rhs != null)
            {
                result = Equals(Schema, rhs.Schema) &&
                         Equals(Title, rhs.Title) &&
                         Equals(Description, rhs.Description) &&
                         Equals(JSONType, rhs.JSONType) &&
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
                   GetHashCode(Description) ^
                   GetHashCode(JSONType) ^
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

        private static bool Equals(IDictionary<string, JSONSchema> lhs, IDictionary<string, JSONSchema> rhs)
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
