// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Properties;
using ParameterLocation = AutoRest.Swagger.Model.ParameterLocation;

namespace AutoRest.Swagger
{
    /// <summary>
    /// The builder for building swagger operations into client model methods.
    /// </summary>
    public class OperationBuilder
    {
        private IList<string> _effectiveProduces;
        private IList<string> _effectiveConsumes;
        private SwaggerModeler _swaggerModeler;
        private Operation _operation;
        private const string APP_JSON_MIME = "application/json";

        public OperationBuilder(Operation operation, SwaggerModeler swaggerModeler)
        {
            if (operation == null)
            {
                throw new ArgumentNullException("operation");
            }
            if (swaggerModeler == null)
            {
                throw new ArgumentNullException("swaggerModeler");
            }

            this._operation = operation;
            this._swaggerModeler = swaggerModeler;
            this._effectiveProduces = operation.Produces.Any() ? operation.Produces : swaggerModeler.ServiceDefinition.Produces;
            this._effectiveConsumes = operation.Consumes.Any() ? operation.Consumes : swaggerModeler.ServiceDefinition.Consumes;
        }

        public Method BuildMethod(HttpMethod httpMethod, string url, string methodName, string methodGroup)
        {
            EnsureUniqueMethodName(methodName, methodGroup);

            var method = new Method
            {
                HttpMethod = httpMethod,
                Url = url,
                Name = methodName,
                SerializedName = _operation.OperationId
            };
            
            method.RequestContentType = _effectiveConsumes.FirstOrDefault() ?? APP_JSON_MIME;
            string produce = _effectiveConsumes.FirstOrDefault(s => s.StartsWith(APP_JSON_MIME, StringComparison.OrdinalIgnoreCase));
            if (!string.IsNullOrEmpty(produce))
            {
                method.RequestContentType = produce;
            }

            if (method.RequestContentType.StartsWith(APP_JSON_MIME, StringComparison.OrdinalIgnoreCase) &&
                method.RequestContentType.IndexOf("charset=", StringComparison.OrdinalIgnoreCase) == -1)
            {
                // Enable UTF-8 charset
                method.RequestContentType += "; charset=utf-8";
            }

            method.Description = _operation.Description;
            method.Summary = _operation.Summary;
            method.ExternalDocsUrl = _operation.ExternalDocs?.Url;
            method.Deprecated = _operation.Deprecated;

            // Service parameters
            if (_operation.Parameters != null)
            {
                BuildMethodParameters(method);
            }

            // Build header object
            var responseHeaders = new Dictionary<string, Header>();
            foreach (var response in _operation.Responses.Values)
            {
                if (response.Headers != null)
                {
                    response.Headers.ForEach(h => responseHeaders[h.Key] = h.Value);
                }
            }

            var headerTypeName = string.Format(CultureInfo.InvariantCulture,
                "{0}-{1}-Headers", methodGroup, methodName).Trim('-');
            var headerType = new CompositeType
            {
                Name = headerTypeName,
                SerializedName = headerTypeName,
                Documentation = string.Format(CultureInfo.InvariantCulture, "Defines headers for {0} operation.", methodName)
            };
            responseHeaders.ForEach(h =>
            {
                var property = new Property
                {
                    Name = h.Key,
                    SerializedName = h.Key,
                    Type = h.Value.GetBuilder(this._swaggerModeler).BuildServiceType(h.Key),
                    Documentation = h.Value.Description
                };
                headerType.Properties.Add(property);
            });

            if (!headerType.Properties.Any())
            {
                headerType = null;
            }

            // Response format
            List<Stack<IType>> typesList = BuildResponses(method, headerType);

            method.ReturnType = BuildMethodReturnType(typesList, headerType);
            if (method.Responses.Count == 0)
            {
                method.ReturnType = method.DefaultResponse;
            }

            if (method.ReturnType.Headers != null)
            {
                _swaggerModeler.ServiceClient.HeaderTypes.Add(method.ReturnType.Headers as CompositeType);
            }

            // Copy extensions
            _operation.Extensions.ForEach(extention => method.Extensions.Add(extention.Key, extention.Value));

            return method;
        }

        private static IEnumerable<SwaggerParameter> DeduplicateParameters(IEnumerable<SwaggerParameter> parameters)
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

        private static void BuildMethodReturnTypeStack(IType type, List<Stack<IType>> types)
        {
            var typeStack = new Stack<IType>();
            typeStack.Push(type);
            types.Add(typeStack);
        }

        private void BuildMethodParameters(Method method)
        {
            foreach (var swaggerParameter in DeduplicateParameters(_operation.Parameters))
            {
                var parameter = ((ParameterBuilder)swaggerParameter.GetBuilder(_swaggerModeler)).Build();
                method.Parameters.Add(parameter);

                StringBuilder parameterName = new StringBuilder(parameter.Name);
                parameterName = CollectionFormatBuilder.OnBuildMethodParameter(method, swaggerParameter,
                    parameterName);

                if (swaggerParameter.In == ParameterLocation.Header)
                {
                    method.RequestHeaders[swaggerParameter.Name] =
                        string.Format(CultureInfo.InvariantCulture, "{{{0}}}", parameterName);
                }
            }
        }

        private List<Stack<IType>> BuildResponses(Method method, CompositeType headerType)
        {
            string methodName = method.Name;
            var typesList = new List<Stack<IType>>();
            foreach (var response in _operation.Responses)
            {
                if (string.Equals(response.Key, "default", StringComparison.OrdinalIgnoreCase))
                {
                    TryBuildDefaultResponse(methodName, response.Value, method, headerType);
                }
                else
                {
                    if (
                        !(TryBuildResponse(methodName, response.Key.ToHttpStatusCode(), response.Value, method,
                            typesList, headerType) ||
                          TryBuildStreamResponse(response.Key.ToHttpStatusCode(), response.Value, method, typesList, headerType) ||
                          TryBuildEmptyResponse(methodName, response.Key.ToHttpStatusCode(), response.Value, method,
                              typesList, headerType)))
                    {
                        throw new InvalidOperationException(
                            string.Format(CultureInfo.InvariantCulture,
                            Resources.UnsupportedMimeTypeForResponseBody,
                            methodName,
                            response.Key));
                    }
                }
            }

            return typesList;
        }

        private Response BuildMethodReturnType(List<Stack<IType>> types, IType headerType)
        {
            IType baseType = new PrimaryType(KnownPrimaryType.Object);
            // Return null if no response is specified
            if (types.Count == 0)
            {
                return new Response(null, headerType);
            }
            // Return first if only one return type
            if (types.Count == 1)
            {
                return new Response(types.First().Pop(), headerType);
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
                        return new Response(baseType, headerType);
                    }
                }
                baseType = currentType;
            }

            return new Response(baseType, headerType);
        }

        private bool TryBuildStreamResponse(HttpStatusCode responseStatusCode, OperationResponse response,
            Method method, List<Stack<IType>> types, IType headerType)
        {
            bool handled = false;
            if (SwaggerOperationProducesNotEmpty())
            {
                if (response.Schema != null)
                {
                    IType serviceType = response.Schema.GetBuilder(_swaggerModeler)
                        .BuildServiceType(response.Schema.Reference.StripDefinitionPath());

                    Debug.Assert(serviceType != null);

                    BuildMethodReturnTypeStack(serviceType, types);

                    var compositeType = serviceType as CompositeType;
                    if (compositeType != null)
                    {
                        VerifyFirstPropertyIsByteArray(compositeType);
                    }
                    method.Responses[responseStatusCode] = new Response(serviceType, headerType);
                    handled = true;
                }
            }
            return handled;
        }

        private void VerifyFirstPropertyIsByteArray(CompositeType serviceType)
        {
            var referenceKey = serviceType.Name;
            var responseType = _swaggerModeler.GeneratedTypes[referenceKey];
            var property = responseType.Properties.FirstOrDefault(p => p.Type is PrimaryType && ((PrimaryType)p.Type).Type == KnownPrimaryType.ByteArray);
            if (property == null)
            {
                throw new KeyNotFoundException(
                    "Please specify a field with type of System.Byte[] to deserialize the file contents to");
            }
        }

        private bool TryBuildResponse(string methodName, HttpStatusCode responseStatusCode,
            OperationResponse response, Method method, List<Stack<IType>> types, IType headerType)
        {
            bool handled = false;
            IType serviceType;
            if (SwaggerOperationProducesJson())
            {
                if (TryBuildResponseBody(methodName, response,
                    s => GenerateResponseObjectName(s, responseStatusCode), out serviceType))
                {
                    method.Responses[responseStatusCode] = new Response(serviceType, headerType);
                    BuildMethodReturnTypeStack(serviceType, types);
                    handled = true;
                }
            }

            return handled;
        }

        private bool TryBuildEmptyResponse(string methodName, HttpStatusCode responseStatusCode,
            OperationResponse response, Method method, List<Stack<IType>> types, IType headerType)
        {
            bool handled = false;

            if (response.Schema == null)
            {
                method.Responses[responseStatusCode] = new Response(null, headerType);
                handled = true;
            }
            else
            {
                if (_operation.Produces.IsNullOrEmpty())
                {
                    method.Responses[responseStatusCode] = new Response(new PrimaryType(KnownPrimaryType.Object), headerType);
                    BuildMethodReturnTypeStack(new PrimaryType(KnownPrimaryType.Object), types);
                    handled = true;
                }

                var unwrapedSchemaProperties =
                    _swaggerModeler.Resolver.Unwrap(response.Schema).Properties;
                if (unwrapedSchemaProperties != null && unwrapedSchemaProperties.Any())
                {
                    Logger.LogWarning(Resources.NoProduceOperationWithBody,
                        methodName);
                }
            }

            return handled;
        }

        private void TryBuildDefaultResponse(string methodName, OperationResponse response, Method method, IType headerType)
        {
            IType errorModel = null;
            if (SwaggerOperationProducesJson())
            {
                if (TryBuildResponseBody(methodName, response, s => GenerateErrorModelName(s), out errorModel))
                {
                    method.DefaultResponse = new Response(errorModel, headerType);
                }
            }
        }

        private bool TryBuildResponseBody(string methodName, OperationResponse response,
            Func<string, string> typeNamer, out IType responseType)
        {
            bool handled = false;
            responseType = null;
            if (SwaggerOperationProducesJson())
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

        private bool SwaggerOperationProducesJson()
        {
            return _effectiveProduces != null &&
                   _effectiveProduces.Any(s => s.StartsWith(APP_JSON_MIME, StringComparison.OrdinalIgnoreCase));
        }

        private bool SwaggerOperationProducesNotEmpty()
        {
            return _effectiveProduces != null
                && _effectiveProduces.Any();
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
