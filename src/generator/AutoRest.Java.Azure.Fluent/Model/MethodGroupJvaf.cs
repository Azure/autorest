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
            //TypeName.OnGet += nam => nam.IsNullOrEmpty() ? nam : nam + "Inner";
        }
        public MethodGroupJvaf(string name) : base(name)
        {
            //TypeName.OnGet += nam => nam.IsNullOrEmpty() ? nam : nam + "Inner";
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
                return CodeModel.Name + "Impl";
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