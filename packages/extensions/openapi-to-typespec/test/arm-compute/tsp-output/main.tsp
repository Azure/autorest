import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./VirtualMachineScaleSet.tsp";
import "./VirtualMachineScaleSetExtension.tsp";
import "./RollingUpgradeStatusInfo.tsp";
import "./VirtualMachineScaleSetVMExtension.tsp";
import "./VirtualMachineScaleSetVM.tsp";
import "./VirtualMachineExtension.tsp";
import "./VirtualMachine.tsp";
import "./VirtualMachineExtensionImage.tsp";
import "./AvailabilitySet.tsp";
import "./ProximityPlacementGroup.tsp";
import "./DedicatedHostGroup.tsp";
import "./DedicatedHost.tsp";
import "./SshPublicKeyResource.tsp";
import "./Image.tsp";
import "./RestorePointCollection.tsp";
import "./RestorePoint.tsp";
import "./CapacityReservationGroup.tsp";
import "./CapacityReservation.tsp";
import "./VirtualMachineRunCommand.tsp";
import "./VirtualMachineRunCommand.tsp";
import "./Disk.tsp";
import "./DiskAccess.tsp";
import "./PrivateEndpointConnection.tsp";
import "./DiskEncryptionSet.tsp";
import "./DiskRestorePoint.tsp";
import "./Snapshot.tsp";
import "./Gallery.tsp";
import "./GalleryImage.tsp";
import "./GalleryImageVersion.tsp";
import "./GalleryApplication.tsp";
import "./GalleryApplicationVersion.tsp";
import "./SharedGallery.tsp";
import "./SharedGalleryImage.tsp";
import "./SharedGalleryImageVersion.tsp";
import "./CommunityGallery.tsp";
import "./CommunityGalleryImage.tsp";
import "./CommunityGalleryImageVersion.tsp";
import "./RoleInstance.tsp";
import "./CloudServiceRole.tsp";
import "./CloudService.tsp";
import "./OSVersion.tsp";
import "./OSFamily.tsp";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
/**
 * Compute Client
 */
@armProviderNamespace
@useAuth(AadOauth2Auth<["user_impersonation"]>)
@service({
  title: "Azure Compute resource management API.",
})
@versioned(Versions)
namespace Microsoft.Compute;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2023-07-01 API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2023_07_01: "2023-07-01",

  /**
   * The 2023-04-02 API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2023_04_02: "2023-04-02",

  /**
   * The 2021-07-01 API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2021_07_01: "2021-07-01",

  /**
   * The 2022-03-03 API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_03_03: "2022-03-03",

  /**
   * The 2022-09-04 API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_09_04: "2022-09-04",
}
