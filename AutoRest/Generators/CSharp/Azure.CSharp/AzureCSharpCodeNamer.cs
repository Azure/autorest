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

            var convertedTypes = new Dictionary<IType, CompositeType>();

            foreach (var method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureCodeGenerator.PageableExtension)))
            {
                foreach (var responseStatus in method.Responses.Where(r => r.Value is CompositeType).Select(s => s.Key).ToArray())
                {
                    var compositType = (CompositeType) method.Responses[responseStatus];
                    var sequenceType = compositType.Properties.Select(p => p.Type).FirstOrDefault(t => t is SequenceType) as SequenceType;

                    // if the type is a wrapper over pageable response
                    if(sequenceType != null &&
                       compositType.Properties.Count == 2 && 
                       compositType.Properties.Any(p => p.SerializedName.Equals("nextLink", StringComparison.OrdinalIgnoreCase)))
                    {
                        var pagableTypeName = string.Format(CultureInfo.InvariantCulture, pageTypeFormat, sequenceType.ElementType.Name);
                        
                        CompositeType pagedResult = new CompositeType
                        {
                            Name = pagableTypeName
                        };
                        pagedResult.Extensions[AzureCodeGenerator.ExternalExtension] = true;

                        convertedTypes[method.Responses[responseStatus]] = pagedResult;
                        method.Responses[responseStatus] = pagedResult;
                    }
                }

                if (convertedTypes.ContainsKey(method.ReturnType))
                {
                    method.ReturnType = convertedTypes[method.ReturnType];
                }
            }
        }
    }
}