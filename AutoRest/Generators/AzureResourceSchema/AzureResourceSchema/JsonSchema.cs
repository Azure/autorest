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
        private IList<JsonSchema> resources;

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
        /// Get the resource type of this JsonSchema. If this JsonSchema defines an Azure Resource,
        /// then this value will be found in definition.properties.type.enum[0]. If this JsonSchema
        /// does not define an Azure Resource, then this will return null.
        /// </summary>
        public string ResourceType
        {
            get
            {
                string result = null;

                if (Properties != null &&
                    Properties.ContainsKey("type") &&
                    Properties["type"].Enum != null)
                {
                    result = Properties["type"].Enum.SingleOrDefault();
                }

                return result;
            }
            set
            {
                if (properties == null)
                {
                    properties = new Dictionary<string, JsonSchema>();
                }

                if (!Properties.ContainsKey("type"))
                {
                    Properties["type"] = new JsonSchema();
                }

                Properties["type"].enumList = new List<string>() { value };
            }
        }

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
        /// The child resources that are allowed for this JsonSchema.
        /// </summary>
        public IList<JsonSchema> Resources
        {
            get { return resources; }
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

        /// <summary>
        /// Add a child resource schema to this JsonSchema.
        /// </summary>
        /// <param name="childResourceSchema">The child resource schema to add to this JsonSchema.</param>
        /// <returns></returns>
        public JsonSchema AddResource(JsonSchema childResourceSchema)
        {
            if (childResourceSchema == null)
            {
                throw new ArgumentNullException("childResourceSchema");
            }

            if (resources == null)
            {
                resources = new List<JsonSchema>();
            }
            resources.Add(childResourceSchema);

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
            result.enumList = Clone(Enum);
            result.properties = Clone(Properties);
            result.requiredList = Clone(Required);
            result.resources = Clone(Resources);
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
                         Equals(Description, rhs.Description);
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
                   GetHashCode(Description);
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
