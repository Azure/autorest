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
        /// <param name="pathName">The variable to prepare url from.</param>
        /// <returns>Code for URL generation.</returns>
        public string BuildUrl(string pathName)
        {
            var builder = new IndentedStringBuilder("  ");
            
            // Filling path parameters (which are directly in the url body).
            if(ParameterTemplateModels.Any(p => p.Location == ParameterLocation.Path))
            {
                BuildPathParams(pathName, builder);                
            }
            
            builder.AppendLine("{0} = URI.parse({0})", pathName);

            // Filling query parameters (which are directly in the url query part).
            if(ParameterTemplateModels.Any(p => p.Location == ParameterLocation.Query))
            {
                BuildQueryParams(pathName, builder);                
            }

            return builder.ToString();
        }
        
        /// <summary>
        /// Generate code to build the path parameters and add replace them in the path.
        /// </summary>
        /// <param name="pathName">The name of the path variable.</param>
        /// <param name="builder">The string builder instance to use to build up the series of calls.</param>
        protected void BuildQueryParams(string pathName, IndentedStringBuilder builder)
        {
            var queryParametres = ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Query).ToList();
            var nonEncodedQueryParams = new List<string>();
            var encodedQueryParams = new List<string>();
            foreach (var param in queryParametres)
            {
                bool hasSkipUrlExtension = param.Extensions.ContainsKey(Generator.Extensions.SkipUrlEncodingExtension);

                if (hasSkipUrlExtension)
                {
                    nonEncodedQueryParams.Add(string.Format(CultureInfo.InvariantCulture, "'{0}' => {1}", param.SerializedName, param.Name));
                }
                else
                {
                    encodedQueryParams.Add(string.Format(CultureInfo.InvariantCulture, "'{0}' => {1}", param.SerializedName, param.Name));
                }
            }
            builder
                .AppendLine("params = {{{0}}}", string.Join(",", encodedQueryParams))
                .AppendLine("params.reject!{ |_, value| value.nil? }");
            
            if(nonEncodedQueryParams.Any())
            {
                builder
                    .AppendLine("skipEncodingQueryParams = {{{0}}}", string.Join(",", nonEncodedQueryParams))
                    .AppendLine("skipEncodingQueryParams.reject!{ |_, value| value.nil? }")
                    .AppendLine("{0}.query = skipEncodingQueryParams.map{{|k,v| \"#{{k}}=#{{v}}\"}}.join('&')", pathName);
                
            }
        }
        
        /// <summary>
        /// Generate code to build the path parameters and add replace them in the path.
        /// </summary>
        /// <param name="pathName">The name of the path variable.</param>
        /// <param name="builder">The string builder instance to use to build up the series of calls.</param>
        protected void BuildPathParams(string pathName, IndentedStringBuilder builder)
        {
            var nonEncodedPathParams = new List<string>();
            var encodedPathParams = new List<string>();
            foreach (var pathParameter in ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Path))
            {
                string variableName = pathParameter.Type.ToString(pathParameter.Name);
                if (pathParameter.Extensions.ContainsKey(Generator.Extensions.SkipUrlEncodingExtension))
                {
                    nonEncodedPathParams.Add(string.Format(CultureInfo.InvariantCulture, "'{0}' => {1}", pathParameter.SerializedName, variableName));
                }
                else
                {
                    encodedPathParams.Add(string.Format(CultureInfo.InvariantCulture, "'{0}' => {1}", pathParameter.SerializedName, variableName));
                }
            }
            
            builder
                .AppendLine("skipEncodingPathParams = {{{0}}}", string.Join(",", nonEncodedPathParams))
                .AppendLine("encodingPathParams = {{{0}}}", string.Join(",", encodedPathParams))
                .AppendLine("skipEncodingPathParams.each{{ |key, value| {0}[\"{{#{{key}}}}\"] = value }}", pathName)
                .AppendLine("encodingPathParams.each{{ |key, value| {0}[\"{{#{{key}}}}\"] = ERB::Util.url_encode(value) }}", pathName);
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
        public override IList<string> FaradayMiddlewares
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