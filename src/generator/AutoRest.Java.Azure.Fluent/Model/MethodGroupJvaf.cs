// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.Model;
using Newtonsoft.Json;

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

        [JsonIgnore]
        public override string MethodGroupDeclarationType => MethodGroupImplType;

        [JsonIgnore]
        public override string ImplClassSuffix => "Inner";

        [JsonIgnore]
        public override string ParentDeclaration
        {
            get
            {
                if (AnyMethodSupportsInnerListing())
                {
                    var listMethod = this.Methods.FirstOrDefault(x => StringComparer.OrdinalIgnoreCase.Equals(x.Name, "List"));

                    return $" implements InnerSupportsListing<{((ResponseJva)listMethod.ReturnType).SequenceElementTypeString}>";
                }
                return "";
            }
        }

        [JsonIgnore]
        public override string ServiceClientType => CodeModel.Name + "Impl";

        [JsonIgnore]
        public override string ImplPackage => "implementation";

        [JsonIgnore]
        public override IEnumerable<string> ImplImports
        {
            get
            {
                var imports = new List<string>();
                var ns = CodeModel.Namespace.ToLowerInvariant();
                if (AnyMethodSupportsInnerListing())
                {
                    imports.Add("com.microsoft.azure.management.resources.fluentcore.collection.InnerSupportsListing");
                }
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

        private bool AnyMethodSupportsInnerListing()
        {
            var listMethod = this.Methods.FirstOrDefault(x => StringComparer.OrdinalIgnoreCase.Equals(x.Name, "List"));
            var listByResourceGroup = this.Methods.FirstOrDefault(x => StringComparer.OrdinalIgnoreCase.Equals(x.Name, "ListByResourceGroup"));
            return listMethod != null && listByResourceGroup != null
                && StringComparer.OrdinalIgnoreCase.Equals(
                    ((ResponseJva)listMethod.ReturnType).SequenceElementTypeString,
                    ((ResponseJva)listByResourceGroup.ReturnType).SequenceElementTypeString);
        }
    }
}