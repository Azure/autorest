import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./GatewayContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Gateway certificate authority details.
 */
@parentResource(GatewayContract)
model GatewayCertificateAuthorityContract
  is Azure.ResourceManager.ProxyResource<GatewayCertificateAuthorityContractProperties> {
  ...ResourceNameParameter<
    Resource = GatewayCertificateAuthorityContract,
    KeyName = "certificateId",
    SegmentName = "certificateAuthorities",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
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
      ...Azure.ResourceManager.Foundations.BaseParameters<GatewayCertificateAuthorityContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("GatewayCertificateAuthority_Delete")
  delete is ArmResourceDeleteSync<
    GatewayCertificateAuthorityContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<GatewayCertificateAuthorityContract>;

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
      ...Azure.ResourceManager.Foundations.BaseParameters<GatewayCertificateAuthorityContract>;

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

@@maxLength(GatewayCertificateAuthorityContract.name, 80);
@@minLength(GatewayCertificateAuthorityContract.name, 1);
@@doc(GatewayCertificateAuthorityContract.name,
  "Identifier of the certificate entity. Must be unique in the current API Management service instance."
);
@@doc(GatewayCertificateAuthorityContract.properties,
  "Gateway certificate authority details."
);
@@encodedName(GatewayCertificateAuthorityContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(GatewayCertificateAuthorityContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(GatewayCertificateAuthorityContracts.createOrUpdate::parameters.resource,
  ""
);
