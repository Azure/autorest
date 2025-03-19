import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.ServiceNetworking;

union ProvisioningState {
  string,
  Provisioning: "Provisioning",
  Updating: "Updating",
  Deleting: "Deleting",
  Accepted: "Accepted",
  Succeeded: "Succeeded",
  Failed: "Failed",
  Canceled: "Canceled",
}

union AssociationType {
  string,
  subnets: "subnets",
}

/**
 * Traffic Controller Properties.
 */
model TrafficControllerProperties {
  /**
   * Configuration Endpoints.
   */
  @visibility(Lifecycle.Read)
  configurationEndpoints?: string[];

  /**
   * Frontends References List
   */
  @visibility(Lifecycle.Read)
  frontends?: ResourceId[];

  /**
   * Associations References List
   */
  @visibility(Lifecycle.Read)
  associations?: ResourceId[];

  /**
   * The status of the last operation.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/**
 * Resource ID definition used by parent to reference child resources.
 */
model ResourceId {
  /**
   * Resource ID of child resource.
   */
  id: string;
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
 * The type used for update operations of the TrafficController.
 */
model TrafficControllerUpdate {
  /**
   * Resource tags.
   */
  tags?: Record<string>;
}

/**
 * Association Properties.
 */
model AssociationProperties {
  /**
   * Association Type
   */
  associationType: AssociationType;

  /**
   * Association Subnet
   */
  subnet?: AssociationSubnet;

  /**
   * Provisioning State of Traffic Controller Association Resource
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/**
 * Association Subnet.
 */
model AssociationSubnet {
  /**
   * Association ID.
   */
  id: string;
}

/**
 * The type used for update operations of the Association.
 */
model AssociationUpdate {
  /**
   * Resource tags.
   */
  tags?: Record<string>;

  /**
   * The updatable properties of the Association.
   */
  properties?: AssociationUpdateProperties;
}

/**
 * The updatable properties of the Association.
 */
model AssociationUpdateProperties {
  /**
   * Association Type
   */
  associationType?: AssociationType;

  /**
   * Association Subnet
   */
  subnet?: AssociationSubnetUpdate;
}

/**
 * Association Subnet.
 */
model AssociationSubnetUpdate {
  /**
   * Association ID.
   */
  id?: string;
}

/**
 * Frontend Properties.
 */
model FrontendProperties {
  /**
   * The Fully Qualified Domain Name of the DNS record associated to a Traffic Controller frontend.
   */
  @visibility(Lifecycle.Read)
  fqdn?: string;

  /**
   * Provisioning State of Traffic Controller Frontend Resource
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;
}

/**
 * The type used for update operations of the Frontend.
 */
model FrontendUpdate {
  /**
   * Resource tags.
   */
  tags?: Record<string>;
}
