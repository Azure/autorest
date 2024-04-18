import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
/**
 * Long-running Operation for AutoRest
 */
@service({
  title: "AutoRest Paging Test Service",
})
@versioned(Versions)
@server(
  "{$host}",
  "Long-running Operation for AutoRest",
  {
    $host: string,
  }
)
namespace AutoRestPagingTestService;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 1.0.0 API version.
   */
  v1_0_0: "1.0.0",
}
