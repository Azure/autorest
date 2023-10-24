import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Test;
@doc("A Test resource")
model Employee is TrackedResource<EmployeeProperties> {
  @doc("Name of employee")
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  @path
  @key("employeeName")
  @segment("employees")
  name: string;
}

@armResourceOperations
interface Employees {
  @doc("Get a Employee")
  get is ArmResourceRead<Employee>;
  @doc("Create a Employee")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Employee>;
  @doc("Update a Employee")
  update is ArmResourcePatchSync<Employee, EmployeeProperties>;
  @doc("Delete a Employee")
  delete is ArmResourceDeleteAsync<Employee>;
  @doc("List Employee resources by resource group")
  listByResourceGroup is ArmResourceListByParent<Employee>;
  @doc("List Employee resources by subscription ID")
  listBySubscription is ArmListBySubscription<Employee>;
}
