import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Load Testing Service",
  version: "2022-11-01",
})
@server(
  "https://{Endpoint}",
  "These APIs allow end users to create, view and run load tests using Azure Load Test Service.",
  {
    Endpoint: string,
  }
)
@doc("""
These APIs allow end users to create, view and run load tests using Azure Load
Test Service.
""")
namespace Azure.LoadTesting;
