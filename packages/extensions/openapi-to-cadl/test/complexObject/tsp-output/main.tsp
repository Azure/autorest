import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Complex Model Client",
  version: "2014-04-01-preview",
})
@server(
  "{$host}",
  "Some cool documentation.",
  {
    $host: string,
  }
)
@doc("Some cool documentation.")
namespace ComplexModelClient;
