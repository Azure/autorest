import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Microsoft.AzureSphere;

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
  @doc("The resource is being updated") Updating,
  @doc("The resource is being deleted") Deleting,
  @doc("The resource create request has been accepted") Accepted,
}

enum CreatedByType {
  User,
  Application,
  ManagedIdentity,
  Key,
}

enum CertificateStatus {
  @doc("Certificate is active") Active,
  @doc("Certificate is inactive") Inactive,
  @doc("Certificate has expired") Expired,
  @doc("Certificate has been revoked") Revoked,
}

enum RegionalDataBoundary {
  @doc("No data boundary") None,
  @doc("EU data boundary") EU,
}

enum ImageType {
  @doc("Invalid image.") InvalidImageType,
  @doc("One Bl image type") OneBl,
  @doc("Pluton image type") PlutonRuntime,
  @doc("Wifi firmware image type") WifiFirmware,
  @doc("Security monitor image type") SecurityMonitor,
  @doc("Normal world loader image type") NormalWorldLoader,
  @doc("Normal world dtb image type") NormalWorldDtb,
  @doc("Normal world kernel image type") NormalWorldKernel,
  @doc("Root FS image type") RootFs,
  @doc("Services image type") Services,
  @doc("Applications image type") Applications,
  @doc("FW config image type") FwConfig,
  @doc("Boot manifest image type") BootManifest,
  @doc("Nwfs image type") Nwfs,
  @doc("Trusted key store image type") TrustedKeystore,
  @doc("Policy image type") Policy,
  @doc("Customer board config image type") CustomerBoardConfig,
  @doc("Update certificate store image type") UpdateCertStore,
  @doc("Base system update manifest image type") BaseSystemUpdateManifest,
  @doc("Firmware update manifest image type") FirmwareUpdateManifest,
  @doc("Customer update manifest image type") CustomerUpdateManifest,
  @doc("Recovery manifest image type") RecoveryManifest,
  @doc("manifest set image type") ManifestSet,
  @doc("Other image type") Other,
}

enum OSFeedType {
  @doc("Retail OS feed type.") Retail,
  @doc("Retail evaluation OS feed type.") RetailEval,
}

enum UpdatePolicy {
  @doc("Update all policy.") UpdateAll,
  @doc("No update for 3rd party app policy.") No3rdPartyAppUpdates,
}

enum AllowCrashDumpCollection {
  @doc("Crash dump collection enabled") Enabled,
  @doc("Crash dump collection disabled") Disabled,
}

enum CapabilityType {
  @doc("Application development capability") ApplicationDevelopment,
  @doc("Field servicing capability") FieldServicing,
}

@doc("Catalog properties")
model CatalogProperties {
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

@doc("The properties of certificate")
model CertificateProperties {
  @doc("The certificate as a UTF-8 encoded base 64 string.")
  @visibility("read")
  certificate?: string;

  @doc("The certificate status.")
  @visibility("read")
  status?: CertificateStatus;

  @doc("The certificate subject.")
  @visibility("read")
  subject?: string;

  @doc("The certificate thumbprint.")
  @visibility("read")
  thumbprint?: string;

  @doc("The certificate expiry date.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryUtc?: utcDateTime;

  @doc("The certificate not before date.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  notBeforeUtc?: utcDateTime;

  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("The certificate chain response.")
model CertificateChainResponse {
  @doc("The certificate chain.")
  @visibility("read")
  certificateChain?: string;
}

@doc("Request for the proof of possession nonce")
model ProofOfPossessionNonceRequest {
  @doc("The proof of possession nonce")
  proofOfPossessionNonce: string;
}

@doc("Result of the action to generate a proof of possession nonce")
model ProofOfPossessionNonceResponse extends CertificateProperties {}

@doc("Response to the action call for count devices in a catalog.")
model CountDeviceResponse extends CountElementsResponse {}

@doc("Response of the count for elements.")
model CountElementsResponse {
  @doc("Number of children resources in parent resource.")
  value: int32;
}

@doc("The properties of image")
model ImageProperties {
  @doc("Image as a UTF-8 encoded base 64 string on image create. This field contains the image URI on image reads.")
  @visibility("read", "create")
  image?: string;

  @doc("Image ID")
  @visibility("read", "create")
  imageId?: string;

  @doc("Image name")
  @visibility("read")
  imageName?: string;

  @doc("Regional data boundary for an image")
  @visibility("read", "create")
  regionalDataBoundary?: RegionalDataBoundary;

  @doc("Location the image")
  @visibility("read")
  uri?: string;

  @doc("The image description.")
  @visibility("read")
  description?: string;

  @doc("The image component id.")
  @visibility("read")
  componentId?: string;

  @doc("The image type.")
  @visibility("read")
  imageType?: ImageType;

  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("The properties of deployment")
model DeploymentProperties {
  @doc("Deployment ID")
  @visibility("read", "create")
  deploymentId?: string;

  @doc("Images deployed")
  @visibility("read", "create")
  deployedImages?: Image[];

  @doc("Deployment date UTC")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  deploymentDateUtc?: utcDateTime;

  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("Request of the action to list device groups for a catalog.")
model ListDeviceGroupsRequest {
  @doc("Device Group name.")
  deviceGroupName?: string;
}

@doc("The properties of deviceGroup")
model DeviceGroupProperties {
  @doc("Description of the device group.")
  description?: string;

  @doc("Operating system feed type of the device group.")
  osFeedType?: OSFeedType;

  @doc("Update policy of the device group.")
  updatePolicy?: UpdatePolicy;

  @doc("Flag to define if the user allows for crash dump collection.")
  allowCrashDumpsCollection?: AllowCrashDumpCollection;

  @doc("Regional data boundary for the device group.")
  regionalDataBoundary?: RegionalDataBoundary;

  @doc("Deployment status for the device group.")
  @visibility("read")
  hasDeployment?: boolean;

  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("Paged collection of DeviceInsight items")
model PagedDeviceInsight is Azure.Core.Page<DeviceInsight>;

@doc("Device insight report.")
model DeviceInsight {
  @doc("Device ID")
  deviceId: string;

  @doc("Event description")
  description: string;

  @doc("Event start timestamp")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTimestampUtc: utcDateTime;

  @doc("Event end timestamp")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTimestampUtc: utcDateTime;

  @doc("Event category")
  eventCategory: string;

  @doc("Event class")
  eventClass: string;

  @doc("Event type")
  eventType: string;

  @doc("Event count")
  eventCount: int32;
}

@doc("The properties of device")
model DeviceProperties {
  @doc("Device ID")
  @visibility("read", "create")
  deviceId?: string;

  @doc("SKU of the chip")
  @visibility("read")
  chipSku?: string;

  @doc("OS version available for installation when update requested")
  @visibility("read")
  lastAvailableOsVersion?: string;

  @doc("OS version running on device when update requested")
  @visibility("read")
  lastInstalledOsVersion?: string;

  @doc("Time when update requested and new OS version available")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastOsUpdateUtc?: utcDateTime;

  @doc("Time when update was last requested")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdateRequestUtc?: utcDateTime;

  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("The properties of product")
model ProductProperties {
  @doc("Description of the product")
  description: string;

  @doc("The status of the last operation.")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("Request to the action call to bulk claim devices.")
model ClaimDevicesRequest {
  @doc("Device identifiers of the devices to be claimed.")
  deviceIdentifiers: string[];
}

@doc("Request of the action to create a signed device capability image")
model GenerateCapabilityImageRequest {
  @doc("List of capabilities to create")
  capabilities: CapabilityType[];
}

@doc("Signed device capability image response")
model SignedCapabilityImageResponse {
  @doc("The signed device capability image as a UTF-8 encoded base 64 string.")
  @visibility("read")
  image?: string;
}

@doc("The properties of device patch")
model DevicePatchProperties {
  @doc("Device group id")
  deviceGroupId: string;
}

@doc("Image upload request body.")
model ImageUploadRequestBody {
  @doc(".")
  images: string;
}
