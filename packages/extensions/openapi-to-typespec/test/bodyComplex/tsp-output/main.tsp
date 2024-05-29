import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
/**
 * Test Infrastructure for AutoRest
 */
@service({
  title: "AutoRest Complex Test Service",
})
@versioned(Versions)
@server(
  "{$host}",
  "Test Infrastructure for AutoRest",
  {
    $host: string,
  }
)
namespace AutoRestComplexTestService;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2016-02-29 API version.
   */
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2016_02_29: "2016-02-29",
}
