import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Complex Model Client",
})
@versioned(Versions)
@server(
  "{$host}",
  "Some cool documentation.",
  {
    $host: string,
  }
)
@doc("Some cool documentation.")
namespace ComplexModelClient;

@doc("The available API versions.")
enum Versions {
  v2014_04_01_preview: "2014-04-01-preview",
}
