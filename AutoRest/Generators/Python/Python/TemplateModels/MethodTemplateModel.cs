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

        public bool IsStreamResponse
        {
            get { return this.ReturnType.Body == PrimaryType.Stream; }
        }

        public bool IsStreamRequestBody
        {
            get
            {
                foreach (var parameter in LocalParameters)
                {
                    if (parameter.Location == ParameterLocation.Body && parameter.Type == PrimaryType.Stream)
                    {
                        return true;
                    }
                }
                return false;
            }
        }

        public bool IsFormData
        {
            get
            {
                foreach (var parameter in LocalParameters)
                {
                    if (parameter.Location == ParameterLocation.FormData)
                    {
                        return true;
                    }
                }
                return false;
            }
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

                return "response.status_code < 200 or response.status_code >= 300";
            }
        }

        public virtual bool NeedsCallback
        {
            get
            {
                if (IsStreamResponse || IsStreamRequestBody)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public virtual string RaisedException
        {
            get
            {
                IType body = DefaultResponse.Body;

                if (body == null)
                {
                    return "raise HttpOperationError(self._deserialize, response)";
                }
                else
                {
                    CompositeType compType = body as CompositeType;
                    if (compType != null)
                    {
                        return string.Format(CultureInfo.InvariantCulture, "raise models.{0}(self._deserialize, response)", compType.GetExceptionDefineType());
                    }
                    else
                    {
                        return string.Format(CultureInfo.InvariantCulture, "raise HttpOperationError(self._deserialize, response, '{0}')", body.ToPythonRuntimeTypeString());
                    }
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
                if (parameter.IsRequired)
                {
                    declarations.Add(parameter.Name);
                }
                else
                {
                    declarations.Add(string.Format(CultureInfo.InvariantCulture, "{0}=None", parameter.Name));
                }
            }

            if (addCustomHeaderParameters)
            {
                declarations.Add("custom_headers={}");
            }

            declarations.Add("raw=False");
            if (this.NeedsCallback)
            {
                declarations.Add("callback=None");
            }
            declarations.Add("**operation_config");
            var declaration = string.Join(", ", declarations);
            return declaration;
        }

        private static string BuildSerializeDataCall(Parameter parameter, string functionName)
        {
            string divChar = ClientModelExtensions.NeedsFormattedSeparator(parameter);
            string divParameter = string.Empty;

            if (!string.IsNullOrEmpty(divChar))
            {
                divParameter = string.Format(CultureInfo.InvariantCulture, ", div='{0}'", divChar);
            }

            return string.Format(CultureInfo.InvariantCulture,
                    "self._serialize.{0}(\"{1}\", {1}, '{2}'{3}{4})",
                        functionName,
                        parameter.Name,
                        parameter.Type.ToPythonRuntimeTypeString(),
                        parameter.SkipUrlEncoding() ? ", skip_quote=True" : string.Empty,
                        divParameter);
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

                for (int i = 0; i < pathParameterList.Count; i ++)
                {
                    builder.AppendLine("'{0}': {1}{2}{3}",
                        pathParameterList[i].SerializedName,
                        BuildSerializeDataCall(pathParameterList[i], "url"),
                        pathParameterList[i].IsRequired ? string.Empty :
                            string.Format(CultureInfo.InvariantCulture, "if {0} else ''", pathParameterList[i].Name),
                        i == pathParameterList.Count-1 ? "" : ",");
                }

                builder.Outdent().AppendLine("}");
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
                if (queryParameter.IsRequired)
                {
                    builder.AppendLine("{0}['{1}'] = {2}",
                                variableName,
                                queryParameter.SerializedName,
                                BuildSerializeDataCall(queryParameter, "query"));
                }
                else
                {
                    builder.AppendLine("if {0} is not None:", queryParameter.Name)
                        .Indent()
                        .AppendLine("{0}['{1}'] = {2}",
                                variableName,
                                queryParameter.SerializedName,
                                BuildSerializeDataCall(queryParameter, "query"))
                        .Outdent();
                }
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
                if (headerParameter.IsRequired)
                {
                    builder.AppendLine("{0}['{1}'] = {2}",
                            variableName,
                            headerParameter.SerializedName,
                            BuildSerializeDataCall(headerParameter, "header"));
                }
                else
                {
                    builder.AppendLine("if {0} is not None:", headerParameter.Name)
                        .Indent()
                        .AppendLine("{0}['{1}'] = {2}", 
                            variableName,
                            headerParameter.SerializedName,
                            BuildSerializeDataCall(headerParameter, "header"))
                        .Outdent();
                }
            }

            return builder.ToString();
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "addheaders"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "ClientRawResponse"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "clientrawresponse"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Utilities.IndentedStringBuilder.AppendLine(System.String)")]
        public virtual string ReturnEmptyResponse
        {
            get
            {
                var builder = new IndentedStringBuilder("    ");
                builder.AppendLine("if raw:").Indent().
                    AppendLine("client_raw_response = ClientRawResponse(None, response)");
                if (this.ReturnType.Headers != null)
                {
                    builder.AppendLine("client_raw_response.add_headers({").Indent();
                    AddHeaderDictionary(builder, (CompositeType)ReturnType.Headers);
                    builder.Outdent().AppendLine("})");
                }
                builder.AppendLine("return client_raw_response").
                    Outdent();

                return builder.ToString();
            }
        }

        public bool HasResponseHeader
        {
            get
            {
                if (this.ReturnType.Headers != null || this.Responses.Any(r => r.Value.Headers != null))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "addheaders"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "headerdict"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "clientrawresponse")]
        public virtual string AddResponseHeader()
        {
            if (HasResponseHeader)
            {
                var builder = new IndentedStringBuilder("    ");
                builder.AppendLine("client_raw_response.add_headers(header_dict)");
                return builder.ToString();
            }
            else
            {
                return string.Empty;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Utilities.IndentedStringBuilder.AppendLine(System.String)")]
        protected void AddHeaderDictionary(IndentedStringBuilder builder, CompositeType headersType)
        {
            if (builder == null)
            {
                throw new ArgumentNullException("builder");
            }
            if (headersType == null)
            {
                throw new ArgumentNullException("headersType");
            }

            foreach (var prop in headersType.Properties)
            {
                if (this.ServiceClient.EnumTypes.Contains(prop.Type))
                {
                    builder.AppendLine(String.Format(CultureInfo.InvariantCulture, "'{0}': models.{1},", prop.SerializedName, prop.Type.ToPythonRuntimeTypeString()));
                }
                else
                {
                    builder.AppendLine(String.Format(CultureInfo.InvariantCulture, "'{0}': '{1}',", prop.SerializedName, prop.Type.ToPythonRuntimeTypeString()));
                }
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "headerdict")]
        public virtual string AddIndividualResponseHeader(HttpStatusCode? code)
        {
            IType headersType = null;

            if (HasResponseHeader)
            {
                if (code != null)
                {
                    headersType = this.ReturnType.Headers;
                }
                else
                {
                    headersType = this.Responses[code.Value].Headers;
                }
            }

            var builder = new IndentedStringBuilder("    ");
            if (headersType == null)
            {
                if (code == null)
                {
                    builder.AppendLine("header_dict = {}");
                }
                else
                {
                    return string.Empty;
                }
            }
            else
            {
                builder.AppendLine("header_dict = {").Indent();
                AddHeaderDictionary(builder, (CompositeType)headersType);
                builder.Outdent().AppendLine("}");
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
                if (ReturnType.Body != null)
                {
                    return ReturnType.Body.Name;
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
                result = type.Name.ToLower(CultureInfo.InvariantCulture);
            }
            else if (type is SequenceType)
            {
                result = "list";
            }
            else if (type is EnumType)
            {
                result = PrimaryType.String.Name.ToLower(CultureInfo.InvariantCulture);
            }
            else if (type is DictionaryType)
            {
                result = "dict";
            }
            else if (type is CompositeType)
            {
                result = type.Name;
            }

            //If None is allowed
            if (!isRequired)
            {
                result += " or None";
            }

            return result;
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

        public static string GetStatusCodeReference(HttpStatusCode code)
        {
            return string.Format(CultureInfo.InvariantCulture, "{0}", (int)code);
        }

        private static string BuildNullCheckExpression(ParameterTransformation transformation)
        {
            if (transformation == null)
            {
                throw new ArgumentNullException("transformation");
            }

            return string.Join(" or ",
                transformation.ParameterMappings.Select(m =>
                    string.Format(CultureInfo.InvariantCulture,
                    "{0} is not None", m.InputParameter.Name)));
        }

        /// <summary>
        /// Generates input mapping code block.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildInputMappings()
        {
            var builder = new IndentedStringBuilder("    ");
            foreach (var transformation in InputParameterTransformation)
            {
                if (transformation.ParameterMappings.Any(m => !string.IsNullOrEmpty(m.OutputParameterProperty)) &&
                    transformation.OutputParameter.Type is CompositeType)
                {
                    builder.AppendLine("{0} = models.{1}()",
                        transformation.OutputParameter.Name,
                        transformation.OutputParameter.Type.Name);
                }
                else
                {
                    builder.AppendLine("{0} = None",
                            transformation.OutputParameter.Name);
                }

                builder.AppendLine("if {0}:", BuildNullCheckExpression(transformation))
                       .Indent();
                foreach (var mapping in transformation.ParameterMappings)
                {
                    builder.AppendLine("{0}{1}",
                        transformation.OutputParameter.Name,
                        mapping);
                }

                builder.Outdent();
            }

            return builder.ToString();
        }

        /// <summary>
        /// Gets the expression for default header setting. 
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "headerparameters"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "customheaders")]
        public virtual string SetDefaultHeaders
        {
            get
            {
                if (this.AddCustomHeader)
                {
                    var sb = new IndentedStringBuilder();
                    sb.AppendLine("if custom_headers:").Indent().AppendLine("header_parameters.update(custom_headers)").Outdent();
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
                if (Responses.Where(r => r.Value.Body != null).Any())
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
                IType body = ReturnType.Body;
                EnumType enumType = body as EnumType;

                if (enumType != null)
                {
                    string enumValues = "";
                    for (var i = 0; i < enumType.Values.Count; i++)
                    {
                        if (i == enumType.Values.Count - 1)
                        {
                            enumValues += enumType.Values[i].SerializedName;
                        }
                        else
                        {
                            enumValues += enumType.Values[i].SerializedName + ", ";
                        }
                    }
                    result = string.Format(CultureInfo.InvariantCulture,
                        "Possible values for result are - {0}.", enumValues);
                }
                else if (body is CompositeType)
                {
                    result = string.Format(CultureInfo.InvariantCulture,
                        "See {{@link {0}}} for more information.", ReturnTypeString);
                }

                return result;
            }
        }
    }
}