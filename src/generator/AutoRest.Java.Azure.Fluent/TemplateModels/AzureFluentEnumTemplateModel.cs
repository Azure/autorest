// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Java.Azure.TemplateModels;

namespace AutoRest.Java.Azure.Fluent.TemplateModels
{
    public class AzureFluentEnumTemplateModel : AzureEnumTemplateModel
    {
        public AzureFluentEnumTemplateModel(EnumType source)
            : base(source)
        {
        }

        public override string ModelsPackage
        {
            get
            {
                return "";
            }
        }
    }
}