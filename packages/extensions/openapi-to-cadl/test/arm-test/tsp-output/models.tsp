import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.ResourceManager.Test;

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

@doc("Enroll properties")
model EnrollProperties {
  @doc("Country of employee")
  country?: int32;

  @doc("City of employee")
  city?: string;
}
