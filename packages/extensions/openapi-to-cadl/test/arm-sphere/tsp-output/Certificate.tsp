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
model Certificate is ProxyResource<CertificateProperties> {
  @doc("Serial number of the certificate. Use '.default' to get current active certificate.")
  @path
  @key("serialNumber")
  @segment("certificates")
  name: string;
}

@armResourceOperations
interface Certificates {
  @doc("Get a Certificate")
  get is ArmResourceRead<Certificate>;
  @doc("List Certificate resources by Catalog")
  listByCatalog is ArmResourceListByParent<
    Certificate,
    {
      ...BaseParameters<Certificate>;

      @doc("Filter the result list using the given expression")
      @query("$filter")
      filter?: string;

      @doc("The number of result items to return.")
      @query("$top")
      top?: int32;

      @doc("The number of result items to skip.")
      @query("$skip")
      skip?: int32;

      @doc("The maximum number of result items per page.")
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;
  @doc("Retrieves cert chain.")
  retrieveCertChain is ArmResourceActionSync<
    Certificate,
    {},
    CertificateChainResponse
  >;
  @doc("Gets the proof of possession nonce.")
  retrieveProofOfPossessionNonce is ArmResourceActionSync<
    Certificate,
    ProofOfPossessionNonceRequest,
    ProofOfPossessionNonceResponse
  >;
}
