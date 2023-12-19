import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Cache details.")
@parentResource(ApiManagementService)
model ApiManagementCache is ProxyResource<CacheContractProperties> {
  @doc("Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("cacheId")
  @segment("caches")
  name: string;
}

@armResourceOperations
interface ApiManagementCaches {
  @doc("Gets the details of the Cache specified by its identifier.")
  get is ArmResourceRead<ApiManagementCache>;
  @doc("Gets the entity state (Etag) version of the Cache specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementCache,
      BaseParameters<ApiManagementCache>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates or updates an External Cache to be used in Api Management instance.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementCache,
    {
      ...BaseParameters<ApiManagementCache>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates the details of the cache specified by its identifier.")
  update is ArmResourcePatchSync<
    ApiManagementCache,
    CacheContractProperties,
    {
      ...BaseParameters<ApiManagementCache>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes specific Cache.")
  delete is ArmResourceDeleteSync<
    ApiManagementCache,
    {
      ...BaseParameters<ApiManagementCache>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of all external Caches in the specified service instance.")
  listByService is ArmResourceListByParent<
    ApiManagementCache,
    {
      ...BaseParameters<ApiManagementCache>;

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
