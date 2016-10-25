// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.Extensions.Azure.Model;
using AutoRest.Ruby.Azure.Model;
using AutoRest.Ruby.Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Ruby.Azure
{
    public class TransformerRba : TransformerRb, ITransformer<CodeModelRba>
    {
        /// <summary>
        ///     A type-specific method for code model tranformation.
        ///     Note: This is the method you want to override.
        /// </summary>
        /// <param name="codeModel"></param>
        /// <returns></returns>
        public override CodeModelRb TransformCodeModel(CodeModel codeModel)
        {
            return ((ITransformer<CodeModelRba>) this).TransformCodeModel(codeModel);
        }

        CodeModelRba ITransformer<CodeModelRba>.TransformCodeModel(CodeModel cs)
        {
            var codeModel = cs as CodeModelRba;

            PopulateAdditionalProperties(codeModel);

            Singleton<Settings>.Instance.AddCredentials = true;
            AzureExtensions.NormalizeAzureClientModel(codeModel);
            CorrectFilterParameters(codeModel);
            AddRubyPageableMethod(codeModel);
            ApplyPagination(codeModel);

            return codeModel;
        }

        /// <summary>
        ///     Adds method to use for autopagination.
        /// </summary>
        /// <param name="serviceClient">The service client.</param>
        private void AddRubyPageableMethod(CodeModelRba serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException(nameof(serviceClient));
            }

            //for (var i = 0; i < serviceClient.Methods.Count; i++)
            foreach (var method in serviceClient.Methods.ToArray())
            {
                Method newMethod = null;
                if (method.Extensions.ContainsKey(AzureExtensions.PageableExtension))
                {
                    var pageableExtension =
                        JsonConvert.DeserializeObject<PageableExtension>(
                            method.Extensions[AzureExtensions.PageableExtension].ToString());

                    if ((pageableExtension != null) && !method.Extensions.ContainsKey("nextLinkMethod") &&
                        !string.IsNullOrWhiteSpace(pageableExtension.NextLinkName))
                    {
                        if (method.Extensions.ContainsKey("nextMethodName"))
                        {
                            method.Extensions["nextMethodName"] = CodeNamer.Instance.GetMethodName(method.Extensions["nextMethodName"].ToString());
                        }
                        else if (!string.IsNullOrWhiteSpace(pageableExtension.OperationName))
                        {
                            method.Extensions["nextMethodName"] = CodeNamer.Instance.GetMethodName(pageableExtension.OperationName);
                        }

                        if (!method.Extensions.ContainsKey(AzureExtensions.LongRunningExtension))
                        {
                            newMethod = New<Method>().LoadFrom(method);
                            
                            // fix the name of this method so it does not get disambiguated
                            // (this leaves the 'raw' value the same, but overrides the 'Name' )
                            newMethod.Name.OnGet += value => $"{value}_as_lazy";
                            foreach (var p in method.Parameters.Where(each => each.IsClientProperty))
                            {
                                newMethod.Remove(param => param.Name.RawValue == p.Name.RawValue );
                            }

                            serviceClient.Add(newMethod);
                        }
                    }
                    if (!method.Extensions.ContainsKey(AzureExtensions.LongRunningExtension) ||
                        method.Extensions.ContainsKey("nextLinkMethod"))
                    {
                        method.Extensions.Remove(AzureExtensions.PageableExtension);
                    }
                }
            }
        }

        /// <summary>
        ///     Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="codeModel">The service client.</param>
        private void ApplyPagination(CodeModelRba codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException(nameof(codeModel));
            }

            foreach (var method in codeModel.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            {
                string nextLinkName = null;
                var ext = method.Extensions[AzureExtensions.PageableExtension] as JContainer;
                if (ext == null)
                {
                    continue;
                }
                nextLinkName = CodeNamer.Instance.GetPropertyName((string) ext["nextLinkName"]);
                var itemName = CodeNamer.Instance.GetPropertyName((string) ext["itemName"] ?? "value");
                foreach (var responseStatus in method.Responses.Where(r => r.Value.Body is CompositeType).Select(s => s.Key).ToArray())
                {
                    var compositeType = (CompositeType) method.Responses[responseStatus].Body;
                    var sequenceType = compositeType.Properties.Select(p => p.ModelType).FirstOrDefault(t => t is SequenceType) as
                            SequenceType;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        compositeType.Extensions[AzureExtensions.PageableExtension] = true;
                        var pageTemplateModel = new PageRba(compositeType, nextLinkName, itemName);
                        if (!codeModel.pageModels.Any( each => each.Name.EqualsIgnoreCase(pageTemplateModel.Name)))
                        {
                            codeModel.pageModels.Add(pageTemplateModel);
                        }
                    }
                }
            }
        }

        /// <summary>
        ///     Corrects type of the filter parameter. Currently typization of filters isn't
        ///     supported and therefore we provide to user an opportunity to pass it in form
        ///     of raw string.
        /// </summary>
        /// <param name="codeModel">The service client.</param>
        public static void CorrectFilterParameters(CodeModelRba codeModel)
        {
            foreach (var method in codeModel.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.ODataExtension)))
            {
                var filterParameter = method.Parameters
                    .FirstOrDefault(p => (p.Location == ParameterLocation.Query) && (p.Name.RawValue == "$filter"));

                if (filterParameter != null)
                {
                    filterParameter.ModelType = New<PrimaryType>(KnownPrimaryType.String);
                }
            }
        }
    }
}