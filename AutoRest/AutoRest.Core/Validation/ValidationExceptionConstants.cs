using System.Collections.Generic;
using Microsoft.Rest.Generator.Properties;

namespace Microsoft.Rest.Generator
{
    public static class ValidationExceptionConstants
    {
        public static class Info
        {
            public static readonly IReadOnlyDictionary<ValidationExceptionNames, string> Messages = new Dictionary<ValidationExceptionNames, string>
            {
                { ValidationExceptionNames.AnonymousTypesDiscouraged, Resources.AnonymousTypesDiscouraged },
            };
        }

        public static class Warnings
        {
            public static readonly IReadOnlyDictionary<ValidationExceptionNames, string> Messages = new Dictionary<ValidationExceptionNames, string>
            {
                { ValidationExceptionNames.DescriptionRequired, Resources.MissingDescription },
                { ValidationExceptionNames.OnlyJsonInRequest, Resources.OnlyJSONInRequests1 },
                { ValidationExceptionNames.OnlyJsonInResponse, Resources.OnlyJSONInResponses1 },
                { ValidationExceptionNames.HeaderShouldHaveClientName, Resources.HeaderShouldHaveClientName },
                { ValidationExceptionNames.InvalidSchemaParameter, Resources.InvalidSchemaParameter },
                { ValidationExceptionNames.ClientNameMustNotBeEmpty, Resources.EmptyClientName },
                { ValidationExceptionNames.RefsMustNotHaveSiblings, Resources.ConflictingRef },
                { ValidationExceptionNames.FormatMustExist, Resources.InvalidTypeFormatCombination },
            };
        }

        public static class Errors
        {
            public static readonly IReadOnlyDictionary<ValidationExceptionNames, string> Messages = new Dictionary<ValidationExceptionNames, string>
            {
                { ValidationExceptionNames.RequiredPropertiesMustExist, Resources.MissingRequiredProperty },
                { ValidationExceptionNames.OnlyOneBodyParameterAllowed, Resources.TooManyBodyParameters1 },
                { ValidationExceptionNames.BodyMustHaveSchema, Resources.BodyMustHaveSchema },
                { ValidationExceptionNames.BodyMustNotHaveType, Resources.BodyWithType },
                { ValidationExceptionNames.AResponseMustBeDefined, Resources.NoResponses },
                { ValidationExceptionNames.DefaultMustAppearInEnum, Resources.InvalidDefault },
                { ValidationExceptionNames.PathParametersMustBeDefined, Resources.NoDefinitionForPathParameter1 },
                { ValidationExceptionNames.OnlyOneUnderscoreInOperationId, Resources.OnlyOneUnderscoreAllowedInOperationId },
            };
        }
    }
}
