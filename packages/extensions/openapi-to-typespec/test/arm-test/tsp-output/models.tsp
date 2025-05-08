import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.Test;

/**
 * The intended executor of the operation; as in Resource Based Access Control (RBAC) and audit logs UX. Default value is "user,system"
 */
union Origin {
  string,
  user: "user",
  system: "system",
  `user,system`: "user,system",
}

/**
 * Enum. Indicates the action type. "Internal" refers to actions that are for internal only APIs.
 */
union ActionType {
  string,
  Internal: "Internal",
}

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
 * The type of identity that created the resource.
 */
union CreatedByType {
  string,
  User: "User",
  Application: "Application",
  ManagedIdentity: "ManagedIdentity",
  Key: "Key",
}

/**
 * Localized display information for this particular operation.
 */
model OperationDisplay {
  /**
   * The localized friendly form of the resource provider name, e.g. "Microsoft Monitoring Insights" or "Microsoft Compute".
   */
  @visibility(Lifecycle.Read)
  provider?: string;

  /**
   * The localized friendly name of the resource type related to this operation. E.g. "Virtual Machines" or "Job Schedule Collections".
   */
  @visibility(Lifecycle.Read)
  resource?: string;

  /**
   * The concise, localized friendly name for the operation; suitable for dropdowns. E.g. "Create or Update Virtual Machine", "Restart Virtual Machine".
   */
  @visibility(Lifecycle.Read)
  operation?: string;

  /**
   * The short, localized friendly description of the operation; suitable for tool tips and detailed views.
   */
  @visibility(Lifecycle.Read)
  description?: string;
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
