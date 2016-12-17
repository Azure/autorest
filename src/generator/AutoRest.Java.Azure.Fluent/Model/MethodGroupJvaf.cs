// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.Model;

namespace AutoRest.Java.Azure.Fluent.Model
{
    public class MethodGroupJvaf : MethodGroupJva
    {
        public MethodGroupJvaf()
        {
        }
        public MethodGroupJvaf(string name) : base(name)
        {
        }

        public override string MethodGroupDeclarationType => MethodGroupImplType;

        public override string ImplClassSuffix => "Inner";

        public override string ParentDeclaration => "";

        public override string ServiceClientType => CodeModel.Name + "Impl";

        public override string ImplPackage => "implementation";

        public override IEnumerable<string> ImplImports
        {
            get
            {
                var imports = new List<string>();
                var ns = CodeModel.Namespace.ToLower(CultureInfo.InvariantCulture);
                foreach (var i in base.ImplImports.ToList())
                {
                    if (i.StartsWith(ns + "." + ImplPackage, StringComparison.OrdinalIgnoreCase))
                    {
                        // Same package, do nothing
                    }
                    else if (i == ns + "." + this.TypeName)
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