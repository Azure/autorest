import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

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
  @doc("The Fully Qualified Domain Name of the DNS record associated to a Traffic Controller frontend.")
  @visibility("read")
  fqdn?: string;

  @doc("Provisioning State of Traffic Controller Frontend Resource")
  @visibility("read")
  provisioningState?: ProvisioningState;
}
