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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  DataManagerForAgricultureProperties
)
model DataManagerForAgriculture extends Foundations.TrackedResource {
  ...ResourceNameParameter<
    Resource = DataManagerForAgriculture,
    KeyName = "dataManagerForAgricultureResourceName",
    SegmentName = "farmBeats",
    NamePattern = "^[A-Za-z0-9]+(-[A-Za-z0-9]+)*$"
  >;

  /**
   * Data Manager For Agriculture ARM Resource properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: DataManagerForAgricultureProperties;

  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
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
  @parameterVisibility
  @operationId("DataManagerForAgricultureResources_Update")
  update is ArmCustomPatchAsync<
    DataManagerForAgriculture,
    DataManagerForAgricultureUpdateRequestModel
  >;

  /**
   * Delete a Data Manager For Agriculture resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
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
      ...Azure.ResourceManager.Foundations.BaseParameters<DataManagerForAgriculture>;

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

@@maxLength(DataManagerForAgriculture.name, 63);
@@minLength(DataManagerForAgriculture.name, 1);
@@doc(DataManagerForAgriculture.name,
  "DataManagerForAgriculture resource name."
);
@@encodedName(DataManagerForAgricultures.createOrUpdate::parameters.resource,
  "application/json",
  "request"
);
@@extension(DataManagerForAgricultures.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "request"
);
@@doc(DataManagerForAgricultures.createOrUpdate::parameters.resource,
  "Data Manager For Agriculture resource create or update request object."
);
@@encodedName(DataManagerForAgricultures.update::parameters.properties,
  "application/json",
  "request"
);
@@extension(DataManagerForAgricultures.update::parameters.properties,
  "x-ms-client-name",
  "request"
);
@@doc(DataManagerForAgricultures.update::parameters.properties,
  "Request object."
);
