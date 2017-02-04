// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using Xunit;
using System.Collections.Generic;
using AutoRest.Core.Validation;
using AutoRest.Core.Logging;
using AutoRest.Core;
using AutoRest.Swagger.Validation;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swagger.Tests
{
    internal static class AssertExtensions
    {
        internal static void AssertOnlyValidationWarning(this IEnumerable<ValidationMessage> messages, Type validationType)
        {
            AssertOnlyValidationMessage(messages.Where(m => m.Severity == Category.Warning), validationType);
        }

        internal static void AssertOnlyValidationWarning(this IEnumerable<ValidationMessage> messages, Type validationType, int count)
        {
            AssertOnlyValidationMessage(messages.Where(m => m.Severity == Category.Warning), validationType, count);
        }
        internal static void AssertOnlyValidationMessage(this IEnumerable<ValidationMessage> messages, Type validationType)
        {
            // checks that the collection has one item, and that it is the correct message type.
            AssertOnlyValidationMessage(messages, validationType, 1);
        }

        internal static void AssertOnlyValidationMessage(this IEnumerable<ValidationMessage> messages, Type validationType, int count)
        {
            // checks that the collection has the right number of items and each is the correct type.
            Assert.Equal(count, messages.Count(message => message.Type == validationType));
        }
    }

    [Collection("Validation Tests")]
    public partial class SwaggerModelerValidationTests
    {
        private IEnumerable<ValidationMessage> ValidateSwagger(string input)
        {
            using (NewContext)
            {
                new Settings
                {
                    Namespace = "Test",
                    Input = input
                };
                var modeler = new SwaggerModeler();
                var messages = new List<LogMessage>();
                Logger.Instance.AddListener(new SignalingLogListener(Category.Info, messages.Add));
                modeler.Build();
                return messages.OfType<ValidationMessage>();
            }
        }

        [Fact]
        public void MissingDescriptionValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "definition-missing-description.json"));
            messages.AssertOnlyValidationMessage(typeof(ModelTypeIncomplete));
        }

        [Fact]
        public void AvoidMsdnReferencesValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "definition-contains-msdn-reference.json"));
            messages.AssertOnlyValidationMessage(typeof(AvoidMsdnReferences), 4);
        }

        [Fact]
        public void DefaultValueInEnumValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "default-value-not-in-enum.json"));

            messages.AssertOnlyValidationMessage(typeof(DefaultMustBeInEnum));
        }

        [Fact]
        public void EmptyClientNameValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "empty-client-name-extension.json"));
            messages.AssertOnlyValidationWarning(typeof(NonEmptyClientName));
        }

        [Fact]
        public void UniqueResourcePathsValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "network-interfaces-api.json"));
            messages.AssertOnlyValidationWarning(typeof(UniqueResourcePaths));
        }

        [Fact]
        public void AnonymousSchemasDiscouragedValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "anonymous-response-type.json"));
            messages.AssertOnlyValidationMessage(typeof(AvoidAnonymousTypes));
        }

        [Fact]
        public void AnonymousParameterSchemaValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "anonymous-parameter-type.json"));
            messages.AssertOnlyValidationMessage(typeof(AnonymousParameterTypes));
        }

        [Fact]
        public void OperationParametersValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "operations-invalid-parameters.json"));
            messages.AssertOnlyValidationMessage(typeof(OperationParametersValidation));
        }
        
        [Fact]
        public void ServiceDefinitionParametersValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "service-def-invalid-parameters.json"));
            messages.AssertOnlyValidationMessage(typeof(ServiceDefinitionParameters));
        }
        
        [Fact]
        public void OperationGroupSingleUnderscoreValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "operation-group-underscores.json"));
            messages.AssertOnlyValidationMessage(typeof(OneUnderscoreInOperationId));
        }


        [Fact]
        public void NonAppJsonTypeOperationForConsumes()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "non-app-json-operation-consumes.json"));
            messages.AssertOnlyValidationWarning(typeof(NonAppJsonTypeWarning));
        }

        [Fact]
        public void NonAppJsonTypeOperationForProduces()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "non-app-json-operation-produces.json"));
            messages.AssertOnlyValidationWarning(typeof(NonAppJsonTypeWarning));
        }

        [Fact]
        public void NonAppJsonTypeServiceDefinitionForProduces()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "non-app-json-service-def-produces.json"));
            messages.AssertOnlyValidationWarning(typeof(NonAppJsonTypeWarning));
        }

        [Fact]
        public void NonAppJsonTypeServiceDefinitionForConsumes()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "non-app-json-service-def-consumes.json"));
            messages.AssertOnlyValidationWarning(typeof(NonAppJsonTypeWarning));
        }

        [Fact]
        public void NonHttpsServiceDefinitionForScheme()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "non-https-service-def-scheme.json"));
            messages.AssertOnlyValidationWarning(typeof(SupportedSchemesWarning));
        }

        [Fact]
        public void NonHttpsOperationsForScheme()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "non-https-operations-scheme.json"));
            messages.AssertOnlyValidationWarning(typeof(SupportedSchemesWarning));
        }

        [Fact]
        public void NoResponsesValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "operations-no-responses.json"));
            messages.AssertOnlyValidationMessage(typeof(ResponseRequired));
        }

        [Fact]
        public void XmsPathNotInPathsValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "xms-path-not-in-paths.json"));
            messages.AssertOnlyValidationMessage(typeof(XmsPathsMustOverloadPaths));
        }

        [Fact]
        public void InvalidFormatValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "invalid-format.json"));
            messages.AssertOnlyValidationMessage(typeof(ValidFormats));
        }

        [Fact]
        public void ListOperationsNamingValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "list-operation-naming.json"));
            messages.AssertOnlyValidationMessage(typeof(ListOperationNamingWarning));
        }

        [Fact]
        public void ListByOperationsValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "listby-operations.json"));
            Assert.Equal(messages.Count(), 3);
            foreach (var message in messages)
            {
                Assert.True(message.Type == typeof(ListByOperationsValidation));
            }
        }

        [Fact]
        public void InvalidConstraintValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "swagger-validation.json"));
            messages.AssertOnlyValidationWarning(typeof(InvalidConstraint), 18);
        }

        [Fact]
        public void NestedPropertiesValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "nested-properties.json"));
            messages.AssertOnlyValidationMessage(typeof(AvoidNestedProperties));
        }

        [Fact]
        public void RequiredPropertiesValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "required-property-not-in-properties.json"));
            messages.AssertOnlyValidationMessage(typeof(RequiredPropertiesMustExist));
        }

        [Fact]
        public void OperationDescriptionValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "operation-missing-description.json"));
            messages.AssertOnlyValidationMessage(typeof(OperationDescriptionRequired));
        }

        [Fact]
        public void ParameterDescriptionValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "parameter-missing-description.json"));
            messages.AssertOnlyValidationMessage(typeof(ParameterDescriptionRequired));
        }

        [Fact]
        public void PageableNextLinkNotModeledValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "pageable-nextlink-not-modeled.json"));
            messages.AssertOnlyValidationMessage(typeof(NextLinkPropertyMustExist));
        }

        [Fact]
        public void Pageable200ResponseNotModeledValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "pageable-no-200-response.json"));
            messages.Any(m => m.Type == typeof(PageableRequires200Response));
        }

        [Fact]
        public void OperationNameValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "operation-name-not-valid.json"));
            messages.AssertOnlyValidationMessage(typeof(OperationNameValidation), 3);
        }

        [Fact]
        public void LongRunningResponseForPutValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "long-running-invalid-response-put.json"));
            messages.AssertOnlyValidationMessage(typeof(LongRunningResponseValidation));
        }

        [Fact]
        public void LongRunningResponseForPostValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "long-running-invalid-response-post.json"));
            messages.AssertOnlyValidationMessage(typeof(LongRunningResponseValidation));
        }

        [Fact]
        public void LongRunningResponseForDeleteValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "long-running-invalid-response-delete.json"));
            messages.AssertOnlyValidationMessage(typeof(LongRunningResponseValidation));
        }

        [Fact]
        public void MutabilityNotModeledValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "mutability-invalid-values.json"));
            messages.AssertOnlyValidationMessage(typeof(MutabilityValidValuesRule), 2);
        }

        [Fact]
        public void MutabilityNotModeledWithReadOnlyValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "mutability-invalid-values-for-readonly.json"));
            messages.AssertOnlyValidationMessage(typeof(MutabilityWithReadOnlyRule), 2);
        }

        [Fact]
        public void VersionFormatValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-version-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(APIVersionPattern), 1);
        }

        [Fact]
        public void GuidUsageValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-guid-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(GuidValidation), 1);
        }

        [Fact]
        public void DeleteRequestBodyValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-delete-request-body-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(DeleteMustHaveEmptyRequestBody), 1);
        }

        [Fact]
        public void ResourceExtensionValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-ext-msresource-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(ResourceIsMsResourceValidation), 1);
        }

        [Fact]
        public void MsClientNameExtensionValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-ext-msclientname-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(XmsClientNameValidation), 1);
        }

        [Fact]
        public void OperationsApiValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-operations-api-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(OperationsAPIImplementationValidation), 1);
        }

        [Fact]
        public void ResourceModelValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-ext-resource-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(ResourceModelValidation), 1);
        }

        [Fact]
        public void SkuModelValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-skumodel-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(SkuModelValidation), 1);
        }

        [Fact]
        public void TrackedResource1Validation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-tracked-resource-1-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourceValidation), 1);
        }

        [Fact]
        public void TrackedResource2Validation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-tracked-resource-2-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourceValidation), 1);
        }

        [Fact]
        public void TrackedResource3Validation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-tracked-resource-3-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourceValidation), 1);
        }

        [Fact]
        public void TrackedResource4Validation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-tracked-resource-4-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourceValidation), 1);
        }

        [Fact]
        public void PutGetPatchResponseValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "swagger-putgetpatch-response-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(PutGetPatchResponseValidation), 1);
        }
    }

    #region Positive tests

    public partial class SwaggerModelerValidationTests
    {
        /// <summary>
        /// Verifies that a clean Swagger file does not result in any validation errors
        /// </summary>
        [Fact]
        public void CleanFileValidation()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "positive", "clean-complex-spec.json"));
            Assert.Empty(messages.Where(m => m.Severity >= Category.Warning));
        }

        /// <summary>
        /// Verifies that a clean Swagger file does not result in any validation errors
        /// </summary>
        [Fact]
        public void RequiredPropertyDefinedAllOf()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "positive", "required-property-defined-allof.json"));
            Assert.Empty(messages.Where(m => m.Severity >= Category.Warning));
        }

        /// <summary>
        /// Verifies that a clean Swagger file does not result in any validation errors
        /// </summary>
        [Fact]
        public void PageableNextLinkDefinedAllOf()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "positive", "pageable-nextlink-defined-allof.json"));
            Assert.Empty(messages.Where(m => m.Severity >= Category.Warning));
        }

        /// <summary>
        /// Verifies that a x-ms-long-running extension response modeled correctly
        /// </summary>
        [Fact]
        public void LongRunningResponseDefined()
        {
            var messages = ValidateSwagger(Path.Combine("Swagger", "Validation", "positive", "long-running-valid-response.json"));
            messages.AssertOnlyValidationMessage(typeof(LongRunningResponseValidation), 0);
        }
    }

    #endregion
}