// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Collections.Generic;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.Python.TemplateModels;

namespace AutoRest.Python.Azure.TemplateModels
{
    public class AzureMethodGroupTemplateModel : MethodGroupTemplateModel
    {
        public AzureMethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName) 
            : base(serviceClient, methodGroupName)
        {
            // Clear base initialized MethodTemplateModels and re-populate with
            // AzureMethodTemplateModel
            MethodTemplateModels.Clear();

            var currentMethods = Methods.Where(m => m.Group == MethodGroupName && m.Extensions.ContainsKey(AzureExtensions.PageableExtension));
            var nextListMethods = new List<Method>();
            foreach (var method in currentMethods)
            {
                var pageableExtension = method.Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
                var operationName = (string)pageableExtension["operationName"];
                if (operationName != null)
                {
                    var nextLinkMethod = Methods.FirstOrDefault(m =>
                        operationName.Equals(m.SerializedName, StringComparison.OrdinalIgnoreCase));
                    if (nextLinkMethod != null)
                    {
                        method.Extensions["nextLinkURL"] = nextLinkMethod.Url;
                        method.Extensions["nextLinkParameters"] = nextLinkMethod.LogicalParameters;
                        nextListMethods.Add(nextLinkMethod);
                    }
                }
            }
            Methods.RemoveAll(m => nextListMethods.Contains(m));
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