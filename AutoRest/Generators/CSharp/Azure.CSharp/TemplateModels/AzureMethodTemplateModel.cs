// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Linq;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.CSharp.Azure.Properties;
using Microsoft.Rest.Generator.CSharp.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator.CSharp.Azure
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

            ParameterTemplateModels.Clear();
            source.Parameters.ForEach(p => ParameterTemplateModels.Add(new AzureParameterTemplateModel(p)));

            if (MethodGroupName != ServiceClient.Name)
            {
                MethodGroupName = MethodGroupName + "Operations";
            }
        }

        public AzureMethodTemplateModel GetMethod
        {
            get
            {
                var getMethod = ServiceClient.Methods.FirstOrDefault(m => m.Url == Url
                                                                          && m.HttpMethod == HttpMethod.Get &&
                                                                          m.Group == Group);
                if (getMethod == null)
                {
                    throw new InvalidOperationException(
                        string.Format(CultureInfo.InvariantCulture,
                        Resources.InvalidLongRunningOperationForCreateOrUpdate,
                            Name, Group));
                }
                return new AzureMethodTemplateModel(getMethod, ServiceClient);
            }
        }

        /// <summary>
        /// Get the expression for exception initialization with message.
        /// </summary>
        public override string InitializeExceptionWithMessage
        {
            get
            {
                if (DefaultResponse != null && DefaultResponse.Name == "CloudError")
                {
                    return "ex = new CloudException(errorBody.Message);";
                }
                return base.InitializeExceptionWithMessage;
            }
        }

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation
        {
            get { return Extensions.ContainsKey(AzureCodeGenerator.LongRunningExtension); }
        }

        /// <summary>
        /// Returns AzureOperationResponse generic type declaration.
        /// </summary>
        public override string OperationResponseReturnTypeString
        {
            get
            {
                if (ReturnType != null)
                {
                    return string.Format(CultureInfo.InvariantCulture,
                        "AzureOperationResponse<{0}>", ReturnType.Name);
                }
                else
                {
                    return "AzureOperationResponse";
                }
            }
        }

        /// <summary>
        /// Get the type for operation exception.
        /// </summary>
        public override string OperationExceptionTypeString
        {
            get
            {
                if (DefaultResponse == null || DefaultResponse.Name == "CloudError")
                {
                    return "CloudException";
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
                if (this.HttpMethod == HttpMethod.Head &&
                    this.ReturnType != null)
                {
                    return "result.Body = (statusCode == HttpStatusCode.NoContent);";
                }
                return base.InitializeResponseBody;
            }
        }

        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the url in.</param>
        /// <returns></returns>
        public override string BuildUrl(string variableName)
        {
            var builder = new IndentedStringBuilder(IndentedStringBuilder.FourSpaces);
            ReplaceSubscriptionIdInUri(variableName, builder);
            ReplacePathParametersInUri(variableName, builder);
            AddQueryParametersToUri(variableName, builder);
            return builder.ToString();
        }

        private void AddQueryParametersToUri(string variableName, IndentedStringBuilder builder)
        {
            builder.AppendLine("List<string> queryParameters = new List<string>();");
            if (ParameterTemplateModels.Any(p => p.Location == ParameterLocation.Query))
            {
                foreach (var queryParameter in ParameterTemplateModels
                    .Where(p => p.Location == ParameterLocation.Query))
                {
                    string queryParametersAddString =
                        "queryParameters.Add(string.Format(\"{0}={{0}}\", Uri.EscapeDataString({1})));";

                    if (queryParameter.SerializedName.Equals("$filter", StringComparison.OrdinalIgnoreCase) &&
                        queryParameter.Type is CompositeType &&
                        queryParameter.Location == ParameterLocation.Query)
                    {
                        queryParametersAddString =
                            "queryParameters.Add(string.Format(\"{0}={{0}}\", FilterString.Generate(filter)));";
                    }
                    else if (queryParameter.Extensions.ContainsKey(AzureCodeGenerator.SkipUrlEncodingExtension))
                    {
                        queryParametersAddString = "queryParameters.Add(string.Format(\"{0}={{0}}\", {1}));";
                    }

                    builder.AppendLine("if ({0} != null)", queryParameter.Name)
                        .AppendLine("{").Indent()
                        .AppendLine(queryParametersAddString,
                            queryParameter.SerializedName, queryParameter.GetFormattedReferenceValue(ClientReference))
                        .Outdent()
                        .AppendLine("}");
                }
            }

            if (!Parameters.Any(p => p.Name.Equals("apiVersion", StringComparison.OrdinalIgnoreCase)) &&
                !IsAbsoluteUrl)
            {
                builder.AppendLine(
                    "queryParameters.Add(string.Format(\"api-version={{0}}\", Uri.EscapeDataString({0}.ApiVersion)));",
                    ClientReference);
            }

            builder.AppendLine("if (queryParameters.Count > 0)")
                .AppendLine("{").Indent()
                .AppendLine("{0} += \"?\" + string.Join(\"&\", queryParameters);", variableName).Outdent()
                .AppendLine("}");
        }

        private void ReplacePathParametersInUri(string variableName, IndentedStringBuilder builder)
        {
            foreach (var pathParameter in ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Path))
            {
                string replaceString = "{0} = {0}.Replace(\"{{{1}}}\", Uri.EscapeDataString({2}));";
                if (pathParameter.Extensions.ContainsKey(AzureCodeGenerator.SkipUrlEncodingExtension))
                {
                    replaceString = "{0} = {0}.Replace(\"{{{1}}}\", {2});";
                }

                builder.AppendLine(replaceString,
                    variableName,
                    pathParameter.Name,
                    pathParameter.Type.ToString(ClientReference, pathParameter.Name));
            }
        }

        private void ReplaceSubscriptionIdInUri(string variableName, IndentedStringBuilder builder)
        {
            if (this.Url != null && this.Url.Contains("{subscriptionId}") &&
                !ParameterTemplateModels.Any(p => p.SerializedName.Equals("subscriptionId", StringComparison.OrdinalIgnoreCase)))
            {
                builder
                    .AppendLine("if ({0}.Credentials == null)", ClientReference)
                    .AppendLine("{")
                    .Indent()
                    .AppendLine(
                        "throw new ArgumentNullException(\"Credentials\", \"SubscriptionCloudCredentials are missing from the client.\");")
                    .Outdent()
                    .AppendLine("}")
                    .AppendLine(
                        "{0} = {0}.Replace(\"{{subscriptionId}}\", Uri.EscapeDataString({1}.Credentials.SubscriptionId));",
                        variableName,
                        ClientReference);
            }
        }
    }
}