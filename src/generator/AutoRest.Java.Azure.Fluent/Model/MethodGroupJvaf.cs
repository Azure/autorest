// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Java.Azure.Model;
using Newtonsoft.Json;

namespace AutoRest.Java.Azure.Fluent.Model
{
    public class MethodGroupJvaf : MethodGroupJva
    {
        private List<string> supportedInterfaces = new List<string>();
        private List<string> interfacesToImport = new List<string>();

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
                DiscoverAllSupportedInterfaces();

                if (supportedInterfaces.Count() > 0)
                {
                    return $" implements {string.Join(", ", supportedInterfaces)}";
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
                DiscoverAllSupportedInterfaces();
                var imports = new List<string>();
                var ns = CodeModel.Namespace.ToLowerInvariant();
                foreach (var interfaceToImport in interfacesToImport)
                {
                    imports.Add(interfaceToImport);
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
            var listMethod = this.Methods.FirstOrDefault(x => StringComparer.OrdinalIgnoreCase.Equals(x.Name, WellKnowMethodNames.List));
            var listByResourceGroup = this.Methods.FirstOrDefault(x => StringComparer.OrdinalIgnoreCase.Equals(x.Name, WellKnowMethodNames.ListByResourceGroup));
            return listMethod != null && listByResourceGroup != null
                && StringComparer.OrdinalIgnoreCase.Equals(
                    ((ResponseJva)listMethod.ReturnType).SequenceElementTypeString,
                    ((ResponseJva)listByResourceGroup.ReturnType).SequenceElementTypeString);
        }

        private void DiscoverAllSupportedInterfaces()
        {
            const string InnerSupportsGet = "InnerSupportsGet";
            const string InnerSupportsDelete = "InnerSupportsDelete";
            const string InnerSupportsListing = "InnerSupportsListing";

            // In case this method has already discovered the interfaces to be implemented, we don't need to do anything again.
            if (supportedInterfaces.Count() > 0)
            {
                return;
            }

            const string packageName = "com.microsoft.azure.management.resources.fluentcore.collection";
            var getMethod = this.Methods.FirstOrDefault(x => StringComparer.OrdinalIgnoreCase.Equals(x.Name, WellKnowMethodNames.GetByResourceGroup));
            if (getMethod != null && Take2RequiredParameters(getMethod))
            {
                supportedInterfaces.Add($"{InnerSupportsGet}<{((ResponseJva)getMethod.ReturnType).GenericBodyClientTypeString}>");
                interfacesToImport.Add($"{packageName}.{InnerSupportsGet}");
            }

            var deleteMethod = this.Methods.FirstOrDefault(x => StringComparer.OrdinalIgnoreCase.Equals(x.Name, WellKnowMethodNames.Delete));
            if (deleteMethod != null && Take2RequiredParameters(deleteMethod))
            {
                supportedInterfaces.Add($"{InnerSupportsDelete}<{((ResponseJva)deleteMethod.ReturnType).ClientCallbackTypeString}>");
                interfacesToImport.Add($"{packageName}.{InnerSupportsDelete}");
            }

            if (AnyMethodSupportsInnerListing())
            {
                // Getting list method to get the name of the type to be supported.
                var listMethod = this.Methods.FirstOrDefault(x => StringComparer.OrdinalIgnoreCase.Equals(x.Name, WellKnowMethodNames.List));

                supportedInterfaces.Add($"{InnerSupportsListing}<{((ResponseJva)listMethod.ReturnType).SequenceElementTypeString}>");
                interfacesToImport.Add($"{packageName}.{InnerSupportsListing}");
            }
        }

        private static bool Take2RequiredParameters(Method method)
        {
            // When parameters are optional we generate more methods.
            return method.Parameters.Count(x => !x.IsClientProperty && !x.IsConstant && x.IsRequired) == 2;
        }
    }
}