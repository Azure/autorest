import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Load Testing Service",
})
@versioned(Versions)
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

@doc("The available API versions.")
enum Versions {
  v2022_11_01: "2022-11-01",
}
