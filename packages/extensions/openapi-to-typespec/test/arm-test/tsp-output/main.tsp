import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./Employee.tsp";
import "./Enroll.tsp";
import "./DictProperty.tsp";
import "./ArrayDefault.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
/**
 * For test.
 */
@armProviderNamespace
@useAuth(AadOauth2Auth<["user_impersonation"]>)
@service({
  title: "Azure Test resource management API.",
})
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v3)
namespace Microsoft.Test;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2023-10-12 API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2023_10_12: "2023-10-12",
}
