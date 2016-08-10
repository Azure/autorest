// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Ruby.TemplateModels;

namespace AutoRest.Ruby.Azure.TemplateModels
{
    /// <summary>
    /// The model for the Azure service client.
    /// </summary>
    public class AzureServiceClientTemplateModel : ServiceClientTemplateModel
    {
        /// <summary>
        /// Initializes a new instance of the AzureServiceClientTemplateModel class.
        /// </summary>
        /// <param name="serviceClient">The service client instance.</param>
        public AzureServiceClientTemplateModel(ServiceClient serviceClient)
            : base(serviceClient)
        {
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == null)
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

        /// <summary>
        /// Gets the base type of the service client.
        /// </summary>
        public override string BaseType
        {
            get
            {
                return "MsRestAzure::AzureServiceClient";
            }
        }

        /// <summary>
        /// Gets the serializer type of the client.
        /// </summary>
        public override string IncludeSerializer
        {
            get
            {
                return "include MsRestAzure::Serialization";
            }
        }
    }
}