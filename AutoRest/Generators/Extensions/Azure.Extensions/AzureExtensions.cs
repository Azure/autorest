// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.Azure.Model;
using Microsoft.Rest.Generator.Azure.Properties;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Microsoft.Rest.Generator.Azure
{
    /// <summary>
    /// Base code generator for Azure.
    /// Normalizes the ServiceClient according to Azure conventions and Swagger extensions.
    /// </summary>
    public abstract class AzureExtensions : Extensions
    {
        public const string LongRunningExtension = "x-ms-long-running-operation";
        public const string PageableExtension = "x-ms-pageable";
        public const string AzureResourceExtension = "x-ms-azure-resource";
        public const string ODataExtension = "x-ms-odata";
        public const string ClientRequestIdExtension = "x-ms-client-request-id";
        public const string ExternalExtension = "x-ms-external";

        //TODO: Ideally this would be the same extension as the ClientRequestIdExtension and have it specified on the response headers,
        //TODO: But the response headers aren't currently used at all so we put an extension on the operation for now
        public const string RequestIdExtension = "x-ms-request-id";
        public const string ApiVersion = "api-version";
        public const string AcceptLanguage = "accept-language";
        
        private const string ResourceType = "Resource";
        private const string SubResourceType = "SubResource";
        private const string ResourceProperties = "Properties";

        /// <summary>
        /// Defines the possible set of valid HTTP status codes for HEAD requests.
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2104:DoNotDeclareReadOnlyMutableReferenceTypes")]
        public static readonly Func<HttpStatusCode, bool> HttpHeadStatusCodeSuccessFunc = code => (int)code >= 200 && (int)code < 300;

        private static IEnumerable<string> ResourcePropertyNames =  
            new List<string>
            { 
                "Id",
                "Name",
                "Type",
                "Location",
                "Tags"
            }.OrderBy(s=> s);

        /// <summary>
        /// Normalizes client model using Azure-specific extensions.
        /// </summary>
        /// <param name="serviceClient">Service client</param>
        /// <param name="settings">AutoRest settings</param>
        /// <param name="codeNamer">AutoRest settings</param>
        /// <returns></returns>
        public static void NormalizeAzureClientModel(ServiceClient serviceClient, Settings settings, CodeNamer codeNamer)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }
            if (settings == null)
            {
                throw new ArgumentNullException("settings");
            }
            if (codeNamer == null)
            {
                throw new ArgumentNullException("codeNamer");
            }

            settings.AddCredentials = true;
            UpdateHeadMethods(serviceClient);
            ParseODataExtension(serviceClient);
            FlattenResourceProperties(serviceClient);
            FlattenRequestPayload(serviceClient, settings);
            AddLongRunningOperations(serviceClient);
            AddAzureProperties(serviceClient);
            SetDefaultResponses(serviceClient);
            AddPageableMethod(serviceClient, codeNamer);
            AddParameterGroups(serviceClient); //This should come after all methods have been dynamically added
        }

        /// <summary>
        /// Changes head method return type.
        /// </summary>
        /// <param name="serviceClient">Service client</param>
        public static void UpdateHeadMethods(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            foreach (var method in serviceClient.Methods.Where(m => m.HttpMethod == HttpMethod.Head)
                                                              .Where(m => m.ReturnType.Body == null))
            {
                HttpStatusCode successStatusCode = method.Responses.Keys.FirstOrDefault(AzureExtensions.HttpHeadStatusCodeSuccessFunc);

                if (method.Responses.Count == 2 &&
                    successStatusCode != default(HttpStatusCode) &&
                    method.Responses.ContainsKey(HttpStatusCode.NotFound))
                {
                    method.ReturnType = new Response(PrimaryType.Boolean, method.ReturnType.Headers);
                }
                else
                {
                    Logger.LogWarning(string.Format(CultureInfo.InvariantCulture, Resources.HeadMethodPossibleIncorrectSpecification, method.Name));
                }
            }
        }

        /// <summary>
        /// Set default response to CloudError if not defined explicitly.
        /// </summary>
        /// <param name="serviceClient"></param>
        public static void SetDefaultResponses(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            // Create CloudError if not already defined
            CompositeType cloudError = serviceClient.ModelTypes.FirstOrDefault(c =>
                c.Name.Equals("cloudError", StringComparison.OrdinalIgnoreCase));
            if (cloudError == null)
            {
                cloudError = new CompositeType
                {
                    Name = "cloudError",
                    SerializedName = "cloudError"
                };
                cloudError.Extensions[ExternalExtension] = true;
                serviceClient.ModelTypes.Add(cloudError);
            }
            // Set default response if not defined explicitly
            foreach (var method in serviceClient.Methods)
            {
                if (method.DefaultResponse.Body == null && method.ReturnType.Body != null)
                {
                    method.DefaultResponse = new Response(cloudError, method.ReturnType.Headers);
                }                
            }
        }

        /// <summary>
        /// Converts Azure Parameters to regular parameters.
        /// </summary>
        /// <param name="serviceClient">Service client</param>
        public static void ParseODataExtension(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            foreach (var method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(ODataExtension)))
            {
                string odataModelPath = (string) method.Extensions[ODataExtension];
                if (odataModelPath == null)
                {
                    throw new InvalidOperationException(
                        string.Format(CultureInfo.InvariantCulture, 
                        Resources.ODataEmpty, ODataExtension));
                }

                odataModelPath = odataModelPath.StripDefinitionPath();

                CompositeType odataType = serviceClient.ModelTypes
                    .FirstOrDefault(t => t.Name.Equals(odataModelPath, StringComparison.OrdinalIgnoreCase));

                if (odataType == null)
                {
                    throw new InvalidOperationException(
                        string.Format(CultureInfo.InvariantCulture, 
                        Resources.ODataInvalidReferance, ODataExtension));
                }
                var filterParameter = method.Parameters
                    .FirstOrDefault(p => p.Location == ParameterLocation.Query &&
                                         p.Name == "$filter");
                if (filterParameter == null)
                {
                    throw new InvalidOperationException(
                        string.Format(CultureInfo.InvariantCulture, 
                        Resources.ODataFilterMissing, ODataExtension));
                }

                filterParameter.Type = odataType;
            }
        }

        /// <summary>
        /// Creates long running operation methods.
        /// </summary>
        /// <param name="serviceClient"></param>
        public static void AddLongRunningOperations(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            for (int i = 0; i < serviceClient.Methods.Count; i++)
            {
                var method = serviceClient.Methods[i];
                if (method.Extensions.ContainsKey(LongRunningExtension))
                {
                    var isLongRunning = method.Extensions[LongRunningExtension];
                    if (isLongRunning is bool && (bool)isLongRunning)
                    {
                        serviceClient.Methods.Insert(i, (Method) method.Clone());
                        method.Name = "Begin" + method.Name.ToPascalCase(); 
                        i++;
                   }
                   
                   method.Extensions.Remove(LongRunningExtension);
                }
            }
        }

        /// <summary>
        /// Creates azure specific properties.
        /// </summary>
        /// <param name="serviceClient"></param>
        public static void AddAzureProperties(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            var apiVersion = serviceClient.Properties
                .FirstOrDefault(p => ApiVersion.Equals(p.SerializedName, StringComparison.OrdinalIgnoreCase));
            if (apiVersion != null)
            {
                apiVersion.DefaultValue = "\"" + serviceClient.ApiVersion + "\"";
                apiVersion.IsReadOnly = true;
                apiVersion.IsRequired = false;
            }

            var subscriptionId =
                serviceClient.Properties.FirstOrDefault(
                    p => string.Equals(p.Name, "subscriptionId", StringComparison.OrdinalIgnoreCase));
            if (subscriptionId != null)
            {
                subscriptionId.IsRequired = true;
            }

            var acceptLanguage = serviceClient.Properties
                .FirstOrDefault(p => AcceptLanguage.Equals(p.SerializedName, StringComparison.OrdinalIgnoreCase));
            if (acceptLanguage == null)
            {
                acceptLanguage = new Property
                {
                    Name = AcceptLanguage,
                    Documentation = "Gets or sets the preferred language for the response.",
                    SerializedName = AcceptLanguage,
                    DefaultValue = "\"en-US\""
                };
                serviceClient.Properties.Add(acceptLanguage);
            }
            acceptLanguage.IsReadOnly = false;
            acceptLanguage.IsRequired = false;
            acceptLanguage.Type = PrimaryType.String;
            serviceClient.Methods
                .Where(m => !m.Parameters.Any(p => AcceptLanguage.Equals(p.SerializedName, StringComparison.OrdinalIgnoreCase)))
                .ForEach(m2 => m2.Parameters.Add(new Parameter
                    {
                        ClientProperty = acceptLanguage,
                        Location = ParameterLocation.Header
                    }.LoadFrom(acceptLanguage)));

            serviceClient.Properties.Insert(0, new Property
            {
                Name = "Credentials",
                SerializedName = "credentials",
                Type = PrimaryType.Credentials,
                IsRequired = true,
                IsReadOnly = true,
                Documentation = "Gets Azure subscription credentials."
            });

            serviceClient.Properties.Add(new Property
            {
                Name = "LongRunningOperationRetryTimeout",
                SerializedName = "longRunningOperationRetryTimeout",
                Type = PrimaryType.Int,
                Documentation = "Gets or sets the retry timeout in seconds for Long Running Operations. Default value is 30.",
                DefaultValue = "30"
            });

            serviceClient.Properties.Add(new Property
            {
                Name = "GenerateClientRequestId",
                SerializedName = "generateClientRequestId",
                Type = PrimaryType.Boolean,
                Documentation = "When set to true a unique x-ms-client-request-id value is generated and included in each request. Default is true.",
                DefaultValue = "true"
            });
        }

        /// <summary>
        /// Flattens the Resource Properties.
        /// </summary>
        /// <param name="serviceClient"></param>
        public static void FlattenResourceProperties(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            HashSet<string> typesToDelete = new HashSet<string>();
            foreach (var compositeType in serviceClient.ModelTypes.ToArray())
            {
                if (IsAzureResource(compositeType))
                {
                    CheckAzureResourceProperties(compositeType);
                    
                    // First find "properties" property
                    var propertiesProperty = compositeType.ComposedProperties.FirstOrDefault(
                        p => p.Name.Equals(ResourceProperties, StringComparison.OrdinalIgnoreCase));

                    // Sub resource does not need to have properties
                    if (propertiesProperty != null)
                    {
                        var propertiesModel = propertiesProperty.Type as CompositeType;
                        // Recursively parsing the "properties" object hierarchy  
                        while (propertiesModel != null)
                        {
                            foreach (Property originalProperty in propertiesModel.Properties)
                            {
                                var pp = (Property) originalProperty.Clone();
                                if (
                                    ResourcePropertyNames.Any(
                                        rp => rp.Equals(pp.Name, StringComparison.OrdinalIgnoreCase)))
                                {
                                    pp.Name = compositeType.Name + CodeNamer.PascalCase(pp.Name);
                                }
                                pp.SerializedName = "properties." + pp.SerializedName;
                                compositeType.Properties.Add(pp);
                            }

                            compositeType.Properties.Remove(propertiesProperty);
                            if (!typesToDelete.Contains(propertiesModel.Name))
                            {
                                typesToDelete.Add(propertiesModel.Name);
                            }
                            propertiesModel = propertiesModel.BaseModelType;
                        }
                    }
                }
            }

            AzureExtensions.RemoveUnreferencedTypes(serviceClient, typesToDelete);
        }

        /// <summary>
        /// Cleans all model types that are not used
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="typeNames"></param>
        public static void RemoveUnreferencedTypes(ServiceClient serviceClient, IEnumerable<string> typeNames)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            if (typeNames == null)
            {
                throw new ArgumentNullException("typeNames");
            }

            foreach (var typeName in typeNames)
            {
                var typeToDelete = serviceClient.ModelTypes.First(t => t.Name == typeName);

                var isUsedInResponses = serviceClient.Methods.Any(m => m.Responses.Any(r => r.Value.Body == typeToDelete));
                var isUsedInParameters = serviceClient.Methods.Any(m => m.Parameters.Any(p => p.Type == typeToDelete));
                var isBaseType = serviceClient.ModelTypes.Any(t => t.BaseModelType == typeToDelete);
                var isUsedInProperties = serviceClient.ModelTypes.Any(t => t.Properties
                                            .Any(p => p.Type == typeToDelete && 
                                                 !"properties".Equals(p.SerializedName, StringComparison.OrdinalIgnoreCase)));
                if (!isUsedInResponses &&
                    !isUsedInParameters &&
                    !isBaseType &&
                    !isUsedInProperties)
                {
                    serviceClient.ModelTypes.Remove(typeToDelete);
                }
            }
        }

        /// <summary>
        /// Determines a composite type as an External Resource if it's name equals "Resource" 
        /// and it has an extension named "x-ms-azure-resource" marked as true.
        /// </summary>
        /// <param name="compositeType">Type to determine if it is an external resource</param>
        /// <returns>True if it is an external resource, false otherwise</returns>
        public static bool IsAzureResource(CompositeType compositeType)
        {
            if (compositeType == null)
            {
                return false;
            }

            if (compositeType.ComposedExtensions.ContainsKey(AzureResourceExtension))
            {
                var external = compositeType.ComposedExtensions[AzureResourceExtension] as bool?;
                return (external == null || external.Value);
            }

            return false;
        }

        /// <summary>
        /// Adds ListNext() method for each List method with x-ms-pageable extension.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="codeNamer"></param>
        public static void AddPageableMethod(ServiceClient serviceClient, CodeNamer codeNamer)
        {
            if (codeNamer == null)
            {
                throw new ArgumentNullException("codeNamer");
            }
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            foreach (var method in serviceClient.Methods.ToArray())
            {
                if (method.Extensions.ContainsKey(PageableExtension))
                {
                    var pageableExtension = JsonConvert.DeserializeObject<PageableExtension>(method.Extensions[PageableExtension].ToString());
                    if (string.IsNullOrWhiteSpace(pageableExtension.NextLinkName))
                    {
                        continue;
                    }

                    Method nextLinkMethod = null;
                    if (!string.IsNullOrEmpty(pageableExtension.OperationName))
                    {
                        nextLinkMethod = serviceClient.Methods.FirstOrDefault(m =>
                            pageableExtension.OperationName.Equals(m.SerializedName, StringComparison.OrdinalIgnoreCase));
                    }

                    if (nextLinkMethod == null)
                    {
                        nextLinkMethod = (Method)method.Clone();

                        if (!string.IsNullOrEmpty(pageableExtension.OperationName))
                        {
                            nextLinkMethod.Name = codeNamer.GetMethodName(SwaggerModeler.GetMethodName(
                                new Rest.Modeler.Swagger.Model.Operation { OperationId = pageableExtension.OperationName }));
                            nextLinkMethod.Group = codeNamer.GetMethodGroupName(SwaggerModeler.GetMethodGroup(
                                new Rest.Modeler.Swagger.Model.Operation { OperationId = pageableExtension.OperationName }));
                        }
                        else
                        {
                            nextLinkMethod.Name = nextLinkMethod.Name + "Next";
                        }
                        nextLinkMethod.Parameters.Clear();
                        nextLinkMethod.Url = "{nextLink}";
                        nextLinkMethod.IsAbsoluteUrl = true;
                        var nextLinkParameter = new Parameter
                        {
                            Name = "nextPageLink",
                            SerializedName = "nextLink",
                            Type = PrimaryType.String,
                            Documentation = "The NextLink from the previous successful call to List operation.",
                            IsRequired = true,
                            Location = ParameterLocation.Path
                        };
                        nextLinkParameter.Extensions[SkipUrlEncodingExtension] = true;
                        nextLinkMethod.Parameters.Add(nextLinkParameter);

                        // Need copy all the header parameters from List method to ListNext method
                        foreach (var param in method.Parameters.Where(p => p.Location == ParameterLocation.Header))
                        {
                            nextLinkMethod.Parameters.Add((Parameter)param.Clone());
                        }

                        // Copy all grouped parameters that only contain header parameters
                        nextLinkMethod.InputParameterTransformation.Clear();
                        method.InputParameterTransformation.GroupBy(t => t.ParameterMappings[0].InputParameter)
                            .ForEach(grouping => {
                                if (grouping.All(t => t.OutputParameter.Location == ParameterLocation.Header))
                                {
                                    // All grouped properties were header parameters, reuse data type
                                    nextLinkMethod.Parameters.Add(grouping.Key);
                                    grouping.ForEach(t => nextLinkMethod.InputParameterTransformation.Add(t));
                                }
                                else if (grouping.Any(t => t.OutputParameter.Location == ParameterLocation.Header))
                                {
                                    // Some grouped properties were header parameters, creating new data types
                                    var headerGrouping = grouping.Where(t => t.OutputParameter.Location == ParameterLocation.Header);
                                    headerGrouping.ForEach(t => nextLinkMethod.InputParameterTransformation.Add(t));
                                    var newGroupingParam = CreateParameterFromGrouping(headerGrouping, nextLinkMethod, serviceClient);
                                    nextLinkMethod.Parameters.Add(newGroupingParam);
                                    grouping.Key.Name = newGroupingParam.Name;
                                }
                            });

                        serviceClient.Methods.Add(nextLinkMethod);
                    }
                }
            }
        }

        private static Parameter CreateParameterFromGrouping(IEnumerable<ParameterTransformation> grouping, Method method, ServiceClient serviceClient)
        {
            var properties = new List<Property>();
            string parameterGroupName = null;
            foreach (var parameter in grouping.Select(g => g.OutputParameter))
            {
                Newtonsoft.Json.Linq.JContainer extensionObject = parameter.Extensions[ParameterGroupExtension] as Newtonsoft.Json.Linq.JContainer;
                string specifiedGroupName = extensionObject.Value<string>("name");
                if (specifiedGroupName == null)
                {
                    string postfix = extensionObject.Value<string>("postfix") ?? "Parameters";
                    parameterGroupName = method.Group + "-" + method.Name + "-" + postfix;
                }
                else
                {
                    parameterGroupName = specifiedGroupName;
                }

                Property groupProperty = new Property()
                {
                    IsReadOnly = false, //Since these properties are used as parameters they are never read only
                    Name = parameter.Name,
                    IsRequired = parameter.IsRequired,
                    DefaultValue = parameter.DefaultValue,
                    //Constraints = parameter.Constraints, Omit these since we don't want to perform parameter validation
                    Documentation = parameter.Documentation,
                    Type = parameter.Type,
                    SerializedName = null //Parameter is never serialized directly
                };
                properties.Add(groupProperty);
            }
            
            var parameterGroupType = new CompositeType()
            {
                Name = parameterGroupName,
                Documentation = "Additional parameters for the " + method.Name + " operation."
            };

            //Add to the service client
            serviceClient.ModelTypes.Add(parameterGroupType);

            foreach (Property property in properties)
            {
                parameterGroupType.Properties.Add(property);
            }

            bool isGroupParameterRequired = parameterGroupType.Properties.Any(p => p.IsRequired);

            //Create the new parameter object based on the parameter group type
            return new Parameter()
            {
                Name = parameterGroupName,
                IsRequired = isGroupParameterRequired,
                Location = ParameterLocation.None,
                SerializedName = string.Empty,
                Type = parameterGroupType,
                Documentation = "Additional parameters for the operation"
            };
        }
        
        public static string GetClientRequestIdString(Method method)
        {
            if (method == null)
            {
                throw new ArgumentNullException("method");
            }
            
            string clientRequestIdName = "x-ms-client-request-id";
            foreach (Parameter parameter in method.Parameters)
            {
                if (parameter.Extensions.ContainsKey(ClientRequestIdExtension))
                {
                    bool? extensionObject = parameter.Extensions[ClientRequestIdExtension] as bool?;
                    if (extensionObject != null)
                    {
                        bool useParamAsClientRequestId = extensionObject.Value;
                        if (useParamAsClientRequestId)
                        {
                            //TODO: Need to do something if they specify two ClientRequestIdExtensions for the same method...?
                            clientRequestIdName = parameter.SerializedName;
                            break;
                        }
                    }
                }
            }
            
            return clientRequestIdName;
        }

        public static string GetRequestIdString(Method method)
        {
            if (method == null)
            {
                throw new ArgumentNullException("method");
            }

            string requestIdName = "x-ms-request-id";
            if (method.Extensions.ContainsKey(RequestIdExtension))
            {
                string extensionObject = method.Extensions[RequestIdExtension] as string;
                if (extensionObject != null)
                {
                    requestIdName = extensionObject;
                }
            }
            
            return requestIdName;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase")]
        private static void CheckAzureResourceProperties(CompositeType compositeType)
        {
            // If derived from resource with x-ms-azure-resource then resource should have resource specific properties
            var missingResourceProperties = ResourcePropertyNames.Select(p => p.ToLowerInvariant())
                                               .Except(compositeType.ComposedProperties.Select(n => n.Name.ToLowerInvariant()));

            if (missingResourceProperties.Count() != 0)
            {
                Logger.LogWarning(Resources.ResourcePropertyMismatch,
                    string.Join(", ", missingResourceProperties));
            }
        }
    }
}