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
 * Cache details.
 */
@parentResource(ApiManagementServiceResource)
model CacheContract
  is Azure.ResourceManager.ProxyResource<CacheContractProperties> {
  ...ResourceNameParameter<
    Resource = CacheContract,
    KeyName = "cacheId",
    SegmentName = "caches",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface CacheContracts {
  /**
   * Gets the details of the Cache specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Cache_Get")
  get is ArmResourceRead<CacheContract>;

  /**
   * Gets the entity state (Etag) version of the Cache specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Cache_GetEntityTag")
  getEntityTag is ArmResourceCheckExistence<CacheContract>;

  /**
   * Creates or updates an External Cache to be used in Api Management instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Cache_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    CacheContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the cache specified by its identifier.
   */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    CacheContract,
    PatchModel = CacheUpdateParameters,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes specific Cache.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Cache_Delete")
  delete is ArmResourceDeleteSync<
    CacheContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of all external Caches in the specified service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Cache_ListByService")
  listByService is ArmResourceListByParent<
    CacheContract,
    Parameters = {
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

@@maxLength(CacheContract.name, 80);
@@minLength(CacheContract.name, 1);
@@doc(CacheContract.name,
  "Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier)."
);
@@doc(CacheContract.properties, "Cache properties details.");
@@doc(CacheContracts.createOrUpdate::parameters.resource,
  "Create or Update parameters."
);
@@doc(CacheContracts.update::parameters.properties, "Update parameters.");
