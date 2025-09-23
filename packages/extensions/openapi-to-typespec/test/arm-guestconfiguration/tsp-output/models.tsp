import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.GuestConfiguration;

/**
 * Kind of the guest configuration. For example:DSC
 */
union Kind {
  string,

  /**
   * DSC
   */
  DSC: "DSC",
}

/**
 * Specifies the assignment type and execution of the configuration. Possible values are Audit, DeployAndAutoCorrect, ApplyAndAutoCorrect and ApplyAndMonitor.
 */
union AssignmentType {
  string,

  /**
   * Audit
   */
  Audit: "Audit",

  /**
   * DeployAndAutoCorrect
   */
  DeployAndAutoCorrect: "DeployAndAutoCorrect",

  /**
   * ApplyAndAutoCorrect
   */
  ApplyAndAutoCorrect: "ApplyAndAutoCorrect",

  /**
   * ApplyAndMonitor
   */
  ApplyAndMonitor: "ApplyAndMonitor",
}

/**
 * Specifies how the LCM(Local Configuration Manager) actually applies the configuration to the target nodes. Possible values are ApplyOnly, ApplyAndMonitor, and ApplyAndAutoCorrect.
 */
union ConfigurationMode {
  string,

  /**
   * ApplyOnly
   */
  ApplyOnly: "ApplyOnly",

  /**
   * ApplyAndMonitor
   */
  ApplyAndMonitor: "ApplyAndMonitor",

  /**
   * ApplyAndAutoCorrect
   */
  ApplyAndAutoCorrect: "ApplyAndAutoCorrect",
}

/**
 * Specifies what happens after a reboot during the application of a configuration. The possible values are ContinueConfiguration and StopConfiguration
 */
union ActionAfterReboot {
  string,

  /**
   * ContinueConfiguration
   */
  ContinueConfiguration: "ContinueConfiguration",

  /**
   * StopConfiguration
   */
  StopConfiguration: "StopConfiguration",
}

/**
 * A value indicating compliance status of the machine for the assigned guest configuration.
 */
union ComplianceStatus {
  string,

  /**
   * Compliant
   */
  Compliant: "Compliant",

  /**
   * NonCompliant
   */
  NonCompliant: "NonCompliant",

  /**
   * Pending
   */
  Pending: "Pending",
}

/**
 * Type of report, Consistency or Initial
 */
union Type {
  string,

  /**
   * Consistency
   */
  Consistency: "Consistency",

  /**
   * Initial
   */
  Initial: "Initial",
}

/**
 * The provisioning state, which only appears in the response.
 */
union ProvisioningState {
  string,

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

  /**
   * Created
   */
  Created: "Created",
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

/**
 * Guest configuration assignment properties.
 */
model GuestConfigurationAssignmentProperties {
  /**
   * VM resource Id.
   */
  @visibility(Lifecycle.Read)
  targetResourceId?: string;

  /**
   * The guest configuration to assign.
   */
  guestConfiguration?: GuestConfigurationNavigation;

  /**
   * A value indicating compliance status of the machine for the assigned guest configuration.
   */
  @visibility(Lifecycle.Read)
  complianceStatus?: ComplianceStatus;

  /**
   * Date and time when last compliance status was checked.
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastComplianceStatusChecked?: utcDateTime;

  /**
   * Id of the latest report for the guest configuration assignment.
   */
  @visibility(Lifecycle.Read)
  latestReportId?: string;

  /**
   * parameter hash for the guest configuration assignment.
   */
  @visibility(Lifecycle.Read)
  parameterHash?: string;

  /**
   * Last reported guest configuration assignment report.
   */
  latestAssignmentReport?: AssignmentReport;

  /**
   * The source which initiated the guest configuration assignment. Ex: Azure Policy
   */
  context?: string;

  /**
   * Combined hash of the configuration package and parameters.
   */
  @visibility(Lifecycle.Read)
  assignmentHash?: string;

  /**
   * The provisioning state, which only appears in the response.
   */
  @visibility(Lifecycle.Read)
  provisioningState?: ProvisioningState;

  /**
   * Type of the resource - VMSS / VM
   */
  @visibility(Lifecycle.Read)
  resourceType?: string;

  /**
   * The list of VM Compliance data for VMSS
   */
  @OpenAPI.extension("x-ms-identifiers", #["vmId"])
  vmssVMList?: VmssvmInfo[];
}

/**
 * Guest configuration is an artifact that encapsulates DSC configuration and its dependencies. The artifact is a zip file containing DSC configuration (as MOF) and dependent resources and other dependencies like modules.
 */
model GuestConfigurationNavigation {
  /**
   * Kind of the guest configuration. For example:DSC
   */
  kind?: Kind;

  /**
   * Name of the guest configuration.
   */
  name?: string;

  /**
   * Version of the guest configuration.
   */
  version?: string;

  /**
   * Uri of the storage where guest configuration package is uploaded.
   */
  contentUri?: string;

  /**
   * Combined hash of the guest configuration package and configuration parameters.
   */
  contentHash?: string;

  /**
   * Managed identity with storage access of the guest configuration package and configuration parameters.
   */
  contentManagedIdentity?: string;

  /**
   * Specifies the assignment type and execution of the configuration. Possible values are Audit, DeployAndAutoCorrect, ApplyAndAutoCorrect and ApplyAndMonitor.
   */
  assignmentType?: AssignmentType;

  /**
   * Specifies the origin of the configuration.
   */
  @visibility(Lifecycle.Read)
  assignmentSource?: string;

  /**
   * Specifies the content type of the configuration. Possible values could be Builtin or Custom.
   */
  @visibility(Lifecycle.Read)
  contentType?: string;

  /**
   * The configuration parameters for the guest configuration.
   */
  @OpenAPI.extension("x-ms-identifiers", #["name"])
  configurationParameter?: ConfigurationParameter[];

  /**
   * The protected configuration parameters for the guest configuration.
   */
  @OpenAPI.extension("x-ms-identifiers", #["name"])
  configurationProtectedParameter?: ConfigurationParameter[];

  /**
   * The configuration setting for the guest configuration.
   */
  @visibility(Lifecycle.Read)
  configurationSetting?: ConfigurationSetting;
}

/**
 * Represents a configuration parameter.
 */
model ConfigurationParameter {
  /**
   * Name of the configuration parameter.
   */
  name?: string;

  /**
   * Value of the configuration parameter.
   */
  value?: string;
}

/**
 * Configuration setting of LCM (Local Configuration Manager).
 */
model ConfigurationSetting {
  /**
   * Specifies how the LCM(Local Configuration Manager) actually applies the configuration to the target nodes. Possible values are ApplyOnly, ApplyAndMonitor, and ApplyAndAutoCorrect.
   */
  @visibility(Lifecycle.Read)
  configurationMode?: ConfigurationMode;

  /**
   * If true - new configurations downloaded from the pull service are allowed to overwrite the old ones on the target node. Otherwise, false
   */
  @visibility(Lifecycle.Read)
  allowModuleOverwrite?: boolean;

  /**
   * Specifies what happens after a reboot during the application of a configuration. The possible values are ContinueConfiguration and StopConfiguration
   */
  @visibility(Lifecycle.Read)
  actionAfterReboot?: ActionAfterReboot;

  /**
   * The time interval, in minutes, at which the LCM checks a pull service to get updated configurations. This value is ignored if the LCM is not configured in pull mode. The default value is 30.
   */
  @visibility(Lifecycle.Read)
  refreshFrequencyMins?: float32 = 30;

  /**
   * Set this to true to automatically reboot the node after a configuration that requires reboot is applied. Otherwise, you will have to manually reboot the node for any configuration that requires it. The default value is false. To use this setting when a reboot condition is enacted by something other than DSC (such as Windows Installer), combine this setting with the xPendingReboot module.
   */
  @visibility(Lifecycle.Read)
  rebootIfNeeded?: boolean;

  /**
   * How often, in minutes, the current configuration is checked and applied. This property is ignored if the ConfigurationMode property is set to ApplyOnly. The default value is 15.
   */
  @visibility(Lifecycle.Read)
  configurationModeFrequencyMins?: float32 = 15;
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model AssignmentReport {
  /**
   * ARM resource id of the report for the guest configuration assignment.
   */
  @visibility(Lifecycle.Read)
  id?: string;

  /**
   * GUID that identifies the guest configuration assignment report under a subscription, resource group.
   */
  @visibility(Lifecycle.Read)
  reportId?: string;

  /**
   * Configuration details of the guest configuration assignment.
   */
  assignment?: AssignmentInfo;

  /**
   * Information about the VM.
   */
  vm?: VMInfo;

  /**
   * Start date and time of the guest configuration assignment compliance status check.
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * End date and time of the guest configuration assignment compliance status check.
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  /**
   * A value indicating compliance status of the machine for the assigned guest configuration.
   */
  @visibility(Lifecycle.Read)
  complianceStatus?: ComplianceStatus;

  /**
   * Type of report, Consistency or Initial
   */
  @visibility(Lifecycle.Read)
  operationType?: Type;

  /**
   * The list of resources for which guest configuration assignment compliance is checked.
   */
  @OpenAPI.extension("x-ms-identifiers", #[])
  resources?: AssignmentReportResource[];
}

/**
 * Information about the guest configuration assignment.
 */
model AssignmentInfo {
  /**
   * Name of the guest configuration assignment.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * Information about the configuration.
   */
  configuration?: ConfigurationInfo;
}

/**
 * Information about the configuration.
 */
model ConfigurationInfo {
  /**
   * Name of the configuration.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * Version of the configuration.
   */
  @visibility(Lifecycle.Read)
  version?: string;
}

/**
 * Information about the VM.
 */
model VMInfo {
  /**
   * Azure resource Id of the VM.
   */
  @visibility(Lifecycle.Read)
  id?: string;

  /**
   * UUID(Universally Unique Identifier) of the VM.
   */
  @visibility(Lifecycle.Read)
  uuid?: string;
}

/**
 * The guest configuration assignment resource.
 */
model AssignmentReportResource {
  /**
   * A value indicating compliance status of the machine for the assigned guest configuration.
   */
  @visibility(Lifecycle.Read)
  complianceStatus?: ComplianceStatus;

  /**
   * Name of the guest configuration assignment resource setting.
   */
  @visibility(Lifecycle.Read)
  resourceId?: string;

  /**
   * Compliance reason and reason code for a resource.
   */
  @OpenAPI.extension("x-ms-identifiers", #["phrase", "code"])
  reasons?: AssignmentReportResourceComplianceReason[];

  /**
   * Properties of a guest configuration assignment resource.
   */
  @visibility(Lifecycle.Read)
  properties?: unknown;
}

/**
 * Reason and code for the compliance of the guest configuration assignment resource.
 */
model AssignmentReportResourceComplianceReason {
  /**
   * Reason for the compliance of the guest configuration assignment resource.
   */
  @visibility(Lifecycle.Read)
  phrase?: string;

  /**
   * Code for the compliance of the guest configuration assignment resource.
   */
  @visibility(Lifecycle.Read)
  code?: string;
}

/**
 * Information about VMSS VM
 */
model VmssvmInfo {
  /**
   * UUID of the VM.
   */
  @visibility(Lifecycle.Read)
  vmId?: string;

  /**
   * Azure resource Id of the VM.
   */
  @visibility(Lifecycle.Read)
  vmResourceId?: string;

  /**
   * A value indicating compliance status of the machine for the assigned guest configuration.
   */
  @visibility(Lifecycle.Read)
  complianceStatus?: ComplianceStatus;

  /**
   * Id of the latest report for the guest configuration assignment.
   */
  @visibility(Lifecycle.Read)
  latestReportId?: string;

  /**
   * Date and time when last compliance status was checked.
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastComplianceChecked?: utcDateTime;
}

/**
 * ARM proxy resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
model ProxyResource extends Resource {}

/**
 * The core properties of ARM resources
 */
model Resource {
  /**
   * ARM resource id of the guest configuration assignment.
   */
  @visibility(Lifecycle.Read)
  id?: string;

  /**
   * Name of the guest configuration assignment.
   */
  name?: string;

  /**
   * Region where the VM is located.
   */
  location?: string;

  /**
   * The type of the resource.
   */
  @visibility(Lifecycle.Read)
  type?: string;
}

/**
 * Error response of an operation failure
 */
@error
model ErrorResponse {
  #suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
  error?: ErrorResponseError;
}

#suppress "@azure-tools/typespec-azure-core/documentation-required" "For backward compatibility"
model ErrorResponseError {
  /**
   * Error code.
   */
  code?: string;

  /**
   * Detail error message indicating why the operation failed.
   */
  message?: string;
}

/**
 * The response of the list guest configuration assignment operation.
 */
model GuestConfigurationAssignmentList {
  /**
   * Result of the list guest configuration assignment operation.
   */
  @pageItems
  value?: GuestConfigurationAssignment[];
}

/**
 * List of guest configuration assignment reports.
 */
model GuestConfigurationAssignmentReportList {
  /**
   * List of reports for the guest configuration. Report contains information such as compliance status, reason and more.
   */
  @pageItems
  value?: GuestConfigurationAssignmentReport[];
}

/**
 * Report for the guest configuration assignment. Report contains information such as compliance status, reason, and more.
 */
model GuestConfigurationAssignmentReport {
  /**
   * ARM resource id of the report for the guest configuration assignment.
   */
  @visibility(Lifecycle.Read)
  id?: string;

  /**
   * GUID that identifies the guest configuration assignment report under a subscription, resource group.
   */
  @visibility(Lifecycle.Read)
  name?: string;

  /**
   * Properties of the guest configuration report.
   */
  properties?: GuestConfigurationAssignmentReportProperties;
}

/**
 * Report for the guest configuration assignment. Report contains information such as compliance status, reason, and more.
 */
model GuestConfigurationAssignmentReportProperties {
  /**
   * A value indicating compliance status of the machine for the assigned guest configuration.
   */
  @visibility(Lifecycle.Read)
  complianceStatus?: ComplianceStatus;

  /**
   * GUID that identifies the guest configuration assignment report under a subscription, resource group.
   */
  @visibility(Lifecycle.Read)
  reportId?: string;

  /**
   * Configuration details of the guest configuration assignment.
   */
  assignment?: AssignmentInfo;

  /**
   * Information about the VM.
   */
  vm?: VMInfo;

  /**
   * Start date and time of the guest configuration assignment compliance status check.
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * End date and time of the guest configuration assignment compliance status check.
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  /**
   * Details of the assignment report.
   */
  details?: AssignmentReportDetails;

  /**
   * Azure resource Id of the VMSS.
   */
  @visibility(Lifecycle.Read)
  vmssResourceId?: string;
}

/**
 * Details of the guest configuration assignment report.
 */
model AssignmentReportDetails {
  /**
   * A value indicating compliance status of the machine for the assigned guest configuration.
   */
  @visibility(Lifecycle.Read)
  complianceStatus?: ComplianceStatus;

  /**
   * Start date and time of the guest configuration assignment compliance status check.
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  /**
   * End date and time of the guest configuration assignment compliance status check.
   */
  @visibility(Lifecycle.Read)
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  /**
   * GUID of the report.
   */
  @visibility(Lifecycle.Read)
  jobId?: string;

  /**
   * Type of report, Consistency or Initial
   */
  @visibility(Lifecycle.Read)
  operationType?: Type;

  /**
   * The list of resources for which guest configuration assignment compliance is checked.
   */
  @OpenAPI.extension("x-ms-identifiers", #[])
  resources?: AssignmentReportResource[];
}

/**
 * GuestConfiguration REST API operation
 */
model Operation {
  /**
   * Operation name: For ex. providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/write or read
   */
  name?: string;

  /**
   * Provider, Resource, Operation and description values.
   */
  display?: OperationDisplay;

  /**
   * Provider, Resource, Operation and description values.
   */
  properties?: OperationProperties;
}

/**
 * Provider, Resource, Operation and description values.
 */
model OperationDisplay {
  /**
   * Service provider: Microsoft.GuestConfiguration
   */
  provider?: string;

  /**
   * Resource on which the operation is performed:  For ex.
   */
  resource?: string;

  /**
   * Operation type: Read, write, delete, etc.
   */
  operation?: string;

  /**
   * Description about operation.
   */
  description?: string;
}

/**
 * Provider, Resource, Operation and description values.
 */
model OperationProperties {
  /**
   * Service provider: Microsoft.GuestConfiguration
   */
  statusCode?: string;
}
