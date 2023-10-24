import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./RestorePointGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Restore Point details.")
@parentResource(RestorePointGroup)
model RestorePoint is ProxyResource<RestorePointProperties> {
  @doc("The name of the restore point.")
  @path
  @key("restorePointName")
  @segment("restorePoints")
  name: string;
}

@armResourceOperations
interface RestorePoints {
  @doc("The operation to get the restore point.")
  get is ArmResourceRead<RestorePoint>;
  @doc("""
The operation to create the restore point. Updating properties of an existing
restore point is not allowed
""")
  create is ArmResourceCreateOrUpdateAsync<RestorePoint>;
  @doc("The operation to delete the restore point.")
  delete is ArmResourceDeleteAsync<RestorePoint>;
}
