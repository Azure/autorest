import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "NotificationHubsClient",
  version: "2020-06-01",
})
@server(
  "{namespaceBaseUrl}",
  "The Notification Hubs client performs operations to register and query devices, and send notifications",
  {
    namespaceBaseUrl: string,
  }
)
@doc("""
The Notification Hubs client performs operations to register and query devices,
and send notifications
""")
namespace NotificationHubsClient;
