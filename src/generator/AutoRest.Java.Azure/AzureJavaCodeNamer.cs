// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Java.Azure.TypeModels;
using AutoRest.Java.TypeModels;

namespace AutoRest.Java.Azure
{
    public class AzureJavaCodeNamer : JavaCodeNamer
    {
        public AzureJavaCodeNamer(string nameSpace)
            : base(nameSpace)
        {
        }

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
        public virtual void NormalizePaginatedMethods(ServiceClient serviceClient, IDictionary<KeyValuePair<string, string>, string> pageClasses)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            var convertedTypes = new Dictionary<ITypeModel, ITypeModel>();

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

                foreach (var responseStatus in method.Responses.Where(r => r.Value.Body is CompositeTypeModel).Select(s => s.Key).ToArray())
                {
                    var compositType = (CompositeTypeModel)method.Responses[responseStatus].Body;
                    var sequenceType = compositType.Properties.Select(p => p.Type).FirstOrDefault(t => t is SequenceTypeModel) as SequenceTypeModel;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        ITypeModel pagedResult;
                        pagedResult = new AzureSequenceTypeModel
                        {
                            ElementType = sequenceType.ElementType,
                            NameFormat = "List<{0}>",
                            PageImplType = pageClassName
                        };

                        convertedTypes[(ITypeModel)method.Responses[responseStatus].Body] = pagedResult;
                        method.Responses[responseStatus] = new Response(pagedResult, method.Responses[responseStatus].Headers);
                    }
                }

                if (convertedTypes.ContainsKey((ITypeModel) method.ReturnType.Body))
                {
                    method.ReturnType = new Response(convertedTypes[(ITypeModel)method.ReturnType.Body], method.ReturnType.Headers);
                }
            }

            SwaggerExtensions.RemoveUnreferencedTypes(serviceClient, new HashSet<string>(convertedTypes.Keys.Cast<CompositeTypeModel>().Select(t => t.Name)));
        }

        protected override CompositeTypeModel NewCompositeTypeModel(CompositeType compositeType)
        {
            return new AzureCompositeTypeModel(compositeType, _package);
        }

        #endregion
    }
}