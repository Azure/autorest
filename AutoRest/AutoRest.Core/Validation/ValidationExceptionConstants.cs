using Microsoft.Rest.Generators.Validation;
using System.Collections.Generic;
using Microsoft.Rest.Generator.Properties;

namespace Microsoft.Rest.Generator.Validation
{
    public static class ValidationExceptionConstants
    {
        public static class Info
        {
            public static readonly IDictionary<ValidationException, string> Messages = new Dictionary<ValidationException, string>
            {
                { ValidationException.AnonymousTypesDiscouraged, Resources.AnonymousTypesDiscouraged },
            };
        }

        public static class Warnings
        {
            public static readonly IDictionary<ValidationException, string> Messages = new Dictionary<ValidationException, string>
            {
                { ValidationException.DescriptionRequired, Resources.MissingDescription },
                { ValidationException.OnlyJSONInRequest, Resources.OnlyJSONInRequests1 },
                { ValidationException.OnlyJSONInResponse, Resources.OnlyJSONInResponses1 },
                { ValidationException.HeaderShouldHaveClientName, Resources.HeaderShouldHaveClientName },
                { ValidationException.InvalidSchemaParameter, Resources.InvalidSchemaParameter },
                { ValidationException.ClientNameMustNotBeEmpty, Resources.EmptyClientName },
                { ValidationException.RefsMustNotHaveSiblings, Resources.ConflictingRef },
                { ValidationException.FormatMustExist, Resources.InvalidTypeFormatCombination },
            };
        }

        public static class Errors
        {
            public static readonly IDictionary<ValidationException, string> Messages = new Dictionary<ValidationException, string>
            {
                { ValidationException.RequiredPropertiesMustExist, Resources.MissingRequiredProperty },
                { ValidationException.OnlyOneBodyParameterAllowed, Resources.TooManyBodyParameters1 },
                { ValidationException.BodyMustHaveSchema, Resources.BodyMustHaveSchema },
                { ValidationException.BodyMustNotHaveType, Resources.BodyWithType },
                { ValidationException.AResponseMustBeDefined, Resources.NoResponses },
                { ValidationException.DefaultMustAppearInEnum, Resources.InvalidDefault },
                { ValidationException.PathParametersMustBeDefined, Resources.NoDefinitionForPathParameter1 },
                { ValidationException.OnlyOneUnderscoreInOperationId, Resources.OnlyOneUnderscoreAllowedInOperationId },
            };
        }
    }
}
