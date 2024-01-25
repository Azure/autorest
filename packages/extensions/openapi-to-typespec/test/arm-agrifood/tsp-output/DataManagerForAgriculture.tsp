import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AgFoodPlatform;
/**
 * Data Manager For Agriculture ARM Resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  DataManagerForAgricultureProperties
)
model DataManagerForAgriculture extends TrackedResourceBase {
  /**
   * DataManagerForAgriculture resource name.
   */
  @maxLength(63)
  @minLength(1)
  @pattern("^[A-Za-z0-9]+(-[A-Za-z0-9]+)*$")
  @path
  @key("dataManagerForAgricultureResourceName")
  @segment("farmBeats")
  @visibility("read")
  name: string;

  /**
   * Data Manager For Agriculture ARM Resource properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: DataManagerForAgricultureProperties;

  ...Azure.ResourceManager.ManagedServiceIdentity;
}

@armResourceOperations
interface DataManagerForAgricultures {
  /**
   * Get DataManagerForAgriculture resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DataManagerForAgricultureResources_Get")
  get is ArmResourceRead<DataManagerForAgriculture>;

  /**
   * Create or update Data Manager For Agriculture resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DataManagerForAgricultureResources_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<DataManagerForAgriculture>;

  /**
   * Update a Data Manager For Agriculture resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("DataManagerForAgricultureResources_Update")
  update is ArmCustomPatchAsync<
    DataManagerForAgriculture,
    DataManagerForAgricultureUpdateRequestModel,
    BaseParameters<DataManagerForAgriculture>,
    ArmLroLocationHeader
  >;

  /**
   * Delete a Data Manager For Agriculture resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DataManagerForAgricultureResources_Delete")
  delete is ArmResourceDeleteSync<DataManagerForAgriculture>;

  /**
   * Lists the DataManagerForAgriculture instances for a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DataManagerForAgricultureResources_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    DataManagerForAgriculture,
    {
      ...BaseParameters<DataManagerForAgriculture>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DataManagerForAgricultureResources_ListBySubscription")
  listBySubscription is ArmListBySubscription<DataManagerForAgriculture>;
}

@@projectedName(DataManagerForAgricultures.createOrUpdate::parameters.resource,
  "json",
  "request"
);
@@extension(DataManagerForAgricultures.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "request"
);
@@doc(DataManagerForAgricultures.createOrUpdate::parameters.resource,
  "Data Manager For Agriculture resource create or update request object."
);
@@projectedName(DataManagerForAgricultures.update::parameters.properties,
  "json",
  "request"
);
@@extension(DataManagerForAgricultures.update::parameters.properties,
  "x-ms-client-name",
  "request"
);
@@doc(DataManagerForAgricultures.update::parameters.properties,
  "Request object."
);
