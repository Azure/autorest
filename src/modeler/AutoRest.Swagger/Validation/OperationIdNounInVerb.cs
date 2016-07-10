// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Validation;
using System;
using System.Linq;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    public class OperationIdNounInVerb : TypedRule<string>
    {
        private const string NOUN_VERB_PATTERN = "^(\\w+)?_(\\w+)$";
        public override bool IsValid(string entity, out object[] formatParameters)
        {
            foreach (Match match in Regex.Matches(entity, NOUN_VERB_PATTERN))
            {
                if (match.Groups.Count != 3)
                {
                    throw new InvalidOperationException("Regex pattern does not conform to Noun_Verb pattern");
                }
                var noun = match.Groups[1].Value;
                var nounSearchPattern = noun + (noun.Last() == 's' ? "?" : string.Empty);
                var verb = match.Groups[2].Value;
                if (Regex.IsMatch(verb, nounSearchPattern))
                {
                    formatParameters = new string[] { noun };
                    return false;
                }
            }
            formatParameters = new object[] {};
            return true;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.OperationIdNounsNotInVerbs;
            }
        }
    }
}
