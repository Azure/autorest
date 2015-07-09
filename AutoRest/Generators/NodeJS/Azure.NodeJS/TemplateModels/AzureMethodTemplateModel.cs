// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.NodeJS.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.NodeJS;
using Microsoft.Rest.Generator.Azure.NodeJS.Properties;

namespace Microsoft.Rest.Generator.Azure.NodeJS
{
    public class AzureMethodTemplateModel : MethodTemplateModel
    {
        public AzureMethodTemplateModel(Method source, ServiceClient serviceClient)
            : base(source, serviceClient)
        {
        }

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation
        {
            get { return Extensions.ContainsKey(AzureCodeGenerator.LongRunningExtension); }
        }

        /// <summary>
        /// If this is a relative uri, we will add api-version query, so add this condition to the check
        /// </summary>
        /// <returns>true if there are any query parameters in the uri, otherwise false</returns>
        protected override bool HasQueryParameters()
        {
            return base.HasQueryParameters() || !IsAbsoluteUrl;
        }

        /// <summary>
        /// Long running put request poller method
        /// </summary>
        public AzureMethodTemplateModel GetMethod
        {
            get
            {
                var getMethod = ServiceClient.Methods.FirstOrDefault(m => m.Url == Url
                                                                          && m.HttpMethod == HttpMethod.Get &&
                                                                          m.Group == Group);
                if (getMethod == null)
                {
                    throw new InvalidOperationException(Resources.InvalidLongRunningOperationForCreateOrUpdate);
                }
                return new AzureMethodTemplateModel(getMethod, ServiceClient);
            }
        }

        /// <summary>
        /// Gets the expression for response body initialization 
        /// </summary>
        public override string InitializeResponseBody
        {
            get
            {
                if (this.HttpMethod == HttpMethod.Head &&
                    this.ReturnType != null)
                {
                    return "result.body = (statusCode === 204);";
                }
                return base.InitializeResponseBody;
            }
        }
    }
}