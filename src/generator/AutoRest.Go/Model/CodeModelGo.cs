// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.Go.Model
{
    public class CodeModelGo : CodeModel
    {
        public CodeModelGo()
        {
            NextMethodUndefined = new List<IModelType>();
            PagedTypes = new Dictionary<IModelType, string>();
        }

        public string[] Version => CodeNamerGo.SDKVersionFromPackageVersion(
                                            !string.IsNullOrEmpty(Settings.Instance.PackageVersion)
                                                    ? Settings.Instance.PackageVersion
                                                    : "0.0.0");

        public override string Namespace
        {
            get
            {
                if (string.IsNullOrEmpty(base.Namespace))
                {
                    return base.Namespace;
                }

                return base.Namespace.ToLowerInvariant();
            }
            set
            {
                base.Namespace = value;
            }
        }

        public string ServiceName => CodeNamer.Instance.PascalCase(Namespace ?? string.Empty);

        public string GetDocumentation()
        {
            return $"Package {Namespace} implements the Azure ARM {ServiceName} service API version {ApiVersion}.\n\n{(Documentation??string.Empty).UnwrapAnchorTags()}";
        }

        public string BaseClient => "ManagementClient";

        public IEnumerable<string> ClientImports
        {
            get
            {
                var imports = new HashSet<string>();
                imports.UnionWith(CodeNamerGo.Instance.AutorestImports);
                var clientMg = MethodGroups.Where(mg => string.IsNullOrEmpty(mg.Name)).FirstOrDefault();
                if (clientMg != null)
                {
                    imports.UnionWith(clientMg.Imports);
                }
                return imports.OrderBy(i => i);
            }
        }

        public string ClientDocumentation => string.Format("{0} is the base client for {1}.", BaseClient, ServiceName);

        public Dictionary<IModelType, string> PagedTypes { get; }

        // NextMethodUndefined is used to keep track of those models which are returned by paged methods,
        // but the next method is not defined in the service client, so these models need a preparer.
        public List<IModelType> NextMethodUndefined { get; }

        public IEnumerable<string> ModelImports
        {
            get
            {
                // Create an ordered union of the imports each model requires
                var imports = new HashSet<string>();
                if (ModelTypes != null && ModelTypes.Cast<CompositeTypeGo>().Any(mtm => mtm.IsResponseType))
                {
                    imports.Add("github.com/Azure/go-autorest/autorest");
                } 
                ModelTypes.Cast<CompositeTypeGo>()
                    .ForEach(mt =>
                    {
                        mt.AddImports(imports);
                        if (NextMethodUndefined.Any())
                        {
                            imports.UnionWith(CodeNamerGo.Instance.PageableImports);
                        }
                    });
                return imports.OrderBy(i => i);
            }
        }

        public virtual IEnumerable<MethodGroupGo> MethodGroups => Operations.Cast<MethodGroupGo>();

        public string GlobalParameters
        {
            get
            {
                var declarations = new List<string>();
                foreach (var p in Properties)
                {                    
                    if (!p.SerializedName.FixedValue.IsApiVersion())
                    {
                        declarations.Add(
                                string.Format(
                                        (p.IsRequired || p.ModelType.CanBeEmpty() ? "{0} {1}" : "{0} *{1}"), 
                                         p.Name.Value.ToSentence(), p.ModelType.Name));
                    }
                }
                return string.Join(", ", declarations);
            }
        }

        public string HelperGlobalParameters
        {
            get
            {
                var invocationParams = new List<string>();
                foreach (var p in Properties)
                {
                    if (!p.SerializedName.Value.IsApiVersion())
                    {
                        invocationParams.Add(p.Name.Value.ToSentence());
                    }
                }
                return string.Join(", ", invocationParams);
            }
        }

        public IEnumerable<MethodGo> ClientMethods
        {
            get
            {
                // client methods are the ones with no method group
                return Methods.Cast<MethodGo>().Where(m => string.IsNullOrEmpty(m.MethodGroup.Name));
            }
        }
    }
}
