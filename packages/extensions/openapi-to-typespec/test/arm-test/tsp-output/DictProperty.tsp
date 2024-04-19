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
model DictProperty is TrackedResource<Record<unknown>> {
  /**
   * Name of resource
   */
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  @path
  @key("name")
  @segment("dictproperties")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface DictProperties {
  /**
   * Get a Resource.
   */
  get is ArmResourceRead<DictProperty>;

  /**
   * List resources by resource group
   */
  listByResourceGroup is ArmResourceListByParent<DictProperty>;
}
