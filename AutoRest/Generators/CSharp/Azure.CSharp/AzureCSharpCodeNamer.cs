// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;

namespace Microsoft.Rest.Generator.CSharp
{
    public class AzureCSharpCodeNamer : CSharpCodeNamer
    {
        /// <summary>
        /// Skips name collision resolution for method groups (operations) as they get
        /// renamed in template models.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="exclusionDictionary"></param>
        protected override void ResolveMethodGroupNameCollision(ServiceClient serviceClient,
            Dictionary<string, string> exclusionDictionary)
        {
            // Do nothing
        }

        private static string GetPagingSetting(Dictionary<string, object> extensions, IDictionary<KeyValuePair<string, string>, string> pageClasses, out string nextLinkName)
        {
            // default value
            nextLinkName = null;
            var ext = extensions[AzureCodeGenerator.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
            if (ext == null)
            {
                return null;
            }

            nextLinkName = (string)ext["nextLinkName"] ?? "nextLink";
            string itemName = (string)ext["itemName"] ?? "value";
            
            var keypair = new KeyValuePair<string, string>(nextLinkName, itemName);
            if (!pageClasses.ContainsKey(keypair))
            {
                string className = (string)ext["className"];
                if (string.IsNullOrEmpty(className))
                {
                    if (pageClasses.Count > 0)
                    {
                        className = String.Format(CultureInfo.InvariantCulture, "Page{0}", pageClasses.Count);
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

        protected override IType NormalizePrimaryType(PrimaryType primaryType)
        {
            if (primaryType != null && primaryType == PrimaryType.Credentials)
            {
                primaryType.Name = "ServiceClientCredentials";
                return primaryType;
            }
            else
            {
                return base.NormalizePrimaryType(primaryType);
            }
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

            var convertedTypes = new Dictionary<IType, CompositeType>();

            foreach (var method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureCodeGenerator.PageableExtension)))
            {
                string nextLinkString;
                string pageClassName = GetPagingSetting(method.Extensions, pageClasses, out nextLinkString);
                if (string.IsNullOrEmpty(pageClassName))
                {
                    continue;
                }
                var pageTypeFormat = "{0}<{1}>";
                var ipageTypeFormat = "IPage<{0}>";

                foreach (var responseStatus in method.Responses.Where(r => r.Value is CompositeType).Select(s => s.Key).ToArray())
                {
                    var compositType = (CompositeType) method.Responses[responseStatus];
                    var sequenceType = compositType.Properties.Select(p => p.Type).FirstOrDefault(t => t is SequenceType) as SequenceType;

                    // if the type is a wrapper over page-able response
                    if(sequenceType != null)
                    {
                        var pagableTypeName = string.Format(CultureInfo.InvariantCulture, pageTypeFormat, pageClassName, sequenceType.ElementType.Name);
                        var ipagableTypeName = string.Format(CultureInfo.InvariantCulture, ipageTypeFormat, sequenceType.ElementType.Name);

                        CompositeType pagedResult = new CompositeType
                        {
                            Name = pagableTypeName
                        };
                        pagedResult.Extensions[AzureCodeGenerator.ExternalExtension] = true;
                        pagedResult.Extensions[AzureCodeGenerator.PageableExtension] = ipagableTypeName;

                        convertedTypes[method.Responses[responseStatus]] = pagedResult;
                        method.Responses[responseStatus] = pagedResult;
                    }
                }

                if (convertedTypes.ContainsKey(method.ReturnType))
                {
                    method.ReturnType = convertedTypes[method.ReturnType];
                }
            }

            AzureCodeGenerator.RemoveUnreferencedTypes(serviceClient, convertedTypes.Keys.Cast<CompositeType>().Select(t => t.Name));
        }
    }
}
