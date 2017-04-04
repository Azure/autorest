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

        /// <summary>
        /// Verifies if a tracked resource has a corresponding patch operation
        /// </summary>
        /// <param name="definitions"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            // Retrieve the list of TrackedResources
            IEnumerable<string> trackedResources = context.TrackedResourceModels;

            // Retrieve the list of getOperations
            IEnumerable<Operation> patchOperations = ValidationUtilities.GetOperationsByRequestMethod("patch", context.Root);

            foreach (string trackedResource in trackedResources)
            {
                // check for 200 status response models since they correspond to a successful get operation
                if (!patchOperations.Any(op => op.Responses.ContainsKey("200") && (op.Responses["200"]?.Schema?.Reference?.StripDefinitionPath()).Equals(trackedResource)))
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(trackedResource)), this, trackedResource);
                }
            }
        }
    }
}
