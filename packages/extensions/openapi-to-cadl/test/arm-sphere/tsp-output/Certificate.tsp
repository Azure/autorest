import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

@doc("An certificate resource belonging to a catalog resource.")
@parentResource("Catalog")
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
  extends Azure.ResourceManager.ProxyResourceOperations<
      Certificate,
      CertificateProperties
    > {
  @autoroute
  @doc("Retrieves cert chain.")
  @armResourceLocation(Certificate)
  @post
  retrieveCertChain(
    ...ResourceInstanceParameters<Certificate>
  ): ArmResponse<CertificateChainResponse> | ErrorResponse;
  @autoroute
  @doc("Gets the proof of possession nonce.")
  @armResourceLocation(Certificate)
  @post
  retrieveProofOfPossessionNonce(
    ...ResourceInstanceParameters<Certificate>
  ): ArmResponse<ProofOfPossessionNonceResponse> | ErrorResponse;
}
