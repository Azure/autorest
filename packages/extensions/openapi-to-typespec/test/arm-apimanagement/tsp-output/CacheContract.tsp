import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Cache details.")
@parentResource(ApiManagementServiceResource)
model CacheContract is ProxyResource<CacheContractProperties> {
  @doc("Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @key("cacheId")
  @segment("caches")
  name: string;
}

@armResourceOperations
@projectedName("client", "Cache")
interface CacheContracts_Cache {
  @doc("Gets the details of the Cache specified by its identifier.")
  get is ArmResourceRead<CacheContract>;

  @doc("Gets the entity state (Etag) version of the Cache specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<CacheContract, BaseParameters<CacheContract>>,
  ): OkResponse | ErrorResponse;

  @doc("Creates or updates an External Cache to be used in Api Management instance.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    CacheContract,
    {
      ...BaseParameters<CacheContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  @doc("Updates the details of the cache specified by its identifier.")
  update is ArmCustomPatchSync<
    CacheContract,
    CacheUpdateParameters,
    {
      ...BaseParameters<CacheContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Deletes specific Cache.")
  delete is ArmResourceDeleteSync<
    CacheContract,
    {
      ...BaseParameters<CacheContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Lists a collection of all external Caches in the specified service instance.")
  listByService is ArmResourceListByParent<
    CacheContract,
    {
      ...BaseParameters<CacheContract>;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;
}
