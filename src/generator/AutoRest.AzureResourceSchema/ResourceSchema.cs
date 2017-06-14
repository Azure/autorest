// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;

namespace AutoRest.AzureResourceSchema
{
    /// <summary>
    /// An object representing an Azure Resource Schema. It is important to note that an Azure
    /// resource schema is actually not a valid JSON schema by itself. It is part of the
    /// deploymentTemplate.json schema.
    /// </summary>
    public class ResourceSchema
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
        public IDictionary<string, JsonSchema> ResourceDefinitions { get; } = new Dictionary<string,JsonSchema>();

        /// <summary>
        /// The named reusable JSON schemas that the resource definitions reference. These
        /// definitions can also reference each other or themselves.
        /// </summary>
        public IDictionary<string,JsonSchema> Definitions { get; } = new Dictionary<string, JsonSchema>();

        /// <summary>
        /// Search this ResourceSchema for a resource definition that has the provided type.
        /// </summary>
        /// <param name="resourceType">The resource type to look for in this ResourceSchema.</param>
        /// <returns></returns>
        public JsonSchema GetResourceDefinitionByResourceType(string resourceType)
        {
            if (string.IsNullOrWhiteSpace(resourceType))
            {
                throw new ArgumentException("resourceType cannot be null or whitespace.", nameof(resourceType));
            }

            JsonSchema result = null;

            if (ResourceDefinitions != null && ResourceDefinitions.Count > 0)
            {
                foreach(JsonSchema resourceDefinition in ResourceDefinitions.Values)
                {
                    if (resourceDefinition.ResourceType == resourceType)
                    {
                        result = resourceDefinition;
                        break;
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// Add the provided resource definition JSON schema to this resourceh schema.
        /// </summary>
        /// <param name="resourceName">The name of the resource definition.</param>
        /// <param name="resourceDefinition">The JSON schema that describes the resource.</param>
        public ResourceSchema AddResourceDefinition(string resourceName, JsonSchema resourceDefinition)
        {
            if (string.IsNullOrWhiteSpace(resourceName))
            {
                throw new ArgumentException("resourceName cannot be null or whitespace", nameof(resourceName));
            }
            if (resourceDefinition == null)
            {
                throw new ArgumentNullException(nameof(resourceDefinition));
            }

            if (ResourceDefinitions.ContainsKey(resourceName))
            {
                throw new ArgumentException("A resource definition for \"" + resourceName + "\" already exists in this resource schema.", nameof(resourceName));
            }

            ResourceDefinitions.Add(resourceName, resourceDefinition);

            return this;
        }

        /// <summary>
        /// Add the provided definition JSON schema to this resourceh schema.
        /// </summary>
        /// <param name="definitionName">The name of the resource definition.</param>
        /// <param name="definition">The JSON schema that describes the resource.</param>
        public ResourceSchema AddDefinition(string definitionName, JsonSchema definition)
        {
            if (string.IsNullOrWhiteSpace(definitionName))
            {
                throw new ArgumentException("definitionName cannot be null or whitespace", nameof(definitionName));
            }
            if (definition == null)
            {
                throw new ArgumentNullException(nameof(definition));
            }

            if (Definitions.ContainsKey(definitionName))
            {
                throw new ArgumentException("A definition for \"" + definitionName + "\" already exists in this resource schema.", nameof(definitionName));
            }

            Definitions.Add(definitionName, definition);

            return this;
        }
    }
}
