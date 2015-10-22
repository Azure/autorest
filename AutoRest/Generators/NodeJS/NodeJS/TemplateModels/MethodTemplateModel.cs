// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.NodeJS.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Collections;
using System.Text;

namespace Microsoft.Rest.Generator.NodeJS
{
    public class MethodTemplateModel : Method
    {
        private readonly IScopeProvider _scopeProvider = new ScopeProvider();

        public MethodTemplateModel(Method source, ServiceClient serviceClient)
        {
            this.LoadFrom(source);
            ParameterTemplateModels = new List<ParameterTemplateModel>();
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
        }

        public string OperationName { get; set; }

        public ServiceClient ServiceClient { get; set; }

        public List<ParameterTemplateModel> ParameterTemplateModels { get; private set; }

        public IScopeProvider Scope
        {
            get { return _scopeProvider; }
        }


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
                foreach (var parameter in LocalParameters)
                {
                    declarations.Add(parameter.Name);
                }

                declarations.Add("options");
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
            foreach (var parameter in LocalParameters)
			{
                if (!first)
                    declarations.Append(", ");

                declarations.Append(parameter.Name);
                declarations.Append(": ");

                // For date/datetime parameters, use a union type to reflect that they can be passed as a JS Date or a string.
                var type = parameter.Type;
                if (type == PrimaryType.Date || type == PrimaryType.DateTime)
                    declarations.Append("Date|string");
                else declarations.Append(type.TSType(false));

                first = false;
            }

            if (includeOptions)
            {
                if (!first)
                    declarations.Append(", ");
                declarations.Append("options: RequestOptions");
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
        public string MethodParameterDeclarationWithCallbackTS(bool includeOptions) {
            //var parameters = MethodParameterDeclarationTS(includeOptions);
            var returnTypeTSString = ReturnType == null ? "void" : ReturnType.TSType(false);

            StringBuilder parameters = new StringBuilder();
            parameters.Append(MethodParameterDeclarationTS(includeOptions));

            if (parameters.Length > 0)
                parameters.Append(", ");

            parameters.Append("callback: ServiceCallback<" + returnTypeTSString + ">");
            return parameters.ToString();
        }

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they appear in the method signature
        /// exclude global parameters
        /// </summary>
        public IEnumerable<ParameterTemplateModel> LocalParameters
        {
            get
            {
                return ParameterTemplateModels.Where(
                    p => p != null && p.ClientProperty == null && !string.IsNullOrWhiteSpace(p.Name))
                    .OrderBy(item => !item.IsRequired);
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

                foreach (var param in LocalParameters)
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
                                if (property.IsReadOnly)
                                {
                                    continue;
                                }

                                var propertyParameter = new Parameter();
                                propertyParameter.Type = property.Type;
                                propertyParameter.Name = param.Name + "." + property.Name;
                                propertyParameter.Documentation = property.Documentation;
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
                if (ReturnType != null)
                {
                    return ReturnType.Name;
                }
                return "null";
            }
        }

        /// <summary>
        /// The Deserialization Error handling code block that provides a useful Error 
        /// message when exceptions occure in deserialization along with the request 
        /// and response object
        /// </summary>
        public string DeserializationError
        {
            get
            {
                var builder = new IndentedStringBuilder("  ");
                var errorVariable = this.Scope.GetVariableName("deserializationError");
                return builder.AppendLine("var {0} = new Error(util.format('Error \"%s\" occurred in " +
                    "deserializing the responseBody - \"%s\"', error, responseBody));", errorVariable)
                    .AppendLine("{0}.request = httpRequest;", errorVariable)
                    .AppendLine("{0}.response = response;", errorVariable)
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
            string typeName = PrimaryType.Object.Name;
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
                typeName = PrimaryType.String.Name;
            }

            return typeName.ToLower(CultureInfo.InvariantCulture);
        }

        public string GetDeserializationString(IType type, string valueReference = "result", string responseVariable = "parsedResponse")
        {
            CompositeType composite = type as CompositeType;
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            PrimaryType primary = type as PrimaryType;
            EnumType enumType = type as EnumType;
            var builder = new IndentedStringBuilder("  ");
            if (primary != null)
            {
                if (primary == PrimaryType.DateTime ||
                    primary == PrimaryType.Date || 
                    primary == PrimaryType.DateTimeRfc1123)
                {
                    builder.AppendLine("{0} = new Date({0});", valueReference);
                }
                else if (primary == PrimaryType.ByteArray)
                {
                    builder.AppendLine("{0} = new Buffer({0}, 'base64');", valueReference);
                }
                else if (primary == PrimaryType.TimeSpan)
                {
                    builder.AppendLine("{0} = moment.duration({0});", valueReference);
                }
            }
            else if (IsSpecialProcessingRequired(sequence))
            {
                builder.AppendLine("for (var i = 0; i < {0}.length; i++) {{", valueReference)
                         .Indent();
                    
                // Loop through the sequence if each property is Date, DateTime or ByteArray 
                // as they need special treatment for deserialization
                if (sequence.ElementType is PrimaryType)
                {
                    builder.AppendLine("if ({0}[i] !== null && {0}[i] !== undefined) {{", valueReference)
                             .Indent();
                    if (sequence.ElementType == PrimaryType.DateTime ||
                       sequence.ElementType == PrimaryType.Date || 
                        sequence.ElementType == PrimaryType.DateTimeRfc1123)
                    {
                        builder.AppendLine("{0}[i] = new Date({0}[i]);", valueReference);
                    }
                    else if (sequence.ElementType == PrimaryType.ByteArray)
                    {
                        builder.AppendLine("{0}[i] = new Buffer({0}[i], 'base64');", valueReference);
                    }
                    else if (sequence.ElementType == PrimaryType.TimeSpan)
                    {
                        builder.AppendLine("{0}[i] = moment.duration({0}[i]);", valueReference);
                    }
                }
                else if (sequence.ElementType is CompositeType)
                {
                    builder.AppendLine("if ({0}[i] !== null && {0}[i] !== undefined) {{", valueReference)
                             .Indent()
                             .AppendLine(GetDeserializationString(sequence.ElementType,
                                string.Format(CultureInfo.InvariantCulture, "{0}[i]", valueReference),
                                string.Format(CultureInfo.InvariantCulture, "{0}[i]", responseVariable)));
                }

                builder.Outdent()
                        .AppendLine("}")
                        .Outdent()
                    .AppendLine("}");
            }
            else if (IsSpecialProcessingRequired(dictionary))
            {
                builder.AppendLine("for (var property in {0}) {{", valueReference)
                    .Indent();
                if (dictionary.ValueType is PrimaryType)
                {
                    builder.AppendLine("if ({0}[property] !== null && {0}[property] !== undefined) {{", valueReference)
                             .Indent();
                    if (dictionary.ValueType == PrimaryType.DateTime || 
                        dictionary.ValueType == PrimaryType.Date || 
                        dictionary.ValueType == PrimaryType.DateTimeRfc1123)
                    {
                        builder.AppendLine("{0}[property] = new Date({0}[property]);", valueReference);
                    }
                    else if (dictionary.ValueType == PrimaryType.ByteArray)
                    {
                        builder.AppendLine("{0}[property] = new Buffer({0}[property], 'base64');", valueReference);
                    }
                    else if (dictionary.ValueType == PrimaryType.TimeSpan)
                    {
                        builder.AppendLine("{0}[property] = moment.duration({0}[property]);", valueReference);
                    }
                }
                else if (dictionary.ValueType is CompositeType)
                {
                    builder.AppendLine("if ({0}[property] !== null && {0}[property] !== undefined) {{", valueReference)
                             .Indent()
                             .AppendLine(GetDeserializationString(dictionary.ValueType,
                                string.Format(CultureInfo.InvariantCulture, "{0}[property]", valueReference),
                                string.Format(CultureInfo.InvariantCulture, "{0}[property]", responseVariable)));
                }
                builder.Outdent()
                        .AppendLine("}")
                        .Outdent()
                    .AppendLine("}");
            }
            else if (composite != null)
            {
                builder.AppendLine("{0}.deserialize({1});", valueReference, responseVariable);
            }
            else if (enumType != null)
            {
                //Do No special deserialization
            }
            else
            {
                return string.Empty;
            }
            return builder.ToString();
        }


        public string ValidationString
        {
            get 
            {
                var builder = new IndentedStringBuilder("  ");
                foreach (var parameter in ParameterTemplateModels)
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

                    {
                        builder.AppendLine(parameter.Type.ValidateType(Scope, parameter.Name, parameter.IsRequired));
                    }
                }
                return builder.ToString();
            }
        }
        /// <summary>
        /// If the element type of a sequenece or value type of a dictionary 
        /// contains one of the following special types then it needs to be 
        /// processed. The special types are: Date, DateTime, ByteArray 
        /// and CompositeType
        /// </summary>
        /// <param name="type">The type to determine if special deserialization is required</param>
        /// <returns>True if special deserialization is required. False, otherwise.</returns>
        private static bool IsSpecialProcessingRequired(IType type)
        {
            PrimaryType[] validTypes = new PrimaryType[] { PrimaryType.DateTime, PrimaryType.Date, PrimaryType.DateTimeRfc1123, PrimaryType.ByteArray, PrimaryType.TimeSpan };
            SequenceType sequence = type as SequenceType;
            DictionaryType dictionary = type as DictionaryType;
            bool result = false;
            if (sequence != null &&
                (validTypes.Any(t => t == sequence.ElementType) || sequence.ElementType is CompositeType))
            {
                result = true;
            }
            else if (dictionary != null &&
                (validTypes.Any(t => t == dictionary.ValueType) || dictionary.ValueType is CompositeType))
            {
                result = true;
            }

            return result;
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
                     .AppendLine("{0} = JSON.parse(responseBody);", valueReference)
                     .AppendLine(type.InitializeSerializationType(Scope, valueReference, responseVariable, "client._models"));
            var deserializeBody = this.GetDeserializationString(type, valueReference, responseVariable);
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
            get { return ParameterTemplateModels.FirstOrDefault(p => p.Location == ParameterLocation.Body); }
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
        private static void AddQueryParametersToUrl(string variableName, IndentedStringBuilder builder)
        {
            builder.AppendLine("if (queryParameters.length > 0) {")
                .Indent()
                .AppendLine("{0} += '?' + queryParameters.join('&');", variableName).Outdent()
                .AppendLine("}");
        }

        /// <summary>
        /// Detremines whether the Uri will have any query string
        /// </summary>
        /// <returns>True if a query string is possible given the method parameters, otherwise false</returns>
        protected virtual bool HasQueryParameters()
        {
            return ParameterTemplateModels.Any(p => p.Location == ParameterLocation.Query);
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
            foreach (var queryParameter in ParameterTemplateModels
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

            foreach (var pathParameter in ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Path))
            {
                var pathReplaceFormat = "{0} = {0}.replace('{{{1}}}', encodeURIComponent({2}));";
                if (pathParameter.SkipUrlEncoding())
                {
                    pathReplaceFormat = "{0} = {0}.replace('{{{1}}}', {2});";
                }
                builder.AppendLine(pathReplaceFormat, variableName, pathParameter.SerializedName,
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

        public string InitializeRequestBody
        {
            get
            {
                var builder = new IndentedStringBuilder("  ");
                if (this.RequestBody != null)
                {
                    if (this.RequestBody.Type is CompositeType)
                    {
                        builder.AppendLine(RequestBody.Type.InitializeSerializationType(Scope, "requestModel", RequestBody.Name, "client._models"));
                    }
                    else
                    {
                        builder.AppendLine(RequestBody.Type.InitializeSerializationType(Scope, RequestBody.Name, RequestBody.Name, "client._models"));
                    }
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
                if (ReturnType is EnumType)
                {
                    string enumValues = "";
                    for (var i = 0; i <((EnumType)ReturnType).Values.Count; i++)
                    {
                        if (i == ((EnumType)ReturnType).Values.Count - 1)
                        {
                            enumValues += ((EnumType)ReturnType).Values[i].SerializedName;
                        }
                        else
                        {
                            enumValues += ((EnumType)ReturnType).Values[i].SerializedName + ", ";
                        }
                    }
                    result = string.Format(CultureInfo.InvariantCulture,
                        "Possible values for result are - {0}.", enumValues);
                }
                else if (ReturnType is CompositeType)
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
                if (ReturnType == null)
                {
                    typeName = "null";
                }
                else if (ReturnType is PrimaryType)
                {
                    typeName = ReturnType.Name;
                }
                else if (ReturnType is SequenceType)
                {
                    typeName = "array";
                }
                else if (ReturnType is EnumType)
                {
                    typeName = PrimaryType.String.Name;
                }
                else if (ReturnType is CompositeType || ReturnType is DictionaryType)
                {
                    typeName = PrimaryType.Object.Name;
                }

                return typeName.ToLower(CultureInfo.InvariantCulture);
            }
        }
    }
}