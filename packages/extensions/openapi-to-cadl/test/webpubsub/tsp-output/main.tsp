import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Azure Web PubSub Service REST API",
  version: "2023-07-01",
})
@server(
  "{endpoint}",
  "// FIXME: (miissing-service-description) Add service description",
  {
    endpoint: string,
  }
)
@doc("// FIXME: (miissing-service-description) Add service description")
namespace AzureWebPubSubServiceRESTAPI;
