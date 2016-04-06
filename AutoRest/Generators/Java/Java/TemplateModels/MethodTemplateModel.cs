// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;
using System.Text;
using System;
using System.Net;

namespace Microsoft.Rest.Generator.Java
{
    public class MethodTemplateModel : Method
    {
        private ResponseModel _returnTypeModel;
        private Dictionary<HttpStatusCode, ResponseModel> _responseModels;

        public MethodTemplateModel(Method source, ServiceClient serviceClient)
        {
            this.LoadFrom(source);
            ParameterModels = new List<ParameterModel>();
            LogicalParameterModels = new List<ParameterModel>();
            source.Parameters.Where(p => p.Location == ParameterLocation.Path).ForEach(p => ParameterModels.Add(new ParameterModel(p, this)));
            source.Parameters.Where(p => p.Location != ParameterLocation.Path).ForEach(p => ParameterModels.Add(new ParameterModel(p, this)));
            source.LogicalParameters.ForEach(p => LogicalParameterModels.Add(new ParameterModel(p, this)));
            ServiceClient = serviceClient;
            if (source.Group != null)
            {
                OperationName = source.Group.ToPascalCase();
                ClientReference = "this.client";
            }
            else
            {
                OperationName = serviceClient.Name;
                ClientReference = "this";
            }
            _returnTypeModel = new ResponseModel(ReturnType);
            _responseModels = new Dictionary<HttpStatusCode,ResponseModel>();
            Responses.ForEach(r => _responseModels.Add(r.Key, new ResponseModel(r.Value)));
        }

        public string ClientReference { get; set; }

        public string OperationName { get; set; }

        public ServiceClient ServiceClient { get; set; }

        public List<ParameterModel> ParameterModels { get; private set; }

        public List<ParameterModel> LogicalParameterModels { get; private set; }

        public virtual ResponseModel ReturnTypeModel
        {
            get
            {
                return _returnTypeModel;
            }
        }

        public virtual Dictionary<HttpStatusCode, ResponseModel> ResponseModels
        {
            get
            {
                return _responseModels;
            }
        }

        public IEnumerable<ParameterModel> RetrofitParameters
        {
            get
            {
                return LogicalParameterModels.Where(p => p.Location != ParameterLocation.None)
                    .Where(p => !p.Extensions.ContainsKey("hostParameter"));
            }
        }

        public IEnumerable<ParameterModel> OrderedRetrofitParameters
        {
            get
            {
                return RetrofitParameters.Where(p => p.Location == ParameterLocation.Path)
                    .Union(RetrofitParameters.Where(p => p.Location != ParameterLocation.Path));
            }
        }

        /// <summary>
        /// Generate the method parameter declarations for a method
        /// </summary>
        public virtual string MethodParameterApiDeclaration
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in OrderedRetrofitParameters)
                {
                    StringBuilder declarationBuilder = new StringBuilder();
                    if (Url.Contains("{" + parameter.Name + "}"))
                    {
                        parameter.Location = ParameterLocation.Path;
                    }
                    if (parameter.Location == ParameterLocation.Path ||
                        parameter.Location == ParameterLocation.Query ||
                        parameter.Location == ParameterLocation.Header)
                    {
                        declarationBuilder.Append(string.Format(CultureInfo.InvariantCulture,
                            "@{0}(\"{1}\") ",
                            parameter.Location.ToString(),
                            parameter.SerializedName));
                    }
                    else if (parameter.Location == ParameterLocation.Body)
                    {
                        declarationBuilder.Append(string.Format(CultureInfo.InvariantCulture, 
                            "@{0} ", 
                            parameter.Location.ToString()));
                    }
                    else if (parameter.Location == ParameterLocation.FormData)
                    {
                        declarationBuilder.Append(string.Format(CultureInfo.InvariantCulture,
                            "@Part(\"{0}\") ",
                            parameter.SerializedName));
                    }
                    var declarativeName = parameter.ClientProperty != null ? parameter.ClientProperty.Name : parameter.Name;
                    declarationBuilder.Append(parameter.WireType.Name);
                    declarationBuilder.Append(" " + declarativeName);
                    declarations.Add(declarationBuilder.ToString());
                }

                var declaration = string.Join(", ", declarations);
                return declaration;
            }
        }

        public virtual string MethodParameterDeclaration
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in LocalParameters.Where(p => !p.IsConstant))
                {
                    declarations.Add(parameter.ClientType.ParameterVariant + " " + parameter.Name);
                }

                var declaration = string.Join(", ", declarations);
                return declaration;
            }
        }

        public virtual string MethodRequiredParameterDeclaration
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in LocalParameters.Where(p => !p.IsConstant && p.IsRequired))
                {
                    declarations.Add(parameter.ClientType.ParameterVariant + " " + parameter.Name);
                }

                var declaration = string.Join(", ", declarations);
                return declaration;
            }
        }

        public string MethodParameterInvocation
        {
            get
            {
                List<string> invocations = new List<string>();
                foreach (var parameter in LocalParameters)
                {
                    invocations.Add(parameter.Name);
                }

                var declaration = string.Join(", ", invocations);
                return declaration;
            }
        }

        public string MethodRequiredParameterInvocation
        {
            get
            {
                List<string> invocations = new List<string>();
                foreach (var parameter in LocalParameters)
                {
                    if (parameter.IsRequired)
                    {
                        invocations.Add(parameter.Name);
                    }
                    else
                    {
                        invocations.Add("null");
                    }
                }

                var declaration = string.Join(", ", invocations);
                return declaration;
            }
        }

        public string MethodParameterApiInvocation
        {
            get
            {
                List<string> invocations = new List<string>();
                foreach (var parameter in OrderedRetrofitParameters)
                {
                    invocations.Add(parameter.WireName);
                }

                var declaration = string.Join(", ", invocations);
                return declaration;
            }
        }

        public string MethodRequiredParameterApiInvocation
        {
            get
            {
                List<string> invocations = new List<string>();
                foreach (var parameter in OrderedRetrofitParameters)
                {
                    invocations.Add(parameter.WireName);
                }

                var declaration = string.Join(", ", invocations);
                return declaration;
            }
        }

        public string ParameterConversion
        {
            get
            {
                IndentedStringBuilder builder = new IndentedStringBuilder();
                foreach (var p in RetrofitParameters)
                {
                    if (p.NeedsConversion)
                    {
                        builder.Append(p.ConvertToWireType(p.Name, ClientReference));
                    }
                }
                return builder.ToString();
            }
        }

        public string RequiredParameterConversion
        {
            get
            {
                IndentedStringBuilder builder = new IndentedStringBuilder();
                foreach (var p in RetrofitParameters.Where(p => p.IsRequired))
                {
                    if (p.NeedsConversion)
                    {
                        builder.Append(p.ConvertToWireType(p.Name, ClientReference));
                    }
                }
                return builder.ToString();
            }
        }

        /// <summary>
        /// Generates input mapping code block.
        /// </summary>
        /// <returns></returns>
        public virtual string BuildInputMappings(bool filterRequired = false)
        {
            var builder = new IndentedStringBuilder();
            foreach (var transformation in InputParameterTransformation)
            {
                var nullCheck = BuildNullCheckExpression(transformation);
                bool conditionalAssignment = !string.IsNullOrEmpty(nullCheck) && !transformation.OutputParameter.IsRequired && !filterRequired;
                if (conditionalAssignment)
                {
                    builder.AppendLine("{0} {1} = null;",
                            ((ParameterModel) transformation.OutputParameter).ClientType.ParameterVariant,
                            transformation.OutputParameter.Name);
                    builder.AppendLine("if ({0}) {{", nullCheck).Indent();
                }

                if (transformation.ParameterMappings.Any(m => !string.IsNullOrEmpty(m.OutputParameterProperty)) &&
                    transformation.OutputParameter.Type is CompositeType)
                {
                    builder.AppendLine("{0}{1} = new {2}();",
                        !conditionalAssignment ? ((ParameterModel)transformation.OutputParameter).ClientType.ParameterVariant + " " : "",
                        transformation.OutputParameter.Name,
                        transformation.OutputParameter.Type.Name);
                }

                foreach (var mapping in transformation.ParameterMappings)
                {
                    if (filterRequired && !mapping.InputParameter.IsRequired)
                    {
                        builder.AppendLine("{0}{1}{2};",
                            !conditionalAssignment && !(transformation.OutputParameter.Type is CompositeType) ?
                                ((ParameterModel)transformation.OutputParameter).WireType + " " : "",
                            ((ParameterModel)transformation.OutputParameter).WireName,
                            " = " + ((ParameterModel)transformation.OutputParameter).WireType.DefaultValue(this));
                    }
                    else
                    {
                        builder.AppendLine("{0}{1}{2};",
                            !conditionalAssignment && !(transformation.OutputParameter.Type is CompositeType) ?
                                ((ParameterModel)transformation.OutputParameter).ClientType.ParameterVariant + " " : "",
                            transformation.OutputParameter.Name,
                            GetMapping(mapping));
                    }
                }

                if (conditionalAssignment)
                {
                    builder.Outdent()
                       .AppendLine("}");
                }
            }

            return builder.ToString();
        }

        private static string GetMapping(ParameterMapping mapping)
        {
            string inputPath = mapping.InputParameter.Name;
            if (mapping.InputParameterProperty != null)
            {
                inputPath += "." + CodeNamer.CamelCase(mapping.InputParameterProperty) + "()";
            }

            string outputPath = "";
            if (mapping.OutputParameterProperty != null)
            {
                outputPath += ".set" + CodeNamer.PascalCase(mapping.OutputParameterProperty);
                return string.Format(CultureInfo.InvariantCulture, "{0}({1})", outputPath, inputPath);
            }
            else
            {
                return string.Format(CultureInfo.InvariantCulture, "{0} = {1}", outputPath, inputPath);
            }
        }

        private static string BuildNullCheckExpression(ParameterTransformation transformation)
        {
            if (transformation == null)
            {
                throw new ArgumentNullException("transformation");
            }

            return string.Join(" || ",
                transformation.ParameterMappings
                    .Where(m => !m.InputParameter.IsRequired)
                    .Select(m => m.InputParameter.Name + " != null"));
        }

        public IEnumerable<ParameterModel> RequiredNullableParameters
        {
            get
            {
                foreach (var param in ParameterModels)
                {
                    if (!param.Type.IsPrimaryType(KnownPrimaryType.Int) &&
                        !param.Type.IsPrimaryType(KnownPrimaryType.Double) &&
                        !param.Type.IsPrimaryType(KnownPrimaryType.Boolean) &&
                        !param.Type.IsPrimaryType(KnownPrimaryType.Long) &&
                        !param.IsConstant && param.IsRequired)
                    {
                        yield return param;
                    }
                }
            }
        }

        public IEnumerable<ParameterModel> ParametersToValidate
        {
            get
            {
                foreach (var param in ParameterModels)
                {
                    if (param.Type is PrimaryType ||
                        param.Type is EnumType ||
                        param.IsConstant)
                    {
                        continue;
                    }
                    yield return param;
                }
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
        public string MethodParameterApiDeclarationWithCallback
        {
            get
            {
                var parameters = MethodParameterApiDeclaration;
                if (!parameters.IsNullOrEmpty())
                {
                    parameters += ", ";
                }
                parameters += "ServiceResponseCallback cb";
                return parameters;
            }
        }

        public virtual string MethodParameterDeclarationWithCallback
        {
            get
            {
                var parameters = MethodParameterDeclaration;
                if (!parameters.IsNullOrEmpty())
                {
                    parameters += ", ";
                }
                parameters += string.Format(CultureInfo.InvariantCulture, "final ServiceCallback<{0}> serviceCallback",
                    ReturnTypeModel.GenericBodyClientTypeString);
                return parameters;
            }
        }

        public virtual string MethodRequiredParameterDeclarationWithCallback
        {
            get
            {
                var parameters = MethodRequiredParameterDeclaration;
                if (!parameters.IsNullOrEmpty())
                {
                    parameters += ", ";
                }
                parameters += string.Format(CultureInfo.InvariantCulture, "final ServiceCallback<{0}> serviceCallback",
                    ReturnTypeModel.GenericBodyClientTypeString);
                return parameters;
            }
        }

        public virtual string MethodParameterInvocationWithCallback
        {
            get
            {
                var parameters = MethodParameterInvocation;
                if (!parameters.IsNullOrEmpty())
                {
                    parameters += ", ";
                }
                parameters += "serviceCallback";
                return parameters;
            }
        }

        public virtual string MethodRequiredParameterInvocationWithCallback
        {
            get
            {
                var parameters = MethodRequiredParameterInvocation;
                if (!parameters.IsNullOrEmpty())
                {
                    parameters += ", ";
                }
                parameters += "serviceCallback";
                return parameters;
            }
        }

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they appear in the method signature
        /// exclude global parameters
        /// </summary>
        public IEnumerable<ParameterModel> LocalParameters
        {
            get
            {
                //Omit parameter-group properties for now since Java doesn't support them yet
                return ParameterModels.Where(
                    p => p != null && p.ClientProperty == null && !string.IsNullOrWhiteSpace(p.Name))
                    .OrderBy(item => !item.IsRequired);
            }
        }

        /// <summary>
        /// Get the type for operation exception
        /// </summary>
        public virtual string OperationExceptionTypeString
        {
            get
            {
                if (this.DefaultResponse.Body is CompositeType)
                {
                    CompositeType type = this.DefaultResponse.Body as CompositeType;
                    return new ModelTemplateModel(type, ServiceClient).ExceptionTypeDefinitionName;
                }
                else
                {
                    return "ServiceException";
                }
            }
        }

        public virtual IEnumerable<string> Exceptions
        {
            get
            {
                yield return OperationExceptionTypeString;
                yield return "IOException";
                if (RequiredNullableParameters.Any())
                {
                    yield return "IllegalArgumentException";
                }
            }
        }

        public virtual string ExceptionString
        {
            get
            {
                return string.Join(", ", Exceptions);
            }
        }

        public virtual List<string> ExceptionStatements
        {
            get
            {
                List<string> exceptions = new List<string>();
                exceptions.Add(OperationExceptionTypeString + " exception thrown from REST call");
                exceptions.Add("IOException exception thrown from serialization/deserialization");
                if (RequiredNullableParameters.Any())
                {
                    exceptions.Add("IllegalArgumentException exception thrown from invalid parameters");
                }
                return exceptions;
            }
        }

        public string CallType
        {
            get
            {
                if (this.HttpMethod == HttpMethod.Head)
                {
                    return "Void";
                }
                else
                {
                    return "ResponseBody";
                }
            }
        }

        public string InternalCallback
        {
            get
            {
                if (this.HttpMethod == HttpMethod.Head)
                {
                    return "ServiceResponseEmptyCallback";
                }
                else
                {
                    return "ServiceResponseCallback";
                }
            }
        }

        public virtual string ResponseBuilder
        {
            get
            {
                return "ServiceResponseBuilder";
            }
        }

        public virtual string RuntimeBasePackage
        {
            get
            {
                return "com.microsoft.rest";
            }
        }

        public virtual string ResponseGeneration(bool filterRequired = false)
        {
            if (ReturnTypeModel.NeedsConversion)
            {
                IndentedStringBuilder builder= new IndentedStringBuilder();
                builder.AppendLine("ServiceResponse<{0}> response = {1}Delegate(call.execute());",
                    ReturnTypeModel.GenericBodyWireTypeString, this.Name.ToCamelCase());
                builder.AppendLine("{0} body = null;", ReturnTypeModel.BodyClientType.Name)
                    .AppendLine("if (response.getBody() != null) {")
                    .Indent().AppendLine("{0}", ReturnTypeModel.ConvertBodyToClientType("response.getBody()", "body"))
                    .Outdent().AppendLine("}");
                return builder.ToString();
            }
            return "";
        }

        public virtual string ReturnValue
        {
            get
            {
                if (ReturnTypeModel.NeedsConversion)
                {
                    return "new ServiceResponse<" + ReturnTypeModel.GenericBodyClientTypeString + ">(body, response.getResponse())";
                }
                return this.Name + "Delegate(call.execute())";
            }
        }

        public virtual string SuccessCallback(bool filterRequired = false)
        {
            if (ReturnTypeModel.NeedsConversion)
            {
                IndentedStringBuilder builder = new IndentedStringBuilder();
                builder.AppendLine("ServiceResponse<{0}> result = {1}Delegate(response);", ReturnTypeModel.GenericBodyWireTypeString, this.Name);
                builder.AppendLine("{0} body = null;", ReturnTypeModel.BodyClientType)
                    .AppendLine("if (result.getBody() != null) {")
                    .Indent().AppendLine("{0}", ReturnTypeModel.ConvertBodyToClientType("result.getBody()", "body"))
                    .Outdent().AppendLine("}");
                builder.AppendLine("serviceCallback.success(new ServiceResponse<{0}>(body, result.getResponse()));", ReturnTypeModel.GenericBodyClientTypeString);
                return builder.ToString();
            }
            return string.Format(CultureInfo.InvariantCulture, "serviceCallback.success({0}Delegate(response));", this.Name);
        }

        public virtual string ServiceCallConstruction
        {
            get
            {
                return "final ServiceCall serviceCall = new ServiceCall(call);";
            }
        }

        public virtual string CallbackDocumentation
        {
            get
            {
                return " * @param serviceCallback the async ServiceCallback to handle successful and failed responses.";
            }
        }

        public virtual List<string> InterfaceImports
        {
            get
            {
                HashSet<string> imports = new HashSet<string>();
                // static imports
                imports.Add("com.microsoft.rest.ServiceCall");
                imports.Add("com.microsoft.rest." + ReturnTypeModel.ClientResponseType);
                imports.Add("com.microsoft.rest.ServiceCallback");
                // parameter types
                this.ParameterModels.ForEach(p => imports.AddRange(p.InterfaceImports));
                // return type
                imports.AddRange(this.ReturnTypeModel.InterfaceImports);
                // exceptions
                this.ExceptionString.Split(new string[] { ", " }, StringSplitOptions.RemoveEmptyEntries)
                    .ForEach(ex => {
                        string exceptionImport = JavaCodeNamer.GetJavaException(ex, ServiceClient);
                        if (exceptionImport != null) imports.Add(JavaCodeNamer.GetJavaException(ex, ServiceClient));
                    });
                return imports.ToList();
            }
        }

        public virtual List<string> ImplImports
        {
            get
            {
                HashSet<string> imports = new HashSet<string>();
                // static imports
                imports.Add("retrofit2.Call");
                if (RequestContentType == "multipart/form-data" || RequestContentType == "application/x-www-form-urlencoded")
                {
                    imports.Add("retrofit2.http.Multipart");
                }
                else
                {
                    imports.Add("retrofit2.http.Headers");
                }
                imports.Add("retrofit2.Response");
                imports.Add("retrofit2.Retrofit");
                if (this.HttpMethod != HttpMethod.Head)
                {
                    imports.Add("okhttp3.ResponseBody");
                }
                imports.Add("com.microsoft.rest.ServiceCall");
                imports.Add("com.microsoft.rest." + ReturnTypeModel.ClientResponseType);
                imports.Add(RuntimeBasePackage + "." + ResponseBuilder);
                imports.Add("com.microsoft.rest.ServiceCallback");
                this.RetrofitParameters.ForEach(p => imports.AddRange(p.RetrofitImports));
                // Http verb annotations
                imports.Add(this.HttpMethod.ImportFrom());
                // response type conversion
                if (this.Responses.Any())
                {
                    imports.Add("com.google.common.reflect.TypeToken");
                }
                // validation
                if (!ParametersToValidate.IsNullOrEmpty())
                {
                    imports.Add("com.microsoft.rest.Validator");
                }
                // internal callback
                if (this.CallType == "Void")
                {
                    imports.Add("com.microsoft.rest.ServiceResponseEmptyCallback");
                }
                else
                {
                    imports.Add("com.microsoft.rest.ServiceResponseCallback");
                }
                // parameters
                this.LocalParameters.Concat(this.LogicalParameterModels)
                    .ForEach(p => imports.AddRange(p.ImplImports));
                // return type
                imports.AddRange(this.ReturnTypeModel.ImplImports);
                if (ReturnType.Body.IsPrimaryType(KnownPrimaryType.Stream))
                {
                    imports.Add("retrofit2.http.Streaming");
                }
                // response type (can be different from return type)
                this.ResponseModels.ForEach(r => imports.AddRange(r.Value.ImplImports));
                // exceptions
                this.ExceptionString.Split(new string[] { ", " }, StringSplitOptions.RemoveEmptyEntries)
                    .ForEach(ex =>
                    {
                        string exceptionImport = JavaCodeNamer.GetJavaException(ex, ServiceClient);
                        if (exceptionImport != null) imports.Add(JavaCodeNamer.GetJavaException(ex, ServiceClient));
                    });
                return imports.ToList();
            }
        }
    }
}