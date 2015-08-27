// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using Microsoft.CSharp;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;
using System.Text;

namespace Microsoft.Rest.Generator.Java
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
        }

        public string OperationName { get; set; }

        public ServiceClient ServiceClient { get; set; }

        public List<ParameterTemplateModel> ParameterTemplateModels { get; private set; }

        public IScopeProvider Scope
        {
            get { return _scopeProvider; }
        }

        /// <summary>
        /// Generate the method parameter declarations for a method
        /// </summary>
        public string MethodParameterApiDeclaration
        {
            get
            {
                List<string> declarations = new List<string>();
                foreach (var parameter in ParameterTemplateModels)
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
                foreach (var parameter in ParameterTemplateModels)
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
                return ParameterTemplateModels.Where(
                    p => p != null && p.ClientProperty == null && !string.IsNullOrWhiteSpace(p.Name))
                    .OrderBy(item => !item.IsRequired);
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

        public string ReturnStatement {
            get
            {
                StringBuilder sb = new StringBuilder();
                if (this.ReturnType != null)
                {
                    sb.Append("return ");
                }
                sb.Append("response.getBody();");
                return sb.ToString();
            }
        }
    }
}