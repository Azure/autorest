// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;

namespace AutoRest.Java.Azure
{
    public class CodeNamerJva : CodeNamerJv
    {
        #region normalization
        
        private static string GetPagingSetting(Dictionary<string, object> extensions, IDictionary<KeyValuePair<string, string>, string> pageClasses, out string nextLinkName)
        {
            // default value
            nextLinkName = null;
            var ext = extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
            if (ext == null)
            {
                return null;
            }

            nextLinkName = (string)ext["nextLinkName"];
            string itemName = (string)ext["itemName"] ?? "value";

            var keypair = new KeyValuePair<string, string>(nextLinkName, itemName);
            if (!pageClasses.ContainsKey(keypair))
            {
                string className = (string)ext["className"];
                if (string.IsNullOrEmpty(className))
                {
                    if (pageClasses.Count > 0)
                    {
                        className = String.Format(CultureInfo.InvariantCulture, "PageImpl{0}", pageClasses.Count);
                    }
                    else
                    {
                        className = "PageImpl";
                    }
                }
                pageClasses.Add(keypair, className);
            }
            ext["className"] = pageClasses[keypair];

            return pageClasses[keypair];
        }

        /// <summary>
        /// Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="pageClasses"></param>
        public virtual void NormalizePaginatedMethods(CodeModel serviceClient, IDictionary<KeyValuePair<string, string>, string> pageClasses)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            var convertedTypes = new Dictionary<IModelType, IModelType>();

            foreach (var method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
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
                        pagedResult.Name.OnGet += name => $"List<{name}>";

                        convertedTypes[method.Responses[responseStatus].Body] = pagedResult;
                        method.Responses[responseStatus] = new Response(pagedResult, method.Responses[responseStatus].Headers);
                    }
                }

                if (convertedTypes.ContainsKey(method.ReturnType.Body))
                {
                    method.ReturnType = new Response(convertedTypes[method.ReturnType.Body], method.ReturnType.Headers);
                }
            }

            SwaggerExtensions.RemoveUnreferencedTypes(serviceClient, new HashSet<string>(convertedTypes.Keys.Cast<CompositeTypeJva>().Select(t => t.Name.ToString())));
        }

        //protected override CompositeTypeJva NewCompositeTypeModel(CompositeType compositeType)
        //{
        //    return new AzureCompositeTypeModel(compositeType, _package);
        //}

        #endregion
    }
}