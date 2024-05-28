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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(BackendContractProperties)
model BackendContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = BackendContract,
    KeyName = "backendId",
    SegmentName = "backends",
    NamePattern = ""
  >;

  /**
   * Backend entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: BackendContractProperties;
}

@armResourceOperations
interface BackendContracts {
  /**
   * Gets the details of the backend specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Backend_Get")
  get is ArmResourceRead<BackendContract>;

  /**
   * Gets the entity state (Etag) version of the backend specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("Backend_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      BackendContract,
      BaseParameters<BackendContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates a backend.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Backend_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    BackendContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<BackendContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Backend_Update")
  update is ArmCustomPatchSync<
    BackendContract,
    BackendUpdateParameters,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<BackendContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Backend_Delete")
  delete is ArmResourceDeleteSync<
    BackendContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<BackendContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Backend_ListByService")
  listByService is ArmResourceListByParent<
    BackendContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<BackendContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Backend_Reconnect")
  reconnect is ArmResourceActionNoContentSync<
    BackendContract,
    BackendReconnectContract
  >;
}

@@maxLength(BackendContract.name, 80);
@@minLength(BackendContract.name, 1);
@@doc(BackendContract.name,
  "Identifier of the Backend entity. Must be unique in the current API Management service instance."
);
@@encodedName(BackendContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(BackendContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(BackendContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@encodedName(BackendContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(BackendContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(BackendContracts.update::parameters.properties, "Update parameters.");
@@encodedName(BackendContracts.reconnect::parameters.body,
  "application/json",
  "parameters"
);
@@extension(BackendContracts.reconnect::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(BackendContracts.reconnect::parameters.body,
  "Reconnect request parameters."
);
