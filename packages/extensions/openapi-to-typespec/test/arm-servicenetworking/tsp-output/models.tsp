import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.ServiceNetworking;

/**
 * The intended executor of the operation; as in Resource Based Access Control (RBAC) and audit logs UX. Default value is "user,system"
 */
union Origin {
  string,

  /**
   * user
   */
  user: "user",

  /**
   * system
   */
  system: "system",

  /**
   * user,system
   */
  `user,system`: "user,system",
}

/**
 * Enum. Indicates the action type. "Internal" refers to actions that are for internal only APIs.
 */
union ActionType {
  string,

  /**
   * Internal
   */
  Internal: "Internal",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union ProvisioningState {
  string,

  /**
   * Provisioning
   */
  Provisioning: "Provisioning",

  /**
   * Updating
   */
  Updating: "Updating",

  /**
   * Deleting
   */
  Deleting: "Deleting",

  /**
   * Accepted
   */
  Accepted: "Accepted",

  /**
   * Succeeded
   */
  Succeeded: "Succeeded",

  /**
   * Failed
   */
  Failed: "Failed",

  /**
   * Canceled
   */
  Canceled: "Canceled",
}

/**
 * The type of identity that created the resource.
 */
union CreatedByType {
  string,

  /**
   * User
   */
  User: "User",

  /**
   * Application
   */
  Application: "Application",

  /**
   * ManagedIdentity
   */
  ManagedIdentity: "ManagedIdentity",

  /**
   * Key
   */
  Key: "Key",
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
union AssociationType {
  string,

  /**
   * subnets
   */
  subnets: "subnets",
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
 * The type used for update operations of the TrafficController.
 */
model TrafficControllerUpdate {
  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
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
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
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
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}
