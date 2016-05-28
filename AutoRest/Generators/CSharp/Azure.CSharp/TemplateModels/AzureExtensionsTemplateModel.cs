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
    public class AzureExtensionsTemplateModel : ExtensionsTemplateModel
    {
        public AzureExtensionsTemplateModel(ServiceClient serviceClient, string operationName, SyncMethodsGenerationMode syncWrappers)
            : base(serviceClient, operationName, syncWrappers)
        {
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == operationName)
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient, syncWrappers)));
            if (ExtensionName != Name)
            {
                ExtensionName = ExtensionName + "Operations";
            }
        }

        public override IEnumerable<string> Usings
        {
            get
            {
                if (MethodTemplateModels.Any(m =>
                    m.ParameterTemplateModels.Any(p => ((AzureParameterTemplateModel)p).IsODataFilterExpression)))
                {
                    yield return "Microsoft.Rest.Azure.OData";
                }
                yield return "Microsoft.Rest.Azure";
                if (this.ModelTypes.Any(m => !m.Extensions.ContainsKey(AzureExtensions.ExternalExtension)))
                {
                    yield return "Models";
                }
            }
        }
    }
}