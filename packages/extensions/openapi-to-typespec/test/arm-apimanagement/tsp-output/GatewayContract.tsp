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
  get is ArmResourceRead<GatewayContract>;

  /**
   * Gets the entity state (Etag) version of the Gateway specified by its identifier.
   */
  getEntityTag is ArmResourceCheckExistence<GatewayContract>;

  /**
   * Creates or updates a Gateway to be used in Api Management instance.
   */
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
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    GatewayContract,
    PatchModel = GatewayContract,
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
  listKeys is ArmResourceActionSync<
    GatewayContract,
    void,
    ArmResponse<GatewayKeysContract>
  >;

  /**
   * Regenerates specified gateway key invalidating any tokens created with it.
   */
  regenerateKey is ArmResourceActionSync<
    GatewayContract,
    GatewayKeyRegenerationRequestContract,
    NoContentResponse
  >;

  /**
   * Gets the Shared Access Authorization Token for the gateway.
   */
  generateToken is ArmResourceActionSync<
    GatewayContract,
    GatewayTokenRequestContract,
    ArmResponse<GatewayTokenContract>
  >;

  /**
   * Lists a collection of the APIs associated with a gateway.
   */
  @list
  @get
  @action("apis")
  gatewayApiListByService is ArmResourceActionSync<
    GatewayContract,
    void,
    ArmResponse<ResourceListResult<GatewayApiData>>,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
   * Checks that API entity specified by identifier is associated with the Gateway entity.
   */
  @head
  @action("{apiId}")
  gatewayApiGetEntityTag is ArmResourceActionSync<
    GatewayContract,
    void,
    OkResponse,
    Parameters = {
      /**
       * API identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      apiId: string;
    }
  >;

  /**
   * Adds an API to the specified Gateway.
   */
  @put
  @action("{apiId}")
  gatewayApiCreateOrUpdate is ArmResourceActionSync<
    GatewayContract,
    AssociationContract,
    ArmResponse<GatewayApiData> | ArmResourceCreatedSyncResponse<GatewayApiData>,
    Parameters = {
      /**
       * API identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      apiId: string;
    },
    OptionalRequestBody = true
  >;

  /**
   * Deletes the specified API from the specified Gateway.
   */
  @delete
  @action("{apiId}")
  gatewayApiDelete is ArmResourceActionSync<
    GatewayContract,
    void,
    OkResponse | NoContentResponse,
    Parameters = {
      /**
       * API identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      apiId: string;
    }
  >;
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
@@doc(GatewayContracts.gatewayApiCreateOrUpdate::parameters.body, "");
