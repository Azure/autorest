import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";


using Azure.ClientGenerator.Core;
using Azure.ResourceManager.ApiManagement;



#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiCreateOrUpdateParameter.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiUpdateContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OperationUpdateContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SchemaContractProperties.document)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueUpdateContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagDescriptionCreateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiVersionSetUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AuthorizationServerUpdateContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BackendUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BackendReconnectContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CacheUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CertificateCreateOrUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RemotePrivateEndpointConnectionWrapper.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiManagementServiceUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(EmailTemplateUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AssociationContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupCreateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IdentityProviderCreateContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IdentityProviderUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(LoggerUpdateContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NamedValueCreateContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NamedValueUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RecipientUserContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RecipientEmailContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OpenidConnectProviderUpdateContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyDescriptionContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalSettingsContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ProductUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaCounterValueUpdateContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GlobalSchemaContractProperties.document)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SubscriptionCreateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SubscriptionUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagCreateUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AccessInformationCreateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AccessInformationUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DeployConfigurationParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OperationResultContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SaveConfigurationParameter.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TenantConfigurationSyncStateContract.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(UserCreateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(UserUpdateParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(UserTokenParameters.properties)


#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QuotaCounterValueContract.value)


@@clientName(ApiContracts.update, "ApiContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiContract.properties)

@@clientName(ApiReleaseContracts.update, "ApiReleaseContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiReleaseContract.properties)

@@clientName(OperationContracts.update, "OperationContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OperationContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PolicyContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagContract.properties)

@@clientName(ProductContracts.update, "ProductContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ProductContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SchemaContract.properties)

@@clientName(DiagnosticContracts.update, "DiagnosticContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiagnosticContract.properties)

@@clientName(IssueContracts.update, "IssueContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueCommentContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IssueAttachmentContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TagDescriptionContract.properties)

@@clientName(ApiVersionSetContracts.update, "ApiVersionSetContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiVersionSetContract.properties)

@@clientName(AuthorizationServerContracts.update, "AuthorizationServerContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AuthorizationServerContract.properties)

@@clientName(BackendContracts.update, "BackendContracts.update::parameters.properties", "parameters")
@@clientName(BackendContracts.reconnect, "BackendContracts.reconnect::parameters.body", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BackendContract.properties)

@@clientName(CacheContracts.update, "CacheContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CacheContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CertificateContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ContentTypeContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ContentItemContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DeletedServiceContract.properties)

@@clientName(ApiManagementServiceResources.update, "ApiManagementServiceResources.update::parameters.properties", "parameters")
@@clientName(ApiManagementServiceResources.performConnectivityCheckAsync, "ApiManagementServiceResources.performConnectivityCheckAsync::parameters.body", "connectivityCheckRequestParams")
@@clientName(ApiManagementServiceResources.restore, "ApiManagementServiceResources.restore::parameters.body", "parameters")
@@clientName(ApiManagementServiceResources.backup, "ApiManagementServiceResources.backup::parameters.body", "parameters")
@@clientName(ApiManagementServiceResources.applyNetworkConfigurationUpdates, "ApiManagementServiceResources.applyNetworkConfigurationUpdates::parameters.body", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ApiManagementServiceResource.properties)

@@clientName(EmailTemplateContracts.update, "EmailTemplateContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(EmailTemplateContract.properties)

@@clientName(GatewayContracts.update, "GatewayContracts.update::parameters.properties", "parameters")
@@clientName(GatewayContracts.regenerateKey, "GatewayContracts.regenerateKey::parameters.body", "parameters")
@@clientName(GatewayContracts.generateToken, "GatewayContracts.generateToken::parameters.body", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GatewayContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GatewayHostnameConfigurationContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GatewayCertificateAuthorityContract.properties)

@@clientName(GroupContracts.update, "GroupContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GroupContract.properties)

@@clientName(UserContracts.update, "UserContracts.update::parameters.properties", "parameters")
@@clientName(UserContracts.getSharedAccessToken, "UserContracts.getSharedAccessToken::parameters.body", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(UserContract.properties)

@@clientName(IdentityProviderContracts.update, "IdentityProviderContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(IdentityProviderContract.properties)

@@clientName(LoggerContracts.update, "LoggerContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(LoggerContract.properties)

@@clientName(NamedValueContracts.update, "NamedValueContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NamedValueContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NotificationContract.properties)

@@clientName(OpenidConnectProviderContracts.update, "OpenidConnectProviderContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OpenidConnectProviderContract.properties)

@@clientName(PortalRevisionContracts.update, "PortalRevisionContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalRevisionContract.properties)

@@clientName(PortalSigninSettingsOperationGroup, "PortalSigninSettings")
@@clientName(PortalSigninSettingsOperationGroup}.update, "PortalSigninSettingsOperationGroup.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalSigninSettings.properties)

@@clientName(PortalSignupSettingsOperationGroup, "PortalSignupSettings")
@@clientName(PortalSignupSettingsOperationGroup}.update, "PortalSignupSettingsOperationGroup.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalSignupSettings.properties)

@@clientName(PortalDelegationSettingsOperationGroup, "PortalDelegationSettings")
@@clientName(PortalDelegationSettingsOperationGroup}.update, "PortalDelegationSettingsOperationGroup.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PortalDelegationSettings.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateLinkResource.properties)

@@clientName(SubscriptionContracts.update, "SubscriptionContracts.update::parameters.properties", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SubscriptionContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GlobalSchemaContract.properties)

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TenantSettingsContract.properties)

@@clientName(AccessInformationContracts.update, "AccessInformationContracts.update::parameters.properties", "parameters")
@@clientName(AccessInformationContracts.deploy, "AccessInformationContracts.deploy::parameters.body", "parameters")
@@clientName(AccessInformationContracts.save, "AccessInformationContracts.save::parameters.body", "parameters")
@@clientName(AccessInformationContracts.validate, "AccessInformationContracts.validate::parameters.body", "parameters")
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AccessInformationContract.properties)


