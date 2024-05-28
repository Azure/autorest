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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  CertificateContractProperties
)
model CertificateContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = CertificateContract,
    KeyName = "certificateId",
    SegmentName = "certificates",
    NamePattern = "^[^*#&+:<>?]+$"
  >;

  /**
   * Certificate properties details.
   */
  @extension("x-ms-client-flatten", true)
  properties?: CertificateContractProperties;
}

@armResourceOperations
interface CertificateContracts {
  /**
   * Gets the details of the certificate specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Certificate_Get")
  get is ArmResourceRead<CertificateContract>;

  /**
   * Gets the entity state (Etag) version of the certificate specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("Certificate_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      CertificateContract,
      BaseParameters<CertificateContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates the certificate being used for authentication with the backend.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Certificate_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    CertificateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<CertificateContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Certificate_Delete")
  delete is ArmResourceDeleteSync<
    CertificateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<CertificateContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Certificate_ListByService")
  listByService is ArmResourceListByParent<
    CertificateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<CertificateContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Certificate_RefreshSecret")
  refreshSecret is ArmResourceActionSync<
    CertificateContract,
    void,
    CertificateContract
  >;
}

@@maxLength(CertificateContract.name, 80);
@@minLength(CertificateContract.name, 1);
@@doc(CertificateContract.name,
  "Identifier of the certificate entity. Must be unique in the current API Management service instance."
);
@@encodedName(CertificateContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(CertificateContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(CertificateContracts.createOrUpdate::parameters.resource,
  "Create or Update parameters."
);
