// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.CSharp.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator.CSharp
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
            MethodGroupName = source.Group ?? serviceClient.Name;
        }

        public string MethodGroupName { get; set; }

        public ServiceClient ServiceClient { get; set; }

        public List<ParameterTemplateModel> ParameterTemplateModels { get; private set; }

        public IScopeProvider Scope
        {
            get { return _scopeProvider; }
        }

        /// <summary>
        /// Get the predicate to determine of the http operation status code indicates success
        /// </summary>
        public string SuccessStatusCodePredicate
        {
            get
            {
                if (Responses.Any())
                {
                    List<string> predicates = new List<string>();
                    foreach (var responseStatus in Responses.Keys)
                    {
                        predicates.Add(string.Format(CultureInfo.InvariantCulture,
                            "statusCode == {0}", GetStatusCodeReference(responseStatus)));
                    }

                    return string.Join(" || ", predicates);
                }
                return "httpResponse.IsSuccessStatusCode";
            }
        }

        /// <summary>
        /// Generate the method parameter declarations for the sync extension
        /// </summary>
        public string SyncMethodParameterDeclaration
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in  LocalParameters)
                {
                    string format = (parameter.IsRequired ? "{0} {1}" : "{0} {1} = default({0})");
                    declarations.Add(string.Format(CultureInfo.InvariantCulture,
                        format, parameter.DeclarationExpression, parameter.Name));
                }

                return string.Join(", ", declarations);
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
        /// Generate the method parameter declaration for async methods and extensions
        /// </summary>
        /// <param name="addCustomHeaderParameters">If true add the customHeader to the parameters</param>
        /// <returns>Generated string of parameters</returns>
        public virtual string GetAsyncMethodParameterDeclaration(bool addCustomHeaderParameters)
        {
            var declarations = this.SyncMethodParameterDeclaration;

            if (!string.IsNullOrEmpty(declarations))
            {
                declarations += ", ";
            }
            if (addCustomHeaderParameters)
            {
                declarations += "Dictionary<string, List<string>> customHeaders = null, ";
            }
            declarations += "CancellationToken cancellationToken = default(CancellationToken)";

            return declarations;
        }

        /// <summary>
        /// Arguments for invoking the method from a synchronous extension method
        /// </summary>
        public string SyncMethodInvocationArgs
        {
            get
            {
                List<string> invocationParams = new List<string>();
                LocalParameters.ForEach(p => invocationParams.Add(p.Name));
                return string.Join(", ", invocationParams);
            }
        }

        /// <summary>
        /// Get the invocation args for an invocation with an async method
        /// </summary>
        public string GetAsyncMethodInvocationArgs (string customHeaderReference)
        {
            List<string> invocationParams = new List<string>();
            LocalParameters.ForEach(p => invocationParams.Add(p.Name));
            invocationParams.Add(customHeaderReference);
            invocationParams.Add("cancellationToken");
            return string.Join(", ", invocationParams);
        }

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they apopear in the method signatur
        /// exclude global parameters
        /// </summary>
        public IEnumerable<ParameterTemplateModel> LocalParameters
        {
            get
            {
                return
                    ParameterTemplateModels.Where(
                        p => p != null && p.ClientProperty == null && !string.IsNullOrWhiteSpace(p.Name))
                        .OrderBy(item => !item.IsRequired);
            }
        }

        /// <summary>
        /// Get the return type name for the underlyign interface method
        /// </summary>
        public virtual string OperationResponseReturnTypeString
        {
            get
            {
                if (ReturnType != null)
                {
                    return string.Format(CultureInfo.InvariantCulture,
                        "HttpOperationResponse<{0}>", ReturnType.Name);
                }
                return "HttpOperationResponse";
            }
        }

        /// <summary>
        /// Get the return type for the async extension method
        /// </summary>
        public string TaskExtensionReturnTypeString
        {
            get
            {
                if (ReturnType != null)
                {
                    return string.Format(CultureInfo.InvariantCulture,
                        "Task<{0}>", ReturnType.Name);
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
                return "HttpOperationException";
            }
        }

        /// <summary>
        /// Get the expression for exception initialization with message.
        /// </summary>
        public virtual string InitializeExceptionWithMessage
        {
            get
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// Gets the expression for response body initialization.
        /// </summary>
        public virtual string InitializeResponseBody
        {
            get
            {
                return string.Empty;
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
            get { return Group == null ? "this" : "this.Client"; }
        }

        /// <summary>
        /// Returns serialization settings reference.
        /// </summary>
        /// <param name="serializationType"></param>
        /// <returns></returns>
        public string GetSerializationSettingsReference(IType serializationType)
        {
            SequenceType sequenceType = serializationType as SequenceType;
            DictionaryType dictionaryType = serializationType as DictionaryType;
            if (serializationType == PrimaryType.Date ||
                (sequenceType != null && sequenceType.ElementType == PrimaryType.Date) ||
                (dictionaryType != null && dictionaryType.ValueType == PrimaryType.Date))
            {
                return "new DateJsonConverter()";
            }

            return ClientReference + ".SerializationSettings";
        }

        /// <summary>
        /// Returns deserialization settings reference.
        /// </summary>
        /// <param name="deserializationType"></param>
        /// <returns></returns>
        public string GetDeserializationSettingsReference(IType deserializationType)
        {
            SequenceType sequenceType = deserializationType as SequenceType;
            DictionaryType dictionaryType = deserializationType as DictionaryType;
            if (deserializationType == PrimaryType.Date ||
                (sequenceType != null && sequenceType.ElementType == PrimaryType.Date) ||
                (dictionaryType != null && dictionaryType.ValueType == PrimaryType.Date))
            if (deserializationType == PrimaryType.Date)
            {
                return "new DateJsonConverter()";
            }

            return ClientReference + ".DeserializationSettings";
        }

        public string GetExtensionParameters(string methodParameters)
        {
            string operationsParameter = "this I" + MethodGroupName + " operations";
            return string.IsNullOrWhiteSpace(methodParameters)
                ? operationsParameter
                : operationsParameter + ", " + methodParameters;
        }

        public static string GetStatusCodeReference(HttpStatusCode code)
        {
            return string.Format(CultureInfo.InvariantCulture,
                "(HttpStatusCode)Enum.Parse(typeof(HttpStatusCode), \"{0}\")", code);
        }

        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the url in.</param>
        /// <returns></returns>
        public virtual string BuildUrl(string variableName)
        {
            var builder = new IndentedStringBuilder();

            foreach (var pathParameter in ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Path))
            {
                builder.AppendLine("{0} = {0}.Replace(\"{{{1}}}\", Uri.EscapeDataString({2}));",
                    variableName,
                    pathParameter.SerializedName,
                    pathParameter.Type.ToString(ClientReference, pathParameter.Name));
            }
            if (ParameterTemplateModels.Any(p => p.Location == ParameterLocation.Query))
            {
                builder.AppendLine("List<string> queryParameters = new List<string>();");
                foreach (var queryParameter in ParameterTemplateModels
                    .Where(p => p.Location == ParameterLocation.Query))
                {
                    builder.AppendLine("if ({0} != null)", queryParameter.Name)
                        .AppendLine("{").Indent()
                        .AppendLine("queryParameters.Add(string.Format(\"{0}={{0}}\", Uri.EscapeDataString({1})));",
                            queryParameter.SerializedName, queryParameter.GetFormattedReferenceValue(ClientReference)).Outdent()
                        .AppendLine("}");
                }

                builder.AppendLine("if (queryParameters.Count > 0)")
                    .AppendLine("{").Indent()
                    .AppendLine("{0} += \"?\" + string.Join(\"&\", queryParameters);", variableName).Outdent()
                    .AppendLine("}");
            }

            return builder.ToString();
        }

        public virtual string RemoveDuplicateForwardSlashes(string urlVariableName)
        {
            var builder = new IndentedStringBuilder();

            builder.AppendLine("// trim all duplicate forward slashes in the url");
            builder.AppendLine("{0} = Regex.Replace({0}, \"([^:]/)/+\", \"$1\");", urlVariableName);
            return builder.ToString();
        }
    }
}
