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
 * Backend details.
 */
@parentResource(ApiManagementServiceResource)
model BackendContract is ProxyResource<BackendContractProperties> {
  /**
   * Identifier of the Backend entity. Must be unique in the current API Management service instance.
   */
  @maxLength(80)
  @minLength(1)
  @path
  @key("backendId")
  @segment("backends")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface BackendContracts {
  /**
   * Gets the details of the backend specified by its identifier.
   */
  get is ArmResourceRead<BackendContract>;

  /**
   * Gets the entity state (Etag) version of the backend specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      BackendContract,
      BaseParameters<BackendContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates a backend.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    BackendContract,
    {
      ...BaseParameters<BackendContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates an existing backend.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    BackendContract,
    BackendUpdateParameters,
    {
      ...BaseParameters<BackendContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes the specified backend.
   */
  delete is ArmResourceDeleteSync<
    BackendContract,
    {
      ...BaseParameters<BackendContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of backends in the specified service instance.
   */
  listByService is ArmResourceListByParent<
    BackendContract,
    {
      ...BaseParameters<BackendContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| title | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| url | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
   * Notifies the APIM proxy to create a new connection to the backend after the specified timeout. If no timeout was specified, timeout of 2 minutes is used.
   */
  reconnect is ArmResourceActionNoContentSync<
    BackendContract,
    BackendReconnectContract
  >;
}

@@doc(BackendContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(BackendContracts.update::parameters.properties, "Update parameters.");
@@doc(BackendContracts.reconnect::parameters.body,
  "Reconnect request parameters."
);
