import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Gateway details.
 */
@parentResource(ApiManagementServiceResource)
model GatewayContract is ProxyResource<GatewayContractProperties> {
  /**
   * Gateway entity identifier. Must be unique in the current API Management service instance. Must not have value 'managed'
   */
  @maxLength(80)
  @minLength(1)
  @path
  @key("gatewayId")
  @segment("gateways")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface GatewayContracts {
  /**
   * Gets the details of the Gateway specified by its identifier.
   */
  get is ArmResourceRead<GatewayContract>;

  /**
   * Gets the entity state (Etag) version of the Gateway specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      GatewayContract,
      BaseParameters<GatewayContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates a Gateway to be used in Api Management instance.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    GatewayContract,
    {
      ...BaseParameters<GatewayContract>;

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
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    GatewayContract,
    GatewayContract,
    {
      ...BaseParameters<GatewayContract>;

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
  delete is ArmResourceDeleteSync<
    GatewayContract,
    {
      ...BaseParameters<GatewayContract>;

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
  listByService is ArmResourceListByParent<
    GatewayContract,
    {
      ...BaseParameters<GatewayContract>;

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
  listKeys is ArmResourceActionSync<GatewayContract, void, GatewayKeysContract>;

  /**
   * Regenerates specified gateway key invalidating any tokens created with it.
   */
  regenerateKey is ArmResourceActionNoContentSync<
    GatewayContract,
    GatewayKeyRegenerationRequestContract
  >;

  /**
   * Gets the Shared Access Authorization Token for the gateway.
   */
  generateToken is ArmResourceActionSync<
    GatewayContract,
    GatewayTokenRequestContract,
    GatewayTokenContract
  >;

  /**
   * Lists a collection of the APIs associated with a gateway.
   */
  // FIXME: GatewayApi_ListByService could not be converted to a resource operation
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

@@doc(GatewayContracts.createOrUpdate::parameters.resource, "");
@@doc(GatewayContracts.update::parameters.properties, "");
@@doc(GatewayContracts.regenerateKey::parameters.body, "");
@@doc(GatewayContracts.generateToken::parameters.body, "");
