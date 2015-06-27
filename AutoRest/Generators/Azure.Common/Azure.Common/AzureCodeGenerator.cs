// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.Azure.Properties;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger;
using System.Globalization;

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
        public const string ODataExtension = "x-ms-odata";
        public const string GlobalParameter = "x-ms-global-parameter";

        private const string ResourceType = "Resource";
        private const string SubResourceType = "SubResource";
        private const string ResourceProperties = "Properties";
        private const string ProvisioningState = "ProvisioningState";

        private static IEnumerable<string> ResourcePropertyNames;

        protected AzureCodeGenerator(Settings settings) : base(settings)
        {
            ResourcePropertyNames = new List<string>
                                        { 
                                            "Id",
                                            "Name",
                                            "Type",
                                            "Location",
                                            "Tags"
                                        }.OrderBy(s=> s);
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
            RemoveCommonPropertiesFromMethods(serviceClient);
            AddLongRunningOperations(serviceClient);
            AddAzureProperties(serviceClient);
            SetDefaultResponses(serviceClient);
        }

        /// <summary>
        /// Changes head method return type.
        /// </summary>
        /// <param name="serviceClient">Service client</param>
        private static void UpdateHeadMethods(ServiceClient serviceClient)
        {
            foreach (var method in serviceClient.Methods.Where(m => m.HttpMethod == HttpMethod.Head)
                                                             .Where(m => m.ReturnType == null))
            {
                if (method.Responses.Count == 2 &&
                    method.Responses.ContainsKey(HttpStatusCode.NoContent) &&
                    method.Responses.ContainsKey(HttpStatusCode.NotFound))
                {
                    method.ReturnType = PrimaryType.Boolean;
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
        internal static void SetDefaultResponses(ServiceClient serviceClient)
        {
            // Create CloudError if not already defined
            CompositeType cloudError = serviceClient.ModelTypes.FirstOrDefault(c =>
                c.Name.Equals("cloudError", StringComparison.OrdinalIgnoreCase));
            if (cloudError == null)
            {
                cloudError = new CompositeType
                {
                    Name = "cloudError"
                };
                cloudError.Extensions[ExternalExtension] = true;
                serviceClient.ModelTypes.Add(cloudError);
            }
            // Set default response if not defined explicitly
            foreach (var method in serviceClient.Methods)
            {
                if (method.DefaultResponse == null && method.ReturnType != null)
                {
                    method.DefaultResponse = cloudError;
                }
            }
        }

        /// <summary>
        /// Removes common properties including subscriptionId and apiVersion from method signatures.
        /// </summary>
        /// <param name="serviceClient"></param>
        internal static void RemoveCommonPropertiesFromMethods(ServiceClient serviceClient)
        {
            foreach (var method in serviceClient.Methods)
            {
                method.Parameters.RemoveAll(
                    p => (!p.Extensions.ContainsKey(GlobalParameter) ||
                         (bool)p.Extensions[GlobalParameter]) 
                         &&
                        ((p.Location == ParameterLocation.Path &&
                         p.Name.Equals("subscriptionId", StringComparison.OrdinalIgnoreCase)) ||
                        (p.Location == ParameterLocation.Query &&
                         p.Name.Replace("-", "").Equals("apiversion", StringComparison.OrdinalIgnoreCase))));
            }
        }

        /// <summary>
        /// Converts Azure Parameters to regular parameters.
        /// </summary>
        /// <param name="serviceClient">Service client</param>
        internal static void ParseODataExtension(ServiceClient serviceClient)
        {
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
        internal static void AddLongRunningOperations(ServiceClient serviceClient)
        {
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
        internal static void AddAzureProperties(ServiceClient serviceClient)
        {
            serviceClient.Properties.Add(new Property
            {
                Name = "ApiVersion",
                SerializedName = "api-version",
                Type = PrimaryType.String,
                Documentation = "The Api Version.",
                IsReadOnly = true,
                DefaultValue = "\"" + serviceClient.ApiVersion + "\""
            });
            serviceClient.Properties.Add(new Property
            {
                Name = "Credentials",
                Type = new CompositeType
                {
                    Name = "SubscriptionCloudCredentials"
                },
                IsRequired = true,
                Documentation = "Subscription credentials which uniquely identify Microsoft Azure subscription."
            });
            serviceClient.Properties.Add(new Property
            {
                Name = "LongRunningOperationRetryTimeout",
                Type = PrimaryType.Int,
                Documentation = "The retry timeout for Long Running Operations."
            });
        }

        /// <summary>
        /// Flattens the Resource Properties.
        /// </summary>
        /// <param name="serviceClient"></param>
        internal static void FlattenResourceProperties(ServiceClient serviceClient)
        {
            HashSet<string> typesToDelete = new HashSet<string>();
            foreach (var compositeType in serviceClient.ModelTypes.ToArray())
            {
                if (compositeType.Extensions.ContainsKey(ExternalExtension) && 
                    compositeType.Name.Equals(ResourceType))
                {
                    CheckExternalResourceProperties(compositeType);
                }

                if (compositeType.BaseModelType != null &&
                        (compositeType.BaseModelType.Name.Equals(ResourceType, StringComparison.OrdinalIgnoreCase) ||
                         compositeType.BaseModelType.Name.Equals(SubResourceType, StringComparison.OrdinalIgnoreCase)) &&
                    compositeType.BaseModelType.Extensions.ContainsKey(ExternalExtension))
                {
                    // First find "properties" property
                    var propertiesProperty = compositeType.Properties.FirstOrDefault(
                        p => p.Name.Equals(ResourceProperties, StringComparison.OrdinalIgnoreCase));
                    if (propertiesProperty == null)
                    {
                        throw new InvalidOperationException(
                            string.Format(CultureInfo.InvariantCulture, 
                            Resources.MissingProperties,
                            compositeType.Name));
                    }
                    var propertiesModel = propertiesProperty.Type as CompositeType;
                    // Recursively parsing the "properties" object hierarchy  
                    while (propertiesModel != null)
                    {
                        // Adding "properties" properties to the compositeType
                        propertiesModel.Properties.ForEach(p => compositeType.Properties.Add(p));
                        compositeType.Properties.Remove(propertiesProperty);
                        if (!typesToDelete.Contains(propertiesModel.Name))
                        {
                            typesToDelete.Add(propertiesModel.Name);
                        }
                        propertiesModel = propertiesModel.BaseModelType;
                    }

                    // If provisioning-state exist in type that is derived from resources - remove it
                    foreach(var propertyToRemove in compositeType.Properties
                        .Where(p => p.Name
                                    .Equals(
                                        ProvisioningState, 
                                        StringComparison.OrdinalIgnoreCase))
                        .ToArray())
                    {
                        compositeType.Properties.Remove(propertyToRemove);
                    }
                }
            }

            foreach (var typeName in typesToDelete)
            {
                serviceClient.ModelTypes.Remove(serviceClient.ModelTypes.First(t => t.Name == typeName));
            }
        }

        private static void CheckExternalResourceProperties(CompositeType compositeType)
        {
            // If derived from resource with x-ms-external then resource should have resource properties 
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

        /// <summary>
        /// Adds ListNext() method for each List method with x-ms-pageable extension.
        /// </summary>
        /// <param name="serviceClient"></param>
        internal static void AddPageableMethod(ServiceClient serviceClient)
        {
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
                        Name = "nextLink",
                        Type = PrimaryType.String,
                        Documentation = "NextLink from the previous successful call to List operation.",
                        IsRequired = true,
                        Location = ParameterLocation.Path
                    };
                    nextLinkParameter.Extensions[SkipUrlEncodingExtension] = true;
                    newMethod.Parameters.Add(nextLinkParameter);
                    serviceClient.Methods.Add(newMethod);
                }
            }
        }
    }
}