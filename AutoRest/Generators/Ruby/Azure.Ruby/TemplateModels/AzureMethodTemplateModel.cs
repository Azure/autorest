// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.Azure.NodeJS.Properties;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby;
using Microsoft.Rest.Generator.Ruby.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    /// <summary>
    /// The model object for Azure methods.
    /// </summary>
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
            if (source == null)
            {
                throw new ArgumentNullException("source");
            }

            ParameterTemplateModels.Clear();
            source.Parameters.ForEach(p => ParameterTemplateModels.Add(new AzureParameterTemplateModel(p)));

            this.ClientRequestIdString = AzureExtensions.GetClientRequestIdString(source);
            this.RequestIdString = AzureExtensions.GetRequestIdString(source);
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

        /// <summary>
        /// Gets the Get method model.
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
                    throw new InvalidOperationException(
                        string.Format(CultureInfo.InvariantCulture, Resources.InvalidLongRunningOperationForCreateOrUpdate,
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

            // Filling path parameters (which are directly in the url body).
            foreach (var pathParameter in ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Path))
            {
                string variableName = pathParameter.Type.ToString(pathParameter.Name);

                string addPathParameterString = String.Format(CultureInfo.InvariantCulture, "{0}['{{{1}}}'] = ERB::Util.url_encode({2}) if {0}.include?('{{{1}}}')",
                    inputVariableName,
                    pathParameter.SerializedName,
                    variableName);

                if (pathParameter.Extensions.ContainsKey(AzureExtensions.SkipUrlEncodingExtension))
                {
                    addPathParameterString = String.Format(CultureInfo.InvariantCulture, "{0}['{{{1}}}'] = {2} if {0}.include?('{{{1}}}')",
                        inputVariableName,
                        pathParameter.SerializedName,
                        variableName);
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

            foreach (var param in queryParametres)
            {
                bool hasSkipUrlExtension = param.Extensions.ContainsKey(AzureExtensions.SkipUrlEncodingExtension);

                if (hasSkipUrlExtension)
                {
                    builder.AppendLine("properties['{0}'] = {1} unless {1}.nil?", param.SerializedName, param.Name);
                }
                else
                {
                    builder.AppendLine("properties['{0}'] = ERB::Util.url_encode({1}.to_s) unless {1}.nil?", param.SerializedName, param.Name);
                }
            }

            builder.AppendLine(SaveExistingUrlItems("properties", outputVariableName));

            builder.AppendLine("properties.reject!{ |key, value| value.nil? }");
            builder.AppendLine("{0}.query = properties.map{{ |key, value| \"#{{key}}=#{{value}}\" }}.compact.join('&')", outputVariableName);

            builder.AppendLine(@"fail URI::Error unless {0}.to_s =~ /\A#{{URI::regexp}}\z/", outputVariableName);

            return builder.ToString();
        }

        /// <summary>
        /// Generates Ruby code in form of string for deserializing polling response.
        /// </summary>
        /// <param name="variableName">Variable name which keeps the response.</param>
        /// <param name="type">Type of response.</param>
        /// <returns>Ruby code in form of string for deserializing polling response.</returns>
        public string DeserializePollingResponse(string variableName, IType type)
        {
            var builder = new IndentedStringBuilder("  ");

            string serializationLogic = type.DeserializeType(this.Scope, variableName);
            return builder.AppendLine(serializationLogic).ToString();
        }

        /// <summary>
        /// Gets the logic required to preprocess response body when required.
        /// </summary>
        public override string InitializeResponseBody
        {
            get
            {
                var sb = new IndentedStringBuilder();

                if (this.HttpMethod == HttpMethod.Head && this.ReturnType.Body != null)
                {
                    HttpStatusCode code = this.Responses.Keys.FirstOrDefault(AzureExtensions.HttpHeadStatusCodeSuccessFunc);
                    sb.AppendLine("result.body = (status_code == {0})", (int)code);
                }

                sb.AppendLine(
                    "result.request_id = http_response['{0}'] unless http_response['{0}'].nil?", this.RequestIdString);

                sb.AppendLine(base.InitializeResponseBody);

                return sb.ToString();
            }
        }

        /// <summary>
        /// Gets the list of namespaces where we look for classes that need to
        /// be instantiated dynamically due to polymorphism.
        /// </summary>
        public override List<string> ClassNamespaces
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
        /// Gets the expression for default header setting.
        /// </summary>
        public override string SetDefaultHeaders
        {
            get
            {
                IndentedStringBuilder sb = new IndentedStringBuilder();
                sb.AppendLine("request_headers['{0}'] = SecureRandom.uuid", this.ClientRequestIdString)
                  .AppendLine(base.SetDefaultHeaders);
                return sb.ToString();
            }
        }

        /// <summary>
        /// Gets AzureOperationResponse generic type declaration.
        /// </summary>
        public override string OperationResponseReturnTypeString
        {
            get
            {
                return "MsRestAzure::AzureOperationResponse";
            }
        }

        /// <summary>
        /// Gets the list of middelwares required for HTTP requests.
        /// </summary>
        public override List<string> FaradeyMiddlewares
        {
            get
            {
                return new List<string>()
                {
                    "MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02",
                    ":cookie_jar"
                };
            }
        }

        /// <summary>
        /// Gets the type for operation exception.
        /// </summary>
        public override string OperationExceptionTypeString
        {
            get
            {
                if (DefaultResponse.Body == null || DefaultResponse.Body.Name == "CloudError")
                {
                    return "MsRestAzure::AzureOperationError";
                }

                return base.OperationExceptionTypeString;
            }
        }
    }
}