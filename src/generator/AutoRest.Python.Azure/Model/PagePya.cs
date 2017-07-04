// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using AutoRest.Python.Model;

namespace AutoRest.Python.Azure.Model
{
    public class PagePya : IEquatable<PagePya>
    {
        private readonly string _typeDefinitionName;

        public PagePya(string className, string nextLinkName, string itemName, IModelType itemType)
        {
            this._typeDefinitionName = className;
            this.NextLinkName = nextLinkName;
            this.ItemName = itemName;
            this.ItemType = itemType;
        }

        public string NextLinkName { get; private set; }

        public string ItemName { get; private set; }

        public string TypeDefinitionName => CodeNamer.Instance.GetTypeName(_typeDefinitionName);

        public IModelType ItemType { get; private set; }

        public string GetReturnTypeDocumentation()
        {
            return (ItemType as IExtendedModelTypePy)?.ReturnTypeDocumentation ?? ItemType.Name;
        }

        public bool Equals(PagePya other)
        {
            if (other != null && 
                this.NextLinkName.EqualsIgnoreCase(other.NextLinkName) && 
                this.TypeDefinitionName.EqualsIgnoreCase(other.TypeDefinitionName) && 
                this.ItemName.EqualsIgnoreCase(other.ItemName))
            {
                return true;
            }
            return false;
        }
    }
}
