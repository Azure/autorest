// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

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
        public const string ParameterGroupExtension = "x-ms-parameter-grouping";
        
        /// <summary>
        /// Normalizes client model using generic extensions.
        /// </summary>
        /// <param name="serviceClient">Service client</param>
        /// <param name="settings">AutoRest settings</param>
        /// <returns></returns>
        public static void NormalizeClientModel(ServiceClient serviceClient, Settings settings)
        {
            FlattenRequestPayload(serviceClient, settings);
            AddParameterGroups(serviceClient);
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
                //This group name is normalized by each languages code generator later, so it need not happen here.
                Dictionary<string, Dictionary<Property, Parameter>> parameterGroups = new Dictionary<string, Dictionary<Property, Parameter>>();

                foreach (Parameter parameter in method.Parameters)
                {
                    if (parameter.Extensions.ContainsKey(ParameterGroupExtension))
                    {
                        Newtonsoft.Json.Linq.JContainer extensionObject = parameter.Extensions[ParameterGroupExtension] as Newtonsoft.Json.Linq.JContainer;
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

                            parameterGroups[parameterGroupName].Add(groupProperty, parameter);
                        }
                    }
                }

                foreach (string parameterGroupName in parameterGroups.Keys)
                {
                    CompositeType parameterGroupType =
                        generatedParameterGroups.FirstOrDefault(item => item.Name == parameterGroupName);
                    bool createdNewCompositeType = false;
                    if (parameterGroupType == null)
                    {
                        parameterGroupType = new CompositeType()
                        {
                            Name = parameterGroupName,
                            Documentation = "Additional parameters for the " + method.Name + " operation."
                        };
                        generatedParameterGroups.Add(parameterGroupType);

                        //Populate the parameter group type with properties.

                        //Add to the service client
                        serviceClient.ModelTypes.Add(parameterGroupType);
                        createdNewCompositeType = true;
                    }

                    foreach (Property property in parameterGroups[parameterGroupName].Keys)
                    {
                        //Either the paramter group is "empty" since it is new, or it is "full" and we don't allow different schemas
                        if (createdNewCompositeType)
                        {
                            parameterGroupType.Properties.Add(property);
                        }
                        else
                        {
                            Property matchingProperty = parameterGroupType.Properties.FirstOrDefault(
                                item => item.Name == property.Name &&
                                        item.IsReadOnly == property.IsReadOnly &&
                                        item.DefaultValue == property.DefaultValue &&
                                        item.SerializedName == property.SerializedName);

                            if (matchingProperty == null)
                            {
                                throw new ArgumentException(string.Format(CultureInfo.CurrentCulture, "Property {0} was specified on group {1} but it is not on shared parameter group object {2}",
                                    property.Name, method.Name, parameterGroupType.Name));
                            }
                        }
                    }

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
        /// Flattens the request payload if the number of properties of the 
        /// payload is less than or equal to the PayloadFlatteningThreshold.
        /// </summary>
        /// <param name="serviceClient">Service client</param>                            
        /// <param name="settings">AutoRest settings</param>                            
        public static void FlattenRequestPayload(ServiceClient serviceClient, Settings settings)
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
                    if (bodyParameterType != null && bodyParameterType.ComposedProperties.Count() <= settings.PayloadFlatteningThreshold)
                    {
                        var parameterTransformation = new ParameterTransformation
                        {
                            OutputParameter = bodyParameter
                        };
                        method.InputParameterTransformation.Add(parameterTransformation);

                        foreach (var property in bodyParameterType.ComposedProperties)
                        {
                            var newMethodParameter = new Parameter();
                            newMethodParameter.LoadFrom(property);
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