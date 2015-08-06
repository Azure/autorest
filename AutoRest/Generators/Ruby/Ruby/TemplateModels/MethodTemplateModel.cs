// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

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
        private readonly IScopeProvider scopeProvider = new ScopeProvider();

        public MethodTemplateModel(Method source, ServiceClient serviceClient)
        {
            this.LoadFrom(source);
            ParameterTemplateModels = new List<ParameterTemplateModel>();
            source.Parameters.ForEach(p => ParameterTemplateModels.Add(new ParameterTemplateModel(p)));
            ServiceClient = serviceClient;
        }

        public ServiceClient ServiceClient { get; set; }

        public List<ParameterTemplateModel> ParameterTemplateModels { get; private set; }

        public IScopeProvider Scope
        {
            get { return scopeProvider; }
        }

        public IEnumerable<Parameter> Headers
        {
            get
            {
                return Parameters.Where(p => p.Location == ParameterLocation.Header);
            }
        }

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
        /// Generate the method parameter declaration
        /// </summary>
        public string MethodParameterDeclaration
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in LocalParameters)
                {
                    string format = (parameter.IsRequired ? "{0}" : "{0} = nil");
                    declarations.Add(string.Format(format, parameter.Name));
                }

                declarations.Add("custom_headers = nil");

                return string.Join(", ", declarations);
            }
        }

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they apopear in the method signatur
        /// exclude global parameters
        /// </summary>
        public IEnumerable<ParameterTemplateModel> LocalParameters
        {
            get
            {
                return
                    ParameterTemplateModels.Where(
                        p => p != null && p.ClientProperty == null && !string.IsNullOrWhiteSpace(p.Name))
                        .OrderBy(item => !item.IsRequired);
            }
        }

        /// <summary>
        /// Get the return type name for the underlyign interface method
        /// </summary>
        public virtual string OperationResponseReturnTypeString
        {
            get
            {
                return "MsRest::HttpOperationResponse";
            }
        }

        /// <summary>
        /// Get the type for operation exception
        /// </summary>
        public virtual string OperationExceptionTypeString
        {
            get
            {
                return "MsRest::HttpOperationException";
            }
        }

        public virtual string InitializeResponseBody
        {
            get { return string.Empty; }
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

        public bool UrlWithPath
        {
            get
            {
                return ParameterTemplateModels.Any(p => p.Location == ParameterLocation.Path);
            }
        }

        public string GetStatusCodeReference(HttpStatusCode code)
        {
            return string.Format("{0}", (int)code);
        }

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

                builder.AppendLine("properties.reject!{ |key, value| value.nil? }");
                builder.AppendLine("{0}.query = properties.map{{ |key, value| \"#{{key}}=#{{ERB::Util.url_encode(value.to_s)}}\" }}.compact.join('&')", outputVariableName);
            }

            builder.AppendLine(@"fail URI::Error unless {0}.to_s =~ /\A#{{URI::regexp}}\z/", outputVariableName);

            return builder.ToString();
        }

        public virtual string RemoveDuplicateForwardSlashes(string urlVariableName)
        {
            var builder = new IndentedStringBuilder("  ");

            // TODO: convert it to Ruby.
            //builder.AppendLine("# trim all duplicate forward slashes in the url");
            //builder.AppendLine("var regex = /([^:]\\/)\\/+/gi;");
            //builder.AppendLine("{0} = {0}.replace(regex, '$1');", urlVariableName);

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
