// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public class ResourceSchema
    {
        private const string resourceMethodPrefix = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/";

        public string Id { get; set; }

        public string Title { get; set; }

        public string Description { get; set; }

        public IEnumerable<Resource> Resources { get; set; }

        public IDictionary<string,Definition> Definitions { get; set; }

        public static ResourceSchema Parse(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            // Get the list of methods that interact with resources
            List<Method> resourceMethods = new List<Method>();
            foreach (Method method in serviceClient.Methods)
            {
                if (method.Url.StartsWith(resourceMethodPrefix, StringComparison.Ordinal))
                {
                    resourceMethods.Add(method);
                }
            }

            // Get the list of methods that create resources
            List<Method> createResourceMethods = new List<Method>();
            foreach (Method resourceMethod in resourceMethods)
            {
                // Azure "create resource" methods are always PUTs.
                if (resourceMethod.HttpMethod == HttpMethod.Put &&
                    resourceMethod.Body != null &&
                    ReturnsResource(resourceMethod))
                {
                    createResourceMethods.Add(resourceMethod);
                }
            }

            // Get the swagger document's api version
            string apiVersion = serviceClient.ApiVersion;

            // Get the swagger document's resources
            string resourceProvider = null;
            List<Resource> resources = new List<Resource>();
            Dictionary<string, Definition> definitionMap = new Dictionary<string, Definition>();
            foreach (Method createResourceMethod in createResourceMethods)
            {
                Resource resource = new Resource();

                resource.AddApiVersion(serviceClient.ApiVersion);

                resource.AddRequiredPropertyName("type");
                resource.AddRequiredPropertyName("apiVersion");
                resource.AddRequiredPropertyName("properties");

                // Get resource provider (only the first resource provider found will be used)
                string afterPrefix = createResourceMethod.Url.Substring(resourceMethodPrefix.Length);
                int forwardSlashIndexAfterProvider = afterPrefix.IndexOf('/');
                string resourceMethodProvider = afterPrefix.Substring(0, forwardSlashIndexAfterProvider);
                Debug.Assert(resourceProvider == null || resourceProvider == resourceMethodProvider);
                resourceProvider = resourceMethodProvider;

                // Get resource's name
                int resourceNameStartIndex = forwardSlashIndexAfterProvider + 1;
                int forwardSlashIndexAfterResourceName = afterPrefix.IndexOf('/', resourceNameStartIndex);
                if (forwardSlashIndexAfterResourceName == -1)
                {
                    resource.Name = afterPrefix.Substring(resourceNameStartIndex);
                }
                else
                {
                    resource.Name = afterPrefix.Substring(resourceNameStartIndex, forwardSlashIndexAfterResourceName - resourceNameStartIndex);
                }

                // Get the resource's full type <provider-name>/<type-name>
                if (forwardSlashIndexAfterResourceName == -1)
                {
                    resource.ResourceType = afterPrefix;
                }
                else
                {
                    resource.ResourceType = afterPrefix.Substring(0, forwardSlashIndexAfterResourceName);
                }
                resource.Description = resource.ResourceType;

                // Get the resource's properties
                CompositeType body = createResourceMethod.Body.Type as CompositeType;
                Debug.Assert(body != null);
                if (body != null)
                {
                    foreach (Property property in body.Properties)
                    {
                        if (!property.IsReadOnly)
                        {
                            SchemaProperty resourceProperty = ParseProperty(property, definitionMap);
                            resource.AddProperty(resourceProperty, property.IsRequired);
                        }
                    }
                }

                resources.Add(resource);
            }

            resources.Sort((lhs, rhs) => lhs.Name.CompareTo(rhs.Name));

            ResourceSchema result = new ResourceSchema()
            {
                Title = resourceProvider,
                Resources = resources,
                Definitions = definitionMap,
            };

            if (resourceProvider != null)
            {
                if (apiVersion != null)
                {
                    result.Id = String.Format(CultureInfo.InvariantCulture, "http://schema.management.azure.com/schemas/{0}/{1}.json#", apiVersion, resourceProvider);
                }
                result.Description = resourceProvider.Replace('.', ' ') + " Resource Types";
            }

            return result;
        }

        private static readonly Response voidReturn = new Response(null, null);

        private static bool ReturnsResource(Method method)
        {
            bool result = false;

            if (method.ReturnType != voidReturn &&
                method.ReturnType.Body is CompositeType)
            {
                CompositeType returnBody = method.ReturnType.Body as CompositeType;
                result = GetValue(returnBody.ComposedExtensions, "x-ms-azure-resource");
            }
            
            return result;
        }

        private static SchemaProperty ParseProperty(Property property, Dictionary<string, Definition> definitionMap)
        {
            bool shouldFlatten = GetValue(property.Extensions, "x-ms-client-flatten");
            return new SchemaProperty()
            {
                Name = property.Name,
                Definition = ParseDefinition(property.Type, property.DefaultValue, !shouldFlatten, definitionMap),
                Description = property.Documentation,
                ShouldFlatten = shouldFlatten,
            };
        }

        private static bool GetValue(IDictionary<string,object> dictionary, string key)
        {
            return dictionary.ContainsKey(key) ? (bool)dictionary[key] : false;
        }

        /// <summary>
        /// Parse a resource property type from the provided type.
        /// </summary>
        /// <param name="type"></param>
        /// <param name="defaultValue"></param>
        /// <param name="addToDefinitionMap"></param>
        /// <param name="definitionMap"></param>
        /// <returns></returns>
        private static Definition ParseDefinition(IType type, string defaultValue, bool addToDefinitionMap, Dictionary<string, Definition> definitionMap)
        {
            Definition definition;

            if (definitionMap.ContainsKey(type.Name))
            {
                definition = definitionMap[type.Name];
            }
            else
            {
                definition = new Definition()
                {
                    Name = type.Name
                };

                if (type is DictionaryType)
                {
                    definition.DefinitionType = "object";

                    DictionaryType dictionaryType = type as DictionaryType;
                    definition.AdditionalProperties = ParseDefinition(dictionaryType.ValueType, null, true, definitionMap);
                }
                else if (type is EnumType)
                {
                    definition.DefinitionType = "string";

                    EnumType propertyEnumType = type as EnumType;
                    foreach (EnumValue allowedValue in propertyEnumType.Values)
                    {
                        definition.AddAllowedValue(allowedValue.Name);
                    }
                }
                else if (type is PrimaryType)
                {
                    PrimaryType primaryPropertyType = type as PrimaryType;
                    switch (primaryPropertyType.Type)
                    {
                        case KnownPrimaryType.Boolean:
                            definition.DefinitionType = "boolean";
                            break;

                        case KnownPrimaryType.Int:
                        case KnownPrimaryType.Long:
                            definition.DefinitionType = "number";
                            break;

                        case KnownPrimaryType.DateTime:
                        case KnownPrimaryType.String:
                            definition.DefinitionType = "string";
                            break;

                        default:
                            Debug.Assert(false, "Unrecognized PrimaryType: " + type);
                            break;
                    }

                    if (defaultValue != null)
                    {
                        definition.AddAllowedValue(defaultValue);
                    }
                }
                else if (type is SequenceType)
                {
                    definition.DefinitionType = "array";

                    SequenceType sequencePropertyType = type as SequenceType;
                    definition.ArrayElement = ParseDefinition(sequencePropertyType.ElementType, null, true, definitionMap);
                }
                else
                {
                    Debug.Assert(type is CompositeType);

                    if (addToDefinitionMap)
                    {
                        definitionMap.Add(definition.Name, definition);
                    }

                    definition.DefinitionType = "object";

                    CompositeType propertyCompositeType = type as CompositeType;
                    definition.Description = propertyCompositeType.Documentation;

                    foreach (Property property in propertyCompositeType.Properties)
                    {
                        if (!property.IsReadOnly)
                        {
                            SchemaProperty definitionProperty = ParseProperty(property, definitionMap);
                            definition.AddProperty(definitionProperty, property.IsRequired);
                        }
                    }
                }
            }

            return definition;
        }
    }
}
