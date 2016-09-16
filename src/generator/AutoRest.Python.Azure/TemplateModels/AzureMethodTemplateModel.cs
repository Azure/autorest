// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Net;
using System.Collections.Generic;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.Python.TemplateModels;

namespace AutoRest.Python.Azure.TemplateModels
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
            this.RequestIdString = AzureExtensions.GetRequestIdString(source);
        }

        public bool IsPagingMethod
        {
            get
            {
                return this.Extensions.ContainsKey(AzureExtensions.PageableExtension);
            }
        }

        public string PagingURL
        {
            get
            {
                if (this.Extensions.ContainsKey("nextLinkURL"))
                {
                    return this.Extensions["nextLinkURL"] as string;
                }
                return null;
            }
        }

        public IEnumerable<Parameter> PagingParameters
        {
            get
            {
                if (this.Extensions.ContainsKey("nextLinkParameters"))
                {
                    return this.Extensions["nextLinkParameters"] as IEnumerable<Parameter>;
                }
                return null;
            }
        }

        public string PagedResponseClassName
        {
            get
            {
                var ext = this.Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
                if (ext == null)
                {
                    return string.Empty;
                }

                return "models." + (string)ext["className"];
            }
        }

        public string ClientRequestIdString { get; private set; }

        public string RequestIdString { get; private set; }

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation
        {
            get { return Extensions.ContainsKey(AzureExtensions.LongRunningExtension); }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "exp"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "CloudError")]
        public override string RaisedException
        {
            get
            {
                if (DefaultResponse.Body == null || DefaultResponse.Body.Name == "CloudError")
                {
                    var sb = new IndentedStringBuilder();
                    sb.AppendLine("exp = CloudError(response)");
                    sb.AppendLine("exp.request_id = response.headers.get('{0}')", this.RequestIdString);
                    sb.AppendLine("raise exp");
                    return sb.ToString();
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
                sb.AppendLine("if self.config.generate_client_request_id:", this.ClientRequestIdString).Indent();
                sb.AppendLine("header_parameters['{0}'] = str(uuid.uuid1())", this.ClientRequestIdString).Outdent().Append(base.SetDefaultHeaders);
                return sb.ToString();
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "addheaders"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "ClientRawResponse"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "clientrawresponse"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)")]
        public override string ReturnEmptyResponse
        {
            get
            {
                if (this.HttpMethod == HttpMethod.Head && this.ReturnType.Body.IsPrimaryType(KnownPrimaryType.Boolean))
                {
                    HttpStatusCode code = this.Responses.Keys.FirstOrDefault(AzureExtensions.HttpHeadStatusCodeSuccessFunc);
                    var builder = new IndentedStringBuilder("    ");
                    builder.AppendFormat("deserialized = (response.status_code == {0})", (int)code).AppendLine();
                    builder.AppendLine("if raw:").Indent().
                        AppendLine("client_raw_response = ClientRawResponse(deserialized, response)");
                    if (this.Responses[code].Headers != null)
                    {
                        builder.AppendLine("client_raw_response.add_headers({").Indent();
                        AddHeaderDictionary(builder, (CompositeType)this.Responses[code].Headers);
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