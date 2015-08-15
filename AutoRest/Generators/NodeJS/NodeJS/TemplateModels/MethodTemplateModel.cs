// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using Microsoft.CSharp;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.NodeJS.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

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
        /// Gets the expression for response body initialization 
        /// </summary>
        public virtual string InitializeResponseBody
        {
            get
            {
                return string.Empty;
            }
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
                var retValue = new List<ParameterTemplateModel>();

                foreach (var param in LocalParameters)
                {
                    traversalStack.Push(param);
                }

                while (traversalStack.Count() != 0)
                {
                    var param = traversalStack.Pop();
                    retValue.Add(param);
                    if (param.Type is CompositeType)
                    {
                        if (!visitedHash.ContainsKey(param.Type.Name))
                        {
                            foreach (var property in ((CompositeType)param.Type).Properties)
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
                    }
                }

                return retValue.OrderBy(p => p.Name).ToList();
            }
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
                return "void";
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

        public string GetDeserializationString(IType type, string valueReference = "result.body")
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
                    primary == PrimaryType.Date)
                {
                    builder.AppendLine("{0} = new Date({0});", valueReference);
                }
                else if (primary == PrimaryType.ByteArray)
                {
                    builder.AppendLine("{0} = new Buffer({0}, 'base64');", valueReference);
                }
            }
            else if (IsSpecialDeserializationRequired(sequence))
            {
                builder.AppendLine("for (var i = 0; i < {0}.length; i++) {{", valueReference)
                    .Indent()
                    .AppendLine("if ({0}[i] !== null && {0}[i] !== undefined) {{", valueReference)
                        .Indent();
                // Loop through the sequence if each property is Date, DateTime or ByteArray 
                // as they need special treatment for deserialization
                if (sequence.ElementType == PrimaryType.DateTime ||
                    sequence.ElementType == PrimaryType.Date)
                {
                    builder.AppendLine("{0}[i] = new Date({0}[i]);", valueReference);
                }
                else if (sequence.ElementType == PrimaryType.ByteArray)
                {
                    builder.AppendLine("{0}[i] = new Buffer({0}[i], 'base64');", valueReference);
                }
                else if (sequence.ElementType is CompositeType)
                {
                    builder.AppendLine(GetDeserializationString(sequence.ElementType,
                        string.Format(CultureInfo.InvariantCulture, "{0}[i]", valueReference)));
                }

                builder.Outdent()
                        .AppendLine("}")
                        .Outdent()
                    .AppendLine("}");
            }
            else if (IsSpecialDeserializationRequired(dictionary))
            {
                builder.AppendLine("for (var property in {0}) {{", valueReference)
                    .Indent()
                    .AppendLine("if ({0}[property] !== null && {0}[property] !== undefined) {{", valueReference)
                        .Indent();
                if (dictionary.ValueType == PrimaryType.DateTime ||
                    dictionary.ValueType == PrimaryType.Date)
                {
                    builder.AppendLine("{0}[property] = new Date({0}[property]);", valueReference);
                }
                else if (dictionary.ValueType == PrimaryType.ByteArray)
                {
                    builder.AppendLine("{0}[property] = new Buffer({0}[property], 'base64');", valueReference);
                }
                else if (dictionary.ValueType is CompositeType)
                {
                    builder.AppendLine(GetDeserializationString(dictionary.ValueType,
                        string.Format(CultureInfo.InvariantCulture, "{0}[property]", valueReference)));
                }
                builder.Outdent()
                        .AppendLine("}")
                        .Outdent()
                    .AppendLine("}");
            }
            else if (composite != null)
            {
                if (!string.IsNullOrEmpty(composite.PolymorphicDiscriminator))
                {
                    builder.AppendLine("if({0}['{1}'] !== null && {0}['{1}'] !== undefined && client._models.discriminators[{0}['{1}']]) {{",
                        valueReference,
                        composite.PolymorphicDiscriminator)
                        .Indent()
                            .AppendLine("{0} = client._models.discriminators[{0}['{1}']].deserialize({0});",
                                valueReference,
                                composite.PolymorphicDiscriminator)
                            .Outdent()
                        .AppendLine("} else {")
                        .Indent()
                            .AppendLine("throw new Error('No discriminator field \"{0}\" was found in response.');",
                                composite.PolymorphicDiscriminator)
                            .Outdent()
                        .AppendLine("}");
                }
                else
                {
                    builder.AppendLine("{0} = client._models['{1}'].deserialize({0});", valueReference, type.Name);
                }
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

        /// <summary>
        /// If the element type of a sequenece or value type of a dictionary 
        /// contains one of the following special types then it needs to be 
        /// deserialized. The special types are: Date, DateTime, ByteArray 
        /// and CompositeType
        /// </summary>
        /// <param name="type">The type to determine if special deserialization is required</param>
        /// <returns>True if special deserialization is required. False, otherwise.</returns>
        private static bool IsSpecialDeserializationRequired(IType type)
        {
            PrimaryType[] validTypes = new PrimaryType[] { PrimaryType.DateTime, PrimaryType.Date, PrimaryType.ByteArray };
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

        // TODO: no callers. Is this needed for NodeJS generator?
        public string GetExtensionParameters(string methodParameters)
        {
            string operationsParameter = "this I" + OperationName + " operations";
            return string.IsNullOrWhiteSpace(methodParameters)
                ? operationsParameter
                : operationsParameter + ", " + methodParameters;
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
    }
}