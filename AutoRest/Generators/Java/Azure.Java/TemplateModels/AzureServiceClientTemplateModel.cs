// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java.Azure
{
    public class AzureServiceClientTemplateModel : ServiceClientTemplateModel
    {
        public const string ExternalExtension = "x-ms-external";

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
                this.ModelTypes.Where(m => m.Extensions.ContainsKey(ExternalExtension) && (bool)m.Extensions[ExternalExtension])
                    .Select(m => (IType)m).ToList().TypeImports(this.Namespace)
                    .ForEach(t => res.Remove(t));
                res.Add("com.microsoft.rest.AzureClient");
                res.Add("com.microsoft.rest.CloudError");
                res.Add("com.microsoft.rest.BaseResource");
                return res;
            }
        }

        public override IEnumerable<string> ImplImports
        {
            get
            {
                var res = base.ImplImports.ToList();
                this.ModelTypes.Where(m => m.Extensions.ContainsKey(ExternalExtension) && (bool)m.Extensions[ExternalExtension])
                    .Select(m => (IType)m).ToList().TypeImports(this.Namespace)
                    .ForEach(t => res.Remove(t));
                res.Add("com.microsoft.rest.AzureClient");
                res.Add("com.microsoft.rest.CloudError");
                res.Add("com.microsoft.rest.BaseResource");
                res.Add("retrofit.Callback");
                return res;
            }
        }
    }
}