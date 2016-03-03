// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.Azure.Properties;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java.Azure
{
    public class AzureMethodTemplateModel : MethodTemplateModel
    {
        public AzureMethodTemplateModel(Method source, ServiceClient serviceClient)
            : base(source, serviceClient)
        {
            if (source == null)
            {
                throw new ArgumentNullException("source");
            }

            this.ClientRequestIdString = AzureExtensions.GetClientRequestIdString(source);
            this.RequestIdString = AzureExtensions.GetRequestIdString(source);
        }

        public string ClientRequestIdString { get; private set; }

        public string RequestIdString { get; private set; }

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation
        {
            get { return Extensions.ContainsKey(AzureExtensions.LongRunningExtension); }
        }

        public bool IsPagingNextOperation
        {
            get { return Url == "{nextLink}"; }
        }

        public bool IsPagingOperation
        {
            get
            {
                return Extensions.ContainsKey(AzureExtensions.PageableExtension) &&
                    Extensions[AzureExtensions.PageableExtension] != null &&
                    !IsPagingNextOperation;
            }
        }

        public bool IsPagingNonPollingOperation
        {
            get
            {
                return Extensions.ContainsKey(AzureExtensions.PageableExtension) &&
                    Extensions[AzureExtensions.PageableExtension] == null &&
                    !IsPagingNextOperation;
            }
        }

        /// <summary>
        /// Get the type for operation exception.
        /// </summary>
        public override string OperationExceptionTypeString
        {
            get
            {
                if (DefaultResponse.Body == null || DefaultResponse.Body.Name == "CloudError")
                {
                    return "CloudException";
                }
                return base.OperationExceptionTypeString;
            }
        }

        public override string MethodParameterApiDeclaration
        {
            get
            {
                var declaration = base.MethodParameterApiDeclaration;
                if (IsPagingNextOperation)
                {
                    declaration = declaration.Replace("@Path(\"nextLink\")", "@Url");
                }
                return declaration;
            }
        }

        public override string MethodParameterDeclaration
        {
            get
            {
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    List<string> declarations = new List<string>();
                    foreach (var parameter in LocalParameters)
                    {
                        declarations.Add("final " + parameter.Type.ToString() + " " + parameter.Name);
                    }

                    var declaration = string.Join(", ", declarations);
                    return declaration;
                }
                return base.MethodParameterDeclaration;
            }
        }

        public override string MethodParameterDeclarationWithCallback
        {
            get
            {
                var parameters = MethodParameterDeclaration;
                if (!parameters.IsNullOrEmpty())
                {
                    parameters += ", ";
                }
                if (this.IsPagingOperation)
                {
                    SequenceType sequenceType = (SequenceType)ReturnType.Body;
                    parameters += string.Format(CultureInfo.InvariantCulture, "final ListOperationCallback<{0}> serviceCallback",
                    sequenceType != null ? JavaCodeNamer.WrapPrimitiveType(sequenceType.ElementType).ToString() : "Void");
                }
                else if (this.IsPagingNextOperation)
                {
                    SequenceType sequenceType = (SequenceType)ReturnType.Body;
                    parameters += string.Format(CultureInfo.InvariantCulture, "final ServiceCall serviceCall, final ListOperationCallback<{0}> serviceCallback",
                    sequenceType != null ? JavaCodeNamer.WrapPrimitiveType(sequenceType.ElementType).ToString() : "Void");
                }
                else
                {
                    parameters += string.Format(CultureInfo.InvariantCulture, "final ServiceCallback<{0}> serviceCallback",
                    ReturnType.Body != null ? JavaCodeNamer.WrapPrimitiveType(ReturnType.Body).ToString() : "Void");
                }
                
                return parameters;
            }
        }

        public override string MethodParameterInvocationWithCallback
        {
            get
            {
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    return base.MethodParameterInvocationWithCallback.Replace("serviceCallback", "serviceCall, serviceCallback");
                }
                return base.MethodParameterInvocationWithCallback;
            }
        }

        public override IEnumerable<string> Exceptions
        {
            get
            {
                var exceptions = base.Exceptions.ToList();
                if (this.IsLongRunningOperation)
                {
                    exceptions.Add("InterruptedException");
                }
                return exceptions;
            }
        }

        public override List<string> ExceptionStatements
        {
            get
            {
                List<string> exceptions = base.ExceptionStatements;
                if (this.IsLongRunningOperation)
                {
                    exceptions.Add("InterruptedException exception thrown when long running operation is interrupted");
                }
                return exceptions;
            }
        }

        public string PollingMethod
        {
            get
            {
                string method;
                if (this.HttpMethod == HttpMethod.Put || this.HttpMethod == HttpMethod.Patch)
                {
                    method = "getPutOrPatchResult";
                }
                else if (this.HttpMethod == HttpMethod.Delete || this.HttpMethod == HttpMethod.Post)
                {
                    method = "getPostOrDeleteResult";
                }
                else
                {
                    throw new InvalidOperationException("Invalid long running operation HTTP method " + this.HttpMethod);
                }
                if (ReturnType.Headers != null)
                {
                    method += "WithHeaders";
                }
                return method;
            }
        }

        public string PollingResourceTypeArgs
        {
            get
            {
                string args = "new TypeToken<" + GenericReturnTypeString + ">() { }.getType()";
                if (ReturnType.Headers != null)
                {
                    args += ", " + ReturnType.Headers.Name + ".class";
                }
                return args;
            }
        }

        public override string ResponseBuilder
        {
            get
            {
                return "AzureServiceResponseBuilder";
            }
        }

        public override string ResponseGeneration
        {
            get
            {
                if (this.IsPagingOperation && !this.IsPagingNextOperation)
                {
                    var builder = new IndentedStringBuilder();
                    builder.AppendLine("{0} response = {1}Delegate(call.execute());",
                        this.DelegateOperationResponseReturnTypeString, this.Name);
                    builder.AppendLine("{0} result = response.getBody().getItems();", ReturnType.Body.Name);
                    builder.AppendLine("while (response.getBody().getNextPageLink() != null) {");
                    builder.Indent();
                    string invocation;
                    AzureMethodTemplateModel nextMethod = GetPagingNextMethod(out invocation);
                    TransformPagingGroupedParameter(builder, nextMethod);
                    var nextCall = string.Format(CultureInfo.InvariantCulture, "response = {0}(response.getBody().getNextPageLink(), {1});",
                        invocation,
                        nextMethod.MethodParameterInvocation);
                    builder.AppendLine(nextCall.Replace(", nextPageLink", ""));
                    builder.AppendLine("result.addAll(response.getBody().getItems());");
                    builder.Outdent().AppendLine("}");
                    return builder.ToString();
                }
                else if (this.IsPagingNonPollingOperation)
                {
                    var builder = new IndentedStringBuilder();
                    builder.AppendLine("{0}<PageImpl<{1}>> response = {2}Delegate(call.execute());",
                        this.OperationResponseType, ((SequenceType)ReturnType.Body).ElementType.Name, this.Name.ToCamelCase());
                    builder.AppendLine("{0} result = response.getBody().getItems();", this.ReturnType.Body.Name);
                    return builder.ToString();
                }
                else
                {
                    return base.ResponseGeneration;
                }
            }
        }

        public override string ReturnValue
        {
            get
            {
                if (this.IsPagingOperation || this.IsPagingNonPollingOperation)
                {
                    if (ReturnType.Headers != null)
                    {
                        return string.Format(CultureInfo.InvariantCulture, "new {0}<>(result, response.getHeaders(), response.getResponse())",
                            this.OperationResponseType);
                    }
                    else
                    {
                        return string.Format(CultureInfo.InvariantCulture, "new {0}<>(result, response.getResponse())",
                            this.OperationResponseType);
                    }
                }
                else
                {
                    return base.ReturnValue;
                }
            }
        }

        public override string SuccessCallback
        {
            get
            {
                if (this.IsPagingOperation)
                {
                    var builder = new IndentedStringBuilder();
                    builder.AppendLine("{0} result = {1}Delegate(response);",
                        this.DelegateOperationResponseReturnTypeString, this.Name);
                    builder.AppendLine("serviceCallback.load(result.getBody().getItems());");
                    builder.AppendLine("if (result.getBody().getNextPageLink() != null").Indent().Indent()
                        .AppendLine("&& serviceCallback.progress(result.getBody().getItems()) == ListOperationCallback.PagingBahavior.CONTINUE) {").Outdent();
                    string invocation;
                    AzureMethodTemplateModel nextMethod = GetPagingNextMethod(out invocation, true);
                    TransformPagingGroupedParameter(builder, nextMethod);
                    var nextCall = string.Format(CultureInfo.InvariantCulture, "{0}(result.getBody().getNextPageLink(), {1});",
                        invocation,
                        nextMethod.MethodParameterInvocationWithCallback);
                    builder.AppendLine(nextCall.Replace(", nextPageLink", "")).Outdent();
                    builder.AppendLine("} else {").Indent();
                    if (ReturnType.Headers == null)
                    {
                        builder.AppendLine("serviceCallback.success(new {0}<>(serviceCallback.get(), result.getResponse()));", this.OperationResponseType);
                    }
                    else
                    {
                        builder.AppendLine("serviceCallback.success(new {0}<>(serviceCallback.get(), result.getHeaders(), result.getResponse()));", this.OperationResponseType);
                    }
                    builder.Outdent().AppendLine("}");
                    return builder.ToString();
                }
                else if (this.IsPagingNextOperation)
                {
                    var builder = new IndentedStringBuilder();
                    builder.AppendLine("{0} result = {1}Delegate(response);", this.DelegateOperationResponseReturnTypeString, this.Name);
                    builder.AppendLine("serviceCallback.load(result.getBody().getItems());");
                    builder.AppendLine("if (result.getBody().getNextPageLink() != null").Indent().Indent();
                    builder.AppendLine("&& serviceCallback.progress(result.getBody().getItems()) == ListOperationCallback.PagingBahavior.CONTINUE) {").Outdent();
                    var nextCall = string.Format(CultureInfo.InvariantCulture, "{0}Async(result.getBody().getNextPageLink(), {1});",
                        this.Name,
                        this.MethodParameterInvocationWithCallback);
                    builder.AppendLine(nextCall.Replace(", nextPageLink", "")).Outdent();
                    builder.AppendLine("} else {").Indent();
                    if (ReturnType.Headers == null)
                    {
                        builder.AppendLine("serviceCallback.success(new {0}<>(serviceCallback.get(), result.getResponse()));", this.OperationResponseType);
                    }
                    else
                    {
                        builder.AppendLine("serviceCallback.success(new {0}<>(serviceCallback.get(), result.getHeaders(), result.getResponse()));", this.OperationResponseType);
                    }
                    builder.Outdent().AppendLine("}");
                    return builder.ToString();
                }
                else if (this.IsPagingNonPollingOperation)
                {
                    var builder = new IndentedStringBuilder();
                    builder.AppendLine("{0}<PageImpl<{1}>> result = {2}Delegate(response);",
                        this.OperationResponseType, ((SequenceType)ReturnType.Body).ElementType.Name, this.Name.ToCamelCase());
                    if (ReturnType.Headers == null)
                    {
                        builder.AppendLine("serviceCallback.success(new {0}<>(result.getBody().getItems(), result.getResponse()));", this.OperationResponseType);
                    }
                    else
                    {
                        builder.AppendLine("serviceCallback.success(new {0}<>(result.getBody().getItems(), result.getHeaders(), result.getResponse()));", this.OperationResponseType);
                    }
                    return builder.ToString();
                }
                return base.SuccessCallback;
            }
        }

        private AzureMethodTemplateModel GetPagingNextMethod(out string invocation, bool async = false)
        {
            string name = ((string)this.Extensions["nextMethodName"]).ToCamelCase();
            string group = (string)this.Extensions["nextMethodGroup"];
            var methodModel = new AzureMethodTemplateModel(
                ServiceClient.Methods.FirstOrDefault(m =>
                    group == null ? m.Group == null : group.Equals(m.Group, StringComparison.OrdinalIgnoreCase)
                    && m.Name.Equals(name, StringComparison.OrdinalIgnoreCase)), ServiceClient);
            group = group.ToPascalCase();
            if (group != null)
            {
                group += "Operations";
            }
            if (async)
            {
                name = name + "Async";
            }
            if (group == null || this.OperationName == methodModel.OperationName)
            {
                invocation = name;
            }
            else
            {
                invocation = string.Format(CultureInfo.InvariantCulture, "{0}.get{1}().{2}", ClientReference.Replace("this.", ""), group, name);
            }
            return methodModel;
        }

        private void TransformPagingGroupedParameter(IndentedStringBuilder builder, AzureMethodTemplateModel nextMethod)
        {
            if (this.InputParameterTransformation.IsNullOrEmpty())
            {
                return;
            }
            var groupedType = this.InputParameterTransformation.First().ParameterMappings[0].InputParameter;
            var nextGroupType = nextMethod.InputParameterTransformation.First().ParameterMappings[0].InputParameter;
            if (nextGroupType.Name == groupedType.Name)
            {
                return;
            }
            if (!groupedType.IsRequired)
            {
                builder.AppendLine("{0} {1} = null;", nextGroupType.Name.ToPascalCase(), nextGroupType.Name.ToCamelCase());
                builder.AppendLine("if ({0} != null) {{", groupedType.Name.ToCamelCase());
                builder.Indent();
                builder.AppendLine("{0} = new {1}();", nextGroupType.Name.ToCamelCase(), nextGroupType.Name.ToPascalCase());
            }
            else
            { 
                builder.AppendLine("{1} {0} = new {1}();", nextGroupType.Name.ToCamelCase(), nextGroupType.Name.ToPascalCase());
            }
            foreach (var outParam in nextMethod.InputParameterTransformation.Select(t => t.OutputParameter))
            {
                builder.AppendLine("{0}.set{1}({2}.get{1}());", nextGroupType.Name.ToCamelCase(), outParam.Name.ToPascalCase(), groupedType.Name.ToCamelCase());
            }
            if (!groupedType.IsRequired)
            {
                builder.Outdent().AppendLine(@"}");
            }
        }

        public override string DelegateReturnTypeString
        {
            get
            {
                if (this.IsPagingOperation || this.IsPagingNextOperation || this.IsPagingNonPollingOperation)
                {
                    return string.Format(CultureInfo.InvariantCulture, "PageImpl<{0}>", ((SequenceType)ReturnType.Body).ElementType);
                }
                return base.DelegateReturnTypeString;
            }
        }

        public override string TypeTokenType(IType type)
        {
            SequenceType sequenceType = type as SequenceType;
            if (sequenceType != null && (this.IsPagingOperation || this.IsPagingNextOperation || this.IsPagingNonPollingOperation))
            {
                return string.Format(CultureInfo.InvariantCulture, "PageImpl<{0}>", sequenceType.ElementType);
            }
            return base.TypeTokenType(type);
        }

        public override string GenericReturnTypeString
        {
            get
            {
                if (ReturnType.Body is SequenceType && this.IsPagingNextOperation)
                {
                    return string.Format(CultureInfo.InvariantCulture, "PageImpl<{0}>", ((SequenceType)ReturnType.Body).ElementType);
                }
                return base.GenericReturnTypeString;
            }
        }

        public override string ServiceCallConstruction
        {
            get
            {
                if (this.IsPagingNextOperation)
                {
                    return "serviceCall.newCall(call);";
                }
                return base.ServiceCallConstruction;
            }
        }

        public override string CallbackDocumentation
        {
            get
            {
                IndentedStringBuilder builder = new IndentedStringBuilder();
                if (this.IsPagingNextOperation)
                {
                    builder.AppendLine(" * @param serviceCall the ServiceCall object tracking the Retrofit calls");
                }
                builder.Append(" * @param serviceCallback the async ServiceCallback to handle successful and failed responses.");
                return builder.ToString();
            }
        }

        public override string RuntimeBasePackage
        {
            get
            {
                return "com.microsoft.azure";
            }
        }

        public override List<string> InterfaceImports
        {
            get
            {
                var imports = base.InterfaceImports;
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    imports.Remove("com.microsoft.rest.ServiceCallback");
                    imports.Add("com.microsoft.azure.ListOperationCallback");
                    imports.AddRange(new CompositeType { Name = "PageImpl" }.ImportFrom(ServiceClient.Namespace));
                }
                return imports;
            }
        }

        public override List<string> ImplImports
        {
            get
            {
                var imports = base.ImplImports;
                if (this.IsLongRunningOperation)
                {
                    imports.Remove("com.microsoft.rest.ServiceResponseEmptyCallback");
                    imports.Remove("com.microsoft.rest.ServiceResponseCallback");
                    imports.Remove("com.microsoft.azure.AzureServiceResponseBuilder");
                    imports.Add("retrofit2.Callback");
                    this.Responses.Select(r => r.Value.Body).Concat(new IType[]{ DefaultResponse.Body })
                        .SelectMany(t => t.ImportFrom(ServiceClient.Namespace))
                        .Where(i => !this.Parameters.Any(p => p.Type.ImportFrom(ServiceClient.Namespace).Contains(i)))
                        .ForEach(i => imports.Remove(i));
                    // return type may have been removed as a side effect
                    imports.AddRange(this.ReturnType.Body.ImportFrom(ServiceClient.Namespace));
                }
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    imports.Remove("com.microsoft.rest.ServiceCallback");
                    imports.Add("com.microsoft.azure.ListOperationCallback");
                    imports.AddRange(new CompositeType { Name = "PageImpl" }.ImportFrom(ServiceClient.Namespace));
                }
                if (this.IsPagingNextOperation)
                {
                    imports.Remove("retrofit2.http.Path");
                    imports.Add("retrofit2.http.Url");
                }
                if (this.IsPagingNonPollingOperation)
                {
                    imports.AddRange(new CompositeType { Name = "PageImpl" }.ImportFrom(ServiceClient.Namespace));
                }
                return imports;
            }
        }
    }
}