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
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Operation> operationDefinition, RuleContext context)
        {
            var serviceDefinition = (ServiceDefinition)context.Root;
            foreach (string httpVerb in operationDefinition.Keys)
            {
                if (httpVerb.ToLower().Equals("delete"))
                {
                    Operation operation = operationDefinition.GetValueOrNull(httpVerb);
                    
                    if (operation?.Parameters == null)
                        continue;

                    foreach(SwaggerParameter parameter in operation.Parameters)
                    {
                        if (parameter.In == ParameterLocation.Body)
                        {
                            yield return new ValidationMessage(new FileObjectPath(context.File,
                                    context.Path.AppendProperty(httpVerb).AppendProperty("parameters").AppendIndex(operation.Parameters.IndexOf(parameter))), this, operation.OperationId);
                        }
                        else if (serviceDefinition.Parameters.ContainsKey(parameter.Reference?.StripParameterPath()??string.Empty))
                        {
                            if (serviceDefinition.Parameters[parameter.Reference.StripParameterPath()].In == ParameterLocation.Body)
                            {
                                yield return new ValidationMessage(new FileObjectPath(context.File,
                                    context.Path.AppendProperty(httpVerb).AppendProperty("parameters").AppendIndex(operation.Parameters.IndexOf(parameter))), this, operation.OperationId);
                            }
                        }
                    }
                }
            }
        }
    }
}
