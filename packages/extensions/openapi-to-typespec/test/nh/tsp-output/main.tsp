import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "NotificationHubsClient",
})
@versioned(Versions)
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

@doc("The available API versions.")
enum Versions {
  v2020_06_01: "2020-06-01",
}
