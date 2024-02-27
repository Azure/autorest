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
 * Cache details.
 */
@parentResource(ApiManagementServiceResource)
model CacheContract is ProxyResource<CacheContractProperties> {
  /**
   * Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).
   */
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("cacheId")
  @segment("caches")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface CacheContracts {
  /**
   * Gets the details of the Cache specified by its identifier.
   */
  get is ArmResourceRead<CacheContract>;

  /**
   * Gets the entity state (Etag) version of the Cache specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<CacheContract, BaseParameters<CacheContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates an External Cache to be used in Api Management instance.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    CacheContract,
    {
      ...BaseParameters<CacheContract>;

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
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    CacheContract,
    CacheUpdateParameters,
    {
      ...BaseParameters<CacheContract>;

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
  delete is ArmResourceDeleteSync<
    CacheContract,
    {
      ...BaseParameters<CacheContract>;

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
  listByService is ArmResourceListByParent<
    CacheContract,
    {
      ...BaseParameters<CacheContract>;

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

@@doc(CacheContracts.createOrUpdate::parameters.resource,
  "Create or Update parameters."
);
@@doc(CacheContracts.update::parameters.properties, "Update parameters.");
