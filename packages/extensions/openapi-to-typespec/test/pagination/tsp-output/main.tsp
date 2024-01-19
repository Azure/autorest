import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
    title: "AutoRest Paging Test Service"
  })
@versioned(Versions)
@server("{$host}", "Long-running Operation for AutoRest"
, {
$host: string 
}
)
/**
* Long-running Operation for AutoRest
*/
namespace AutoRestPagingTestService;

/**
* The available API versions.
*/
enum Versions {
/**
* The 1.0.0 API version.
*/
v1.0.0: "1.0.0",
}