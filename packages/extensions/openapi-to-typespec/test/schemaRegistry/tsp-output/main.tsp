import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Azure Schema Registry",
})
@versioned(Versions)
@server(
  "https://{endpoint}",
  "Azure Schema Registry is as a central schema repository, with support for versioning, management, compatibility checking, and RBAC.",
  {
    endpoint: string,
  }
)
@doc("""
Azure Schema Registry is as a central schema repository, with support for
versioning, management, compatibility checking, and RBAC.
""")
namespace AzureSchemaRegistry;

@doc("The available API versions.")
enum Versions {
  v2021_10: "2021-10",
}
