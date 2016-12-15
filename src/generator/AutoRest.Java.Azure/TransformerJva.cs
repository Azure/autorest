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
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using Newtonsoft.Json.Linq;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Java.Azure
{
    public class TransformerJva : TransformerJv, ITransformer<CodeModelJva> // TODO: ADJUST
    {
        /// <summary>
        /// A type-specific method for code model tranformation.
        /// Note: This is the method you want to override.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <returns></returns>
        public override CodeModelJv TransformCodeModel(CodeModel codeModel)
        {
            return ((ITransformer<CodeModelJv>)this).TransformCodeModel(codeModel);
        }

        CodeModelJva ITransformer<CodeModelJva>.TransformCodeModel(CodeModel cs)
        {
            var codeModel = cs as CodeModelJva;

            // we're guaranteed to be in our language-specific context here.
            Settings.Instance.AddCredentials = true;

            PopulateAdditionalProperties(codeModel);

            // This extension from general extensions must be run prior to Azure specific extensions.
            AzureExtensions.ProcessParameterizedHost(codeModel);
            AzureExtensions.ProcessClientRequestIdExtension(codeModel);
            AzureExtensions.UpdateHeadMethods(codeModel);
            AzureExtensions.ProcessGlobalParameters(codeModel);
            AzureExtensions.FlattenModels(codeModel);
            AzureExtensions.FlattenMethodParameters(codeModel);
            ParameterGroupExtensionHelper.AddParameterGroups(codeModel);
            AzureExtensions.AddLongRunningOperations(codeModel);
            AzureExtensions.AddAzureProperties(codeModel);
            AzureExtensions.SetDefaultResponses(codeModel);
            AzureExtensions.AddPageableMethod(codeModel);
            
            // TODO: ask the cowboy - some parts rely on singular, later parts on plural!
            // pluralize method groups
            foreach (var mg in codeModel.Operations)
            {
                mg.Name.OnGet += name => name.IsNullOrEmpty() || name.EndsWith("s", StringComparison.OrdinalIgnoreCase) ? name : $"{name}s";
            }

            //CodeNamerJva.Instance.NormalizeClientModel(codeModel);
            //CodeNamerJva.Instance.ResolveNameCollisions(codeModel, Settings.Namespace,
            //    Settings.Namespace + ".Models");
            //CodeNamerJva.Instance.NormalizePaginatedMethods(codeModel, pageClasses);

            //// Do parameter transformations
            //TransformParameters(codeModel);

            //// todo: these should be turned into individual transformers
            //AzureExtensions.NormalizeAzureClientModel(codeModel);

            //NormalizePaginatedMethods(codeModel);
            //NormalizeODataMethods(codeModel);

            //foreach (var model in codeModel.ModelTypes)
            //{
            //    if (model.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) &&
            //        (bool)model.Extensions[AzureExtensions.AzureResourceExtension])
            //    {
            //        model.BaseModelType = New<ILiteralType>("Microsoft.Rest.Azure.IResource",
            //            new { SerializedName = "Microsoft.Rest.Azure.IResource" }) as CompositeType;
            //    }
            //}

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
        public virtual void NormalizePaginatedMethods(CodeModelJva codeModel)
        {
            //if (codeModel == null)
            //{
            //    throw new ArgumentNullException($"serviceClient");
            //}

            //var convertedTypes = new Dictionary<IModelType, CompositeType>();

            //foreach (
            //    var method in
            //    codeModel.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            //{
            //    string nextLinkString;
            //    var pageClassName = GetPagingSetting(method.Extensions, codeModel.pageClasses, out nextLinkString);
            //    if (string.IsNullOrEmpty(pageClassName))
            //    {
            //        continue;
            //    }
            //    var pageTypeFormat = "{0}<{1}>";
            //    var ipageTypeFormat = "Microsoft.Rest.Azure.IPage<{0}>";
            //    if (string.IsNullOrWhiteSpace(nextLinkString))
            //    {
            //        ipageTypeFormat = "System.Collections.Generic.IEnumerable<{0}>";
            //    }

            //    foreach (var responseStatus in method.Responses
            //        .Where(r => r.Value.Body is CompositeType).Select(s => s.Key).ToArray())
            //    {
            //        var compositType = (CompositeType)method.Responses[responseStatus].Body;
            //        var sequenceType =
            //            compositType.Properties.Select(p => p.ModelType).FirstOrDefault(t => t is SequenceType) as
            //                SequenceTypeJva;

            //        // if the type is a wrapper over page-able response
            //        if (sequenceType != null)
            //        {
            //            var pagableTypeName = string.Format(CultureInfo.InvariantCulture, pageTypeFormat, pageClassName,
            //                sequenceType.ElementType.AsNullableType(!sequenceType.ElementType.IsValueType() || (sequenceType.IsXNullable ?? true)));
            //            var ipagableTypeName = string.Format(CultureInfo.InvariantCulture, ipageTypeFormat,
            //                sequenceType.ElementType.AsNullableType(!sequenceType.ElementType.IsValueType() || (sequenceType.IsXNullable ?? true)));

            //            var pagedResult = New<ILiteralType>(pagableTypeName) as CompositeType;

            //            pagedResult.Extensions[AzureExtensions.ExternalExtension] = true;
            //            pagedResult.Extensions[AzureExtensions.PageableExtension] = ipagableTypeName;

            //            convertedTypes[method.Responses[responseStatus].Body] = pagedResult;
            //            method.Responses[responseStatus] = new Response(pagedResult,
            //                method.Responses[responseStatus].Headers);
            //        }
            //    }

            //    if (convertedTypes.ContainsKey(method.ReturnType.Body))
            //    {
            //        method.ReturnType = new Response(convertedTypes[method.ReturnType.Body],
            //            method.ReturnType.Headers);
            //    }
            //}

            //SwaggerExtensions.RemoveUnreferencedTypes(codeModel,
            //    new HashSet<string>(convertedTypes.Keys.Cast<CompositeType>().Select(t => t.Name.Value)));
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
