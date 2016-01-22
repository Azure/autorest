// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Python.TemplateModels;
using Microsoft.Rest.Generator.Python;

namespace Microsoft.Rest.Generator.Azure.Python
{
    public class AzureMethodGroupTemplateModel : MethodGroupTemplateModel
    {
        public AzureMethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName) 
            : base(serviceClient, methodGroupName)
        {
            MethodGroupType = methodGroupName + "Operations";
            // Clear base initialized MethodTemplateModels and re-populate with
            // AzureMethodTemplateModel
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == methodGroupName)
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient)));
        }

        public override bool HasAnyModel
        {
            get
            {
                bool result = false;
                foreach (var model in this.ModelTypes)
                {
                    if (!model.Extensions.ContainsKey(AzureExtensions.ExternalExtension) || !(bool)model.Extensions[AzureExtensions.ExternalExtension])
                    {
                        result = true;
                        break;
                    }
                }

                return result;
            }
        }

        public bool HasAnyCloudErrors
        {
            get
            {
                return this.MethodTemplateModels.Any(item => item.DefaultResponse.Body == null || item.DefaultResponse.Body.Name == "CloudError");
            }
        }

        public bool HasAnyLongRunOperation
        {
            get { return MethodTemplateModels.Any(m => m.Extensions.ContainsKey(AzureExtensions.LongRunningExtension)); }
        }
    }
}