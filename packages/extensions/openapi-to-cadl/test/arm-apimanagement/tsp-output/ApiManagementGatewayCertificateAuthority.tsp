import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementGateway.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Gateway certificate authority details.")
@parentResource(ApiManagementGateway)
model ApiManagementGatewayCertificateAuthority
  is ProxyResource<GatewayCertificateAuthorityContractProperties> {
  @doc("Identifier of the certificate entity. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("certificateId")
  @segment("certificateAuthorities")
  name: string;
}

@armResourceOperations
interface ApiManagementGatewayCertificateAuthorities {
  @doc("Get assigned Gateway Certificate Authority details.")
  get is ArmResourceRead<ApiManagementGatewayCertificateAuthority>;
  @doc("Checks if Certificate entity is assigned to Gateway entity as Certificate Authority.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementGatewayCertificateAuthority,
      BaseParameters<ApiManagementGatewayCertificateAuthority>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Assign Certificate entity to Gateway entity as Certificate Authority.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementGatewayCertificateAuthority,
    {
      ...BaseParameters<ApiManagementGatewayCertificateAuthority>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Remove relationship between Certificate Authority and Gateway entity.")
  delete is ArmResourceDeleteSync<
    ApiManagementGatewayCertificateAuthority,
    {
      ...BaseParameters<ApiManagementGatewayCertificateAuthority>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists the collection of Certificate Authorities for the specified Gateway entity.")
  listByService is ArmResourceListByParent<
    ApiManagementGatewayCertificateAuthority,
    {
      ...BaseParameters<ApiManagementGatewayCertificateAuthority>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | eq, ne |  |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;
}
