import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.AzurePlaywrightService;

interface Operations extends Azure.ResourceManager.Operations {}

enum Origin {
  user,
  system,
  `user,system`,
}

enum ActionType {
  Internal,
}

enum EnablementStatus {
  @doc("The feature is Enabled.") Enabled,
  @doc("The feature is Disabled.") Disabled,
}

enum ProvisioningState {
  @doc("Resource has been created.") Succeeded,
  @doc("Resource creation failed.") Failed,
  @doc("Resource creation was canceled.") Canceled,
  @doc("Deletion in progress") Deleting,
  @doc("Change accepted for processing") Accepted,
}

enum CreatedByType {
  User,
  Application,
  ManagedIdentity,
  Key,
}

enum FreeTrialState {
  @doc("The free-trial is Active.") Active,
  @doc("The free-trial is Expired.") Expired,
}

enum QuotaNames {
  @doc("The quota details for scalable execution feature. When enabled, Playwright client workers can connect to cloud-hosted browsers. This can increase the number of parallel workers for a test run, significantly minimizing test completion durations.")
  ScalableExecution,
}

@doc("Account properties")
model AccountProperties {
  @doc("The Playwright testing dashboard URI for the account resource.")
  @visibility("read")
  dashboardUri?: string;

  @doc("This property sets the connection region for Playwright client workers to cloud-hosted browsers. If enabled, workers connect to browsers in the closest Azure region, ensuring lower latency. If disabled, workers connect to browsers in the Azure region in which the workspace was initially created.")
  regionalAffinity?: EnablementStatus;

  @doc("When enabled, Playwright client workers can connect to cloud-hosted browsers. This can increase the number of parallel workers for a test run, significantly minimizing test completion durations.")
  scalableExecution?: EnablementStatus;

  @doc("When enabled, this feature allows the workspace to upload and display test results, including artifacts like traces and screenshots, in the Playwright portal. This enables faster and more efficient troubleshooting.")
  reporting?: EnablementStatus;

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

@doc("Quota properties")
model QuotaProperties {
  @doc("The free-trial quota.")
  freeTrial?: FreeTrialProperties;

  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("The free-trial properties")
model FreeTrialProperties {
  @doc("The playwright account id.")
  @visibility("read")
  accountId: string;

  @doc("The free-trial createdAt utcDateTime.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdAt: utcDateTime;

  @doc("The free-trial expiryAt utcDateTime.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryAt: utcDateTime;

  @doc("The free-trial allocated limit value eg. allocated free minutes.")
  @visibility("read")
  allocatedValue: int32;

  @doc("The free-trial used value eg. used free minutes.")
  @visibility("read")
  usedValue: int32;

  @doc("The free-trial percentage used.")
  @visibility("read")
  @maxValue(100)
  percentageUsed: float32;

  @doc("The free-trial state.")
  @visibility("read")
  state: FreeTrialState;
}
