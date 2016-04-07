// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Azure;

namespace Microsoft.Rest.Generator.Java.Azure
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
                if (this.Extensions.ContainsKey(Microsoft.Rest.Generator.Extensions.NameOverrideExtension))
                {
                    var ext = this.Extensions[Microsoft.Rest.Generator.Extensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
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

        public override string ModelsPackage
        {
            get
            {
                return "models.implementation.api";
            }
        }
    }
}