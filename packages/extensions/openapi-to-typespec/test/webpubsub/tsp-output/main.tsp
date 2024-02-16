import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
/**
 * // FIXME: (missing-service-description) Add service description
 */
@service({
  title: "Azure Web PubSub Service REST API",
})
@versioned(Versions)
@server(
  "{endpoint}",
  "// FIXME: (missing-service-description) Add service description",
  {
    endpoint: string,
  }
)
namespace AzureWebPubSubServiceRESTAPI;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2023-07-01 API version.
   */
  v2023_07_01: "2023-07-01",
}
