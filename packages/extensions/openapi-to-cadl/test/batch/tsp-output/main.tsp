import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Azure Batch Service",
  version: "2022-01-01.15.0",
})
@server(
  "{batchUrl}",
  "A client for issuing REST requests to the Azure Batch service.",
  {
    batchUrl: string,
  }
)
@doc("A client for issuing REST requests to the Azure Batch service.")
namespace Azure.Batch;
