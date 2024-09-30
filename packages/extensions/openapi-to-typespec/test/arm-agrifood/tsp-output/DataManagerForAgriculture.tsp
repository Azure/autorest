import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AgFoodPlatform;
/**
 * Data Manager For Agriculture ARM Resource.
 */
model DataManagerForAgriculture
  is Azure.ResourceManager.TrackedResource<DataManagerForAgricultureProperties> {
  ...ResourceNameParameter<
    Resource = DataManagerForAgriculture,
    KeyName = "dataManagerForAgricultureResourceName",
    SegmentName = "farmBeats",
    NamePattern = "^[A-Za-z0-9]+(-[A-Za-z0-9]+)*$"
  >;
  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
}

@armResourceOperations
interface DataManagerForAgricultures {
  /**
   * Get DataManagerForAgriculture resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DataManagerForAgricultureResources_Get")
  get is ArmResourceRead<DataManagerForAgriculture>;

  /**
   * Create or update Data Manager For Agriculture resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DataManagerForAgricultureResources_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<DataManagerForAgriculture>;

  /**
   * Update a Data Manager For Agriculture resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("DataManagerForAgricultureResources_Update")
  update is ArmCustomPatchAsync<
    DataManagerForAgriculture,
    DataManagerForAgricultureUpdateRequestModel
  >;

  /**
   * Delete a Data Manager For Agriculture resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("DataManagerForAgricultureResources_Delete")
  delete is ArmResourceDeleteSync<DataManagerForAgriculture>;

  /**
   * Lists the DataManagerForAgriculture instances for a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DataManagerForAgricultureResources_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    DataManagerForAgriculture,
    Parameters = {
      /**
       * Maximum number of items needed (inclusive).
       * Minimum = 10, Maximum = 1000, Default value = 50.
       */
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;

      /**
       * Continuation token for getting next set of results.
       */
      @query("$skipToken")
      $skipToken?: string;
    }
  >;

  /**
   * Lists the DataManagerForAgriculture instances for a subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DataManagerForAgricultureResources_ListBySubscription")
  listBySubscription is ArmListBySubscription<
    DataManagerForAgriculture,
    Parameters = {
      /**
       * Maximum number of items needed (inclusive).
       * Minimum = 10, Maximum = 1000, Default value = 50.
       */
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;

      /**
       * Skip token for getting next set of results.
       */
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
}

@@maxLength(DataManagerForAgriculture.name, 63);
@@minLength(DataManagerForAgriculture.name, 1);
@@doc(DataManagerForAgriculture.name,
  "DataManagerForAgriculture resource name."
);
@@doc(DataManagerForAgriculture.properties,
  "Data Manager For Agriculture ARM Resource properties."
);
@@doc(DataManagerForAgricultures.createOrUpdate::parameters.resource,
  "Data Manager For Agriculture resource create or update request object."
);
@@doc(DataManagerForAgricultures.update::parameters.properties,
  "Request object."
);
