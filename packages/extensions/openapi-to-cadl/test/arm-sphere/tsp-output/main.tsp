import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Azure Sphere resource management API.",
  version: "2022-09-01-preview",
})
@server(
  "{$host}",
  "Azure Sphere resource management API.",
  {
    $host: string,
  }
)
@doc("Azure Sphere resource management API.")
namespace Microsoft.AzureSphere;
