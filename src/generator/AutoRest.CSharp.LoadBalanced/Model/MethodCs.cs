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
                if (!Responses.Any())
                {
                    return "!_httpResponse.IsSuccessStatusCode";
                }
                var predicates = Responses.Keys.Select(responseStatus => string.Format(CultureInfo.InvariantCulture, "(int)_statusCode != {0}", GetStatusCodeReference(responseStatus))).ToList();

                return string.Join(" && ", predicates);
            }
        }

        /// <summary>
        /// Generate the method parameter declaration for async methods and extensions
        /// </summary>
        public virtual string GetAsyncMethodParameterDeclaration()
        {
            return GetAsyncMethodParameterDeclaration(false);
        }

        /// <summary>
        /// Generate the method parameter declaration for sync methods and extensions
        /// </summary>
        /// <param name="addCustomHeaderParameters">If true add the customHeader to the parameters</param>
        /// <returns>Generated string of parameters</returns>
        public virtual string GetSyncMethodParameterDeclaration(bool addCustomHeaderParameters)
        {
            var declarations = new List<string>();
            foreach (var parameter in LocalParameters)
            {
                var format = (parameter.IsRequired ? "{0} {1}" : "{0} {1} = {2}");

                var defaultValue = $"default({parameter.ModelTypeName})";
                if (!string.IsNullOrEmpty(parameter.DefaultValue) && parameter.ModelType is PrimaryType)
                {
                    defaultValue = parameter.DefaultValue;
                }
                declarations.Add(string.Format(CultureInfo.InvariantCulture,
                    format, parameter.ModelTypeName, parameter.Name, defaultValue));
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
            var declarations = GetSyncMethodParameterDeclaration(addCustomHeaderParameters);
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
                        !string.IsNullOrWhiteSpace(parameter.Name) &&
                        !parameter.IsConstant)
                        .OrderBy(item => !item.IsRequired).Cast<ParameterCs>();
            }
        }

        /// <summary>
        /// Get the return type name for the underlying interface method
        /// </summary>
        public virtual string OperationResponseReturnTypeString => GetOperationResponseReturnTypeString();

        public virtual string OperationResponseReturnTypeStringForMethodName => GetOperationResponseReturnTypeStringForMethodName();

        public virtual string NameWithoutRoute => ReplaceRouteWithEmpty();

        public virtual string ReplaceRouteWithEmpty()
        {
            return Name.Value.Replace("Route", "");
        }

        public virtual string GetOperationResponseReturnTypeString(string typeName = "Task")
        {
			// hardcode wrapper object for V1
			const string wrapperTypeName = "Response"; 
			
            if (ReturnType.Body != null)
            {
                return $"{typeName}<{OperationResponseType}>";
            }

            return $"{typeName}<{wrapperTypeName}>";
        }

        public virtual string GetOperationResponseReturnTypeStringForMethodName(string typeName = "Task") {
            // hardcode wrapper object for V1
            const string wrapperTypeName = "Response";

            if (ReturnType.Body != null)
            {
                return $"{typeName}<{wrapperTypeName}<{OperationResponseType}>>";
            }

            return $"{typeName}<{wrapperTypeName}>";
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
                if (!(DefaultResponse.Body is CompositeType))
                {
                    return "HttpOperationException";
                }

                var type = DefaultResponse.Body as CompositeType;
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
            var operationsParameter = "this I" + MethodGroup.TypeName + " operations";
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

                builder.AppendLine("var queryParameters = new Dictionary<string,object>();");
            foreach (var pathParameter in LogicalParameters.Where(p => p.Location == ParameterLocation.Path))
            {
                var replaceString = "queryParameters.Add(\"{0}\",{1});";
                var urlPathName = pathParameter.SerializedName;
                if (pathParameter.ModelType is SequenceType)
                {
                    builder.AppendLine(replaceString,
                    urlPathName,
                    pathParameter.GetFormattedReferenceValue(ClientReference));
                }
                else
                {
                    builder.AppendLine(replaceString,
                    urlPathName,
                    pathParameter.ModelType.ToString(ClientReference, pathParameter.Name));
                }
            }
            if (LogicalParameters.Any(p => p.Location == ParameterLocation.Query))
            {
                foreach (var queryParameter in LogicalParameters.Where(p => p.Location == ParameterLocation.Query))
                {
                    var replaceString = "queryParameters.Add(\"{0}\",{1});";
                    if ((queryParameter as ParameterCs).IsNullable())
                    {
                        builder.Append($"if ({queryParameter.Name} != null)");
                    }
                    
                    if (queryParameter.CollectionFormat == CollectionFormat.Multi)
                    {
                        if ((queryParameter as ParameterCs).IsNullable())
                        {
                            builder
                                .AppendLine("{").Indent();
                        }
                        builder.AppendLine("if ({0}.Count == 0)", queryParameter.Name)
                           .AppendLine("{").Indent()
                           .AppendLine(replaceString, queryParameter.SerializedName, "string.Empty").Outdent()
                           .AppendLine("}")
                           .AppendLine("else")
                           .AppendLine("{").Indent()
                           .AppendLine("foreach (var _item in {0})", queryParameter.Name)
                           .AppendLine("{").Indent()
                           .AppendLine(replaceString, queryParameter.SerializedName, "_item.ToString() ?? string.Empty").Outdent()
                           .AppendLine("}").Outdent()
                           .AppendLine("}").Outdent();
                        if ((queryParameter as ParameterCs).IsNullable())
                        {
                            builder
                                .AppendLine("}").Indent();
                        }
                    }
                    else
                    {
                        builder.AppendLine(replaceString,
                                queryParameter.SerializedName, queryParameter.GetFormattedReferenceValue(ClientReference));
                    }
                    
                }
                
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
