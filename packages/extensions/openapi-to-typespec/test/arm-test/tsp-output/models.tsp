import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.Test;

interface Operations extends Azure.ResourceManager.Operations {}

@doc("The intended executor of the operation; as in Resource Based Access Control (RBAC) and audit logs UX. Default value is \"user,system\"")
enum Origin {
  user,
  system,
  `user,system`,
}

@doc("Enum. Indicates the action type. \"Internal\" refers to actions that are for internal only APIs.")
enum ActionType {
  Internal,
}

@doc("The provisioning state of a resource.")
enum ProvisioningState {
  @doc("Resource has been created.") Succeeded,
  @doc("Resource creation failed.") Failed,
  @doc("Resource creation was canceled.") Canceled,
  @doc("The resource is being provisioned") Provisioning,
  @doc("The resource is updating") Updating,
  @doc("The resource is being deleted") Deleting,
  @doc("The resource create request has been accepted") Accepted,
}

@doc("The type of identity that created the resource.")
enum CreatedByType {
  User,
  Application,
  ManagedIdentity,
  Key,
}

@doc("Employee properties")
model EmployeeProperties {
  @doc("Age of employee")
  age?: int32;

  @doc("City of employee")
  city?: string;

  @doc("Profile of employee")
  profile?: bytes;

  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("Common fields that are returned in the response for all Azure Resource Manager resources")
model Resource {
  @doc("Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}")
  @visibility("read")
  id?: string;

  @doc("The name of the resource")
  @visibility("read")
  name?: string;

  @doc("The type of the resource. E.g. \"Microsoft.Compute/virtualMachines\" or \"Microsoft.Storage/storageAccounts\"")
  @visibility("read")
  type?: string;

  @doc("Azure Resource Manager metadata containing createdBy and modifiedBy information.")
  @visibility("read")
  systemData?: SystemData;
}

@doc("The type used for update operations of the Employee.")
model EmployeeUpdate {
  @doc("Resource tags.")
  tags?: Record<string>;

  @doc("The updatable properties of the Employee.")
  properties?: EmployeeUpdateProperties;
}

@doc("The updatable properties of the Employee.")
model EmployeeUpdateProperties {
  @doc("Age of employee")
  age?: int32;

  @doc("City of employee")
  city?: string;

  @doc("Profile of employee")
  profile?: bytes;
}

@doc("Enroll properties")
model EnrollProperties {
  @doc("Country of employee")
  country?: int32;

  @doc("City of employee")
  city?: string;
}
