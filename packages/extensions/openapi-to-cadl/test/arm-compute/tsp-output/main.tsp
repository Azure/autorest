import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Microsoft Azure Compute Management",
  version: "2022-08-01",
})
@server(
  "{$host}",
  "Compute Client",
  {
    $host: string,
  }
)
@doc("Compute Client")
namespace Compute;
