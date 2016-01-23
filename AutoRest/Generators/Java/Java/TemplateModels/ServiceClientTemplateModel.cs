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
        }

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

                if (this.Properties.Any(p => p.Type == PrimaryType.Credentials))
                {
                    classes.Add("com.microsoft.rest.credentials.ServiceClientCredentials");
                }
                classes.AddRange(new[]{
                        "com.microsoft.rest.ServiceClient",
                        "com.squareup.okhttp.OkHttpClient",
                        "retrofit.Retrofit" 
                    });
                
                if (this.MethodTemplateModels.IsNullOrEmpty())
                {
                    return classes;
                }

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
                classes.Add("com.squareup.okhttp.Interceptor");
                classes.Add("com.squareup.okhttp.logging.HttpLoggingInterceptor.Level");
                classes.Add("com.microsoft.rest.serializer.JacksonMapperAdapter");
                if (this.Properties.Any(p => p.Type == PrimaryType.Credentials))
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