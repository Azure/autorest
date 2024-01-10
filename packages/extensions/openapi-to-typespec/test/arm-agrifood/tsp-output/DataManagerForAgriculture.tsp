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
@doc("Data Manager For Agriculture ARM Resource.")
model DataManagerForAgriculture
  is TrackedResource<DataManagerForAgricultureProperties> {
  @doc("DataManagerForAgriculture resource name.")
  @maxLength(63)
  @minLength(1)
  @pattern("^[A-Za-z0-9]+(-[A-Za-z0-9]+)*$")
  @path
  @key("dataManagerForAgricultureResourceName")
  @segment("farmBeats")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
}

@armResourceOperations
interface DataManagerForAgricultures {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get DataManagerForAgriculture resource.")
  @operationId("DataManagerForAgricultureResources_Get")
  get is ArmResourceRead<DataManagerForAgriculture>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update Data Manager For Agriculture resource.")
  @operationId("DataManagerForAgricultureResources_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<DataManagerForAgriculture>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update a Data Manager For Agriculture resource.")
  @operationId("DataManagerForAgricultureResources_Update")
  update is ArmCustomPatchAsync<
    DataManagerForAgriculture,
    DataManagerForAgricultureUpdateRequestModel,
    BaseParameters<DataManagerForAgriculture>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete a Data Manager For Agriculture resource.")
  @operationId("DataManagerForAgricultureResources_Delete")
  delete is ArmResourceDeleteSync<DataManagerForAgriculture>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists the DataManagerForAgriculture instances for a resource group.")
  @operationId("DataManagerForAgricultureResources_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    DataManagerForAgriculture,
    {
      ...BaseParameters<DataManagerForAgriculture>;

      @doc("""
Maximum number of items needed (inclusive).
Minimum = 10, Maximum = 1000, Default value = 50.
""")
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;

      @doc("Continuation token for getting next set of results.")
      @query("$skipToken")
      $skipToken?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists the DataManagerForAgriculture instances for a subscription.")
  @operationId("DataManagerForAgricultureResources_ListBySubscription")
  listBySubscription is ArmListBySubscription<DataManagerForAgriculture>;
}
