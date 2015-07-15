// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using System.Collections.Generic;
using Microsoft.Rest.Generator.ClientModel;
using System;
using Microsoft.Rest.Generator.Azure;
using System.Globalization;

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

        /// <summary>
        /// Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="serviceClient"></param>
        public virtual void NormalizePaginatedMethods(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            var pageTypeFormat = "Page<{0}>";
            var pagableMethods = serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureCodeGenerator.PageableExtension));

            var exclusionSet = new HashSet<CompositeType>();

            foreach (var method in pagableMethods)
            {
                // get underlying type of the sequence
                var underlyingType = ((SequenceType)((CompositeType)method.ReturnType).Properties
                                             .First(p => !p.Name.Equals("nextLink", StringComparison.OrdinalIgnoreCase)).Type).ElementType;


                var pagableTypeName = string.Format(CultureInfo.InvariantCulture, pageTypeFormat, underlyingType.Name);

                CompositeType pagedResult = serviceClient.ModelTypes.FirstOrDefault(c =>
                    c.Name.Equals(pagableTypeName, StringComparison.OrdinalIgnoreCase));
                if (pagedResult == null)
                {
                    pagedResult = new CompositeType
                    {
                        Name = pagableTypeName
                    };
                    pagedResult.Extensions[AzureCodeGenerator.ExternalExtension] = true;
                    serviceClient.ModelTypes.Add(pagedResult);
                }

                if (serviceClient.ModelTypes.Contains(method.ReturnType))
                {
                    exclusionSet.Add((CompositeType)method.ReturnType);
                    for (int i = 0; i < method.Responses.Count; i++)
                    {
                        if (method.Responses.ElementAt(i).Value == method.ReturnType)
                        {
                            method.Responses[method.Responses.ElementAt(i).Key] = pagedResult;
                        }
                    }
                }
                method.ReturnType = pagedResult;
            }

            foreach (var typeToExclude in exclusionSet)
            {
                serviceClient.ModelTypes.Remove(typeToExclude);
            }
        }
    }
}