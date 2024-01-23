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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(CloudService)
@Azure.ResourceManager.Private.armResourceInternal(CloudServiceRoleProperties)
@includeInapplicableMetadataInPayload(false)
model CloudServiceRole extends ProxyResourceBase {
  /**
   * Name of the role.
   */
  @path
  @key("roleName")
  @segment("roles")
  name: string;

  /**
   * Describes the cloud service role sku.
   */
  sku?: CloudServiceRoleSku;

  /**
   * The cloud service role properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: CloudServiceRoleProperties;
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
