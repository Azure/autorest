// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using Xunit;
using System.Collections.Generic;
using AutoRest.Swagger.Validation.Core;
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
            Assert.Equal(count, messages.Count(message => message.Rule.GetType() == validationType));
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
                    CodeGenerator = "None",
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
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "definition-missing-description.json"));
            messages.AssertOnlyValidationMessage(typeof(DescriptionMissing), 2);
        }

        [Fact]
        public void AvoidMsdnReferencesValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "definition-contains-msdn-reference.json"));
            messages.AssertOnlyValidationMessage(typeof(AvoidMsdnReferences), 4);
        }

        [Fact]
        public void BooleanPropertiesValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "boolean-properties.json"));

            messages.AssertOnlyValidationMessage(typeof(BooleanPropertyNotRecommended), 4);
        }

        [Fact]
        public void DefaultValueInEnumValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "default-value-not-in-enum.json"));

            messages.AssertOnlyValidationMessage(typeof(DefaultMustBeInEnum));
        }

        [Fact]
        public void EmptyClientNameValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "empty-client-name-extension.json"));
            messages.AssertOnlyValidationMessage(typeof(NonEmptyClientName));
        }

        [Fact]
        public void UniqueResourcePathsValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "network-interfaces-api.json"));
            messages.AssertOnlyValidationMessage(typeof(UniqueResourcePaths));
        }

        [Fact]
        public void AnonymousSchemasDiscouragedValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "anonymous-response-type.json"));
            messages.AssertOnlyValidationMessage(typeof(AvoidAnonymousTypes));
        }

        [Fact]
        public void AnonymousParameterSchemaValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "anonymous-parameter-type.json"));
            messages.AssertOnlyValidationMessage(typeof(AnonymousBodyParameter));
        }

        [Fact]
        public void OperationParametersValidation()
        {
            // ignore ServiceDefinitionParameters validation rule since it overlaps with this
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "operations-invalid-parameters.json"))
                            .Where(msg => msg.Rule.GetType().Name != "ServiceDefinitionParameters");
            messages.AssertOnlyValidationMessage(typeof(OperationParametersValidation), 2);
        }

        [Fact]
        public void ServiceDefinitionParametersValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "service-def-invalid-parameters.json"));
            messages.AssertOnlyValidationMessage(typeof(ServiceDefinitionParameters), 2);
        }

        [Fact]
        public void OperationGroupSingleUnderscoreValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "operation-group-underscores.json"));
            messages.AssertOnlyValidationMessage(typeof(OneUnderscoreInOperationId));
        }


        [Fact]
        public void NonAppJsonTypeOperationForConsumes()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "non-app-json-operation-consumes.json"));
            messages.AssertOnlyValidationWarning(typeof(NonAppJsonTypeWarning));
        }

        [Fact]
        public void ProvidersPathValidate()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "providers-path.json"));
            messages.AssertOnlyValidationWarning(typeof(ProvidersPathValidation), 2);
        }


        [Fact]
        public void NonAppJsonTypeOperationForProduces()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "non-app-json-operation-produces.json"));
            messages.AssertOnlyValidationWarning(typeof(NonAppJsonTypeWarning));
        }

        [Fact]
        public void NonAppJsonTypeServiceDefinitionForProduces()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "non-app-json-service-def-produces.json"));
            messages.AssertOnlyValidationWarning(typeof(NonAppJsonTypeWarning));
        }

        [Fact]
        public void NonAppJsonTypeServiceDefinitionForConsumes()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "non-app-json-service-def-consumes.json"));
            messages.AssertOnlyValidationWarning(typeof(NonAppJsonTypeWarning));
        }

        [Fact]
        public void NonHttpsServiceDefinitionForScheme()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "non-https-service-def-scheme.json"));
            messages.AssertOnlyValidationWarning(typeof(SupportedSchemesWarning));
        }

        [Fact]
        public void NonHttpsOperationsForScheme()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "non-https-operations-scheme.json"));
            messages.AssertOnlyValidationWarning(typeof(SupportedSchemesWarning));
        }

        [Fact]
        public void XmsPathNotInPathsValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "xms-path-not-in-paths.json"));
            messages.AssertOnlyValidationMessage(typeof(XmsPathsMustOverloadPaths));
        }

        [Fact]
        public void InvalidFormatValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "invalid-format.json"));
            messages.AssertOnlyValidationMessage(typeof(ValidFormats));
        }

        [Fact]
        public void ListOperationsNamingValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "list-operations-naming.json"));
            messages.AssertOnlyValidationMessage(typeof(ListOperationNamingWarning), 2);
        }

        [Fact]
        public void ListByOperationsValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "listby-operations.json"));
            messages.AssertOnlyValidationMessage(typeof(ListByOperationsValidation), 3);
        }

        [Fact]
        public void ArmResourcePropertiesBagValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "arm-resource-properties-bag.json"));
            messages.AssertOnlyValidationMessage(typeof(ArmResourcePropertiesBag), 1);
        }

        [Fact]
        public void CollectionObjectsPropertiesNamingValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "collection-objects-naming.json"));
            messages.AssertOnlyValidationMessage(typeof(CollectionObjectPropertiesNamingValidation), 2);
        }

        [Fact]
        public void BodyTopLevelPropertiesValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "body-top-level-properties.json"));
            messages.AssertOnlyValidationMessage(typeof(BodyTopLevelProperties), 2);
        }

        [Fact]
        public void PropertyNameCasingValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "property-names-casing.json"));
            messages.AssertOnlyValidationMessage(typeof(BodyPropertiesNamesCamelCase), 1);
            messages.AssertOnlyValidationMessage(typeof(DefinitionsPropertiesNamesCamelCase), 1);
        }

        [Fact]
        public void NestedPropertiesValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "nested-properties.json"));
            messages.AssertOnlyValidationMessage(typeof(AvoidNestedProperties));
        }

        [Fact]
        public void OperationDescriptionValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "operation-missing-description.json"));
            messages.AssertOnlyValidationMessage(typeof(OperationDescriptionRequired));
        }

        [Fact]
        public void ParameterDescriptionValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "parameter-missing-description.json"));
            messages.AssertOnlyValidationMessage(typeof(ParameterDescriptionRequired), 2);
        }

        [Fact]
        public void PageableNextLinkNotModeledValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "pageable-nextlink-not-modeled.json"));
            messages.AssertOnlyValidationMessage(typeof(NextLinkPropertyMustExist));
        }

        [Fact]
        public void Pageable200ResponseNotModeledValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "pageable-no-200-response.json"));
            messages.Any(m => m.Rule.GetType() == typeof(PageableRequires200Response));
        }

        [Fact]
        public void OperationNameValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "operation-name-not-valid.json"));
            messages.AssertOnlyValidationMessage(typeof(GetOperationNameValidation), 1);
            messages.AssertOnlyValidationMessage(typeof(PutOperationNameValidation), 1);
            messages.AssertOnlyValidationMessage(typeof(DeleteOperationNameValidation), 1);
        }

        [Fact]
        public void LongRunningResponseForPutValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource","Swagger", "Validation", "long-running-invalid-response-put.json"));
            messages.AssertOnlyValidationMessage(typeof(LongRunningResponseValidationRule));
        }

        [Fact]
        public void LongRunningResponseForPostValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "long-running-invalid-response-post.json"));
            messages.AssertOnlyValidationMessage(typeof(LongRunningResponseValidationRule));
        }

        [Fact]
        public void LongRunningResponseForDeleteValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "long-running-invalid-response-delete.json"));
            messages.AssertOnlyValidationMessage(typeof(LongRunningResponseValidationRule));
        }

        [Fact]
        public void MutabilityNotModeledWithReadOnlyValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "mutability-invalid-values-for-readonly.json"));
            messages.AssertOnlyValidationMessage(typeof(MutabilityWithReadOnlyRule), 2);
        }

        [Fact]
        public void VersionFormatValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "swagger-version-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(APIVersionPattern), 1);
        }

        [Fact]
        public void GuidUsageValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "swagger-guid-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(GuidValidation), 1);
        }

        [Fact]
        public void DeleteRequestBodyValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "swagger-delete-request-body-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(DeleteMustNotHaveRequestBody), 1);
        }

        [Fact]
        public void ResourceExtensionValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "swagger-ext-msresource-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(ResourceIsMsResourceValidation), 1);
        }

        [Fact]
        public void MsClientNameExtensionValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "swagger-ext-msclientname-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(XmsClientNamePropertyValidation), 1);
            messages.AssertOnlyValidationMessage(typeof(XmsClientNameParameterValidation), 1);
        }

        [Fact]
        public void OperationsApiValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "swagger-operations-api-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(OperationsAPIImplementationValidation), 1);
        }

        [Fact]
        public void ResourceModelValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "swagger-ext-resource-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(ResourceModelValidation), 1);
        }

        [Fact]
        public void SkuModelValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "swagger-skumodel-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(SkuModelValidation), 1);
        }

        [Fact]
        public void TrackedResourceGetOperationValidation2()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource","Swagger", "Validation", "swagger-tracked-resource-1-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourceGetOperationValidation), 1);
        }

        [Fact]
        public void TrackedResourceListByResourceGroupValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource","Swagger", "Validation", "swagger-tracked-resource-2-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourceListByResourceGroup), 1);
        }

        [Fact]
        public void TrackedResourcePatchOperationValidationValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "tracked-resource-patch-operation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourcePatchOperationValidation), 1);
        }

        [Fact]
        public void TrackedResourceGetOperationValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "tracked-resource-get-operation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourceGetOperationValidation), 1);
        }

        [Fact]
        public void TrackedResourceListBySubscriptionValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource","Swagger", "Validation", "swagger-tracked-resource-3-validation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourceListBySubscription), 1);
        }

        [Fact]
        public void PutGetPatchResponseValidation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "swagger-putgetpatch-response-validation.json"));
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
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "clean-complex-spec.json"));
            Assert.Empty(messages.Where(m => m.Severity >= Category.Warning));
        }

        /// <summary>
        /// 
        /// </summary>
        [Fact]
        public void ValidCollectionObjectsPropertiesName()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "collection-objects-naming-valid.json"));
            Assert.Empty(messages.Where(m => m.Severity >= Category.Warning));
        }

        /// <summary>
        /// Verifies that a clean Swagger file does not result in any validation errors
        /// </summary>
        [Fact]
        public void RequiredPropertyDefinedAllOf()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "required-property-defined-allof.json"));
            Assert.Empty(messages.Where(m => m.Severity >= Category.Warning));
        }

        /// <summary>
        /// Verifies that a clean Swagger file does not result in any validation errors
        /// </summary>
        [Fact]
        public void PageableNextLinkDefinedAllOf()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "pageable-nextlink-defined-allof.json"));
            Assert.Empty(messages.Where(m => m.Severity >= Category.Warning));
        }

        /// <summary>
        /// Verifies that a x-ms-long-running extension response modeled correctly
        /// </summary>
        [Fact]
        public void LongRunningResponseDefined()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource","Swagger", "Validation", "positive", "long-running-valid-response.json"));
            messages.AssertOnlyValidationMessage(typeof(LongRunningResponseValidationRule), 0);
        }

        /// <summary>
        /// Verifies that tracked resource has a patch operation
        /// </summary>
        [Fact]
        public void ValidTrackedResourcePatchOperation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "tracked-resource-patch-valid-operation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourcePatchOperationValidation), 0);
        }

        /// <summary>
        /// Verifies that tracked resource has a get operation
        /// </summary>
        [Fact]
        public void ValidTrackedResourceGetOperation()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "tracked-resource-get-valid-operation.json"));
            messages.AssertOnlyValidationMessage(typeof(TrackedResourceGetOperationValidation), 0);
        }

        /// <summary>
        /// Verifies that list by operations (operations that are named as *_listby*) are correctly named
        /// </summary>
        [Fact]
        public void ListByOperationsCorrectlyNamed()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "listby-operations-valid-naming.json"));
            messages.AssertOnlyValidationMessage(typeof(ListByOperationsValidation), 0);
        }

        /// <summary>
        /// Verifies that listing operations (any operation that returns an array or is of xmspageable type) 
        /// are correctly named
        /// </summary>
        [Fact]
        public void ListOperationsCorrectlyNamed()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "list-operations-valid-naming.json"));
            messages.AssertOnlyValidationMessage(typeof(ListOperationNamingWarning), 0);
        }

        /// Verifies that a providers path is of proper format
        /// </summary>
        [Fact]
        public void ProvidersPathValidJson()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "providers-path-valid.json"));
            messages.AssertOnlyValidationWarning(typeof(ProvidersPathValidation), 0);
        }

        /// <summary>
        /// Verifies that property names follow camelCase style
        /// </summary>
        [Fact]
        public void ValidPropertyNameCasing()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "property-names-casing-valid.json"));
            messages.AssertOnlyValidationMessage(typeof(BodyPropertiesNamesCamelCase), 0);
            messages.AssertOnlyValidationMessage(typeof(DefinitionsPropertiesNamesCamelCase), 0);
        }

        [Fact]
        public void ValidServiceDefinitionParameters()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "service-def-valid-parameters.json"));
            messages.AssertOnlyValidationMessage(typeof(ServiceDefinitionParameters), 0);
        }

        [Fact]
        public void ValidOperationParameters()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "operations-valid-parameters.json"));
            messages.AssertOnlyValidationMessage(typeof(OperationParametersValidation), 0);
        }

        [Fact]
        public void ValidArmResourcePropertiesBag()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "arm-resource-properties-valid.json"));
            messages.AssertOnlyValidationMessage(typeof(ArmResourcePropertiesBag), 0);
        }

        /// <summary>
        /// Verifies resource models are correctly identified
        /// </summary>
        [Fact]
        public void ValidResourceModels()
        {
            var filePath = Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "valid-resource-model-definitions.json");
            var fileText = System.IO.File.ReadAllText(filePath);
            var servDef = SwaggerParser.Parse(filePath, fileText);
            Uri uriPath = null;
            Uri.TryCreate(filePath, UriKind.RelativeOrAbsolute, out uriPath);
            var context = new RuleContext(servDef, uriPath);
            Assert.Equal(4, context.ResourceModels.Count());
            Assert.Equal(1, context.TrackedResourceModels.Count());
            Assert.Equal(3, context.ProxyResourceModels.Count());
        }

        /// <summary>
        /// Verifies that sku object
        /// </summary>
        [Fact]
        public void ValidSkuObjectStructure()
        {
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "swagger-skumodel-validation-valid.json"));
            messages.AssertOnlyValidationMessage(typeof(SkuModelValidation), 0);
        }
    }

    #endregion
}
