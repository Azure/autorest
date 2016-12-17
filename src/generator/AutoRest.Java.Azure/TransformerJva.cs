// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Newtonsoft.Json.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Java.Azure
{
    public class TransformerJva : TransformerJv, ITransformer<CodeModelJva>
    {
        /// <summary>
        /// A type-specific method for code model tranformation.
        /// Note: This is the method you want to override.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <returns></returns>
        public override CodeModelJv TransformCodeModel(CodeModel cm)
        {
            var codeModel = cm as CodeModelJva;

            // we're guaranteed to be in our language-specific context here.
            Settings.Instance.AddCredentials = true;

            // This extension from general extensions must be run prior to Azure specific extensions.
            AzureExtensions.ProcessParameterizedHost(codeModel);
            AzureExtensions.ProcessClientRequestIdExtension(codeModel);
            AzureExtensions.UpdateHeadMethods(codeModel);
            AzureExtensions.ProcessGlobalParameters(codeModel);
            AzureExtensions.FlattenModels(codeModel);
            AzureExtensions.FlattenMethodParameters(codeModel);
            ParameterGroupExtensionHelper.AddParameterGroups(codeModel);
            AddLongRunningOperations(codeModel);
            AzureExtensions.AddAzureProperties(codeModel);
            AzureExtensions.SetDefaultResponses(codeModel);



            // set Parent on responses (required for pageable)
            foreach (MethodJva method in codeModel.Methods)
            {
                foreach (ResponseJva response in method.Responses.Values)
                {
                    response.Parent = method;
                }
                (method.DefaultResponse as ResponseJva).Parent = method;
                method.ReturnTypeJva.Parent = method;
            }
            AzureExtensions.AddPageableMethod(codeModel);
            
            // pluralize method groups
            foreach (var mg in codeModel.Operations)
            {
                mg.Name.OnGet += name => name.IsNullOrEmpty() || name.EndsWith("s", StringComparison.OrdinalIgnoreCase) ? name : $"{name}s";
            }
            
            NormalizePaginatedMethods(codeModel, codeModel.pageClasses);

            // param order (PATH first)
            foreach (MethodJva method in codeModel.Methods)
            {
                var ps = method.Parameters.ToList();
                method.ClearParameters();
                foreach (var p in ps.Where(x => x.Location == ParameterLocation.Path))
                {
                    method.Add(p);
                }
                foreach (var p in ps.Where(x => x.Location != ParameterLocation.Path))
                {
                    method.Add(p);
                }
            }

            return codeModel;
        }

        public static void AddLongRunningOperations(CodeModel codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            foreach (var operation in codeModel.Operations)
            {
                var methods = operation.Methods.ToArray();
                operation.ClearMethods();
                foreach (var method in methods)
                {
                    operation.Add(method);
                    if (true == method.Extensions.Get<bool>(AzureExtensions.LongRunningExtension))
                    {
                        // copy the method 
                        var m = Duplicate(method);

                        // change the name, remove the extension.
                        m.Name = "Begin" + m.Name.ToPascalCase();
                        m.Extensions.Remove(AzureExtensions.LongRunningExtension);

                        operation.Add(m);
                    }
                }
            }
        }
        

        CodeModelJva ITransformer<CodeModelJva>.TransformCodeModel(CodeModel codeModel)
        {
            return this.TransformCodeModel(codeModel) as CodeModelJva;
        }

        /// <summary>
        /// Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="pageClasses"></param>
        public void NormalizePaginatedMethods(CodeModel serviceClient, IDictionary<KeyValuePair<string, string>, string> pageClasses)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            var convertedTypes = new Dictionary<IModelType, IModelType>();

            foreach (MethodJva method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            {
                string nextLinkString;
                string pageClassName = GetPagingSetting(method.Extensions, pageClasses, out nextLinkString);
                if (string.IsNullOrEmpty(pageClassName))
                {
                    continue;
                }
                if (string.IsNullOrEmpty(nextLinkString))
                {
                    method.Extensions[AzureExtensions.PageableExtension] = null;
                }

                foreach (var responseStatus in method.Responses.Where(r => r.Value.Body is CompositeTypeJva).Select(s => s.Key).ToArray())
                {
                    var compositType = (CompositeTypeJva)method.Responses[responseStatus].Body;
                    var sequenceType = compositType.Properties.Select(p => p.ModelType).FirstOrDefault(t => t is SequenceTypeJva) as SequenceTypeJva;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        IModelType pagedResult;
                        pagedResult = new SequenceTypeJva
                        {
                            ElementType = sequenceType.ElementType,
                            PageImplType = pageClassName
                        };

                        convertedTypes[method.Responses[responseStatus].Body] = pagedResult;
                        var resp = New<Response>(pagedResult, method.Responses[responseStatus].Headers) as ResponseJva;
                        resp.Parent = method;
                        method.Responses[responseStatus] = resp;
                    }
                }

                if (convertedTypes.ContainsKey(method.ReturnType.Body))
                {
                    var resp = New<Response>(convertedTypes[method.ReturnType.Body], method.ReturnType.Headers) as ResponseJva;
                    resp.Parent = method;
                    method.ReturnType = resp;
                }
            }

            SwaggerExtensions.RemoveUnreferencedTypes(serviceClient, new HashSet<string>(convertedTypes.Keys.Cast<CompositeTypeJva>().Select(t => t.Name.ToString())));
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
                        ModelType = New<CompositeType>($"Microsoft.Rest.Azure.OData.ODataQuery<{odataFilter.ModelType.Name}>"),
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
                        className = string.Format(CultureInfo.InvariantCulture, "PageImpl{0}", pageClasses.Count);
                    }
                    else
                    {
                        className = "PageImpl";
                    }
                }
                pageClasses.Add(keypair, className);
            }

            return pageClasses[keypair];
        }
    }
}
