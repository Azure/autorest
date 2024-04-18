import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
/**
 * A client for issuing REST requests to the Azure Batch service.
 */
@useAuth(
  AadOauth2Auth<["user_impersonation"]> | ApiKeyAuth<
    ApiKeyLocation.header,
    "Authorization"
  >
)
@service({
  title: "Azure Batch Service",
})
@versioned(Versions)
@server(
  "{batchUrl}",
  "A client for issuing REST requests to the Azure Batch service.",
  {
    batchUrl: string,
  }
)
namespace Azure.Batch;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2022-01-01.15.0 API version.
   */
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_01_01_15_0: "2022-01-01.15.0",
}
