// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Java.TemplateModels;
using System.Globalization;

namespace AutoRest.Java.Azure.TemplateModels
{
    public class AzureServiceClientTemplateModel : ServiceClientTemplateModel
    {
        public const string ExternalExtension = "x-ms-external";

        public AzureServiceClientTemplateModel(ServiceClient serviceClient)
            : base(serviceClient)
        {
            Properties.Remove(Properties.Find(p => p.Type.Name == "ServiceClientCredentials"));
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

        public virtual string ParentDeclaration
        {
            get
            {
                return " extends AzureServiceClient implements " + Name;
            }
        }

        public override List<string> InterfaceImports
        {
            get
            {
                var imports = base.InterfaceImports;
                imports.Add("com.microsoft.azure.AzureClient");
                imports.Add("com.microsoft.azure.RestClient");
                return imports.OrderBy(i => i).ToList();
            }
        }

        public override IEnumerable<string> ImplImports
        {
            get
            {
                var imports = base.ImplImports.ToList();
                imports.Add("com.microsoft.azure.AzureClient");
                imports.Add("com.microsoft.azure.RestClient");
                imports.Add("com.microsoft.rest.credentials.ServiceClientCredentials");
                imports.Remove("com.microsoft.rest.ServiceClient");
                imports.Remove("okhttp3.OkHttpClient");
                imports.Remove("retrofit2.Retrofit");
                imports.Add("com.microsoft.azure.AzureServiceClient");
                return imports.OrderBy(i => i).ToList();
            }
        }

        public string SetDefaultHeaders
        {
            get
            {
                return "";
            }
        }
    }
}