import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

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
interface DataManagerForAgricultureResources {
  @doc("Get DataManagerForAgriculture resource.")
  get is ArmResourceRead<DataManagerForAgriculture>;
  @doc("Create or update Data Manager For Agriculture resource.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<DataManagerForAgriculture>;
  @doc("Update a Data Manager For Agriculture resource.")
  update is ArmResourcePatchAsync<
    DataManagerForAgriculture,
    DataManagerForAgricultureProperties
  >;
  @doc("Delete a Data Manager For Agriculture resource.")
  delete is ArmResourceDeleteSync<DataManagerForAgriculture>;
  @doc("Lists the DataManagerForAgriculture instances for a resource group.")
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
  @doc("Lists the DataManagerForAgriculture instances for a subscription.")
  listBySubscription is ArmListBySubscription<DataManagerForAgriculture>;
}
