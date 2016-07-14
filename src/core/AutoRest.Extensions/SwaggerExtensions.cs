// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Properties;
using AutoRest.Swagger;
using AutoRest.Swagger.Model;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using ParameterLocation = AutoRest.Core.ClientModel.ParameterLocation;

namespace AutoRest.Extensions
{
    /// <summary>
    /// Base code generator for Azure.
    /// Normalizes the ServiceClient according to Azure conventions and Swagger extensions.
    /// </summary>
    public abstract class SwaggerExtensions
    {
        public const string SkipUrlEncodingExtension = "x-ms-skip-url-encoding";
        public const string NameOverrideExtension = "x-ms-client-name";
        public const string FlattenExtension = "x-ms-client-flatten";
        public const string FlattenOriginalTypeName = "x-ms-client-flatten-original-type-name";
        public const string ParameterGroupExtension = "x-ms-parameter-grouping";
        public const string ParameterizedHostExtension = "x-ms-parameterized-host";
        public const string UseSchemePrefix = "useSchemePrefix";
        public const string PositionInOperation = "positionInOperation";
        public const string ParameterLocationExtension = "x-ms-parameter-location";

        private static bool hostChecked = false;

        /// <summary>
        /// Normalizes client model using generic extensions.
        /// </summary>
        /// <param name="serviceClient">Service client</param>
        /// <param name="settings">AutoRest settings</param>
        /// <returns></returns>
        public static void NormalizeClientModel(ServiceClient serviceClient, Settings settings)
        {
            ProcessGlobalParameters(serviceClient);
            FlattenModels(serviceClient);
            FlattenMethodParameters(serviceClient, settings);
            ParameterGroupExtensionHelper.AddParameterGroups(serviceClient);
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
                    var useSchemePrefix = true;
                    if (hostExtension[UseSchemePrefix] != null)
                    {
                        useSchemePrefix = bool.Parse(hostExtension[UseSchemePrefix].ToString());
                    }

                    var position = "first";
                    
                    if (hostExtension[PositionInOperation] != null)
                    {
                        var pat = "^(fir|la)st$";
                        Regex r = new Regex(pat, RegexOptions.IgnoreCase);
                        var text = hostExtension[PositionInOperation].ToString();
                        Match m = r.Match(text);
                        if (!m.Success)
                        {
                            throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture, 
                                Resources.InvalidExtensionProperty, text, PositionInOperation, ParameterizedHostExtension, "first, last"));
                        }
                        position = text;
                    }

                    if (!string.IsNullOrEmpty(parametersJson))
                    {
                        var jsonSettings = new JsonSerializerSettings
                        {
                            TypeNameHandling = TypeNameHandling.None,
                            MetadataPropertyHandling = MetadataPropertyHandling.Ignore
                        };

                        var swaggerParams = JsonConvert.DeserializeObject<List<SwaggerParameter>>(parametersJson, jsonSettings);
                        List<Parameter> hostParamList = new List<Parameter>();
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
                            hostParamList.Add(parameter);
                        }

                        foreach (var method in serviceClient.Methods)
                        {
                            if (position.Equals("first", StringComparison.OrdinalIgnoreCase))
                            {
                                method.Parameters.InsertRange(0, hostParamList);
                            }
                            else
                            {
                                method.Parameters.AddRange(hostParamList);
                            }
                            
                        }
                        if (useSchemePrefix)
                        {
                            serviceClient.BaseUrl = string.Format(CultureInfo.InvariantCulture, "{0}://{1}{2}",
                                modeler.ServiceDefinition.Schemes[0].ToString().ToLowerInvariant(),
                                hostTemplate, modeler.ServiceDefinition.BasePath);
                        }
                        else
                        {
                            serviceClient.BaseUrl = string.Format(CultureInfo.InvariantCulture, "{0}{1}",
                                hostTemplate, modeler.ServiceDefinition.BasePath);
                        }
                        
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

        /// <summary>
        /// Ensures that global parameters that are tagged with x-ms-paramater-location: "method" are not client properties
        /// </summary>
        /// <param name="serviceClient"></param>
        public static void ProcessGlobalParameters(ServiceClient serviceClient)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            List<Property> propertiesToProcess = new List<Property>();
            foreach(var property in serviceClient.Properties)
            {
                if (property.Extensions.ContainsKey(ParameterLocationExtension) && property.Extensions[ParameterLocationExtension].ToString().Equals("method", StringComparison.OrdinalIgnoreCase))
                {
                    propertiesToProcess.Add(property);
                }
            }
            //set the clientProperty to null for such parameters in the method.
            foreach(var prop in propertiesToProcess)
            {
                serviceClient.Properties.Remove(prop);
                foreach(var method in serviceClient.Methods)
                {
                    foreach(var parameter in method.Parameters)
                    {
                        if (parameter.Name == prop.Name && parameter.IsClientProperty)
                        {
                            parameter.ClientProperty = null;
                        } 
                    }
                }
            }
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
            foreach (Property innerProperty in typeToFlatten.ComposedProperties)
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
                    p => p.Location == ParameterLocation.Body);

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

                            var documentationString = !string.IsNullOrEmpty(property.Summary) ? property.Summary + " " : string.Empty;
                            documentationString += property.Documentation;
                            newMethodParameter.Documentation = documentationString;

                            bodyParameter.Extensions.ForEach(kv => { newMethodParameter.Extensions[kv.Key] = kv.Value; });
                            method.Parameters.Add(newMethodParameter);

                            parameterTransformation.ParameterMappings.Add(new ParameterMapping
                            {
                                InputParameter = newMethodParameter,
                                OutputParameterProperty = property.GetClientName()
                            });
                        }

                        method.Parameters.Remove(bodyParameter);
                    }
                }
            }
        }
    }
}