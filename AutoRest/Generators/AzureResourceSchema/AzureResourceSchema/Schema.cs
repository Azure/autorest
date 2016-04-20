// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public class Schema
    {
        private const string resourceMethodPrefix = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/";

        private readonly string id;
        private readonly string title;
        private readonly string description;
        private readonly IEnumerable<Resource> resources;

        private Schema(string id, string title, string description, IEnumerable<Resource> resources)
        {
            this.id = id;
            this.title = title;
            this.description = description;
            this.resources = resources;
        }

        public string Id
        {
            get { return id; }
        }

        public string SchemaUri
        {
            get { return "http://json-schema.org/draft-04/schema#"; }
        }

        public string Title
        {
            get { return title; }
        }

        public string Description
        {
            get { return description; }
        }

        public IEnumerable<Resource> Resources
        {
            get { return resources; }
        }

        public static Schema Parse(ServiceClient serviceClient)
        {
            string resourceProvider = GetResourceProvider(serviceClient);
            string apiVersion = serviceClient.ApiVersion;

            string id = String.Format("http://schema.management.azure.com/schemas/{0}/{1}.json#", apiVersion, resourceProvider);

            string title = resourceProvider;

            string description = resourceProvider.Replace('.', ' ') + " Resource Types";

            List<Resource> resources = new List<Resource>();
            foreach (Method resourceMethod in GetResourceMethods(serviceClient))
            {
                // Azure "create resource" methods are always PUTs.
                if (resourceMethod.HttpMethod == HttpMethod.Put)
                {
                    string resourceName = GetResourceName(resourceMethod);
                    string resourceType = GetResourceType(resourceMethod);
                    string[] apiVersions = new string[] { apiVersion };
                    List<ResourceProperty> resourceProperties = new List<ResourceProperty>();
                    string resourceDescription = resourceType;

                    CompositeType body = resourceMethod.Body.Type as CompositeType;
                    if (body != null)
                    {
                        CompositeType bodyProperties = body.Properties.Where(p => p.Name == "properties").Single().Type as CompositeType;
                        if (bodyProperties != null)
                        {
                            foreach (Property property in bodyProperties.Properties)
                            {
                                string propertyName = property.Name;
                                bool propertyIsRequired = property.IsRequired;
                                string propertyType = null;
                                string[] allowedValues = null;
                                string propertyDescription = String.Format("{0}: {1}", resourceType, property.Documentation);

                                if(property.Type is EnumType)
                                {
                                    propertyType = "string";

                                    EnumType propertyEnumType = property.Type as EnumType;
                                    allowedValues = new string[propertyEnumType.Values.Count];
                                    for (int i = 0; i < propertyEnumType.Values.Count; ++i)
                                    {
                                        allowedValues[i] = propertyEnumType.Values[i].Name;
                                    }
                                }

                                resourceProperties.Add(new ResourceProperty(propertyName, propertyIsRequired, propertyType, allowedValues, propertyDescription));
                            }
                        }
                    }

                    resources.Add(new Resource(resourceName, resourceType, apiVersions, resourceProperties, resourceDescription));
                }
            }

            return new Schema(id, title, description, resources);
        }

        private static IEnumerable<Method> GetResourceMethods(ServiceClient serviceClient)
        {
            return serviceClient.Methods.Where(method => method.Url.StartsWith(resourceMethodPrefix));
        }

        private static string GetResourceProvider(ServiceClient serviceClient)
        {
            return GetResourceMethods(serviceClient).Select(GetResourceProvider).Distinct().Single();
        }

        private static string GetResourceProvider(Method resourceMethod)
        {
            string afterPrefix = resourceMethod.Url.Substring(resourceMethodPrefix.Length);
            int firstForwardSlashAfterPrefix = afterPrefix.IndexOf('/');
            return afterPrefix.Substring(0, firstForwardSlashAfterPrefix);
        }

        private static string GetResourceName(Method resourceMethod)
        {
            string afterPrefix = resourceMethod.Url.Substring(resourceMethodPrefix.Length);
            int forwardSlashIndexAfterProvider = afterPrefix.IndexOf('/');
            int resourceNameStartIndex = forwardSlashIndexAfterProvider + 1;
            int forwardSlashIndexAfterResourceName = afterPrefix.IndexOf('/', resourceNameStartIndex);

            string result;
            if(forwardSlashIndexAfterResourceName == -1)
            {
                result = afterPrefix.Substring(resourceNameStartIndex);
            }
            else
            {
                result = afterPrefix.Substring(resourceNameStartIndex, forwardSlashIndexAfterResourceName - resourceNameStartIndex);
            }

            return result;
        }

        private static string GetResourceType(Method resourceMethod)
        {
            string afterPrefix = resourceMethod.Url.Substring(resourceMethodPrefix.Length);
            int forwardSlashIndexAfterProvider = afterPrefix.IndexOf('/');
            int forwardSlashIndexAfterResourceName = afterPrefix.IndexOf('/', forwardSlashIndexAfterProvider + 1);

            string result;
            if(forwardSlashIndexAfterResourceName == -1)
            {
                result = afterPrefix;
            }
            else
            {
                result = afterPrefix.Substring(0, forwardSlashIndexAfterResourceName);
            }

            return result;
        }
    }
}
