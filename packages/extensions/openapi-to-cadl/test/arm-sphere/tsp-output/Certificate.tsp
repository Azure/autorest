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
  @doc("""
Serial number of the certificate. Use '.default' to get current active
certificate.
""")
  @key("serialNumber")
  @path
  @segment("certificates")
  name: string;
}

@armResourceOperations
interface Certificates
  extends Azure.ResourceManager.ProxyResourceOperations<Certificate> {
  @autoRoute
  @doc("Retrieves cert chain.")
  @armResourceAction(Certificate)
  @post
  retrieveCertChain(
    ...ResourceInstanceParameters<Certificate>
  ): ArmResponse<CertificateChainResponse> | ErrorResponse;
  @autoRoute
  @doc("Gets the proof of possession nonce.")
  @armResourceAction(Certificate)
  @post
  retrieveProofOfPossessionNonce(
    ...ResourceInstanceParameters<Certificate>,

    @doc("Proof of possession nonce request body ")
    @body
    proofOfPossessionNonceRequest: ProofOfPossessionNonceRequest
  ): ArmResponse<ProofOfPossessionNonceResponse> | ErrorResponse;
}
