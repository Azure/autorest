import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.AzurePlaywrightService;

/**
 * The enablement status of a feature.
 */
union EnablementStatus {
  string,

  /**
   * The feature is Enabled.
   */
  Enabled: "Enabled",

  /**
   * The feature is Disabled.
   */
  Disabled: "Disabled",
}

/**
 * The status of the current operation.
 */
union ProvisioningState {
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
   * Deletion in progress
   */
  Deleting: "Deleting",

  /**
   * Change accepted for processing
   */
  Accepted: "Accepted",
}

/**
 * The free-trial state.
 */
union FreeTrialState {
  string,

  /**
   * The free-trial is Active.
   */
  Active: "Active",

  /**
   * The free-trial is Expired.
   */
  Expired: "Expired",
}

union QuotaNames {
  string,

  /**
   * The quota details for scalable execution feature. When enabled, Playwright client workers can connect to cloud-hosted browsers. This can increase the number of parallel workers for a test run, significantly minimizing test completion durations.
   */
  ScalableExecution: "ScalableExecution",
}

/**
 * The response of a Account list operation.
 */
model AccountListResult is Azure.Core.Page<Account>;

/**
 * Account properties
 */
model AccountProperties {
  /**
   * The Playwright testing dashboard URI for the account resource.
   */
  @visibility("read")
  dashboardUri?: url;

  /**
   * This property sets the connection region for Playwright client workers to cloud-hosted browsers. If enabled, workers connect to browsers in the closest Azure region, ensuring lower latency. If disabled, workers connect to browsers in the Azure region in which the workspace was initially created.
   */
  regionalAffinity?: EnablementStatus;

  /**
   * When enabled, Playwright client workers can connect to cloud-hosted browsers. This can increase the number of parallel workers for a test run, significantly minimizing test completion durations.
   */
  scalableExecution?: EnablementStatus;

  /**
   * When enabled, this feature allows the workspace to upload and display test results, including artifacts like traces and screenshots, in the Playwright portal. This enables faster and more efficient troubleshooting.
   */
  reporting?: EnablementStatus;

  /**
   * The status of the last operation.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;
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
 * The response of a Quota list operation.
 */
model QuotaListResult is Azure.Core.Page<Quota>;

/**
 * Quota properties
 */
model QuotaProperties {
  /**
   * The free-trial quota.
   */
  freeTrial?: FreeTrialProperties;

  /**
   * The status of the last operation.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;
}

/**
 * The free-trial properties
 */
model FreeTrialProperties {
  /**
   * The playwright account id.
   */
  @visibility("read")
  accountId: string;

  /**
   * The free-trial createdAt utcDateTime.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdAt: utcDateTime;

  /**
   * The free-trial expiryAt utcDateTime.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryAt: utcDateTime;

  /**
   * The free-trial allocated limit value eg. allocated free minutes.
   */
  @visibility("read")
  allocatedValue: int32;

  /**
   * The free-trial used value eg. used free minutes.
   */
  @visibility("read")
  usedValue: int32;

  /**
   * The free-trial percentage used.
   */
  @visibility("read")
  @maxValue(100)
  percentageUsed: decimal;

  /**
   * The free-trial state.
   */
  @visibility("read")
  state: FreeTrialState;
}

/**
 * The type used for update operations of the Account.
 */
model AccountUpdate {
  /**
   * Resource tags.
   */
  tags?: Record<string>;

  /**
   * The updatable properties of the Account.
   */
  properties?: AccountUpdateProperties;
}

/**
 * The updatable properties of the Account.
 */
model AccountUpdateProperties {
  /**
   * This property sets the connection region for Playwright client workers to cloud-hosted browsers. If enabled, workers connect to browsers in the closest Azure region, ensuring lower latency. If disabled, workers connect to browsers in the Azure region in which the workspace was initially created.
   */
  regionalAffinity?: EnablementStatus;

  /**
   * When enabled, Playwright client workers can connect to cloud-hosted browsers. This can increase the number of parallel workers for a test run, significantly minimizing test completion durations.
   */
  scalableExecution?: EnablementStatus;

  /**
   * When enabled, this feature allows the workspace to upload and display test results, including artifacts like traces and screenshots, in the Playwright portal. This enables faster and more efficient troubleshooting.
   */
  reporting?: EnablementStatus;
}
