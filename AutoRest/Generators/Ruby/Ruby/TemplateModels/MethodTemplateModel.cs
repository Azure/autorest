// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
{
    /// <summary>
    /// The model object for regular Ruby methods.
    /// </summary>
    public class MethodTemplateModel : Method
    {
        /// <summary>
        /// The scope provider (used for creating new variables with non-conflict names).
        /// </summary>
        private readonly IScopeProvider scopeProvider = new ScopeProvider();

        /// <summary>
        /// Gets the scope.
        /// </summary>
        public IScopeProvider Scope
        {
            get { return scopeProvider; }
        }

        /// <summary>
        /// Initializes a new instance of the class MethodTemplateModel.
        /// </summary>
        /// <param name="source">The source object.</param>
        /// <param name="serviceClient">The service client.</param>
        public MethodTemplateModel(Method source, ServiceClient serviceClient)
        {
            this.LoadFrom(source);
            ParameterTemplateModels = new List<ParameterTemplateModel>();
            source.Parameters.ForEach(p => ParameterTemplateModels.Add(new ParameterTemplateModel(p)));
            ServiceClient = serviceClient;
        }

        /// <summary>
        /// Gets the reference to the service client object.
        /// </summary>
        public ServiceClient ServiceClient { get; set; }

        /// <summary>
        /// Gets the list of method paramater templates.
        /// </summary>
        public List<ParameterTemplateModel> ParameterTemplateModels { get; private set; }

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
                return this.Url.Split('?').First();
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
                foreach (var parameter in LocalParameters)
                {
                    string format = "{0}";
                    if (!parameter.IsRequired)
                    {
                        format = "{0} = nil";
                        if (parameter.DefaultValue != null && parameter.Type is PrimaryType)
                        {
                            PrimaryType type = parameter.Type as PrimaryType;
                            if (type == PrimaryType.Boolean || type == PrimaryType.Double || type == PrimaryType.Int || type == PrimaryType.Long)
                            {
                                format = "{0} = " + parameter.DefaultValue;
                            }
                            else if (type == PrimaryType.String)
                            {
                                format = "{0} = \"" + parameter.DefaultValue + "\"";
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
                var invocationParams = LocalParameters.Select(p => p.Name).ToList();
                invocationParams.Add("custom_headers");

                return string.Join(", ", invocationParams);
            }
        }

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they appear in the method signature
        /// exclude global parameters
        /// </summary>
        public IEnumerable<ParameterTemplateModel> LocalParameters
        {
            get
            {
                //Omit parameter group parameters for now since AutoRest-Ruby doesn't support them
                return
                    ParameterTemplateModels.Where(
                        p => p != null && p.ClientProperty == null && !string.IsNullOrWhiteSpace(p.Name))
                        .OrderBy(item => !item.IsRequired);
            }
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
        public virtual List<string> ClassNamespaces
        {
            get
            {
                return new List<string> { };
            }
        }

        /// <summary>
        /// Get the method's request body (or null if there is no request body)
        /// </summary>
        public ParameterTemplateModel RequestBody
        {
            get { return ParameterTemplateModels.FirstOrDefault(p => p.Location == ParameterLocation.Body); }
        }

        /// <summary>
        /// Generate a reference to the ServiceClient
        /// </summary>
        public string UrlReference
        {
            get { return Group == null ? "@base_url" : "@client.base_url"; }
        }

        /// <summary>
        /// Generate a reference to the ServiceClient
        /// </summary>
        public string ClientReference
        {
            get { return Group == null ? "self" : "@client"; }
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
        /// Gets the formatted status code.
        /// </summary>
        /// <param name="code">The status code.</param>
        /// <returns>Formatted status code.</returns>
        public string GetStatusCodeReference(HttpStatusCode code)
        {
            return string.Format("{0}", (int)code);
        }

        /// <summary>
        /// Creates a code in form of string which deserializes given input variable of given type.
        /// </summary>
        /// <param name="inputVariable">The input variable.</param>
        /// <param name="type">The type of input variable.</param>
        /// <param name="outputVariable">The output variable.</param>
        /// <returns>The deserialization string.</returns>
        public virtual string CreateDeserializationString(string inputVariable, IType type, string outputVariable)
        {
            var builder = new IndentedStringBuilder("  ");
            var tempVariable = "parsed_response";

            // Firstly parsing the input json file into temporay variable.
            builder.AppendLine("{0} = JSON.load({1}) unless {1}.to_s.empty?", tempVariable, inputVariable);

            // Secondly parse each js object into appropriate Ruby type (DateTime, Byte array, etc.)
            // and overwrite temporary variable variable value.
            string deserializationLogic = type.DeserializeType(this.Scope, tempVariable);
            builder.AppendLine(deserializationLogic);

            // Assigning value of temporary variable to the output variable.
            return builder.AppendLine("{0} = {1}", outputVariable, tempVariable).ToString();
        }

        /// <summary>
        /// Creates a code in form of string which serializes given input variable of given type.
        /// </summary>
        /// <param name="inputVariable">The input variable.</param>
        /// <param name="type">The type of input variable.</param>
        /// <param name="outputVariable">The output variable.</param>
        /// <returns>The serialization code.</returns>
        public virtual string CreateSerializationString(string inputVariable, IType type, string outputVariable)
        {
            var builder = new IndentedStringBuilder("  ");

            // Firstly recursively serialize each component of the object.
            string serializationLogic = type.SerializeType(this.Scope, inputVariable);

            builder.AppendLine(serializationLogic);

            // After that - generate JSON object after serializing each component.
            return builder.AppendLine("{0} = JSON.generate({1}, quirks_mode: true)", outputVariable, inputVariable).ToString();
        }

        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters.
        /// </summary>
        /// <param name="inputVariableName">The variable to prepare url from.</param>
        /// <param name="outputVariableName">The variable that will keep the url.</param>
        /// <returns>Code for URL generation.</returns>
        public virtual string BuildUrl(string inputVariableName, string outputVariableName)
        {
            var builder = new IndentedStringBuilder("  ");

            // Filling path parameters (which are directly in the url body).
            foreach (var pathParameter in ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Path))
            {
                builder.AppendLine("{0}['{{{1}}}'] = ERB::Util.url_encode({2}) if {0}.include?('{{{1}}}')",
                    inputVariableName,
                    pathParameter.SerializedName,
                    pathParameter.Type.ToString(pathParameter.Name));
            }

            // Adding prefix in case of not absolute url.
            if (!this.IsAbsoluteUrl)
            {
                builder.AppendLine("{0} = URI.join({1}.base_url, {2})", outputVariableName, ClientReference, inputVariableName);
            }

            // Filling query parameters (which are directly in the url query part).
            var queryParametres = ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Query).ToList();

            if (queryParametres.Any())
            {
                builder.AppendLine("properties = {{ {0} }}",
                    string.Join(", ", queryParametres.Select(x => string.Format("'{0}' => {1}", x.SerializedName, x.Name))));

                builder.AppendLine(SaveExistingUrlItems("properties", outputVariableName));

                builder.AppendLine("properties.reject!{ |key, value| value.nil? }");
                builder.AppendLine("{0}.query = properties.map{{ |key, value| \"#{{key}}=#{{ERB::Util.url_encode(value.to_s)}}\" }}.compact.join('&')", outputVariableName);
            }

            builder
                .AppendLine(@"fail URI::Error unless {0}.to_s =~ /\A#{{URI::regexp}}\z/", outputVariableName);

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
        /// Gets the list of middelwares required for HTTP requests.
        /// </summary>
        public virtual List<string> FaradeyMiddlewares
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
        /// Gets the expression for default header setting.
        /// </summary>
        public virtual string SetDefaultHeaders
        {
            get
            {
                return string.Empty;
            }
        }
    }
}
