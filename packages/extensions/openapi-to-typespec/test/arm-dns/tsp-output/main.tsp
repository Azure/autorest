import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./DnsRecord.tsp";
import "./DnsRecord.tsp";
import "./DnsRecord.tsp";
import "./DnsRecord.tsp";
import "./DnsRecord.tsp";
import "./DnsRecord.tsp";
import "./DnsRecord.tsp";
import "./DnsRecord.tsp";
import "./DnsRecord.tsp";
import "./DnsRecord.tsp";
import "./DnsZone.tsp";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
@armProviderNamespace
@service({
  title: "DnsManagementClient",
})
@versioned(Versions)
@doc("The DNS Management Client.")
namespace Azure.ResourceManager.Dns;

@doc("The available API versions.")
enum Versions {
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  @doc("The 2018-05-01 API version.")
  v2018_05_01: "2018-05-01",
}
