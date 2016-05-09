// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    /// <summary>
    /// The ResourceSchemaParser class is responsible for converting a ServiceClient object into a
    /// ResourceSchemaModel.
    /// </summary>
    public static class ResourceSchemaParser
    {
        private const string resourceMethodPrefix = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/";

        /// <summary>
        /// Parse a ResourceSchemaModel from the provided ServiceClient.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public static ResourceSchemaModel Parse(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            ResourceSchemaModel result = new ResourceSchemaModel();
            result.Schema = "http://json-schema.org/draft-04/schema#";

            List<Method> createResourceMethods = new List<Method>();
            foreach (Method method in serviceClient.Methods)
            {
                if (IsCreateResourceMethod(method))
                {
                    createResourceMethods.Add(method);
                }
            }

            string apiVersion = serviceClient.ApiVersion;
            string resourceProvider = null;

            foreach (Method createResourceMethod in createResourceMethods)
            {
                JSONSchema resourceDefinition = new JSONSchema();
                resourceDefinition.JSONType = "object";

                string afterPrefix = createResourceMethod.Url.Substring(resourceMethodPrefix.Length);
                int forwardSlashIndexAfterProvider = afterPrefix.IndexOf('/');
                string resourceMethodProvider = afterPrefix.Substring(0, forwardSlashIndexAfterProvider);
                if (resourceProvider == null)
                {
                    resourceProvider = resourceMethodProvider;

                    if (apiVersion != null)
                    {
                        result.Id = string.Format("http://schema.management.azure.com/schemas/{0}/{1}.json#", apiVersion, resourceProvider);
                    }

                    result.Title = resourceProvider;
                    result.Description = resourceProvider.Replace('.', ' ') + " Resource Types";
                }
                else
                {
                    Debug.Assert(resourceProvider == resourceMethodProvider);
                }

                string methodUrlPathAfterProvider = afterPrefix.Substring(forwardSlashIndexAfterProvider + 1);
                string resourceType = GetResourceType(resourceProvider, methodUrlPathAfterProvider);

                string resourceName = resourceType.Split('/').Last();

                resourceDefinition.AddProperty("type", new JSONSchema()
                {
                    JSONType = "string",
                    Enum = new string[] { resourceType }
                });

                if (!string.IsNullOrWhiteSpace(apiVersion))
                {
                    resourceDefinition.AddProperty("apiVersion", new JSONSchema()
                    {
                        JSONType = "string",
                        Enum = new string[] { apiVersion }
                    });
                }

                IDictionary<string, JSONSchema> definitionMap = new Dictionary<string, JSONSchema>();

                CompositeType body = createResourceMethod.Body.Type as CompositeType;
                Debug.Assert(body != null, "The create resource method's body must be a CompositeType and cannot be null.");
                if (body != null)
                {
                    foreach (Property property in body.Properties)
                    {
                        JSONSchema propertyDefinition = ParseProperty(property, definitionMap);
                        if (propertyDefinition != null)
                        {
                            resourceDefinition.AddProperty(property.Name, propertyDefinition, property.IsRequired);
                        }
                    }
                }

                foreach (string definitionName in definitionMap.Keys)
                {
                    result.AddDefinition(definitionName, definitionMap[definitionName]);
                }

                resourceDefinition.Description = resourceType;

                foreach (string standardPropertyName in new string[] { "properties", "apiVersion", "type" })
                {
                    if (resourceDefinition.Properties.ContainsKey(standardPropertyName))
                    {
                        if (resourceDefinition.Required == null)
                        {
                            resourceDefinition.AddRequired(standardPropertyName);
                        }
                        else
                        {
                            resourceDefinition.Required.Insert(0, standardPropertyName);
                        }
                    }
                }

                result.AddResourceDefinition(resourceName, resourceDefinition);
            }

            return result;
        }

        private static JSONSchema ParseProperty(Property property, IDictionary<string, JSONSchema> definitionMap)
        {
            JSONSchema propertyDefinition = null;

            if (!property.IsReadOnly)
            {
                propertyDefinition = new JSONSchema();

                IType propertyType = property.Type;
                if (propertyType is CompositeType)
                {
                    propertyDefinition = ParseCompositeType(propertyType as CompositeType, definitionMap);
                    propertyDefinition.Description = property.Documentation;
                }
                else if (propertyType is DictionaryType)
                {
                    DictionaryType dictionaryType = propertyType as DictionaryType;

                    string definitionName = dictionaryType.Name;
                    propertyDefinition.JSONType = "object";
                    propertyDefinition.Description = property.Documentation;

                    if (dictionaryType.ValueType is PrimaryType)
                    {
                        propertyDefinition.AdditionalProperties = ParsePrimaryType(dictionaryType.ValueType as PrimaryType);
                    }
                    else
                    {
                        Debug.Assert(false, "Unrecognized DictionaryType.ValueType: " + dictionaryType.ValueType.GetType());
                    }
                }
                else if (propertyType is EnumType)
                {
                    EnumType enumType = propertyType as EnumType;

                    string definitionName = enumType.Name;
                    propertyDefinition.JSONType = "string";
                    foreach (EnumValue enumValue in enumType.Values)
                    {
                        propertyDefinition.AddEnum(enumValue.Name);
                    }

                    propertyDefinition.Description = property.Documentation;
                }
                else if (propertyType is PrimaryType)
                {
                    propertyDefinition = ParsePrimaryType(propertyType as PrimaryType);
                    propertyDefinition.Description = property.Documentation;

                    if (property.DefaultValue != null)
                    {
                        propertyDefinition.AddEnum(property.DefaultValue);
                    }
                }
                else if (propertyType is SequenceType)
                {
                    SequenceType sequenceType = propertyType as SequenceType;

                    string definitionName = sequenceType.Name;
                    propertyDefinition.JSONType = "array";

                    if (sequenceType.ElementType is CompositeType)
                    {
                        propertyDefinition.Items = ParseCompositeType(sequenceType.ElementType as CompositeType, definitionMap);
                    }
                    else if (sequenceType.ElementType is PrimaryType)
                    {
                        propertyDefinition.Items = ParsePrimaryType(sequenceType.ElementType as PrimaryType);
                    }
                    else
                    {
                        Debug.Assert(false, "Unrecognized SequenceType.ElementType: " + sequenceType.ElementType.GetType());
                    }
                }
                else
                {
                    Debug.Assert(false, "Unrecognized property type: " + propertyType.GetType());
                }
            }

            return propertyDefinition;
        }

        private static JSONSchema ParseCompositeType(CompositeType compositeType, IDictionary<string, JSONSchema> definitionMap)
        {
            JSONSchema result = new JSONSchema();

            string definitionName = compositeType.Name;

            if (!definitionMap.ContainsKey(definitionName))
            {
                JSONSchema definition = new JSONSchema();
                definition.JSONType = "object";

                Debug.Assert(compositeType.Properties.Count == compositeType.ComposedProperties.Count());
                foreach (Property subProperty in compositeType.ComposedProperties)
                {
                    JSONSchema subPropertyDefinition = ParseProperty(subProperty, definitionMap);
                    if (subPropertyDefinition != null)
                    {
                        definition.AddProperty(subProperty.Name, subPropertyDefinition, subProperty.IsRequired);
                    }
                }

                definition.Description = compositeType.Documentation;

                definitionMap.Add(definitionName, definition);
            }

            result.Ref = "#/definitions/" + definitionName;

            return result;
        }

        private static JSONSchema ParsePrimaryType(PrimaryType primaryType)
        {
            JSONSchema result = new JSONSchema();

            switch (primaryType.Type)
            {
                case KnownPrimaryType.Boolean:
                    result.JSONType = "boolean";
                    break;

                case KnownPrimaryType.Int:
                    result.JSONType = "integer";
                    break;

                case KnownPrimaryType.String:
                    result.JSONType = "string";
                    break;

                default:
                    Debug.Assert(false, "Unrecognized known property type: " + primaryType.Type);
                    break;
            }

            return result;
        }

        /// <summary>
        /// Determine whether the provided method object represents an Azure REST API that would
        /// create an Azure resource.
        /// </summary>
        /// <param name="method"></param>
        /// <returns></returns>
        internal static bool IsCreateResourceMethod(Method method)
        {
            if (method == null)
            {
                throw new ArgumentNullException("method");
            }

            bool result = false;

            if (!string.IsNullOrWhiteSpace(method.Url) &&
                method.Url.StartsWith(resourceMethodPrefix) &&
                method.HttpMethod == HttpMethod.Put &&
                method.ReturnType.Body != null)
            {
                CompositeType body = method.ReturnType.Body as CompositeType;
                if (body != null)
                {
                    Dictionary<string, object> bodyComposedExtensions = body.ComposedExtensions;
                    const string azureResource = "x-ms-azure-resource";
                    result = bodyComposedExtensions.ContainsKey(azureResource) ? (bool)bodyComposedExtensions[azureResource] : false;
                }
            }

            return result;
        }

        /// <summary>
        /// Get the resource type from the provided resourceProvider and the portion of the method
        /// URL path that comes after the resourceProvider section.
        /// </summary>
        /// <param name="resourceProvider"></param>
        /// <param name="methodUrlPathAfterProvider"></param>
        /// <returns></returns>
        internal static string GetResourceType(string resourceProvider, string methodUrlPathAfterProvider)
        {
            if (string.IsNullOrWhiteSpace(resourceProvider))
            {
                throw new ArgumentException("resourceProvider cannot be null or whitespace", "resourceProvider");
            }
            if (string.IsNullOrWhiteSpace(methodUrlPathAfterProvider))
            {
                throw new ArgumentException("methodUrlPathAfterProvider cannot be null or whitespace", "methodUrlPathAfterProvider");
            }

            List<string> resourceTypeParts = new List<string>();
            resourceTypeParts.Add(resourceProvider);

            string[] pathSegments = methodUrlPathAfterProvider.Split(new char[] { '/' });
            for (int i = 0; i < pathSegments.Length; i += 2)
            {
                resourceTypeParts.Add(pathSegments[i]);
            }

            return string.Join("/", resourceTypeParts);
        }
    }
}
