// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using System;
using System.Linq;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;

namespace AutoRest.Swagger.Validation
{
    public class OperationIdNounInVerb : TypedRule<string>
    {
        private const string NOUN_VERB_PATTERN = "^(\\w+)?_(\\w+)$";

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
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

    }
}
