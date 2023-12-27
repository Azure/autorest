import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./GatewayContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Gateway certificate authority details.")
@parentResource(GatewayContract)
model GatewayCertificateAuthorityContract
  is ProxyResource<GatewayCertificateAuthorityContractProperties> {
  @doc("Identifier of the certificate entity. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @key("certificateId")
  @segment("certificateAuthorities")
  name: string;
}

@armResourceOperations
interface GatewayCertificateAuthority {
  @doc("Get assigned Gateway Certificate Authority details.")
  get is ArmResourceRead<GatewayCertificateAuthorityContract>;
  @doc("Checks if Certificate entity is assigned to Gateway entity as Certificate Authority.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      GatewayCertificateAuthorityContract,
      BaseParameters<GatewayCertificateAuthorityContract>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Assign Certificate entity to Gateway entity as Certificate Authority.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    GatewayCertificateAuthorityContract,
    {
      ...BaseParameters<GatewayCertificateAuthorityContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Remove relationship between Certificate Authority and Gateway entity.")
  delete is ArmResourceDeleteSync<
    GatewayCertificateAuthorityContract,
    {
      ...BaseParameters<GatewayCertificateAuthorityContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists the collection of Certificate Authorities for the specified Gateway entity.")
  listByService is ArmResourceListByParent<
    GatewayCertificateAuthorityContract,
    {
      ...BaseParameters<GatewayCertificateAuthorityContract>;

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
