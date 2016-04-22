// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public class Resource
    {
        private readonly string name;
        private readonly string resourceType;
        private readonly string[] apiVersions;
        private readonly IEnumerable<ResourceProperty> properties;
        private readonly string description;

        public Resource(string name, string resourceType, string[] apiVersions, IEnumerable<ResourceProperty> properties, string description)
        {
            this.name = name;
            this.resourceType = resourceType;
            this.apiVersions = apiVersions;
            this.properties = properties;
            this.description = description;
        }

        public string Name
        {
            get { return name; }
        }

        public string ResourceType
        {
            get { return resourceType; }
        }

        public IEnumerable<string> ApiVersions
        {
            get { return apiVersions; }
        }

        public IEnumerable<ResourceProperty> Properties
        {
            get { return properties; }
        }

        public IEnumerable<string> RequiredPropertyNames
        {
            get { return Properties.Where(property => property.IsRequired).Select(property => property.Name).ToArray(); }
        }

        public string Description
        {
            get { return description; }
        }
    }
}
