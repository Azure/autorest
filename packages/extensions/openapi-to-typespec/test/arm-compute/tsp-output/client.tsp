import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Compute;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ComputeOperationValue.display);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetNetworkConfiguration.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetIPConfiguration.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetPublicIPAddressConfiguration.properties
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetUpdateNetworkConfiguration.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetUpdateIPConfiguration.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetUpdatePublicIPAddressConfiguration.properties
);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetExtensionUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetVMExtensionUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(NetworkInterfaceReference.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineNetworkInterfaceConfiguration.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineNetworkInterfaceIPConfiguration.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachinePublicIPAddressConfiguration.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineExtensionUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineImage.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AvailabilitySetUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DedicatedHostGroupUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DedicatedHostUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SshPublicKeyUpdateResource.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ImageUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RestorePointCollectionUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CapacityReservationGroupUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CapacityReservationUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineRunCommandUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateLinkResource.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskEncryptionSetUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SnapshotUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryImageUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryImageVersionUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryApplicationUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryApplicationVersionUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PirSharedGalleryResource.identifier);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PirCommunityGalleryResource.identifier);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(LoadBalancerConfiguration.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(LoadBalancerFrontendIpConfiguration.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Extension.properties);

@@clientName(VirtualMachineScaleSets.update,
  "VirtualMachineScaleSets.update::parameters.properties",
  "parameters"
);
@@clientName(VirtualMachineScaleSets.deallocate,
  "VirtualMachineScaleSets.deallocate::parameters.body",
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.deleteInstances,
  "VirtualMachineScaleSets.deleteInstances::parameters.body",
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.powerOff,
  "VirtualMachineScaleSets.powerOff::parameters.body",
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.restart,
  "VirtualMachineScaleSets.restart::parameters.body",
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.start,
  "VirtualMachineScaleSets.start::parameters.body",
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.redeploy,
  "VirtualMachineScaleSets.redeploy::parameters.body",
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.performMaintenance,
  "VirtualMachineScaleSets.performMaintenance::parameters.body",
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.updateInstances,
  "VirtualMachineScaleSets.updateInstances::parameters.body",
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.reimage,
  "VirtualMachineScaleSets.reimage::parameters.body",
  "vmScaleSetReimageInput"
);
@@clientName(VirtualMachineScaleSets.reimageAll,
  "VirtualMachineScaleSets.reimageAll::parameters.body",
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.convertToSinglePlacementGroup,
  "VirtualMachineScaleSets.convertToSinglePlacementGroup::parameters.body",
  "parameters"
);
@@clientName(VirtualMachineScaleSets.setOrchestrationServiceState,
  "VirtualMachineScaleSets.setOrchestrationServiceState::parameters.body",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSet.properties);

@@clientName(VirtualMachineScaleSetExtensions.update,
  "VirtualMachineScaleSetExtensions.update::parameters.properties",
  "extensionParameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetExtension.properties);

@@clientName(VirtualMachineExtensions.update,
  "VirtualMachineExtensions.update::parameters.properties",
  "extensionParameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineExtension.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RollingUpgradeStatusInfo.properties);

@@clientName(VirtualMachineScaleSetVMExtensions.update,
  "VirtualMachineScaleSetVMExtensions.update::parameters.properties",
  "extensionParameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetVMExtension.properties);

@@clientName(VirtualMachineScaleSetVMS.reimage,
  "VirtualMachineScaleSetVMS.reimage::parameters.body",
  "vmScaleSetVMReimageInput"
);
@@clientName(VirtualMachineScaleSetVMS.runCommand,
  "VirtualMachineScaleSetVMS.runCommand::parameters.body",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetVM.properties);

@@clientName(VirtualMachines.update,
  "VirtualMachines.update::parameters.properties",
  "parameters"
);
@@clientName(VirtualMachines.capture,
  "VirtualMachines.capture::parameters.body",
  "parameters"
);
@@clientName(VirtualMachines.reimage,
  "VirtualMachines.reimage::parameters.body",
  "parameters"
);
@@clientName(VirtualMachines.installPatches,
  "VirtualMachines.installPatches::parameters.body",
  "installPatchesInput"
);
@@clientName(VirtualMachines.runCommand,
  "VirtualMachines.runCommand::parameters.body",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachine.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineExtensionImage.properties);

@@clientName(AvailabilitySets.update,
  "AvailabilitySets.update::parameters.properties",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AvailabilitySet.properties);

@@clientName(ProximityPlacementGroups.update,
  "ProximityPlacementGroups.update::parameters.properties",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ProximityPlacementGroup.properties);

@@clientName(DedicatedHostGroups.update,
  "DedicatedHostGroups.update::parameters.properties",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DedicatedHostGroup.properties);

@@clientName(DedicatedHosts.update,
  "DedicatedHosts.update::parameters.properties",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DedicatedHost.properties);

@@clientName(SshPublicKeyResources.update,
  "SshPublicKeyResources.update::parameters.properties",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SshPublicKeyResource.properties);

@@clientName(Images.update,
  "Images.update::parameters.properties",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Image.properties);

@@clientName(RestorePointCollections.update,
  "RestorePointCollections.update::parameters.properties",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RestorePointCollection.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RestorePoint.properties);

@@clientName(CapacityReservationGroups.update,
  "CapacityReservationGroups.update::parameters.properties",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CapacityReservationGroup.properties);

@@clientName(CapacityReservations.update,
  "CapacityReservations.update::parameters.properties",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CapacityReservation.properties);

@@clientName(VirtualMachineRunCommands.update,
  "VirtualMachineRunCommands.update::parameters.properties",
  "runCommand"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineRunCommand.properties);

@@clientName(Disks.update, "Disks.update::parameters.properties", "disk");
@@clientName(Disks.grantAccess,
  "Disks.grantAccess::parameters.body",
  "grantAccessData"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Disk.properties);

@@clientName(DiskAccesses.update,
  "DiskAccesses.update::parameters.properties",
  "diskAccess"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskAccess.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

@@clientName(DiskEncryptionSets.update,
  "DiskEncryptionSets.update::parameters.properties",
  "diskEncryptionSet"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskEncryptionSet.properties);

@@clientName(DiskRestorePoints.grantAccess,
  "DiskRestorePoints.grantAccess::parameters.body",
  "grantAccessData"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskRestorePoint.properties);

@@clientName(Snapshots.update,
  "Snapshots.update::parameters.properties",
  "snapshot"
);
@@clientName(Snapshots.grantAccess,
  "Snapshots.grantAccess::parameters.body",
  "grantAccessData"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Snapshot.properties);

@@clientName(Galleries.update,
  "Galleries.update::parameters.properties",
  "gallery"
);
@@clientName(Galleries.gallerySharingProfileUpdate,
  "Galleries.gallerySharingProfileUpdate::parameters.body",
  "sharingUpdate"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Gallery.properties);

@@clientName(GalleryImages.update,
  "GalleryImages.update::parameters.properties",
  "galleryImage"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryImage.properties);

@@clientName(GalleryImageVersions.update,
  "GalleryImageVersions.update::parameters.properties",
  "galleryImageVersion"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryImageVersion.properties);

@@clientName(GalleryApplications.update,
  "GalleryApplications.update::parameters.properties",
  "galleryApplication"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryApplication.properties);

@@clientName(GalleryApplicationVersions.update,
  "GalleryApplicationVersions.update::parameters.properties",
  "galleryApplicationVersion"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryApplicationVersion.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SharedGalleryImage.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SharedGalleryImageVersion.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CommunityGalleryImage.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CommunityGalleryImageVersion.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleInstance.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CloudServiceRole.properties);

@@clientName(CloudServices.update,
  "CloudServices.update::parameters.properties",
  "parameters"
);
@@clientName(CloudServices.restart,
  "CloudServices.restart::parameters.body",
  "parameters"
);
@@clientName(CloudServices.reimage,
  "CloudServices.reimage::parameters.body",
  "parameters"
);
@@clientName(CloudServices.rebuild,
  "CloudServices.rebuild::parameters.body",
  "parameters"
);
@@clientName(CloudServices.deleteInstances,
  "CloudServices.deleteInstances::parameters.body",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CloudService.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OSVersion.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OSFamily.properties);
