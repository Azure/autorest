import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Employee.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Test;
/**
 * A Test resource
 */
@parentResource(Employee)
model ArrayDefault is TrackedResource<ArrayDefaultProperties> {
  /**
   * Name of resource
   */
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  @path
  @key("name")
  @segment("arraydefaults")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface ArrayDefaults {
  /**
   * Get a Resource.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ArrayDefault_Get")
  get is ArmResourceRead<ArrayDefault>;

  /**
   * List resources by resource group
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ArrayDefault_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<ArrayDefault>;
}
