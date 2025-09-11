import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.ApiManagement;

@@clientName(ApiEntityBaseContract.type, "apiType");
@@clientName(ApiEntityBaseContract.subscriptionRequired,
  "IsSubscriptionRequired"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ErrorResponse.error);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ApiCreateOrUpdateParameter.properties);

@@clientName(ApiCreateOrUpdateProperties.apiType, "soapApiType");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ApiUpdateContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(OperationUpdateContract.properties);

@@clientName(ProductEntityBaseParameters.subscriptionRequired,
  "IsSubscriptionRequired"
);
@@clientName(ProductEntityBaseParameters.approvalRequired,
  "IsApprovalRequired"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SchemaContractProperties.document);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(IssueUpdateContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(TagDescriptionCreateParameters.properties);

@@clientName(ApiExportResult.format, "exportResultFormat");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ApiVersionSetUpdateParameters.properties);

@@clientName(AuthorizationServerContractBaseProperties.clientAuthenticationMethod,
  "clientAuthenticationMethods"
);
@@clientName(AuthorizationServerContractBaseProperties.supportState,
  "doesSupportState"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AuthorizationServerUpdateContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(BackendUpdateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(BackendReconnectContract.properties);

@@clientName(CacheContractProperties.resourceId, "resourceUri");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CacheUpdateParameters.properties);

@@clientName(CacheUpdateProperties.resourceId, "resourceUri");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CertificateCreateOrUpdateParameters.properties);

@@clientName(ConnectivityCheckRequestProtocolConfiguration.HTTPConfiguration,
  "httpConfiguration"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RemotePrivateEndpointConnectionWrapper.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ApiManagementServiceUpdateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(EmailTemplateUpdateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AssociationContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GroupCreateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GroupUpdateParameters.properties);

@@clientName(IdentityProviderBaseParameters.type, "identityProviderType");
@@clientName(IdentityProviderBaseParameters.signinTenant, "signInTenant");
@@clientName(IdentityProviderBaseParameters.signupPolicyName,
  "signUpPolicyName"
);
@@clientName(IdentityProviderBaseParameters.signinPolicyName,
  "signInPolicyName"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(IdentityProviderCreateContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(IdentityProviderUpdateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(LoggerUpdateContract.properties);

@@clientName(NamedValueEntityBaseParameters.secret, "IsSecret");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(NamedValueCreateContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(NamedValueUpdateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RecipientUserContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RecipientEmailContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(OpenidConnectProviderUpdateContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PolicyDescriptionContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PortalSettingsContract.properties);

@@clientName(PortalSettingsContractProperties.subscriptions, "IsSubscriptions");
@@clientName(PortalSettingsContractProperties.userRegistration,
  "IsUserRegistration"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ProductUpdateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(QuotaCounterValueUpdateContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GlobalSchemaContractProperties.document);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SubscriptionCreateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SubscriptionUpdateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(TagCreateUpdateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AccessInformationCreateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AccessInformationUpdateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DeployConfigurationParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(OperationResultContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SaveConfigurationParameter.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(TenantConfigurationSyncStateContract.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(UserCreateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(UserUpdateParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(UserTokenParameters.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(QuotaCounterValueContract.value);

@@clientLocation(ApiContracts.get, "Api");
@@clientLocation(ApiContracts.getEntityTag, "Api");
@@clientLocation(ApiContracts.createOrUpdate, "Api");
@@clientName(ApiContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(ApiContracts.update, "Api");
@@clientName(ApiContracts.update::parameters.properties, "parameters");
@@clientLocation(ApiContracts.delete, "Api");
@@clientLocation(ApiContracts.listByService, "Api");
@@clientLocation(ApiContracts.apiRevisionListByService, "ApiRevision");
@@clientName(ApiContracts.apiRevisionListByService, "ListByService");
@@clientLocation(ApiContracts.listByApis, "ApiProduct");
@@clientLocation(ApiContracts.listByTags, "Operation");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ApiContract.properties);

@@clientLocation(ApiReleaseContracts.get, "ApiRelease");
@@clientLocation(ApiReleaseContracts.getEntityTag, "ApiRelease");
@@clientLocation(ApiReleaseContracts.createOrUpdate, "ApiRelease");
@@clientName(ApiReleaseContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(ApiReleaseContracts.update, "ApiRelease");
@@clientName(ApiReleaseContracts.update::parameters.properties, "parameters");
@@clientLocation(ApiReleaseContracts.delete, "ApiRelease");
@@clientLocation(ApiReleaseContracts.listByService, "ApiRelease");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ApiReleaseContract.properties);

@@clientLocation(OperationContracts.get, "ApiOperation");
@@clientLocation(OperationContracts.getEntityTag, "ApiOperation");
@@clientLocation(OperationContracts.createOrUpdate, "ApiOperation");
@@clientName(OperationContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(OperationContracts.update, "ApiOperation");
@@clientName(OperationContracts.update::parameters.properties, "parameters");
@@clientLocation(OperationContracts.delete, "ApiOperation");
@@clientLocation(OperationContracts.listByApi, "ApiOperation");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(OperationContract.properties);

@@clientLocation(PolicyContracts.get, "ApiOperationPolicy");
@@clientLocation(PolicyContracts.getEntityTag, "ApiOperationPolicy");
@@clientLocation(PolicyContracts.createOrUpdate, "ApiOperationPolicy");
@@clientName(PolicyContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(PolicyContracts.delete, "ApiOperationPolicy");
@@clientLocation(PolicyContracts.listByOperation, "ApiOperationPolicy");
@@clientName(ApiPolicy.createOrUpdate::parameters.resource, "parameters");
@@clientName(Policy.createOrUpdate::parameters.resource, "parameters");
@@clientName(ProductPolicy.createOrUpdate::parameters.resource, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PolicyContract.properties);

@@clientLocation(TagContracts.getByOperation, Tag);
@@clientLocation(TagContracts.getEntityStateByOperation, Tag);
@@clientLocation(TagContracts.assignToOperation, Tag);
@@clientLocation(TagContracts.detachFromOperation, Tag);
@@clientLocation(TagContracts.listByOperation, Tag);
@@clientLocation(TagContractOperationGroup.getByProduct, Tag);
@@clientLocation(TagContractOperationGroup.getEntityStateByProduct, Tag);
@@clientLocation(TagContractOperationGroup.assignToProduct, Tag);
@@clientLocation(TagContractOperationGroup.detachFromProduct, Tag);
@@clientLocation(TagContractOperationGroup.listByProduct, Tag);
@@clientLocation(TagContractOperationGroup.get, Tag);
@@clientLocation(TagContractOperationGroup.getEntityState, Tag);
@@clientLocation(TagContractOperationGroup.createOrUpdate, Tag);
@@clientName(TagContractOperationGroup.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(TagContractOperationGroup.update, Tag);
@@clientName(TagContractOperationGroup.update::parameters.properties,
  "parameters"
);
@@clientLocation(TagContractOperationGroup.delete, Tag);
@@clientLocation(TagContractOperationGroup.listByService, Tag);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(TagContract.properties);

@@clientLocation(ProductContracts.get, "Product");
@@clientLocation(ProductContracts.getEntityTag, "Product");
@@clientLocation(ProductContracts.createOrUpdate, "Product");
@@clientName(ProductContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(ProductContracts.update, "Product");
@@clientName(ProductContracts.update::parameters.properties, "parameters");
@@clientLocation(ProductContracts.delete, "Product");
@@clientLocation(ProductContracts.listByService, "Product");
@@clientLocation(ProductContracts.listByProduct, "ProductApi");
@@clientLocation(ProductContracts.checkEntityExists, "ProductApi");
@@clientLocation(ProductContracts.productApiCreateOrUpdate, "ProductApi");
@@clientName(ProductContracts.productApiCreateOrUpdate, "CreateOrUpdate");
@@clientLocation(ProductContracts.productApiDelete, "ProductApi");
@@clientName(ProductContracts.productApiDelete, "Delete");
@@clientLocation(ProductContracts.productGroupListByProduct, "ProductGroup");
@@clientName(ProductContracts.productGroupListByProduct, "ListByProduct");
@@clientLocation(ProductContracts.productGroupCheckEntityExists,
  "ProductGroup"
);
@@clientName(ProductContracts.productGroupCheckEntityExists,
  "CheckEntityExists"
);
@@clientLocation(ProductContracts.productGroupCreateOrUpdate, "ProductGroup");
@@clientName(ProductContracts.productGroupCreateOrUpdate, "CreateOrUpdate");
@@clientLocation(ProductContracts.productGroupDelete, "ProductGroup");
@@clientName(ProductContracts.productGroupDelete, "Delete");
@@clientLocation(ProductContracts.list, "ProductSubscriptions");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ProductContract.properties);

@@clientLocation(SchemaContracts.get, "ApiSchema");
@@clientLocation(SchemaContracts.getEntityTag, "ApiSchema");
@@clientLocation(SchemaContracts.createOrUpdate, "ApiSchema");
@@clientName(SchemaContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(SchemaContracts.delete, "ApiSchema");
@@clientLocation(SchemaContracts.listByApi, "ApiSchema");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SchemaContract.properties);

@@clientLocation(DiagnosticContracts.get, "ApiDiagnostic");
@@clientLocation(DiagnosticContracts.getEntityTag, "ApiDiagnostic");
@@clientLocation(DiagnosticContracts.createOrUpdate, "ApiDiagnostic");
@@clientName(DiagnosticContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(DiagnosticContracts.update, "ApiDiagnostic");
@@clientName(DiagnosticContracts.update::parameters.properties, "parameters");
@@clientLocation(DiagnosticContracts.delete, "ApiDiagnostic");
@@clientLocation(DiagnosticContracts.listByService, "ApiDiagnostic");
@@clientName(Diagnostic.createOrUpdate::parameters.resource, "parameters");
@@clientName(Diagnostic.update::parameters.properties, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DiagnosticContract.properties);

@@clientLocation(IssueContracts.get, "ApiIssue");
@@clientLocation(IssueContracts.getEntityTag, "ApiIssue");
@@clientLocation(IssueContracts.createOrUpdate, "ApiIssue");
@@clientName(IssueContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(IssueContracts.update, "ApiIssue");
@@clientName(IssueContracts.update::parameters.properties, "parameters");
@@clientLocation(IssueContracts.delete, "ApiIssue");
@@clientLocation(IssueContracts.listByService, "ApiIssue");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(IssueContract.properties);

@@clientLocation(IssueCommentContracts.get, "ApiIssueComment");
@@clientLocation(IssueCommentContracts.getEntityTag, "ApiIssueComment");
@@clientLocation(IssueCommentContracts.createOrUpdate, "ApiIssueComment");
@@clientName(IssueCommentContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(IssueCommentContracts.delete, "ApiIssueComment");
@@clientLocation(IssueCommentContracts.listByService, "ApiIssueComment");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(IssueCommentContract.properties);

@@clientLocation(IssueAttachmentContracts.get, "ApiIssueAttachment");
@@clientLocation(IssueAttachmentContracts.getEntityTag, "ApiIssueAttachment");
@@clientLocation(IssueAttachmentContracts.createOrUpdate, "ApiIssueAttachment");
@@clientName(IssueAttachmentContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(IssueAttachmentContracts.delete, "ApiIssueAttachment");
@@clientLocation(IssueAttachmentContracts.listByService, "ApiIssueAttachment");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(IssueAttachmentContract.properties);

@@clientLocation(TagDescriptionContracts.get, "ApiTagDescription");
@@clientLocation(TagDescriptionContracts.getEntityTag, "ApiTagDescription");
@@clientLocation(TagDescriptionContracts.createOrUpdate, "ApiTagDescription");
@@clientName(TagDescriptionContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(TagDescriptionContracts.delete, "ApiTagDescription");
@@clientLocation(TagDescriptionContracts.listByService, "ApiTagDescription");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(TagDescriptionContract.properties);

@@clientLocation(ApiVersionSetContracts.get, "ApiVersionSet");
@@clientLocation(ApiVersionSetContracts.getEntityTag, "ApiVersionSet");
@@clientLocation(ApiVersionSetContracts.createOrUpdate, "ApiVersionSet");
@@clientName(ApiVersionSetContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(ApiVersionSetContracts.update, "ApiVersionSet");
@@clientName(ApiVersionSetContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(ApiVersionSetContracts.delete, "ApiVersionSet");
@@clientLocation(ApiVersionSetContracts.listByService, "ApiVersionSet");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ApiVersionSetContract.properties);

@@clientLocation(AuthorizationServerContracts.get, "AuthorizationServer");
@@clientLocation(AuthorizationServerContracts.getEntityTag,
  "AuthorizationServer"
);
@@clientLocation(AuthorizationServerContracts.createOrUpdate,
  "AuthorizationServer"
);
@@clientName(AuthorizationServerContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(AuthorizationServerContracts.update, "AuthorizationServer");
@@clientName(AuthorizationServerContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(AuthorizationServerContracts.delete, "AuthorizationServer");
@@clientLocation(AuthorizationServerContracts.listByService,
  "AuthorizationServer"
);
@@clientLocation(AuthorizationServerContracts.listSecrets,
  "AuthorizationServer"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AuthorizationServerContract.properties);

@@clientLocation(BackendContracts.get, "Backend");
@@clientLocation(BackendContracts.getEntityTag, "Backend");
@@clientLocation(BackendContracts.createOrUpdate, "Backend");
@@clientName(BackendContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(BackendContracts.update, "Backend");
@@clientName(BackendContracts.update::parameters.properties, "parameters");
@@clientLocation(BackendContracts.delete, "Backend");
@@clientLocation(BackendContracts.listByService, "Backend");
@@clientLocation(BackendContracts.reconnect, "Backend");
@@clientName(BackendContracts.reconnect::parameters.body, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(BackendContract.properties);

@@clientLocation(CacheContracts.get, "Cache");
@@clientLocation(CacheContracts.getEntityTag, "Cache");
@@clientLocation(CacheContracts.createOrUpdate, "Cache");
@@clientName(CacheContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(CacheContracts.update, "Cache");
@@clientName(CacheContracts.update::parameters.properties, "parameters");
@@clientLocation(CacheContracts.delete, "Cache");
@@clientLocation(CacheContracts.listByService, "Cache");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CacheContract.properties);

@@clientLocation(CertificateContracts.get, "Certificate");
@@clientLocation(CertificateContracts.getEntityTag, "Certificate");
@@clientLocation(CertificateContracts.createOrUpdate, "Certificate");
@@clientName(CertificateContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(CertificateContracts.delete, "Certificate");
@@clientLocation(CertificateContracts.listByService, "Certificate");
@@clientLocation(CertificateContracts.refreshSecret, "Certificate");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CertificateContract.properties);

@@clientLocation(ContentTypeContracts.get, "ContentType");
@@clientLocation(ContentTypeContracts.createOrUpdate, "ContentType");
@@clientLocation(ContentTypeContracts.delete, "ContentType");
@@clientLocation(ContentTypeContracts.listByService, "ContentType");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ContentTypeContract.properties);

@@clientLocation(ContentItemContracts.get, "ContentItem");
@@clientLocation(ContentItemContracts.getEntityTag, "ContentItem");
@@clientLocation(ContentItemContracts.createOrUpdate, "ContentItem");
@@clientLocation(ContentItemContracts.delete, "ContentItem");
@@clientLocation(ContentItemContracts.listByService, "ContentItem");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ContentItemContract.properties);

@@clientLocation(DeletedServiceContracts.getByName, "DeletedServices");
@@clientLocation(DeletedServiceContracts.purge, "DeletedServices");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DeletedServiceContract.properties);

@@clientLocation(ApiManagementServiceResources.get, "ApiManagementService");
@@clientLocation(ApiManagementServiceResources.createOrUpdate,
  "ApiManagementService"
);
@@clientName(ApiManagementServiceResources.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(ApiManagementServiceResources.update, "ApiManagementService");
@@clientName(ApiManagementServiceResources.update::parameters.properties,
  "parameters"
);
@@clientLocation(ApiManagementServiceResources.delete, "ApiManagementService");
@@clientLocation(ApiManagementServiceResources.listByResourceGroup,
  "ApiManagementService"
);
@@clientLocation(ApiManagementServiceResources.list, "ApiManagementService");
@@clientLocation(ApiManagementServiceResources.listByTags, "Api");
@@clientLocation(ApiManagementServiceResources.performConnectivityCheckAsync,
  ""
);
@@clientName(ApiManagementServiceResources.performConnectivityCheckAsync::parameters.body,
  "connectivityCheckRequestParams"
);
@@clientLocation(ApiManagementServiceResources.listAvailableServiceSkus,
  "ApiManagementServiceSkus"
);
@@clientLocation(ApiManagementServiceResources.restore, "ApiManagementService");
@@clientName(ApiManagementServiceResources.restore::parameters.body,
  "parameters"
);
@@clientLocation(ApiManagementServiceResources.backup, "ApiManagementService");
@@clientName(ApiManagementServiceResources.backup::parameters.body,
  "parameters"
);
@@clientLocation(ApiManagementServiceResources.getSsoToken,
  "ApiManagementService"
);
@@clientLocation(ApiManagementServiceResources.applyNetworkConfigurationUpdates,
  "ApiManagementService"
);
@@clientName(ApiManagementServiceResources.applyNetworkConfigurationUpdates::parameters.body,
  "parameters"
);
@@clientLocation(ApiManagementServiceResources.listByService, "NetworkStatus");
@@clientLocation(ApiManagementServiceResources.listByLocation, "NetworkStatus");
@@clientLocation(ApiManagementServiceResources.outboundNetworkDependenciesEndpointsListByService,
  "OutboundNetworkDependenciesEndpoints"
);
@@clientName(ApiManagementServiceResources.outboundNetworkDependenciesEndpointsListByService,
  "ListByService"
);
@@clientLocation(ApiManagementServiceResources.policyDescriptionListByService,
  "PolicyDescription"
);
@@clientName(ApiManagementServiceResources.policyDescriptionListByService,
  "ListByService"
);
@@clientLocation(ApiManagementServiceResources.portalSettingsListByService,
  "PortalSettings"
);
@@clientName(ApiManagementServiceResources.portalSettingsListByService,
  "ListByService"
);
@@clientLocation(ApiManagementServiceResources.productListByTags, "Product");
@@clientName(ApiManagementServiceResources.productListByTags, "ListByTags");
@@clientLocation(ApiManagementServiceResources.quotaByCounterKeysListByService,
  "QuotaByCounterKeys"
);
@@clientName(ApiManagementServiceResources.quotaByCounterKeysListByService,
  "ListByService"
);
@@clientLocation(ApiManagementServiceResources.quotaByCounterKeysUpdate,
  "QuotaByCounterKeys"
);
@@clientName(ApiManagementServiceResources.quotaByCounterKeysUpdate, "Update");
@@clientName(ApiManagementServiceResources.quotaByCounterKeysUpdate::parameters.body,
  "parameters"
);
@@clientLocation(ApiManagementServiceResources.quotaByPeriodKeysGet,
  "QuotaByPeriodKeys"
);
@@clientName(ApiManagementServiceResources.quotaByPeriodKeysGet, "Get");
@@clientLocation(ApiManagementServiceResources.quotaByPeriodKeysUpdate,
  "QuotaByPeriodKeys"
);
@@clientName(ApiManagementServiceResources.quotaByPeriodKeysUpdate, "Update");
@@clientName(ApiManagementServiceResources.quotaByPeriodKeysUpdate::parameters.body,
  "parameters"
);
@@clientLocation(ApiManagementServiceResources.regionListByService, "Region");
@@clientName(ApiManagementServiceResources.regionListByService,
  "ListByService"
);
@@clientLocation(ApiManagementServiceResources.listByApi, "Reports");
@@clientLocation(ApiManagementServiceResources.listByUser, "Reports");
@@clientLocation(ApiManagementServiceResources.listByOperation, "Reports");
@@clientLocation(ApiManagementServiceResources.listByProduct, "Reports");
@@clientLocation(ApiManagementServiceResources.listByGeo, "Reports");
@@clientLocation(ApiManagementServiceResources.listBySubscription, "Reports");
@@clientLocation(ApiManagementServiceResources.listByTime, "Reports");
@@clientLocation(ApiManagementServiceResources.listByRequest, "Reports");
@@clientLocation(ApiManagementServiceResources.tagResourceListByService,
  "TagResource"
);
@@clientName(ApiManagementServiceResources.tagResourceListByService,
  "ListByService"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ApiManagementServiceResource.properties);

@@clientLocation(EmailTemplateContracts.get, "EmailTemplate");
@@clientLocation(EmailTemplateContracts.getEntityTag, "EmailTemplate");
@@clientLocation(EmailTemplateContracts.createOrUpdate, "EmailTemplate");
@@clientName(EmailTemplateContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(EmailTemplateContracts.update, "EmailTemplate");
@@clientName(EmailTemplateContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(EmailTemplateContracts.delete, "EmailTemplate");
@@clientLocation(EmailTemplateContracts.listByService, "EmailTemplate");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(EmailTemplateContract.properties);

@@clientLocation(GatewayContracts.get, "Gateway");
@@clientLocation(GatewayContracts.getEntityTag, "Gateway");
@@clientLocation(GatewayContracts.createOrUpdate, "Gateway");
@@clientName(GatewayContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(GatewayContracts.update, "Gateway");
@@clientName(GatewayContracts.update::parameters.properties, "parameters");
@@clientLocation(GatewayContracts.delete, "Gateway");
@@clientLocation(GatewayContracts.listByService, "Gateway");
@@clientLocation(GatewayContracts.listKeys, "Gateway");
@@clientLocation(GatewayContracts.regenerateKey, "Gateway");
@@clientName(GatewayContracts.regenerateKey::parameters.body, "parameters");
@@clientLocation(GatewayContracts.generateToken, "Gateway");
@@clientName(GatewayContracts.generateToken::parameters.body, "parameters");
@@clientLocation(GatewayContracts.gatewayApiListByService, "GatewayApi");
@@clientName(GatewayContracts.gatewayApiListByService, "ListByService");
@@clientLocation(GatewayContracts.gatewayApiGetEntityTag, "GatewayApi");
@@clientName(GatewayContracts.gatewayApiGetEntityTag, "GetEntityTag");
@@clientLocation(GatewayContracts.gatewayApiCreateOrUpdate, "GatewayApi");
@@clientName(GatewayContracts.gatewayApiCreateOrUpdate, "CreateOrUpdate");
@@clientName(GatewayContracts.gatewayApiCreateOrUpdate::parameters.body,
  "parameters"
);
@@clientLocation(GatewayContracts.gatewayApiDelete, "GatewayApi");
@@clientName(GatewayContracts.gatewayApiDelete, "Delete");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GatewayContract.properties);

@@clientLocation(GatewayHostnameConfigurationContracts.get,
  "GatewayHostnameConfiguration"
);
@@clientLocation(GatewayHostnameConfigurationContracts.getEntityTag,
  "GatewayHostnameConfiguration"
);
@@clientLocation(GatewayHostnameConfigurationContracts.createOrUpdate,
  "GatewayHostnameConfiguration"
);
@@clientName(GatewayHostnameConfigurationContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(GatewayHostnameConfigurationContracts.delete,
  "GatewayHostnameConfiguration"
);
@@clientLocation(GatewayHostnameConfigurationContracts.listByService,
  "GatewayHostnameConfiguration"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GatewayHostnameConfigurationContract.properties);

@@clientLocation(GatewayCertificateAuthorityContracts.get,
  "GatewayCertificateAuthority"
);
@@clientLocation(GatewayCertificateAuthorityContracts.getEntityTag,
  "GatewayCertificateAuthority"
);
@@clientLocation(GatewayCertificateAuthorityContracts.createOrUpdate,
  "GatewayCertificateAuthority"
);
@@clientName(GatewayCertificateAuthorityContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(GatewayCertificateAuthorityContracts.delete,
  "GatewayCertificateAuthority"
);
@@clientLocation(GatewayCertificateAuthorityContracts.listByService,
  "GatewayCertificateAuthority"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GatewayCertificateAuthorityContract.properties);

@@clientLocation(GroupContracts.get, "Group");
@@clientLocation(GroupContracts.getEntityTag, "Group");
@@clientLocation(GroupContracts.createOrUpdate, "Group");
@@clientName(GroupContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(GroupContracts.update, "Group");
@@clientName(GroupContracts.update::parameters.properties, "parameters");
@@clientLocation(GroupContracts.delete, "Group");
@@clientLocation(GroupContracts.listByService, "Group");
@@clientLocation(GroupContracts.list, "GroupUser");
@@clientLocation(GroupContracts.checkEntityExists, "GroupUser");
@@clientLocation(GroupContracts.create, "GroupUser");
@@clientLocation(GroupContracts.groupUserDelete, "GroupUser");
@@clientName(GroupContracts.groupUserDelete, "Delete");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GroupContract.properties);

@@clientLocation(UserContracts.get, "User");
@@clientLocation(UserContracts.getEntityTag, "User");
@@clientLocation(UserContracts.createOrUpdate, "User");
@@clientName(UserContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(UserContracts.update, "User");
@@clientName(UserContracts.update::parameters.properties, "parameters");
@@clientLocation(UserContracts.delete, "User");
@@clientLocation(UserContracts.listByService, "User");
@@clientLocation(UserContracts.generateSsoUrl, "User");
@@clientLocation(UserContracts.getSharedAccessToken, "User");
@@clientName(UserContracts.getSharedAccessToken::parameters.body, "parameters");
@@clientLocation(UserContracts.list, "UserGroup");
@@clientLocation(UserContracts.userIdentitiesList, "UserIdentities");
@@clientName(UserContracts.userIdentitiesList, "List");
@@clientLocation(UserContracts.send, "UserConfirmationPassword");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(UserContract.properties);

@@clientLocation(IdentityProviderContracts.get, "IdentityProvider");
@@clientLocation(IdentityProviderContracts.getEntityTag, "IdentityProvider");
@@clientLocation(IdentityProviderContracts.createOrUpdate, "IdentityProvider");
@@clientName(IdentityProviderContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(IdentityProviderContracts.update, "IdentityProvider");
@@clientName(IdentityProviderContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(IdentityProviderContracts.delete, "IdentityProvider");
@@clientLocation(IdentityProviderContracts.listByService, "IdentityProvider");
@@clientLocation(IdentityProviderContracts.listSecrets, "IdentityProvider");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(IdentityProviderContract.properties);

@@clientLocation(LoggerContracts.get, "Logger");
@@clientLocation(LoggerContracts.getEntityTag, "Logger");
@@clientLocation(LoggerContracts.createOrUpdate, "Logger");
@@clientName(LoggerContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(LoggerContracts.update, "Logger");
@@clientName(LoggerContracts.update::parameters.properties, "parameters");
@@clientLocation(LoggerContracts.delete, "Logger");
@@clientLocation(LoggerContracts.listByService, "Logger");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(LoggerContract.properties);

@@clientLocation(NamedValueContracts.get, "NamedValue");
@@clientLocation(NamedValueContracts.getEntityTag, "NamedValue");
@@clientLocation(NamedValueContracts.createOrUpdate, "NamedValue");
@@clientName(NamedValueContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(NamedValueContracts.update, "NamedValue");
@@clientName(NamedValueContracts.update::parameters.properties, "parameters");
@@clientLocation(NamedValueContracts.delete, "NamedValue");
@@clientLocation(NamedValueContracts.listByService, "NamedValue");
@@clientLocation(NamedValueContracts.listValue, "NamedValue");
@@clientLocation(NamedValueContracts.refreshSecret, "NamedValue");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(NamedValueContract.properties);

@@clientLocation(NotificationContracts.get, "Notification");
@@clientLocation(NotificationContracts.createOrUpdate, "Notification");
@@clientLocation(NotificationContracts.listByService, "Notification");
@@clientLocation(NotificationContracts.listByNotification,
  "NotificationRecipientUser"
);
@@clientLocation(NotificationContracts.checkEntityExists,
  "NotificationRecipientUser"
);
@@clientLocation(NotificationContracts.notificationRecipientUserCreateOrUpdate,
  "NotificationRecipientUser"
);
@@clientName(NotificationContracts.notificationRecipientUserCreateOrUpdate,
  "CreateOrUpdate"
);
@@clientLocation(NotificationContracts.delete, "NotificationRecipientUser");
@@clientLocation(NotificationContracts.notificationRecipientEmailListByNotification,
  "NotificationRecipientEmail"
);
@@clientName(NotificationContracts.notificationRecipientEmailListByNotification,
  "ListByNotification"
);
@@clientLocation(NotificationContracts.notificationRecipientEmailCheckEntityExists,
  "NotificationRecipientEmail"
);
@@clientName(NotificationContracts.notificationRecipientEmailCheckEntityExists,
  "CheckEntityExists"
);
@@clientLocation(NotificationContracts.notificationRecipientEmailCreateOrUpdate,
  "NotificationRecipientEmail"
);
@@clientName(NotificationContracts.notificationRecipientEmailCreateOrUpdate,
  "CreateOrUpdate"
);
@@clientLocation(NotificationContracts.notificationRecipientEmailDelete,
  "NotificationRecipientEmail"
);
@@clientName(NotificationContracts.notificationRecipientEmailDelete, "Delete");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(NotificationContract.properties);

@@clientLocation(OpenidConnectProviderContracts.get, "OpenIdConnectProvider");
@@clientLocation(OpenidConnectProviderContracts.getEntityTag,
  "OpenIdConnectProvider"
);
@@clientLocation(OpenidConnectProviderContracts.createOrUpdate,
  "OpenIdConnectProvider"
);
@@clientName(OpenidConnectProviderContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(OpenidConnectProviderContracts.update,
  "OpenIdConnectProvider"
);
@@clientName(OpenidConnectProviderContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(OpenidConnectProviderContracts.delete,
  "OpenIdConnectProvider"
);
@@clientLocation(OpenidConnectProviderContracts.listByService,
  "OpenIdConnectProvider"
);
@@clientLocation(OpenidConnectProviderContracts.listSecrets,
  "OpenIdConnectProvider"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(OpenidConnectProviderContract.properties);

@@clientLocation(PortalRevisionContracts.get, "PortalRevision");
@@clientLocation(PortalRevisionContracts.getEntityTag, "PortalRevision");
@@clientLocation(PortalRevisionContracts.createOrUpdate, "PortalRevision");
@@clientName(PortalRevisionContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(PortalRevisionContracts.update, "PortalRevision");
@@clientName(PortalRevisionContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(PortalRevisionContracts.listByService, "PortalRevision");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PortalRevisionContract.properties);

@@clientName(SignInSettings.createOrUpdate::parameters.resource, "parameters");
@@clientName(SignInSettings.update::parameters.properties, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PortalSigninSettings.properties);

@@clientName(SignUpSettings.createOrUpdate::parameters.resource, "parameters");
@@clientName(SignUpSettings.update::parameters.properties, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PortalSignupSettings.properties);

@@clientName(DelegationSettings.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(DelegationSettings.update::parameters.properties, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PortalDelegationSettings.properties);

@@clientLocation(PrivateEndpointConnections.getByName,
  "PrivateEndpointConnection"
);
@@clientLocation(PrivateEndpointConnections.createOrUpdate,
  "PrivateEndpointConnection"
);
@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "privateEndpointConnectionRequest"
);
@@clientLocation(PrivateEndpointConnections.delete,
  "PrivateEndpointConnection"
);
@@clientLocation(PrivateEndpointConnections.listByService,
  "PrivateEndpointConnection"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PrivateEndpointConnection.properties);

@@clientLocation(PrivateLinkResources.getPrivateLinkResource,
  "PrivateEndpointConnection"
);
@@clientLocation(PrivateLinkResources.listPrivateLinkResources,
  "PrivateEndpointConnection"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PrivateLinkResource.properties);

@@clientLocation(SubscriptionContracts.get, "Subscription");
@@clientLocation(SubscriptionContracts.getEntityTag, "Subscription");
@@clientLocation(SubscriptionContracts.createOrUpdate, "Subscription");
@@clientName(SubscriptionContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(SubscriptionContracts.update, "Subscription");
@@clientName(SubscriptionContracts.update::parameters.properties, "parameters");
@@clientLocation(SubscriptionContracts.delete, "Subscription");
@@clientLocation(SubscriptionContracts.list, "Subscription");
@@clientLocation(SubscriptionContracts.regeneratePrimaryKey, "Subscription");
@@clientLocation(SubscriptionContracts.regenerateSecondaryKey, "Subscription");
@@clientLocation(SubscriptionContracts.listSecrets, "Subscription");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SubscriptionContract.properties);

@@clientLocation(GlobalSchemaContracts.get, "GlobalSchema");
@@clientLocation(GlobalSchemaContracts.getEntityTag, "GlobalSchema");
@@clientLocation(GlobalSchemaContracts.createOrUpdate, "GlobalSchema");
@@clientName(GlobalSchemaContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(GlobalSchemaContracts.delete, "GlobalSchema");
@@clientLocation(GlobalSchemaContracts.listByService, "GlobalSchema");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GlobalSchemaContract.properties);

@@clientLocation(TenantSettingsContracts.get, "TenantSettings");
@@clientLocation(TenantSettingsContracts.listByService, "TenantSettings");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(TenantSettingsContract.properties);

@@clientLocation(AccessInformationContracts.get, "TenantAccess");
@@clientLocation(AccessInformationContracts.getEntityTag, "TenantAccess");
@@clientLocation(AccessInformationContracts.create, "TenantAccess");
@@clientName(AccessInformationContracts.create::parameters.resource,
  "parameters"
);
@@clientLocation(AccessInformationContracts.update, "TenantAccess");
@@clientName(AccessInformationContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(AccessInformationContracts.listByService, "TenantAccess");
@@clientLocation(AccessInformationContracts.regeneratePrimaryKey,
  "TenantAccess"
);
@@clientLocation(AccessInformationContracts.regenerateSecondaryKey,
  "TenantAccess"
);
@@clientLocation(AccessInformationContracts.listSecrets, "TenantAccess");
@@clientLocation(AccessInformationContracts.tenantAccessGitRegeneratePrimaryKey,
  "TenantAccessGit"
);
@@clientName(AccessInformationContracts.tenantAccessGitRegeneratePrimaryKey,
  "RegeneratePrimaryKey"
);
@@clientLocation(AccessInformationContracts.tenantAccessGitRegenerateSecondaryKey,
  "TenantAccessGit"
);
@@clientName(AccessInformationContracts.tenantAccessGitRegenerateSecondaryKey,
  "RegenerateSecondaryKey"
);
@@clientLocation(AccessInformationContracts.deploy, "TenantConfiguration");
@@clientName(AccessInformationContracts.deploy::parameters.body, "parameters");
@@clientLocation(AccessInformationContracts.save, "TenantConfiguration");
@@clientName(AccessInformationContracts.save::parameters.body, "parameters");
@@clientLocation(AccessInformationContracts.validate, "TenantConfiguration");
@@clientName(AccessInformationContracts.validate::parameters.body,
  "parameters"
);
@@clientLocation(AccessInformationContracts.getSyncState,
  "TenantConfiguration"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AccessInformationContract.properties);

@@clientLocation(ApiExportOperationGroup.get, "ApiExport");

@@clientLocation(DeletedServicesOperationGroup.listBySubscription,
  "DeletedServices"
);

@@clientLocation(ApiManagementServiceOperationGroup.checkNameAvailability,
  "ApiManagementService"
);
@@clientLocation(ApiManagementServiceOperationGroup.getDomainOwnershipIdentifier,
  "ApiManagementService"
);

@@clientLocation(ApiManagementSkusOperationGroup.list, "ApiManagementSkus");
