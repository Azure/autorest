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
  get is ArmResourceRead<NamedValueContract>;

  /**
   * Gets the entity state (Etag) version of the named value specified by its identifier.
   */
  getEntityTag is ArmResourceCheckExistence<NamedValueContract>;

  /**
   * Creates or updates named value.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is Azure.ResourceManager.Legacy.CreateOrUpdateAsync<
    NamedValueContract,
    Request = NamedValueCreateContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<NamedValueContract> | ArmResourceCreatedResponse<
      NamedValueContract,
      ArmLroLocationHeader<FinalResult = NamedValueContract> &
        Azure.Core.Foundations.RetryAfterHeader
    > | ArmAcceptedLroResponse
  >;

  /**
   * Updates the specific named value.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    NamedValueContract,
    PatchModel = NamedValueUpdateParameters,
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
    }
  >;

  /**
   * Gets the secret of the named value specified by its identifier.
   */
  listValue is ArmResourceActionSync<
    NamedValueContract,
    void,
    ArmResponse<NamedValueSecretContract>
  >;

  /**
   * Refresh the secret of the named value specified by its identifier.
   */
  refreshSecret is ArmResourceActionAsync<
    NamedValueContract,
    void,
    ArmResponse<NamedValueContract>
  >;
}

@@maxLength(NamedValueContract.name, 256);
@@doc(NamedValueContract.name, "Identifier of the NamedValue.");
@@doc(NamedValueContract.properties, "NamedValue entity contract properties.");
@@doc(NamedValueContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
@@doc(NamedValueContracts.update::parameters.properties, "Update parameters.");
