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
        /// Gets the expression for response body initialization 
        /// </summary>
        public override string InitializeResponseBody
        {
            get
            {
                //result.requestId = result.httpRequest.headers['x-ms-request-id'];
                var sb = new IndentedStringBuilder();
                if (this.HttpMethod == HttpMethod.Head &&
                    this.ReturnType != null)
                {
                    sb.AppendLine("result.body = (statusCode === 204);");
                }
                sb.AppendLine("result.requestId = response.headers['x-ms-request-id'];")
                    .AppendLine(base.InitializeResponseBody);
                return sb.ToString();
            }
        }

        /// <summary>
        /// Gets the expression for default header setting. 
        /// </summary>
        public override string SetDefaultHeaders
        {
            get
            {
                var sb = new IndentedStringBuilder();
                sb.AppendLine("httpRequest.headers['x-ms-client-request-id'] = msRestAzure.generateUuid();")
                  .AppendLine(base.SetDefaultHeaders);
                return sb.ToString();
            }
        }
    }
}