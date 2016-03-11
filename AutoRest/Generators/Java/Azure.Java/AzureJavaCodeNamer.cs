// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Azure;
using System.Globalization;

namespace Microsoft.Rest.Generator.Java.Azure
{
    public class AzureJavaCodeNamer : JavaCodeNamer
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

            var convertedTypes = new Dictionary<IType, IType>();

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

                foreach (var responseStatus in method.Responses.Where(r => r.Value.Body is CompositeType).Select(s => s.Key).ToArray())
                {
                    var compositType = (CompositeType)method.Responses[responseStatus].Body;
                    var sequenceType = compositType.Properties.Select(p => p.Type).FirstOrDefault(t => t is SequenceType) as SequenceType;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        IType pagedResult;
                        pagedResult = new SequenceType
                        {
                            ElementType = sequenceType.ElementType,
                            NameFormat = "List<{0}>"
                        };

                        convertedTypes[method.Responses[responseStatus].Body] = pagedResult;
                        method.Responses[responseStatus] = new Response(pagedResult, method.Responses[responseStatus].Headers);
                    }
                }

                if (convertedTypes.ContainsKey(method.ReturnType.Body))
                {
                    method.ReturnType = new Response(convertedTypes[method.ReturnType.Body], method.ReturnType.Headers);
                }
            }

            Extensions.RemoveUnreferencedTypes(serviceClient, new HashSet<string>(convertedTypes.Keys.Cast<CompositeType>().Select(t => t.Name)));
        }

        #endregion

        public override List<string> ImportType(IType type, string ns)
        {
            List<string> imports = new List<string>();
            var compositeType = type as CompositeType;
            if (compositeType != null && ns != null)
            {
                if (type.Name.Contains('<'))
                {
                    imports.AddRange(compositeType.ParseGenericType().SelectMany(t => ImportType(t, ns)));
                }
                else if (compositeType.Extensions.ContainsKey(ExternalExtension) &&
                    (bool)compositeType.Extensions[ExternalExtension])
                {
                    imports.Add(string.Join(
                        ".",
                        "com.microsoft.rest",
                        type.Name));
                }
                else if (compositeType.isResource())
                {
                    imports.Add(string.Join(
                            ".",
                            "com.microsoft.azure",
                            type.Name));
                }
                else
                {
                    imports.Add(string.Join(
                        ".",
                        ns.ToLower(CultureInfo.InvariantCulture),
                        "models",
                        type.Name));
                }
            }
            else
            {
                imports.AddRange(base.ImportType(type, ns));
            }
            return imports;
        }
    }
}