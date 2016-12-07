// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.NodeJS.Model
{
    public class MethodJs : Method
    {
        public MethodJs()
        {
            // methods that have no group name get the client name as their name
            Group.OnGet += groupName =>
            {
                return groupName.IsNullOrEmpty() ? CodeModel?.Name : groupName;
            };

            OptionsParameterTemplateModel = (ParameterJs)New<Parameter>(new
            {
                Name = "options",
                SerializedName = "options",
                IsRequired = false,
                Documentation = "Optional Parameters.",
                Location = ParameterLocation.None,
                ModelType = New<CompositeType>(new
                {
                    Name = "options",
                    SerializedName = "options",
                    Documentation = "Optional Parameters."
                })
            });

            OptionsParameterModelType.Add(New<Core.Model.Property>(new
            {
                IsReadOnly = false,
                Name = "customHeaders",
                IsRequired = false,
                Documentation = "Headers that will be added to the request",
                ModelType = New<PrimaryType>(KnownPrimaryType.Object),
                SerializedName = "customHeaders"
            }));
        }

        public override void Remove(Parameter item)
        {
            base.Remove(item);
            // find a Property in OptionsParameterModelType with the same name and remove it.

            OptionsParameterModelType.Remove(prop => prop.Name == item.Name);
        }

        public override Parameter Add(Parameter item)
        {
            var parameter = base.Add(item) as ParameterJs;

            if (parameter.IsLocal && !parameter.IsRequired)
            {
                OptionsParameterModelType.Add(New<Core.Model.Property>(new
                {
                    IsReadOnly = false,
                    Name = parameter.Name,
                    IsRequired = parameter.IsRequired,
                    DefaultValue = parameter.DefaultValue,
                    Documentation = parameter.Documentation,
                    ModelType = parameter.ModelType,
                    SerializedName = parameter.SerializedName,
                    Constraints = parameter.Constraints,
                    // optionalProperty.Constraints.AddRange(parameter.Constraints);
                    Extensions = parameter.Extensions // optionalProperty.Extensions.AddRange(parameter.Extensions);
                }));
            }
            
            return parameter;
        }

        [JsonIgnore]
        private CompositeType OptionsParameterModelType => ((CompositeType) OptionsParameterTemplateModel.ModelType);

        [JsonIgnore]
        public IEnumerable<ParameterJs> ParameterTemplateModels => Parameters.Cast<ParameterJs>();

        [JsonIgnore]
        public ParameterJs OptionsParameterTemplateModel { get; }

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
            IEnumerable<ParameterJs> requiredParameters = LocalParameters.Where(p => p.IsRequired);
            foreach (var parameter in requiredParameters)
            {
                if (!first)
                    declarations.Append(", ");

                declarations.Append(parameter.Name);
                declarations.Append(": ");

                // For date/datetime parameters, use a union type to reflect that they can be passed as a JS Date or a string.
                var type = parameter.ModelType;
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
                var optionalParameters = ((CompositeType)OptionsParameterTemplateModel.ModelType).Properties.OrderBy(each => each.Name == "customHeaders" ? 1 : 0).ToArray();
                for(int i = 0; i < optionalParameters.Length; i++)
                {
                    if (i != 0)
                    {
                        declarations.Append(", ");
                    }
                    declarations.Append(optionalParameters[i].Name);
                    declarations.Append("? : ");
                    if (optionalParameters[i].Name.EqualsIgnoreCase("customHeaders"))
                    {
                        declarations.Append("{ [headerName: string]: string; }");
                    }
                    else
                    {
                        declarations.Append(optionalParameters[i].ModelType.TSType(false));
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
        internal IEnumerable<ParameterJs> LocalParameters
        {
            get
            {
                return ParameterTemplateModels.Where(
                    p => p != null && !p.IsClientProperty && !string.IsNullOrWhiteSpace(p.Name) && !p.IsConstant)
                    .OrderBy(item => !item.IsRequired);
            }
        }

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they appear in the method signature
        /// exclude global parameters. All the optional parameters are pushed into the second last "options" parameter.
        /// </summary>
        [JsonIgnore]
        public IEnumerable<ParameterJs> LocalParametersWithOptions
        {
            get
            {
                List<ParameterJs> requiredParamsWithOptionsList = LocalParameters.Where(p => p.IsRequired).ToList();
                requiredParamsWithOptionsList.Add(OptionsParameterTemplateModel);
                return requiredParamsWithOptionsList as IEnumerable<ParameterJs>;
            }
        }

        /// <summary>
        /// Returns list of parameters and their properties in (alphabetical order) that needs to be documented over a method.
        /// This property does simple tree traversal using stack and hashtable for already visited complex types.
        /// </summary>
        [JsonIgnore]
        public IEnumerable<ParameterJs> DocumentationParameters
        {
            get
            {
                var traversalStack = new Stack<ParameterJs>();
                var visitedHash = new HashSet<string>();
                var retValue = new Stack<ParameterJs>();

                foreach (var param in LocalParametersWithOptions)
                {
                    traversalStack.Push(param);
                }

                while (traversalStack.Count() != 0)
                {
                    var param = traversalStack.Pop();
                    if (!(param.ModelType is CompositeType))
                    {
                        retValue.Push(param);
                    }

                    if (param.ModelType is CompositeType)
                    {
                        if (!visitedHash.Contains(param.ModelType.Name))
                        {
                            traversalStack.Push(param);
                            foreach (var property in param.ComposedProperties.OrderBy( each => each.Name == "customHeaders"? 1:0)) //.OrderBy( each => each.Name.Else("")))
                            {
                                if (property.IsReadOnly || property.IsConstant)
                                {
                                    continue;
                                }

                                var propertyParameter = New<Parameter>() as ParameterJs;
                                propertyParameter.ModelType = property.ModelType;
                                propertyParameter.IsRequired = property.IsRequired;
                                propertyParameter.Name.FixedValue = param.Name + "." + property.Name;
                                string documentationString = string.Join(" ", (new[] { property.Summary, property.Documentation}).Where(s => !string.IsNullOrEmpty(s)));
                                propertyParameter.Documentation = documentationString;
                                traversalStack.Push(propertyParameter);
                            }

                            visitedHash.Add(param.ModelType.Name);
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
        [JsonIgnore]
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
        [JsonIgnore]
        public string DeserializationError
        {
            get
            {
                var builder = new IndentedStringBuilder("  ");
                var errorVariable = this.GetUniqueName("deserializationError");
                return builder.AppendLine("var {0} = new Error(util.format('Error \"%s\" occurred in " +
                    "deserializing the responseBody - \"%s\"', error, responseBody));", errorVariable)
                    .AppendLine("{0}.request = msRest.stripRequest(httpRequest);", errorVariable)
                    .AppendLine("{0}.response = msRest.stripResponse(response);", errorVariable)
                    .AppendLine("return callback({0});", errorVariable).ToString();
            }
        }

        public string PopulateErrorCodeAndMessage()
        {
            var builder = new IndentedStringBuilder("  ");
            if (DefaultResponse.Body != null && DefaultResponse.Body.Name.RawValue.Equals("CloudError", StringComparison.InvariantCultureIgnoreCase))
            {
                builder.AppendLine("if (parsedErrorResponse.error) parsedErrorResponse = parsedErrorResponse.error;")
                       .AppendLine("if (parsedErrorResponse.code) error.code = parsedErrorResponse.code;")
                       .AppendLine("if (parsedErrorResponse.message) error.message = parsedErrorResponse.message;");
            }
            else
            {
                builder.AppendLine("var internalError = null;")
                       .AppendLine("if (parsedErrorResponse.error) internalError = parsedErrorResponse.error;")
                       .AppendLine("error.code = internalError ? internalError.code : parsedErrorResponse.code;")
                       .AppendLine("error.message = internalError ? internalError.message : parsedErrorResponse.message;");
            }
            return builder.ToString();
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
                throw new ArgumentNullException(nameof(parameter));
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
                throw new ArgumentNullException(nameof(parameter));
            }
            string typeName = "object";
            if (parameter.ModelType is PrimaryTypeJs)
            {
                typeName = parameter.ModelType.Name;
            }
            else if (parameter.ModelType is Core.Model.SequenceType)
            {
                typeName = "array";
            }
            else if (parameter.ModelType is EnumType)
            {
                typeName = "string";
            }

            return typeName.ToLower(CultureInfo.InvariantCulture);
        }

        public string GetDeserializationString(IModelType type, string valueReference = "result", string responseVariable = "parsedResponse")
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

        [JsonIgnore]
        public string ValidationString
        {
            get
            {
                var builder = new IndentedStringBuilder("  ");
                foreach (var parameter in ParameterTemplateModels.Where(p => !p.IsConstant))
                {
                    if ((HttpMethod == HttpMethod.Patch && parameter.ModelType is CompositeType))
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
                        builder.AppendLine(parameter.ModelType.ValidateType(this, parameter.Name, parameter.IsRequired));
                        if (parameter.Constraints != null && parameter.Constraints.Count > 0 && parameter.Location != ParameterLocation.Body)
                        {
                            builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", parameter.Name).Indent();
                            builder = parameter.ModelType.AppendConstraintValidations(parameter.Name, parameter.Constraints, builder);
                            builder.Outdent().AppendLine("}");
                        }        
                    }
                }
                return builder.ToString();
            }
        }

        public string DeserializeResponse(IModelType type, string valueReference = "result", string responseVariable = "parsedResponse")
        {
            if (type == null)
            {
                throw new ArgumentNullException(nameof(type));
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
        public ParameterJs RequestBody => Body as ParameterJs;

        /// <summary>
        /// Generate a reference to the ServiceClient
        /// </summary>
        [JsonIgnore]
        public string ClientReference => MethodGroup.IsCodeModelMethodGroup ? "this" : "this.client";

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
                throw new ArgumentNullException(nameof(builder));
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
                throw new ArgumentNullException(nameof(builder));
            }

            foreach (var pathParameter in LogicalParameters.Where(p => p.Location == ParameterLocation.Path))
            {
                var pathReplaceFormat = "{0} = {0}.replace('{{{1}}}', encodeURIComponent({2}));";
                if (pathParameter.SkipUrlEncoding())
                {
                    pathReplaceFormat = "{0} = {0}.replace('{{{1}}}', {2});";
                }
                
                builder.AppendLine(pathReplaceFormat, variableName, pathParameter.SerializedName,
                    pathParameter.ModelType.ToString(pathParameter.Name));
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

        [JsonIgnore]
        public string ConstructRequestBodyMapper
        {
            get
            {
                var builder = new IndentedStringBuilder("  ");
                if (RequestBody.ModelType is CompositeType)
                {
                    builder.AppendLine("var requestModelMapper = new client.models['{0}']().mapper();", RequestBody.ModelType.Name);
                }
                else
                {
                    builder.AppendLine("var requestModelMapper = {{{0}}};",
                        RequestBody.ModelType.ConstructMapper(RequestBody.SerializedName, RequestBody, false, false));
                }
                return builder.ToString();
            }
        }
        [JsonIgnore]
        public virtual string InitializeResult
        {
            get
            {
                return string.Empty;
            }
        }
        [JsonIgnore]
        public string ReturnTypeInfo
        {
            get
            {
                string result = null;

                if (ReturnType.Body is EnumType)
                {
                    var returnBodyType = ReturnType.Body as EnumType;
                    if (!returnBodyType.ModelAsString)
                    {
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
        [JsonIgnore]
        public string DocumentReturnTypeString
        {
            get
            {
                string typeName = "object";
                IModelType returnBodyType = ReturnType.Body;

                if (returnBodyType == null)
                {
                    typeName = "null";
                }
                else if (returnBodyType is PrimaryTypeJs)
                {
                    typeName = returnBodyType.Name;
                }
                else if (returnBodyType is Core.Model.SequenceType)
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
                var compositeOutputParameter = transformation.OutputParameter.ModelType as CompositeType;
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
                    transformation.OutputParameter.ModelType is CompositeType)
                {
                    builder.AppendLine("{0} = new client.models['{1}']();",
                        transformation.OutputParameter.Name,
                        transformation.OutputParameter.ModelType.Name);
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
                    if (transformation.OutputParameter.ModelType is CompositeType && 
                        transformation.OutputParameter.IsRequired)
                    {
                        builder.AppendLine("var {0} = new client.models['{1}']();",
                            transformation.OutputParameter.Name,
                            transformation.OutputParameter.ModelType.Name);
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
                        transformation.OutputParameter.ModelType is CompositeType)
                    {
                        //required outputParameter is initialized at the time of declaration
                        if (!transformation.OutputParameter.IsRequired)
                        {
                            builder.AppendLine("{0} = new client.models['{1}']();",
                                transformation.OutputParameter.Name,
                                transformation.OutputParameter.ModelType.Name);
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
                            builder.AppendLine(outputParameter.ModelType.ValidateType(this, outputParameter.Name, outputParameter.IsRequired));
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
                throw new ArgumentNullException(nameof(transformation));
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
            IEnumerable<Core.Model.Property> optionalParameters = 
                ((CompositeType)OptionsParameterTemplateModel.ModelType)
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