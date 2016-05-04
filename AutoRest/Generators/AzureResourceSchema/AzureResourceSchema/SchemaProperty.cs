// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.


namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    /// <summary>
    /// A SchemaProperty is a property for a JSON object within a Schema.
    /// </summary>
    public class SchemaProperty
    {
        /// <summary>
        /// The name of the property.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// The definition of this property. For example, in 'a': { 'b': 'c' }, 'a' is the property
        /// name and { 'b': 'c' } is the definition.
        /// </summary>
        public Definition Definition { get; set; }

        /// <summary>
        /// An explanation of what the property is for.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Whether or not this property should be flattened into its parent property or resource.
        /// </summary>
        public bool ShouldFlatten { get; set; }

        public override string ToString()
        {
            return Name;
        }
    }
}
