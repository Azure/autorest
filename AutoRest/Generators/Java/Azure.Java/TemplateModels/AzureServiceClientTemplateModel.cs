// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java.Azure
{
    public class AzureServiceClientTemplateModel : ServiceClientTemplateModel
    {
        public AzureServiceClientTemplateModel(ServiceClient serviceClient)
            : base(serviceClient)
        {
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == null)
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient)));
            ModelTemplateModels.Clear();
            ModelTypes.ForEach(m => ModelTemplateModels.Add(new AzureModelTemplateModel(m, serviceClient)));
        }

        public override IEnumerable<MethodGroupTemplateModel> MethodGroupModels
        {
            get
            {
                return MethodGroups.Select(mg => new AzureMethodGroupTemplateModel(this, mg));
            }
        }

        public override IEnumerable<MethodGroupTemplateModel> Operations
        {
            get
            {
                return MethodGroups.Select(mg => new AzureMethodGroupTemplateModel(this, mg));
            }
        }

        public override IEnumerable<string> InterfaceImports
        {
            get
            {
                var res = base.InterfaceImports.ToList();
                res.Add("com.microsoft.rest.AzureClient");
                return res;
            }
        }

        public override IEnumerable<string> ImplImports
        {
            get
            {
                var res = base.ImplImports.ToList();
                res.Add("com.microsoft.rest.AzureClient");
                return res;
            }
        }
    }
}