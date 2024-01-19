import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Microsoft.AzureSphere;

interface Operations extends Azure.ResourceManager.Operations {}

/**
 * Provisioning state of the resource.
 */
enum ProvisioningState {
  /**
   * Resource has been created.
   */
  Succeeded,

  /**
   * Resource creation failed.
   */
  Failed,

  /**
   * Resource creation was canceled.
   */
  Canceled,

  /**
   * The resource is being provisioned
   */
  Provisioning,

  /**
   * The resource is being updated
   */
  Updating,

  /**
   * The resource is being deleted
   */
  Deleting,

  /**
   * The resource create request has been accepted
   */
  Accepted,
}

/**
 * Certificate status values.
 */
enum CertificateStatus {
  /**
   * Certificate is active
   */
  Active,

  /**
   * Certificate is inactive
   */
  Inactive,

  /**
   * Certificate has expired
   */
  Expired,

  /**
   * Certificate has been revoked
   */
  Revoked,
}

/**
 * Regional data boundary values.
 */
enum RegionalDataBoundary {
  /**
   * No data boundary
   */
  None,

  /**
   * EU data boundary
   */
  EU,
}

/**
 * Image type values.
 */
enum ImageType {
  /**
   * Invalid image.
   */
  InvalidImageType,

  /**
   * One Bl image type
   */
  OneBl,

  /**
   * Pluton image type
   */
  PlutonRuntime,

  /**
   * Wifi firmware image type
   */
  WifiFirmware,

  /**
   * Security monitor image type
   */
  SecurityMonitor,

  /**
   * Normal world loader image type
   */
  NormalWorldLoader,

  /**
   * Normal world dtb image type
   */
  NormalWorldDtb,

  /**
   * Normal world kernel image type
   */
  NormalWorldKernel,

  /**
   * Root FS image type
   */
  RootFs,

  /**
   * Services image type
   */
  Services,

  /**
   * Applications image type
   */
  Applications,

  /**
   * FW config image type
   */
  FwConfig,

  /**
   * Boot manifest image type
   */
  BootManifest,

  /**
   * Nwfs image type
   */
  Nwfs,

  /**
   * Trusted key store image type
   */
  TrustedKeystore,

  /**
   * Policy image type
   */
  Policy,

  /**
   * Customer board config image type
   */
  CustomerBoardConfig,

  /**
   * Update certificate store image type
   */
  UpdateCertStore,

  /**
   * Base system update manifest image type
   */
  BaseSystemUpdateManifest,

  /**
   * Firmware update manifest image type
   */
  FirmwareUpdateManifest,

  /**
   * Customer update manifest image type
   */
  CustomerUpdateManifest,

  /**
   * Recovery manifest image type
   */
  RecoveryManifest,

  /**
   * manifest set image type
   */
  ManifestSet,

  /**
   * Other image type
   */
  Other,
}

/**
 * OS feed type values.
 */
enum OSFeedType {
  /**
   * Retail OS feed type.
   */
  Retail,

  /**
   * Retail evaluation OS feed type.
   */
  RetailEval,
}

/**
 * Update policy values.
 */
enum UpdatePolicy {
  /**
   * Update all policy.
   */
  UpdateAll,

  /**
   * No update for 3rd party app policy.
   */
  No3rdPartyAppUpdates,
}

/**
 * Allow crash dumps values.
 */
enum AllowCrashDumpCollection {
  /**
   * Crash dump collection enabled
   */
  Enabled,

  /**
   * Crash dump collection disabled
   */
  Disabled,
}

/**
 * Capability image type
 */
enum CapabilityType {
  /**
   * Application development capability
   */
  ApplicationDevelopment,

  /**
   * Field servicing capability
   */
  FieldServicing,
}

/**
 * Catalog properties
 */
model CatalogProperties {
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
 * The type used for update operations of the Catalog.
 */
model CatalogUpdate {
  /**
   * Resource tags.
   */
  tags?: Record<string>;
}

/**
 * The properties of certificate
 */
model CertificateProperties {
  /**
   * The certificate as a UTF-8 encoded base 64 string.
   */
  @visibility("read")
  certificate?: string;

  /**
   * The certificate status.
   */
  @visibility("read")
  status?: CertificateStatus;

  /**
   * The certificate subject.
   */
  @visibility("read")
  subject?: string;

  /**
   * The certificate thumbprint.
   */
  @visibility("read")
  thumbprint?: string;

  /**
   * The certificate expiry date.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryUtc?: utcDateTime;

  /**
   * The certificate not before date.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  notBeforeUtc?: utcDateTime;

  /**
   * The status of the last operation.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;
}

/**
 * The certificate chain response.
 */
model CertificateChainResponse {
  /**
   * The certificate chain.
   */
  @visibility("read")
  certificateChain?: string;
}

/**
 * Request for the proof of possession nonce
 */
model ProofOfPossessionNonceRequest {
  /**
   * The proof of possession nonce
   */
  proofOfPossessionNonce: string;
}

/**
 * Result of the action to generate a proof of possession nonce
 */
model ProofOfPossessionNonceResponse extends CertificateProperties {}

/**
 * Response to the action call for count devices in a catalog.
 */
model CountDeviceResponse extends CountElementsResponse {}

/**
 * Response of the count for elements.
 */
model CountElementsResponse {
  /**
   * Number of children resources in parent resource.
   */
  value: int32;
}

/**
 * The properties of image
 */
model ImageProperties {
  /**
   * Image as a UTF-8 encoded base 64 string on image create. This field contains the image URI on image reads.
   */
  @visibility("read", "create")
  image?: string;

  /**
   * Image ID
   */
  @visibility("read", "create")
  imageId?: string;

  /**
   * Image name
   */
  @visibility("read")
  imageName?: string;

  /**
   * Regional data boundary for an image
   */
  @visibility("read", "create")
  regionalDataBoundary?: RegionalDataBoundary;

  /**
   * Location the image
   */
  @visibility("read")
  uri?: string;

  /**
   * The image description.
   */
  @visibility("read")
  description?: string;

  /**
   * The image component id.
   */
  @visibility("read")
  componentId?: string;

  /**
   * The image type.
   */
  @visibility("read")
  imageType?: ImageType;

  /**
   * The status of the last operation.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;
}

/**
 * The properties of deployment
 */
model DeploymentProperties {
  /**
   * Deployment ID
   */
  @visibility("read", "create")
  deploymentId?: string;

  /**
   * Images deployed
   */
  @visibility("read", "create")
  deployedImages?: Image[];

  /**
   * Deployment date UTC
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  deploymentDateUtc?: utcDateTime;

  /**
   * The status of the last operation.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;
}

/**
 * Request of the action to list device groups for a catalog.
 */
model ListDeviceGroupsRequest {
  /**
   * Device Group name.
   */
  deviceGroupName?: string;
}

/**
 * The properties of deviceGroup
 */
model DeviceGroupProperties {
  /**
   * Description of the device group.
   */
  description?: string;

  /**
   * Operating system feed type of the device group.
   */
  osFeedType?: OSFeedType;

  /**
   * Update policy of the device group.
   */
  updatePolicy?: UpdatePolicy;

  /**
   * Flag to define if the user allows for crash dump collection.
   */
  allowCrashDumpsCollection?: AllowCrashDumpCollection;

  /**
   * Regional data boundary for the device group.
   */
  regionalDataBoundary?: RegionalDataBoundary;

  /**
   * Deployment status for the device group.
   */
  @visibility("read")
  hasDeployment?: boolean;

  /**
   * The status of the last operation.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;
}

/**
 * Paged collection of DeviceInsight items
 */
model PagedDeviceInsight is Azure.Core.Page<DeviceInsight>;

/**
 * Device insight report.
 */
model DeviceInsight {
  /**
   * Device ID
   */
  deviceId: string;

  /**
   * Event description
   */
  description: string;

  /**
   * Event start timestamp
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTimestampUtc: utcDateTime;

  /**
   * Event end timestamp
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTimestampUtc: utcDateTime;

  /**
   * Event category
   */
  eventCategory: string;

  /**
   * Event class
   */
  eventClass: string;

  /**
   * Event type
   */
  eventType: string;

  /**
   * Event count
   */
  eventCount: int32;
}

/**
 * The properties of device
 */
model DeviceProperties {
  /**
   * Device ID
   */
  @visibility("read", "create")
  deviceId?: string;

  /**
   * SKU of the chip
   */
  @visibility("read")
  chipSku?: string;

  /**
   * OS version available for installation when update requested
   */
  @visibility("read")
  lastAvailableOsVersion?: string;

  /**
   * OS version running on device when update requested
   */
  @visibility("read")
  lastInstalledOsVersion?: string;

  /**
   * Time when update requested and new OS version available
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastOsUpdateUtc?: utcDateTime;

  /**
   * Time when update was last requested
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdateRequestUtc?: utcDateTime;

  /**
   * The status of the last operation.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;
}

/**
 * The properties of product
 */
model ProductProperties {
  /**
   * Description of the product
   */
  description: string;

  /**
   * The status of the last operation.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;
}

/**
 * The type used for update operations of the Product.
 */
model ProductUpdate {
  /**
   * The updatable properties of the Product.
   */
  properties?: ProductUpdateProperties;
}

/**
 * The updatable properties of the Product.
 */
model ProductUpdateProperties {
  /**
   * Description of the product
   */
  description?: string;
}

/**
 * The type used for update operations of the DeviceGroup.
 */
model DeviceGroupUpdate {
  /**
   * The updatable properties of the DeviceGroup.
   */
  properties?: DeviceGroupUpdateProperties;
}

/**
 * The updatable properties of the DeviceGroup.
 */
model DeviceGroupUpdateProperties {
  /**
   * Description of the device group.
   */
  description?: string;

  /**
   * Operating system feed type of the device group.
   */
  osFeedType?: OSFeedType;

  /**
   * Update policy of the device group.
   */
  updatePolicy?: UpdatePolicy;

  /**
   * Flag to define if the user allows for crash dump collection.
   */
  allowCrashDumpsCollection?: AllowCrashDumpCollection;

  /**
   * Regional data boundary for the device group.
   */
  regionalDataBoundary?: RegionalDataBoundary;
}

/**
 * Request to the action call to bulk claim devices.
 */
model ClaimDevicesRequest {
  /**
   * Device identifiers of the devices to be claimed.
   */
  deviceIdentifiers: string[];
}

/**
 * The type used for update operations of the Device.
 */
model DeviceUpdate {
  /**
   * The updatable properties of the Device.
   */
  properties?: DeviceUpdateProperties;
}

/**
 * The updatable properties of the Device.
 */
model DeviceUpdateProperties {
  /**
   * Device group id
   */
  deviceGroupId?: string;
}

/**
 * Request of the action to create a signed device capability image
 */
model GenerateCapabilityImageRequest {
  /**
   * List of capabilities to create
   */
  capabilities: CapabilityType[];
}

/**
 * Signed device capability image response
 */
model SignedCapabilityImageResponse {
  /**
   * The signed device capability image as a UTF-8 encoded base 64 string.
   */
  @visibility("read")
  image?: string;
}

/**
 * The properties of device patch
 */
model DevicePatchProperties {
  /**
   * Device group id
   */
  deviceGroupId: string;
}

/**
 * Image upload request body.
 */
model ImageUploadRequestBody {
  /**
   * .
   */
  images: string;
}
