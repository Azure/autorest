// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Java.Azure.Model;
using Newtonsoft.Json;

namespace AutoRest.Java.Azure.Fluent.Model
{
    public class PageJvaf : PageJva
    {
        public PageJvaf(string typeDefinitionName, string nextLinkName, string itemName)
            : base(typeDefinitionName, nextLinkName, itemName) {
        }

        [JsonIgnore]
        public override string ModelsPackage
        {
            get
            {
                return "implementation";
            }
        }
    }
}
