// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    /// <summary>
    /// The model for the Azure method template.
    /// </summary>
    public class AzureMethodGroupTemplateModel : MethodGroupTemplateModel
    {
        /// <summary>
        /// Initializes a new instance
        /// </summary>
        /// <param name="serviceClient">The service client instance.</param>
        /// <param name="methodGroupName">The name of the method group.</param>
        public AzureMethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName)
            : base(serviceClient, methodGroupName)
        {
            // Clear base initialized MethodTemplateModels and re-populate with
            // AzureMethodTemplateModel
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == methodGroupName)
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient)));
        }

        /// <summary>
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public override List<string> Includes
        {
            get
            {
                return new List<string>
                {
                    "MsRestAzure"
                };
            }
        }
    }
}