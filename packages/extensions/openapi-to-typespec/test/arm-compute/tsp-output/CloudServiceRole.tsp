import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CloudService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Describes a role of the cloud service.
 */
@parentResource(CloudService)
model CloudServiceRole
  is Azure.ResourceManager.ProxyResource<CloudServiceRoleProperties> {
  ...ResourceNameParameter<
    Resource = CloudServiceRole,
    KeyName = "roleName",
    SegmentName = "roles",
    NamePattern = ""
  >;

  /**
   * Resource id
   */
  @visibility("read")
  id?: string;

  /**
   * Resource type
   */
  @visibility("read")
  type?: string;

  /**
   * Resource location
   */
  @visibility("read")
  location?: string;

  /**
   * Describes the cloud service role sku.
   */
  sku?: CloudServiceRoleSku;
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
  list is ArmResourceListByParent<CloudServiceRole>;
}

@@doc(CloudServiceRole.name, "Name of the role.");
@@doc(CloudServiceRole.properties, "The cloud service role properties.");
