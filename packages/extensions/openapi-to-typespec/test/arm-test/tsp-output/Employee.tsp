import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Test;
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
  createOrUpdate is ArmResourceCreateOrUpdateAsync<
    Employee,
    BaseParameters<Employee>,
    ArmAsyncOperationHeader
  >;

  @doc("Update a Employee")
  update is ArmCustomPatchSync<Employee, EmployeeUpdate>;

  @doc("Delete a Employee")
  delete is ArmResourceDeleteSync<Employee>;

  @doc("List Employee resources by resource group")
  listByResourceGroup is ArmResourceListByParent<Employee>;

  @doc("List Employee resources by subscription ID")
  listBySubscription is ArmListBySubscription<Employee>;
}
