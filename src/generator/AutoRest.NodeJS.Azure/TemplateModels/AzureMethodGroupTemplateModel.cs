// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.NodeJS.TemplateModels;

namespace AutoRest.NodeJS.Azure.TemplateModels
{
    public class AzureMethodGroupTemplateModel : MethodGroupTemplateModel
    {
        public AzureMethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName)
            : base(serviceClient, methodGroupName)
        {
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == MethodGroupName)
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient)));
        }
    }
}