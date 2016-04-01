// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java
{
    public class ServiceClientTemplateModel : ServiceClient
    {
        public ServiceClientTemplateModel(ServiceClient serviceClient)
        {
            this.LoadFrom(serviceClient);
            MethodTemplateModels = new List<MethodTemplateModel>();
            ModelTemplateModels = new List<ModelTemplateModel>();
            Methods.Where(m => m.Group == null)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient)));

            ModelTypes.ForEach(m => ModelTemplateModels.Add(new ModelTemplateModel(m, serviceClient)));
            this.IsCustomBaseUri = serviceClient.Extensions.ContainsKey(Microsoft.Rest.Generator.Extensions.ParameterizedHostExtension);
        }

        public bool IsCustomBaseUri { get; private set; }

        public List<MethodTemplateModel> MethodTemplateModels { get; private set; }

        public List<ModelTemplateModel> ModelTemplateModels { get; private set; }

        public virtual IEnumerable<MethodGroupTemplateModel> MethodGroupModels
        {
            get
            {
                return MethodGroups.Select(mg => new MethodGroupTemplateModel(this, mg));
            }
        }

        public virtual IEnumerable<MethodGroupTemplateModel> Operations
        {
            get
            {
                return MethodGroups.Select(mg => new MethodGroupTemplateModel(this, mg));
            }
        }

        public string ServiceClientServiceType
        {
            get
            {
                return JavaCodeNamer.GetServiceName(Name.ToPascalCase());
            }
        }

        public virtual IEnumerable<string> ImplImports
        {
            get
            {
                HashSet<string> classes = new HashSet<string>();
                classes.Add(Namespace.ToLower(CultureInfo.InvariantCulture) + "." + this.Name);
                foreach(var methodGroup in this.MethodGroupModels)
                {
                    classes.Add(methodGroup.MethodGroupFullType);
                }
                if (this.Properties.Any(p => p.Type.IsPrimaryType(KnownPrimaryType.Credentials)))
                {
                    classes.Add("com.microsoft.rest.credentials.ServiceClientCredentials");
                }
                classes.AddRange(new[]{
                        "com.microsoft.rest.ServiceClient",
                        "com.microsoft.rest.AutoRestBaseUrl",
                        "okhttp3.OkHttpClient",
                        "retrofit2.Retrofit" 
                    });
                
                if (this.MethodTemplateModels.IsNullOrEmpty())
                {
                    return classes;
                }

                // The following are for client level methods
                classes.Add("okhttp3.logging.HttpLoggingInterceptor.Level");

                classes.AddRange(this.MethodTemplateModels
                    .SelectMany(m => m.ImplImports)
                    .OrderBy(i => i));

                return classes.AsEnumerable();
            }
        }

        public virtual List<string> InterfaceImports
        {
            get
            {
                HashSet<string> classes = new HashSet<string>();
                classes.Add("java.util.List");
                classes.Add("okhttp3.Interceptor");
                classes.Add("okhttp3.logging.HttpLoggingInterceptor.Level");
                classes.Add("com.microsoft.rest.AutoRestBaseUrl");
                classes.Add("com.microsoft.rest.serializer.JacksonMapperAdapter");
                if (this.Properties.Any(p => p.Type.IsPrimaryType(KnownPrimaryType.Credentials)))
                {
                    classes.Add("com.microsoft.rest.credentials.ServiceClientCredentials");
                }

                if (this.MethodTemplateModels.IsNullOrEmpty())
                {
                    return classes.ToList();
                }

                classes.AddRange(this.MethodTemplateModels
                    .SelectMany(m => m.InterfaceImports)
                    .OrderBy(i => i).Distinct());

                return classes.ToList();
            }
        }
    }
}