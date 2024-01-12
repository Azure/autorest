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
@doc("Cache details.")
@parentResource(ApiManagementServiceResource)
model CacheContract is ProxyResource<CacheContractProperties> {
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
interface CacheContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the Cache specified by its identifier.")
  @operationId("Cache_Get")
  get is ArmResourceRead<CacheContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the Cache specified by its identifier.")
  @head
  @operationId("Cache_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<CacheContract, BaseParameters<CacheContract>>,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or updates an External Cache to be used in Api Management instance.")
  @operationId("Cache_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    CacheContract,
    {
      ...BaseParameters<CacheContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the details of the cache specified by its identifier.")
  @operationId("Cache_Update")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes specific Cache.")
  @operationId("Cache_Delete")
  delete is ArmResourceDeleteSync<
    CacheContract,
    {
      ...BaseParameters<CacheContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of all external Caches in the specified service instance.")
  @operationId("Cache_ListByService")
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

@@projectedName(CacheContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(CacheContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(CacheContracts.createOrUpdate::parameters.resource,
  "Create or Update parameters."
);
@@projectedName(CacheContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(CacheContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(CacheContracts.update::parameters.properties, "Update parameters.");
