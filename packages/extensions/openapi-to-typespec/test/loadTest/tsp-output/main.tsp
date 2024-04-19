import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
/**
 * These APIs allow end users to create, view and run load tests using Azure Load
 * Test Service.
 */
@useAuth(AadOauth2Auth<["https://cnt-prod.loadtesting.azure.com/.default"]>)
@service({
  title: "Load Testing Service",
})
@versioned(Versions)
@server(
  "https://{Endpoint}",
  "These APIs allow end users to create, view and run load tests using Azure Load Test Service.",
  {
    Endpoint: string,
  }
)
namespace Azure.LoadTesting;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2022-11-01 API version.
   */
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_11_01: "2022-11-01",
}
