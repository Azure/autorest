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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(GatewayContract)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  GatewayCertificateAuthorityContractProperties
)
model GatewayCertificateAuthorityContract extends ProxyResourceBase {
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

  /**
   * Gateway certificate authority details.
   */
  @extension("x-ms-client-flatten", true)
  properties?: GatewayCertificateAuthorityContractProperties;
}

@armResourceOperations
interface GatewayCertificateAuthorityContracts {
  /**
   * Get assigned Gateway Certificate Authority details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GatewayCertificateAuthority_Get")
  get is ArmResourceRead<GatewayCertificateAuthorityContract>;

  /**
   * Checks if Certificate entity is assigned to Gateway entity as Certificate Authority.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("GatewayCertificateAuthority_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      GatewayCertificateAuthorityContract,
      BaseParameters<GatewayCertificateAuthorityContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Assign Certificate entity to Gateway entity as Certificate Authority.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GatewayCertificateAuthority_CreateOrUpdate")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GatewayCertificateAuthority_Delete")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GatewayCertificateAuthority_ListByService")
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

@@projectedName(GatewayCertificateAuthorityContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(GatewayCertificateAuthorityContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(GatewayCertificateAuthorityContracts.createOrUpdate::parameters.resource,
  ""
);
