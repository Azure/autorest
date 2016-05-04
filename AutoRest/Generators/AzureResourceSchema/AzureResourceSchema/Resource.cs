// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public class Resource
    {
        public string Name { get; set; }

        public string ResourceType { get; set; }

        public List<string> ApiVersions { get; set; }

        public List<SchemaProperty> Properties { get; set; }

        public List<string> RequiredPropertyNames { get; set; }

        public string Description { get; set; }

        public void AddApiVersion(string apiVersion)
        {
            if (ApiVersions == null)
            {
                ApiVersions = new List<string>();
            }
            ApiVersions.Add(apiVersion);
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

        public override string ToString()
        {
            return Name;
        }
    }
}
