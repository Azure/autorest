// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Logging;
using AutoRest.Extensions.Azure;
using AutoRest.Extensions.Azure.Model;
using AutoRest.Ruby.Azure.Properties;
using AutoRest.Ruby.TemplateModels;
using IndentedStringBuilder = AutoRest.Core.Utilities.IndentedStringBuilder;
using Newtonsoft.Json;

namespace AutoRest.Ruby.Azure.TemplateModels
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
        /// Returns true if method has x-ms-pageable extension.
        /// </summary>
        public bool IsPageable
        {
            get { return Extensions.ContainsKey(AzureExtensions.PageableExtension); }
        }

        /// <summary>
        /// Returns invocation string for next method async.
        /// </summary>
        public string InvokeNextMethodAsync()
        {
            StringBuilder builder = new StringBuilder();
            string nextMethodName;
            PageableExtension pageableExtension = JsonConvert.DeserializeObject<PageableExtension>(Extensions[AzureExtensions.PageableExtension].ToString());

            Method nextMethod = null;
            if (pageableExtension != null && !string.IsNullOrEmpty(pageableExtension.OperationName))
            {
                nextMethod = ServiceClient.Methods.FirstOrDefault(m =>
                    pageableExtension.OperationName.Equals(m.SerializedName, StringComparison.OrdinalIgnoreCase));
                nextMethodName = nextMethod.Name;
            }
            else
            {
                nextMethodName = (string)Extensions["nextMethodName"];
                nextMethod = ServiceClient.Methods.Where(m => m.Name == nextMethodName).FirstOrDefault();
            }

            IEnumerable<Parameter> origMethodGroupedParameters = Parameters.Where(p => p.Name.Contains(Name));
            if (origMethodGroupedParameters.Count() > 0)
            {
                foreach (Parameter param in nextMethod.Parameters)
                {
                    if (param.Name.Contains(nextMethod.Name) && (param.Name.Length > nextMethod.Name.Length)) //parameter that contains the method name + postfix, it's a grouped param
                    {
                        //assigning grouped parameter passed to the lazy method, to the parameter used in the invocation to the next method
                        string argumentName = param.Name.Replace(nextMethodName, Name);
                        builder.AppendLine(string.Format(CultureInfo.InvariantCulture, "{0} = {1}", param.Name, argumentName));
                    }
                }
            }

            IList<string> headerParams = nextMethod.Parameters.Where(p => (p.Location == ParameterLocation.Header || p.Location == ParameterLocation.None) && !p.IsConstant && p.ClientProperty == null).Select(p => p.Name).ToList();
            headerParams.Add("custom_headers");
            string nextMethodParamaterInvocation = string.Join(", ", headerParams);

            builder.AppendLine(string.Format(CultureInfo.InvariantCulture, "{0}_async(next_link, {1})", nextMethodName, nextMethodParamaterInvocation));
            return builder.ToString();
        }

        /// <summary>
        /// Returns generated response or body of the auto-paginated method.
        /// </summary>
        public override string ResponseGeneration()
        {

            IndentedStringBuilder builder = new IndentedStringBuilder();
            if (ReturnType.Body != null)
            {
                if (ReturnType.Body is CompositeType)
                {
                    CompositeType compositeType = (CompositeType)ReturnType.Body;
                    if (compositeType.Extensions.ContainsKey(AzureExtensions.PageableExtension) && this.Extensions.ContainsKey("nextMethodName"))
                    {
                        bool isNextLinkMethod = this.Extensions.ContainsKey("nextLinkMethod") && (bool)this.Extensions["nextLinkMethod"];
                        bool isPageable = (bool)compositeType.Extensions[AzureExtensions.PageableExtension];
                        if (isPageable && !isNextLinkMethod)
                        {
                            builder.AppendLine("first_page = {0}_as_lazy({1})", Name, MethodParameterInvocation);
                            builder.AppendLine("first_page.get_all_items");
                            return builder.ToString();
                        }
                    }
                }
            }
            return base.ResponseGeneration();

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
        /// Generates Ruby code in form of string for deserializing polling response.
        /// </summary>
        /// <param name="variableName">Variable name which keeps the response.</param>
        /// <param name="type">Type of response.</param>
        /// <returns>Ruby code in form of string for deserializing polling response.</returns>
        public string DeserializePollingResponse(string variableName, IType type)
        {
            var builder = new IndentedStringBuilder("  ");

            string serializationLogic = GetDeserializationString(type, variableName, variableName);
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
                    "[MsRest::RetryPolicyMiddleware, times: 3, retry: 0.02]",
                    "[:cookie_jar]"
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

        /// <summary>
        /// Gets the type for operation result.
        /// </summary>
        public override string OperationReturnTypeString
        {
            get
            {
                if (Extensions.ContainsKey("nextMethodName") && (!Extensions.ContainsKey(AzureExtensions.PageableExtension) ||
                    (Extensions.ContainsKey(AzureExtensions.PageableExtension) && Extensions.ContainsKey(AzureExtensions.LongRunningExtension))))
                {
                    try
                    {
                        SequenceType sequenceType = ((CompositeType)ReturnType.Body).Properties.Select(p => p.Type).FirstOrDefault(t => t is SequenceType) as SequenceType;
                        return string.Format(CultureInfo.InvariantCulture, "Array<{0}>", sequenceType.ElementType.Name);
                    }
                    catch (NullReferenceException nr)
                    {
                        throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture, "No collection type exists in pageable operation return type: {0}", nr.StackTrace));
                    }
                }
                return base.OperationReturnTypeString;
            }
        }
    }
}