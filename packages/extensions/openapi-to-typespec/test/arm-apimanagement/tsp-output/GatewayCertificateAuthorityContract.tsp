import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GatewayContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Gateway certificate authority details.
 */
@parentResource(GatewayContract)
model GatewayCertificateAuthorityContract
  is ProxyResource<GatewayCertificateAuthorityContractProperties> {
  /**
   * Identifier of the certificate entity. Must be unique in the current API Management service instance.
   */
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("certificateId")
  @segment("certificateAuthorities")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface GatewayCertificateAuthorityContracts {
  /**
   * Get assigned Gateway Certificate Authority details.
   */
  get is ArmResourceRead<GatewayCertificateAuthorityContract>;

  /**
   * Checks if Certificate entity is assigned to Gateway entity as Certificate Authority.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      GatewayCertificateAuthorityContract,
      BaseParameters<GatewayCertificateAuthorityContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Assign Certificate entity to Gateway entity as Certificate Authority.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    GatewayCertificateAuthorityContract,
    {
      ...BaseParameters<GatewayCertificateAuthorityContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Remove relationship between Certificate Authority and Gateway entity.
   */
  delete is ArmResourceDeleteSync<
    GatewayCertificateAuthorityContract,
    {
      ...BaseParameters<GatewayCertificateAuthorityContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists the collection of Certificate Authorities for the specified Gateway entity.
   */
  listByService is ArmResourceListByParent<
    GatewayCertificateAuthorityContract,
    {
      ...BaseParameters<GatewayCertificateAuthorityContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | eq, ne |  |</br>
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
    }
  >;
}

@@doc(GatewayCertificateAuthorityContracts.createOrUpdate::parameters.resource,
  ""
);
