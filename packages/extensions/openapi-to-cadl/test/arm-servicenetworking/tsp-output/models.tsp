import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Microsoft.ServiceNetworking;

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
  Provisioning,
  Updating,
  Deleting,
  Accepted,
  Succeeded,
  Failed,
  Canceled,
}

enum CreatedByType {
  User,
  Application,
  ManagedIdentity,
  Key,
}

enum AssociationType {
  subnets,
}

@doc("Traffic Controller Properties.")
model TrafficControllerProperties {
  @doc("Configuration Endpoints.")
  @visibility("read")
  configurationEndpoints?: string[];

  @doc("Frontends References List")
  @visibility("read")
  frontends?: ResourceId[];

  @doc("Associations References List")
  @visibility("read")
  associations?: ResourceId[];

  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("Resource ID definition used by parent to reference child resources.")
model ResourceId {
  @doc("Resource ID of child resource.")
  id: string;
}

@doc("Association Properties.")
model AssociationProperties {
  @doc("Association Type")
  associationType: AssociationType;

  @doc("Association Subnet")
  subnet?: AssociationSubnet;

  @doc("Provisioning State of Traffic Controller Association Resource")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("Association Subnet.")
model AssociationSubnet {
  @doc("Association ID.")
  id: string;
}

@doc("Association Subnet.")
model AssociationSubnetUpdate {
  @doc("Association ID.")
  id?: string;
}

@doc("Frontend Properties.")
model FrontendProperties {
  @doc("""
The Fully Qualified Domain Name of the DNS record associated to a Traffic
Controller frontend.
""")
  @visibility("read")
  fqdn?: string;

  @doc("Provisioning State of Traffic Controller Frontend Resource")
  @visibility("read")
  provisioningState?: ProvisioningState;
}
