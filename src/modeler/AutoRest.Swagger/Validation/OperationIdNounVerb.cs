// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class OperationIdNounVerb : TypedRule<string>
    {
        private const string NOUN_VERB_PATTERN = "^(\\w+)?_(\\w+)$";

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R1001";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;


        /// <summary>
        /// The rule runs on each operation in isolation irrespective of the state and can be run in individual state
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Individual;

        /// <summary>
        /// This rule passes if the operation id doesn't contain a repeated value before and after the underscore
        ///   e.g. User_GetUser
        ///     or Users_DeleteUser
        ///     or User_ListUsers
        /// </summary>
        /// <param name="entity">The operation id to test</param>
        /// <param name="formatParameters">The noun to be put in the failure message</param>
        /// <returns></returns>
        public override bool IsValid(string entity, RuleContext context, out object[] formatParameters)
        {
            foreach (Match match in Regex.Matches(entity, NOUN_VERB_PATTERN))
            {
                if (match.Groups.Count != 3)
                {
                    // If we don't have 3 groups, then the regex has been changed from capturing [{Match}, {Noun}, {Verb}].
                    throw new InvalidOperationException("Regex pattern does not conform to Noun_Verb pattern");
                }

                // Get the noun and verb parts of the operation id
                var noun = match.Groups[1].Value;
                var verb = match.Groups[2].Value;

                // The noun is sometimes singlular or plural, but we want to catch the other versions in the verb as well
                var nounSearchPattern = noun + (noun.Last() == 's' ? "?" : string.Empty);
                if (Regex.IsMatch(verb, nounSearchPattern))
                {
                    formatParameters = new object[] { noun };
                    return false;
                }
            }
            formatParameters = new object[] {};
            return true;
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.OperationIdNounInVerb;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

    }
}
