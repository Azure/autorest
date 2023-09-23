import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

@parentResource("Catalog")
model Certificate is ProxyResource<CertificateProperties> {
  @doc("""
Serial number of the certificate. Use '.default' to get current active
certificate.
""")
  @key("serialNumber")
  @path
  name: string;
}
