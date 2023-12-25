import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.Test;

interface Operations extends Azure.ResourceManager.Operations {}

enum Origin {
  user,
  system,
  `user,system`,
}

enum ActionType {
  Internal,
}

enum ProvisioningState {
  @doc("Resource has been created.") Succeeded,
  @doc("Resource creation failed.") Failed,
  @doc("Resource creation was canceled.") Canceled,
  @doc("The resource is being provisioned") Provisioning,
  @doc("The resource is updating") Updating,
  @doc("The resource is being deleted") Deleting,
  @doc("The resource create request has been accepted") Accepted,
}

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

@doc("Enroll properties")
model EnrollProperties {
  @doc("Country of employee")
  country?: int32;

  @doc("City of employee")
  city?: string;
}
