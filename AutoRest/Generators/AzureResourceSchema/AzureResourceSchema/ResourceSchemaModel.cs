// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    /// <summary>
    /// An object representing an Azure Resource Schema. It is important to note that an Azure
    /// resource schema is actually not a valid JSON schema by itself. It is part of the
    /// deploymentTemplate.json schema.
    /// </summary>
    public class ResourceSchemaModel
    {
        /// <summary>
        /// The id metadata that uniquely identifies this schema. Usually this will be the URL to
        /// the permanent location of this schema in schema.management.azure.com/schemas/.
        /// </summary>
        public string Id { get; set; }

        /// <summary>
        /// The JSON schema metadata url that points to the schema that can be used to validate
        /// this schema.
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
        /// The named JSON schemas that define the resources of this resource schema.
        /// </summary>
        public IDictionary<string,JSONSchema> ResourceDefinitions { get; set; }

        /// <summary>
        /// The named reusable JSON schemas that the resource definitions reference. These
        /// definitions can also reference each other or themselves.
        /// </summary>
        public IDictionary<string,JSONSchema> Definitions { get; set; }

        /// <summary>
        /// Add the provided resource definition JSON schema to this resourceh schema.
        /// </summary>
        /// <param name="resourceName">The name of the resource definition.</param>
        /// <param name="resourceDefinition">The JSON schema that describes the resource.</param>
        public void AddResourceDefinition(string resourceName, JSONSchema resourceDefinition)
        {
            if (string.IsNullOrWhiteSpace(resourceName))
            {
                throw new ArgumentException("resourceName cannot be null or whitespace", "resourceName");
            }
            if (resourceDefinition == null)
            {
                throw new ArgumentNullException("resourceDefinition");
            }

            if (ResourceDefinitions == null)
            {
                ResourceDefinitions = new Dictionary<string, JSONSchema>();
            }

            if (ResourceDefinitions.ContainsKey(resourceName))
            {
                throw new ArgumentException("A resource definition for \"" + resourceName + "\" already exists in this resource schema.", "resourceName");
            }

            ResourceDefinitions.Add(resourceName, resourceDefinition);
        }

        /// <summary>
        /// Add the provided definition JSON schema to this resourceh schema.
        /// </summary>
        /// <param name="definitionName">The name of the resource definition.</param>
        /// <param name="definition">The JSON schema that describes the resource.</param>
        public void AddDefinition(string definitionName, JSONSchema definition)
        {
            if (string.IsNullOrWhiteSpace(definitionName))
            {
                throw new ArgumentException("definitionName cannot be null or whitespace", "definitionName");
            }
            if (definition == null)
            {
                throw new ArgumentNullException("definition");
            }

            if (Definitions == null)
            {
                Definitions = new Dictionary<string, JSONSchema>();
            }

            if (Definitions.ContainsKey(definitionName))
            {
                throw new ArgumentException("A definition for \"" + definitionName + "\" already exists in this resource schema.", "definitionName");
            }

            Definitions.Add(definitionName, definition);
        }
    }
}
