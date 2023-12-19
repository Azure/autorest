import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Certificate details.")
@parentResource(ApiManagementService)
model ApiManagementCertificate is ProxyResource<CertificateContractProperties> {
  @doc("Identifier of the certificate entity. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("certificateId")
  @segment("certificates")
  name: string;
}

@armResourceOperations
interface ApiManagementCertificates {
  @doc("Gets the details of the certificate specified by its identifier.")
  get is ArmResourceRead<ApiManagementCertificate>;
  @doc("Gets the entity state (Etag) version of the certificate specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementCertificate,
      BaseParameters<ApiManagementCertificate>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates or updates the certificate being used for authentication with the backend.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementCertificate,
    {
      ...BaseParameters<ApiManagementCertificate>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Deletes specific certificate.")
  delete is ArmResourceDeleteSync<
    ApiManagementCertificate,
    {
      ...BaseParameters<ApiManagementCertificate>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of all certificates in the specified service instance.")
  listByService is ArmResourceListByParent<
    ApiManagementCertificate,
    {
      ...BaseParameters<ApiManagementCertificate>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| subject | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| thumbprint | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| expirationDate | filter | ge, le, eq, ne, gt, lt |     |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("When set to true, the response contains only certificates entities which failed refresh.")
      @query("isKeyVaultRefreshFailed")
      isKeyVaultRefreshFailed?: boolean;
    }
  >;
  @doc("From KeyVault, Refresh the certificate being used for authentication with the backend.")
  refreshSecret is ArmResourceActionSync<
    ApiManagementCertificate,
    void,
    ApiManagementCertificate
  >;
}
