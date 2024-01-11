import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
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
@doc("Azure OpenAI APIs for completions and search")
namespace Azure.AI.OpenAI;

@doc("The available API versions.")
enum Versions {
  @doc("The 2022-06-01-preview API version.")
  v2022_06_01_preview: "2022-06-01-preview",
}
