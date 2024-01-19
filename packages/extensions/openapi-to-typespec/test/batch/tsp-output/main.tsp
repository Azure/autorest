import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
    title: "Azure Batch Service"
  })
@versioned(Versions)
@server("{batchUrl}", "A client for issuing REST requests to the Azure Batch service."
, {
batchUrl: string 
}
)
/**
* A client for issuing REST requests to the Azure Batch service.
*/
namespace Azure.Batch;

/**
* The available API versions.
*/
enum Versions {
/**
* The 2022-01-01.15.0 API version.
*/
v2022_01_01.15.0: "2022-01-01.15.0",
}