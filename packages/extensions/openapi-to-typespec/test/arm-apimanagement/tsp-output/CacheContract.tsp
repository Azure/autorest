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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(CacheContractProperties)
model CacheContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = CacheContract,
    KeyName = "cacheId",
    SegmentName = "caches",
    NamePattern = "^[^*#&+:<>?]+$"
  >;

  /**
   * Cache properties details.
   */
  @extension("x-ms-client-flatten", true)
  properties?: CacheContractProperties;
}

@armResourceOperations
interface CacheContracts {
  /**
   * Gets the details of the Cache specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Cache_Get")
  get is ArmResourceRead<CacheContract>;

  /**
   * Gets the entity state (Etag) version of the Cache specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("Cache_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<CacheContract, BaseParameters<CacheContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates an External Cache to be used in Api Management instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Cache_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    CacheContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<CacheContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Cache_Update")
  update is ArmCustomPatchSync<
    CacheContract,
    CacheUpdateParameters,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<CacheContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Cache_Delete")
  delete is ArmResourceDeleteSync<
    CacheContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<CacheContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Cache_ListByService")
  listByService is ArmResourceListByParent<
    CacheContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<CacheContract>;

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
@@encodedName(CacheContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(CacheContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(CacheContracts.createOrUpdate::parameters.resource,
  "Create or Update parameters."
);
@@encodedName(CacheContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(CacheContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(CacheContracts.update::parameters.properties, "Update parameters.");
