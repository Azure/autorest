// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger;
using Microsoft.Rest.Modeler.Swagger.Model;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

namespace Microsoft.Rest.Generator
{
    /// <summary>
    /// Base code generator for Azure.
    /// Normalizes the ServiceClient according to Azure conventions and Swagger extensions.
    /// </summary>
    public abstract class Extensions
    {
        public const string SkipUrlEncodingExtension = "x-ms-skip-url-encoding";
        public const string NameOverrideExtension = "x-ms-client-name";
        public const string FlattenExtension = "x-ms-client-flatten";
        public const string FlattenOriginalTypeName = "x-ms-client-flatten-original-type-name";
        public const string ParameterGroupExtension = "x-ms-parameter-grouping";
        public const string ParameterizedHostExtension = "x-ms-parameterized-host";

        private static bool hostChecked = false;

        /// <summary>
        /// Normalizes client model using generic extensions.
        /// </summary>
        /// <param name="serviceClient">Service client</param>
        /// <param name="settings">AutoRest settings</param>
        /// <returns></returns>
        public static void NormalizeClientModel(ServiceClient serviceClient, Settings settings)
        {
            FlattenModels(serviceClient);
            FlattenMethodParameters(serviceClient, settings);
            AddParameterGroups(serviceClient);
            ProcessParameterizedHost(serviceClient, settings);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase", Justification = "We are normalizing a URI, which is lowercase by convention")]
        public static void ProcessParameterizedHost(ServiceClient serviceClient, Settings settings)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            if (settings == null)
            {
                throw new ArgumentNullException("settings");
            }

            if (serviceClient.Extensions.ContainsKey(ParameterizedHostExtension) && !hostChecked)
            { 
                SwaggerModeler modeler = new SwaggerModeler(settings);
                modeler.Build();
                var hostExtension = serviceClient.Extensions[ParameterizedHostExtension] as JObject;

                if (hostExtension != null)
                {
                    var hostTemplate = (string)hostExtension["hostTemplate"];
                    var parametersJson = hostExtension["parameters"].ToString();
                    if (!string.IsNullOrEmpty(parametersJson))
                    {
                        var jsonSettings = new JsonSerializerSettings
                        {
                            TypeNameHandling = TypeNameHandling.None,
                            MetadataPropertyHandling = MetadataPropertyHandling.Ignore
                        };

                        var swaggerParams = JsonConvert.DeserializeObject<List<SwaggerParameter>>(parametersJson, jsonSettings);
                        
                        foreach (var swaggerParameter in swaggerParams)
                        {
                            // Build parameter
                            var parameterBuilder = new ParameterBuilder(swaggerParameter, modeler);
                            var parameter = parameterBuilder.Build();

                            // check to see if the parameter exists in properties, and needs to have its name normalized
                            if (serviceClient.Properties.Any(p => p.SerializedName.Equals(parameter.SerializedName)))
                            {
                                parameter.ClientProperty = serviceClient.Properties.Single(p => p.SerializedName.Equals(parameter.SerializedName));
                            }
                            parameter.Extensions["hostParameter"] = true;

                            foreach (var method in serviceClient.Methods)
                            {
                                method.Parameters.Add(parameter);
                            }
                        }

                        serviceClient.BaseUrl = string.Format(CultureInfo.InvariantCulture, "{0}://{1}{2}",
                        modeler.ServiceDefinition.Schemes[0].ToString().ToLowerInvariant(),
                        hostTemplate, modeler.ServiceDefinition.BasePath);
                    }
                }
            }

            hostChecked = true;
        }

        /// <summary>
        /// Flattens the Resource Properties.
        /// </summary>
        /// <param name="serviceClient"></param>
        public static void FlattenModels(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            HashSet<string> typesToDelete = new HashSet<string>();
            foreach (var compositeType in serviceClient.ModelTypes)
            {
                if (compositeType.Properties.Any(p => p.ShouldBeFlattened())
                    && !typesToDelete.Contains(compositeType.Name))
                {
                    List<Property> oldProperties = compositeType.Properties.ToList();
                    compositeType.Properties.Clear();
                    foreach (Property innerProperty in oldProperties)
                    {
                        if (innerProperty.ShouldBeFlattened() && compositeType != innerProperty.Type)
                        {
                            FlattenProperty(innerProperty, typesToDelete)
                                .ForEach(p => compositeType.Properties.Add(p));
                        }
                        else
                        {
                            compositeType.Properties.Add(innerProperty);
                        }
                    }

                    RemoveFlatteningConflicts(compositeType);
                }
            }

            RemoveUnreferencedTypes(serviceClient, typesToDelete);
        }

        private static void RemoveFlatteningConflicts(CompositeType compositeType)
        {
            if (compositeType == null)
            {
                throw new ArgumentNullException("compositeType");
            }

            foreach (Property innerProperty in compositeType.Properties)
            {
                // Check conflict among peers

                var conflictingPeers = compositeType.Properties
                    .Where(p => p.Name == innerProperty.Name && p.SerializedName != innerProperty.SerializedName);

                if (conflictingPeers.Any())
                {
                    foreach (var cp in conflictingPeers.Concat(new[] { innerProperty }))
                    {
                        if (cp.Extensions.ContainsKey(FlattenOriginalTypeName))
                        {
                            cp.Name = cp.Extensions[FlattenOriginalTypeName].ToString() + "_" + cp.Name;
                        }
                    }
                }

                if (compositeType.BaseModelType != null)
                {
                    var conflictingParentProperties = compositeType.BaseModelType.ComposedProperties
                        .Where(p => p.Name == innerProperty.Name && p.SerializedName != innerProperty.SerializedName);

                    if (conflictingParentProperties.Any())
                    {
                        innerProperty.Name = compositeType.Name + "_" + innerProperty.Name;
                    }
                }
            }
        }

        private static IEnumerable<Property> FlattenProperty(Property propertyToFlatten, HashSet<string> typesToDelete)
        {
            if (propertyToFlatten == null)
            {
                throw new ArgumentNullException("propertyToFlatten");
            }
            if (typesToDelete == null)
            {
                throw new ArgumentNullException("typesToDelete");
            }

            CompositeType typeToFlatten = propertyToFlatten.Type as CompositeType;
            if (typeToFlatten == null)
            {
                return new[] { propertyToFlatten };
            }

            List<Property> extractedProperties = new List<Property>();
            foreach (Property innerProperty in typeToFlatten.Properties)
            {
                Debug.Assert(typeToFlatten.SerializedName != null);
                Debug.Assert(innerProperty.SerializedName != null);

                if (innerProperty.ShouldBeFlattened() && typeToFlatten != innerProperty.Type)
                {
                    extractedProperties.AddRange(FlattenProperty(innerProperty, typesToDelete)
                        .Select(fp => UpdateSerializedNameWithPathHierarchy(fp, propertyToFlatten.SerializedName, false)));
                }
                else
                {
                    Property clonedProperty = (Property)innerProperty.Clone();
                    if (!clonedProperty.Extensions.ContainsKey(FlattenOriginalTypeName))
                    {
                        clonedProperty.Extensions[FlattenOriginalTypeName] = typeToFlatten.Name;
                        UpdateSerializedNameWithPathHierarchy(clonedProperty, propertyToFlatten.SerializedName, true);
                    }
                    extractedProperties.Add(clonedProperty);
                }
            }

            typesToDelete.Add(typeToFlatten.Name);

            return extractedProperties;
        }

        private static Property UpdateSerializedNameWithPathHierarchy(Property property, string basePath, bool escapePropertyName)
        {
            if (property == null)
            {
                throw new ArgumentNullException("property");
            }
            if (basePath == null)
            {
                basePath = "";
            }

            basePath = basePath.Replace(".", "\\\\.");
            string propertyName = property.SerializedName;
            if (escapePropertyName)
            {
                propertyName = propertyName.Replace(".", "\\\\.");
            }
            property.SerializedName = basePath + "." + propertyName;
            return property;
        }

        /// <summary>
        /// Cleans all model types that are not used
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="typeNames"></param>
        public static void RemoveUnreferencedTypes(ServiceClient serviceClient, HashSet<string> typeNames)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            if (typeNames == null)
            {
                throw new ArgumentNullException("typeNames");
            }

            while (typeNames.Count > 0)
            {
                string typeName = typeNames.First();
                typeNames.Remove(typeName);

                var typeToDelete = serviceClient.ModelTypes.First(t => t.Name == typeName);

                var isUsedInErrorTypes = serviceClient.ErrorTypes.Any(e => e.Name == typeName);
                var isUsedInResponses = serviceClient.Methods.Any(m => m.Responses.Any(r => r.Value.Body == typeToDelete));
                var isUsedInParameters = serviceClient.Methods.Any(m => m.Parameters.Any(p => p.Type == typeToDelete));
                var isBaseType = serviceClient.ModelTypes.Any(t => t.BaseModelType == typeToDelete);
                var isUsedInProperties = serviceClient.ModelTypes.Where(t => !typeNames.Contains(t.Name))
                                                                 .Any(t => t.Properties.Any(p => p.Type == typeToDelete));
                if (!isUsedInErrorTypes &&
                    !isUsedInResponses &&
                    !isUsedInParameters &&
                    !isBaseType &&
                    !isUsedInProperties)
                {
                    serviceClient.ModelTypes.Remove(typeToDelete);
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

            HashSet<CompositeType> generatedParameterGroups = new HashSet<CompositeType>();

            foreach (Method method in serviceClient.Methods)
            {
                //Copy out flattening transformations as they should be the last
                List<ParameterTransformation> flatteningTransformations = method.InputParameterTransformation.ToList();
                method.InputParameterTransformation.Clear();

                //This group name is normalized by each languages code generator later, so it need not happen here.
                Dictionary<string, Dictionary<Property, Parameter>> parameterGroups = new Dictionary<string, Dictionary<Property, Parameter>>();

                foreach (Parameter parameter in method.Parameters)
                {
                    if (parameter.Extensions.ContainsKey(ParameterGroupExtension))
                    {
                        JContainer extensionObject = parameter.Extensions[ParameterGroupExtension] as JContainer;
                        if (extensionObject != null)
                        {
                            string specifiedGroupName = extensionObject.Value<string>("name");
                            string parameterGroupName;
                            if (specifiedGroupName == null)
                            {
                                string postfix = extensionObject.Value<string>("postfix") ?? "Parameters";
                                parameterGroupName = method.Group + "-" + method.Name + "-" + postfix;
                            }
                            else
                            {
                                parameterGroupName = specifiedGroupName;
                            }

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
                            // Copy over extensions
                            foreach (var key in parameter.Extensions.Keys)
                            {
                                groupProperty.Extensions[key] = parameter.Extensions[key];
                            }

                            parameterGroups[parameterGroupName].Add(groupProperty, parameter);
                        }
                    }
                }

                foreach (string parameterGroupName in parameterGroups.Keys)
                {
                    CompositeType parameterGroupType =
                        generatedParameterGroups.FirstOrDefault(item => item.Name == parameterGroupName);
                    if (parameterGroupType == null)
                    {
                        parameterGroupType = new CompositeType
                        {
                            Name = parameterGroupName,
                            Documentation = "Additional parameters for the " + method.Name + " operation."
                        };
                        generatedParameterGroups.Add(parameterGroupType);

                        //Add to the service client
                        serviceClient.ModelTypes.Add(parameterGroupType);
                    }

                    foreach (Property property in parameterGroups[parameterGroupName].Keys)
                    {
                        Property matchingProperty = parameterGroupType.Properties.FirstOrDefault(
                                item => item.Name == property.Name &&
                                        item.IsReadOnly == property.IsReadOnly &&
                                        item.DefaultValue == property.DefaultValue &&
                                        item.SerializedName == property.SerializedName);
                        if (matchingProperty == null)
                        {
                            parameterGroupType.Properties.Add(property);
                        }
                    }

                    bool isGroupParameterRequired = parameterGroupType.Properties.Any(p => p.IsRequired);

                    //Create the new parameter object based on the parameter group type
                    Parameter parameterGroup = new Parameter()
                    {
                        Name = parameterGroupName,
                        IsRequired = isGroupParameterRequired,
                        Location = ClientModel.ParameterLocation.None,
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

                // Copy back flattening transformations if any
                flatteningTransformations.ForEach(t => method.InputParameterTransformation.Add(t));
            }
        }

        /// <summary>
        /// Flattens the request payload if the number of properties of the 
        /// payload is less than or equal to the PayloadFlatteningThreshold.
        /// </summary>
        /// <param name="serviceClient">Service client</param>                            
        /// <param name="settings">AutoRest settings</param>                            
        public static void FlattenMethodParameters(ServiceClient serviceClient, Settings settings)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");    
            }
            if (settings == null)
            {
                throw new ArgumentNullException("settings");
            }

            foreach (var method in serviceClient.Methods)
            {
                var bodyParameter = method.Parameters.FirstOrDefault(
                    p => p.Location == ClientModel.ParameterLocation.Body);

                if (bodyParameter != null)
                {
                    var bodyParameterType = bodyParameter.Type as CompositeType;
                    if (bodyParameterType != null && 
                        (bodyParameterType.ComposedProperties.Count(p => !p.IsConstant) <= settings.PayloadFlatteningThreshold ||
                         bodyParameter.ShouldBeFlattened()))
                    {
                        var parameterTransformation = new ParameterTransformation
                        {
                            OutputParameter = bodyParameter
                        };
                        method.InputParameterTransformation.Add(parameterTransformation);

                        foreach (var property in bodyParameterType.ComposedProperties.Where(p => !p.IsConstant && p.Name != null))
                        {
                            var newMethodParameter = new Parameter();
                            newMethodParameter.LoadFrom(property);
                            bodyParameter.Extensions.ForEach(kv => { newMethodParameter.Extensions[kv.Key] = kv.Value; });
                            method.Parameters.Add(newMethodParameter);

                            parameterTransformation.ParameterMappings.Add(new ParameterMapping
                            {
                                InputParameter = newMethodParameter,
                                OutputParameterProperty = property.Name
                            });
                        }

                        method.Parameters.Remove(bodyParameter);
                    }
                }
            }
        }
    }
}