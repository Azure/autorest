// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates if there is no request body for the delete operation.
    /// </summary>
    public class DeleteMustNotHaveRequestBody : TypedRule<Dictionary<string, Operation>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3013";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// What kind of breaking change implementing this rule can cause.
        /// </summary>
        public virtual ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.ServiceBreakingChanges;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.DeleteMustNotHaveRequestBody;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// An <paramref name="operationDefinition"/> fails this rule if delete operation has a request body.
        /// </summary>
        /// <param name="operationDefinition">Operation Definition to validate</param>
        /// <returns>true if delete operation does not have a request body. false otherwise.</returns>
        public override bool IsValid(Dictionary<string, Operation> operationDefinition, RuleContext context)
        {
            foreach (string httpVerb in operationDefinition.Keys)
            {
                if (httpVerb.ToLower().Equals("delete"))
                {
                    Operation operation = operationDefinition.GetValueOrNull(httpVerb);
                    if (operation == null)
                        return false;

                    if (operation.Parameters == null)
                        continue;

                    foreach(SwaggerParameter parameter in operation.Parameters)
                    {
                        if(parameter.Reference == null)
                        {
                            if(parameter.In == ParameterLocation.Body)
                            {
                                return false;
                            }
                        }
                        else
                        {
                            if (context == null || context.Root == null)
                            {
                                return false;
                            }

                            if(this.GetParameterLocation(parameter, (ServiceDefinition)context.Root) == ParameterLocation.Body)
                            {
                                return false;
                            }
                        }
                    }
                }
            }

            return true;
        }

        private ParameterLocation GetParameterLocation(SwaggerParameter parameter, ServiceDefinition serviceDefinition)
        {
            string parameterReference = parameter.Reference;
            if(parameterReference.StartsWith("#/parameters/"))
            {
                string[] splitArray = parameterReference.Split('/');
                SwaggerParameter parameterValue = serviceDefinition.Parameters.GetValueOrNull(splitArray[splitArray.Length - 1].Trim());
                if (parameterValue != null)
                {
                    return parameterValue.In;
                }
            }
            return ParameterLocation.None;
        }
    }
}
