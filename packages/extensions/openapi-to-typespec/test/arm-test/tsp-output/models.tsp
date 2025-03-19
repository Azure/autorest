import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.Test;

/**
 * The provisioning state of a resource.
 */
union ProvisioningStateTest {
  string,

  /**
   * Resource has been created.
   */
  Succeeded: "Succeeded",

  /**
   * Resource creation failed.
   */
  Failed: "Failed",

  /**
   * Resource creation was canceled.
   */
  Canceled: "Canceled",

  /**
   * The resource is being provisioned
   */
  Provisioning: "Provisioning",

  /**
   * The resource is updating
   */
  Updating: "Updating",

  /**
   * The resource is being deleted
   */
  Deleting: "Deleting",

  /**
   * The resource create request has been accepted
   */
  Accepted: "Accepted",
}

/**
 * Employee properties
 */
model EmployeeProperties {
  /**
   * Age of employee
   */
  age?: int32;

  /**
   * City of employee
   */
  city?: string;

  /**
   * Profile of employee
   */
  profile?: bytes;

  /**
   * The status of the last operation.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningStateTest;
}

/**
 * Common fields that are returned in the response for all Azure Resource Manager resources
 */
model Resource {
  /**
   * Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}
   */
  @visibility(Lifecycle.Read)
  id?: string;

  /**
   * The name of the resource
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * The type of the resource. E.g. "Microsoft.Compute/virtualMachines" or "Microsoft.Storage/storageAccounts"
   */
  @visibility(Lifecycle.Read)
  type?: string;

  /**
   * Azure Resource Manager metadata containing createdBy and modifiedBy information.
   */
  @visibility(Lifecycle.Read)
  systemData?: SystemData;
}

/**
 * The type used for update operations of the Employee.
 */
model EmployeeUpdate {
  /**
   * Resource tags.
   */
  tags?: Record<string>;

  /**
   * The updatable properties of the Employee.
   */
  properties?: EmployeeUpdateProperties;
}

/**
 * The updatable properties of the Employee.
 */
model EmployeeUpdateProperties {
  /**
   * Age of employee
   */
  age?: int32;

  /**
   * City of employee
   */
  city?: string;

  /**
   * Profile of employee
   */
  profile?: bytes;
}

/**
 * Enroll properties
 */
model EnrollProperties {
  /**
   * Country of employee
   */
  country?: int32;

  /**
   * City of employee
   */
  city?: string;
}

/**
 * Resource properties
 */
model ArrayDefaultProperties {
  ...Record<unknown>;

  /**
   * Array of strings
   */
  array?: string[] = #["911", "933"];
}
