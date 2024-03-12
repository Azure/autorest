import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
/**
 * SchemaRegistryClient is a client for registering and retrieving schemas from
 * the Azure Schema Registry service.
 */
@useAuth(AadOauth2Auth<["https://eventhubs.azure.net/.default"]>)
@service({
  title: "Azure Schema Registry",
})
@versioned(Versions)
@server(
  "https://{fullyQualifiedNamespace}",
  "SchemaRegistryClient is a client for registering and retrieving schemas from the Azure Schema Registry service.",
  {
    fullyQualifiedNamespace: string,
  }
)
namespace AzureSchemaRegistry;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2021-10 API version.
   */
  v2021_10: "2021-10",
}
