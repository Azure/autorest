// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Python.Azure.TemplateModels
{
    public class PageTemplateModel : IEquatable<PageTemplateModel>
    {
        public PageTemplateModel(string className, string nextLinkName, string itemName, string itemType)
        {
            this.TypeDefinitionName = className;
            this.NextLinkName = nextLinkName;
            this.ItemName = itemName;
            this.ItemType = itemType;
        }

        public string NextLinkName { get; private set; }

        public string ItemName { get; private set; }

        public string TypeDefinitionName { get; private set; }

        public string ItemType { get; private set; }

        public bool Equals(PageTemplateModel other)
        {
            if (other != null && this.NextLinkName == other.NextLinkName && 
                this.TypeDefinitionName == other.TypeDefinitionName && this.ItemName == other.ItemName)
            {
                return true;
            }
            return false;
        }
    }
}
