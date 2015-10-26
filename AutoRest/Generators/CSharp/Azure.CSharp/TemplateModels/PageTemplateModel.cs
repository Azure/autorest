// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Azure;

namespace Microsoft.Rest.Generator.CSharp.Azure
{
    public class PageTemplateModel
    {
        public PageTemplateModel(string typeDefinitionName, string nextLinkName, string itemName)
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
