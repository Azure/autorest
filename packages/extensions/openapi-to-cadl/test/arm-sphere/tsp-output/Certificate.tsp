import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.AzureSphere;
@doc("An certificate resource belonging to a catalog resource.")
@parentResource(Catalog)
model Certificate is MinProxyResource<CertificateProperties> {
  @doc("""
Serial number of the certificate. Use '.default' to get current active
certificate.
""")
  @path
  @key("serialNumber")
  @segment("certificates")
  serialNumber: string;
}
