// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates if the response of Put/Get/Patch are same.
    /// </summary>
    public class PutGetPatchResponseSchema : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R3007";

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
        public override string MessageTemplate => Resources.PutGetPatchResponseInvalid;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// When to apply the validation rule, before or after it has been merged as a part of 
        /// its merged document as specified in the corresponding '.md' file
        /// By default consider all rules to be applied for After only
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        private static readonly IEnumerable<string> OpList = new List<string>() { "put", "get", "patch" };


        /// <summary>
        /// Validates if the response of Put/Get/Patch are same.
        /// </summary>
        /// <param name="entity">paths to validate</param>
        /// <param name="context">The rule context</param>
        /// <returns>list of ValidationMessages.</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> entity, RuleContext context)
        {
            var serviceDefinition = (ServiceDefinition)context.Root;
            foreach (var pathPair in entity)
            {
                var respModels = pathPair.Value.Where(opPair => OpList.Contains(opPair.Key.ToLower()))
                                                // exclude list operations here?
                                               .Where(opPair=>!opPair.Value.OperationId.ToLower().Contains("_list"))
                                               .Select(opPair => opPair.Value.Responses?.GetValueOrNull<OperationResponse>("200")?.Schema?.Reference)
                                               .Where(respModel => !string.IsNullOrWhiteSpace(respModel) && serviceDefinition.Definitions.ContainsKey(respModel.StripDefinitionPath()))
                                               .Distinct();
                if (respModels.Count() > 1)
                {
                    // more than one model referenced by get/put/patch operations under a path, must be flagged
                    yield return new ValidationMessage(
                        new FileObjectPath(context.File, context.Path.AppendProperty(pathPair.Key)), this, pathPair.Key);

                }
            }
        }
    }
}
