﻿// Copyright (c) Microsoft Corporation. All rights reserved.
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
        public override string Id => "R3013";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.ServiceImpactingChanges;

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
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// Whether the rule should be applied to the individual or composed context based on
        /// the corresponding .md file
        /// In most cases this should be composed
        /// This is because validation rules that run in individual mode will end up
        /// throwing multiple validation messages for the same violation if related model/property,etc 
        /// was referenced in multiple files
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Individual;

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
