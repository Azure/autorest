// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java.Azure
{
    public class AzureModelTemplateModel : ModelTemplateModel
    {
        public AzureModelTemplateModel(CompositeType source, ServiceClient serviceClient)
            : base(source, serviceClient)
        {
        }

        public override IEnumerable<String> ImportList {
            get
            {
                var imports = base.ImportList.ToList();
                if (this.BaseModelType != null && 
                    this.BaseModelType.Name == "BaseResource")
                {
                    imports.Add("com.microsoft.azure.BaseResource");
                }
                return imports;
            }
        }
    }
}