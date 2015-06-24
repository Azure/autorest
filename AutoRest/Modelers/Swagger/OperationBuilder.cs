// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using System.Diagnostics;
using System.Net;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;
using ParameterLocation = Microsoft.Rest.Modeler.Swagger.Model.ParameterLocation;
using System.Globalization;

namespace Microsoft.Rest.Modeler.Swagger
{
    /// <summary>
    /// The builder for building swagger operations into client model methods.
    /// </summary>
    public class OperationBuilder
    {
        protected List<string> _effectiveConsumes;
        protected List<string> _effectiveProduces;
        protected SwaggerModeler _swaggerModeler;
        protected Operation Operation;

        public OperationBuilder(Operation operation, SwaggerModeler swaggerModeler)
        {
            this.Operation = operation;
            this._swaggerModeler = swaggerModeler;
            this._effectiveConsumes = operation.Consumes ?? swaggerModeler.ServiceDefinition.Consumes;
            this._effectiveProduces = operation.Produces ?? swaggerModeler.ServiceDefinition.Produces;
        }

        public Method BuildMethod(HttpMethod httpMethod, string url, string methodName, string methodGroup)
        {
            EnsureUniqueMethodName(methodName, methodGroup);

            var method = new Method
            {
                HttpMethod = httpMethod,
                Url = url,
                Name = methodName
            };

            method.Documentation = Operation.Description;

            // Service parameters
            if (Operation.Parameters != null)
            {
                CollectionFormatBuilder collectionBuilder = new CollectionFormatBuilder();

                foreach (var swaggerParameter in DeduplicateParameters(Operation.Parameters))
                {
                    var parameter = ((ParameterBuilder) swaggerParameter.GetBuilder(_swaggerModeler)).Build();
                    method.Parameters.Add(parameter);

                    StringBuilder parameterName = new StringBuilder(parameter.Name);
                    parameterName = collectionBuilder.OnBuildMethodParameter(method, swaggerParameter,
                        parameterName);

                    if (swaggerParameter.In == ParameterLocation.Header)
                    {
                        method.RequestHeaders[swaggerParameter.Name] = 
                            string.Format(CultureInfo.InvariantCulture, "{{{0}}}", parameterName);
                    }
                }
            }

            // Response format
            var typesList = new List<Stack<IType>>();
            Operation.Responses.ForEach(response =>
            {
                if (string.Equals(response.Key, "default", StringComparison.OrdinalIgnoreCase))
                {
                    TryBuildDefaultResponse(methodName, response.Value, method);
                }
                else
                {
                    if (
                        !(TryBuildResponse(methodName, response.Key.ToHttpStatusCode(), response.Value, method,
                            typesList) ||
                          TryBuildStreamResponse(response.Key.ToHttpStatusCode(), response.Value, method, typesList) ||
                          TryBuildEmptyResponse(methodName, response.Key.ToHttpStatusCode(), response.Value, method,
                              typesList)))
                    {
                        throw new InvalidOperationException(
                            string.Format(CultureInfo.InvariantCulture, 
                            Resources.UnsupportedMimeTypeForResponseBody, 
                            methodName, 
                            response.Key));
                    }
                }
            });

            method.ReturnType = BuildMethodReturnType(typesList);
            if (method.Responses.Count == 0 &&
                method.DefaultResponse != null)
            {
                method.ReturnType = method.DefaultResponse;
            }

            // Copy extensions
            Operation.Extensions.ForEach(extention => method.Extensions.Add(extention.Key, extention.Value));

            return method;
        }

        private IEnumerable<SwaggerParameter> DeduplicateParameters(IEnumerable<SwaggerParameter> parameters)
        {
            return parameters
                .Select(s =>
                {
                    // if parameter with the same name exists in Body and Path/Query then we need to give it a unique name
                    if (s.In == ParameterLocation.Body)
                    {
                        string newName = s.Name;

                        while (parameters.Any(t => t.In != ParameterLocation.Body &&
                                                   string.Equals(t.Name, newName,
                                                       StringComparison.OrdinalIgnoreCase)))
                        {
                            newName += "Body";
                        }
                        s.Name = newName;
                    }
                    // if parameter with same name exists in Query and Path, make Query one required 
                    if (s.In == ParameterLocation.Query &&
                        parameters.Any(t => t.In == ParameterLocation.Path &&
                                            string.Equals(t.Name, s.Name, StringComparison.OrdinalIgnoreCase)))
                    {
                        s.IsRequired = true;
                    }

                    return s;
                });
        }

        private void BuildMethodReturnTypeStack(IType type, List<Stack<IType>> types)
        {
            var typeStack = new Stack<IType>();
            typeStack.Push(type);
            types.Add(typeStack);
        }

        private IType BuildMethodReturnType(List<Stack<IType>> types)
        {
            IType baseType = PrimaryType.Object;
            // Return null if no response is specified
            if (types.Count == 0)
            {
                return null;
            }
            // Return first if only one return type
            if (types.Count == 1)
            {
                return types.First().Pop();
            }

            // BuildParameter up type inheritance tree
            types.ForEach(typeStack =>
            {
                IType type = typeStack.Peek();
                while (!Equals(type, baseType))
                {
                    if (type is CompositeType && _swaggerModeler.ExtendedTypes.ContainsKey(type.Name))
                    {
                        type = _swaggerModeler.GeneratedTypes[_swaggerModeler.ExtendedTypes[type.Name]];
                    }
                    else
                    {
                        type = baseType;
                    }
                    typeStack.Push(type);
                }
            });

            // Eliminate commonly shared base classes 
            while (!types.First().IsNullOrEmpty())
            {
                IType currentType = types.First().Peek();
                foreach (var typeStack in types)
                {
                    IType t = typeStack.Pop();
                    if (!Equals(t, currentType))
                    {
                        return baseType;
                    }
                }
                baseType = currentType;
            }
            return baseType;
        }

        private bool TryBuildStreamResponse(HttpStatusCode responseStatusCode, Response response,
            Method method, List<Stack<IType>> types)
        {
            bool handled = false;
            if (SwaggerOperationProducesOctetStream(Operation))
            {
                if (response.Schema != null)
                {
                    CompositeType serviceType = response.Schema.GetBuilder(_swaggerModeler)
                        .BuildServiceType(response.Schema.Reference.StripDefinitionPath()) as CompositeType;

                    Debug.Assert(serviceType != null);

                    BuildMethodReturnTypeStack(serviceType, types);

                    VerifyFirstPropertyIsByteArray(serviceType);
                    method.Responses[responseStatusCode] = PrimaryType.Stream;
                    handled = true;
                }
            }
            return handled;
        }

        private void VerifyFirstPropertyIsByteArray(CompositeType serviceType)
        {
            var referenceKey = serviceType.Name;
            var responseType = _swaggerModeler.GeneratedTypes[referenceKey];
            var property = responseType.Properties.FirstOrDefault(p => p.Type == PrimaryType.ByteArray);
            if (property == null)
            {
                throw new KeyNotFoundException(
                    "Please specify a field with type of System.Byte[] to deserialize the file contents to");
            }
        }

        private bool TryBuildResponse(string methodName, HttpStatusCode responseStatusCode,
            Response response, Method method, List<Stack<IType>> types)
        {
            bool handled = false;
            IType serviceType;
            if (SwaggerOperationProducesJson(Operation))
            {
                if (TryBuildResponseBody(methodName, response,
                    s => GenerateResponseObjectName(s, responseStatusCode), out serviceType))
                {
                    method.Responses[responseStatusCode] = serviceType;
                    BuildMethodReturnTypeStack(serviceType, types);
                    handled = true;
                }
            }

            return handled;
        }

        private bool TryBuildEmptyResponse(string methodName, HttpStatusCode responseStatusCode,
            Response response, Method method, List<Stack<IType>> types)
        {
            bool handled = false;

            if (response.Schema == null)
            {
                method.Responses[responseStatusCode] = null;
                handled = true;
            }
            else
            {
                if (Operation.Produces.IsNullOrEmpty())
                {
                    method.Responses[responseStatusCode] = PrimaryType.Object;
                    BuildMethodReturnTypeStack(PrimaryType.Object, types);
                    handled = true;
                }

                var unwrapedSchemaProperties =
                    _swaggerModeler.GetResolver().Unwrap(response.Schema).Properties;
                if (unwrapedSchemaProperties != null && unwrapedSchemaProperties.Any())
                {
                    Logger.LogWarning(Resources.NoProduceOperationWithBody,
                        methodName);
                }
            }

            return handled;
        }

        private void TryBuildDefaultResponse(string methodName, Response response, Method method)
        {
            IType errorModel = null;
            if (SwaggerOperationProducesJson(Operation))
            {
                if (TryBuildResponseBody(methodName, response, s => GenerateErrorModelName(s), out errorModel))
                {
                    method.DefaultResponse = errorModel;
                }
            }
        }

        private bool TryBuildResponseBody(string methodName, Response response,
            Func<string, string> typeNamer, out IType responseType)
        {
            bool handled = false;
            responseType = null;
            if (SwaggerOperationProducesJson(Operation))
            {
                if (response.Schema != null)
                {
                    string referenceKey;
                    if (response.Schema.Reference != null)
                    {
                        referenceKey = response.Schema.Reference.StripDefinitionPath();
                        response.Schema.Reference = referenceKey;
                    }
                    else
                    {
                        referenceKey = typeNamer(methodName);
                    }

                    responseType = response.Schema.GetBuilder(_swaggerModeler).BuildServiceType(referenceKey);
                    handled = true;
                }
            }

            return handled;
        }

        private bool SwaggerOperationProducesJson(Operation operation)
        {
            return _effectiveProduces != null &&
                   _effectiveProduces.Contains("application/json", StringComparer.OrdinalIgnoreCase);
        }

        private bool SwaggerOperationConsumesJson(Operation operation)
        {
            return _effectiveConsumes != null &&
                   _effectiveConsumes.Contains("application/json", StringComparer.OrdinalIgnoreCase);
        }

        private bool SwaggerOperationProducesOctetStream(Operation operation)
        {
            return _effectiveProduces != null &&
                   _effectiveProduces.Contains("application/octet-stream", StringComparer.OrdinalIgnoreCase);
        }

        private bool SwaggerOperationConsumesMultipartFormData(Operation operation)
        {
            return _effectiveConsumes != null &&
                   _effectiveConsumes.Contains("multipart/form-data", StringComparer.OrdinalIgnoreCase);
        }

        private void EnsureUniqueMethodName(string methodName, string methodGroup)
        {
            string serviceOperationPrefix = "";
            if (methodGroup != null)
            {
                serviceOperationPrefix = methodGroup + "_";
            }

            if (_swaggerModeler.ServiceClient.Methods.Any(m => m.Group == methodGroup && m.Name == methodName))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, 
                    Resources.DuplicateOperationIdException,
                    serviceOperationPrefix + methodName));
            }
        }

        private static string GenerateResponseObjectName(string methodName, HttpStatusCode responseStatusCode)
        {
            return string.Format(CultureInfo.InvariantCulture, 
                "{0}{1}Response", methodName, responseStatusCode);
        }

        private static string GenerateErrorModelName(string methodName)
        {
            return string.Format(CultureInfo.InvariantCulture, 
                "{0}ErrorModel", methodName);
        }
    }
}