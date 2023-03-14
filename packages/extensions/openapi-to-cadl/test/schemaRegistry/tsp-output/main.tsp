import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Azure Schema Registry",
  version: "2021-10",
})
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
