import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./Api.tsp";
import "./ApiRelease.tsp";
import "./ApiOperation.tsp";
import "./ApiOperationPolicy.tsp";
import "./ApiPolicy.tsp";
import "./ApiManagementPolicy.tsp";
import "./ApiManagementProductPolicy.tsp";
import "./ApiOperationTag.tsp";
import "./ApiTag.tsp";
import "./ApiManagementProductTag.tsp";
import "./ApiManagementTag.tsp";
import "./ApiSchema.tsp";
import "./ApiDiagnostic.tsp";
import "./ApiManagementDiagnostic.tsp";
import "./ApiIssue.tsp";
import "./ApiManagementIssue.tsp";
import "./ApiIssueComment.tsp";
import "./ApiIssueAttachment.tsp";
import "./ApiTagDescription.tsp";
import "./ApiVersionSet.tsp";
import "./ApiManagementAuthorizationServer.tsp";
import "./ApiManagementBackend.tsp";
import "./ApiManagementCache.tsp";
import "./ApiManagementCertificate.tsp";
import "./ApiManagementDeletedService.tsp";
import "./ApiManagementService.tsp";
import "./ApiManagementEmailTemplate.tsp";
import "./ApiManagementGateway.tsp";
import "./ApiManagementGatewayHostnameConfiguration.tsp";
import "./ApiManagementGatewayCertificateAuthority.tsp";
import "./ApiManagementGroup.tsp";
import "./ApiManagementIdentityProvider.tsp";
import "./ApiManagementLogger.tsp";
import "./ApiManagementNamedValue.tsp";
import "./ApiManagementNotification.tsp";
import "./ApiManagementOpenIdConnectProvider.tsp";
import "./ApiManagementPortalRevision.tsp";
import "./ApiManagementPortalSignInSetting.tsp";
import "./ApiManagementPortalSignUpSetting.tsp";
import "./ApiManagementPortalDelegationSetting.tsp";
import "./ApiManagementPrivateEndpointConnection.tsp";
import "./ApiManagementPrivateLinkResource.tsp";
import "./ApiManagementProduct.tsp";
import "./ApiManagementGlobalSchema.tsp";
import "./ApiManagementTenantSetting.tsp";
import "./ApiManagementSubscription.tsp";
import "./ApiManagementUserSubscription.tsp";
import "./TenantAccessInfo.tsp";
import "./ApiManagementUser.tsp";
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
