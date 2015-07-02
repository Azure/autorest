// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    public class AzureRubyCodeNamingFramework : RubyCodeNamingFramework
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
    }
}