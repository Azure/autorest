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
@doc("A Test resource")
@parentResource(Employee)
model DictProperty is TrackedResource<Record<unknown>> {
  @doc("Name of resource")
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  @path
  @key("name")
  @segment("dictproperties")
  name: string;
}

@armResourceOperations
interface DictProperties {
  @doc("Get a Resource.")
  get is ArmResourceRead<DictProperty>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List resources by resource group")
  @operationId("DictProperties_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<DictProperty>;
}
