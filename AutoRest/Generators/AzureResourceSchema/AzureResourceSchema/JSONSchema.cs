// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Diagnostics;

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
        /// The description metadata that describes this schema.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// The type metadata of this schema that describes what type matching JSON values must be.
        /// </summary>
        public string Type { get; set; }

        /// <summary>
        /// The schemas that describe the properties of a matching JSON value.
        /// </summary>
        public IDictionary<string,JSONSchema> Properties { get; set; }

        /// <summary>
        /// The names of the properties that are required for a matching JSON value.
        /// </summary>
        public IEnumerable<string> Required { get; set; }

        /// <summary>
        /// Add the provided property to this JSON schema.
        /// </summary>
        /// <param name="propertyName">The name of the property to add.</param>
        /// <param name="propertySchema">The schema of the property to add.</param>
        public void AddProperty(string propertyName, JSONSchema propertySchema)
        {
            Debug.Assert(!string.IsNullOrWhiteSpace(propertyName));
            Debug.Assert(Properties == null || !Properties.ContainsKey(propertyName));
            Debug.Assert(propertySchema != null);

            if (Properties == null)
            {
                Properties = new Dictionary<string, JSONSchema>();
            }
            Properties.Add(propertyName, propertySchema);
        }
    }
}
