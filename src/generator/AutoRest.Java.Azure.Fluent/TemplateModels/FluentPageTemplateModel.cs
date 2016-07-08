// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Java.Azure.TemplateModels;

namespace AutoRest.Java.Azure.Fluent.TemplateModels
{
    public class FluentPageTemplateModel : PageTemplateModel
    {
        public FluentPageTemplateModel(string typeDefinitionName, string nextLinkName, string itemName)
            : base(typeDefinitionName, nextLinkName, itemName) {
        }

        public override string ModelsPackage
        {
            get
            {
                return "implementation";
            }
        }
    }
}
