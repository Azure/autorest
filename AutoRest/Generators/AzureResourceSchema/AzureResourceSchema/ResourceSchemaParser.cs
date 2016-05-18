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
        public static IDictionary<string,ResourceSchema> Parse(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            IDictionary<string,ResourceSchema> result = new Dictionary<string,ResourceSchema>();
            
            List<Method> createResourceMethods = new List<Method>();
            foreach (Method method in serviceClient.Methods)
            {
                if (IsCreateResourceMethod(method))
                {
                    createResourceMethods.Add(method);
                }
            }

            string apiVersion = serviceClient.ApiVersion;
            
            foreach (Method createResourceMethod in createResourceMethods)
            {
                JsonSchema resourceDefinition = new JsonSchema();
                resourceDefinition.JsonType = "object";

                string afterPrefix = createResourceMethod.Url.Substring(resourceMethodPrefix.Length);
                int forwardSlashIndexAfterProvider = afterPrefix.IndexOf('/');
                string resourceProvider = afterPrefix.Substring(0, forwardSlashIndexAfterProvider);

                ResourceSchema resourceSchema;
                if (!result.ContainsKey(resourceProvider))
                {
                    resourceSchema = new ResourceSchema();

                    if (apiVersion != null)
                    {
                        resourceSchema.Id = string.Format(CultureInfo.InvariantCulture, "http://schema.management.azure.com/schemas/{0}/{1}.json#", apiVersion, resourceProvider);
                    }

                    resourceSchema.Title = resourceProvider;
                    resourceSchema.Description = resourceProvider.Replace('.', ' ') + " Resource Types";
                    resourceSchema.Schema = "http://json-schema.org/draft-04/schema#";

                    result.Add(resourceProvider, resourceSchema);
                }
                else
                {
                    resourceSchema = result[resourceProvider];
                }

                string methodUrlPathAfterProvider = afterPrefix.Substring(forwardSlashIndexAfterProvider + 1);
                string resourceType = GetResourceType(resourceProvider, methodUrlPathAfterProvider);

                resourceDefinition.AddProperty("type", new JsonSchema()
                    {
                        JsonType = "string"
                    }
                    .AddEnum(resourceType));

                if (!string.IsNullOrWhiteSpace(apiVersion))
                {
                    resourceDefinition.AddProperty("apiVersion", new JsonSchema()
                        {
                            JsonType = "string"
                        }
                        .AddEnum(apiVersion));
                }

                CompositeType body = createResourceMethod.Body.Type as CompositeType;
                Debug.Assert(body != null, "The create resource method's body must be a CompositeType and cannot be null.");
                if (body != null)
                {
                    foreach (Property property in body.Properties)
                    {
                        JsonSchema propertyDefinition = ParseProperty(property, resourceSchema.Definitions);
                        if (propertyDefinition != null)
                        {
                            resourceDefinition.AddProperty(property.Name, propertyDefinition, property.IsRequired);
                        }
                    }
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

                string resourcePropertyName = resourceType.Substring(resourceProvider.Length + 1).Replace('/', '_');
                Debug.Assert(!resourceSchema.ResourceDefinitions.ContainsKey(resourcePropertyName));
                resourceSchema.AddResourceDefinition(resourcePropertyName, resourceDefinition);
            }

            // This loop adds child resource schemas to their parent resource schemas. We can't do
            // this until we're done adding all resources as top level resources, though, because
            // it's possible that we will parse a child resource before we parse the parent
            // resource.
            foreach (ResourceSchema resourceSchema in result.Values)
            {
                // By iterating over the reverse order of the defined resource definitions, I'm
                // counting on the resource definitions being in sorted order. That way I'm
                // guaranteed to visit child resource definitions before I visit their parent
                // resource definitions. By doing this, I've guaranteed that grandchildren resource
                // definitions will be added to their grandparent (and beyond) ancestor
                // resource definitions.
                foreach (string resourcePropertyName in resourceSchema.ResourceDefinitions.Keys.Reverse())
                {
                    JsonSchema resourceDefinition = resourceSchema.ResourceDefinitions[resourcePropertyName];

                    string resourceType = resourceDefinition.ResourceType;
                    int lastSlashIndex = resourceType.LastIndexOf('/');
                    string parentResourceType = resourceType.Substring(0, lastSlashIndex);
                    JsonSchema parentResourceDefinition = resourceSchema.GetResourceDefinitionByResourceType(parentResourceType);
                    if (parentResourceDefinition != null)
                    {
                        string childResourceType = resourceType.Substring(lastSlashIndex + 1);

                        JsonSchema childResourceDefinition = resourceDefinition.Clone();
                        childResourceDefinition.ResourceType = childResourceType;
                        string childResourceDefinitionPropertyName = string.Join("_", resourcePropertyName, "childResource");
                        resourceSchema.AddDefinition(childResourceDefinitionPropertyName, childResourceDefinition);

                        parentResourceDefinition.AddResource(new JsonSchema()
                        {
                            Ref = "#/definitions/" + childResourceDefinitionPropertyName,
                        });
                    }
                }
            }

            return result;
        }

        private static JsonSchema ParseProperty(Property property, IDictionary<string, JsonSchema> definitionMap)
        {
            JsonSchema propertyDefinition = null;

            if (!property.IsReadOnly)
            {
                propertyDefinition = new JsonSchema();

                IType propertyType = property.Type;

                CompositeType compositeType = propertyType as CompositeType;
                if (compositeType != null)
                {
                    propertyDefinition = ParseCompositeType(compositeType, definitionMap);
                    propertyDefinition.Description = property.Documentation;
                }
                else
                {
                    DictionaryType dictionaryType = propertyType as DictionaryType;
                    if (dictionaryType != null)
                    {
                        propertyDefinition.JsonType = "object";
                        propertyDefinition.Description = property.Documentation;

                        PrimaryType dictionaryPrimaryType = dictionaryType.ValueType as PrimaryType;
                        if (dictionaryPrimaryType != null)
                        {
                            propertyDefinition.AdditionalProperties = ParsePrimaryType(dictionaryPrimaryType);
                        }
                        else
                        {
                            CompositeType dictionaryCompositeType = dictionaryType.ValueType as CompositeType;
                            if (dictionaryCompositeType != null)
                            {
                                propertyDefinition.AdditionalProperties = ParseCompositeType(dictionaryCompositeType, definitionMap);
                            }
                            else
                            {
                                Debug.Assert(false, "Unrecognized DictionaryType.ValueType: " + dictionaryType.ValueType.GetType());
                            }
                        }
                    }
                    else
                    {
                        EnumType enumType = propertyType as EnumType;
                        if (enumType != null)
                        {
                            propertyDefinition = ParseEnumType(enumType);
                            propertyDefinition.Description = property.Documentation;
                        }
                        else
                        {
                            PrimaryType primaryType = propertyType as PrimaryType;
                            if (primaryType != null)
                            {
                                propertyDefinition = ParsePrimaryType(primaryType);
                                propertyDefinition.Description = property.Documentation;

                                if (property.DefaultValue != null)
                                {
                                    propertyDefinition.AddEnum(property.DefaultValue);
                                }
                            }
                            else
                            {
                                SequenceType sequenceType = propertyType as SequenceType;
                                if (sequenceType != null)
                                {
                                    propertyDefinition.JsonType = "array";
                                    propertyDefinition.Description = property.Documentation;

                                    IType sequenceElementType = sequenceType.ElementType;

                                    CompositeType sequenceCompositeType = sequenceElementType as CompositeType;
                                    if (sequenceCompositeType != null)
                                    {
                                        propertyDefinition.Items = ParseCompositeType(sequenceCompositeType, definitionMap);
                                    }
                                    else
                                    {
                                        PrimaryType sequencePrimaryType = sequenceElementType as PrimaryType;
                                        if (sequencePrimaryType != null)
                                        {
                                            propertyDefinition.Items = ParsePrimaryType(sequencePrimaryType);
                                        }
                                        else
                                        {
                                            EnumType sequenceEnumType = sequenceElementType as EnumType;
                                            if (sequenceEnumType != null)
                                            {
                                                propertyDefinition = ParseEnumType(sequenceEnumType);
                                            }
                                            else
                                            {
                                                Debug.Assert(false, "Unrecognized SequenceType.ElementType: " + sequenceType.ElementType.GetType());
                                            }
                                        }
                                    }       
                                }
                                else
                                {
                                    Debug.Assert(false, "Unrecognized property type: " + propertyType.GetType());
                                }
                            }
                        }
                    }
                }
            }

            return propertyDefinition;
        }

        private static JsonSchema ParseCompositeType(CompositeType compositeType, IDictionary<string, JsonSchema> definitionMap)
        {
            JsonSchema result = new JsonSchema();

            string definitionName = compositeType.Name;

            if (!definitionMap.ContainsKey(definitionName))
            {
                JsonSchema definition = new JsonSchema();
                definitionMap.Add(definitionName, definition);

                definition.JsonType = "object";

                foreach (Property subProperty in compositeType.ComposedProperties)
                {
                    JsonSchema subPropertyDefinition = ParseProperty(subProperty, definitionMap);
                    if (subPropertyDefinition != null)
                    {
                        definition.AddProperty(subProperty.Name, subPropertyDefinition, subProperty.IsRequired);
                    }
                }

                definition.Description = compositeType.Documentation;
            }

            result.Ref = "#/definitions/" + definitionName;

            return result;
        }

        private static JsonSchema ParseEnumType(EnumType enumType)
        {
            JsonSchema result = new JsonSchema();

            result.JsonType = "string";
            foreach (EnumValue enumValue in enumType.Values)
            {
                result.AddEnum(enumValue.Name);
            }

            return result;
        }

        private static JsonSchema ParsePrimaryType(PrimaryType primaryType)
        {
            JsonSchema result = new JsonSchema();

            switch (primaryType.Type)
            {
                case KnownPrimaryType.Boolean:
                    result.JsonType = "boolean";
                    break;

                case KnownPrimaryType.Int:
                case KnownPrimaryType.Long:
                    result.JsonType = "integer";
                    break;

                case KnownPrimaryType.Double:
                    result.JsonType = "number";
                    break;

                case KnownPrimaryType.Object:
                    result.JsonType = "object";
                    break;

                case KnownPrimaryType.DateTime:
                case KnownPrimaryType.String:
                    result.JsonType = "string";
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
        public static bool IsCreateResourceMethod(Method method)
        {
            if (method == null)
            {
                throw new ArgumentNullException("method");
            }

            bool result = false;

            if (!string.IsNullOrWhiteSpace(method.Url) &&
                method.Url.StartsWith(resourceMethodPrefix, StringComparison.Ordinal) &&
                method.Url.EndsWith("}", StringComparison.Ordinal) && // Only methods that end with the resource's name ({name}) are resource create methods.
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
        /// <param name="methodPathAfterProvider"></param>
        /// <returns></returns>
        public static string GetResourceType(string resourceProvider, string methodPathAfterProvider)
        {
            if (string.IsNullOrWhiteSpace(resourceProvider))
            {
                throw new ArgumentException("resourceProvider cannot be null or whitespace", "resourceProvider");
            }
            if (string.IsNullOrWhiteSpace(methodPathAfterProvider))
            {
                throw new ArgumentException("methodPathAfterProvider cannot be null or whitespace", "methodPathAfterProvider");
            }

            List<string> resourceTypeParts = new List<string>();
            resourceTypeParts.Add(resourceProvider);

            string[] pathSegments = methodPathAfterProvider.Split(new char[] { '/' });
            for (int i = 0; i < pathSegments.Length; i += 2)
            {
                resourceTypeParts.Add(pathSegments[i]);
            }

            return string.Join("/", resourceTypeParts);
        }
    }
}
