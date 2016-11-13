// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.Python.Model
{
    public class MethodPy : Method
    {
        public MethodPy()
        {
            Url.OnGet += value =>
            {
                foreach (Match m in Regex.Matches(value, @"\{[\w]+:[\w]+\}"))
                {
                    var formatter = m.Value.Split(':').First() + '}';
                    value = value.Replace(m.Value, formatter);
                }
                return value;
            };
        }


        public bool AddCustomHeader => true;

        public string OperationName { get; set; }

        public IEnumerable<ParameterPy> ParameterTemplateModels => Parameters.Cast<ParameterPy>();

        public bool IsStreamResponse => this.ReturnType.Body.IsPrimaryType(KnownPrimaryType.Stream);

        public bool IsStreamRequestBody => LocalParameters.Any(parameter => 
            parameter.Location == ParameterLocation.Body && 
            parameter.ModelType.IsPrimaryType(KnownPrimaryType.Stream));

        public bool IsFormData => LocalParameters.Any(parameter => parameter.Location == ParameterLocation.FormData);

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

        public virtual string ExceptionDocumentation
        {
            get
            {
                IModelType body = DefaultResponse.Body;
                if (body == null)
                {
                    return ":class:`HttpOperationError<msrest.exceptions.HttpOperationError>`";
                }
                else
                {
                    //TODO: Namespace handling is already done on CodeModelPy
                    var modelNamespace = CodeModel.Name.ToPythonCase();
                    if (!CodeModel.Namespace.IsNullOrEmpty())
                        modelNamespace = CodeModel.Namespace;
                    CompositeType compType = body as CompositeType;
                    if (compType != null)
                    {
                        return string.Format(CultureInfo.InvariantCulture, ":class:`{0}<{1}.models.{0}>`", compType.GetExceptionDefineType(), modelNamespace.ToLower());
                    }
                    else
                    {
                        return ":class:`HttpOperationError<msrest.exceptions.HttpOperationError>`";
                    }
                }
            }
        }

        public virtual string RaisedException
        {
            get
            {
                IModelType body = DefaultResponse.Body;

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
            List<string> requiredDeclarations = new List<string>();
            List<string> combinedDeclarations = new List<string>();

            foreach (var parameter in DocumentationParameters)
            {
                if (parameter.IsRequired && parameter.DefaultValue.RawValue.IsNullOrEmpty())
                {
                    requiredDeclarations.Add(parameter.Name);
                }
                else
                {
                    declarations.Add(string.Format(
                        CultureInfo.InvariantCulture,
                        "{0}={1}",
                        parameter.Name,
                        parameter.DefaultValue));
                }
            }

            if (addCustomHeaderParameters)
            {
                declarations.Add("custom_headers=None");
            }

            declarations.Add("raw=False");
            if (this.NeedsCallback)
            {
                declarations.Add("callback=None");
            }
            declarations.Add("**operation_config");

            if (requiredDeclarations.Any())
            {
                combinedDeclarations.Add(string.Join(", ", requiredDeclarations));
            }
            combinedDeclarations.Add(string.Join(", ", declarations));
            return string.Join(", ", combinedDeclarations);
        }

        private string BuildSerializeDataCall(Parameter parameter, string functionName)
        {
            string divChar = ClientModelExtensions.NeedsFormattedSeparator(parameter);
            string divParameter = string.Empty;
            
            string parameterName = (MethodGroup as MethodGroupPy)?.ConstantProperties?.FirstOrDefault(each => each.Name.RawValue == parameter.Name.RawValue && each.DefaultValue.RawValue == parameter.DefaultValue.RawValue)?.Name.Else(parameter.Name) ?? parameter.Name;
            
            if (!string.IsNullOrEmpty(divChar))
            {
                divParameter = string.Format(CultureInfo.InvariantCulture, ", div='{0}'", divChar);
            }

            //TODO: This creates a very long line - break it up over multiple lines.
            return string.Format(CultureInfo.InvariantCulture,
                    "self._serialize.{0}(\"{1}\", {1}, '{2}'{3}{4}{5})",
                        functionName,
                        parameterName,
                        parameter.ModelType.ToPythonRuntimeTypeString(),
                        parameter.SkipUrlEncoding() ? ", skip_quote=True" : string.Empty,
                        divParameter,
                        BuildValidationParameters(parameter.Constraints));
        }
        private static string BuildValidationParameters(Dictionary<Constraint, string> constraints)
        {
            List<string> validators = new List<string>();
            foreach (var constraint in constraints.Keys)
            {
                switch (constraint)
                {
                    case Constraint.ExclusiveMaximum:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "maximum_ex={0}", constraints[constraint]));
                        break;
                    case Constraint.ExclusiveMinimum:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "minimum_ex={0}", constraints[constraint]));
                        break;
                    case Constraint.InclusiveMaximum:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "maximum={0}", constraints[constraint]));
                        break;
                    case Constraint.InclusiveMinimum:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "minimum={0}", constraints[constraint]));
                        break;
                    case Constraint.MaxItems:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "max_items={0}", constraints[constraint]));
                        break;
                    case Constraint.MaxLength:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "max_length={0}", constraints[constraint]));
                        break;
                    case Constraint.MinItems:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "min_items={0}", constraints[constraint]));
                        break;
                    case Constraint.MinLength:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "min_length={0}", constraints[constraint]));
                        break;
                    case Constraint.MultipleOf:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "multiple={0}", constraints[constraint]));
                        break;
                    case Constraint.Pattern:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "pattern='{0}'", constraints[constraint]));
                        break;
                    case Constraint.UniqueItems:
                        var pythonBool = Convert.ToBoolean(constraints[constraint], CultureInfo.InvariantCulture) ? "True" : "False";
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "unique={0}", pythonBool));
                        break;
                    default:
                        throw new NotSupportedException("Constraint '" + constraint + "' is not supported.");
                }
            }
            if (!validators.Any())
            {
                return string.Empty;
            }
            return ", " + string.Join(", ", validators);

        }

        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the url in.</param>
        /// <param name="pathParameters">The list of parameters for url construction.</param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "pathformatarguments"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1055:UriReturnValuesShouldNotBeStrings")]
        public virtual string BuildUrlPath(string variableName, IEnumerable<Parameter> pathParameters)
        {
            var builder = new IndentedStringBuilder("    ");
            if (pathParameters == null)
                return builder.ToString();

            var pathParameterList = pathParameters.Where(p => p.Location == ParameterLocation.Path).ToList();
            if (pathParameterList.Any())
            {
                builder.AppendLine("path_format_arguments = {").Indent();

                for (int i = 0; i < pathParameterList.Count; i++)
                {
                    builder.AppendLine("'{0}': {1}{2}{3}",
                        pathParameterList[i].SerializedName,
                        BuildSerializeDataCall(pathParameterList[i], "url"),
                        pathParameterList[i].IsRequired ? string.Empty :
                            string.Format(CultureInfo.InvariantCulture, "if {0} else ''", pathParameterList[i].Name),
                        i == pathParameterList.Count - 1 ? "" : ",");
                }

                builder.Outdent().AppendLine("}");
                builder.AppendLine("{0} = self._client.format_url({0}, **path_format_arguments)", variableName);
            }

            return builder.ToString();
        }

        /// <summary>
        /// Generate code to build the query of URL from method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the query in.</param>
        /// <param name="queryParameters">The list of parameters for url construction.</param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1055:UriReturnValuesShouldNotBeStrings")]
        public virtual string BuildUrlQuery(string variableName, IEnumerable<Parameter> queryParameters)
        {
            var builder = new IndentedStringBuilder("    ");
            if (queryParameters == null)
                return builder.ToString();

            foreach (var queryParameter in queryParameters.Where(p => p.Location == ParameterLocation.Query))
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

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "addheaders"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "ClientRawResponse"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "clientrawresponse"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)")]
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

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "addheaders"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "headerdict"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "clientrawresponse")]
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

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)")]
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
                var enumType = prop.ModelType as EnumType;
                if (CodeModel.EnumTypes.Contains(prop.ModelType) && !enumType.ModelAsString)
                {
                    builder.AppendLine(String.Format(CultureInfo.InvariantCulture, "'{0}': models.{1},", prop.SerializedName, prop.ModelType.ToPythonRuntimeTypeString()));
                }
                else
                {
                    builder.AppendLine(String.Format(CultureInfo.InvariantCulture, "'{0}': '{1}',", prop.SerializedName, prop.ModelType.ToPythonRuntimeTypeString()));
                }
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "headerdict")]
        public virtual string AddIndividualResponseHeader(HttpStatusCode? code)
        {
            IModelType headersType = null;

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
        public IEnumerable<ParameterPy> LocalParameters
        {
            get
            {
                return ParameterTemplateModels.Where(
                    p => p != null && !p.IsClientProperty && !string.IsNullOrWhiteSpace(p.Name))
                    .OrderBy(item => !item.IsRequired);
            }
        }

        public IEnumerable<ParameterPy> DocumentationParameters
        {
            get
            {
                return this.LocalParameters.Where(p => !p.IsConstant);
            }
        }

        public IEnumerable<ParameterPy> ConstantParameters
        {
            get
            {
                var constantParameters = LocalParameters.Where(p => p.IsConstant && !p.Name.StartsWith("self."));

                if (!constantParameters.Any())
                {
                    return constantParameters;
                }

                var m = MethodGroup as MethodGroupPy;
                if (m?.ConstantProperties != null)
                {
                    if (!m.ConstantProperties.Any())
                    {
                        return constantParameters;
                    }

                    return constantParameters.Where(parameter =>
                            !m.ConstantProperties.Any(constantProperty =>
                                constantProperty.Name.RawValue == parameter.Name.RawValue &&
                                constantProperty.DefaultValue.Value == parameter.DefaultValue.Value)
                    );
                }

               return constantParameters;
            }
        }

        /// <summary>
        /// Provides the parameter documentation string.
        /// </summary>
        /// <param name="parameter">Parameter to be documented</param>
        /// <returns>Parameter documentation string correct notation</returns>
        public static string GetParameterDocumentationString(Parameter parameter)
        {
            if (parameter == null)
            {
                throw new ArgumentNullException("parameter");
            }

            string docString = ":param ";

            docString += parameter.Name + ":";

            if (!string.IsNullOrWhiteSpace(parameter.Documentation))
            {
                docString += " " + parameter.Documentation;
            }

            return docString;
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

        public string GetReturnTypeDocumentation(IModelType type)
        {
            return (type as IExtendedModelTypePy)?.ReturnTypeDocumentation ?? PythonConstants.None;
        }

        public string GetDocumentationType(IModelType type)
        {
            return (type as IExtendedModelTypePy)?.TypeDocumentation ?? PythonConstants.None;
        }

        /// <summary>
        /// Get the method's request body (or null if there is no request body)
        /// </summary>
        public ParameterPy RequestBody => Body as ParameterPy;

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
                    transformation.OutputParameter.ModelType is CompositeType)
                {
                    var comps = CodeModel.ModelTypes.Where(x => x.Name == transformation.OutputParameter.ModelTypeName);
                    var composite = comps.First();

                    List<string> combinedParams = new List<string>();
                    List<string> paramCheck = new List<string>();

                    foreach (var mapping in transformation.ParameterMappings)
                    {
                        // var mappedParams = composite.ComposedProperties.Where(x => x.Name.RawValue == mapping.InputParameter.Name.RawValue);
                        var mappedParams = composite.ComposedProperties.Where(x => x.Name == mapping.InputParameter.Name);
                        if (mappedParams.Any())
                        {
                            var param = mappedParams.First();
                            combinedParams.Add(string.Format(CultureInfo.InvariantCulture, "{0}={0}", param.Name));
                            paramCheck.Add(string.Format(CultureInfo.InvariantCulture, "{0} is not None", param.Name));
                        }
                    }

                    if (!transformation.OutputParameter.IsRequired)
                    {
                        builder.AppendLine("{0} = None", transformation.OutputParameter.Name);
                        builder.AppendLine("if {0}:", string.Join(" or ", paramCheck)).Indent();
                    }
                    builder.AppendLine("{0} = models.{1}({2})",
                        transformation.OutputParameter.Name,
                        transformation.OutputParameter.ModelType.Name,
                        string.Join(", ", combinedParams));
                }
                else
                {
                    builder.AppendLine("{0} = None",
                            transformation.OutputParameter.Name);
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
            }

            return builder.ToString();
        }

        /// <summary>
        /// Gets the expression for default header setting. 
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "headerparameters"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "customheaders")]
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
                IModelType body = ReturnType.Body;
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

        public string BuildSummaryAndDescriptionString()
        {
            return CodeGeneratorPy.BuildSummaryAndDescriptionString(this.Summary, this.Description);
        }
    }
}