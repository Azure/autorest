// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Net;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.NodeJS.Model;
using Newtonsoft.Json;

namespace AutoRest.NodeJS.Azure.Model
{
    public class MethodJsa : MethodJs
    {
        protected MethodJsa()
            : base()
        {
        }

        [JsonIgnore]
        public string ClientRequestIdString => AzureExtensions.GetClientRequestIdString(this);

        [JsonIgnore]
        public string RequestIdString => AzureExtensions.GetRequestIdString(this);

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        [JsonIgnore]
        public bool IsLongRunningOperation => Extensions.ContainsKey(AzureExtensions.LongRunningExtension);

        /// <summary>
        /// If this is a relative uri, we will add api-version query, so add this condition to the check
        /// </summary>
        /// <returns>true if there are any query parameters in the uri, otherwise false</returns>
        protected override bool HasQueryParameters()
        {
            return base.HasQueryParameters() || !IsAbsoluteUrl;
        }


        [JsonIgnore]
        public override string InitializeResult
        {
            get
            {
                var sb = new IndentedStringBuilder();
                if (this.HttpMethod == HttpMethod.Head &&
                    this.ReturnType.Body != null)
                {
                    HttpStatusCode code = this.Responses.Keys.FirstOrDefault(AzureExtensions.HttpHeadStatusCodeSuccessFunc);
                    sb.AppendFormat("result = (statusCode === {0});", (int)code).AppendLine();
                }

                return sb.ToString();
            }
        }

        /// <summary>
        /// Gets the expression for default header setting. 
        /// </summary>
        [JsonIgnore]
        public override string SetDefaultHeaders
        {
            get
            {
                var sb = new IndentedStringBuilder();
                sb.AppendLine("if ({0}.generateClientRequestId) {{", this.ClientReference).Indent()
                    .AppendLine("httpRequest.headers['{0}'] = msRestAzure.generateUuid();", 
                        this.ClientRequestIdString, this.ClientReference).Outdent()
                  .AppendLine("}")
                  .AppendLine(base.SetDefaultHeaders);
                return sb.ToString();
            }
        }

        [JsonIgnore]
        public string LongRunningOperationMethodNameInRuntime
        {
            get
            {
                string result = null;
                if (this.IsLongRunningOperation)
                {
                    result = "getLongRunningOperationResult";
                }
                return result;
            }
        }
    }
}