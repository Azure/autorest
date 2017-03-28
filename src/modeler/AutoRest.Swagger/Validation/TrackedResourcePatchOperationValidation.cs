// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Properties;
using AutoRest.Core.Logging;
using AutoRest.Swagger.Model.Utilities;
using System.Collections.Generic;
using AutoRest.Swagger;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;
using System.Linq;
using AutoRest.Swagger.Validation.Core;

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

        // Verifies if a tracked resource has a corresponding PATCH operation
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            ServiceDefinition serviceDefinition = (ServiceDefinition)context.Root;
            // enumerate all the PATCH operations
            IEnumerable<Operation> patchOperations = ValidationUtilities.GetOperationsByRequestMethod("patch", serviceDefinition);

            // enumerate all the models returned by all PATCH operations (200/201 responses)
            var respModels = patchOperations.Select(op => op.Responses["200"]?.Schema?.Reference?.StripDefinitionPath());
            respModels.Union(patchOperations.Select(op => op.Responses["201"]?.Schema?.Reference?.StripDefinitionPath()));

            // find models that are not being returned by any of the PATCH operations
            var violatingModels = context.TrackedResourceModels.Except(respModels);

            foreach (var modelName in violatingModels)
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, modelName);
            }
        }
    }
}
