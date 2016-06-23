namespace Microsoft.Rest.Generators.Validation
{
    public enum ValidationException
    {
        MissingDescription = 1,
        OnlyJSONInResponse,
        OnlyJSONInRequest,
        MissingRequiredProperty,
        TooManyBodyParameters,
        BodyMustHaveSchema,
        BodyWithType,
        HeaderShouldHaveClientName,
        InvalidSchemaParameter,
        NoResponses,
        EmptyClientName,
        InvalidDefault,
    }
}