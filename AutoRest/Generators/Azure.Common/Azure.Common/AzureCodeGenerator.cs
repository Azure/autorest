// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.Azure.Properties;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger;

namespace Microsoft.Rest.Generator.Azure
{
    /// <summary>
    /// Base code generator for Azure.
    /// Normalizes the ServiceClient according to Azure conventions and Swagger extensions.
    /// </summary>
    public abstract class AzureCodeGenerator : CodeGenerator
    {
        public const string LongRunningExtension = "x-ms-long-running-operation";
        public const string PageableExtension = "x-ms-pageable";
        public const string ExternalExtension = "x-ms-external";
        public const string AzureResourceExtension = "x-ms-azure-resource";
        public const string ODataExtension = "x-ms-odata";
        public const string ClientRequestIdExtension = "x-ms-client-request-id";
        
        //TODO: Ideally this would be the same extension as the ClientRequestIdExtension and have it specified on the response headers,
        //TODO: But the response headers aren't currently used at all so we put an extension on the operation for now
        public const string RequestIdExtension = "x-ms-request-id";
        public const string ParameterGroupExtension = "x-ms-parameter-grouping";
        public const string ApiVersion = "api-version";
        public const string AcceptLanguage = "accept-language";
        
        private const string ResourceType = "Resource";
        private const string SubResourceType = "SubResource";
        private const string ResourceProperties = "Properties";

        private static IEnumerable<string> ResourcePropertyNames =  
            new List<string>
            { 
                "Id",
                "Name",
                "Type",
                "Location",
                "Tags"
            }.OrderBy(s=> s);

        protected AzureCodeGenerator(Settings settings) : base(settings)
        {
        }

        /// <summary>
        /// Normalizes client model using Azure-specific extensions.
        /// </summary>
        /// <param name="serviceClient">Service client</param>
        /// <returns></returns>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            Settings.AddCredentials = true;
            UpdateHeadMethods(serviceClient);
            ParseODataExtension(serviceClient);
            FlattenResourceProperties(serviceClient);
            AddPageableMethod(serviceClient);
            AddLongRunningOperations(serviceClient);
            AddAzureProperties(serviceClient);
            SetDefaultResponses(serviceClient);
            AddParameterGroups(serviceClient);
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
                                                             .Where(m => m.ReturnType == null))
            {
                if (method.Responses.Count == 2 &&
                    method.Responses.ContainsKey(HttpStatusCode.NoContent) &&
                    method.Responses.ContainsKey(HttpStatusCode.NotFound))
                {
                    if (method.ReturnType != null)
                    {
                        method.ReturnType = new Tuple<IType, IType>(PrimaryType.Boolean, method.ReturnType.Item2);
                    }
                    else
                    {
                        method.ReturnType = new Tuple<IType, IType>(PrimaryType.Boolean, null);
                    }
                }
                else
                {
                    throw new NotSupportedException(
                        string.Format(CultureInfo.InvariantCulture, 
                        Resources.HeadMethodInvalidResponses, method.Name));
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
                if (method.DefaultResponse == null && method.ReturnType != null)
                {
                    method.DefaultResponse = new Tuple<IType, IType>(cloudError, method.ReturnType.Item2);
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
        /// Adds the parameter groups to operation parameters.
        /// </summary>
        /// <param name="serviceClient"></param>
        public static void AddParameterGroups(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            foreach (Method method in serviceClient.Methods)
            {
                //This group name is normalized by each languages code generator later, so it need not happen here.
                Dictionary<string, Dictionary<Property, Parameter>> parameterGroups = new Dictionary<string, Dictionary<Property, Parameter>>();
                
                foreach (Parameter parameter in method.Parameters)
                {
                    if (parameter.Extensions.ContainsKey(ParameterGroupExtension))
                    {
                        Newtonsoft.Json.Linq.JContainer extensionObject = parameter.Extensions[ParameterGroupExtension] as Newtonsoft.Json.Linq.JContainer;
                        if (extensionObject != null)
                        {
                            string parameterGroupName = method.Group + "-" + method.Name + "-" + "Parameters";
                            parameterGroupName = extensionObject.Value<string>("name") ?? parameterGroupName;
                            
                            if (!parameterGroups.ContainsKey(parameterGroupName))
                            {
                                parameterGroups.Add(parameterGroupName, new Dictionary<Property, Parameter>());
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
                            
                            parameterGroups[parameterGroupName].Add(groupProperty, parameter);
                        }
                    }
                }

                foreach (string parameterGroupName in parameterGroups.Keys)
                {
                    //Define the new parameter group type (it's always a composite type)
                    CompositeType parameterGroupType = new CompositeType()
                        {
                            Name = parameterGroupName,
                            Documentation = "Additional parameters for the " + method.Name + " operation."
                        };
                    
                    //Populate the parameter group type with properties.
                    foreach (Property property in parameterGroups[parameterGroupName].Keys)
                    {
                        parameterGroupType.Properties.Add(property);
                    }

                    //Add to the service client
                    serviceClient.ModelTypes.Add(parameterGroupType);

                    bool isGroupParameterRequired = parameterGroupType.Properties.Any(p => p.IsRequired);

                    //Create the new parameter object based on the parameter group type
                    Parameter parameterGroup = new Parameter()
                        {
                            Name = parameterGroupName,
                            IsRequired = isGroupParameterRequired,
                            Location = ParameterLocation.None,
                            SerializedName = string.Empty,
                            Type = parameterGroupType,
                            Documentation = "Additional parameters for the operation"
                        };
                    
                    method.Parameters.Add(parameterGroup);

                    //Link the grouped parameters to their parent, and remove them from the method parameters
                    foreach (Property property in parameterGroups[parameterGroupName].Keys)
                    {
                        Parameter p = parameterGroups[parameterGroupName][property];

                        var parameterTransformation = new ParameterTransformation
                        {
                            OutputParameter = p
                        };
                        parameterTransformation.ParameterMappings.Add(new ParameterMapping
                        {
                            InputParameter = parameterGroup,
                            InputParameterProperty = property.Name
                        });
                        method.InputParameterTransformation.Add(parameterTransformation);
                        method.Parameters.Remove(p);
                    }
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
                Type = new CompositeType
                {
                    Name = "ServiceClientCredentials"
                },
                IsRequired = true,
                IsReadOnly = true,
                Documentation = "The management credentials for Azure."
            });

            serviceClient.Properties.Add(new Property
            {
                Name = "LongRunningOperationRetryTimeout",
                SerializedName = "longRunningOperationRetryTimeout",
                Type = PrimaryType.Int,
                Documentation = "The retry timeout for Long Running Operations."
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
                }

                if (IsDerivedFromAzureResource(compositeType))
                {
                    // First find "properties" property
                    var propertiesProperty = compositeType.Properties.FirstOrDefault(
                        p => p.Name.Equals(ResourceProperties, StringComparison.OrdinalIgnoreCase));
                    if (propertiesProperty == null &&
                        compositeType.BaseModelType.Name.Equals(ResourceType, StringComparison.OrdinalIgnoreCase))
                    {
                        throw new InvalidOperationException(
                            string.Format(CultureInfo.InvariantCulture, 
                            Resources.MissingProperties,
                            compositeType.Name));
                    }

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

            AzureCodeGenerator.RemoveUnreferencedTypes(serviceClient, typesToDelete);
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

                var isUsedInResponses = serviceClient.Methods.Any(m => m.Responses.Any(r => r.Value != null && r.Value.Item2 == typeToDelete));
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

        public static bool IsDerivedFromAzureResource(CompositeType compositeType)
        {
            if (compositeType == null)
            {
                return false;
            }

            if (compositeType.BaseModelType != null &&
                compositeType.BaseModelType.Extensions.ContainsKey(AzureResourceExtension))
            {
                var external = compositeType.BaseModelType.Extensions[AzureResourceExtension] as bool?;
                return (external == null || external.Value);
            }

            return false;
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

            if (compositeType.Extensions.ContainsKey(AzureResourceExtension) &&
                compositeType.Name.Equals(ResourceType, StringComparison.OrdinalIgnoreCase))
            {
                var external = compositeType.Extensions[AzureResourceExtension] as bool?;
                return (external == null || external.Value);
            }

            return false;
        }

        /// <summary>
        /// Adds ListNext() method for each List method with x-ms-pageable extension.
        /// </summary>
        /// <param name="serviceClient"></param>
        public static void AddPageableMethod(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            foreach (var method in serviceClient.Methods.ToArray())
            {
                if (method.Extensions.ContainsKey(PageableExtension))
                {
                    var newMethod = (Method) method.Clone();
                    newMethod.Name = newMethod.Name + "Next";
                    newMethod.Parameters.Clear();
                    newMethod.Url = "{nextLink}";
                    newMethod.IsAbsoluteUrl = true;
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
                    newMethod.Parameters.Add(nextLinkParameter);
                    serviceClient.Methods.Add(newMethod);
                }
            }
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
                    Newtonsoft.Json.Linq.JContainer extensionObject = parameter.Extensions[ClientRequestIdExtension] as Newtonsoft.Json.Linq.JContainer;
                    if (extensionObject != null)
                    {
                        bool useParamAsClientRequestId = (bool)extensionObject["value"];
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
                Newtonsoft.Json.Linq.JContainer extensionObject = method.Extensions[RequestIdExtension] as Newtonsoft.Json.Linq.JContainer;
                if (extensionObject != null)
                {
                    requestIdName = extensionObject["value"].ToString();
                }
            }
            
            return requestIdName;
        }

        private static void CheckAzureResourceProperties(CompositeType compositeType)
        {
            // If derived from resource with x-ms-azure-resource then resource should have resource properties 
            // that are in client-runtime, except provisioning state
            var extraResourceProperties = compositeType.Properties
                                                       .Select(p => p.Name.ToUpperInvariant())
                                                       .OrderBy(n => n)
                                                       .Except(ResourcePropertyNames.Select(n => n.ToUpperInvariant()));

            if (compositeType.Properties.Count() != ResourcePropertyNames.Count() ||
               extraResourceProperties.Count() != 0)
            {
                throw new InvalidOperationException(
                    string.Format(CultureInfo.InvariantCulture,
                    Resources.ResourcePropertyMismatch,
                    string.Join(", ", ResourcePropertyNames)));
            }
        }
    }
}