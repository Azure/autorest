// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Java.TemplateModels;

namespace AutoRest.Java.Azure.TemplateModels
{
    public class AzureEnumTemplateModel : EnumTemplateModel
    {
        public AzureEnumTemplateModel(EnumType source)
            : base(source)
        {
        }

        public override string ModelsPackage
        {
            get
            {
                return ".models";
            }
        }
    }
}