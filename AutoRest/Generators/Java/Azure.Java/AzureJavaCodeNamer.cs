// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using System.Collections.Generic;
using Microsoft.Rest.Generator.ClientModel;
using System;
using Microsoft.Rest.Generator.Azure;
using System.Globalization;

namespace Microsoft.Rest.Generator.Java
{
    public class AzureJavaCodeNamer : JavaCodeNamer
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
        }
    }
}