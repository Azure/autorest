// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    public class OperationIdNounConflictingModelNames : TypedRule<string>
    {
        private readonly Regex NounVerbPattern = new Regex("^(?<noun>\\w+)?_(\\w+)$");

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2063";

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
        /// Check if the noun part of an operationId (Noun_Verb) conflicts with any model names provided in the spec
        /// </summary>
        /// <param name="entity">The operation id to test</param>
        /// <param name="formatParameters">The noun to be put in the failure message</param>
        /// <returns></returns>
        public override bool IsValid(string entity, RuleContext context, out object[] formatParameters)
        {
            var match = NounVerbPattern.Match(entity);
            formatParameters = new object[] { };

            // if operationId does not match the pattern, return true and let some other validation handle it
            if (!match.Success)
            {
                return true;
            }

            // Get the noun and verb parts of the operation id
            var noun = match.Groups["noun"].Value;

            var serviceDefinition = (ServiceDefinition)context.Root;
            if (serviceDefinition.Definitions.Keys.Any(key => key.ToLower().Equals(noun.ToLower())))
            {
                formatParameters = new object[] { noun, noun };
                return false;
            }

            return true;
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.OperationIdNounConflictingModelNamesMessage;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

    }
}
