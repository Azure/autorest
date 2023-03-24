import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "AutoRest Complex Test Service",
  version: "2016-02-29",
})
@server(
  "{$host}",
  "Test Infrastructure for AutoRest",
  {
    $host: string,
  }
)
@doc("Test Infrastructure for AutoRest")
namespace AutoRestComplexTestService;
