// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
{
    public class ServiceClientTemplateModel : ServiceClient
    {
        public ServiceClientTemplateModel(ServiceClient serviceClient)
        {
            this.LoadFrom(serviceClient);
            HasModelTypes = serviceClient.HasModelTypes();
            MethodTemplateModels = new List<MethodTemplateModel>();
            Methods.Where(m => m.Group == null)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient)));
        }

        public bool HasModelTypes { get; private set; }

        public List<MethodTemplateModel> MethodTemplateModels { get; set; }

        public virtual string BaseType
        {
            get
            {
                return "ClientRuntime::ServiceClient";
            }
        }

        public virtual string BaseClassParams
        {
            get { return ""; }
        }

        public string RequiredContructorParametersWithSeparator
        {
            get
            {
                List<string> requireParams = new List<string>();

                this.Properties.Where(p => p.IsRequired)
                    .ForEach(p => requireParams.Add(string.Format("{0}", p.Name)));

                return requireParams.Any() ? ", " + string.Join(", ", requireParams) : string.Empty;
            }
        }
    }
}