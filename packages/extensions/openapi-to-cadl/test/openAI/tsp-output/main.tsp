import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "OpenAI",
  version: "2022-06-01-preview",
})
@server(
  "https://{endpoint}/openai",
  "Azure OpenAI APIs for completions and search",
  {
    endpoint: string,
  }
)
@doc("Azure OpenAI APIs for completions and search")
namespace Azure.AI.OpenAI;
