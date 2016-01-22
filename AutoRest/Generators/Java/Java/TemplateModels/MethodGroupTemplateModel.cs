// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java
{
    public class MethodGroupTemplateModel : ServiceClient
    {
        public MethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName)
        {
            this.LoadFrom(serviceClient);
            MethodTemplateModels = new List<MethodTemplateModel>();
            // MethodGroup name and type are always the same but can be 
            // changed in derived classes
            MethodGroupName = methodGroupName;
            MethodGroupType = methodGroupName.ToPascalCase();
            if (MethodGroupType != null && !MethodGroupType.EndsWith("Operations", StringComparison.Ordinal))
            {
                MethodGroupType += "Operations";
            }
            Methods.Where(m => m.Group == MethodGroupName)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient)));
        }
        public List<MethodTemplateModel> MethodTemplateModels { get; private set; }

        public string MethodGroupName { get; set; }

        public string MethodGroupType { get; set; }

        public string MethodGroupServiceType
        {
            get
            {
                return JavaCodeNamer.GetServiceName(MethodGroupName.ToPascalCase());
            }
        }

        public virtual IEnumerable<string> ImplImports
        {
            get
            {
                return this.MethodTemplateModels
                    .SelectMany(m => m.ImplImports)
                    .OrderBy(i => i).Distinct();
            }
        }

        public virtual IEnumerable<string> InterfaceImports
        {
            get
            {
                return this.MethodTemplateModels
                    .SelectMany(m => m.InterfaceImports)
                    .OrderBy(i => i).Distinct();
            }
        }
    }
}