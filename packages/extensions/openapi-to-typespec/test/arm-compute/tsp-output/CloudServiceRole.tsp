import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CloudService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Describes a role of the cloud service.
 */
@parentResource(CloudService)
model CloudServiceRole is ProxyResource<CloudServiceRoleProperties> {
  /**
   * Name of the role.
   */
  @path
  @key("roleName")
  @segment("roles")
  name: string;

  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface CloudServiceRoles {
  /**
   * Gets a role from a cloud service.
   */
  get is ArmResourceRead<CloudServiceRole>;

  /**
   * Gets a list of all roles in a cloud service. Use nextLink property in the response to get the next page of roles. Do this till nextLink is null to fetch all the roles.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CloudServiceRoles_List")
  list is ArmResourceListByParent<CloudServiceRole>;
}
