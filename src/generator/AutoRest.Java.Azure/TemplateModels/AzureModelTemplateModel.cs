// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Extensions;
using AutoRest.Java.TemplateModels;

namespace AutoRest.Java.Azure.TemplateModels
{
    public class AzureModelTemplateModel : ModelTemplateModel
    {
        private AzureJavaCodeNamer _namer;

        public AzureModelTemplateModel(CompositeType source, ServiceClient serviceClient)
            : base(source, serviceClient)
        {
            _namer = new AzureJavaCodeNamer(serviceClient.Namespace);
        }

        protected override JavaCodeNamer Namer
        {
            get
            {
                return _namer;
            }
        }

        public override string ExceptionTypeDefinitionName
        {
            get
            {
                if (this.Extensions.ContainsKey(SwaggerExtensions.NameOverrideExtension))
                {
                    var ext = this.Extensions[SwaggerExtensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
                    if (ext != null && ext["name"] != null)
                    {
                        return ext["name"].ToString();
                    }
                }
                return this.Name + "Exception";
            }
        }

        public override IEnumerable<String> ImportList {
            get
            {
                var imports = base.ImportList.ToList();
                foreach (var property in this.Properties)
                {
                    if (property.Type.IsResource())
                    {
                        imports.Add("com.microsoft.azure." + property.Type.Name);
                    }
                }
                if (this.BaseModelType != null && (this.BaseModelType.Name == "Resource" || this.BaseModelType.Name == "SubResource"))
                {
                    imports.Add("com.microsoft.azure." + BaseModelType.Name);
                }
                return imports.Distinct();
            }
        }
    }
}