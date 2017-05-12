// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;
using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class TrackedResourcePatchOperationValidation : TypedRule<Dictionary<string, Schema>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3026";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.NonBreakingServiceChanges;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.TrackedResourcePatchOperationMissing;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// Verifies if a tracked resource has a corresponding patch operation
        /// </summary>
        /// <param name="definitions"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            ServiceDefinition serviceDefinition = (ServiceDefinition)context.Root;
            // enumerate all the PATCH operations
            IEnumerable<Operation> patchOperations = ValidationUtilities.GetOperationsByRequestMethod("patch", serviceDefinition);

            // enumerate all the models returned by all PATCH operations (200/201 responses)
            var respModels = patchOperations.Select(op => op.Responses.GetValueOrNull("200")?.Schema?.Reference?.StripDefinitionPath());
            respModels.Union(patchOperations.Select(op => op.Responses.GetValueOrNull("201")?.Schema?.Reference?.StripDefinitionPath())).Where(modelName => !string.IsNullOrEmpty(modelName));

            // find models that are not being returned by any of the PATCH operations
            var violatingModels = context.TrackedResourceModels.Except(respModels);

            foreach (var modelName in violatingModels)
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(modelName)), this, modelName);
            }
        }
    }
}
