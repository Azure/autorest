// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Go.TemplateModels
{
    public class ServiceClientTemplateModel : ServiceClient
    {
        public readonly string BaseClient;
        public string ClientName { get; set; }
        public string ClientDocumentation { get; set; }
        public readonly string MethodGroupName;
        public readonly string PackageName;

        public readonly MethodScopeProvider MethodScope;
        public readonly List<MethodTemplateModel> MethodTemplateModels;

        public ServiceClientTemplateModel(ServiceClient serviceClient, string packageName, string methodGroupName = null)
        {
            this.LoadFrom(serviceClient);

            MethodGroupName = methodGroupName == null
                                ? string.Empty
                                : methodGroupName;
            PackageName = packageName == null
                            ? string.Empty
                            : packageName;

            BaseClient = "ManagementClient";
            ClientName = string.IsNullOrEmpty(MethodGroupName)
                            ? BaseClient
                            : MethodGroupName.IsNamePlural(PackageName)
                                             ? MethodGroupName + "Client"
                                             : (MethodGroupName + "Client").TrimPackageName(PackageName);
            MethodScope = new MethodScopeProvider();
            MethodTemplateModels = new List<MethodTemplateModel>();
            Methods.Where(m => m.BelongsToGroup(MethodGroupName, PackageName))
                .OrderBy(m => m.Name)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, ClientName, PackageName, new MethodScopeProvider(), m.NextMethodExists(Methods))));
                
            Documentation = string.Format("Package {0} implements the Azure ARM {1} service API version {2}.\n\n{3}", PackageName, ServiceName, ApiVersion,
                                    !string.IsNullOrEmpty(Documentation) ? Documentation.UnwrapAnchorTags() : "");
            ClientDocumentation = string.Format("{0} is the base client for {1}.", ClientName, ServiceName);
        }

        public string ServiceName
        {
            get
            {
                if (!string.IsNullOrEmpty(PackageName))
                {
                    return GoCodeNamer.PascalCase(PackageName);
                }
                return string.Empty;
            }
        }

        public string GlobalParameters
        {
            get
            {
                List<string> declarations = new List<string>();
                Properties
                    .ForEach(p =>
                    {
                        if (!p.SerializedName.IsApiVersion())
                        {
                            declarations.Add(
                                string.Format(
                                        (p.IsRequired || p.Type.CanBeEmpty() ? "{0} {1}" : "{0} *{1}"), 
                                         p.Name.ToSentence(), p.Type.Name));
                        }
                    });
                return string.Join(", ", declarations);
            }
        }

        public string HelperGlobalParameters
        {
            get
            {
                List<string> invocationParams = new List<string>();
                Properties
                    .ForEach(p =>
                    {
                        if (!p.SerializedName.IsApiVersion())
                        {
                            invocationParams.Add(p.Name.ToSentence());
                        }
                    });
                return string.Join(", ", invocationParams);
            }
        }

        public virtual IEnumerable<string> Imports
        {
            get
            {
                var imports = new HashSet<string>();
                imports.UnionWith(GoCodeNamer.AutorestImports);
                bool validationImports = false;
                if (MethodTemplateModels.Count() > 0)
                {
                    imports.UnionWith(GoCodeNamer.StandardImports);
                    MethodTemplateModels
                        .ForEach(mtm =>
                        {
                            mtm.Parameters.ForEach(p => p.AddImports(imports));
                            if (mtm.HasReturnValue() && !mtm.ReturnValue().Body.IsPrimaryType(KnownPrimaryType.Stream))
                            {
                                mtm.ReturnType.Body.AddImports(imports);
                            }
                            if (!string.IsNullOrEmpty(mtm.ParameterValidations))
                                validationImports = true;
                        });
                }

                if (validationImports)
                    imports.UnionWith(GoCodeNamer.ValidationImport);
                return imports.OrderBy(i => i);
            }
        }
    }
}