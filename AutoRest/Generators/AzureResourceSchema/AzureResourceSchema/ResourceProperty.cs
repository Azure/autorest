// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public class ResourceProperty
    {
        private readonly string name;
        private readonly bool isRequired;
        private readonly string type;
        private readonly string[] allowedValues;
        private readonly string description;

        public ResourceProperty(string name, bool isRequired = false, string type = null, string[] allowedValues = null, string description = null)
        {
            this.name = name;
            this.isRequired = isRequired;
            this.type = type;
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

        public string Type
        {
            get { return type; }
        }

        public string[] AllowedValues
        {
            get { return allowedValues; }
        }

        public string Description
        {
            get { return description; }
        }
    }
}
