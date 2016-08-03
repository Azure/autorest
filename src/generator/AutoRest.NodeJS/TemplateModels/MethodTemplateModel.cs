// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.NodeJS.TemplateModels
{
    public class MethodTemplateModel : Method
    {
        public MethodTemplateModel(Method source, ServiceClient serviceClient)
        {
            this.LoadFrom(source);
            ParameterTemplateModels = new List<ParameterTemplateModel>();
            GroupedParameterTemplateModels = new List<ParameterTemplateModel>();
            source.Parameters.ForEach(p => ParameterTemplateModels.Add(new ParameterTemplateModel(p)));

            ServiceClient = serviceClient;
            if (source.Group != null)
            {
                OperationName = source.Group.ToPascalCase();
            }
            else
            {
                OperationName = serviceClient.Name;
            }

            BuildOptionsParameterTemplateModel();
        }

        private void BuildOptionsParameterTemplateModel()
        {
            CompositeType optionsType;
            optionsType = new CompositeType
            {
                Name = "options",
                SerializedName = "options",
                Documentation = "Optional Parameters."
            };
            var optionsParmeter = new Parameter
            {
                Name = "options",
                SerializedName = "options",
                IsRequired = false,
                Documentation = "Optional Parameters.",
                Location = ParameterLocation.None,
                Type = optionsType
            };

            IEnumerable<ParameterTemplateModel> optionalParameters = LocalParameters.Where(p => !p.IsRequired);
            foreach (ParameterTemplateModel parameter in optionalParameters)
            {
                Property optionalProperty = new Property
                {
                    IsReadOnly = false,
                    Name = parameter.Name,
                    IsRequired = parameter.IsRequired,
                    DefaultValue = parameter.DefaultValue,
                    Documentation = parameter.Documentation,
                    Type = parameter.Type,
                    SerializedName = parameter.SerializedName   
                };
                parameter.Constraints.ToList().ForEach(x => optionalProperty.Constraints.Add(x.Key, x.Value));
                parameter.Extensions.ToList().ForEach(x => optionalProperty.Extensions.Add(x.Key, x.Value));
                ((CompositeType)optionsParmeter.Type).Properties.Add(optionalProperty);
            }

            //Adding customHeaders to the options object
            Property customHeaders = new Property
            {
                IsReadOnly = false,
                Name = "customHeaders",
                IsRequired = false,
                Documentation = "Headers that will be added to the request",
                Type = new PrimaryType(KnownPrimaryType.Object),
                SerializedName = "customHeaders"
            };
            ((CompositeType)optionsParmeter.Type).Properties.Add(customHeaders);
            OptionsParameterTemplateModel = new ParameterTemplateModel(optionsParmeter);
        }

        public string OperationName { get; set; }

        public ServiceClient ServiceClient { get; set; }

        public List<ParameterTemplateModel> ParameterTemplateModels { get; private set; }

        public ParameterTemplateModel OptionsParameterTemplateModel { get; private set; }

        protected List<ParameterTemplateModel> GroupedParameterTemplateModels { get; private set; }

        /// <summary>
        /// Get the predicate to determine of the http operation status code indicates success
        /// </summary>
        public string FailureStatusCodePredicate
        {
            get
            {
                if (Responses.Any())
                {
                    List<string> predicates = new List<string>();
                    foreach (var responseStatus in Responses.Keys)
                    {
                        predicates.Add(string.Format(CultureInfo.InvariantCulture,
                            "statusCode !== {0}", GetStatusCodeReference(responseStatus)));
                    }

                    return string.Join(" && ", predicates);
                }

                return "statusCode < 200 || statusCode >= 300";
            }
        }

        /// <summary>
        /// Generate the method parameter declarations for a method
        /// </summary>
        public string MethodParameterDeclaration
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in LocalParametersWithOptions)
                {
                    declarations.Add(parameter.Name);
                }

                var declaration = string.Join(", ", declarations);
                declaration += ", ";
                return declaration;
            }
        }

        /// <summary>
        /// Generate the method parameter declarations for a method, using TypeScript declaration syntax
        /// <param name="includeOptions">whether the ServiceClientOptions parameter should be included</param>
        /// </summary>
        public string MethodParameterDeclarationTS(bool includeOptions)
        {
            StringBuilder declarations = new StringBuilder();

            bool first = true;
            IEnumerable<ParameterTemplateModel> requiredParameters = LocalParameters.Where(p => p.IsRequired);
            foreach (var parameter in requiredParameters)
            {
                if (!first)
                    declarations.Append(", ");

                declarations.Append(parameter.Name);
                declarations.Append(": ");

                // For date/datetime parameters, use a union type to reflect that they can be passed as a JS Date or a string.
                var type = parameter.Type;
                if (type.IsPrimaryType(KnownPrimaryType.Date) || type.IsPrimaryType(KnownPrimaryType.DateTime))
                    declarations.Append("Date|string");
                else declarations.Append(type.TSType(false));

                first = false;
            }

            if (includeOptions)
            {
                if (!first)
                    declarations.Append(", ");
                declarations.Append("options: { ");
                var optionalParameters = ((CompositeType)OptionsParameterTemplateModel.Type).Properties;
                for(int i = 0; i < optionalParameters.Count; i++)
                {
                    if (i != 0)
                    {
                        declarations.Append(", ");
                    }
                    declarations.Append(optionalParameters[i].Name);
                    declarations.Append("? : ");
                    if (optionalParameters[i].Name.Equals("customHeaders", StringComparison.OrdinalIgnoreCase))
                    {
                        declarations.Append("{ [headerName: string]: string; }");
                    }
                    else
                    {
                        declarations.Append(optionalParameters[i].Type.TSType(false));
                    }
                }
                declarations.Append(" }");
            }

            return declarations.ToString();
        }

        /// <summary>
        /// Generate the method parameter declarations with callback for a method
        /// </summary>
        public string MethodParameterDeclarationWithCallback
        {
            get
            {
                var parameters = MethodParameterDeclaration;
                parameters += "callback";
                return parameters;
            }
        }

        /// <summary>
        /// Generate the method parameter declarations with callback for a method, using TypeScript method syntax
        /// <param name="includeOptions">whether the ServiceClientOptions parameter should be included</param>
        /// </summary>
        public string MethodParameterDeclarationWithCallbackTS(bool includeOptions)
        {
            //var parameters = MethodParameterDeclarationTS(includeOptions);
            var returnTypeTSString = ReturnType.Body == null ? "void" : ReturnType.Body.TSType(false);

            StringBuilder parameters = new StringBuilder();
            parameters.Append(MethodParameterDeclarationTS(includeOptions));

            if (parameters.Length > 0)
                parameters.Append(", ");

            parameters.Append("callback: ServiceCallback<" + returnTypeTSString + ">");
            return parameters.ToString();
        }

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they appear in the method signature
        /// exclude global parameters and constants.
        /// </summary>
        internal IEnumerable<ParameterTemplateModel> LocalParameters
        {
            get
            {
                return ParameterTemplateModels.Where(
                    p => p != null && p.ClientProperty == null && !string.IsNullOrWhiteSpace(p.Name) && !p.IsConstant)
                    .OrderBy(item => !item.IsRequired);
            }
        }

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they appear in the method signature
        /// exclude global parameters. All the optional parameters are pushed into the second last "options" parameter.
        /// </summary>
        public IEnumerable<ParameterTemplateModel> LocalParametersWithOptions
        {
            get
            {
                List<ParameterTemplateModel> requiredParamsWithOptionsList = LocalParameters.Where(p => p.IsRequired).ToList();
                requiredParamsWithOptionsList.Add(OptionsParameterTemplateModel);
                return requiredParamsWithOptionsList as IEnumerable<ParameterTemplateModel>;
            }
        }

        /// <summary>
        /// Returns list of parameters and their properties in (alphabetical order) that needs to be documented over a method.
        /// This property does simple tree traversal using stack and hashtable for already visited complex types.
        /// </summary>
        public IEnumerable<ParameterTemplateModel> DocumentationParameters
        {
            get
            {
                var traversalStack = new Stack<ParameterTemplateModel>();
                var visitedHash = new Dictionary<string, ParameterTemplateModel>();
                var retValue = new Stack<ParameterTemplateModel>();

                foreach (var param in LocalParametersWithOptions)
                {
                    traversalStack.Push(param);
                }

                while (traversalStack.Count() != 0)
                {
                    var param = traversalStack.Pop();
                    if (!(param.Type is CompositeType))
                    {
                        retValue.Push(param);
                    }

                    if (param.Type is CompositeType)
                    {
                        if (!visitedHash.ContainsKey(param.Type.Name))
                        {
                            traversalStack.Push(param);
                            foreach (var property in param.ComposedProperties)
                            {
                                if (property.IsReadOnly || property.IsConstant)
                                {
                                    continue;
                                }

                                var propertyParameter = new Parameter();
                                propertyParameter.Type = property.Type;
                                propertyParameter.IsRequired = property.IsRequired;
                                propertyParameter.Name = param.Name + "." + property.Name;
                                string documentationString = string.Join(" ", (new[] { property.Summary, property.Documentation}).Where(s => !string.IsNullOrEmpty(s)));
                                propertyParameter.Documentation = documentationString;
                                traversalStack.Push(new ParameterTemplateModel(propertyParameter));
                            }

                            visitedHash.Add(param.Type.Name, new ParameterTemplateModel(param));
                        }
                        else
                        {
                            retValue.Push(param);
                        }
                    }
                }

                return retValue.ToList();
            }
        }

        public static string ConstructParameterDocumentation(string documentation)
        {
            var builder = new IndentedStringBuilder("  ");
            return builder.AppendLine(documentation)
                          .AppendLine(" * ").ToString();
        }

        /// <summary>
        /// Get the type name for the method's return type
        /// </summary>
        public string ReturnTypeString
        {
            get
            {
                if (ReturnType.Body != null)
                {
                    return ReturnType.Body.Name;
                }
                else
                {
                    return "null";
                }
            }
        }

        /// <summary>
        /// The Deserialization Error handling code block that provides a useful Error 
        /// message when exceptions occur in deserialization along with the request 
        /// and response object
        /// </summary>
        public string DeserializationError
        {
            get
            {
                var builder = new IndentedStringBuilder("  ");
                var errorVariable = this.Scope.GetUniqueName("deserializationError");
                return builder.AppendLine("var {0} = new Error(util.format('Error \"%s\" occurred in " +
                    "deserializing the responseBody - \"%s\"', error, responseBody));", errorVariable)
                    .AppendLine("{0}.request = msRest.stripRequest(httpRequest);", errorVariable)
                    .AppendLine("{0}.response = msRest.stripResponse(response);", errorVariable)
                    .AppendLine("return callback({0});", errorVariable).ToString();
            }
        }

        /// <summary>
        /// Provides the parameter name in the correct jsdoc notation depending on 
        /// whether it is required or optional
        /// </summary>
        /// <param name="parameter">Parameter to be documented</param>
        /// <returns>Parameter name in the correct jsdoc notation</returns>
        public static string GetParameterDocumentationName(Parameter parameter)
        {
            if (parameter == null)
            {
                throw new ArgumentNullException("parameter");
            }
            if (parameter.IsRequired)
            {
                return parameter.Name;
            }
            else
            {
                return string.Format(CultureInfo.InvariantCulture, "[{0}]", parameter.Name);
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase")]
        public static string GetParameterDocumentationType(Parameter parameter)
        {
            if (parameter == null)
            {
                throw new ArgumentNullException("parameter");
            }
            string typeName = "object";
            if (parameter.Type is PrimaryType)
            {
                typeName = parameter.Type.Name;
            }
            else if (parameter.Type is SequenceType)
            {
                typeName = "array";
            }
            else if (parameter.Type is EnumType)
            {
                typeName = "string";
            }

            return typeName.ToLower(CultureInfo.InvariantCulture);
        }

        public string GetDeserializationString(IType type, string valueReference = "result", string responseVariable = "parsedResponse")
        {
            var builder = new IndentedStringBuilder("  ");
            if (type is CompositeType)
            {
                builder.AppendLine("var resultMapper = new client.models['{0}']().mapper();", type.Name);
            }
            else
            {
                builder.AppendLine("var resultMapper = {{{0}}};", type.ConstructMapper(responseVariable, null, false, false));
            }
            builder.AppendLine("{1} = client.deserialize(resultMapper, {0}, '{1}');", responseVariable, valueReference);
            return builder.ToString();
        }

        public string ValidationString
        {
            get
            {
                var builder = new IndentedStringBuilder("  ");
                foreach (var parameter in ParameterTemplateModels.Where(p => !p.IsConstant))
                {
                    if ((HttpMethod == HttpMethod.Patch && parameter.Type is CompositeType))
                    {
                        if (parameter.IsRequired)
                        {
                            builder.AppendLine("if ({0} === null || {0} === undefined) {{", parameter.Name)
                                     .Indent()
                                     .AppendLine("throw new Error('{0} cannot be null or undefined.');", parameter.Name)
                                   .Outdent()
                                   .AppendLine("}");
                        }
                    }
                    else
                    {
                        builder.AppendLine(parameter.Type.ValidateType(Scope, parameter.Name, parameter.IsRequired));
                        if (parameter.Constraints != null && parameter.Constraints.Count > 0 && parameter.Location != ParameterLocation.Body)
                        {
                            builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", parameter.Name).Indent();
                            builder = parameter.Type.AppendConstraintValidations(parameter.Name, parameter.Constraints, builder);
                            builder.Outdent().AppendLine("}");
                        }        
                    }
                }
                return builder.ToString();
            }
        }

        public string DeserializeResponse(IType type, string valueReference = "result", string responseVariable = "parsedResponse")
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            var builder = new IndentedStringBuilder("  ");
            builder.AppendLine("var {0} = null;", responseVariable)
                   .AppendLine("try {")
                   .Indent()
                     .AppendLine("{0} = JSON.parse(responseBody);", responseVariable)
                     .AppendLine("{0} = JSON.parse(responseBody);", valueReference);
            var deserializeBody = GetDeserializationString(type, valueReference, responseVariable);
            if (!string.IsNullOrWhiteSpace(deserializeBody))
            {
                builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", responseVariable)
                         .Indent()
                         .AppendLine(deserializeBody)
                       .Outdent()
                       .AppendLine("}");
            }
            builder.Outdent()
                   .AppendLine("} catch (error) {")
                     .Indent()
                     .AppendLine(DeserializationError)
                   .Outdent()
                   .AppendLine("}");

            return builder.ToString();
        }

        /// <summary>
        /// Get the method's request body (or null if there is no request body)
        /// </summary>
        public ParameterTemplateModel RequestBody
        {
            get
            {
                return this.Body != null ? new ParameterTemplateModel(this.Body) : null;
            }
        }        

        /// <summary>
        /// Generate a reference to the ServiceClient
        /// </summary>
        public string ClientReference
        {
            get { return Group == null ? "this" : "this.client"; }
        }

        public static string GetStatusCodeReference(HttpStatusCode code)
        {
            return string.Format(CultureInfo.InvariantCulture, "{0}", (int)code);
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
            if (HasQueryParameters())
            {
                BuildQueryParameterArray(builder);
                AddQueryParametersToUrl(variableName, builder);
            }

            return builder.ToString();
        }

        /// <summary>
        /// Generate code to construct the query string from an array of query parameter strings containing 'key=value'
        /// </summary>
        /// <param name="variableName">The variable reference for the url</param>
        /// <param name="builder">The string builder for url construction</param>
        private void AddQueryParametersToUrl(string variableName, IndentedStringBuilder builder)
        {
            builder.AppendLine("if (queryParameters.length > 0) {")
                .Indent();
            if (this.Extensions.ContainsKey("nextLinkMethod") && (bool)this.Extensions["nextLinkMethod"])
            {
                builder.AppendLine("{0} += ({0}.indexOf('?') !== -1 ? '&' : '?') + queryParameters.join('&');", variableName);
            }
            else
            {
                builder.AppendLine("{0} += '?' + queryParameters.join('&');", variableName);
            }

            builder.Outdent().AppendLine("}");
        }

        /// <summary>
        /// Detremines whether the Uri will have any query string
        /// </summary>
        /// <returns>True if a query string is possible given the method parameters, otherwise false</returns>
        protected virtual bool HasQueryParameters()
        {
            return LogicalParameters.Any(p => p.Location == ParameterLocation.Query);
        }

        /// <summary>
        /// Genrate code to build an array of query parameter strings in a variable named 'queryParameters'.  The 
        /// array should contain one string element for each query parameter of the form 'key=value'
        /// </summary>
        /// <param name="builder">The stringbuilder for url construction</param>
        protected virtual void BuildQueryParameterArray(IndentedStringBuilder builder)
        {
            if (builder == null)
            {
                throw new ArgumentNullException("builder");
            }

            builder.AppendLine("var queryParameters = [];");
            foreach (var queryParameter in LogicalParameters
                .Where(p => p.Location == ParameterLocation.Query))
            {
                var queryAddFormat = "queryParameters.push('{0}=' + encodeURIComponent({1}));";
                if (queryParameter.SkipUrlEncoding())
                {
                    queryAddFormat = "queryParameters.push('{0}=' + {1});";
                }
                if (!queryParameter.IsRequired)
                {
                    builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", queryParameter.Name)
                        .Indent()
                        .AppendLine(queryAddFormat,
                            queryParameter.SerializedName, queryParameter.GetFormattedReferenceValue()).Outdent()
                        .AppendLine("}");
                }
                else
                {
                    builder.AppendLine(queryAddFormat,
                        queryParameter.SerializedName, queryParameter.GetFormattedReferenceValue());
                }
            }
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

            foreach (var pathParameter in LogicalParameters.Where(p => p.Location == ParameterLocation.Path))
            {
                var pathReplaceFormat = "{0} = {0}.replace('{{{1}}}', encodeURIComponent({2}));";
                if (pathParameter.SkipUrlEncoding())
                {
                    pathReplaceFormat = "{0} = {0}.replace('{{{1}}}', {2});";
                }
                var urlPathName = pathParameter.SerializedName;
                string pat = @".*\{" + urlPathName + @"(\:\w+)\}";
                Regex r = new Regex(pat);
                Match m = r.Match(Url);
                if (m.Success)
                {
                    urlPathName += m.Groups[1].Value;
                }
                builder.AppendLine(pathReplaceFormat, variableName, urlPathName,
                    pathParameter.Type.ToString(pathParameter.Name));
            }
        }

        /// <summary>
        /// Generate code to remove duplicated forward slashes from a URL in code
        /// </summary>
        /// <param name="urlVariableName"></param>
        /// <returns></returns>
        public virtual string RemoveDuplicateForwardSlashes(string urlVariableName)
        {
            var builder = new IndentedStringBuilder("  ");

            builder.AppendLine("// trim all duplicate forward slashes in the url");
            builder.AppendLine("var regex = /([^:]\\/)\\/+/gi;");
            builder.AppendLine("{0} = {0}.replace(regex, '$1');", urlVariableName);
            return builder.ToString();
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

        public string ConstructRequestBodyMapper
        {
            get
            {
                var builder = new IndentedStringBuilder("  ");
                if (RequestBody.Type is CompositeType)
                {
                    builder.AppendLine("var requestModelMapper = new client.models['{0}']().mapper();", RequestBody.Type.Name);
                }
                else
                {
                    builder.AppendLine("var requestModelMapper = {{{0}}};",
                        RequestBody.Type.ConstructMapper(RequestBody.SerializedName, RequestBody, false, false));
                }
                return builder.ToString();
            }
        }

        public virtual string InitializeResult
        {
            get
            {
                return string.Empty;
            }
        }

        public string ReturnTypeInfo
        {
            get
            {
                string result = null;

                if (ReturnType.Body is EnumType)
                {
                    var returnBodyType = ReturnType.Body as EnumType;

                    string enumValues = "";
                    for (var i = 0; i < returnBodyType.Values.Count; i++)
                    {
                        if (i == returnBodyType.Values.Count - 1)
                        {
                            enumValues += returnBodyType.Values[i].SerializedName;
                        }
                        else
                        {
                            enumValues += returnBodyType.Values[i].SerializedName + ", ";
                        }
                    }
                    result = string.Format(CultureInfo.InvariantCulture,
                        "Possible values for result are - {0}.", enumValues);
                }
                else if (ReturnType.Body is CompositeType)
                {
                    result = string.Format(CultureInfo.InvariantCulture,
                        "See {{@link {0}}} for more information.", ReturnTypeString);
                }

                return result;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase")]
        public string DocumentReturnTypeString
        {
            get
            {
                string typeName = "object";
                IType returnBodyType = ReturnType.Body;

                if (returnBodyType == null)
                {
                    typeName = "null";
                }
                else if (returnBodyType is PrimaryType)
                {
                    typeName = returnBodyType.Name;
                }
                else if (returnBodyType is SequenceType)
                {
                    typeName = "array";
                }
                else if (returnBodyType is EnumType)
                {
                    typeName = "string";
                }

                return typeName.ToLower(CultureInfo.InvariantCulture);
            }
        }

        /// <summary>
        /// Generates input mapping code block.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildInputMappings()
        {
            var builder = new IndentedStringBuilder("  ");
            if (InputParameterTransformation.Count > 0)
            {
                if (AreWeFlatteningParameters())
                {
                    return BuildFlattenParameterMappings();
                }
                else
                {
                    return BuildGroupedParameterMappings();
                }
            }
            return builder.ToString();
        }

        public virtual bool AreWeFlatteningParameters()
        {
            bool result = true;
            foreach(var transformation in InputParameterTransformation)
            {
                var compositeOutputParameter = transformation.OutputParameter.Type as CompositeType;
                if (compositeOutputParameter == null)
                {
                    result = false;
                    break;
                }
                else
                {
                    foreach (var poperty in compositeOutputParameter.ComposedProperties.Select(p => p.Name))
                    {
                        if (!transformation.ParameterMappings.Select(m => m.InputParameter.Name).Contains(poperty))
                        {
                            result = false;
                            break;
                        }
                    }
                    if (!result) break;
                }
            }

            return result;
        }

        public virtual string BuildFlattenParameterMappings()
        {
            var builder = new IndentedStringBuilder();
            foreach (var transformation in InputParameterTransformation)
            {
                builder.AppendLine("var {0};",
                        transformation.OutputParameter.Name);

                builder.AppendLine("if ({0}) {{", BuildNullCheckExpression(transformation))
                       .Indent();

                if (transformation.ParameterMappings.Any(m => !string.IsNullOrEmpty(m.OutputParameterProperty)) &&
                    transformation.OutputParameter.Type is CompositeType)
                {
                    builder.AppendLine("{0} = new client.models['{1}']();",
                        transformation.OutputParameter.Name,
                        transformation.OutputParameter.Type.Name);
                }

                foreach (var mapping in transformation.ParameterMappings)
                {
                    builder.AppendLine("{0}{1};",
                        transformation.OutputParameter.Name,
                        mapping);
                }

                builder.Outdent()
                       .AppendLine("}");
            }

            return builder.ToString();
        }

        public virtual string BuildGroupedParameterMappings()
        {
            var builder = new IndentedStringBuilder("  ");
            if (InputParameterTransformation.Count > 0)
            {
                // Declare all the output paramaters outside the try block
                foreach (var transformation in InputParameterTransformation)
                {
                    if (transformation.OutputParameter.Type is CompositeType && 
                        transformation.OutputParameter.IsRequired)
                    {
                        builder.AppendLine("var {0} = new client.models['{1}']();",
                            transformation.OutputParameter.Name,
                            transformation.OutputParameter.Type.Name);
                    }
                    else
                    {
                        builder.AppendLine("var {0};", transformation.OutputParameter.Name);
                    }
                    
                }
                builder.AppendLine("try {").Indent();
                foreach (var transformation in InputParameterTransformation)
                {
                    builder.AppendLine("if ({0})", BuildNullCheckExpression(transformation))
                           .AppendLine("{").Indent();
                    var outputParameter = transformation.OutputParameter;
                    bool noCompositeTypeInitialized = true;
                    if (transformation.ParameterMappings.Any(m => !string.IsNullOrEmpty(m.OutputParameterProperty)) &&
                        transformation.OutputParameter.Type is CompositeType)
                    {
                        //required outputParameter is initialized at the time of declaration
                        if (!transformation.OutputParameter.IsRequired)
                        {
                            builder.AppendLine("{0} = new client.models['{1}']();",
                                transformation.OutputParameter.Name,
                                transformation.OutputParameter.Type.Name);
                        }
                        
                        noCompositeTypeInitialized = false;
                    }

                    foreach (var mapping in transformation.ParameterMappings)
                    {
                        builder.AppendLine("{0}{1};",
                            transformation.OutputParameter.Name,
                            mapping);
                        if (noCompositeTypeInitialized)
                        {
                            // If composite type is initialized based on the above logic then it should not be validated.
                            builder.AppendLine(outputParameter.Type.ValidateType(Scope, outputParameter.Name, outputParameter.IsRequired));
                        }
                    }

                    builder.Outdent()
                           .AppendLine("}");
                }
                builder.Outdent()
                       .AppendLine("} catch (error) {")
                         .Indent()
                         .AppendLine("return callback(error);")
                       .Outdent()
                       .AppendLine("}");
            }
            return builder.ToString();
        }

        private static string BuildNullCheckExpression(ParameterTransformation transformation)
        {
            if (transformation == null)
            {
                throw new ArgumentNullException("transformation");
            }
            if (transformation.ParameterMappings.Count == 1)
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "{0} !== null && {0} !== undefined", 
                    transformation.ParameterMappings[0].InputParameter.Name);
            }
            else
            {
                return string.Join(" || ",
                transformation.ParameterMappings.Select(m =>
                    string.Format(CultureInfo.InvariantCulture,
                    "({0} !== null && {0} !== undefined)", m.InputParameter.Name)));
            }
        }

        public string  BuildOptionalMappings()
        {
            IEnumerable<Property> optionalParameters = 
                ((CompositeType)OptionsParameterTemplateModel.Type)
                .Properties.Where(p => p.Name != "customHeaders");
            var builder = new IndentedStringBuilder("  ");
            foreach (var optionalParam in optionalParameters)
            {
                string defaultValue = "undefined";
                if (!string.IsNullOrWhiteSpace(optionalParam.DefaultValue))
                {
                    defaultValue = optionalParam.DefaultValue;
                }
                builder.AppendLine("var {0} = ({1} && {1}.{2} !== undefined) ? {1}.{2} : {3};", 
                    optionalParam.Name, OptionsParameterTemplateModel.Name, optionalParam.Name, defaultValue);
            }
            return builder.ToString();
        }
    }        
}