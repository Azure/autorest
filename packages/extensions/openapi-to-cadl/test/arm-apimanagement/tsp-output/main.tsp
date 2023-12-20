import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./ApiContract.tsp";
import "./ApiReleaseContract.tsp";
import "./OperationContract.tsp";
import "./PolicyContract.tsp";
import "./PolicyContract.tsp";
import "./PolicyContract.tsp";
import "./PolicyContract.tsp";
import "./TagContract.tsp";
import "./TagContract.tsp";
import "./TagContract.tsp";
import "./TagContract.tsp";
import "./SchemaContract.tsp";
import "./DiagnosticContract.tsp";
import "./DiagnosticContract.tsp";
import "./IssueContract.tsp";
import "./IssueContract.tsp";
import "./IssueCommentContract.tsp";
import "./IssueAttachmentContract.tsp";
import "./TagDescriptionContract.tsp";
import "./ApiVersionSetContract.tsp";
import "./AuthorizationServerContract.tsp";
import "./BackendContract.tsp";
import "./CacheContract.tsp";
import "./CertificateContract.tsp";
import "./DeletedServiceContract.tsp";
import "./ApiManagementServiceResource.tsp";
import "./EmailTemplateContract.tsp";
import "./GatewayContract.tsp";
import "./GatewayHostnameConfigurationContract.tsp";
import "./GatewayCertificateAuthorityContract.tsp";
import "./GroupContract.tsp";
import "./IdentityProviderContract.tsp";
import "./LoggerContract.tsp";
import "./NamedValueContract.tsp";
import "./NotificationContract.tsp";
import "./OpenidConnectProviderContract.tsp";
import "./PortalRevisionContract.tsp";
import "./PortalSigninSettings.tsp";
import "./PortalSignupSettings.tsp";
import "./PortalDelegationSettings.tsp";
import "./PrivateEndpointConnection.tsp";
import "./PrivateLinkResource.tsp";
import "./ProductContract.tsp";
import "./GlobalSchemaContract.tsp";
import "./TenantSettingsContract.tsp";
import "./SubscriptionContract.tsp";
import "./SubscriptionContract.tsp";
import "./AccessInformationContract.tsp";
import "./UserContract.tsp";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
@armProviderNamespace
@service({
  title: "ApiManagementClient",
})
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v2)
@doc("ApiManagement Client")
namespace Azure.ResourceManager.ApiManagement;

@doc("The available API versions.")
enum Versions {
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2021_08_01: "2021-08-01",
}
