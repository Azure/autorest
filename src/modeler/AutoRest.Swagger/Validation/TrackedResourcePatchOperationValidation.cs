// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Properties;
using AutoRest.Core.Logging;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model.Utilities;
using System.Collections.Generic;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;
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

        // Verifies if a tracked resource has a corresponding patch operation
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            var servDef = (ServiceDefinition)context.Root;
            IEnumerable<Operation> patchOperations = ValidationUtilities.GetOperationsByRequestMethod("patch", servDef);
            var respDefinitions = servDef.Paths.Concat(servDef.CustomPaths).SelectMany(pathPair => pathPair.Value.Select(pathObj => pathObj.Value.Responses["200"]?.Schema?.Reference?.StripDefinitionPath())).Distinct();
            foreach (KeyValuePair<string, Schema> definition in definitions)
            {
                if (respDefinitions.Contains(definition.Key) && ValidationUtilities.IsTrackedResource(definition.Value, definitions))
                {
                    if(!patchOperations.Any(op => (op.Responses["200"].Schema?.Reference?.StripDefinitionPath()) == definition.Key))
                    {
                        // if no patch operation returns current tracked resource as a response, 
                        // the tracked resource does not have a corresponding patch operation
                        yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, definition.Key.StripDefinitionPath());
                    }
                }
            }
        }
    }
}
