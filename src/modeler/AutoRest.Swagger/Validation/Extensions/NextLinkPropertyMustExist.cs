// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using Newtonsoft.Json.Linq;

namespace AutoRest.Swagger.Validation
{
    public class NextLinkPropertyMustExist : PageableExtensionRule
    {
        private const string ExtensionNextLinkPropertyName = "nextLinkName";

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2025";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// When to apply the validation rule, before or after it has been merged as a part of 
        /// its merged document as specified in the corresponding '.md' file
        /// By default consider all rules to be applied for After only
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Individual;

        /// <summary>
        /// An x-ms-pageable extension passes this rule if the value for nextLinkName refers to a string property
        /// that exists on the schema for the 200 response of the parent operation.
        /// </summary>
        /// <param name="pageable"></param>
        /// <param name="context"></param>
        /// <param name="formatParameters"></param>
        /// <returns></returns>
        public override bool IsValid(object pageable, RuleContext context, out object[] formatParameters)
        {
            // Get the name of the property defined by nextLinkName in the spec
            var nextLinkPropertyName = (pageable as JContainer)?[ExtensionNextLinkPropertyName]?.ToString();
            if (!string.IsNullOrEmpty(nextLinkPropertyName))
            {
                var schema = Get200ResponseSchema(context);
                var serviceDefinition = context.GetServiceDefinition();
                // Try to find the property in this schema or its ancestors
                if (schema.FindPropertyInChain(serviceDefinition, nextLinkPropertyName) == null)
                {
                    formatParameters = new string[] { nextLinkPropertyName };
                    return false;
                }
            }
            formatParameters = new string[0];
            return true;
        }

        /// <summary>
        /// The template message for this Rule.
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "The property '{0}' specified by nextLinkName does not exist in the 200 response schema. \nPlease, specify the name of the property that provides the nextLink. If the model does not have the nextLink property then specify null.";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;
    }
}
