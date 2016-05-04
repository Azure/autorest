// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    /// <summary>
    /// A Definition describes the value portion of a json object property's key value pair.
    /// For example, in 'a': { 'b': 'c' }, the value of 'a' ({ 'b': 'c'}) is the definition.
    /// </summary>
    public class Definition
    {
        /// <summary>
        /// The name of this Definition. This is not the same thing as the name of a property.
        /// </summary>
        public string Name { get; set; }

        public string DefinitionType { get; set; }

        public List<string> AllowedValues { get; set; }

        public List<SchemaProperty> Properties { get; set; }

        public List<string> RequiredPropertyNames { get; set; }

        public Definition ArrayElement { get; set; }

        public Definition AdditionalProperties { get; set; }

        public string Description { get; set; }

        /// <summary>
        /// Whether this definition should be flattened into its owner.
        /// </summary>
        //public bool ShouldFlatten { get; set; }

        public void AddAllowedValue(string allowedValue)
        {
            if (AllowedValues == null)
            {
                AllowedValues = new List<string>();
            }
            AllowedValues.Add(allowedValue);
        }

        public void AddProperty(SchemaProperty property, bool isRequired)
        {
            if (Properties == null)
            {
                Properties = new List<SchemaProperty>();
            }
            Properties.Add(property);

            if (isRequired)
            {
                AddRequiredPropertyName(property.Name);
            }
        }

        public void AddRequiredPropertyName(string propertyName)
        {
            if (RequiredPropertyNames == null)
            {
                RequiredPropertyNames = new List<string>();
            }
            RequiredPropertyNames.Add(propertyName);
        }
    }
}
