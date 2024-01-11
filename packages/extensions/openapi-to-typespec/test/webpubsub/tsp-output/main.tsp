import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Azure Web PubSub Service REST API",
})
@versioned(Versions)
@server(
  "{endpoint}",
  "// FIXME: (miissing-service-description) Add service description",
  {
    endpoint: string,
  }
)
@doc("// FIXME: (miissing-service-description) Add service description")
namespace AzureWebPubSubServiceRESTAPI;

@doc("The available API versions.")
enum Versions {
  @doc("The 2023-07-01 API version.")
  v2023_07_01: "2023-07-01",
}
