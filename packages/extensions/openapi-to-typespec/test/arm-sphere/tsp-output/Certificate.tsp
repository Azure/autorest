import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureSphere;
/**
 * An certificate resource belonging to a catalog resource.
 */
@parentResource(Catalog)
model Certificate
  is Azure.ResourceManager.ProxyResource<CertificateProperties> {
  ...ResourceNameParameter<
    Resource = Certificate,
    KeyName = "serialNumber",
    SegmentName = "certificates",
    NamePattern = ""
  >;
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
      ...Azure.ResourceManager.Foundations.BaseParameters<Certificate>;

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

@@doc(Certificate.name,
  "Serial number of the certificate. Use '.default' to get current active certificate."
);
@@doc(Certificate.properties,
  "The resource-specific properties for this resource."
);
@@doc(Certificates.retrieveProofOfPossessionNonce::parameters.body,
  "Proof of possession nonce request body "
);
