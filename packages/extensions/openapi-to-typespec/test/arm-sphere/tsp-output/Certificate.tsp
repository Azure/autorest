import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureSphere;
/**
 * An certificate resource belonging to a catalog resource.
 */
@parentResource(Catalog)
model Certificate is ProxyResource<CertificateProperties> {
  /**
   * Serial number of the certificate. Use '.default' to get current active certificate.
   */
  @path
  @key("serialNumber")
  @segment("certificates")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface Certificates {
  /**
   * Get a Certificate
   */
  get is ArmResourceRead<Certificate>;

  /**
   * List Certificate resources by Catalog
   */
  listByCatalog is ArmResourceListByParent<
    Certificate,
    {
      ...BaseParameters<Certificate>;

      /**
       * Filter the result list using the given expression
       */
      @query("$filter")
      filter?: string;

      /**
       * The number of result items to return.
       */
      @query("$top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("$skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;

  /**
   * Retrieves cert chain.
   */
  retrieveCertChain is ArmResourceActionSync<
    Certificate,
    void,
    CertificateChainResponse
  >;

  /**
   * Gets the proof of possession nonce.
   */
  retrieveProofOfPossessionNonce is ArmResourceActionSync<
    Certificate,
    ProofOfPossessionNonceRequest,
    ProofOfPossessionNonceResponse
  >;
}

@@doc(Certificates.retrieveProofOfPossessionNonce::parameters.body,
  "Proof of possession nonce request body "
);
