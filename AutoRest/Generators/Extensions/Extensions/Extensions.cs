// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
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

        /// <summary>
        /// Normalizes client model using generic extensions.
        /// </summary>
        /// <param name="serviceClient">Service client</param>
        /// <param name="settings">AutoRest settings</param>
        /// <returns></returns>
        public static void NormalizeClientModel(ServiceClient serviceClient, Settings settings)
        {
            FlattenRequestPayload(serviceClient, settings);
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