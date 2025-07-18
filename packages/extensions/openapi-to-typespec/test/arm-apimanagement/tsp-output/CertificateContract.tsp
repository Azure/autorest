import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Certificate details.
 */
@parentResource(ApiManagementServiceResource)
model CertificateContract
  is Azure.ResourceManager.ProxyResource<CertificateContractProperties> {
  ...ResourceNameParameter<
    Resource = CertificateContract,
    KeyName = "certificateId",
    SegmentName = "certificates",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface CertificateContracts {
  /**
   * Gets the details of the certificate specified by its identifier.
   */
  get is ArmResourceRead<CertificateContract>;

  /**
   * Gets the entity state (Etag) version of the certificate specified by its identifier.
   */
  getEntityTag is ArmResourceCheckExistence<CertificateContract>;

  /**
   * Creates or updates the certificate being used for authentication with the backend.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    CertificateContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Deletes specific certificate.
   */
  delete is ArmResourceDeleteSync<
    CertificateContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of all certificates in the specified service instance.
   */
  listByService is ArmResourceListByParent<
    CertificateContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| subject | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| thumbprint | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| expirationDate | filter | ge, le, eq, ne, gt, lt |     |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * When set to true, the response contains only certificates entities which failed refresh.
       */
      @query("isKeyVaultRefreshFailed")
      isKeyVaultRefreshFailed?: boolean;
    }
  >;

  /**
   * From KeyVault, Refresh the certificate being used for authentication with the backend.
   */
  refreshSecret is ArmResourceActionSync<
    CertificateContract,
    void,
    ArmResponse<CertificateContract>
  >;
}

@@maxLength(CertificateContract.name, 80);
@@minLength(CertificateContract.name, 1);
@@doc(CertificateContract.name,
  "Identifier of the certificate entity. Must be unique in the current API Management service instance."
);
@@doc(CertificateContract.properties, "Certificate properties details.");
@@doc(CertificateContracts.createOrUpdate::parameters.resource,
  "Create or Update parameters."
);
