namespace Microsoft.Rest.Generator
{
    public enum ValidationException
    {
        DescriptionRequired = 1,
        OnlyJSONInResponse,
        OnlyJSONInRequest,
        RequiredPropertiesMustExist,
        OnlyOneBodyParameterAllowed,
        BodyMustHaveSchema,
        BodyMustNotHaveType,
        HeaderShouldHaveClientName,
        InvalidSchemaParameter,
        AResponseMustBeDefined,
        ClientNameMustNotBeEmpty,
        DefaultMustAppearInEnum,
        RefsMustNotHaveSiblings,
        PathParametersMustBeDefined,
        FormatMustExist,
        AnonymousTypesDiscouraged,
        OnlyOneUnderscoreInOperationId,
    }
}