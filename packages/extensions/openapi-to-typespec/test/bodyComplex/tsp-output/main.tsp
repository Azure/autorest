import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "AutoRest Complex Test Service",
})
@versioned(Versions)
@server(
  "{$host}",
  "Test Infrastructure for AutoRest",
  {
    $host: string,
  }
)
@doc("Test Infrastructure for AutoRest")
namespace AutoRestComplexTestService;

@doc("The available API versions.")
enum Versions {
  v2016_02_29: "2016-02-29",
}
