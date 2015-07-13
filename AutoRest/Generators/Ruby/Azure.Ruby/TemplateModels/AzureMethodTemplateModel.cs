// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Linq;
using Microsoft.Rest.Generator.Azure.NodeJS.Properties;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby;
using Microsoft.Rest.Generator.Ruby.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    public class AzureMethodTemplateModel : MethodTemplateModel
    {
        /// <summary>
        /// Initializes a new instance of the AzureMethodTemplateModel class.
        /// </summary>
        /// <param name="source">The method current model is built for.</param>
        /// <param name="serviceClient">The service client - main point of access to the SDK.</param>
        public AzureMethodTemplateModel(Method source, ServiceClient serviceClient)
            : base(source, serviceClient)
        {
            ParameterTemplateModels.Clear();
            source.Parameters.ForEach(p => ParameterTemplateModels.Add(new AzureParameterTemplateModel(p)));
        }

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation
        {
            get { return Extensions.ContainsKey(AzureCodeGenerator.LongRunningExtension); }
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
                        string.Format(Resources.InvalidLongRunningOperationForCreateOrUpdate,
                            Name, Group));
                }
                return new AzureMethodTemplateModel(getMethod, ServiceClient);
            }
        }

        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters.
        /// </summary>
        /// <param name="inputVariableName">The variable to prepare url from.</param>
        /// <param name="outputVariableName">The variable that will keep the url.</param>
        /// <returns>Code for URL generation.</returns>
        public override string BuildUrl(string inputVariableName, string outputVariableName)
        {
            var builder = new IndentedStringBuilder("  ");

            // Adding SubscriptionId parameter from the Credentials object.
            if (this.Url != null && this.Url.Contains("{subscriptionId}")
                && !ParameterTemplateModels.Any(p => p.SerializedName.Equals("subscriptionId", StringComparison.OrdinalIgnoreCase)))
            {
                builder
                    .AppendLine("if ({0}.credentials.nil?)", ClientReference)
                        .Indent()
                        .AppendLine("fail ArgumentError(\"SubscriptionCloudCredentials are missing from the client.\");")
                        .Outdent()
                    .AppendLine("end")
                    .AppendLine("{0}['{{subscriptionId}}'] = {1}.credentials.subscriptionId", inputVariableName, ClientReference);
            }

            // Filling path parameters (which are directly in the url body).
            foreach (var pathParameter in ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Path))
            {
                string addPathParameterString = String.Format("{0}['{{{1}}}'] = CGI.escape({2})",
                    inputVariableName,
                    pathParameter.SerializedName,
                    pathParameter.Type.ToString(pathParameter.Name));

                if (pathParameter.Extensions.ContainsKey(AzureCodeGenerator.SkipUrlEncodingExtension))
                {
                    addPathParameterString = String.Format("{0}['{{{1}}}'] = {2}",
                        inputVariableName,
                        pathParameter.SerializedName,
                        pathParameter.Type.ToString(pathParameter.Name));
                }

                builder.AppendLine(addPathParameterString);
            }

            // Adding prefix in case of not absolute url.
            if (!this.IsAbsoluteUrl)
            {
                builder.AppendLine("{0} = URI.join({1}.base_url, {2})", outputVariableName, ClientReference, inputVariableName);
            }
            else
            {
                builder.AppendLine("{0} = URI.parse({1})", outputVariableName, inputVariableName);
            }

            // Filling query parameters (which are directly in the url query part). 
            var queryParametres = ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Query).ToList();

            builder.AppendLine("properties = {}");

            if (queryParametres.Any())
            {
                builder.AppendLine(string.Join(", ",
                    queryParametres.Select(x => string.Format("properties['{0}'] = {1}", x.SerializedName, x.Name))));

            }

            if (!Parameters.Any(p => p.Name.Equals("apiVersion", StringComparison.OrdinalIgnoreCase)) && !IsAbsoluteUrl)
            {
                builder.AppendLine("properties['api-version'] = CGI.escape({0}.api_version)", ClientReference);
            }

            builder.AppendLine("properties.reject!{ |key, value| value.nil? }");
            builder.AppendLine("{0}.query = properties.map{{ |key, value| \"#{{key}}=#{{CGI.escape(value.to_s)}}\" }}.compact.join('&')", outputVariableName);

            builder.AppendLine(@"fail URI::Error unless {0}.to_s =~ /\A#{{URI::regexp}}\z/", outputVariableName);

            // TODO: maybe more specific azure stuff is required.

            return builder.ToString();
        }

        public string DeserializePollingResponse(string variableName, IType type, bool isRequired, string defaultNamespace)
        {
            // TODO: handle required property via "unless deserialized_property.nil?"

            var builder = new IndentedStringBuilder("  ");

            string serializationLogic = type.DeserializeType(this.Scope, variableName, defaultNamespace);
            return builder.AppendLine(serializationLogic).ToString();
        }

        public override string InitializeResponseBody
        {
            get
            {
                if (this.HttpMethod == HttpMethod.Head && this.ReturnType != null)
                {
                    return "result.body = (status_code == 204)";
                }

                return base.InitializeResponseBody;
            }
        }

        ///// <summary>
        ///// Returns AzureOperationResponse generic type declaration.
        ///// </summary>
        //public override string OperationResponseReturnTypeString
        //{
        //    get
        //    {
        //        if (ReturnType != null)
        //        {
        //            return string.Format("AzureOperationResponse<{0}>", ReturnType.Name);
        //        }
        //        else
        //        {
        //            return "AzureOperationResponse";
        //        }
        //    }
        //}

        ///// <summary>
        ///// Get the type for operation exception.
        ///// </summary>
        //public override string OperationExceptionTypeString
        //{
        //    get
        //    {
        //        if (DefaultResponse == null || DefaultResponse.Name == "CloudError")
        //        {
        //            return "CloudException";
        //        }
        //        return base.OperationExceptionTypeString;
        //    }
        //}


        ///// <summary>
        ///// Gets the expression for response body initialization 
        ///// </summary>
        //public override string InitializeResponseBody
        //{
        //    get
        //    {
        //        if (this.HttpMethod == HttpMethod.Head &&
        //            this.ReturnType != null)
        //        {
        //            return "result.Body = (statusCode == HttpStatusCode.NoContent);";
        //        }
        //        return base.InitializeResponseBody;
        //    }
        //}

        ///// <summary>
        ///// Generate code to build the URL from a url expression and method parameters
        ///// </summary>
        ///// <param name="variableName">The variable to store the url in.</param>
        ///// <returns></returns>
        //public override string BuildUrl(string variableName)
        //{
        //    var builder = new IndentedStringBuilder(IndentedStringBuilder.FourSpaces);

        //    if (this.Url != null && this.Url.Contains("{subscriptionId}") 
        //        && !ParameterTemplateModels.Any(p => p.SerializedName.Equals("subscriptionId", StringComparison.OrdinalIgnoreCase)))
        //    {
        //        builder
        //            .AppendLine("if ({0}.Credentials == null)", ClientReference)
        //            .AppendLine("{")
        //                .Indent()
        //                .AppendLine("throw new ArgumentNullException(\"Credentials\", \"SubscriptionCloudCredentials are missing from the client.\");").Outdent()
        //            .AppendLine("}")
        //            .AppendLine("{0} = {0}.Replace(\"{{subscriptionId}}\", Uri.EscapeDataString({1}.Credentials.SubscriptionId));",
        //                    variableName,
        //                    ClientReference);
        //    }

        //    foreach (var pathParameter in ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Path))
        //    {
        //        string replaceString = "{0} = {0}.Replace(\"{{{1}}}\", Uri.EscapeDataString({2}));";
        //        if (pathParameter.Extensions.ContainsKey(AzureCodeGenerator.SkipUrlEncodingExtension))
        //        {
        //            replaceString = "{0} = {0}.Replace(\"{{{1}}}\", {2});";
        //        }

        //        builder.AppendLine(replaceString,
        //            variableName,
        //            pathParameter.Name,
        //            // pathParameter.Type.ToString(ClientReference, pathParameter.Name));
        //            // TODO: fix it.
        //            pathParameter.Type.ToString());
        //    }

        //    builder.AppendLine("List<string> queryParameters = new List<string>();");
        //    if (ParameterTemplateModels.Any(p => p.Location == ParameterLocation.Query))
        //    {
        //        foreach (var queryParameter in ParameterTemplateModels
        //            .Where(p => p.Location == ParameterLocation.Query))
        //        {
        //            string queryParametersAddString =
        //                "queryParameters.Add(string.Format(\"{0}={{0}}\", Uri.EscapeDataString({1})));";

        //            if (queryParameter.SerializedName.Equals("$filter", StringComparison.OrdinalIgnoreCase) &&
        //                queryParameter.Type is CompositeType &&
        //                queryParameter.Location == ParameterLocation.Query)
        //            {
        //                queryParametersAddString =
        //                    "queryParameters.Add(string.Format(\"{0}={{0}}\", FilterString.Generate(filter)));";
        //            }
        //            else if (queryParameter.Extensions.ContainsKey(AzureCodeGenerator.SkipUrlEncodingExtension))
        //            {
        //                queryParametersAddString = "queryParameters.Add(string.Format(\"{0}={{0}}\", {1}));";
        //            }

        //            builder.AppendLine("if ({0} != null)", queryParameter.Name)
        //                .AppendLine("{").Indent()
        //                .AppendLine(queryParametersAddString,
        //                    queryParameter.SerializedName, queryParameter.GetFormattedReferenceValue())
        //                .Outdent()
        //                .AppendLine("}");
        //        }
        //    }

        //    if (!Parameters.Any(p => p.Name.Equals("apiVersion", StringComparison.OrdinalIgnoreCase)) &&
        //        !IsAbsoluteUrl)
        //    {
        //        builder.AppendLine(
        //            "queryParameters.Add(string.Format(\"api-version={{0}}\", Uri.EscapeDataString({0}.ApiVersion)));",
        //            ClientReference);
        //    }
        //    builder.AppendLine("if (queryParameters.Count > 0)")
        //        .AppendLine("{").Indent()
        //        .AppendLine("{0} += \"?\" + string.Join(\"&\", queryParameters);", variableName).Outdent()
        //        .AppendLine("}");

        //    return builder.ToString();
        //}
    }
}