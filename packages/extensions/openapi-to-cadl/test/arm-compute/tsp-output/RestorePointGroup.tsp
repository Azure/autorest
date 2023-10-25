import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("Create or update Restore Point collection parameters.")
model RestorePointGroup is TrackedResource<RestorePointCollectionProperties> {
  @doc("The name of the restore point collection.")
  @path
  @key("restorePointCollectionName")
  @segment("restorePointCollections")
  name: string;
}

@armResourceOperations
interface RestorePointGroups {
  @doc("The operation to get the restore point collection.")
  get is ArmResourceRead<
    RestorePointGroup,
    {
      ...BaseParameters<RestorePointGroup>;

      @doc("The name of the restore point collection.")
      @path
      restorePointCollectionName: string;

      @doc("""
The expand expression to apply on the operation. If expand=restorePoints,
server will return all contained restore points in the restorePointCollection.
""")
      @query("$expand")
      $expand?: RestorePointCollectionExpandOptions;
    }
  >;
  @doc("""
The operation to create or update the restore point collection. Please refer to
https://aka.ms/RestorePoints for more details. When updating a restore point
collection, only tags may be modified.
""")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    RestorePointGroup,
    {
      ...BaseParameters<RestorePointGroup>;

      @doc("The name of the restore point collection.")
      @path
      restorePointCollectionName: string;
    }
  >;
  @doc("The operation to update the restore point collection.")
  update is ArmResourcePatchSync<
    RestorePointGroup,
    RestorePointCollectionProperties,
    {
      ...BaseParameters<RestorePointGroup>;

      @doc("The name of the restore point collection.")
      @path
      restorePointCollectionName: string;
    }
  >;
  @doc("""
The operation to delete the restore point collection. This operation will also
delete all the contained restore points.
""")
  delete is ArmResourceDeleteAsync<
    RestorePointGroup,
    {
      ...BaseParameters<RestorePointGroup>;

      @doc("The name of the Restore Point Collection.")
      @path
      restorePointCollectionName: string;
    }
  >;
  @doc("Gets the list of restore point collections in a resource group.")
  list is ArmResourceListByParent<RestorePointGroup>;
  @doc("""
Gets the list of restore point collections in the subscription. Use nextLink
property in the response to get the next page of restore point collections. Do
this till nextLink is not null to fetch all the restore point collections.
""")
  listAll is ArmListBySubscription<RestorePointGroup>;
}
