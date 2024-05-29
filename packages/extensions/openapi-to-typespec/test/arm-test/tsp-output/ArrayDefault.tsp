import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Employee.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Test;
/**
 * A Test resource
 */
@parentResource(Employee)
model ArrayDefault
  is Azure.ResourceManager.TrackedResource<ArrayDefaultProperties> {
  ...ResourceNameParameter<
    Resource = ArrayDefault,
    KeyName = "name",
    SegmentName = "arraydefaults",
    NamePattern = "^[a-zA-Z0-9-]{3,24}$"
  >;
}

@armResourceOperations
interface ArrayDefaults {
  /**
   * Get a Resource.
   */
  get is ArmResourceRead<ArrayDefault>;

  /**
   * List resources by resource group
   */
  listByResourceGroup is ArmResourceListByParent<ArrayDefault>;
}

@@doc(ArrayDefault.name, "Name of resource");
