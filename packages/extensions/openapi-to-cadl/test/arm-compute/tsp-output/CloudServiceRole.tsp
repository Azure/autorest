import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./CloudService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
@doc("Describes a role of the cloud service.")
@parentResource(CloudService)
model CloudServiceRole is ProxyResource<CloudServiceRoleProperties> {
  @doc("Name of the role.")
  @path
  @key("roleName")
  @segment("roles")
  name: string;
}

@armResourceOperations
interface CloudServiceRoles {
  @doc("Gets a role from a cloud service.")
  get is ArmResourceRead<CloudServiceRole>;
  @doc("""
Gets a list of all roles in a cloud service. Use nextLink property in the
response to get the next page of roles. Do this till nextLink is null to fetch
all the roles.
""")
  list is ArmResourceListByParent<CloudServiceRole>;
}
