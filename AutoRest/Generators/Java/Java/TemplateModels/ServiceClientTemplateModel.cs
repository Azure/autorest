// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

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
                return JavaCodeNamer.GetServiceName(Name);
            }
        }

        public IEnumerable<string> ImplImports
        {
            get
            {
                HashSet<string> classes = new HashSet<string>();

                if (this.Properties.Any(p => p.Type != null &&
                                             p.Type.Name.Equals("ServiceClientCredentials", System.StringComparison.OrdinalIgnoreCase)))
                {
                    classes.Add("com.microsoft.rest.credentials.ServiceClientCredentials");
                }
                classes.AddRange(new[]{
                        "com.microsoft.rest.ServiceClient",
                        "com.squareup.okhttp.OkHttpClient",
                        "retrofit.RestAdapter" 
                    });
                
                if (this.MethodTemplateModels.IsNullOrEmpty())
                {
                    return classes;
                }

                classes.AddRange(new[]{
                    "com.google.gson.reflect.TypeToken",
                    "com.microsoft.rest.ServiceCallback",
                    "com.microsoft.rest.ServiceException",
                    "com.microsoft.rest.ServiceResponse",
                    "com.microsoft.rest.ServiceResponseBuilder",
                    "com.microsoft.rest.ServiceResponseCallback",
                    "retrofit.RetrofitError",
                    "retrofit.client.Response"
                });

                IList<IType> types = this.MethodTemplateModels
                    .SelectMany(mtm => mtm.Parameters.Select(p => p.Type))
                    .Concat(this.MethodTemplateModels.SelectMany(mtm => mtm.Responses.Select(res => res.Value)))
                    .Concat(this.MethodTemplateModels.Select(mtm => mtm.DefaultResponse))
                    .Distinct()
                    .ToList();

                classes.UnionWith(types.TypeImports(this.Namespace));


                return classes.AsEnumerable();
            }
        }

        public IEnumerable<string> InterfaceImports
        {
            get
            {
                HashSet<string> classes = new HashSet<string>();

                if (this.Properties.Any(p => p.Type != null &&
                                             p.Type.Name.Equals("ServiceClientCredentials", System.StringComparison.OrdinalIgnoreCase)))
                {
                    classes.Add("com.microsoft.rest.credentials.ServiceClientCredentials");
                }

                if (this.MethodTemplateModels.IsNullOrEmpty())
                {
                    return classes;
                }

                classes.AddRange(new[]{
                    "com.microsoft.rest.ServiceCallback",
                    "com.microsoft.rest.ServiceException",
                    "com.microsoft.rest.ServiceResponseCallback",
                    "retrofit.client.Response"
                });

                IList<IType> types = this.MethodTemplateModels
                    .SelectMany(mtm => mtm.Parameters.Select(p => p.Type))
                    .Concat(this.MethodTemplateModels.Select(mtm => mtm.ReturnType))
                    .Distinct()
                    .ToList();
                classes.UnionWith(types.TypeImports(this.Namespace));

                foreach (var method in this.MethodTemplateModels)
                {
                    classes.Add("retrofit.http." + method.HttpMethod.ToString().ToUpper(CultureInfo.InvariantCulture));
                    foreach (var param in method.Parameters)
                    {
                        if (param.Location != ParameterLocation.None &&
                            param.Location != ParameterLocation.FormData)
                            classes.Add("retrofit.http." + param.Location.ToString());
                    }
                }

                return classes.AsEnumerable();
            }
        }
    }
}