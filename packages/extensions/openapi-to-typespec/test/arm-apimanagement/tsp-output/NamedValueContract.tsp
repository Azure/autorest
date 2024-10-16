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
 * NamedValue details.
 */
@parentResource(ApiManagementServiceResource)
model NamedValueContract
  is Azure.ResourceManager.ProxyResource<NamedValueContractProperties> {
  ...ResourceNameParameter<
    Resource = NamedValueContract,
    KeyName = "namedValueId",
    SegmentName = "namedValues",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface NamedValueContracts {
  /**
   * Gets the details of the named value specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NamedValue_Get")
  get is ArmResourceRead<NamedValueContract>;

  /**
   * Gets the entity state (Etag) version of the named value specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("NamedValue_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      NamedValueContract,
      BaseParameters<NamedValueContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates named value.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  @operationId("NamedValue_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    NamedValueContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceCreatedResponse<NamedValueContract> | ArmResourceUpdatedResponse<NamedValueContract> | ArmAcceptedLroResponse
  >;

  /**
   * Updates the specific named value.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("NamedValue_Update")
  update is ArmCustomPatchAsync<
    NamedValueContract,
    NamedValueUpdateParameters,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes specific named value from the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("NamedValue_Delete")
  delete is ArmResourceDeleteSync<
    NamedValueContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of named values defined within a service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NamedValue_ListByService")
  listByService is ArmResourceListByParent<
    NamedValueContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| tags | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith, any, all |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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

      /**
       * When set to true, the response contains only named value entities which failed refresh.
       */
      @query("isKeyVaultRefreshFailed")
      isKeyVaultRefreshFailed?: boolean;
    },
    Response = NamedValueListResult
  >;

  /**
   * Gets the secret of the named value specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NamedValue_ListValue")
  listValue is ArmResourceActionSync<
    NamedValueContract,
    void,
    NamedValueSecretContract
  >;

  /**
   * Refresh the secret of the named value specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("NamedValue_RefreshSecret")
  refreshSecret is ArmResourceActionAsync<
    NamedValueContract,
    void,
    NamedValueContract
  >;
}

@@maxLength(NamedValueContract.name, 256);
@@doc(NamedValueContract.name, "Identifier of the NamedValue.");
@@doc(NamedValueContract.properties, "NamedValue entity contract properties.");
@@doc(NamedValueContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(NamedValueContracts.update::parameters.properties, "Update parameters.");
