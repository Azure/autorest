// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.TemplateModels;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure.TemplateModels
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
                yield return "Microsoft.Rest.Azure";
                if (this.ModelTypes.Any(m => !m.Extensions.ContainsKey(AzureExtensions.ExternalExtension)))
                {
                    yield return this.ModelsName;
                }
            }
        }
    }
}