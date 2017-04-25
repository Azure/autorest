// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Go;
using AutoRest.Extensions;

namespace AutoRest.Go.Model
{
    public class MethodGroupGo : MethodGroup
    {
        public string ClientName { get; private set; }
        public string Documentation { get; private set; }
        public string PackageName { get; private set; }
        public string BaseClient { get; private set; }

        public bool IsCustomBaseUri
            => CodeModel.Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);

        public string GlobalParameters;
        public string HelperGlobalParameters;
        public string GlobalDefaultParameters;
        public string HelperGlobalDefaultParameters;
        public string ConstGlobalDefaultParameters;
        public IEnumerable<string> Imports { get; private set; }

        public MethodGroupGo(string name) : base(name)
        {
        }

        public MethodGroupGo()
        {
        }

        internal void Transform(CodeModelGo cmg)
        {
            var originalName = Name.Value;
            Name = Name.FixedValue.TrimPackageName(cmg.Namespace);
            if (Name != originalName)
            {
                // fix up the method group names
                cmg.Methods.Where(m => m.Group.Value == originalName)
                    .ForEach(m =>
                    {
                        m.Group = Name;
                    });
            }

            ClientName = string.IsNullOrEmpty(Name)
                            ? cmg.BaseClient
                            : TypeName.Value.IsNamePlural(cmg.Namespace)
                                             ? Name + "Client"
                                             : (Name + "Client").TrimPackageName(cmg.Namespace);

            Documentation = string.Format("{0} is the {1} ", ClientName,
                                    string.IsNullOrEmpty(cmg.Documentation)
                                        ? string.Format("client for the {0} methods of the {1} service.", TypeName, cmg.ServiceName)
                                        : cmg.Documentation.ToSentence());

            PackageName = cmg.Namespace;
            BaseClient = cmg.BaseClient;
            GlobalParameters = cmg.GlobalParameters;
            HelperGlobalParameters = cmg.HelperGlobalParameters;
            GlobalDefaultParameters = cmg.GlobalDefaultParameters;
            HelperGlobalDefaultParameters = cmg.HelperGlobalDefaultParameters;
            ConstGlobalDefaultParameters = cmg.ConstGlobalDefaultParameters;



            //Imports
            var imports = new HashSet<string>();
            imports.UnionWith(CodeNamerGo.Instance.AutorestImports);
            imports.UnionWith(CodeNamerGo.Instance.StandardImports);

            bool validationImports = false;
            cmg.Methods.Where(m => m.Group.Value == Name)
                .ForEach(m =>
                {
                    var mg = m as MethodGo;
                    mg.ParametersGo.ForEach(p => p.AddImports(imports));
                    if (mg.HasReturnValue() && !mg.ReturnValue().Body.PrimaryType(KnownPrimaryType.Stream))
                    {
                        mg.ReturnType.Body.AddImports(imports);
                    }
                    if (!string.IsNullOrEmpty(mg.ParameterValidations))
                        validationImports = true;
                });

            if (validationImports)
            {
                imports.UnionWith(CodeNamerGo.Instance.ValidationImport);
            }

            foreach (var p in cmg.Properties)
            {
                p.ModelType.AddImports(imports);
            }

            imports.OrderBy(i => i);
            Imports = imports;
        }
    }
}
