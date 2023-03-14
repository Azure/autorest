import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "AutoRest Paging Test Service",
  version: "1.0.0",
})
@server(
  "{$host}",
  "Long-running Operation for AutoRest",
  {
    $host: string,
  }
)
@doc("Long-running Operation for AutoRest")
namespace AutoRestPagingTestService;
