// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.NodeJS.TemplateModels;

namespace AutoRest.NodeJS.Azure.TemplateModels
{
    public class AzureServiceClientTemplateModel : ServiceClientTemplateModel
    {
        public AzureServiceClientTemplateModel(ServiceClient serviceClient)
            : base(serviceClient)
        {
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == null)
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient)));
            // Removing all models that contain the extension "x-ms-external", as they will be 
            // generated in nodejs client runtime for azure - "ms-rest-azure".
            ModelTemplateModels.RemoveAll(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension));
            ModelTemplateModels.RemoveAll(m => m.Extensions.ContainsKey(AzureExtensions.ExternalExtension));
            PageTemplateModels = new List<PageTemplateModel>();
        }

        public IList<PageTemplateModel> PageTemplateModels { get; set; }
        public override IEnumerable<MethodGroupTemplateModel> MethodGroupModels
        {
            get
            {
                return MethodGroups.Select(mg => new AzureMethodGroupTemplateModel(this, mg));
            }
        }
    }
}