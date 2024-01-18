import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
/**
 * Azure OpenAI APIs for completions and search
 */
@useAuth(
  AadOauth2Auth<["api.read"]> | ApiKeyAuth<ApiKeyLocation.header, "api-key">
)
@service({
  title: "OpenAI",
})
@versioned(Versions)
@server(
  "https://{endpoint}/openai",
  "Azure OpenAI APIs for completions and search",
  {
    endpoint: string,
  }
)
namespace Azure.AI.OpenAI;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2022-06-01-preview API version.
   */
  v2022_06_01_preview: "2022-06-01-preview",
}
