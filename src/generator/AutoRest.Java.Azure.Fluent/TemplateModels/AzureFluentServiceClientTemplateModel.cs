// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.TemplateModels;
using AutoRest.Java.TemplateModels;

namespace AutoRest.Java.Azure.Fluent.TemplateModels
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
                return "implementation";
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
                    if (i.StartsWith(ns + "." + ImplPackage, StringComparison.OrdinalIgnoreCase))
                    {
                        // Same package, do nothing
                    }
                    else if (MethodGroupModels.Any(m => i.EndsWith(m.MethodGroupType, StringComparison.OrdinalIgnoreCase)))
                    {
                        // do nothing
                    }
                    else if (i.EndsWith(this.Name, StringComparison.OrdinalIgnoreCase))
                    {
                        // do nothing
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