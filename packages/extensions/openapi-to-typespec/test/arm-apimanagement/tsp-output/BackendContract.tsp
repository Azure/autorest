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
 * Backend details.
 */
@parentResource(ApiManagementServiceResource)
model BackendContract
  is Azure.ResourceManager.ProxyResource<BackendContractProperties> {
  ...ResourceNameParameter<
    Resource = BackendContract,
    KeyName = "backendId",
    SegmentName = "backends",
    NamePattern = ""
  >;
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
  getEntityTag is ArmResourceCheckExistence<BackendContract>;

  /**
   * Creates or Updates a backend.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    BackendContract,
    Parameters = {
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
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    BackendContract,
    PatchModel = BackendUpdateParameters,
    Parameters = {
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
    Parameters = {
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
    Parameters = {
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
  reconnect is ArmResourceActionSync<
    BackendContract,
    BackendReconnectContract,
    AcceptedResponse,
    OptionalRequestBody = true
  >;
}

@@maxLength(BackendContract.name, 80);
@@minLength(BackendContract.name, 1);
@@doc(BackendContract.name,
  "Identifier of the Backend entity. Must be unique in the current API Management service instance."
);
@@doc(BackendContract.properties, "Backend entity contract properties.");
@@doc(BackendContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(BackendContracts.update::parameters.properties, "Update parameters.");
@@doc(BackendContracts.reconnect::parameters.body,
  "Reconnect request parameters."
);
