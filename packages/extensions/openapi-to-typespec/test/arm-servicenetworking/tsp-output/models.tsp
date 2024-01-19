import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.ServiceNetworking;

interface Operations extends Azure.ResourceManager.Operations {}

enum ProvisioningState {
  Provisioning,
  Updating,
  Deleting,
  Accepted,
  Succeeded,
  Failed,
  Canceled,
}

enum AssociationType {
  subnets,
}

/**
 * Traffic Controller Properties.
 */
model TrafficControllerProperties {
  /**
   * Configuration Endpoints.
   */
  @visibility("read")
  configurationEndpoints?: string[];

  /**
   * Frontends References List
   */
  @visibility("read")
  frontends?: ResourceId[];

  /**
   * Associations References List
   */
  @visibility("read")
  associations?: ResourceId[];

  /**
   * The status of the last operation.
   */
  @visibility("read")
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
  @visibility("read")
  id?: string;

  /**
   * The name of the resource
   */
  @visibility("read")
  name?: string;

  /**
   * The type of the resource. E.g. "Microsoft.Compute/virtualMachines" or "Microsoft.Storage/storageAccounts"
   */
  @visibility("read")
  type?: string;

  /**
   * Azure Resource Manager metadata containing createdBy and modifiedBy information.
   */
  @visibility("read")
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
  @visibility("read")
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
  @visibility("read")
  fqdn?: string;

  /**
   * Provisioning State of Traffic Controller Frontend Resource
   */
  @visibility("read")
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
