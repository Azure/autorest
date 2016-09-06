using AutoRest.Core.Validation;

namespace AutoRest.Swagger.Validation
{
    public static class ComparisonMessages
    {
        public static MessageTemplate VersionsReversed = new MessageTemplate { Id = 1000, Message = "The new version has a lower value than the old: {0} -> {1}" };

        public static MessageTemplate NoVersionChange = new MessageTemplate { Id = 1001, Message = "The versions have not changed." };

        public static MessageTemplate ProtocolNoLongerSupported = new MessageTemplate { Id = 1002, Message = "The new version does not support '{0}' as a protocol." };

        public static MessageTemplate RequestBodyFormatNoLongerSupported = new MessageTemplate { Id = 1003, Message = "The new version does not support '{0}' as a request body format." };

        public static MessageTemplate ResponseBodyFormatNowSupported = new MessageTemplate { Id = 1004, Message = "The old version did not support '{0}' as a response body format." };

        public static MessageTemplate RemovedPath = new MessageTemplate { Id = 1005, Message = "The new version is missing a path that was found in the old version. Was '{0}' removed or restructured?" };

        public static MessageTemplate RemovedDefinition = new MessageTemplate { Id = 1006, Message = "The new version is missing a definition that was found in the old version. Was '{0}' removed or renamed?" };

        public static MessageTemplate RemovedClientParameter = new MessageTemplate { Id = 1007, Message = "The new version is missing a client parameter that was found in the old version. Was '{0}' removed or renamed?" };

        public static MessageTemplate ModifiedOperationId = new MessageTemplate { Id = 1008, Message = "The operation id has been changed. This will impact generated code." };

        public static MessageTemplate RemovedRequiredParameter = new MessageTemplate { Id = 1009, Message = "The required parameter '{0}' was removed." };

        public static MessageTemplate AddingRequiredParameter = new MessageTemplate { Id = 1010, Message = "The new version adds a required parameter '{0}'." };

        public static MessageTemplate AddingResponseCode = new MessageTemplate { Id = 1011, Message = "The new version adds a response code '{0}'" };

        public static MessageTemplate RemovedResponseCode = new MessageTemplate { Id = 1012, Message = "The new version removes the response code '{0}'" };

        public static MessageTemplate AddingHeader = new MessageTemplate { Id = 1013, Message = "Adding a required header '{0}'." };

        public static MessageTemplate RemovingHeader = new MessageTemplate { Id = 1014, Message = "Removing a required header '{0}'." };

        public static MessageTemplate ParameterInHasChanged = new MessageTemplate { Id = 1015, Message = "How the parameter is passed has changed -- it used to be '{0}', now it is '{1}'" };

        public static MessageTemplate ConstantStatusHasChanged = new MessageTemplate { Id = 1016, Message = "The 'constant' status changed from the old version to the new" };

        public static MessageTemplate ReferenceRedirection = new MessageTemplate { Id = 1017, Message = "The '$ref' property points to different models in the old and new versions" };

        public static MessageTemplate RemovedEnumValues = new MessageTemplate { Id = 1018, Message = "The new version does not specify a list of valid values" };
        public static MessageTemplate RemovedEnumValue = new MessageTemplate { Id = 1019, Message = "The new version does not include some of the previous values in its list of valid values" };
        public static MessageTemplate AddedEnumValues = new MessageTemplate { Id = 1020, Message = "The new version places constraints on valid values while the old doesn't" };
        public static MessageTemplate AddedAdditionalProperties = new MessageTemplate { Id = 1021, Message = "The new version adds an 'additionalProperties' element" };
        public static MessageTemplate RemovedAdditionalProperties = new MessageTemplate { Id = 1022, Message = "The new version removes the 'additionalProperties' element" };
        public static MessageTemplate TypeFormatChanged = new MessageTemplate { Id = 1023, Message = "The new version has a different format than the previous one" };

        public static MessageTemplate ConstraintIsStronger = new MessageTemplate { Id = 1024, Message = "The new version has a more constraining '{0}' value than the previous one" };

        public static MessageTemplate RequiredStatusChange = new MessageTemplate { Id = 1025, Message = "The 'required' status changed from the old version to the new" };
        public static MessageTemplate TypeChanged = new MessageTemplate { Id = 1026, Message = "The new version has a different type than the previous one" };
        public static MessageTemplate DefaultValueChanged = new MessageTemplate { Id = 1027, Message = "The new version has a different default value than the previous one" };
        public static MessageTemplate ArrayCollectionFormatChanged = new MessageTemplate { Id = 1028, Message = "The new version has a different array collection format than the previous one" };

        public static MessageTemplate ReadonlyPropertyChanged2 = new MessageTemplate { Id = 1029, Message = "The read only property has changed from '{0}' to '{1}'." };
        public static MessageTemplate DifferentDiscriminator = new MessageTemplate { Id = 1030, Message = "The new version has a different discriminator than the previous one" };
        public static MessageTemplate DifferentExtends = new MessageTemplate { Id = 1031, Message = "The new version has a different 'extends' property than the previous one" };
        public static MessageTemplate DifferentAllOf = new MessageTemplate { Id = 1032, Message = "The new version has a different 'allOf' property than the previous one" };
        public static MessageTemplate RemovedProperty1 = new MessageTemplate { Id = 1033, Message = "The new version is missing a property found in the old version. Was '{0}' renamed or removed?" };
        public static MessageTemplate AddedRequiredProperty1 = new MessageTemplate { Id = 1034, Message = "The new version has a new required property '{0}' not found in the old version" };

        public static MessageTemplate RemovedOperation = new MessageTemplate { Id = 1035, Message = "The new version is misting an operation that was found in the old version. Was '{0}' removed or restructured?" };

        public static MessageTemplate ConstraintChanged = new MessageTemplate { Id = 1036, Message = "The new version has a different '{0}' value than the previous one" };

        public static MessageTemplate ConstraintIsWeaker = new MessageTemplate { Id = 1037, Message = "The new version has a less constraining '{0}' value than the previous one" };
    }
}
