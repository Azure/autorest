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
 * Gateway details.
 */
@parentResource(ApiManagementServiceResource)
model GatewayContract
  is Azure.ResourceManager.ProxyResource<GatewayContractProperties> {
  ...ResourceNameParameter<
    Resource = GatewayContract,
    KeyName = "gatewayId",
    SegmentName = "gateways",
    NamePattern = ""
  >;
}

@armResourceOperations
interface GatewayContracts {
  /**
   * Gets the details of the Gateway specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Gateway_Get")
  get is ArmResourceRead<GatewayContract>;

  /**
   * Gets the entity state (Etag) version of the Gateway specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("Gateway_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      GatewayContract,
      BaseParameters<GatewayContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates a Gateway to be used in Api Management instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Gateway_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    GatewayContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the gateway specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("Gateway_Update")
  update is ArmCustomPatchSync<
    GatewayContract,
    GatewayContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes specific Gateway.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Gateway_Delete")
  delete is ArmResourceDeleteSync<
    GatewayContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of gateways registered with service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Gateway_ListByService")
  listByService is ArmResourceListByParent<
    GatewayContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| region | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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

  /**
   * Retrieves gateway keys.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Gateway_ListKeys")
  listKeys is ArmResourceActionSync<GatewayContract, void, GatewayKeysContract>;

  /**
   * Regenerates specified gateway key invalidating any tokens created with it.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Gateway_RegenerateKey")
  regenerateKey is ArmResourceActionNoContentSync<
    GatewayContract,
    GatewayKeyRegenerationRequestContract
  >;

  /**
   * Gets the Shared Access Authorization Token for the gateway.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Gateway_GenerateToken")
  generateToken is ArmResourceActionSync<
    GatewayContract,
    GatewayTokenRequestContract,
    GatewayTokenContract
  >;

  /**
   * Lists a collection of the APIs associated with a gateway.
   */
  // FIXME: GatewayApi_ListByService could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("GatewayApi_ListByService")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/gateways/{gatewayId}/apis")
  @get
  listByService(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * Gateway entity identifier. Must be unique in the current API Management service instance. Must not have value 'managed'
     */
    @maxLength(80)
    @minLength(1)
    @path
    gatewayId: string,

    /**
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
     */
    @query("$filter")
    $filter?: string,

    /**
     * Number of records to return.
     */
    @minValue(1)
    @query("$top")
    $top?: int32,

    /**
     * Number of records to skip.
     */
    @query("$skip")
    $skip?: int32,

    ...SubscriptionIdParameter,
  ): ArmResponse<ApiManagementGatewayApiListResult> | ErrorResponse;
}

@@maxLength(GatewayContract.name, 80);
@@minLength(GatewayContract.name, 1);
@@doc(GatewayContract.name,
  "Gateway entity identifier. Must be unique in the current API Management service instance. Must not have value 'managed'"
);
@@doc(GatewayContract.properties, "Gateway details.");
@@doc(GatewayContracts.createOrUpdate::parameters.resource, "");
@@doc(GatewayContracts.update::parameters.properties, "");
@@doc(GatewayContracts.regenerateKey::parameters.body, "");
@@doc(GatewayContracts.generateToken::parameters.body, "");
