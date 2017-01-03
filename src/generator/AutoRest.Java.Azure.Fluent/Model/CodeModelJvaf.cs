// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;
using Newtonsoft.Json;

namespace AutoRest.Java.Azure.Fluent.Model
{
    public class CodeModelJvaf : CodeModelJva
    {
        [JsonIgnore]
        public override string ImplPackage
        {
            get
            {
                return "implementation";
            }
        }

        [JsonIgnore]
        public override string ParentDeclaration
        {
            get
            {
                return " extends AzureServiceClient";
            }
        }

        [JsonIgnore]
        public override List<string> InterfaceImports
        {
            get
            {
                var imports = base.InterfaceImports;
                imports.Add("com.microsoft.azure.AzureClient");
                return imports.OrderBy(i => i).ToList();
            }
        }

        [JsonIgnore]
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
                    else if (Operations.Any(m => i.EndsWith(m.TypeName, StringComparison.OrdinalIgnoreCase)))
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