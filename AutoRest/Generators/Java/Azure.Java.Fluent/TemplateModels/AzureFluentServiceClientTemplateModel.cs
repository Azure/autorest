// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator.Java.Azure.Fluent
{
    public class AzureFluentServiceClientTemplateModel : AzureServiceClientTemplateModel
    {
        public AzureFluentServiceClientTemplateModel(ServiceClient serviceClient)
            : base(serviceClient)
        {
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == null)
                .ForEach(m => MethodTemplateModels.Add(new AzureFluentMethodTemplateModel(m, serviceClient)));
            ModelTemplateModels.Clear();
            ModelTypes.ForEach(m => ModelTemplateModels.Add(new AzureFluentModelTemplateModel(m, serviceClient)));
        }

        public override IEnumerable<MethodGroupTemplateModel> MethodGroupModels
        {
            get
            {
                return MethodGroups.Select(mg => new AzureFluentMethodGroupTemplateModel(this, mg));
            }
        }

        public override IEnumerable<MethodGroupTemplateModel> Operations
        {
            get
            {
                return MethodGroups.Select(mg => new AzureFluentMethodGroupTemplateModel(this, mg));
            }
        }

        public override string ImplPackage
        {
            get
            {
                return "implementation.api";
            }
        }

        public override string ParentDeclaration
        {
            get
            {
                return " extends AzureServiceClient";
            }
        }

        public override List<string> InterfaceImports
        {
            get
            {
                var imports = base.InterfaceImports;
                imports.Add("com.microsoft.azure.AzureClient");
                return imports.OrderBy(i => i).ToList();
            }
        }

        public override IEnumerable<string> ImplImports
        {
            get
            {
                var imports = new List<string>();
                var ns = Namespace.ToLower(CultureInfo.InvariantCulture);
                foreach (var i in base.ImplImports.ToList())
                {
                    if (i.StartsWith(ns, StringComparison.OrdinalIgnoreCase))
                    {
                        // same package, do nothing
                    }
                    else
                    {
                        imports.Add(i);
                    }
                }
                return imports.OrderBy(i => i).ToList();
            }
        }
    }
}