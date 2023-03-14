import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "AzureMessagingWebPubSubServiceClient",
  version: "2022-11-01",
})
@server(
  "{Endpoint}",
  "// FIXME: (miissing-service-description) Add service description",
  {
    Endpoint: string,
  }
)
@doc("// FIXME: (miissing-service-description) Add service description")
namespace AzureMessagingWebPubSubServiceClient;
