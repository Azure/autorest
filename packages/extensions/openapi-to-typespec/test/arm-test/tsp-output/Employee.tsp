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
/**
 * A Test resource
 */
model Employee is TrackedResource<EmployeeProperties> {
  /**
   * Name of employee
   */
  @pattern("^[a-zA-Z0-9-]{3,24}$")
  @path
  @key("employeeName")
  @segment("employees")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface Employees {
  /**
   * Get a Employee
   */
  get is ArmResourceRead<Employee>;

  /**
   * Create a Employee
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Employee>;

  /**
   * Update a Employee
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<Employee, EmployeeUpdate>;

  /**
   * Delete a Employee
   */
  delete is ArmResourceDeleteSync<Employee>;

  /**
   * List Employee resources by resource group
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Employees_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<Employee>;

  /**
   * List Employee resources by subscription ID
   */
  listBySubscription is ArmListBySubscription<Employee>;
}
