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
            AddCustomHeader = true;
        }

        public bool AddCustomHeader { get; private set; }

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
                        predicates.Add(((int)responseStatus).ToString(CultureInfo.InvariantCulture));
                    }

                    return string.Format(CultureInfo.InvariantCulture, "response.status_code not in [{0}]", string.Join(", ", predicates));
                }

                return "reponse.status_code < 200 or reponse.status_code >= 300";
            }
        }

        public virtual string RaisedException
        {
            get
            {
                if (DefaultResponse == null)
                {
                    return "HttpOperationException(self._deserialize, response)";
                }
                else if (DefaultResponse is CompositeType)
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0}(self._deserialize, response)", ((CompositeType)DefaultResponse).GetExceptionDefineType());
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
        public virtual string MethodParameterDeclaration(bool addCustomHeaderParameters)
        {
            List<string> declarations = new List<string>();
            foreach (var parameter in LocalParameters)
            {
                declarations.Add(parameter.Name);
            }

            if (addCustomHeaderParameters)
            {
                declarations.Add("custom_headers={}");
            }

            declarations.Add("raw=False");
            declarations.Add("callback=None");
            var declaration = string.Join(", ", declarations);
            return declaration;
        }
		
        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the url in.</param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "pathformatarguments"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1055:UriReturnValuesShouldNotBeStrings")]
        public virtual string BuildUrlPath(string variableName)
        {
            var builder = new IndentedStringBuilder("    ");

            var pathParameterList = this.LogicalParameters.Where(p => p.Location == ParameterLocation.Path).ToList();
            if (pathParameterList.Any())
            {
                builder.AppendLine("path_format_arguments = {").Indent();
                //builder.AppendLine("{0} = {0}.format(", variableName).Indent();

                for (int i = 0; i < pathParameterList.Count; i ++)
                {
                    builder.AppendLine("'{0}': self._parse_url(\"{1}\", {1}, '{2}', {3}){4}",
                        pathParameterList[i].SerializedName,
                        pathParameterList[i].Name,
                        pathParameterList[i].Type.ToPythonRuntimeTypeString(),
                        pathParameterList[i].SkipUrlEncoding(),
                        i == pathParameterList.Count-1 ? "}" : ",");
                }

                builder.Outdent();
                builder.AppendLine("{0} = {0}.format(**path_format_arguments)", variableName);
            }

            return builder.ToString();
        }

        /// <summary>
        /// Generate code to build the query of URL from method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the query in.</param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1055:UriReturnValuesShouldNotBeStrings")]
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
                        headerParameter.SerializedName, headerParameter.Type.ToString(headerParameter.Name))
                    .Outdent();
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

        public IEnumerable<ParameterTemplateModel> DocumentationParameters
        {
            get
            {
                return this.LocalParameters;
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
                return "null";
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1026:DefaultParametersShouldNotBeUsed"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase")]
        public static string GetDocumentationType(IType type, bool isRequired = true)
        {
            if (type == null)
            {
                return "None";
            }

            string result = PrimaryType.Object.Name;

            if (type is PrimaryType)
            {
                result = type.Name;
            }
            else if (type is SequenceType)
            {
                result = "list";
            }
            else if (type is EnumType)
            {
                result = PrimaryType.String.Name;
            }

            //If None is allowed
            if (!isRequired)
            {
                result += " or None";
            }

            return result.ToLower(CultureInfo.InvariantCulture);
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
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "customheaders")]
        public virtual string SetDefaultHeaders
        {
            get
            {
                if (this.AddCustomHeader)
                {
                    var sb = new IndentedStringBuilder();
                    sb.AppendLine("headers.update(custom_headers)");
                    return sb.ToString();
                }
                else
                {
                    return string.Empty;
                }
            }
        }

        public static string GetHttpFunction(HttpMethod method)
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
                    throw new ArgumentException(String.Format(CultureInfo.InvariantCulture, "wrong method {0}", method));
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
    }
}