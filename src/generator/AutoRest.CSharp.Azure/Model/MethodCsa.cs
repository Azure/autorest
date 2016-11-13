// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.Azure.Properties;
using AutoRest.CSharp.Model;
using AutoRest.Extensions.Azure;
using Newtonsoft.Json;
using IndentedStringBuilder = AutoRest.Core.Utilities.IndentedStringBuilder;

namespace AutoRest.CSharp.Azure.Model
{
    public class MethodCsa : MethodCs
    {
        public MethodCsa()
        {
        }
        
        [JsonIgnore]
        public string ClientRequestIdString => AzureExtensions.GetClientRequestIdString(this);

        [JsonIgnore]
        public string RequestIdString => AzureExtensions.GetRequestIdString(this);

        [JsonIgnore]
        public MethodCsa GetMethod
        {
            get
            {
                var getMethod = CodeModel.Methods.FirstOrDefault(m => m.Url == Url
                                                                          && m.HttpMethod == HttpMethod.Get &&
                                                                          m.Group == Group);
                if (getMethod == null)
                {
                    throw new InvalidOperationException(
                        string.Format(CultureInfo.InvariantCulture,
                        Resources.InvalidLongRunningOperationForCreateOrUpdate,
                            Name, Group));
                }
                MethodCsa method = getMethod as MethodCsa;
                method.SyncMethods = SyncMethods;
                return method;
            }
        }

        /// <summary>
        /// Get the expression for exception initialization with message.
        /// </summary>
        public override string InitializeExceptionWithMessage
        {
            get
            {
                if (DefaultResponse.Body != null && DefaultResponse.Body.Name == "CloudError")
                {
                    return "ex = new Microsoft.Rest.Azure.CloudException(_errorBody.Message);";
                }
                return base.InitializeExceptionWithMessage;
            }
        }

        /// <summary>
        /// Get the expression for exception initialization.
        /// </summary>
        public override string InitializeException
        {
            get
            {
                if (OperationExceptionTypeString == "Microsoft.Rest.Azure.CloudException")
                {
                    IndentedStringBuilder sb = new IndentedStringBuilder();
                    sb.AppendLine(base.InitializeExceptionWithMessage)
                      .AppendLine("if (_httpResponse.Headers.Contains(\"{0}\"))", this.RequestIdString)
                      .AppendLine("{").Indent()
                        .AppendLine("ex.RequestId = _httpResponse.Headers.GetValues(\"{0}\").FirstOrDefault();", this.RequestIdString).Outdent()
                      .AppendLine("}");
                    return sb.ToString();
                }
                return base.InitializeExceptionWithMessage;
            }
        }

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation => Extensions.ContainsKey(AzureExtensions.LongRunningExtension) && true == Extensions[AzureExtensions.LongRunningExtension] as bool?;

        private string ReturnTypePageInterfaceName
        {
            get
            {
                if (ReturnType.Body is CompositeType)
                {
                    // Special handle Page class with IPage interface
                    CompositeType compositeType = ReturnType.Body as CompositeType;
                    if (compositeType.Extensions.ContainsKey(AzureExtensions.PageableExtension))
                    {
                        return (string)compositeType.Extensions[AzureExtensions.PageableExtension];
                    }
                }
                return null;
            }
        }

        /// <summary>
        /// Returns AzureOperationResponse generic type declaration.
        /// </summary>
        public override string OperationResponseReturnTypeString
        {
            get
            {
                if (ReturnType.Body != null)
                {
                   
                    if (ReturnType.Headers != null)
                    {
                        return string.Format(CultureInfo.InvariantCulture,
                                    "Microsoft.Rest.Azure.AzureOperationResponse<{0},{1}>", ReturnTypeString, ReturnType.Headers.AsNullableType(HttpMethod != HttpMethod.Head));
                    }
                    else
                    {
                        return string.Format(CultureInfo.InvariantCulture,
                                    "Microsoft.Rest.Azure.AzureOperationResponse<{0}>", ReturnTypeString);
                    }
                }
                else if (ReturnType.Headers != null)
                {
                    return string.Format(CultureInfo.InvariantCulture,
                                    "Microsoft.Rest.Azure.AzureOperationHeaderResponse<{0}>", ReturnType.Headers.AsNullableType(HttpMethod != HttpMethod.Head));
                }
                else
                {
                    return "Microsoft.Rest.Azure.AzureOperationResponse";
                }
            }
        }

        /// <summary>
        /// Get the type name for the method's return type
        /// </summary>
        public override string ReturnTypeString => ReturnTypePageInterfaceName ?? base.ReturnTypeString;

        /// <summary>
        /// Get the return type for the async extension method
        /// </summary>
        public override string TaskExtensionReturnTypeString
        {
            get
            {
                if (!string.IsNullOrEmpty(ReturnTypePageInterfaceName))
                {
                    return string.Format(CultureInfo.InvariantCulture,
                        "Task<{0}>", ReturnTypePageInterfaceName);
                }
                return base.TaskExtensionReturnTypeString;
            }
        }

        /// <summary>
        /// Get the type for operation exception.
        /// </summary>
        public override string OperationExceptionTypeString
        {
            get
            {
                if (DefaultResponse.Body == null || DefaultResponse.Body.Name == "CloudError")
                {
                    return "Microsoft.Rest.Azure.CloudException";
                }
                return base.OperationExceptionTypeString;
            }
        }


        /// <summary>
        /// Gets the expression for response body initialization 
        /// </summary>
        public override string InitializeResponseBody
        {
            get
            {
                var sb = new IndentedStringBuilder();
                if (this.HttpMethod == HttpMethod.Head &&
                    this.ReturnType.Body != null)
                {
                    HttpStatusCode code = this.Responses.Keys.FirstOrDefault(AzureExtensions.HttpHeadStatusCodeSuccessFunc);
                    sb.AppendFormat("_result.Body = (_statusCode == System.Net.HttpStatusCode.{0});", code.ToString()).AppendLine();
                }
                sb.AppendLine("if (_httpResponse.Headers.Contains(\"{0}\"))", this.RequestIdString)
                    .AppendLine("{").Indent()
                        .AppendLine("_result.RequestId = _httpResponse.Headers.GetValues(\"{0}\").FirstOrDefault();", this.RequestIdString).Outdent()
                    .AppendLine("}")
                    .AppendLine(base.InitializeResponseBody);
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
                var sb= new IndentedStringBuilder();
                sb.AppendLine("if ({0}.GenerateClientRequestId != null && {0}.GenerateClientRequestId.Value)", this.ClientReference)
                   .AppendLine("{").Indent()
                       .AppendLine("_httpRequest.Headers.TryAddWithoutValidation(\"{0}\", System.Guid.NewGuid().ToString());", 
                           this.ClientRequestIdString, this.ClientReference).Outdent()
                   .AppendLine("}")
                   .AppendLine(base.SetDefaultHeaders);
                return sb.ToString();
            }
        }

        /// <summary>
        /// Gets Get method invocation arguments for Long Running Operations.
        /// </summary>
        /// <param name="getMethod">Get method.</param>
        /// <returns>Invocation arguments.</returns>
        public string GetMethodInvocationArgs(Method getMethod)
        {
            if (getMethod == null)
            {
                throw new ArgumentNullException("getMethod");
            }

            var invocationParams = new List<string>();
            getMethod.Parameters
                .Where(p => LocalParameters.Any(lp => lp.Name == p.Name))
                .ForEach(p => invocationParams.Add(string.Format(CultureInfo.InvariantCulture,"{0}: {0}", p.Name)));
            invocationParams.Add("customHeaders: customHeaders");
            invocationParams.Add("cancellationToken: cancellationToken");
            return string.Join(", ", invocationParams);
        }

        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the url in.</param>
        /// <returns></returns>
        public override string BuildUrl(string variableName)
        {
            var builder = new IndentedStringBuilder(IndentedStringBuilder.FourSpaces);
            ReplacePathParametersInUri(variableName, builder);
            AddQueryParametersToUri(variableName, builder);
            return builder.ToString();
        }

        private void AddQueryParametersToUri(string variableName, IndentedStringBuilder builder)
        {
            builder.AppendLine("System.Collections.Generic.List<string> _queryParameters = new System.Collections.Generic.List<string>();");
            if (LogicalParameters.Any(p => p.Location == ParameterLocation.Query))
            {
                foreach (var queryParameter in LogicalParameters
                    .Where(p => p.Location == ParameterLocation.Query).Select(p => p as ParameterCsa))
                {
                    string queryParametersAddString =
                        "_queryParameters.Add(string.Format(\"{0}={{0}}\", System.Uri.EscapeDataString({1})));";

                    if (queryParameter.IsODataFilterExpression)
                    {
                        queryParametersAddString = @"var _odataFilter = {2}.ToString();
    if (!string.IsNullOrEmpty(_odataFilter)) 
    {{
        _queryParameters.Add(_odataFilter);
    }}";
                    }
                    else if (queryParameter.Extensions.ContainsKey(AzureExtensions.SkipUrlEncodingExtension))
                    {
                        queryParametersAddString = "_queryParameters.Add(string.Format(\"{0}={{0}}\", {1}));";
                    }

                    if (queryParameter.IsNullable())
                    {
                        builder.AppendLine("if ({0} != null)", queryParameter.Name)
                            .AppendLine("{").Indent();
                    }

                    if (queryParameter.CollectionFormat == CollectionFormat.Multi)
                    {
                        builder.AppendLine("if ({0}.Count == 0)", queryParameter.Name)
                           .AppendLine("{").Indent()
                           .AppendLine(queryParametersAddString, queryParameter.SerializedName, "string.Empty").Outdent()
                           .AppendLine("}")
                           .AppendLine("else")
                           .AppendLine("{").Indent()
                           .AppendLine("foreach (var _item in {0})", queryParameter.Name)
                           .AppendLine("{").Indent()
                           .AppendLine(queryParametersAddString, queryParameter.SerializedName, "_item ?? string.Empty").Outdent()
                           .AppendLine("}").Outdent()
                           .AppendLine("}").Outdent();
                    }
                    else
                    {
                        builder.AppendLine(queryParametersAddString,
                            queryParameter.SerializedName, queryParameter.GetFormattedReferenceValue(ClientReference), queryParameter.Name);
                    }

                    if (queryParameter.IsNullable())
                    {
                        builder.Outdent()
                            .AppendLine("}");
                    }
                }
            }

            builder.AppendLine("if (_queryParameters.Count > 0)")
                .AppendLine("{").Indent()
                .AppendLine("{0} += ({0}.Contains(\"?\") ? \"&\" : \"?\") + string.Join(\"&\", _queryParameters);", variableName).Outdent()
                .AppendLine("}");
        }

        private void ReplacePathParametersInUri(string variableName, IndentedStringBuilder builder)
        {
            foreach (var pathParameter in LogicalParameters.Where(p => p.Location == ParameterLocation.Path))
            {
                string replaceString = "{0} = {0}.Replace(\"{{{1}}}\", System.Uri.EscapeDataString({2}));";
                if (pathParameter.Extensions.ContainsKey(AzureExtensions.SkipUrlEncodingExtension))
                {
                    replaceString = "{0} = {0}.Replace(\"{{{1}}}\", {2});";
                }

                builder.AppendLine(replaceString,
                    variableName,
                    pathParameter.SerializedName,
                    pathParameter.ModelType.ToString(ClientReference, pathParameter.Name));
            }
        }
    }
}