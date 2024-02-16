import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
/**
 * Test Infrastructure for AutoRest
 */
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
namespace AutoRestUrlTestService;
