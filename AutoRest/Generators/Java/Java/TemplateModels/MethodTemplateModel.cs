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

namespace Microsoft.Rest.Generator.Java
{
    public class MethodTemplateModel : Method
    {
        private readonly IScopeProvider _scopeProvider = new ScopeProvider();

        public MethodTemplateModel(Method source, ServiceClient serviceClient)
        {
            this.LoadFrom(source);
            ParameterTemplateModels = new List<ParameterTemplateModel>();
            source.Parameters.Where(p => p.Location == ParameterLocation.Path).ForEach(p => ParameterTemplateModels.Add(new ParameterTemplateModel(p)));
            source.Parameters.Where(p => p.Location != ParameterLocation.Path).ForEach(p => ParameterTemplateModels.Add(new ParameterTemplateModel(p)));
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

        public IEnumerable<Parameter> OrderedLogicalParameters
        {
            get
            {
                return LogicalParameters.Where(p => p.Location == ParameterLocation.Path)
                    .Union(LogicalParameters.Where(p => p.Location != ParameterLocation.Path));
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
                foreach (var parameter in OrderedLogicalParameters)
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
                    var declarativeName = parameter.ClientProperty != null ? parameter.ClientProperty.Name : parameter.Name;
                    if ((parameter.Location != ParameterLocation.Body)
                        && parameter.Type.NeedsSpecialSerialization())
                    {
                        declarationBuilder.Append("String");
                    }
                    else
                    {
                        declarationBuilder.Append(parameter.Type.ToString());
                    }
                    declarationBuilder.Append(" " + declarativeName);
                    declarations.Add(declarationBuilder.ToString());
                }

                var declaration = string.Join(", ", declarations);
                return declaration;
            }
        }

        public string MethodParameterDeclaration
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in LocalParameters)
                {
                    declarations.Add(parameter.Type.ToString() + " " + parameter.Name);
                }

                var declaration = string.Join(", ", declarations);
                return declaration;
            }
        }

        public string MethodParameterInvocation
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in OrderedLogicalParameters)
                {
                    if ((parameter.Location != ParameterLocation.Body)
                         && parameter.Type.NeedsSpecialSerialization())
                    {
                        declarations.Add(parameter.ToString(parameter.Name));
                    }
                    else
                    {
                        declarations.Add(parameter.Name);
                    }
                }

                var declaration = string.Join(", ", declarations);
                return declaration;
            }
        }

        public string MethodParameterInvocationWithCallback
        {
            get
            {
                var parameters = MethodParameterInvocation;
                if (!parameters.IsNullOrEmpty())
                {
                    parameters += ", ";
                }
                parameters += string.Format(CultureInfo.InvariantCulture, "new ServiceResponseCallback()");
                return parameters;
            }
        }

        public string LocalMethodParameterInvocation
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in LocalParameters)
                {
                    if ((parameter.Location != ParameterLocation.Body)
                         && parameter.Type.NeedsSpecialSerialization())
                    {
                        declarations.Add(parameter.ToString(parameter.Name));
                    }
                    else
                    {
                        declarations.Add(parameter.Name);
                    }
                }

                var declaration = string.Join(", ", declarations);
                return declaration;
            }
        }

        public string LocalMethodParameterInvocationWithCallback
        {
            get
            {
                var parameters = LocalMethodParameterInvocation;
                if (!parameters.IsNullOrEmpty())
                {
                    parameters += ", ";
                }
                parameters += string.Format(CultureInfo.InvariantCulture, "new ServiceCallback<" + GenericReturnTypeString + ">()");
                return parameters;
            }
        }

        public IEnumerable<ParameterTemplateModel> RequiredNullableParameters
        {
            get
            {
                foreach (var param in ParameterTemplateModels)
                {
                    if (param.Type != PrimaryType.Int &&
                        param.Type != PrimaryType.Double &&
                        param.Type != PrimaryType.Boolean &&
                        param.Type != PrimaryType.Long &&
                        param.IsRequired)
                    {
                        yield return param;
                    }
                }
            }
        }

        public IEnumerable<ParameterTemplateModel> ParametersToValidate
        {
            get
            {
                foreach (var param in ParameterTemplateModels)
                {
                    if (param.Type is PrimaryType ||
                        param.Type is EnumType)
                    {
                        continue;
                    }
                    if (param.IsRequired)
                    {
                        yield return param;
                    }
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

        public string MethodParameterDeclarationWithCallback
        {
            get
            {
                var parameters = MethodParameterDeclaration;
                if (!parameters.IsNullOrEmpty())
                {
                    parameters += ", ";
                }
                parameters += string.Format(CultureInfo.InvariantCulture, "final ServiceCallback<{0}> serviceCallback",
                    ReturnType != null ? JavaCodeNamer.WrapPrimitiveType(ReturnType).ToString() : "Void");
                return parameters;
            }
        }

        /// <summary>
        /// Get the parameters that are actually method parameters in the order they appear in the method signature
        /// exclude global parameters
        /// </summary>
        public IEnumerable<ParameterTemplateModel> LocalParameters
        {
            get
            {
                //Omit parameter-group properties for now since Java doesn't support them yet
                return ParameterTemplateModels.Where(
                    p => p != null && p.ClientProperty == null && !string.IsNullOrWhiteSpace(p.Name))
                    .OrderBy(item => !item.IsRequired);
            }
        }

        public virtual string Exceptions
        {
            get
            {
                List<string> exceptions = new List<string>();
                exceptions.Add("ServiceException");
                exceptions.Add("IOException");
                if (RequiredNullableParameters.Any())
                {
                    exceptions.Add("IllegalArgumentException");
                }
                return string.Join(", ", exceptions);
            }
        }

        public virtual List<string> ExceptionStatements
        {
            get
            {
                List<string> exceptions = new List<string>();
                exceptions.Add("ServiceException exception thrown from REST call");
                exceptions.Add("IOException exception thrown from serialization/deserialization");
                if (RequiredNullableParameters.Any())
                {
                    exceptions.Add("IllegalArgumentException exception thrown from invalid parameters");
                }
                return exceptions;
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
                    return JavaCodeNamer.WrapPrimitiveType(ReturnType).Name;
                }
                return "void";
            }
        }

        public string GenericReturnTypeString
        {
            get
            {
                if (ReturnType != null)
                {
                    return JavaCodeNamer.WrapPrimitiveType(ReturnType).Name;
                }
                return "Void";
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

        public virtual string ServiceResponseBuilderArgs
        {
            get
            {
                return "";
            }
        }

        public virtual List<string> InterfaceImports
        {
            get
            {
                HashSet<string> imports = new HashSet<string>();
                // static imports
                imports.Add("retrofit.Call");
                imports.Add("com.squareup.okhttp.ResponseBody");
                imports.Add("com.microsoft.rest.ServiceResponse");
                imports.Add("com.microsoft.rest.ServiceException");
                imports.Add("com.microsoft.rest.ServiceCallback");
                // parameter types
                this.Parameters.ForEach(p => imports.AddRange(p.Type.ImportFrom(ServiceClient.Namespace)));
                // parameter locations
                this.LogicalParameters.ForEach(p =>
                {
                    string locationImport = p.Location.ImportFrom();
                    if (!string.IsNullOrEmpty(locationImport))
                    {
                        imports.Add(p.Location.ImportFrom());
                    }
                });
                // return type
                imports.AddRange(this.ReturnType.ImportFrom(ServiceClient.Namespace));
                // Http verb annotations
                imports.Add(this.HttpMethod.ImportFrom());
                // exceptions
                this.Exceptions.Split(new string[] { ", " }, StringSplitOptions.RemoveEmptyEntries)
                    .ForEach(ex => imports.Add(JavaCodeNamer.GetJavaException(ex)));
                return imports.ToList();
            }
        }

        public virtual List<string> ImplImports
        {
            get
            {
                HashSet<string> imports = new HashSet<string>();
                // static imports
                imports.Add("retrofit.Call");
                imports.Add("retrofit.Response");
                imports.Add("retrofit.Retrofit");
                imports.Add("com.squareup.okhttp.ResponseBody");
                imports.Add("com.microsoft.rest.ServiceResponse");
                imports.Add("com.microsoft.rest." + ResponseBuilder);
                imports.Add("com.microsoft.rest.ServiceException");
                imports.Add("com.microsoft.rest.ServiceCallback");

                // response type conversion
                if (this.Responses.Any() || this.DefaultResponse != null)
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
                // parameter types
                this.LocalParameters.ForEach(p => imports.AddRange(p.Type.ImportFrom(ServiceClient.Namespace)));
                // parameter utils
                this.LocalParameters.ForEach(p => imports.AddRange(p.ImportFrom()));
                // return type
                imports.AddRange(this.ReturnType.ImportFrom(ServiceClient.Namespace));
                // response type (can be different from return type)
                this.Responses.ForEach(r => imports.AddRange(r.Value.ImportFrom(ServiceClient.Namespace)));
                imports.AddRange(DefaultResponse.ImportFrom(ServiceClient.Namespace));
                // exceptions
                this.Exceptions.Split(new string[] { ", " }, StringSplitOptions.RemoveEmptyEntries)
                    .ForEach(ex => imports.Add(JavaCodeNamer.GetJavaException(ex)));
                return imports.ToList();
            }
        }
    }
}