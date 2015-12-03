// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Collections;
using System.Text;
using Microsoft.Rest.Generator.Python;

namespace Microsoft.Rest.Generator.Azure.Python
{
    public class AzureMethodTemplateModel : MethodTemplateModel
    {
        public AzureMethodTemplateModel(Method source, ServiceClient serviceClient)
            : base(source, serviceClient)
        {
            if (source == null)
            {
                throw new ArgumentNullException("source");
            }
            
            this.ClientRequestIdString = AzureExtensions.GetClientRequestIdString(source);
        }

        public bool IsPagingMethod
        {
            get
            {
                return this.Extensions.ContainsKey(AzureExtensions.PageableExtension);
            }
        }

        public string PagedResponseClassName
        {
            get
            {
                var ext = this.Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;

                return "models." + (string)ext["className"];
            }
        }

        public string ClientRequestIdString { get; private set; }

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation
        {
            get { return Extensions.ContainsKey(AzureExtensions.LongRunningExtension); }
        }

        public override string RaisedException
        {
            get
            {
                if (DefaultResponse.Body != null && DefaultResponse.Body.Name == "CloudError")
                {
                    return "CloudError(response)";
                }

                return base.RaisedException;
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
                sb.AppendLine("header_parameters['{0}'] = str(uuid.uuid1())", this.ClientRequestIdString).Append(base.SetDefaultHeaders);
                return sb.ToString();
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Utilities.IndentedStringBuilder.AppendLine(System.String)")]
        public override string ReturnEmptyResponse
        {
            get
            {
                if (this.HttpMethod == HttpMethod.Head)
                {
                    HttpStatusCode code = this.Responses.Keys.FirstOrDefault(AzureExtensions.HttpHeadStatusCodeSuccessFunc);
                    var builder = new IndentedStringBuilder("    ");
                    builder.AppendFormat("deserialized = (response.status_code == {0})", (int)code).AppendLine();
                    builder.AppendLine("if raw:").Indent().
                        AppendLine("client_raw_response = ClientRawResponse(deserialized, response)");
                    if (this.Responses[code].Headers != null)
                    {
                        builder.AppendLine("client_raw_response.add_headers({").Indent();
                        foreach (var prop in ((CompositeType)this.Responses[code].Headers).Properties)
                        {
                            builder.AppendLine(String.Format(CultureInfo.InvariantCulture, "'{0}': '{1}',", prop.SerializedName, prop.Type.ToPythonRuntimeTypeString()));
                        }
                        builder.AppendLine("})").Outdent();
                    }
                    builder.AppendLine("return client_raw_response").
                        Outdent();
                    builder.AppendLine("return deserialized");

                    return builder.ToString();
                }
                else
                {
                    return base.ReturnEmptyResponse;
                }
            }
        }
    }
}