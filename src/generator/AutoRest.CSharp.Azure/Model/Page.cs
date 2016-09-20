// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.CSharp.Azure.Model
{
    public class Page
    {
        public Page(string typeDefinitionName, string nextLinkName, string itemName)
        {
            this.TypeDefinitionName = typeDefinitionName;
            this.NextLinkName = nextLinkName;
            this.ItemName = itemName;
        }

        public string NextLinkName { get; private set; }

        public string ItemName { get; private set; }

        public string TypeDefinitionName { get; private set; }
    }
}
