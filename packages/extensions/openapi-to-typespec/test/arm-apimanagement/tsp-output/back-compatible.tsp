import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.ApiManagement;

@@clientName(ApiEntityBaseContract.type, "apiType");
@@clientName(ApiEntityBaseContract.subscriptionRequired,
  "IsSubscriptionRequired"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ErrorResponse.error);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiCreateOrUpdateParameter.properties);

@@clientName(ApiCreateOrUpdateProperties.apiType, "soapApiType");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiUpdateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OperationUpdateContract.properties);

@@clientName(ProductEntityBaseParameters.subscriptionRequired,
  "IsSubscriptionRequired"
);
@@clientName(ProductEntityBaseParameters.approvalRequired,
  "IsApprovalRequired"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SchemaContractProperties.document);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueUpdateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagDescriptionCreateParameters.properties);

@@clientName(ApiExportResult.format, "exportResultFormat");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiVersionSetUpdateParameters.properties);

@@clientName(AuthorizationServerContractBaseProperties.clientAuthenticationMethod,
  "clientAuthenticationMethods"
);
@@clientName(AuthorizationServerContractBaseProperties.supportState,
  "doesSupportState"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AuthorizationServerUpdateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BackendUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BackendReconnectContract.properties);

@@clientName(CacheContractProperties.resourceId, "resourceUri");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CacheUpdateParameters.properties);

@@clientName(CacheUpdateProperties.resourceId, "resourceUri");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CertificateCreateOrUpdateParameters.properties);

@@clientName(ConnectivityCheckRequestProtocolConfiguration.HTTPConfiguration,
  "httpConfiguration"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RemotePrivateEndpointConnectionWrapper.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiManagementServiceUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(EmailTemplateUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AssociationContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupCreateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupUpdateParameters.properties);

@@clientName(IdentityProviderBaseParameters.type, "identityProviderType");
@@clientName(IdentityProviderBaseParameters.signinTenant, "signInTenant");
@@clientName(IdentityProviderBaseParameters.signupPolicyName,
  "signUpPolicyName"
);
@@clientName(IdentityProviderBaseParameters.signinPolicyName,
  "signInPolicyName"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IdentityProviderCreateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IdentityProviderUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(LoggerUpdateContract.properties);

@@clientName(NamedValueEntityBaseParameters.secret, "IsSecret");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NamedValueCreateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NamedValueUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RecipientUserContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RecipientEmailContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OpenidConnectProviderUpdateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyDescriptionContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalSettingsContract.properties);

@@clientName(PortalSettingsContractProperties.subscriptions, "IsSubscriptions");
@@clientName(PortalSettingsContractProperties.userRegistration,
  "IsUserRegistration"
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ProductUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaCounterValueUpdateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GlobalSchemaContractProperties.document);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SubscriptionCreateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SubscriptionUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagCreateUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AccessInformationCreateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AccessInformationUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DeployConfigurationParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OperationResultContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SaveConfigurationParameter.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TenantConfigurationSyncStateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(UserCreateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(UserUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(UserTokenParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaCounterValueContract.value);

@@clientLocation(ApiContracts.get, "Api");
@@clientLocation(ApiContracts.getEntityTag, "Api");
@@clientName(ApiContracts.getEntityTag, "GetEntityTag");
@@clientLocation(ApiContracts.createOrUpdate, "Api");
@@clientName(ApiContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(ApiContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(ApiContracts.update, "Api");
@@clientName(ApiContracts.update::parameters.properties, "parameters");
@@clientLocation(ApiContracts.delete, "Api");
@@clientLocation(ApiContracts.listByService, "Api");
@@clientName(ApiContracts.listByService, "ListByService");
@@clientLocation(ApiContracts.apiRevisionListByService, "ApiRevision");
@@clientName(ApiContracts.apiRevisionListByService, "ListByService");
@@clientLocation(ApiContracts.listByApis, "ApiProduct");
@@clientName(ApiContracts.listByApis, "ListByApis");
@@clientLocation(ApiContracts.listByTags, "Operation");
@@clientName(ApiContracts.listByTags, "ListByTags");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiContract.properties);

@@clientLocation(ApiReleaseContracts.get, "ApiRelease");
@@clientLocation(ApiReleaseContracts.getEntityTag, "ApiRelease");
@@clientName(ApiReleaseContracts.getEntityTag, "GetEntityTag");
@@clientLocation(ApiReleaseContracts.createOrUpdate, "ApiRelease");
@@clientName(ApiReleaseContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(ApiReleaseContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(ApiReleaseContracts.update, "ApiRelease");
@@clientName(ApiReleaseContracts.update::parameters.properties, "parameters");
@@clientLocation(ApiReleaseContracts.delete, "ApiRelease");
@@clientLocation(ApiReleaseContracts.listByService, "ApiRelease");
@@clientName(ApiReleaseContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiReleaseContract.properties);

@@clientLocation(OperationContracts.get, "ApiOperation");
@@clientLocation(OperationContracts.getEntityTag, "ApiOperation");
@@clientName(OperationContracts.getEntityTag, "GetEntityTag");
@@clientLocation(OperationContracts.createOrUpdate, "ApiOperation");
@@clientName(OperationContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(OperationContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(OperationContracts.update, "ApiOperation");
@@clientName(OperationContracts.update::parameters.properties, "parameters");
@@clientLocation(OperationContracts.delete, "ApiOperation");
@@clientLocation(OperationContracts.listByApi, "ApiOperation");
@@clientName(OperationContracts.listByApi, "ListByApi");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OperationContract.properties);

@@clientLocation(PolicyContracts.get, "ApiOperationPolicy");
@@clientLocation(PolicyContracts.getEntityTag, "ApiOperationPolicy");
@@clientName(PolicyContracts.getEntityTag, "GetEntityTag");
@@clientLocation(PolicyContracts.createOrUpdate, "ApiOperationPolicy");
@@clientName(PolicyContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(PolicyContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(PolicyContracts.delete, "ApiOperationPolicy");
@@clientLocation(PolicyContracts.listByOperation, "ApiOperationPolicy");
@@clientName(PolicyContracts.listByOperation, "ListByOperation");
@@clientLocation(ApiPolicy.get, "ApiPolicy");
@@clientLocation(ApiPolicy.getEntityTag, "ApiPolicy");
@@clientName(ApiPolicy.getEntityTag, "GetEntityTag");
@@clientLocation(ApiPolicy.createOrUpdate, "ApiPolicy");
@@clientName(ApiPolicy.createOrUpdate, "CreateOrUpdate");
@@clientName(ApiPolicy.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(ApiPolicy.delete, "ApiPolicy");
@@clientLocation(ApiPolicy.listByApi, "ApiPolicy");
@@clientName(ApiPolicy.listByApi, "ListByApi");
@@clientName(Policy.getEntityTag, "GetEntityTag");
@@clientName(Policy.createOrUpdate, "CreateOrUpdate");
@@clientName(Policy.createOrUpdate::parameters.resource, "parameters");
@@clientName(Policy.listByService, "ListByService");
@@clientLocation(ProductPolicy.get, "ProductPolicy");
@@clientLocation(ProductPolicy.getEntityTag, "ProductPolicy");
@@clientName(ProductPolicy.getEntityTag, "GetEntityTag");
@@clientLocation(ProductPolicy.createOrUpdate, "ProductPolicy");
@@clientName(ProductPolicy.createOrUpdate, "CreateOrUpdate");
@@clientName(ProductPolicy.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(ProductPolicy.delete, "ProductPolicy");
@@clientLocation(ProductPolicy.listByProduct, "ProductPolicy");
@@clientName(ProductPolicy.listByProduct, "ListByProduct");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyContract.properties);

@@clientLocation(TagContracts.getByOperation, "Tag");
@@clientName(TagContracts.getByOperation, "GetByOperation");
@@clientLocation(TagContracts.getEntityStateByOperation, "Tag");
@@clientName(TagContracts.getEntityStateByOperation,
  "GetEntityStateByOperation"
);
@@clientLocation(TagContracts.assignToOperation, "Tag");
@@clientName(TagContracts.assignToOperation, "AssignToOperation");
@@clientLocation(TagContracts.detachFromOperation, "Tag");
@@clientName(TagContracts.detachFromOperation, "DetachFromOperation");
@@clientLocation(TagContracts.listByOperation, "Tag");
@@clientName(TagContracts.listByOperation, "ListByOperation");
@@clientName(Tag.getByApi, "GetByApi");
@@clientName(Tag.getEntityStateByApi, "GetEntityStateByApi");
@@clientName(Tag.assignToApi, "AssignToApi");
@@clientName(Tag.detachFromApi, "DetachFromApi");
@@clientName(Tag.listByApi, "ListByApi");
@@clientLocation(TagContractOperationGroup.getByProduct, "Tag");
@@clientName(TagContractOperationGroup.getByProduct, "GetByProduct");
@@clientLocation(TagContractOperationGroup.getEntityStateByProduct, "Tag");
@@clientName(TagContractOperationGroup.getEntityStateByProduct,
  "GetEntityStateByProduct"
);
@@clientLocation(TagContractOperationGroup.assignToProduct, "Tag");
@@clientName(TagContractOperationGroup.assignToProduct, "AssignToProduct");
@@clientLocation(TagContractOperationGroup.detachFromProduct, "Tag");
@@clientName(TagContractOperationGroup.detachFromProduct, "DetachFromProduct");
@@clientLocation(TagContractOperationGroup.listByProduct, "Tag");
@@clientName(TagContractOperationGroup.listByProduct, "ListByProduct");
@@clientLocation(TagContractOperationGroup.get, "Tag");
@@clientLocation(TagContractOperationGroup.getEntityState, "Tag");
@@clientName(TagContractOperationGroup.getEntityState, "GetEntityState");
@@clientLocation(TagContractOperationGroup.createOrUpdate, "Tag");
@@clientName(TagContractOperationGroup.createOrUpdate, "CreateOrUpdate");
@@clientName(TagContractOperationGroup.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(TagContractOperationGroup.update, "Tag");
@@clientName(TagContractOperationGroup.update::parameters.properties,
  "parameters"
);
@@clientLocation(TagContractOperationGroup.delete, "Tag");
@@clientLocation(TagContractOperationGroup.listByService, "Tag");
@@clientName(TagContractOperationGroup.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagContract.properties);

@@clientLocation(ProductContracts.get, "Product");
@@clientLocation(ProductContracts.getEntityTag, "Product");
@@clientName(ProductContracts.getEntityTag, "GetEntityTag");
@@clientLocation(ProductContracts.createOrUpdate, "Product");
@@clientName(ProductContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(ProductContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(ProductContracts.update, "Product");
@@clientName(ProductContracts.update::parameters.properties, "parameters");
@@clientLocation(ProductContracts.delete, "Product");
@@clientLocation(ProductContracts.listByService, "Product");
@@clientName(ProductContracts.listByService, "ListByService");
@@clientLocation(ProductContracts.listByProduct, "ProductApi");
@@clientName(ProductContracts.listByProduct, "ListByProduct");
@@clientLocation(ProductContracts.checkEntityExists, "ProductApi");
@@clientName(ProductContracts.checkEntityExists, "CheckEntityExists");
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
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ProductContract.properties);

@@clientLocation(SchemaContracts.get, "ApiSchema");
@@clientLocation(SchemaContracts.getEntityTag, "ApiSchema");
@@clientName(SchemaContracts.getEntityTag, "GetEntityTag");
@@clientLocation(SchemaContracts.createOrUpdate, "ApiSchema");
@@clientName(SchemaContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(SchemaContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(SchemaContracts.delete, "ApiSchema");
@@clientLocation(SchemaContracts.listByApi, "ApiSchema");
@@clientName(SchemaContracts.listByApi, "ListByApi");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SchemaContract.properties);

@@clientLocation(DiagnosticContracts.get, "ApiDiagnostic");
@@clientLocation(DiagnosticContracts.getEntityTag, "ApiDiagnostic");
@@clientName(DiagnosticContracts.getEntityTag, "GetEntityTag");
@@clientLocation(DiagnosticContracts.createOrUpdate, "ApiDiagnostic");
@@clientName(DiagnosticContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(DiagnosticContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(DiagnosticContracts.update, "ApiDiagnostic");
@@clientName(DiagnosticContracts.update::parameters.properties, "parameters");
@@clientLocation(DiagnosticContracts.delete, "ApiDiagnostic");
@@clientLocation(DiagnosticContracts.listByService, "ApiDiagnostic");
@@clientName(DiagnosticContracts.listByService, "ListByService");
@@clientName(Diagnostic.getEntityTag, "GetEntityTag");
@@clientName(Diagnostic.createOrUpdate, "CreateOrUpdate");
@@clientName(Diagnostic.createOrUpdate::parameters.resource, "parameters");
@@clientName(Diagnostic.update::parameters.properties, "parameters");
@@clientName(Diagnostic.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiagnosticContract.properties);

@@clientLocation(IssueContracts.get, "ApiIssue");
@@clientLocation(IssueContracts.getEntityTag, "ApiIssue");
@@clientName(IssueContracts.getEntityTag, "GetEntityTag");
@@clientLocation(IssueContracts.createOrUpdate, "ApiIssue");
@@clientName(IssueContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(IssueContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(IssueContracts.update, "ApiIssue");
@@clientName(IssueContracts.update::parameters.properties, "parameters");
@@clientLocation(IssueContracts.delete, "ApiIssue");
@@clientLocation(IssueContracts.listByService, "ApiIssue");
@@clientName(IssueContracts.listByService, "ListByService");
@@clientName(Issue.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueContract.properties);

@@clientLocation(IssueCommentContracts.get, "ApiIssueComment");
@@clientLocation(IssueCommentContracts.getEntityTag, "ApiIssueComment");
@@clientName(IssueCommentContracts.getEntityTag, "GetEntityTag");
@@clientLocation(IssueCommentContracts.createOrUpdate, "ApiIssueComment");
@@clientName(IssueCommentContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(IssueCommentContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(IssueCommentContracts.delete, "ApiIssueComment");
@@clientLocation(IssueCommentContracts.listByService, "ApiIssueComment");
@@clientName(IssueCommentContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueCommentContract.properties);

@@clientLocation(IssueAttachmentContracts.get, "ApiIssueAttachment");
@@clientLocation(IssueAttachmentContracts.getEntityTag, "ApiIssueAttachment");
@@clientName(IssueAttachmentContracts.getEntityTag, "GetEntityTag");
@@clientLocation(IssueAttachmentContracts.createOrUpdate, "ApiIssueAttachment");
@@clientName(IssueAttachmentContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(IssueAttachmentContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(IssueAttachmentContracts.delete, "ApiIssueAttachment");
@@clientLocation(IssueAttachmentContracts.listByService, "ApiIssueAttachment");
@@clientName(IssueAttachmentContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueAttachmentContract.properties);

@@clientLocation(TagDescriptionContracts.get, "ApiTagDescription");
@@clientLocation(TagDescriptionContracts.getEntityTag, "ApiTagDescription");
@@clientName(TagDescriptionContracts.getEntityTag, "GetEntityTag");
@@clientLocation(TagDescriptionContracts.createOrUpdate, "ApiTagDescription");
@@clientName(TagDescriptionContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(TagDescriptionContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(TagDescriptionContracts.delete, "ApiTagDescription");
@@clientLocation(TagDescriptionContracts.listByService, "ApiTagDescription");
@@clientName(TagDescriptionContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagDescriptionContract.properties);

@@clientLocation(ApiVersionSetContracts.get, "ApiVersionSet");
@@clientLocation(ApiVersionSetContracts.getEntityTag, "ApiVersionSet");
@@clientName(ApiVersionSetContracts.getEntityTag, "GetEntityTag");
@@clientLocation(ApiVersionSetContracts.createOrUpdate, "ApiVersionSet");
@@clientName(ApiVersionSetContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(ApiVersionSetContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(ApiVersionSetContracts.update, "ApiVersionSet");
@@clientName(ApiVersionSetContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(ApiVersionSetContracts.delete, "ApiVersionSet");
@@clientLocation(ApiVersionSetContracts.listByService, "ApiVersionSet");
@@clientName(ApiVersionSetContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiVersionSetContract.properties);

@@clientLocation(AuthorizationServerContracts.get, "AuthorizationServer");
@@clientLocation(AuthorizationServerContracts.getEntityTag,
  "AuthorizationServer"
);
@@clientName(AuthorizationServerContracts.getEntityTag, "GetEntityTag");
@@clientLocation(AuthorizationServerContracts.createOrUpdate,
  "AuthorizationServer"
);
@@clientName(AuthorizationServerContracts.createOrUpdate, "CreateOrUpdate");
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
@@clientName(AuthorizationServerContracts.listByService, "ListByService");
@@clientLocation(AuthorizationServerContracts.listSecrets,
  "AuthorizationServer"
);
@@clientName(AuthorizationServerContracts.listSecrets, "ListSecrets");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AuthorizationServerContract.properties);

@@clientLocation(BackendContracts.get, "Backend");
@@clientLocation(BackendContracts.getEntityTag, "Backend");
@@clientName(BackendContracts.getEntityTag, "GetEntityTag");
@@clientLocation(BackendContracts.createOrUpdate, "Backend");
@@clientName(BackendContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(BackendContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(BackendContracts.update, "Backend");
@@clientName(BackendContracts.update::parameters.properties, "parameters");
@@clientLocation(BackendContracts.delete, "Backend");
@@clientLocation(BackendContracts.listByService, "Backend");
@@clientName(BackendContracts.listByService, "ListByService");
@@clientLocation(BackendContracts.reconnect, "Backend");
@@clientName(BackendContracts.reconnect::parameters.body, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BackendContract.properties);

@@clientLocation(CacheContracts.get, "Cache");
@@clientLocation(CacheContracts.getEntityTag, "Cache");
@@clientName(CacheContracts.getEntityTag, "GetEntityTag");
@@clientLocation(CacheContracts.createOrUpdate, "Cache");
@@clientName(CacheContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(CacheContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(CacheContracts.update, "Cache");
@@clientName(CacheContracts.update::parameters.properties, "parameters");
@@clientLocation(CacheContracts.delete, "Cache");
@@clientLocation(CacheContracts.listByService, "Cache");
@@clientName(CacheContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CacheContract.properties);

@@clientLocation(CertificateContracts.get, "Certificate");
@@clientLocation(CertificateContracts.getEntityTag, "Certificate");
@@clientName(CertificateContracts.getEntityTag, "GetEntityTag");
@@clientLocation(CertificateContracts.createOrUpdate, "Certificate");
@@clientName(CertificateContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(CertificateContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(CertificateContracts.delete, "Certificate");
@@clientLocation(CertificateContracts.listByService, "Certificate");
@@clientName(CertificateContracts.listByService, "ListByService");
@@clientLocation(CertificateContracts.refreshSecret, "Certificate");
@@clientName(CertificateContracts.refreshSecret, "RefreshSecret");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CertificateContract.properties);

@@clientLocation(ContentTypeContracts.get, "ContentType");
@@clientLocation(ContentTypeContracts.createOrUpdate, "ContentType");
@@clientName(ContentTypeContracts.createOrUpdate, "CreateOrUpdate");
@@clientLocation(ContentTypeContracts.delete, "ContentType");
@@clientLocation(ContentTypeContracts.listByService, "ContentType");
@@clientName(ContentTypeContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ContentTypeContract.properties);

@@clientLocation(ContentItemContracts.get, "ContentItem");
@@clientLocation(ContentItemContracts.getEntityTag, "ContentItem");
@@clientName(ContentItemContracts.getEntityTag, "GetEntityTag");
@@clientLocation(ContentItemContracts.createOrUpdate, "ContentItem");
@@clientName(ContentItemContracts.createOrUpdate, "CreateOrUpdate");
@@clientLocation(ContentItemContracts.delete, "ContentItem");
@@clientLocation(ContentItemContracts.listByService, "ContentItem");
@@clientName(ContentItemContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ContentItemContract.properties);

@@clientLocation(DeletedServiceContracts.getByName, "DeletedServices");
@@clientName(DeletedServiceContracts.getByName, "GetByName");
@@clientLocation(DeletedServiceContracts.purge, "DeletedServices");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DeletedServiceContract.properties);

@@clientLocation(ApiManagementServiceResources.get, "ApiManagementService");
@@clientLocation(ApiManagementServiceResources.createOrUpdate,
  "ApiManagementService"
);
@@clientName(ApiManagementServiceResources.createOrUpdate, "CreateOrUpdate");
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
@@clientName(ApiManagementServiceResources.listByResourceGroup,
  "ListByResourceGroup"
);
@@clientLocation(ApiManagementServiceResources.list, "ApiManagementService");
@@clientLocation(ApiManagementServiceResources.listByTags, "Api");
@@clientName(ApiManagementServiceResources.listByTags, "ListByTags");
@@clientLocation(ApiManagementServiceResources.performConnectivityCheckAsync,
  ""
);
@@clientName(ApiManagementServiceResources.performConnectivityCheckAsync,
  "PerformConnectivityCheckAsync"
);
@@clientName(ApiManagementServiceResources.performConnectivityCheckAsync::parameters.body,
  "connectivityCheckRequestParams"
);
@@clientLocation(ApiManagementServiceResources.listAvailableServiceSkus,
  "ApiManagementServiceSkus"
);
@@clientName(ApiManagementServiceResources.listAvailableServiceSkus,
  "ListAvailableServiceSkus"
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
@@clientName(ApiManagementServiceResources.getSsoToken, "GetSsoToken");
@@clientLocation(ApiManagementServiceResources.applyNetworkConfigurationUpdates,
  "ApiManagementService"
);
@@clientName(ApiManagementServiceResources.applyNetworkConfigurationUpdates,
  "ApplyNetworkConfigurationUpdates"
);
@@clientName(ApiManagementServiceResources.applyNetworkConfigurationUpdates::parameters.body,
  "parameters"
);
@@clientLocation(ApiManagementServiceResources.listByService, "NetworkStatus");
@@clientName(ApiManagementServiceResources.listByService, "ListByService");
@@clientLocation(ApiManagementServiceResources.listByLocation, "NetworkStatus");
@@clientName(ApiManagementServiceResources.listByLocation, "ListByLocation");
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
@@clientName(ApiManagementServiceResources.listByApi, "ListByApi");
@@clientLocation(ApiManagementServiceResources.listByUser, "Reports");
@@clientName(ApiManagementServiceResources.listByUser, "ListByUser");
@@clientLocation(ApiManagementServiceResources.listByOperation, "Reports");
@@clientName(ApiManagementServiceResources.listByOperation, "ListByOperation");
@@clientLocation(ApiManagementServiceResources.listByProduct, "Reports");
@@clientName(ApiManagementServiceResources.listByProduct, "ListByProduct");
@@clientLocation(ApiManagementServiceResources.listByGeo, "Reports");
@@clientName(ApiManagementServiceResources.listByGeo, "ListByGeo");
@@clientLocation(ApiManagementServiceResources.listBySubscription, "Reports");
@@clientName(ApiManagementServiceResources.listBySubscription,
  "ListBySubscription"
);
@@clientLocation(ApiManagementServiceResources.listByTime, "Reports");
@@clientName(ApiManagementServiceResources.listByTime, "ListByTime");
@@clientLocation(ApiManagementServiceResources.listByRequest, "Reports");
@@clientName(ApiManagementServiceResources.listByRequest, "ListByRequest");
@@clientLocation(ApiManagementServiceResources.tagResourceListByService,
  "TagResource"
);
@@clientName(ApiManagementServiceResources.tagResourceListByService,
  "ListByService"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiManagementServiceResource.properties);

@@clientLocation(EmailTemplateContracts.get, "EmailTemplate");
@@clientLocation(EmailTemplateContracts.getEntityTag, "EmailTemplate");
@@clientName(EmailTemplateContracts.getEntityTag, "GetEntityTag");
@@clientLocation(EmailTemplateContracts.createOrUpdate, "EmailTemplate");
@@clientName(EmailTemplateContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(EmailTemplateContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(EmailTemplateContracts.update, "EmailTemplate");
@@clientName(EmailTemplateContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(EmailTemplateContracts.delete, "EmailTemplate");
@@clientLocation(EmailTemplateContracts.listByService, "EmailTemplate");
@@clientName(EmailTemplateContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(EmailTemplateContract.properties);

@@clientLocation(GatewayContracts.get, "Gateway");
@@clientLocation(GatewayContracts.getEntityTag, "Gateway");
@@clientName(GatewayContracts.getEntityTag, "GetEntityTag");
@@clientLocation(GatewayContracts.createOrUpdate, "Gateway");
@@clientName(GatewayContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(GatewayContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(GatewayContracts.update, "Gateway");
@@clientName(GatewayContracts.update::parameters.properties, "parameters");
@@clientLocation(GatewayContracts.delete, "Gateway");
@@clientLocation(GatewayContracts.listByService, "Gateway");
@@clientName(GatewayContracts.listByService, "ListByService");
@@clientLocation(GatewayContracts.listKeys, "Gateway");
@@clientName(GatewayContracts.listKeys, "ListKeys");
@@clientLocation(GatewayContracts.regenerateKey, "Gateway");
@@clientName(GatewayContracts.regenerateKey, "RegenerateKey");
@@clientName(GatewayContracts.regenerateKey::parameters.body, "parameters");
@@clientLocation(GatewayContracts.generateToken, "Gateway");
@@clientName(GatewayContracts.generateToken, "GenerateToken");
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
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GatewayContract.properties);

@@clientLocation(GatewayHostnameConfigurationContracts.get,
  "GatewayHostnameConfiguration"
);
@@clientLocation(GatewayHostnameConfigurationContracts.getEntityTag,
  "GatewayHostnameConfiguration"
);
@@clientName(GatewayHostnameConfigurationContracts.getEntityTag,
  "GetEntityTag"
);
@@clientLocation(GatewayHostnameConfigurationContracts.createOrUpdate,
  "GatewayHostnameConfiguration"
);
@@clientName(GatewayHostnameConfigurationContracts.createOrUpdate,
  "CreateOrUpdate"
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
@@clientName(GatewayHostnameConfigurationContracts.listByService,
  "ListByService"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GatewayHostnameConfigurationContract.properties);

@@clientLocation(GatewayCertificateAuthorityContracts.get,
  "GatewayCertificateAuthority"
);
@@clientLocation(GatewayCertificateAuthorityContracts.getEntityTag,
  "GatewayCertificateAuthority"
);
@@clientName(GatewayCertificateAuthorityContracts.getEntityTag, "GetEntityTag");
@@clientLocation(GatewayCertificateAuthorityContracts.createOrUpdate,
  "GatewayCertificateAuthority"
);
@@clientName(GatewayCertificateAuthorityContracts.createOrUpdate,
  "CreateOrUpdate"
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
@@clientName(GatewayCertificateAuthorityContracts.listByService,
  "ListByService"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GatewayCertificateAuthorityContract.properties);

@@clientLocation(GroupContracts.get, "Group");
@@clientLocation(GroupContracts.getEntityTag, "Group");
@@clientName(GroupContracts.getEntityTag, "GetEntityTag");
@@clientLocation(GroupContracts.createOrUpdate, "Group");
@@clientName(GroupContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(GroupContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(GroupContracts.update, "Group");
@@clientName(GroupContracts.update::parameters.properties, "parameters");
@@clientLocation(GroupContracts.delete, "Group");
@@clientLocation(GroupContracts.listByService, "Group");
@@clientName(GroupContracts.listByService, "ListByService");
@@clientLocation(GroupContracts.list, "GroupUser");
@@clientLocation(GroupContracts.checkEntityExists, "GroupUser");
@@clientName(GroupContracts.checkEntityExists, "CheckEntityExists");
@@clientLocation(GroupContracts.create, "GroupUser");
@@clientLocation(GroupContracts.groupUserDelete, "GroupUser");
@@clientName(GroupContracts.groupUserDelete, "Delete");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupContract.properties);

@@clientLocation(UserContracts.get, "User");
@@clientLocation(UserContracts.getEntityTag, "User");
@@clientName(UserContracts.getEntityTag, "GetEntityTag");
@@clientLocation(UserContracts.createOrUpdate, "User");
@@clientName(UserContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(UserContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(UserContracts.update, "User");
@@clientName(UserContracts.update::parameters.properties, "parameters");
@@clientLocation(UserContracts.delete, "User");
@@clientLocation(UserContracts.listByService, "User");
@@clientName(UserContracts.listByService, "ListByService");
@@clientLocation(UserContracts.generateSsoUrl, "User");
@@clientName(UserContracts.generateSsoUrl, "GenerateSsoUrl");
@@clientLocation(UserContracts.getSharedAccessToken, "User");
@@clientName(UserContracts.getSharedAccessToken, "GetSharedAccessToken");
@@clientName(UserContracts.getSharedAccessToken::parameters.body, "parameters");
@@clientLocation(UserContracts.list, "UserGroup");
@@clientLocation(UserContracts.userIdentitiesList, "UserIdentities");
@@clientName(UserContracts.userIdentitiesList, "List");
@@clientLocation(UserContracts.send, "UserConfirmationPassword");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(UserContract.properties);

@@clientLocation(IdentityProviderContracts.get, "IdentityProvider");
@@clientLocation(IdentityProviderContracts.getEntityTag, "IdentityProvider");
@@clientName(IdentityProviderContracts.getEntityTag, "GetEntityTag");
@@clientLocation(IdentityProviderContracts.createOrUpdate, "IdentityProvider");
@@clientName(IdentityProviderContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(IdentityProviderContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(IdentityProviderContracts.update, "IdentityProvider");
@@clientName(IdentityProviderContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(IdentityProviderContracts.delete, "IdentityProvider");
@@clientLocation(IdentityProviderContracts.listByService, "IdentityProvider");
@@clientName(IdentityProviderContracts.listByService, "ListByService");
@@clientLocation(IdentityProviderContracts.listSecrets, "IdentityProvider");
@@clientName(IdentityProviderContracts.listSecrets, "ListSecrets");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IdentityProviderContract.properties);

@@clientLocation(LoggerContracts.get, "Logger");
@@clientLocation(LoggerContracts.getEntityTag, "Logger");
@@clientName(LoggerContracts.getEntityTag, "GetEntityTag");
@@clientLocation(LoggerContracts.createOrUpdate, "Logger");
@@clientName(LoggerContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(LoggerContracts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(LoggerContracts.update, "Logger");
@@clientName(LoggerContracts.update::parameters.properties, "parameters");
@@clientLocation(LoggerContracts.delete, "Logger");
@@clientLocation(LoggerContracts.listByService, "Logger");
@@clientName(LoggerContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(LoggerContract.properties);

@@clientLocation(NamedValueContracts.get, "NamedValue");
@@clientLocation(NamedValueContracts.getEntityTag, "NamedValue");
@@clientName(NamedValueContracts.getEntityTag, "GetEntityTag");
@@clientLocation(NamedValueContracts.createOrUpdate, "NamedValue");
@@clientName(NamedValueContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(NamedValueContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(NamedValueContracts.update, "NamedValue");
@@clientName(NamedValueContracts.update::parameters.properties, "parameters");
@@clientLocation(NamedValueContracts.delete, "NamedValue");
@@clientLocation(NamedValueContracts.listByService, "NamedValue");
@@clientName(NamedValueContracts.listByService, "ListByService");
@@clientLocation(NamedValueContracts.listValue, "NamedValue");
@@clientName(NamedValueContracts.listValue, "ListValue");
@@clientLocation(NamedValueContracts.refreshSecret, "NamedValue");
@@clientName(NamedValueContracts.refreshSecret, "RefreshSecret");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NamedValueContract.properties);

@@clientLocation(NotificationContracts.get, "Notification");
@@clientLocation(NotificationContracts.createOrUpdate, "Notification");
@@clientName(NotificationContracts.createOrUpdate, "CreateOrUpdate");
@@clientLocation(NotificationContracts.listByService, "Notification");
@@clientName(NotificationContracts.listByService, "ListByService");
@@clientLocation(NotificationContracts.listByNotification,
  "NotificationRecipientUser"
);
@@clientName(NotificationContracts.listByNotification, "ListByNotification");
@@clientLocation(NotificationContracts.checkEntityExists,
  "NotificationRecipientUser"
);
@@clientName(NotificationContracts.checkEntityExists, "CheckEntityExists");
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
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NotificationContract.properties);

@@clientLocation(OpenidConnectProviderContracts.get, "OpenIdConnectProvider");
@@clientLocation(OpenidConnectProviderContracts.getEntityTag,
  "OpenIdConnectProvider"
);
@@clientName(OpenidConnectProviderContracts.getEntityTag, "GetEntityTag");
@@clientLocation(OpenidConnectProviderContracts.createOrUpdate,
  "OpenIdConnectProvider"
);
@@clientName(OpenidConnectProviderContracts.createOrUpdate, "CreateOrUpdate");
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
@@clientName(OpenidConnectProviderContracts.listByService, "ListByService");
@@clientLocation(OpenidConnectProviderContracts.listSecrets,
  "OpenIdConnectProvider"
);
@@clientName(OpenidConnectProviderContracts.listSecrets, "ListSecrets");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OpenidConnectProviderContract.properties);

@@clientLocation(PortalRevisionContracts.get, "PortalRevision");
@@clientLocation(PortalRevisionContracts.getEntityTag, "PortalRevision");
@@clientName(PortalRevisionContracts.getEntityTag, "GetEntityTag");
@@clientLocation(PortalRevisionContracts.createOrUpdate, "PortalRevision");
@@clientName(PortalRevisionContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(PortalRevisionContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(PortalRevisionContracts.update, "PortalRevision");
@@clientName(PortalRevisionContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(PortalRevisionContracts.listByService, "PortalRevision");
@@clientName(PortalRevisionContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalRevisionContract.properties);

@@clientLocation(SignInSettings.get, "SignInSettings");
@@clientLocation(SignInSettings.getEntityTag, "SignInSettings");
@@clientName(SignInSettings.getEntityTag, "GetEntityTag");
@@clientLocation(SignInSettings.createOrUpdate, "SignInSettings");
@@clientName(SignInSettings.createOrUpdate, "CreateOrUpdate");
@@clientName(SignInSettings.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(SignInSettings.update, "SignInSettings");
@@clientName(SignInSettings.update::parameters.properties, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalSigninSettings.properties);

@@clientLocation(SignUpSettings.get, "SignUpSettings");
@@clientLocation(SignUpSettings.getEntityTag, "SignUpSettings");
@@clientName(SignUpSettings.getEntityTag, "GetEntityTag");
@@clientLocation(SignUpSettings.createOrUpdate, "SignUpSettings");
@@clientName(SignUpSettings.createOrUpdate, "CreateOrUpdate");
@@clientName(SignUpSettings.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(SignUpSettings.update, "SignUpSettings");
@@clientName(SignUpSettings.update::parameters.properties, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalSignupSettings.properties);

@@clientLocation(DelegationSettings.get, "DelegationSettings");
@@clientLocation(DelegationSettings.getEntityTag, "DelegationSettings");
@@clientName(DelegationSettings.getEntityTag, "GetEntityTag");
@@clientLocation(DelegationSettings.createOrUpdate, "DelegationSettings");
@@clientName(DelegationSettings.createOrUpdate, "CreateOrUpdate");
@@clientName(DelegationSettings.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(DelegationSettings.update, "DelegationSettings");
@@clientName(DelegationSettings.update::parameters.properties, "parameters");
@@clientLocation(DelegationSettings.listSecrets, "DelegationSettings");
@@clientName(DelegationSettings.listSecrets, "ListSecrets");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalDelegationSettings.properties);

@@clientLocation(PrivateEndpointConnections.getByName,
  "PrivateEndpointConnection"
);
@@clientName(PrivateEndpointConnections.getByName, "GetByName");
@@clientLocation(PrivateEndpointConnections.createOrUpdate,
  "PrivateEndpointConnection"
);
@@clientName(PrivateEndpointConnections.createOrUpdate, "CreateOrUpdate");
@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "privateEndpointConnectionRequest"
);
@@clientLocation(PrivateEndpointConnections.delete,
  "PrivateEndpointConnection"
);
@@clientLocation(PrivateEndpointConnections.listByService,
  "PrivateEndpointConnection"
);
@@clientName(PrivateEndpointConnections.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

@@clientLocation(PrivateLinkResources.getPrivateLinkResource,
  "PrivateEndpointConnection"
);
@@clientName(PrivateLinkResources.getPrivateLinkResource,
  "GetPrivateLinkResource"
);
@@clientLocation(PrivateLinkResources.listPrivateLinkResources,
  "PrivateEndpointConnection"
);
@@clientName(PrivateLinkResources.listPrivateLinkResources,
  "ListPrivateLinkResources"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateLinkResource.properties);

@@clientLocation(SubscriptionContracts.get, "Subscription");
@@clientLocation(SubscriptionContracts.getEntityTag, "Subscription");
@@clientName(SubscriptionContracts.getEntityTag, "GetEntityTag");
@@clientLocation(SubscriptionContracts.createOrUpdate, "Subscription");
@@clientName(SubscriptionContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(SubscriptionContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(SubscriptionContracts.update, "Subscription");
@@clientName(SubscriptionContracts.update::parameters.properties, "parameters");
@@clientLocation(SubscriptionContracts.delete, "Subscription");
@@clientLocation(SubscriptionContracts.list, "Subscription");
@@clientLocation(SubscriptionContracts.regeneratePrimaryKey, "Subscription");
@@clientName(SubscriptionContracts.regeneratePrimaryKey,
  "RegeneratePrimaryKey"
);
@@clientLocation(SubscriptionContracts.regenerateSecondaryKey, "Subscription");
@@clientName(SubscriptionContracts.regenerateSecondaryKey,
  "RegenerateSecondaryKey"
);
@@clientLocation(SubscriptionContracts.listSecrets, "Subscription");
@@clientName(SubscriptionContracts.listSecrets, "ListSecrets");
@@clientLocation(UserSubscription.get, "UserSubscription");
@@clientLocation(UserSubscription.list, "UserSubscription");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SubscriptionContract.properties);

@@clientLocation(GlobalSchemaContracts.get, "GlobalSchema");
@@clientLocation(GlobalSchemaContracts.getEntityTag, "GlobalSchema");
@@clientName(GlobalSchemaContracts.getEntityTag, "GetEntityTag");
@@clientLocation(GlobalSchemaContracts.createOrUpdate, "GlobalSchema");
@@clientName(GlobalSchemaContracts.createOrUpdate, "CreateOrUpdate");
@@clientName(GlobalSchemaContracts.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(GlobalSchemaContracts.delete, "GlobalSchema");
@@clientLocation(GlobalSchemaContracts.listByService, "GlobalSchema");
@@clientName(GlobalSchemaContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GlobalSchemaContract.properties);

@@clientLocation(TenantSettingsContracts.get, "TenantSettings");
@@clientLocation(TenantSettingsContracts.listByService, "TenantSettings");
@@clientName(TenantSettingsContracts.listByService, "ListByService");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TenantSettingsContract.properties);

@@clientLocation(AccessInformationContracts.get, "TenantAccess");
@@clientLocation(AccessInformationContracts.getEntityTag, "TenantAccess");
@@clientName(AccessInformationContracts.getEntityTag, "GetEntityTag");
@@clientLocation(AccessInformationContracts.create, "TenantAccess");
@@clientName(AccessInformationContracts.create::parameters.resource,
  "parameters"
);
@@clientLocation(AccessInformationContracts.update, "TenantAccess");
@@clientName(AccessInformationContracts.update::parameters.properties,
  "parameters"
);
@@clientLocation(AccessInformationContracts.listByService, "TenantAccess");
@@clientName(AccessInformationContracts.listByService, "ListByService");
@@clientLocation(AccessInformationContracts.regeneratePrimaryKey,
  "TenantAccess"
);
@@clientName(AccessInformationContracts.regeneratePrimaryKey,
  "RegeneratePrimaryKey"
);
@@clientLocation(AccessInformationContracts.regenerateSecondaryKey,
  "TenantAccess"
);
@@clientName(AccessInformationContracts.regenerateSecondaryKey,
  "RegenerateSecondaryKey"
);
@@clientLocation(AccessInformationContracts.listSecrets, "TenantAccess");
@@clientName(AccessInformationContracts.listSecrets, "ListSecrets");
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
@@clientName(AccessInformationContracts.getSyncState, "GetSyncState");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AccessInformationContract.properties);

@@clientLocation(ApiExportOperationGroup.get, "ApiExport");

@@clientLocation(DeletedServicesOperationGroup.listBySubscription,
  "DeletedServices"
);
@@clientName(DeletedServicesOperationGroup.listBySubscription,
  "ListBySubscription"
);

@@clientLocation(ApiManagementServiceOperationGroup.checkNameAvailability,
  "ApiManagementService"
);
@@clientName(ApiManagementServiceOperationGroup.checkNameAvailability,
  "CheckNameAvailability"
);
@@clientLocation(ApiManagementServiceOperationGroup.getDomainOwnershipIdentifier,
  "ApiManagementService"
);
@@clientName(ApiManagementServiceOperationGroup.getDomainOwnershipIdentifier,
  "GetDomainOwnershipIdentifier"
);

@@clientLocation(ApiManagementSkusOperationGroup.list, "ApiManagementSkus");
