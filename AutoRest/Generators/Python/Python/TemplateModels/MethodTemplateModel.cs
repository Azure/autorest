// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Collections;
using System.Text;

namespace Microsoft.Rest.Generator.Python
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
                        predicates.Add(((int)responseStatus).ToString());
                    }

                    return string.Format(CultureInfo.InvariantCulture, "response.status_code not in [{0}]", string.Join(" , ", predicates));
                }

                return "reponse.status_code < 200 or reponse.status_code >= 300";
            }
        }

        public string RaisedException
        {
            get
            {
                if (DefaultResponse == null)
                {
                    return string.Format(CultureInfo.InvariantCulture, "HttpOperationException(self._deserialize, response)");
                }
                else if (DefaultResponse is CompositeType)
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0}Exception(self._deserialize, response)", DefaultResponse.Name);
                }
                else
                {
                    return string.Format(CultureInfo.InvariantCulture, "HttpOperationException(self._deserialize, response, '{0}')", DefaultResponse.ToPythonRuntimeTypeString());
                }
            }
        }

        /// <summary>
        /// Generate the method parameter declarations for a method
        /// </summary>
        /// <param name="addCustomHeaderParameters">If true add the customHeader to the parameters</param>
        /// <returns>Generated string of parameters</returns>
        public string MethodParameterDeclaration(bool addCustomHeaderParameters)
        {
            List<string> declarations = new List<string>();
            foreach (var parameter in LocalParameters)
            {
                declarations.Add(parameter.Name);
            }

            if (addCustomHeaderParameters)
            {
                declarations.Add("custom_headers = {}");
            }

            declarations.Add("raw = False");
            declarations.Add("callback = None");
            var declaration = string.Join(", ", declarations);
            return declaration;
        }
		
        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the url in.</param>
        /// <returns></returns>
        public virtual string BuildUrlPath(string variableName)
        {
            var builder = new IndentedStringBuilder("    ");

            var pathParameterList = this.LogicalParameters.Where(p => p.Location == ParameterLocation.Path).ToList();
            if (pathParameterList.Any())
            {
                builder.AppendLine("{0} = {0}.format(", variableName).Indent();

                for (int i = 0; i < pathParameterList.Count; i ++)
                {
                    builder.AppendLine("{0} = self._parse_url(\"{1}\", {1}, '{2}', {3}){4}",
                        pathParameterList[i].SerializedName,
                        pathParameterList[i].Name,
                        pathParameterList[i].Type.ToPythonRuntimeTypeString(),
                        pathParameterList[i].SkipUrlEncoding(),
                        i == pathParameterList.Count-1 ? ")" : ",");
                }
            }

            return builder.ToString();
        }

        /// <summary>
        /// Generate code to build the query of URL from method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the query in.</param>
        /// <returns></returns>
        public virtual string BuildUrlQuery(string variableName)
        {
            var builder = new IndentedStringBuilder("    ");

            foreach (var queryParameter in this.LogicalParameters.Where(p => p.Location == ParameterLocation.Query))
            {
                builder.AppendLine("if {0} is not None:", queryParameter.Name)
                    .Indent()
                    .AppendLine("{0}['{1}'] = self._parse_url(\"{2}\", {2}, '{3}', {4})", 
                            variableName,
                            queryParameter.SerializedName, 
                            queryParameter.Name, 
                            queryParameter.Type.ToPythonRuntimeTypeString(), 
                            queryParameter.SkipUrlEncoding())
                    .Outdent();
            }

            return builder.ToString();
        }

        /// <summary>
        /// Generate code to build the headers from method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the headers in.</param>
        /// <returns></returns>
        public virtual string BuildHeaders(string variableName)
        {
            var builder = new IndentedStringBuilder("    ");

            foreach (var headerParameter in this.LogicalParameters.Where(p => p.Location == ParameterLocation.Header))
            {
                builder.AppendLine("if {0} is not None:", headerParameter.Name)
                    .Indent()
                    .AppendLine("{0}['{1}'] = {2}", variableName,
                        headerParameter.SerializedName, headerParameter.Type.ToString(headerParameter.Name));
            }

            return builder.ToString();
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
            var builder = new IndentedStringBuilder("    ");
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

        /// <summary>
        /// Get the method's request body (or null if there is no request body)
        /// </summary>
        public ParameterTemplateModel RequestBody
        {
            get { return ParameterTemplateModels.FirstOrDefault(p => p.Location == ParameterLocation.Body); }
        }

        public static string GetStatusCodeReference(HttpStatusCode code)
        {
            return string.Format(CultureInfo.InvariantCulture, "{0}", (int)code);
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

        public string GetHttpFunction(HttpMethod method)
        {
            switch (method)
            {
                case HttpMethod.Delete:
                    return "delete";
                case HttpMethod.Get:
                    return "get";
                case HttpMethod.Head:
                    return "head";
                case HttpMethod.Patch:
                    return "patch";
                case HttpMethod.Post:
                    return "post";
                case HttpMethod.Put:
                    return "put";
                default:
                    throw new Exception(String.Format(CultureInfo.InvariantCulture, "wrong method {0}", method));
            }
        }

        public bool HasAnyResponse
        {
            get
            {
                if (Responses.Where(r => r.Value != null).Any())
                {
                    return true;
                }
                return false;
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