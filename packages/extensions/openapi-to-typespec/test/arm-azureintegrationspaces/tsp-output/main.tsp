import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./Space.tsp";
import "./Application.tsp";
import "./BusinessProcess.tsp";
import "./BusinessProcessVersion.tsp";
import "./InfrastructureResource.tsp";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
/**
 * The azure integration spaces resource provider.
 */
@armProviderNamespace
@useAuth(AadOauth2Auth<["user_impersonation"]>)
@service({
  title: "Azure Integration Spaces resource management API.",
})
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v3)
namespace Microsoft.IntegrationSpaces;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2023-11-14-preview API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2023_11_14_preview: "2023-11-14-preview",
}
