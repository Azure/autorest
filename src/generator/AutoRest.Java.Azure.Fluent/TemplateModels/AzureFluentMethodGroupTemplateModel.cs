// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.TemplateModels;

namespace AutoRest.Java.Azure.Fluent.TemplateModels
{
    public class AzureFluentMethodGroupTemplateModel : AzureMethodGroupTemplateModel
    {
        public AzureFluentMethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName)
            : base(serviceClient, methodGroupName)
        {
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == methodGroupName)
                .ForEach(m => MethodTemplateModels.Add(new AzureFluentMethodTemplateModel(m, serviceClient)));
        }

        public override string MethodGroupDeclarationType
        {
            get
            {
                return MethodGroupImplType;
            }
        }

        public override string ImplClassSuffix
        {
            get
            {
                return "Inner";
            }
        }

        public override string ParentDeclaration
        {
            get
            {
                return "";
            }
        }

        public override string ServiceClientType
        {
            get
            {
                return this.Name + "Impl";
            }
        }

        public override string ImplPackage
        {
            get
            {
                return "implementation";
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
                    else if (i == ns + "." + this.MethodGroupType)
                    {
                        // do nothing
                    }
                    else
                    {
                        imports.Add(i);
                    }
                }
                return imports;
            }
        }
    }
}