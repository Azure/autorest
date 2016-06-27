// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Azure;

namespace Microsoft.Rest.Generator.Java.Azure
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

        public IEnumerable<string> ImportList
        {
            get
            {
                List<string> imports = new List<string>();
                imports.Add("com.microsoft.azure.Page");
                imports.Add("java.util.List");
                imports.Add("com.fasterxml.jackson.annotation.JsonProperty");
                return imports.OrderBy(i => i).Distinct();
            }
        }
    }
}
