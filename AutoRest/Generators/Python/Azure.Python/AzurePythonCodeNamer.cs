// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Python;

namespace Microsoft.Rest.Generator.Azure.Python
{
    public class AzurePythonCodeNamer : PythonCodeNamer
    {
        /// <summary>
        /// Initializes a new instance of CSharpCodeNamingFramework.
        /// </summary>
        public AzurePythonCodeNamer()
        {
        }

        private static void GetPagingSetting(Dictionary<string, object> extensions, string valueTypeName, IDictionary<Tuple<string, string>, Tuple<string, string>> pageClasses)
        {
            var ext = extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;

            string nextLinkName = (string)ext["nextLinkName"] ?? "nextLink";
            string itemName = (string)ext["itemName"] ?? "value";

            var pair = new Tuple<string, string>(nextLinkName, itemName);
            if (!pageClasses.ContainsKey(pair))
            {
                string className = (string)ext["className"];
                if (string.IsNullOrEmpty(className))
                {
                    className = valueTypeName + "Paged";
                    ext["className"] = className;
                }
                pageClasses.Add(pair, new Tuple<string, string>(className, valueTypeName));
            }
        }

        /// <summary>
        /// Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="pageClasses"></param>
        public virtual void NormalizePaginatedMethods(ServiceClient serviceClient, IDictionary<Tuple<string, string>, Tuple<string, string>> pageClasses)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            foreach (var method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            {
                bool hasReturnType = false;

                foreach (var responseStatus in method.Responses.Where(r => r.Value is CompositeType).Select(s => s.Key))
                {
                    var compositType = (CompositeType)method.Responses[responseStatus];
                    var sequenceType = compositType.Properties.Select(p => p.Type).FirstOrDefault(t => t is SequenceType) as SequenceType;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        GetPagingSetting(method.Extensions, sequenceType.ElementType.Name, pageClasses);

                        // TODO: What if this type is reference by other non-page function?
                        compositType.Extensions[AzureExtensions.ExternalExtension] = true;
                        hasReturnType = true;
                        break;
                    }
                }

                if (!hasReturnType)
                {
                    // Somehow the page method doesn't have correct response type
                    method.Extensions.Remove(AzureExtensions.PageableExtension);
                }
            }
        }
    }
}
