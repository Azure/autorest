using Microsoft.Rest.Generator;
using System;
using System.Linq;
using System.Text.RegularExpressions;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class OperationIdNounInVerb : TypedRule<string>
    {
        private const string NOUN_VERB_PATTERN = "^(\\w+)s?_(\\w+)$";
        public override bool IsValid(string entity, out object[] formatParameters)
        {
            foreach (Match match in Regex.Matches(entity, NOUN_VERB_PATTERN))
            {
                if (match.Groups.Count != 3)
                {
                    throw new InvalidOperationException("Regex pattern does not conform to Noun_Verb pattern");
                }
                var noun = match.Groups[1].Value;
                var verb = match.Groups[2].Value;
                if (Regex.IsMatch(verb, noun + "s?"))
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
                return ValidationExceptionName.OperationIdNounsShouldNotAppearInVerb;
            }
        }
    }
}
