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
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swagger.Tests
{
    
    [Collection("Validation Tests")]
    public partial class SwaggerModelerValidationTests
    {
        private static readonly string PathToValidationResources = Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation");
        private IEnumerable<ValidationMessage> ValidateSwagger(string input, ServiceDefinitionMetadata metadata)
        {
            // Most rules are to be applied for ARM documents
            // Also, most rules need to be run over the composite document (i.e. AFTER merge state)
            // hence the defaults
            using (NewContext)
            {
                var validator = new RecursiveObjectValidator(PropertyNameResolver.JsonName);
                var serviceDefinition = SwaggerParser.Parse(input, File.ReadAllText(input));
                return validator.GetValidationExceptions(new Uri(input, UriKind.RelativeOrAbsolute), serviceDefinition, metadata).OfType<ValidationMessage>();
            }
        }

        private static IEnumerable<ValidationMessage> GetValidationMessagesForCategory(IEnumerable<ValidationMessage> messages, Category category) => messages.Where(m => m.Severity == category);

        private IEnumerable<ValidationMessage> GetValidationMessagesForRule<TRule>(string swaggerFileName) where TRule : Rule
        {
            var ruleInstance = Activator.CreateInstance<TRule>();
            var messages = ValidateSwagger(Path.Combine(PathToValidationResources, swaggerFileName), GetMetadataForRuleTest(ruleInstance));
            return GetValidationMessagesForCategory(messages, ruleInstance.Severity).Where(message => message.Rule.GetType() == typeof(TRule));
        }

        private ServiceDefinitionMetadata GetMetadataForRuleTest(Rule rule) =>
             new ServiceDefinitionMetadata
             {
                 ServiceDefinitionDocumentType = rule.ServiceDefinitionDocumentType,
                 MergeState = rule.ValidationRuleMergeState
             };

        [Fact]
        public void MissingDescriptionValidation()
        {
            var messages = GetValidationMessagesForRule<DescriptionAndTitleMissing>("definition-missing-description.json");
            Assert.Equal(messages.Count(), 2);
        }

        [Fact]
        public void AvoidMsdnReferencesValidation()
        {
            var messages = GetValidationMessagesForRule<AvoidMsdnReferences>("definition-contains-msdn-reference.json");
            Assert.Equal(messages.Count(), 4);
        }

        [Fact]
        public void BooleanPropertiesValidation()
        {
            var messages = GetValidationMessagesForRule<EnumInsteadOfBoolean>("boolean-properties.json");
            Assert.Equal(messages.Count(), 5);
        }

        [Fact]
        public void DefaultValueInEnumValidation()
        {
            var messages = GetValidationMessagesForRule<DefaultMustBeInEnum>("default-value-not-in-enum.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void EmptyClientNameValidation()
        {
            var messages = GetValidationMessagesForRule<NonEmptyClientName>("empty-client-name-extension.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void UniqueResourcePathsValidation()
        {
            var messages = GetValidationMessagesForRule<UniqueResourcePaths>("network-interfaces-api.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void AnonymousSchemasDiscouragedValidation()
        {
            var messages = GetValidationMessagesForRule<AvoidAnonymousTypes>("anonymous-response-type.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void AnonymousParameterSchemaValidation()
        {
            var messages = GetValidationMessagesForRule<AnonymousBodyParameter>("anonymous-parameter-type.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void OperationParametersValidation()
        {
            // ignore ParameterNotDefinedInGlobalParameters validation rule since it overlaps with this
            var messages = GetValidationMessagesForRule<SubscriptionIdParameterInOperations>("operations-invalid-parameters.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void ServiceDefinitionParametersValidation()
        {
            var messages = GetValidationMessagesForRule<ParameterNotDefinedInGlobalParameters>("service-def-invalid-parameters.json");
            Assert.Equal(messages.Count(), 2);
        }

        [Fact]
        public void OperationGroupSingleUnderscoreValidation()
        {
            var messages = GetValidationMessagesForRule<OneUnderscoreInOperationId>("operation-group-underscores.json");
            Assert.Equal(messages.Count(), 1);
        }


        [Fact]
        public void NonAppJsonTypeOperationForConsumes()
        {
            var messages = GetValidationMessagesForRule<NonApplicationJsonType>("non-app-json-operation-consumes.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void ProvidersPathValidate()
        {
            var messages = GetValidationMessagesForRule<ParameterizeProperties>("providers-path.json");
            Assert.Equal(messages.Count(), 2);
        }


        [Fact]
        public void NonAppJsonTypeOperationForProduces()
        {
            var messages = GetValidationMessagesForRule<NonApplicationJsonType>("non-app-json-operation-produces.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void NonAppJsonTypeServiceDefinitionForProduces()
        {
            var messages = GetValidationMessagesForRule<NonApplicationJsonType>("non-app-json-service-def-produces.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void NonAppJsonTypeServiceDefinitionForConsumes()
        {
            var messages = GetValidationMessagesForRule<NonApplicationJsonType>("non-app-json-service-def-consumes.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void NonHttpsServiceDefinitionForScheme()
        {
            var messages = GetValidationMessagesForRule<HttpsSupportedScheme>("non-https-service-def-scheme.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void NonHttpsOperationsForScheme()
        {
            var messages = GetValidationMessagesForRule<HttpsSupportedScheme>("non-https-operations-scheme.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void XmsPathNotInPathsValidation()
        {
            var messages = GetValidationMessagesForRule<XmsPathsMustOverloadPaths>("xms-path-not-in-paths.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void InvalidFormatValidation()
        {
            var messages = GetValidationMessagesForRule<ValidFormats>("invalid-format.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void ListOperationsNamingValidation()
        {
            var messages = GetValidationMessagesForRule<ListInOperationName>("list-operations-naming.json");
            Assert.Equal(messages.Count(), 2);
        }

        [Fact]
        public void ArmResourcePropertiesBagValidation()
        {
            var messages = GetValidationMessagesForRule<ArmResourcePropertiesBag>("arm-resource-properties-bag.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void CollectionObjectsPropertiesNamingValidation()
        {
            var messages = GetValidationMessagesForRule<CollectionObjectPropertiesNaming>("collection-objects-naming.json");
            Assert.Equal(messages.Count(), 2);
        }

        [Fact]
        public void BodyTopLevelPropertiesValidation()
        {
            var messages = GetValidationMessagesForRule<BodyTopLevelProperties>("body-top-level-properties.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void PropertyNameCasingValidation()
        {
            var messages = GetValidationMessagesForRule<BodyPropertiesNamesCamelCase>("property-names-casing.json");
            Assert.Equal(messages.Count(), 1);
            messages = GetValidationMessagesForRule<DefinitionsPropertiesNamesCamelCase>("property-names-casing.json");
            Assert.Equal(messages.Count(), 2);
        }

        [Fact]
        public void NestedPropertiesValidation()
        {
            var messages = GetValidationMessagesForRule<AvoidNestedProperties>("nested-properties.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void OperationDescriptionValidation()
        {
            var messages = GetValidationMessagesForRule<OperationDescriptionOrSummaryRequired>("operation-missing-description.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void ParameterDescriptionValidation()
        {
            var messages = GetValidationMessagesForRule<ParameterDescriptionRequired>("parameter-missing-description.json");
            Assert.Equal(messages.Count(), 2);
        }

        [Fact]
        public void PageableNextLinkNotModeledValidation()
        {
            var messages = GetValidationMessagesForRule<NextLinkPropertyMustExist>("pageable-nextlink-not-modeled.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void Pageable200ResponseNotModeledValidation()
        {
            var messages = GetValidationMessagesForRule<PageableRequires200Response>("pageable-no-200-response.json");
            Assert.True(true);
        }

        [Fact]
        public void OperationNameValidation()
        {
            var messages = GetValidationMessagesForRule<GetInOperationName>("operation-name-not-valid.json");
            Assert.Equal(messages.Count(), 1);
            messages = GetValidationMessagesForRule<PutInOperationName>("operation-name-not-valid.json");
            Assert.Equal(messages.Count(), 1);
            messages = GetValidationMessagesForRule<DeleteInOperationName>("operation-name-not-valid.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void LongRunningResponseForPutValidation()
        {
            var messages = GetValidationMessagesForRule<LongRunningResponseStatusCode>("long-running-invalid-response-put.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void LongRunningResponseForPostValidation()
        {
            var messages = GetValidationMessagesForRule<LongRunningResponseStatusCode>("long-running-invalid-response-post.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void LongRunningResponseForDeleteValidation()
        {
            var messages = GetValidationMessagesForRule<LongRunningResponseStatusCode>("long-running-invalid-response-delete.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void MutabilityNotModeledWithReadOnlyValidation()
        {
            var messages = GetValidationMessagesForRule<MutabilityWithReadOnly>("mutability-invalid-values-for-readonly.json");
            Assert.Equal(messages.Count(), 2);
        }

        [Fact]
        public void VersionFormatValidation()
        {
            var messages = GetValidationMessagesForRule<APIVersionPattern>("swagger-version-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void GuidUsageValidation()
        {
            var messages = GetValidationMessagesForRule<GuidUsage>("swagger-guid-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void DeleteRequestBodyValidation()
        {
            var messages = GetValidationMessagesForRule<DeleteMustNotHaveRequestBody>("swagger-delete-request-body-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void ResourceExtensionValidation()
        {
            var messages = GetValidationMessagesForRule<ResourceHasXMsResourceEnabled>("swagger-ext-msresource-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void MsClientNameExtensionValidation()
        {
            var messages = GetValidationMessagesForRule<XmsClientNameProperty>("swagger-ext-msclientname-validation.json");
            Assert.Equal(messages.Count(), 1);
            messages = GetValidationMessagesForRule<XmsClientNameParameter>("swagger-ext-msclientname-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void OperationsApiValidation()
        {
            var messages = GetValidationMessagesForRule<OperationsAPIImplementation>("swagger-operations-api-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void ResourceModelValidation()
        {
            var messages = GetValidationMessagesForRule<RequiredPropertiesMissingInResourceModel>("swagger-ext-resource-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SkuModelValidation()
        {
            var messages = GetValidationMessagesForRule<InvalidSkuModel>("swagger-skumodel-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void TrackedResourceGetOperationValidation2()
        {
            var messages = GetValidationMessagesForRule<TrackedResourceGetOperation>("swagger-tracked-resource-1-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void TrackedResourceListByResourceGroupValidation()
        {
            var messages = GetValidationMessagesForRule<TrackedResourceListByResourceGroup>("swagger-tracked-resource-2-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void TrackedResourcePatchOperationValidationValidation()
        {
            var messages = GetValidationMessagesForRule<TrackedResourcePatchOperation>("tracked-resource-patch-operation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void TrackedResourceGetOperationValidation()
        {
            var messages = GetValidationMessagesForRule<TrackedResourceGetOperation>("tracked-resource-get-operation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void TrackedResourceListBySubscriptionValidation()
        {
            var messages = GetValidationMessagesForRule<TrackedResourceListBySubscription>("swagger-tracked-resource-3-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void TrackedResourceListByImmediateParentValidation()
        {
            var messages = GetValidationMessagesForRule<TrackedResourceListByImmediateParent>("swagger-list-by-immediate-parent.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void TrackedResourceListByImmediateParentWithOperationValidation()
        {
            var messages = GetValidationMessagesForRule<TrackedResourceListByImmediateParent>("swagger-list-by-immediate-parent-2.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void PutGetPatchResponseValidation()
        {
            var messages = GetValidationMessagesForRule<PutGetPatchResponseSchema>("swagger-putgetpatch-response-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructurePresenceValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-1.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructureEmptyValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-2.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructureMultipleEntriesValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-3.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructureIncorrectKeyValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-4.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructureMissingDescriptionValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-5.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructureEmptyDescriptionValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-6.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructureIncorrectDefValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-7.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructureMissingScopesValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-8.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructureEmptyScopesValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-9.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructureMultipleScopesValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-10.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SecurityDefinitionStructureMissingScopesDescriptionValidation()
        {
            var messages = GetValidationMessagesForRule<SecurityDefinitionsStructure>("security-definitions-validations-11.json");
            Assert.Equal(messages.Count(), 1);
        }

        public void RequiredReadOnlyPropertiesValidationInDefinitions()
        {
            // This test validates if a definition has required properties which are marked as readonly true
            var messages = GetValidationMessagesForRule<RequiredReadOnlyProperties>("required-readonly-properties.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void RequiredReadOnlyPropertiesValidationInResponses()
        {
            // This test validates if a definition has required properties which are marked as readonly true
            var messages = GetValidationMessagesForRule<RequiredReadOnlyProperties>("required-readonly-properties-2.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void RequiredReadOnlyPropertiesValidationInParameters()
        {
            // This test validates if a definition has required properties which are marked as readonly true
            var messages = GetValidationMessagesForRule<RequiredReadOnlyProperties>("required-readonly-properties-3.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void RequiredReadOnlyPropertiesValidationInNestedSchema()
        {
            // This test validates if a definition has required properties which are marked as readonly true
            var messages = GetValidationMessagesForRule<RequiredReadOnlyProperties>("required-readonly-properties-4.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void RequiredReadOnlyPropertiesValidationInItems()
        {
            // This test validates if a definition has required properties which are marked as readonly true
            var messages = GetValidationMessagesForRule<RequiredReadOnlyProperties>("required-readonly-properties-5.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void DefaultValuedInPropertiesInPatchRequestValidation()
        {
            // This test validates if a definition has required properties which are marked as readonly true
            var messages = GetValidationMessagesForRule<PatchBodyParametersSchema>("default-valued-properties-in-patch-request.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void RequiredPropertiesInPatchRequestValidation()
        {
            // This test validates if a definition has required properties which are marked as readonly true
            var messages = GetValidationMessagesForRule<PatchBodyParametersSchema>("req-properties-in-patch-request.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void XmsEnumExtensionValidation()
        {
            var messages = GetValidationMessagesForRule<XmsEnumValidation>("x-ms-enum-absent.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void XmsExamplesProvidedValidation()
        {
            var messages = GetValidationMessagesForRule<XmsExamplesRequired>("xms-examples-absent.json");
            Assert.Equal(messages.Count(), 2);
        }

        [Fact]
        public void PutResponseResourceValidationTest()
        {
            var messages = GetValidationMessagesForRule<XmsResourceInPutResponse>("put-response-resource-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void LROStatusCodesValidationTest()
        {
            var messages = GetValidationMessagesForRule<LROStatusCodesReturnTypeSchema>("lro-status-codes-validation.json");
            Assert.Equal(messages.Count(), 2);
        }

        [Fact]
        public void EmptyParameterNameValidation()
        {
            var messages = GetValidationMessagesForRule<NamePropertyDefinitionInParameter>("empty-parameter-name.json");
            Assert.Equal(messages.Count(), 2);
        }

        [Fact]
        public void OperationIdNounConflictingModelNameValidationTest()
        {
            var messages = GetValidationMessagesForRule<OperationIdNounConflictingModelNames>("operationid-noun-conflicting-model.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void PutRequestResponseBodySchemaValidation()
        {
            var messages = GetValidationMessagesForRule<PutRequestResponseScheme>("put-request-response-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void XMSPageableListByRGAndSubscriptionValidation()
        {
            var messages = GetValidationMessagesForRule<XmsPageableListByRGAndSubscriptions>("xms-pageable-validation.json");
            Assert.Equal(messages.Count(), 1);
        }

        [Fact]
        public void SummaryDescriptionValidation()
        {
            var messages = GetValidationMessagesForRule<SummaryAndDescriptionMustNotBeSame>("swagger-summary-description.json");
            Assert.Equal(messages.Count(), 1);
        }


        [Fact]
        public void LocationPropertyWithoutXmsMutability()
        {
            var messages = GetValidationMessagesForRule<LocationMustHaveXmsMutability>("location-without-xms-mutability.json");
            Assert.Equal(messages.Count(), 1);
        }
        
        [Fact]
        public void LocationPropertyWithIncorrectXmsMutability()
        {
            var messages = GetValidationMessagesForRule<LocationMustHaveXmsMutability>("location-with-incorrect-xms-mutability.json");
            Assert.Equal(messages.Count(), 1);
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
            // individual state
            var subtest1md = new ServiceDefinitionMetadata
            {
                ServiceDefinitionDocumentType = ServiceDefinitionDocumentType.ARM,
                MergeState = ServiceDefinitionDocumentState.Individual
            };
            var messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "clean-complex-spec.json"), subtest1md);
            Assert.Empty(messages.Where(m => m.Severity >= Category.Warning));

            // composed state
            var subtest2md = new ServiceDefinitionMetadata
            {
                ServiceDefinitionDocumentType = ServiceDefinitionDocumentType.ARM,
                MergeState = ServiceDefinitionDocumentState.Composed
            };
            messages = ValidateSwagger(Path.Combine(Core.Utilities.Extensions.CodeBaseDirectory, "Resource", "Swagger", "Validation", "positive", "clean-complex-spec.json"), subtest1md);
            Assert.Empty(messages.Where(m => m.Severity >= Category.Warning));

        }

        /// <summary>
        /// 
        /// </summary>
        [Fact]
        public void ValidCollectionObjectsPropertiesName()
        {
            var messages = GetValidationMessagesForRule<CollectionObjectPropertiesNaming>(Path.Combine("positive", "collection-objects-naming-valid.json"));
            Assert.Empty(messages);
        }

        /// <summary>
        /// Verifies that a clean Swagger file does not result in any validation errors
        /// </summary>
        [Fact]
        public void PageableNextLinkDefinedAllOf()
        {
            var messages = GetValidationMessagesForRule<NextLinkPropertyMustExist>(Path.Combine("positive", "pageable-nextlink-defined-allof.json"));
            Assert.Empty(messages);
        }

        /// <summary>
        /// Verifies that a x-ms-long-running extension response modeled correctly
        /// </summary>
        [Fact]
        public void LongRunningResponseDefined()
        {
            var messages = GetValidationMessagesForRule<LongRunningResponseStatusCode>(Path.Combine("positive", "long-running-valid-response.json"));
            Assert.Empty(messages);
        }

        /// <summary>
        /// Verifies that tracked resource has a patch operation
        /// </summary>
        [Fact]
        public void ValidTrackedResourcePatchOperation()
        {
            var messages = GetValidationMessagesForRule<TrackedResourcePatchOperation>(Path.Combine("positive", "tracked-resource-patch-valid-operation.json"));
            Assert.Empty(messages);
        }

        /// <summary>
        /// Verifies that tracked resource has a get operation
        /// </summary>
        [Fact]
        public void ValidTrackedResourceGetOperation()
        {
            var messages = GetValidationMessagesForRule<TrackedResourceGetOperation>(Path.Combine("positive", "tracked-resource-get-valid-operation.json"));
            Assert.Empty(messages);
        }

        /// <summary>
        /// Verifies that listing operations (any operation that returns an array or is of xmspageable type) 
        /// are correctly named
        /// </summary>
        [Fact]
        public void ListOperationsCorrectlyNamed()
        {
            var messages = GetValidationMessagesForRule<ListInOperationName>(Path.Combine("positive", "list-operations-valid-naming.json"));
            Assert.Empty(messages);
        }

        /// Verifies that a providers path is of proper format
        /// </summary>
        [Fact]
        public void ProvidersPathValidJson()
        {
            var messages = GetValidationMessagesForRule<ParameterizeProperties>(Path.Combine("positive", "providers-path-valid.json"));
            Assert.Empty(messages);
        }

        /// <summary>
        /// Verifies that property names follow camelCase style
        /// </summary>
        [Fact]
        public void ValidPropertyNameCasing()
        {
            var messages = GetValidationMessagesForRule<BodyPropertiesNamesCamelCase>(Path.Combine("positive", "property-names-casing-valid.json"));
            Assert.Empty(messages);
            messages = GetValidationMessagesForRule<DefinitionsPropertiesNamesCamelCase>(Path.Combine("positive", "property-names-casing-valid.json"));
            Assert.Empty(messages);
        }

        [Fact]
        public void ValidServiceDefinitionParameters()
        {
            var messages = GetValidationMessagesForRule<ParameterNotDefinedInGlobalParameters>(Path.Combine("positive", "service-def-valid-parameters.json"));
            Assert.Empty(messages);
        }

        [Fact]
        public void ValidOperationParameters()
        {
            var messages = GetValidationMessagesForRule<SubscriptionIdParameterInOperations>(Path.Combine("positive", "operations-valid-parameters.json"));
            Assert.Empty(messages);
        }

        [Fact]
        public void ValidArmResourcePropertiesBag()
        {
            var messages = GetValidationMessagesForRule<ArmResourcePropertiesBag>(Path.Combine("positive", "arm-resource-properties-valid.json"));
            Assert.Empty(messages);
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
            var context = new RuleContext(servDef, uriPath, new ServiceDefinitionMetadata() { MergeState = ServiceDefinitionDocumentState.Composed, ServiceDefinitionDocumentType = ServiceDefinitionDocumentType.ARM });
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
            var messages = GetValidationMessagesForRule<InvalidSkuModel>(Path.Combine("positive", "swagger-skumodel-validation-valid.json"));
            Assert.Empty(messages);
        }

        /// <summary>
        /// Verifies resource model readonly properties
        /// </summary>
        [Fact]
        public void ValidResourceModelReadOnlyProperties()
        {
            var messages = GetValidationMessagesForRule<RequiredPropertiesMissingInResourceModel>(Path.Combine("positive", "valid-resource-model-readonly-props.json"));
            Assert.Empty(messages);
        }

    }

    #endregion
}
