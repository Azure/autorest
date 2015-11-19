// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Azure;

namespace Microsoft.Rest.Generator.Azure.Python
{
    public class PageTemplateModel
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
    }
}
