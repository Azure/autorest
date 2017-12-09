// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using Newtonsoft.Json;

namespace AutoRest.CSharp.LoadBalanced.Model
{
    public class MethodCs : Method
    {
        public MethodCs()
        {

        }
        
        public bool IsCustomBaseUri
            => CodeModel.Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);

        public SyncMethodsGenerationMode SyncMethods { get; set; }

        /// <summary>
        /// Get the predicate to determine of the http operation status code indicates failure
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
                            "(int)_statusCode != {0}", GetStatusCodeReference(responseStatus)));
                    }

                    return string.Join(" && ", predicates);
                }
                return "!_httpResponse.IsSuccessStatusCode";
            }
        }

        /// <summary>
        /// Generate the method parameter declaration for async methods and extensions
        /// </summary>
        public virtual string GetAsyncMethodParameterDeclaration()
        {
            return this.GetAsyncMethodParameterDeclaration(false);
        }

        /// <summary>
        /// Generate the method parameter declaration for sync methods and extensions
        /// </summary>
        /// <param name="addCustomHeaderParameters">If true add the customHeader to the parameters</param>
        /// <returns>Generated string of parameters</returns>
        public virtual string GetSyncMethodParameterDeclaration(bool addCustomHeaderParameters)
        {
            List<string> declarations = new List<string>();
            foreach (var parameter in LocalParameters)
            {
                string format = (parameter.IsRequired ? "{0} {1}" : "{0} {1} = {2}");

                string defaultValue = $"default({parameter.ModelTypeName})";
                if (!string.IsNullOrEmpty(parameter.DefaultValue) && parameter.ModelType is PrimaryType)
                {
                    defaultValue = parameter.DefaultValue;
                }
                declarations.Add(string.Format(CultureInfo.InvariantCulture,
                    format, parameter.ModelTypeName, parameter.Name, defaultValue));
            }

            if (addCustomHeaderParameters)
            {
                declarations.Add("Dictionary<string, string> customHeaders = null");
            }

            return string.Join(", ", declarations);
        }

        /// <summary>
        /// Generate the method parameter declaration for async methods and extensions
        /// </summary>
        /// <param name="addCustomHeaderParameters">If true add the customHeader to the parameters</param>
        /// <returns>Generated string of parameters</returns>
        public virtual string GetAsyncMethodParameterDeclaration(bool addCustomHeaderParameters)
        {
            var declarations = this.GetSyncMethodParameterDeclaration(addCustomHeaderParameters);
            return string.Join(", ", declarations);
        }

        /// <summary>
        /// Arguments for invoking the method from a synchronous extension method
        /// </summary>
        public string SyncMethodInvocationArgs => string.Join(", ", LocalParameters.Select(each => each.Name));

        /// <summary>
        /// Get the invocation args for an invocation with an async method
        /// </summary>
        public string GetAsyncMethodInvocationArgs(string customHeaderReference, string cancellationTokenReference = "cancellationToken") => string.Join(", ", LocalParameters.Select(each => (string)each.Name).Concat(new[] { customHeaderReference, cancellationTokenReference }));

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they appear in the method signature
        /// exclude global parameters
        /// </summary>
        [JsonIgnore]
        public IEnumerable<ParameterCs> LocalParameters
        {
            get
            {
                return
                    Parameters.Where(parameter =>
                        parameter != null &&
                        !parameter.IsClientProperty &&
                        !string.IsNullOrWhiteSpace(parameter.Name) &&
                        !parameter.IsConstant)
                        .OrderBy(item => !item.IsRequired).Cast<ParameterCs>();
            }
        }

        /// <summary>
        /// Get the return type name for the underlying interface method
        /// </summary>
        public virtual string OperationResponseReturnTypeString => GetOperationResponseReturnTypeString();

        public virtual string GetOperationResponseReturnTypeString(string typeName = "Task")
        {
            if (ReturnType.Body != null)
            {
                return $"{typeName}<{OperationResponseType}>";
            }

            return typeName;
        }


        public string OperationResponseType
        {
            get
            {
                var typeName = ReturnType.Body?.AsNullableType(HttpMethod != HttpMethod.Head);

                if (string.IsNullOrWhiteSpace(typeName))
                {
                    return "dynamic";
                }

                return typeName.Replace("System.Collections.Generic.", ""); // TODO: all using namespace
            }
        } 

        /// <summary>
        /// Get the return type for the async extension method
        /// </summary>
        public virtual string TaskExtensionReturnTypeString
        {
            get
            {
                if (ReturnType.Body != null)
                {
                    return string.Format(CultureInfo.InvariantCulture,
                        "Task<{0}>", ReturnType.Body.AsNullableType(HttpMethod != HttpMethod.Head));
                }

                if (ReturnType.Headers != null)
                {
                    return string.Format(CultureInfo.InvariantCulture,
                        "Task<{0}>", ReturnType.Headers.AsNullableType(HttpMethod != HttpMethod.Head));
                }

                return "Task";
            }
        }

        /// <summary>
        /// Get the type for operation exception
        /// </summary>
        public virtual string OperationExceptionTypeString
        {
            get
            {
                if (!(this.DefaultResponse.Body is CompositeType))
                {
                    return "HttpOperationException";
                }

                CompositeType type = this.DefaultResponse.Body as CompositeType;
                if (!type.Extensions.ContainsKey(SwaggerExtensions.NameOverrideExtension))
                {
                    return type.Name + "Exception";
                }

                var ext = type.Extensions[SwaggerExtensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
                if (ext != null && ext["name"] != null)
                {
                    return ext["name"].ToString();
                }
                return type.Name + "Exception";
            }
        }

        /// <summary>
        /// Get the expression for exception initialization with message.
        /// </summary>
        public virtual string InitializeExceptionWithMessage => string.Empty;

        /// <summary>
        /// Get the expression for exception initialization with message.
        /// </summary>
        public virtual string InitializeException => string.Empty;

        /// <summary>
        /// Gets the expression for response body initialization.
        /// </summary>
        public virtual string InitializeResponseBody => string.Empty;

        /// <summary>
        /// Gets the expression for default header setting.
        /// </summary>
        public virtual string SetDefaultHeaders => string.Empty;

        /// <summary>
        /// Get the type name for the method's return type
        /// </summary>
        public virtual string ReturnTypeString
        {
            get
            {
                if (ReturnType.Body != null)
                {
                    return ReturnType.Body.AsNullableType(HttpMethod != HttpMethod.Head);
                }

                return ReturnType.Headers != null ? ReturnType.Headers.AsNullableType(HttpMethod != HttpMethod.Head) : "void";
            }
        }

        /// <summary>
        /// Get the method's request body (or null if there is no request body)
        /// </summary>
        [JsonIgnore]
        public ParameterCs RequestBody => Body as ParameterCs;

        /// <summary>
        /// Generate a reference to the ServiceClient
        /// </summary>
        [JsonIgnore]
        public string ClientReference => Group.IsNullOrEmpty() ? "this" : "this.Client";

        /// <summary>
        /// Returns serialization settings reference.
        /// </summary>
        /// <param name="serializationType"></param>
        /// <returns></returns>
        public string GetSerializationSettingsReference(IModelType serializationType)
        {
            if (serializationType.IsOrContainsPrimaryType(KnownPrimaryType.Date))
            {
                return "new DateJsonConverter()";
            }

            if (serializationType.IsOrContainsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
            {
                return "new DateTimeRfc1123JsonConverter()";
            }

            if (serializationType.IsOrContainsPrimaryType(KnownPrimaryType.Base64Url))
            {
                return "new Base64UrlJsonConverter()";
            }

            if (serializationType.IsOrContainsPrimaryType(KnownPrimaryType.UnixTime))
            {
                return "new UnixTimeJsonConverter()";
            }
            return ClientReference + ".SerializationSettings";
        }

        /// <summary>
        /// Returns deserialization settings reference.
        /// </summary>
        /// <param name="deserializationType"></param>
        /// <returns></returns>
        public string GetDeserializationSettingsReference(IModelType deserializationType)
        {
            if (deserializationType.IsOrContainsPrimaryType(KnownPrimaryType.Date))
            {
                return "new DateJsonConverter()";
            }

            if (deserializationType.IsOrContainsPrimaryType(KnownPrimaryType.Base64Url))
            {
                return "new Base64UrlJsonConverter()";
            }

            if (deserializationType.IsOrContainsPrimaryType(KnownPrimaryType.UnixTime))
            {
                return "new UnixTimeJsonConverter()";
            }

            return ClientReference + ".DeserializationSettings";
        }

        public string GetExtensionParameters(string methodParameters)
        {
            string operationsParameter = "this I" + MethodGroup.TypeName + " operations";
            return string.IsNullOrWhiteSpace(methodParameters)
                ? operationsParameter
                : operationsParameter + ", " + methodParameters;
        }

        public static string GetStatusCodeReference(HttpStatusCode code)
        {
            return ((int)code).ToString(CultureInfo.InvariantCulture);
        }

        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the url in.</param>
        /// <returns></returns>
        public virtual string BuildUrl(string variableName)
        {
            var builder = new IndentedStringBuilder();

            foreach (var pathParameter in this.LogicalParameters.Where(p => p.Location == ParameterLocation.Path))
            {
                string replaceString = "{0} = {0}.Replace(\"{{{1}}}\", Uri.EscapeDataString({2}));";
                if (pathParameter.SkipUrlEncoding())
                {
                    replaceString = "{0} = {0}.Replace(\"{{{1}}}\", {2});";
                }
                var urlPathName = pathParameter.SerializedName;
                if (pathParameter.ModelType is SequenceType)
                {
                    builder.AppendLine(replaceString,
                    variableName,
                    urlPathName,
                    pathParameter.GetFormattedReferenceValue(ClientReference));
                }
                else
                {
                    builder.AppendLine(replaceString,
                    variableName,
                    urlPathName,
                    pathParameter.ModelType.ToString(ClientReference, pathParameter.Name));
                }
            }
            if (this.LogicalParameters.Any(p => p.Location == ParameterLocation.Query))
            {
                builder.AppendLine("List<string> _queryParameters = new SList<string>();");
                foreach (var queryParameter in this.LogicalParameters.Where(p => p.Location == ParameterLocation.Query))
                {
                    var replaceString = "_queryParameters.Add(string.Format(\"{0}={{0}}\", Uri.EscapeDataString({1})));";
                    if ((queryParameter as ParameterCs).IsNullable())
                    {
                        builder.AppendLine("if ({0} != null)", queryParameter.Name)
                            .AppendLine("{").Indent();
                    }

                    if (queryParameter.SkipUrlEncoding())
                    {
                        replaceString = "_queryParameters.Add(string.Format(\"{0}={{0}}\", {1}));";
                    }

                    if (queryParameter.CollectionFormat == CollectionFormat.Multi)
                    {
                        builder.AppendLine("if ({0}.Count == 0)", queryParameter.Name)
                           .AppendLine("{").Indent()
                           .AppendLine(replaceString, queryParameter.SerializedName, "string.Empty").Outdent()
                           .AppendLine("}")
                           .AppendLine("else")
                           .AppendLine("{").Indent()
                           .AppendLine("foreach (var _item in {0})", queryParameter.Name)
                           .AppendLine("{").Indent()
                           .AppendLine(replaceString, queryParameter.SerializedName, "_item ?? string.Empty").Outdent()
                           .AppendLine("}").Outdent()
                           .AppendLine("}").Outdent();
                    }
                    else
                    {
                        builder.AppendLine(replaceString,
                                queryParameter.SerializedName, queryParameter.GetFormattedReferenceValue(ClientReference));
                    }

                    if ((queryParameter as ParameterCs).IsNullable())
                    {
                        builder.Outdent()
                            .AppendLine("}");
                    }
                }

                builder.AppendLine("if (_queryParameters.Count > 0)")
                    .AppendLine("{").Indent();
                if (this.Extensions.ContainsKey("nextLinkMethod") && (bool)this.Extensions["nextLinkMethod"])
                {
                    builder.AppendLine("{0} += ({0}.Contains(\"?\") ? \"&\" : \"?\") + string.Join(\"&\", _queryParameters);", variableName);
                }
                else
                {
                    builder.AppendLine("{0} += \"?\" + string.Join(\"&\", _queryParameters);", variableName);
                }

                builder.Outdent().AppendLine("}");
            }

            return builder.ToString();
        }

        /// <summary>
        /// Generates input mapping code block.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildInputMappings()
        {
            var builder = new IndentedStringBuilder();
            foreach (var transformation in InputParameterTransformation)
            {
                var compositeOutputParameter = transformation.OutputParameter.ModelType as CompositeType;
                if (transformation.OutputParameter.IsRequired && compositeOutputParameter != null)
                {
                    builder.AppendLine("{0} {1} = new {0}();",
                        transformation.OutputParameter.ModelTypeName,
                        transformation.OutputParameter.Name);
                }
                else
                {
                    builder.AppendLine("{0} {1} = default({0});",
                        transformation.OutputParameter.ModelTypeName,
                        transformation.OutputParameter.Name);
                }
                var nullCheck = BuildNullCheckExpression(transformation);
                if (!string.IsNullOrEmpty(nullCheck))
                {
                    builder.AppendLine("if ({0})", nullCheck)
                       .AppendLine("{").Indent();
                }

                if (transformation.ParameterMappings.Any(m => !string.IsNullOrEmpty(m.OutputParameterProperty)) &&
                    compositeOutputParameter != null && !transformation.OutputParameter.IsRequired)
                {
                    builder.AppendLine("{0} = new {1}();",
                        transformation.OutputParameter.Name,
                        transformation.OutputParameter.ModelType.Name);
                }

                foreach (var mapping in transformation.ParameterMappings)
                {
                    builder.AppendLine("{0};", mapping.CreateCode(transformation.OutputParameter));
                }

                if (!string.IsNullOrEmpty(nullCheck))
                {
                    builder.Outdent()
                       .AppendLine("}");
                }
            }

            return builder.ToString();
        }

        private static string BuildNullCheckExpression(ParameterTransformation transformation)
        {
            if (transformation == null)
            {
                throw new ArgumentNullException(nameof(transformation));
            }

            return string.Join(" || ",
                transformation.ParameterMappings
                    .Where(m => m.InputParameter.IsNullable())
                    .Select(m => m.InputParameter.Name + " != null"));
        }
    }
}
