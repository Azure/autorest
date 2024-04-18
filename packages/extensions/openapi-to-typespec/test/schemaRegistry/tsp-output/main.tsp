import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
/**
 * Azure Schema Registry is as a central schema repository, with support for
 * versioning, management, compatibility checking, and RBAC.
 */
@service({
  title: "Azure Schema Registry",
})
@versioned(Versions)
@server(
  "https://{endpoint}",
  "Azure Schema Registry is as a central schema repository, with support for versioning, management, compatibility checking, and RBAC.",
  {
    endpoint: string,
  }
)
namespace AzureSchemaRegistry;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2021-10 API version.
   */
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2021_10: "2021-10",
}
