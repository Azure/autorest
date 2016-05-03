// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public class ResourceProperty
    {
        private readonly string name;
        private readonly bool isRequired;
        private readonly string propertyType;
        private readonly IEnumerable<string> allowedValues;
        private readonly string description;

        public ResourceProperty(string name, bool isRequired, string propertyType, IEnumerable<string> allowedValues, string description)
        {
            this.name = name;
            this.isRequired = isRequired;
            this.propertyType = propertyType;
            this.allowedValues = allowedValues;
            this.description = description;
        }

        public string Name
        {
            get { return name; }
        }

        public bool IsRequired
        {
            get { return isRequired; }
        }

        public string PropertyType
        {
            get { return propertyType; }
        }

        public IEnumerable<string> AllowedValues
        {
            get { return allowedValues; }
        }

        public string Description
        {
            get { return description; }
        }
    }
}
