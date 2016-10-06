// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.Azure.Model;
using AutoRest.CSharp.Model;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using Newtonsoft.Json.Linq;
using static AutoRest.Core.Utilities.DependencyInjection;
using MethodGroup = AutoRest.Core.Model.MethodGroup;

namespace AutoRest.CSharp.Azure
{
    public class AzureCSharpModelTransformer : CSharpModelTransformer
    {
        internal AzureCSharpCodeGenerator AzureCodeGenerator { get; set; }
        protected override CodeNamer NewCodeNamer => new CSharpCodeNamer();

        protected override Context InitializeContext()
        {
            // our instance of the codeNamer.
            var codeNamer = NewCodeNamer;

            return new Context
            {
                // inherit anything from the parent class.
                // base.InitializeContext(),

                // on activation of this context, 
                () =>
                {
                    // set the singleton for the code namer.
                    Singleton<CodeNamer>.Instance = codeNamer;

                    // and the c# specific settings
                    Singleton<ICSharpGeneratorSettings>.Instance = AzureCodeGenerator;
                },

                // add/override our own implementations 
                new Factory<CodeModel> {() => new CodeModelCsa(AzureCodeGenerator.InternalConstructors)},
                new Factory<Method, MethodCsa>(),
                new Factory<MethodCs, MethodCsa>(),
                new Factory<CompositeType, CompositeTypeCsa>(),
                new Factory<ILiteralType> {(string name) => new CompositeTypeCsa {Name = {FixedValue = name}}},
                new Factory<Parameter, ParameterCsa>(),
                new Factory<MethodGroup, MethodGroupCsa>(),
                new Factory<PrimaryType, PrimaryTypeCsa>(),
                new Factory<EnumType, EnumTypeCs>(),
                new Factory<Property, PropertyCs>(),
                new Factory<DictionaryType, DictionaryTypeCs>(),
                new Factory<SequenceType, SequenceTypeCs>()
            };
        }

        protected override CodeModel Transform(CodeModel cm)
        {
            var codeModel = cm as CodeModelCsa;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a Azure c# CodeModel");
            }

            // we're guaranteed to be in our language-specific context here.
            Settings.Instance.AddCredentials = true;

            // add the Credentials
            // PopulateAdditionalProperties(codeModel);

            // todo: these should be turned into individual transformers
            // SwaggerExtensions.NormalizeClientModel(codeModel);

            // Do parameter transformations
            TransformParameters(codeModel);

            // todo: these should be turned into individual transformers
            AzureExtensions.NormalizeAzureClientModel(codeModel);

            NormalizePaginatedMethods(codeModel);
            NormalizeODataMethods(codeModel);

            foreach (var model in codeModel.ModelTypes)
            {
                if (model.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) &&
                    (bool)model.Extensions[AzureExtensions.AzureResourceExtension])
                {
                    model.BaseModelType = New<ILiteralType>("Microsoft.Rest.Azure.IResource",
                        new { SerializedName = "Microsoft.Rest.Azure.IResource" }) as CompositeType;
                }
            }

            return codeModel;
        }

        public virtual void NormalizeODataMethods(CodeModel client)
        {
            if (client == null)
            {
                throw new ArgumentNullException("client");
            }

            foreach (var method in client.Methods)
            {
                if (method.Extensions.ContainsKey(AzureExtensions.ODataExtension))
                {
                    var odataFilter = method.Parameters.FirstOrDefault(p =>
                        p.SerializedName.EqualsIgnoreCase("$filter") &&
                        (p.Location == ParameterLocation.Query) &&
                        p.ModelType is CompositeType);

                    if (odataFilter == null)
                    {
                        continue;
                    }

                    // Remove all odata parameters
                    method.Remove(source =>
                        (source.SerializedName.EqualsIgnoreCase("$filter") ||
                         source.SerializedName.EqualsIgnoreCase("$top") ||
                         source.SerializedName.EqualsIgnoreCase("$orderby") ||
                         source.SerializedName.EqualsIgnoreCase("$skip") ||
                         source.SerializedName.EqualsIgnoreCase("$expand"))
                        && (source.Location == ParameterLocation.Query));

                    var odataQuery = New<Parameter>(new
                    {
                        SerializedName = "$filter",
                        Name = "odataQuery",
                        // ModelType = New<CompositeType>($"Microsoft.Rest.Azure.OData.ODataQuery<{odataFilter.ModelType.Name}>"),
                        // ModelType = New<CompositeType>(new { Name = new Fixable<string>(){FixedValue = $"Microsoft.Rest.Azure.OData.ODataQuery<{odataFilter.ModelType.Name}>"} } ),
                        ModelType =
                        New<ILiteralType>($"Microsoft.Rest.Azure.OData.ODataQuery<{odataFilter.ModelType.Name}>"),
                        Documentation = "OData parameters to apply to the operation.",
                        Location = ParameterLocation.Query,
                        odataFilter.IsRequired
                    });
                    odataQuery.Extensions[AzureExtensions.ODataExtension] =
                        method.Extensions[AzureExtensions.ODataExtension];
                    method.Insert(odataQuery);
                }
            }
        }

        /// <summary>
        ///     Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <param name="pageClasses"></param>
        public virtual void NormalizePaginatedMethods(CodeModelCsa codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException($"serviceClient");
            }

            var convertedTypes = new Dictionary<IModelType, CompositeType>();

            foreach (
                var method in
                codeModel.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            {
                string nextLinkString;
                var pageClassName = GetPagingSetting(method.Extensions, codeModel.pageClasses, out nextLinkString);
                if (string.IsNullOrEmpty(pageClassName))
                {
                    continue;
                }
                var pageTypeFormat = "{0}<{1}>";
                var ipageTypeFormat = "Microsoft.Rest.Azure.IPage<{0}>";
                if (string.IsNullOrWhiteSpace(nextLinkString))
                {
                    ipageTypeFormat = "System.Collections.Generic.IEnumerable<{0}>";
                }

                foreach (var responseStatus in method.Responses
                    .Where(r => r.Value.Body is CompositeType).Select(s => s.Key).ToArray())
                {
                    var compositType = (CompositeType)method.Responses[responseStatus].Body;
                    var sequenceType =
                        compositType.Properties.Select(p => p.ModelType).FirstOrDefault(t => t is SequenceType) as
                            SequenceType;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        var pagableTypeName = string.Format(CultureInfo.InvariantCulture, pageTypeFormat, pageClassName,
                            sequenceType.ElementType.Name);
                        var ipagableTypeName = string.Format(CultureInfo.InvariantCulture, ipageTypeFormat,
                            sequenceType.ElementType.Name);

                        var pagedResult = New<ILiteralType>(pagableTypeName) as CompositeType;

                        pagedResult.Extensions[AzureExtensions.ExternalExtension] = true;
                        pagedResult.Extensions[AzureExtensions.PageableExtension] = ipagableTypeName;

                        convertedTypes[method.Responses[responseStatus].Body] = pagedResult;
                        method.Responses[responseStatus] = new Response(pagedResult,
                            method.Responses[responseStatus].Headers);
                    }
                }

                if (convertedTypes.ContainsKey(method.ReturnType.Body))
                {
                    method.ReturnType = new Response(convertedTypes[method.ReturnType.Body],
                        method.ReturnType.Headers);
                }
            }

            SwaggerExtensions.RemoveUnreferencedTypes(codeModel,
                new HashSet<string>(convertedTypes.Keys.Cast<CompositeType>().Select(t => t.Name.Value)));
        }

        private static string GetPagingSetting(Dictionary<string, object> extensions,
            IDictionary<KeyValuePair<string, string>, string> pageClasses, out string nextLinkName)
        {
            // default value
            nextLinkName = null;
            var ext = extensions[AzureExtensions.PageableExtension] as JContainer;
            if (ext == null)
            {
                return null;
            }

            nextLinkName = (string)ext["nextLinkName"];
            var itemName = (string)ext["itemName"] ?? "value";

            var keypair = new KeyValuePair<string, string>(nextLinkName, itemName);
            if (!pageClasses.ContainsKey(keypair))
            {
                var className = (string)ext["className"];
                if (string.IsNullOrEmpty(className))
                {
                    if (pageClasses.Count > 0)
                    {
                        className = string.Format(CultureInfo.InvariantCulture, "Page{0}", pageClasses.Count);
                    }
                    else
                    {
                        className = "Page";
                    }
                }
                pageClasses.Add(keypair, className);
            }

            return pageClasses[keypair];
        }
    }
}