import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
/**
 * The Notification Hubs client performs operations to register and query devices,
 * and send notifications
 */
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
namespace NotificationHubsClient;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2020-06-01 API version.
   */
  v2020_06_01: "2020-06-01",

  /**
   * The 2015-01 API version.
   */
  v2015_01: "2015-01",

  /**
   * The 2015-04 API version.
   */
  v2015_04: "2015-04",

  /**
   * The 2015-08 API version.
   */
  v2015_08: "2015-08",

  /**
   * The 2016-07 API version.
   */
  v2016_07: "2016-07",

  /**
   * The 2020-06 API version.
   */
  v2020_06: "2020-06",
}
