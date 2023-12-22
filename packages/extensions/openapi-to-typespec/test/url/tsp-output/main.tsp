import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "AutoRest Url Test Service",
})
@server(
  "{$host}",
  "Test Infrastructure for AutoRest",
  {
    $host: string,
  }
)
@doc("Test Infrastructure for AutoRest")
namespace AutoRestUrlTestService;
