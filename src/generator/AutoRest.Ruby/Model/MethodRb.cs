// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;

namespace AutoRest.Ruby.Model
{
    /// <summary>
    /// The model object for regular Ruby methods.
    /// </summary>
    public class MethodRb : Method
    {
        /// <summary>
        /// Initializes a new instance of the class MethodTemplateModel.
        /// </summary>
        public MethodRb()
        {
        }

        /// <summary>
        /// Gets the return type name for the underlying interface method
        /// </summary>
        public virtual string OperationResponseReturnTypeString
        {
            get
            {
                return "MsRest::HttpOperationResponse";
            }
        }

        /// <summary>
        /// Gets the type for operation exception
        /// </summary>
        public virtual string OperationExceptionTypeString
        {
            get
            {
                return "MsRest::HttpOperationError";
            }
        }

        /// <summary>
        /// Gets the code required to initialize response body.
        /// </summary>
        public virtual string InitializeResponseBody
        {
            get { return string.Empty; }
        }

        /// <summary>
        /// Gets the list of namespaces where we look for classes that need to
        /// be instantiated dynamically due to polymorphism.
        /// </summary>
        public virtual IEnumerable<string> ClassNamespaces => Enumerable.Empty<string>();

        /// <summary>
        /// Gets the path parameters as a Ruby dictionary string
        /// </summary>
        public virtual string PathParamsRbDict
        {
            get
            {
                return ParamsToRubyDict(EncodingPathParams);
            }
        }

        /// <summary>
        /// Gets the skip encoding path parameters as a Ruby dictionary string
        /// </summary>
        public virtual string SkipEncodingPathParamsRbDict
        {
            get
            {
                return ParamsToRubyDict(SkipEncodingPathParams);
            }
        }

        /// <summary>
        /// Gets the query parameters as a Ruby dictionary string
        /// </summary>
        public virtual string QueryParamsRbDict
        {
            get
            {
                return ParamsToRubyDict(EncodingQueryParams);
            }
        }

        /// <summary>
        /// Gets the skip encoding query parameters as a Ruby dictionary string
        /// </summary>
        public virtual string SkipEncodingQueryParamsRbDict
        {
            get
            {
                return ParamsToRubyDict(SkipEncodingQueryParams);
            }
        }

        /// <summary>
        /// Gets the path parameters not including the params that skip encoding
        /// </summary>
        public virtual IEnumerable<ParameterRb> EncodingPathParams
        {
            get
            {
                return AllPathParams.Where(p => !(p.Extensions.ContainsKey(SwaggerExtensions.SkipUrlEncodingExtension) &&
                  "true".EqualsIgnoreCase(p.Extensions[SwaggerExtensions.SkipUrlEncodingExtension].ToString())));
            }
        }

        /// <summary>
        /// Gets the skip encoding path parameters
        /// </summary>
        public virtual IEnumerable<ParameterRb> SkipEncodingPathParams
        {
            get
            {
                return AllPathParams.Where(p =>
                    (p.Extensions.ContainsKey(SwaggerExtensions.SkipUrlEncodingExtension) &&
                    "true".EqualsIgnoreCase(p.Extensions[SwaggerExtensions.SkipUrlEncodingExtension].ToString()) &&
                    !p.Extensions.ContainsKey("hostParameter")));
            }
        }

        /// <summary>
        /// Gets all path parameters
        /// </summary>
        public virtual IEnumerable<ParameterRb> AllPathParams
        {
            get { return LogicalParameterTemplateModels.Where(p => p.Location == ParameterLocation.Path); }
        }

        /// <summary>
        /// Gets the skip encoding query parameters
        /// </summary>
        public virtual IEnumerable<ParameterRb> SkipEncodingQueryParams
        {
            get { return AllQueryParams.Where(p => p.Extensions.ContainsKey(SwaggerExtensions.SkipUrlEncodingExtension)); }
        }

        /// <summary>
        /// Gets the query parameters not including the params that skip encoding
        /// </summary>
        public virtual IEnumerable<ParameterRb> EncodingQueryParams
        {
            get { return AllQueryParams.Where(p => !p.Extensions.ContainsKey(SwaggerExtensions.SkipUrlEncodingExtension)); }
        }

        /// <summary>
        /// Gets all of the query parameters
        /// </summary>
        public virtual IEnumerable<ParameterRb> AllQueryParams
        {
            get
            {
                return LogicalParameterTemplateModels.Where(p => p.Location == ParameterLocation.Query);
            }
        }

        /// <summary>
        /// Gets the list of middelwares required for HTTP requests.
        /// </summary>
        public virtual IList<string> FaradayMiddlewares
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
        /// Gets the expression for default header setting.
        /// </summary>
        public virtual string SetDefaultHeaders
        {
            get
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// Gets the list of method paramater templates.
        /// </summary>
        public IEnumerable<ParameterRb> ParameterTemplateModels => Parameters.Cast<ParameterRb>();

        /// <summary>
        /// Gets the list of logical method paramater templates.
        /// </summary>
        private IEnumerable<ParameterRb> LogicalParameterTemplateModels => LogicalParameters.Cast<ParameterRb>();

        /// <summary>
        /// Gets the list of parameter which need to be included into HTTP header.
        /// </summary>
        public IEnumerable<Parameter> Headers
        {
            get
            {
                return Parameters.Where(p => p.Location == ParameterLocation.Header);
            }
        }

        /// <summary>
        /// Gets the URL without query parameters.
        /// </summary>
        public string UrlWithoutParameters
        {
            get
            {
                return ((string)Url).Split('?').First();
            }
        }

        /// <summary>
        /// Get the predicate to determine of the http operation status code indicates success
        /// </summary>
        public string SuccessStatusCodePredicate
        {
            get
            {
                if (Responses.Any())
                {
                    List<string> predicates = new List<string>();
                    foreach (var responseStatus in Responses.Keys)
                    {
                        predicates.Add(string.Format("status_code == {0}", GetStatusCodeReference(responseStatus)));
                    }

                    return string.Join(" || ", predicates);
                }

                return "status_code >= 200 && status_code < 300";
            }
        }

        /// <summary>
        /// Gets the method parameter declaration parameters list.
        /// </summary>
        public string MethodParameterDeclaration
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in MethodParameters.Where(p => !p.IsConstant))
                {
                    string format = "{0}";
                    if (!parameter.IsRequired)
                    {
                        format = "{0} = nil";
                        if (!parameter.DefaultValue.IsNullOrEmpty()&& parameter.ModelType is PrimaryType)
                        {
                            PrimaryType type = parameter.ModelType as PrimaryType;
                            if (type != null)
                            {
                                if (type.KnownPrimaryType == KnownPrimaryType.Boolean || type.KnownPrimaryType == KnownPrimaryType.Double ||
                                    type.KnownPrimaryType == KnownPrimaryType.Int || type.KnownPrimaryType == KnownPrimaryType.Long || type.KnownPrimaryType == KnownPrimaryType.String)
                                {
                                    format = "{0} = " + parameter.DefaultValue;
                                }
                            }
                        }
                    }
                    declarations.Add(string.Format(format, parameter.Name));
                }

                declarations.Add("custom_headers = nil");

                return string.Join(", ", declarations);
            }
        }

        /// <summary>
        /// Gets the method parameter invocation parameters list.
        /// </summary>
        public string MethodParameterInvocation
        {
            get
            {
                var invocationParams = MethodParameters.Where(p => !p.IsConstant).Select(p => p.Name).ToList();
                invocationParams.Add("custom_headers");

                return string.Join(", ", invocationParams);
            }
        }

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they appear in the method signature
        /// exclude global parameters
        /// </summary>
        public IEnumerable<ParameterRb> MethodParameters
        {
            get
            {
                //Omit parameter group parameters for now since AutoRest-Ruby doesn't support them
                return
                    ParameterTemplateModels.Where(p => p != null && !p.IsClientProperty && !string.IsNullOrWhiteSpace(p.Name) &&!p.IsConstant)
                        .OrderBy(item => !item.IsRequired);
            }
        }

        /// <summary>
        /// Get the method's request body (or null if there is no request body)
        /// </summary>
        public ParameterRb RequestBody
        {
            get { return LogicalParameterTemplateModels.FirstOrDefault(p => p.Location == ParameterLocation.Body); }
        }

        /// <summary>
        /// Generate a reference to the ServiceClient
        /// </summary>
        public string UrlReference
        {
            get { return true == MethodGroup?.IsCodeModelMethodGroup? "@base_url" : "@client.base_url"; }
        }

        /// <summary>
        /// Generate a reference to the ServiceClient
        /// </summary>
        public string ClientReference
        {
            get { return true == MethodGroup?.IsCodeModelMethodGroup ? "self" : "@client"; }
        }

        /// <summary>
        /// Gets the flag indicating whether URL contains path parameters.
        /// </summary>
        public bool UrlWithPath
        {
            get
            {
                return ParameterTemplateModels.Any(p => p.Location == ParameterLocation.Path);
            }
        }

        /// <summary>
        /// Gets the type for operation result.
        /// </summary>
        public virtual string OperationReturnTypeString
        {
            get
            {
                return ReturnType.Body.Name.ToString();
            }
        }

        /// <summary>
        /// Creates a code in form of string which deserializes given input variable of given type.
        /// </summary>
        /// <param name="inputVariable">The input variable.</param>
        /// <param name="type">The type of input variable.</param>
        /// <param name="outputVariable">The output variable.</param>
        /// <returns>The deserialization string.</returns>
        public virtual string CreateDeserializationString(string inputVariable, IModelType type, string outputVariable)
        {
            var builder = new IndentedStringBuilder("  ");
            var tempVariable = "parsed_response";

            // Firstly parsing the input json file into temporay variable.
            builder.AppendLine("{0} = {1}.to_s.empty? ? nil : JSON.load({1})", tempVariable, inputVariable);

            // Secondly parse each js object into appropriate Ruby type (DateTime, Byte array, etc.)
            // and overwrite temporary variable value.
            string deserializationLogic = GetDeserializationString(type, outputVariable, tempVariable);
            builder.AppendLine(deserializationLogic);

            // Assigning value of temporary variable to the output variable.
            return builder.ToString();
        }

        /// <summary>
        /// Saves url items from the URL into collection.
        /// </summary>
        /// <param name="hashName">The name of the collection save url items to.</param>
        /// <param name="variableName">The URL variable.</param>
        /// <returns>Generated code of saving url items.</returns>
        public virtual string SaveExistingUrlItems(string hashName, string variableName)
        {
            var builder = new IndentedStringBuilder("  ");

            // Saving existing URL properties into properties hash.
            builder
                .AppendLine("unless {0}.query.nil?", variableName)
                .Indent()
                    .AppendLine("{0}.query.split('&').each do |url_item|", variableName)
                    .Indent()
                        .AppendLine("url_items_parts = url_item.split('=')")
                        .AppendLine("{0}[url_items_parts[0]] = url_items_parts[1]", hashName)
                    .Outdent()
                    .AppendLine("end")
                .Outdent()
                .AppendLine("end");

            return builder.ToString();
        }

        /// <summary>
        /// Ensures that there is no duplicate forward slashes in the url.
        /// </summary>
        /// <param name="urlVariableName">The url variable.</param>
        /// <returns>Updated url.</returns>
        public virtual string RemoveDuplicateForwardSlashes(string urlVariableName)
        {
            var builder = new IndentedStringBuilder("  ");

            // Removing duplicate forward slashes.
            builder.AppendLine(@"corrected_url = {0}.to_s.gsub(/([^:])\/\//, '\1/')", urlVariableName);
            builder.AppendLine(@"{0} = URI.parse(corrected_url)", urlVariableName);

            return builder.ToString();
        }

        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the url in.</param>
        /// <returns></returns>
        public virtual string BuildUrl(string variableName)
        {
            var builder = new IndentedStringBuilder("  ");
            BuildPathParameters(variableName, builder);

            return builder.ToString();
        }

        /// <summary>
        /// Build parameter mapping from parameter grouping transformation.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildInputParameterMappings()
        {
            var builder = new IndentedStringBuilder("  ");
            if (InputParameterTransformation.Count > 0)
            {
                builder.Indent();
                foreach (var transformation in InputParameterTransformation)
                {
                    if (transformation.OutputParameter.ModelType is CompositeType &&
                        transformation.OutputParameter.IsRequired)
                    {
                        builder.AppendLine("{0} = {1}.new",
                            transformation.OutputParameter.Name,
                            transformation.OutputParameter.ModelType.Name);
                    }
                    else
                    {
                        builder.AppendLine("{0} = nil", transformation.OutputParameter.Name);
                    }
                }
                foreach (var transformation in InputParameterTransformation)
                {
                    builder.AppendLine("unless {0}", BuildNullCheckExpression(transformation))
                           .AppendLine().Indent();
                    var outputParameter = transformation.OutputParameter;
                    if (transformation.ParameterMappings.Any(m => !string.IsNullOrEmpty(m.OutputParameterProperty)) &&
                        transformation.OutputParameter.ModelType is CompositeType)
                    {
                        //required outputParameter is initialized at the time of declaration
                        if (!transformation.OutputParameter.IsRequired)
                        {
                            builder.AppendLine("{0} = {1}.new",
                                transformation.OutputParameter.Name,
                                transformation.OutputParameter.ModelType.Name);
                        }
                    }

                    foreach (var mapping in transformation.ParameterMappings)
                    {
                        builder.AppendLine("{0}{1}", transformation.OutputParameter.Name, mapping);
                    }

                    builder.Outdent().AppendLine("end");
                }
            }
            return builder.ToString();
        }

        /// <summary>
        /// Generates response or body of method
        /// </summary>
        public virtual string ResponseGeneration()
        {
            IndentedStringBuilder builder = new IndentedStringBuilder("");
            builder.AppendLine("response = {0}_async({1}).value!", Name, MethodParameterInvocation);
            if (ReturnType.Body != null)
            {
                builder.AppendLine("response.body unless response.nil?");
            }
            else
            {
                builder.AppendLine("nil");
            }
            return builder.ToString();
        }

        /// <summary>
        /// Gets the formatted status code.
        /// </summary>
        /// <param name="code">The status code.</param>
        /// <returns>Formatted status code.</returns>
        public string GetStatusCodeReference(HttpStatusCode code)
        {
            return string.Format("{0}", (int)code);
        }

        /// <summary>
        /// Generate code to replace path parameters in the url template with the appropriate values
        /// </summary>
        /// <param name="variableName">The variable name for the url to be constructed</param>
        /// <param name="builder">The string builder for url construction</param>
        protected virtual void BuildPathParameters(string variableName, IndentedStringBuilder builder)
        {
            if (builder == null)
            {
                throw new ArgumentNullException("builder");
            }

            IEnumerable<Parameter> pathParameters = LogicalParameters.Where(p => p.Extensions.ContainsKey("hostParameter") && p.Location == ParameterLocation.Path);

            foreach (var pathParameter in pathParameters)
            {
                var pathReplaceFormat = "{0} = {0}.gsub('{{{1}}}', {2})";
                builder.AppendLine(pathReplaceFormat, variableName, pathParameter.SerializedName, pathParameter.GetFormattedReferenceValue());
            }
        }

        /// <summary>
        /// Builds the parameters as a Ruby dictionary string
        /// </summary>
        /// <param name="parameters">The enumerable of parameters to be turned into a Ruby dictionary.</param>
        /// <returns>ruby dictionary as a string</returns>
        protected string ParamsToRubyDict(IEnumerable<ParameterRb> parameters)
        {
            var encodedParameters = new List<string>();
            foreach (var param in parameters)
            {
                string variableName = param.Name;
                encodedParameters.Add(string.Format("'{0}' => {1}", param.SerializedName, param.GetFormattedReferenceValue()));
            }
            return string.Format(CultureInfo.InvariantCulture, "{{{0}}}", string.Join(",", encodedParameters));
        }
        
        /// <summary>
        /// Constructs mapper for the request body.
        /// </summary>
        /// <param name="outputVariable">Name of the output variable.</param>
        /// <returns>Mapper for the request body as string.</returns>
        public string ConstructRequestBodyMapper(string outputVariable = "request_mapper")
        {
            var builder = new IndentedStringBuilder("  ");
            if (RequestBody.ModelType is CompositeType)
            {
                builder.AppendLine("{0} = {1}.mapper()", outputVariable, RequestBody.ModelType.Name);
            }
            else
            {
                builder.AppendLine("{0} = {{{1}}}", outputVariable,
                    RequestBody.ModelType.ConstructMapper(RequestBody.SerializedName, RequestBody, false));
            }
            return builder.ToString();
        }

        /// <summary>
        /// Creates deserialization logic for the given <paramref name="type"/>.
        /// </summary>
        /// <param name="type">Type for which deserialization logic being constructed.</param>
        /// <param name="valueReference">Reference variable name.</param>
        /// <param name="responseVariable">Response variable name.</param>
        /// <returns>Deserialization logic for the given <paramref name="type"/> as string.</returns>
        /// <exception cref="ArgumentNullException">Thrown when a required parameter is null.</exception>
        public string GetDeserializationString(IModelType type, string valueReference = "result", string responseVariable = "parsed_response")
        {
            if (type == null)
            {
                throw new ArgumentNullException(nameof(type));
            }

            var builder = new IndentedStringBuilder("  ");
            if (type is CompositeType)
            {
                builder.AppendLine("result_mapper = {0}.mapper()", type.Name);
            }
            else
            {
                builder.AppendLine("result_mapper = {{{0}}}", type.ConstructMapper(responseVariable, null, false));
            }
            if (MethodGroup.IsCodeModelMethodGroup)
            {
                builder.AppendLine("{1} = self.deserialize(result_mapper, {0}, '{1}')", responseVariable, valueReference);
            }
            else
            {
                builder.AppendLine("{1} = @client.deserialize(result_mapper, {0}, '{1}')", responseVariable, valueReference);
            }

            return builder.ToString();
        }

        /// <summary>
        /// Builds null check expression for the given <paramref name="transformation"/>.
        /// </summary>
        /// <param name="transformation">ParameterTransformation for which to build null check expression.</param>
        /// <returns></returns>
        private static string BuildNullCheckExpression(ParameterTransformation transformation)
        {
            if (transformation == null)
            {
                throw new ArgumentNullException("transformation");
            }
            if (transformation.ParameterMappings.Count == 1)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "{0}.nil?", transformation.ParameterMappings[0].InputParameter.Name);
            }
            else
            {
                return string.Join(" && ",
                transformation.ParameterMappings.Select(m =>
                    string.Format(CultureInfo.InvariantCulture,
                    "{0}.nil?", m.InputParameter.Name)));
            }
        }
    }
}