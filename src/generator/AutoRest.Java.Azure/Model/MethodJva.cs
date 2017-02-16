// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;
using AutoRest.Core.Utilities.Collections;
using static AutoRest.Core.Utilities.DependencyInjection;
using Newtonsoft.Json;
using System.Text.RegularExpressions;
using System.Text;

namespace AutoRest.Java.Azure.Model
{
    public class MethodJva : MethodJv
    {
        [JsonIgnore]
        public string ClientRequestIdString => AzureExtensions.GetClientRequestIdString(this);

        [JsonIgnore]
        public string RequestIdString => AzureExtensions.GetRequestIdString(this);

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        [JsonIgnore]
        public bool IsLongRunningOperation
        {
            get { return Extensions.ContainsKey(AzureExtensions.LongRunningExtension); }
        }

        [JsonIgnore]
        public bool IsPagingNextOperation
        {
            get { return Extensions.ContainsKey("nextLinkMethod") && (bool) Extensions["nextLinkMethod"]; }
        }

        [JsonIgnore]
        public bool IsPagingOperation => Extensions.ContainsKey(AzureExtensions.PageableExtension) &&
                    Extensions[AzureExtensions.PageableExtension] != null &&
                    !IsPagingNextOperation;

        [JsonIgnore]
        public bool IsPagingNonPollingOperation => Extensions.ContainsKey(AzureExtensions.PageableExtension) &&
                    Extensions[AzureExtensions.PageableExtension] == null &&
                    !IsPagingNextOperation;

        [JsonIgnore]
        public ResponseJva ReturnTypeJva => ReturnType as ResponseJva;

        /// <summary>
        /// Get the type for operation exception.
        /// </summary>
        [JsonIgnore]
        public override string OperationExceptionTypeString
        {
            get
            {
                if (DefaultResponse.Body == null || DefaultResponse.Body.Name == "CloudError")
                {
                    return "CloudException";
                }
                else if (this.DefaultResponse.Body is CompositeType)
                {
                    CompositeTypeJva type = this.DefaultResponse.Body as CompositeTypeJva;
                    return type.ExceptionTypeDefinitionName;
                }
                else
                {
                    return "RestException";
                }
            }
        }

        [JsonIgnore]
        public override IEnumerable<ParameterJv> RetrofitParameters
        {
            get
            {
                List<ParameterJv> parameters = base.RetrofitParameters.ToList();
                var par = new ParameterJv
                {
                    SerializedName = "User-Agent",
                    Location = ParameterLocation.Header,
                    ModelType = new PrimaryTypeJv(KnownPrimaryType.String),
                    ClientProperty = new PropertyJv
                    {
                        Name = "userAgent"
                    }
                };
                par.Name.FixedValue = Group.IsNullOrEmpty() ? "this.userAgent()" : "this.client.userAgent()";
                parameters.Add(par);

                if (IsPagingNextOperation)
                {
                    parameters.RemoveAll(p => p.Location == ParameterLocation.Path);
                    parameters.Insert(0, new ParameterJv
                    {
                        Name = "nextUrl",
                        SerializedName = "nextUrl",
                        ModelType = New<PrimaryType>(KnownPrimaryType.String),
                        Documentation = "The URL to get the next page of items.",
                        Location = ParameterLocation.Path,
                        IsRequired = true
                    });
                }

                return parameters;
            }
        }

        [JsonIgnore]
        public override string MethodParameterApiDeclaration
        {
            get
            {
                var declaration = base.MethodParameterApiDeclaration;
                if (IsPagingNextOperation)
                {
                    declaration = declaration.Replace("@Path(\"nextUrl\")", "@Url");
                }
                foreach (var parameter in RetrofitParameters.Where(p => 
                    p.Location == ParameterLocation.Path || p.Location == ParameterLocation.Query))
                {
                    if (parameter.Extensions.ContainsKey(AzureExtensions.SkipUrlEncodingExtension) &&
                        (bool) parameter.Extensions[AzureExtensions.SkipUrlEncodingExtension] == true)
                    {
                        declaration = declaration.Replace(
                            string.Format(CultureInfo.InvariantCulture, "@{0}(\"{1}\")", parameter.Location.ToString(), parameter.SerializedName),
                            string.Format(CultureInfo.InvariantCulture, "@{0}(value = \"{1}\", encoded = true)", parameter.Location.ToString(), parameter.SerializedName));
                    }
                }
                return declaration;
            }
        }

        [JsonIgnore]
        public override string MethodParameterDeclaration
        {
            get
            {
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    List<string> declarations = new List<string>();
                    foreach (var parameter in LocalParameters.Where(p => !p.IsConstant))
                    {
                        declarations.Add("final " + parameter.ClientType.ParameterVariant.Name + " " + parameter.Name);
                    }

                    var declaration = string.Join(", ", declarations);
                    return declaration;
                }
                return base.MethodParameterDeclaration;
            }
        }

        [JsonIgnore]
        public override string MethodRequiredParameterDeclaration
        {
            get
            {
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    List<string> declarations = new List<string>();
                    foreach (var parameter in LocalParameters.Where(p => !p.IsConstant && p.IsRequired))
                    {
                        declarations.Add("final " + parameter.ClientType.ParameterVariant.Name + " " + parameter.Name);
                    }

                    var declaration = string.Join(", ", declarations);
                    return declaration;
                }
                return base.MethodRequiredParameterDeclaration;
            }
        }

        [JsonIgnore]
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
                    parameters += string.Format(CultureInfo.InvariantCulture, "final ListOperationCallback<{0}> serviceCallback",
                        ReturnTypeJva.SequenceElementTypeString);
                }
                else if (this.IsPagingNextOperation)
                {
                    parameters += string.Format(CultureInfo.InvariantCulture, "final ServiceFuture<{0}> serviceFuture, final ListOperationCallback<{1}> serviceCallback",
                        ReturnTypeJva.ServiceFutureGenericParameterString, ReturnTypeJva.SequenceElementTypeString);
                }
                else
                {
                    parameters += string.Format(CultureInfo.InvariantCulture, "final ServiceCallback<{0}> serviceCallback", ReturnTypeJva.GenericBodyClientTypeString);
                }
                
                return parameters;
            }
        }

        [JsonIgnore]
        public override string MethodRequiredParameterDeclarationWithCallback
        {
            get
            {
                var parameters = MethodRequiredParameterDeclaration;
                if (!parameters.IsNullOrEmpty())
                {
                    parameters += ", ";
                }
                if (this.IsPagingOperation)
                {
                    parameters += string.Format(CultureInfo.InvariantCulture, "final ListOperationCallback<{0}> serviceCallback",
                        ReturnTypeJva.SequenceElementTypeString);
                }
                else if (this.IsPagingNextOperation)
                {
                    parameters += string.Format(CultureInfo.InvariantCulture, "final ServiceFuture<{0}> serviceFuture, final ListOperationCallback<{1}> serviceCallback",
                        ReturnTypeJva.ServiceFutureGenericParameterString, ReturnTypeJva.SequenceElementTypeString);
                }
                else
                {
                    parameters += string.Format(CultureInfo.InvariantCulture, "final ServiceCallback<{0}> serviceCallback", ReturnTypeJva.GenericBodyClientTypeString);
                }

                return parameters;
            }
        }

        [JsonIgnore]
        public override string MethodParameterInvocationWithCallback
        {
            get
            {
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    return base.MethodParameterInvocationWithCallback.Replace("serviceCallback", "serviceFuture, serviceCallback");
                }
                return base.MethodParameterInvocationWithCallback;
            }
        }

        [JsonIgnore]
        public override string MethodRequiredParameterInvocationWithCallback
        {
            get
            {
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    return base.MethodRequiredParameterInvocationWithCallback.Replace("serviceCallback", "serviceFuture, serviceCallback");
                }
                return base.MethodRequiredParameterInvocationWithCallback;
            }
        }

        [JsonIgnore]
        public override bool IsParameterizedHost => 
            (CodeModel?.Extensions?.ContainsKey(SwaggerExtensions.ParameterizedHostExtension) ?? false) && 
            !IsPagingNextOperation;

        [JsonIgnore]
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

        [JsonIgnore]
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

        [JsonIgnore]
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

        [JsonIgnore]
        public string PollingResourceTypeArgs
        {
            get
            {
                string args = "new TypeToken<" + ReturnTypeJva.GenericBodyClientTypeString + ">() { }.getType()";
                if (ReturnType.Headers != null)
                {
                    args += ", " + ReturnTypeJva.HeaderWireType.Name + ".class";
                }
                return args;
            }
        }

        [JsonIgnore]
        public override string ResponseBuilder
        {
            get
            {
                return "AzureResponseBuilder";
            }
        }

        [JsonIgnore]
        public override string ReturnTypeResponseName => 
            ReturnTypeJv?.BodyClientType?.ServiceResponseVariant()?.Name;

        public string PagingGroupedParameterTransformation(bool filterRequired = false)
        {
            var builder = new IndentedStringBuilder();
            if (IsPagingOperation)
            {
                string invocation;
                MethodJva nextMethod = GetPagingNextMethodWithInvocation(out invocation);
                TransformPagingGroupedParameter(builder, nextMethod, filterRequired);
            }
            return builder.ToString();
        }

        public string NextMethodParameterInvocation(bool filterRequired = false)
        {
            string invocation;
            MethodJva nextMethod = GetPagingNextMethodWithInvocation(out invocation);
            if (filterRequired)
            {
                if (this.InputParameterTransformation.IsNullOrEmpty() || nextMethod.InputParameterTransformation.IsNullOrEmpty())
                {
                    return nextMethod.MethodDefaultParameterInvocation;
                }
                var groupedType = this.InputParameterTransformation.First().ParameterMappings[0].InputParameter;
                var nextGroupType = nextMethod.InputParameterTransformation.First().ParameterMappings[0].InputParameter;
                List<string> invocations = new List<string>();
                foreach (var parameter in nextMethod.LocalParameters)
                {
                    if (parameter.IsRequired)
                    {
                        invocations.Add(parameter.Name);
                    }
                    else if (parameter.Name == nextGroupType.Name && groupedType.IsRequired)
                    {
                        invocations.Add(parameter.Name);
                    }
                    else
                    {
                        invocations.Add("null");
                    }
                }
                return string.Join(", ", invocations);
            }
            else
            {
                return nextMethod.MethodParameterInvocation;
            }
        }

        [JsonIgnore]
        public string PagingNextPageLinkParameterName
        {
            get
            {
                string invocation;
                MethodJva nextMethod = GetPagingNextMethodWithInvocation(out invocation);
                return nextMethod.Parameters.First(p => p.Name.ToString().StartsWith("next", StringComparison.OrdinalIgnoreCase)).Name;
            }
        }

        public override string ResponseGeneration(bool filterRequired = false)
        {
            if (this.IsPagingOperation && !this.IsPagingNextOperation)
            {
                var builder = new IndentedStringBuilder();
                builder.AppendLine("{0} response = {1}Delegate(call.execute());",
                    ReturnTypeJva.WireResponseTypeString, this.Name);
                    
                string invocation;
                MethodJva nextMethod = GetPagingNextMethodWithInvocation(out invocation);

                builder.AppendLine("PagedList<{0}> result = new PagedList<{0}>(response.body()) {{", ((SequenceType)ReturnType.Body).ElementType.Name)
                    .Indent().AppendLine("@Override")
                    .AppendLine("public Page<{0}> nextPage(String {1}) throws {2}, IOException {{",
                        ((SequenceType)ReturnType.Body).ElementType.Name,
                        nextMethod.Parameters.First(p => p.Name.ToString().StartsWith("next", StringComparison.OrdinalIgnoreCase)).Name,
                        OperationExceptionTypeString)
                        .Indent();
                        TransformPagingGroupedParameter(builder, nextMethod, filterRequired);
                        builder.AppendLine("return {0}({1}).body();", 
                            invocation, filterRequired ? nextMethod.MethodDefaultParameterInvocation : nextMethod.MethodParameterInvocation)
                    .Outdent().AppendLine("}")
                .Outdent().AppendLine("};");
                return builder.ToString();
            }
            else if (this.IsPagingNonPollingOperation)
            {
                var returnTypeBody = ReturnType.Body as SequenceTypeJva;
                var builder = new IndentedStringBuilder();
                builder.AppendLine("{0}<{1}<{2}>> response = {3}Delegate(call.execute());",
                    ReturnTypeJva.ClientResponseType, returnTypeBody.PageImplType, returnTypeBody.ElementType.Name, this.Name.ToCamelCase());
                builder.AppendLine("{0} result = response.body().items();", this.ReturnType.Body.Name);
                return builder.ToString();
            }
            else
            {
                return base.ResponseGeneration();
            }
        }

        [JsonIgnore]
        public override string ReturnValue
        {
            get
            {
                if (this.IsPagingOperation || this.IsPagingNonPollingOperation)
                {
                    if (ReturnType.Headers != null)
                    {
                        return string.Format(CultureInfo.InvariantCulture, "new {0}<>(result, response.headers(), response.response())",
                            ReturnTypeJva.ClientResponseType);
                    }
                    else
                    {
                        return string.Format(CultureInfo.InvariantCulture, "new {0}<>(result, response.response())",
                            ReturnTypeJva.ClientResponseType);
                    }
                }
                else
                {
                    return base.ReturnValue;
                }
            }
        }

        public override string SuccessCallback(bool filterRequired = false)
        {
            if (this.IsPagingOperation)
            {
                var builder = new IndentedStringBuilder();
                builder.AppendLine("{0} result = {1}Delegate(response);",
                    ReturnTypeJva.WireResponseTypeString, this.Name);
                builder.AppendLine("if (serviceCallback != null) {").Indent();
                builder.AppendLine("serviceCallback.load(result.body().items());");
                builder.AppendLine("if (result.body().nextPageLink() != null").Indent().Indent()
                    .AppendLine("&& serviceCallback.progress(result.body().items()) == ListOperationCallback.PagingBahavior.CONTINUE) {").Outdent();
                string invocation;
                MethodJva nextMethod = GetPagingNextMethodWithInvocation(out invocation, true);
                TransformPagingGroupedParameter(builder, nextMethod, filterRequired);
                var nextCall = string.Format(CultureInfo.InvariantCulture, "{0}(result.body().nextPageLink(), {1});",
                    invocation,
                    filterRequired ? nextMethod.MethodRequiredParameterInvocationWithCallback : nextMethod.MethodParameterInvocationWithCallback);
                builder.AppendLine(nextCall.Replace(
                    string.Format(", {0}", nextMethod.Parameters.First(p => p.Name.ToString().StartsWith("next", StringComparison.OrdinalIgnoreCase)).Name),
                    "")).Outdent();
                builder.AppendLine("} else {").Indent();
                if (ReturnType.Headers == null)
                {
                    builder.AppendLine("serviceCallback.success(new {0}<>(serviceCallback.get(), result.response()));", ReturnTypeJva.ClientResponseType);
                }
                else
                {
                    builder.AppendLine("serviceCallback.success(new {0}<>(serviceCallback.get(), result.headers(), result.response()));", ReturnTypeJva.ClientResponseType);
                }
                builder.Outdent().AppendLine("}").Outdent().AppendLine("}");
                if (ReturnType.Headers == null)
                {
                builder.AppendLine("serviceFuture.success(new {0}<>(result.body().items(), response));", ReturnTypeJva.ClientResponseType);
                }
                else
                {
                    builder.AppendLine("serviceFuture.success(new {0}<>(result.body().items(), result.headers(), result.response()));", ReturnTypeJva.ClientResponseType);
                }
                return builder.ToString();
            }
            else if (this.IsPagingNextOperation)
            {
                var builder = new IndentedStringBuilder();
                builder.AppendLine("{0} result = {1}Delegate(response);", ReturnTypeJva.WireResponseTypeString, this.Name);
                builder.AppendLine("serviceCallback.load(result.body().items());");
                builder.AppendLine("if (result.body().nextPageLink() != null").Indent().Indent();
                builder.AppendLine("&& serviceCallback.progress(result.body().items()) == ListOperationCallback.PagingBahavior.CONTINUE) {").Outdent();
                var nextCall = string.Format(CultureInfo.InvariantCulture, "{0}Async(result.body().nextPageLink(), {1});",
                    this.Name,
                    filterRequired ? MethodRequiredParameterInvocationWithCallback : MethodParameterInvocationWithCallback);
                builder.AppendLine(nextCall.Replace(
                    string.Format(", {0}", Parameters.First(p => p.Name.ToString().StartsWith("next", StringComparison.OrdinalIgnoreCase)).Name),
                    "")).Outdent();
                builder.AppendLine("} else {").Indent();
                if (ReturnType.Headers == null)
                {
                    builder.AppendLine("serviceCallback.success(new {0}<>(serviceCallback.get(), result.response()));", ReturnTypeJva.ClientResponseType);
                }
                else
                {
                    builder.AppendLine("serviceCallback.success(new {0}<>(serviceCallback.get(), result.headers(), result.response()));", ReturnTypeJva.ClientResponseType);
                }
                builder.Outdent().AppendLine("}");
                return builder.ToString();
            }
            else if (this.IsPagingNonPollingOperation)
            {
                var returnTypeBody = ReturnType.Body as SequenceTypeJva;
                var builder = new IndentedStringBuilder();
                builder.AppendLine("{0}<{1}<{2}>> result = {3}Delegate(response);",
                    ReturnTypeJva.ClientResponseType, returnTypeBody.PageImplType, returnTypeBody.ElementType.Name, this.Name.ToCamelCase());
                if (ReturnType.Headers == null)
                {
                    builder.AppendLine("serviceCallback.success(new {0}<>(result.body().items(), result.response()));", ReturnTypeJva.ClientResponseType);
                }
                else
                {
                    builder.AppendLine("serviceCallback.success(new {0}<>(result.body().items(), result.headers(), result.response()));", ReturnTypeJva.ClientResponseType);
                }
                return builder.ToString();
            }
            return base.SuccessCallback();
        }

        private MethodJva GetPagingNextMethodWithInvocation(out string invocation, bool async = false, bool singlePage = true)
        {
            String methodSuffixString = "WithServiceResponse";
            if (singlePage)
            {
                methodSuffixString = "SinglePage";
            }
            if (IsPagingNextOperation)
            {
                invocation = Name + methodSuffixString + (async ? "Async" : "");
                return this;
            }
            string name = this.Extensions.GetValue<Fixable<string>>("nextMethodName")?.ToCamelCase();
            string group = this.Extensions.GetValue<Fixable<string>>("nextMethodGroup")?.ToCamelCase();
            group = CodeNamerJva.Instance.GetMethodGroupName(group);
            var methodModel =
                CodeModel.Methods.FirstOrDefault(m =>
                    (group == null ? m.Group == null : group.Equals(m.Group, StringComparison.OrdinalIgnoreCase))
                    && m.Name.ToString().Equals(name, StringComparison.OrdinalIgnoreCase)) as MethodJva;
            group = group.ToPascalCase();
            name = name + methodSuffixString;
            if (async)
            {
                name = name + "Async";
            }
            if (group == null || this.Group == methodModel.Group)
            {
                invocation = name;
            }
            else
            {
                invocation = string.Format(CultureInfo.InvariantCulture, "{0}.get{1}().{2}", ClientReference.Replace("this.", ""), group, name);
            }
            return methodModel;
        }

        public string GetPagingNextMethodInvocation(bool async = false, bool singlePage = true)
        {
            string invocation;
            GetPagingNextMethodWithInvocation(out invocation, async, singlePage);
            return invocation;
        }

        protected virtual void TransformPagingGroupedParameter(IndentedStringBuilder builder, MethodJva nextMethod, bool filterRequired = false)
        {
            if (this.InputParameterTransformation.IsNullOrEmpty() || nextMethod.InputParameterTransformation.IsNullOrEmpty())
            {
                return;
            }
            var groupedType = this.InputParameterTransformation.First().ParameterMappings[0].InputParameter;
            var nextGroupType = nextMethod.InputParameterTransformation.First().ParameterMappings[0].InputParameter;
            if (nextGroupType.Name == groupedType.Name)
            {
                return;
            }
            var nextGroupTypeName = CodeNamerJva.Instance.GetTypeName(nextGroupType.Name);
            if (filterRequired && !groupedType.IsRequired)
            {
                return;
            }
            if (!groupedType.IsRequired)
            {
                builder.AppendLine("{0} {1} = null;", nextGroupTypeName, nextGroupType.Name.ToCamelCase());
                builder.AppendLine("if ({0} != null) {{", groupedType.Name.ToCamelCase());
                builder.Indent();
                builder.AppendLine("{0} = new {1}();", nextGroupType.Name.ToCamelCase(), nextGroupTypeName);
            }
            else
            {
                builder.AppendLine("{1} {0} = new {1}();", nextGroupType.Name.ToCamelCase(), nextGroupTypeName);
            }
            foreach (var outParam in nextMethod.InputParameterTransformation.Select(t => t.OutputParameter))
            {
                builder.AppendLine("{0}.with{1}({2}.{3}());", nextGroupType.Name.ToCamelCase(), outParam.Name.ToPascalCase(), groupedType.Name.ToCamelCase(), outParam.Name.ToCamelCase());
            }
            if (!groupedType.IsRequired)
            {
                builder.Outdent().AppendLine(@"}");
            }
        }

        public override string ClientResponse(bool filterRequired = false)
        {
            if (this.IsPagingOperation || this.IsPagingNextOperation)
            {
                IndentedStringBuilder builder = new IndentedStringBuilder();
                builder.AppendLine("ServiceResponse<{0}> result = {1}Delegate(response);", ReturnTypeJva.GenericBodyWireTypeString, this.Name);
                builder.AppendLine("{0} body = null;", ReturnTypeJva.ServiceFutureGenericParameterString)
                    .AppendLine("if (result.body() != null) {")
                    .Indent().AppendLine("{0}", ReturnTypeJva.ConvertBodyToClientType("result.body()", "body"))
                    .Outdent().AppendLine("}");
                builder.AppendLine("ServiceResponse<{0}> clientResponse = new ServiceResponse<{0}>(body, result.response());",
                    ReturnTypeJva.ServiceFutureGenericParameterString);
                return builder.ToString();
            }
            else if (this.IsPagingNonPollingOperation)
            {
                IndentedStringBuilder builder = new IndentedStringBuilder();
                builder.AppendLine("ServiceResponse<{0}> result = {1}Delegate(response);", ReturnTypeJva.GenericBodyWireTypeString, this.Name);
                builder.AppendLine("ServiceResponse<{0}> clientResponse = new ServiceResponse<{0}>(result.body().items(), result.response());",
                    ReturnTypeJva.ServiceFutureGenericParameterString);
                return builder.ToString();
            }
            else
            {
                return base.ClientResponse(filterRequired);
            }
        }

        [JsonIgnore]
        public override string ServiceFutureFactoryMethod
        {
            get
            {
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    if (ReturnType.Headers == null)
                    {
                        return "fromPageResponse";
                    }
                    else
                    {
                        return "fromHeaderPageResponse";
                    }
                }
                else
                {
                    return base.ServiceFutureFactoryMethod;
                }
            }
        }

        [JsonIgnore]
        public override string CallbackDocumentation
        {
            get
            {
                IndentedStringBuilder builder = new IndentedStringBuilder();
                if (this.IsPagingNextOperation)
                {
                    builder.AppendLine(" * @param serviceFuture the ServiceFuture object tracking the Retrofit calls");
                }
                builder.Append(" * @param serviceCallback the async ServiceCallback to handle successful and failed responses.");
                return builder.ToString();
            }
        }

        [JsonIgnore]
        public string NextUrlConstruction
        {
            get
            {
                var builder = new StringBuilder("String.format(");
                var regex = new Regex("{\\w+}");
                var matches = regex.Matches(Url);
                builder.Append("\"").Append(regex.Replace(Url, "%s").TrimStart('/')).Append("\"");
                foreach (Match match in matches)
                {
                    var sn = match.Value.Trim('{', '}');
                    builder.Append(", " + base.RetrofitParameters.First(p => p.SerializedName == sn).WireName);
                }
                return builder.Append(")").ToString();
            }
        }

        [JsonIgnore]
        public override string RuntimeBasePackage
        {
            get
            {
                return "com.microsoft.azure";
            }
        }

        [JsonIgnore]
        public override List<string> InterfaceImports
        {
            get
            {
                var imports = base.InterfaceImports;
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    imports.Remove("com.microsoft.rest.ServiceCallback");
                    imports.Add("com.microsoft.azure.ListOperationCallback");
                    imports.Add("com.microsoft.azure.Page");
                    imports.Add("com.microsoft.azure.PagedList");
                }
                return imports;
            }
        }

        [JsonIgnore]
        public override List<string> ImplImports
        {
            get
            {
                var imports = base.ImplImports;
                if (this.IsLongRunningOperation)
                {
                    imports.Remove("com.microsoft.azure.AzureResponseBuilder");
                    this.Responses.Select(r => r.Value.Body).Concat(new IModelType[] { DefaultResponse.Body })
                        .SelectMany(t => t.ImportSafe())
                        .Where(i => !this.Parameters.Any(p => p.ModelType.ImportSafe().Contains(i)))
                        .ForEach(i => imports.Remove(i));
                    // return type may have been removed as a side effect
                    imports.AddRange(ReturnTypeJva.ImplImports);
                }
                var typeName = (ReturnTypeJva.BodyClientType as SequenceTypeJva)?.PageImplType;
                CompositeType ctype = null;
                if (typeName != null)
                {
                    ctype = new CompositeTypeJva();
                    ctype.Name.CopyFrom(typeName);
                    ctype.CodeModel = CodeModel;
                }
                if (this.IsPagingOperation || this.IsPagingNextOperation)
                {
                    imports.Remove("java.util.ArrayList");
                    imports.Remove("com.microsoft.rest.ServiceCallback");
                    imports.Add("com.microsoft.azure.ListOperationCallback");
                    imports.Add("com.microsoft.azure.Page");
                    imports.Add("com.microsoft.azure.PagedList");
                    imports.Add("com.microsoft.azure.AzureServiceFuture");
                    imports.AddRange(ctype.ImportSafe());
                }
                if (this.IsPagingNextOperation)
                {
                    imports.Remove("retrofit2.http.Path");
                    imports.Add("retrofit2.http.Url");
                }
                if (this.IsPagingNonPollingOperation)
                {
                    imports.AddRange(ctype.ImportSafe());
                }
                return imports;
            }
        }
    }
}