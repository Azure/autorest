import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.ApiManagement;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiCreateOrUpdateParameter.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiUpdateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OperationUpdateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SchemaContractProperties.document);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueUpdateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagDescriptionCreateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiVersionSetUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AuthorizationServerUpdateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BackendUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BackendReconnectContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CacheUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CertificateCreateOrUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ContentTypeContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ContentItemContract.properties);

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

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IdentityProviderCreateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IdentityProviderUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(LoggerUpdateContract.properties);

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

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiReleaseContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OperationContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ProductContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SchemaContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiagnosticContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueCommentContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueAttachmentContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagDescriptionContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiVersionSetContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AuthorizationServerContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BackendContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CacheContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CertificateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DeletedServiceContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiManagementServiceResource.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(EmailTemplateContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GatewayContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GatewayHostnameConfigurationContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GatewayCertificateAuthorityContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(UserContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IdentityProviderContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(LoggerContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NamedValueContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NotificationContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OpenidConnectProviderContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalRevisionContract.properties);

@@clientName(PortalSigninSettingsOperationGroup, "PortalSigninSettings");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalSigninSettings.properties);

@@clientName(PortalSignupSettingsOperationGroup, "PortalSignupSettings");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalSignupSettings.properties);

@@clientName(PortalDelegationSettingsOperationGroup,
  "PortalDelegationSettings"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalDelegationSettings.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateLinkResource.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SubscriptionContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GlobalSchemaContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TenantSettingsContract.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AccessInformationContract.properties);
