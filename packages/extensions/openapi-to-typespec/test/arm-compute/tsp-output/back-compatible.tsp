import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Compute;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ComputeOperationValue.display);

@@clientName(VirtualMachineScaleSetDataDisk.diskIOPSReadWrite,
  "diskIopsReadWrite"
);

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

@@clientName(DataDisk.diskIOPSReadWrite, "diskIopsReadWrite");

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

@@clientName(VirtualMachineCaptureResult.$schema, "schema");

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

@@clientName(RestorePointSourceVMStorageProfile.dataDisks, "dataDiskList");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RestorePointCollectionUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CapacityReservationGroupUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CapacityReservationUpdate.properties);

@@clientName(RunCommandDocumentBase.$schema, "schema");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineRunCommandUpdate.properties);

@@clientName(DiskProperties.diskIOPSReadWrite, "diskIopsReadWrite");
@@clientName(DiskProperties.diskIOPSReadOnly, "diskIopsReadOnly");
@@clientName(DiskProperties.LastOwnershipUpdateTime, "lastOwnershipUpdateTime");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskUpdate.properties);

@@clientName(DiskUpdateProperties.diskIOPSReadWrite, "diskIopsReadWrite");
@@clientName(DiskUpdateProperties.diskIOPSReadOnly, "diskIopsReadOnly");

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

@@clientName(VirtualMachineScaleSets.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(VirtualMachineScaleSets.update::parameters.properties,
  "parameters"
);
@@clientName(VirtualMachineScaleSets.deallocate::parameters.body,
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.deleteInstances::parameters.body,
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.powerOff::parameters.body,
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.restart::parameters.body, "vmInstanceIDs");
@@clientName(VirtualMachineScaleSets.start::parameters.body, "vmInstanceIDs");
@@clientName(VirtualMachineScaleSets.redeploy::parameters.body,
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.performMaintenance::parameters.body,
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.updateInstances::parameters.body,
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.reimage::parameters.body,
  "vmScaleSetReimageInput"
);
@@clientName(VirtualMachineScaleSets.reimageAll::parameters.body,
  "vmInstanceIDs"
);
@@clientName(VirtualMachineScaleSets.convertToSinglePlacementGroup::parameters.body,
  "parameters"
);
@@clientName(VirtualMachineScaleSets.setOrchestrationServiceState::parameters.body,
  "parameters"
);
@@clientLocation(VirtualMachineScaleSets.cancel,
  "VirtualMachineScaleSetRollingUpgrades"
);
@@clientLocation(VirtualMachineScaleSets.startOSUpgrade,
  "VirtualMachineScaleSetRollingUpgrades"
);
@@clientLocation(VirtualMachineScaleSets.startExtensionUpgrade,
  "VirtualMachineScaleSetRollingUpgrades"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSet.properties);

@@clientName(VirtualMachineScaleSetExtensions.createOrUpdate::parameters.resource,
  "extensionParameters"
);
@@clientName(VirtualMachineScaleSetExtensions.update::parameters.properties,
  "extensionParameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetExtension.properties);

@@clientName(VirtualMachineExtensions.createOrUpdate::parameters.resource,
  "extensionParameters"
);
@@clientName(VirtualMachineExtensions.update::parameters.properties,
  "extensionParameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineExtension.properties);

@@clientLocation(RollingUpgradeStatusInfos.getLatest,
  "VirtualMachineScaleSetRollingUpgrades"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RollingUpgradeStatusInfo.properties);

@@clientName(VirtualMachineScaleSetVMExtensions.createOrUpdate::parameters.resource,
  "extensionParameters"
);
@@clientName(VirtualMachineScaleSetVMExtensions.update::parameters.properties,
  "extensionParameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetVMExtension.properties);

@@clientLocation(VirtualMachineScaleSetVMS.get, "VirtualMachineScaleSetVMs");
@@clientLocation(VirtualMachineScaleSetVMS.update, "VirtualMachineScaleSetVMs");
@@clientName(VirtualMachineScaleSetVMS.update::parameters.resource,
  "parameters"
);
@@clientLocation(VirtualMachineScaleSetVMS.delete, "VirtualMachineScaleSetVMs");
@@clientLocation(VirtualMachineScaleSetVMS.list, "VirtualMachineScaleSetVMs");
@@clientLocation(VirtualMachineScaleSetVMS.reimage,
  "VirtualMachineScaleSetVMs"
);
@@clientName(VirtualMachineScaleSetVMS.reimage::parameters.body,
  "vmScaleSetVMReimageInput"
);
@@clientLocation(VirtualMachineScaleSetVMS.reimageAll,
  "VirtualMachineScaleSetVMs"
);
@@clientLocation(VirtualMachineScaleSetVMS.deallocate,
  "VirtualMachineScaleSetVMs"
);
@@clientLocation(VirtualMachineScaleSetVMS.getInstanceView,
  "VirtualMachineScaleSetVMs"
);
@@clientLocation(VirtualMachineScaleSetVMS.powerOff,
  "VirtualMachineScaleSetVMs"
);
@@clientLocation(VirtualMachineScaleSetVMS.restart,
  "VirtualMachineScaleSetVMs"
);
@@clientLocation(VirtualMachineScaleSetVMS.start, "VirtualMachineScaleSetVMs");
@@clientLocation(VirtualMachineScaleSetVMS.redeploy,
  "VirtualMachineScaleSetVMs"
);
@@clientLocation(VirtualMachineScaleSetVMS.retrieveBootDiagnosticsData,
  "VirtualMachineScaleSetVMs"
);
@@clientLocation(VirtualMachineScaleSetVMS.performMaintenance,
  "VirtualMachineScaleSetVMs"
);
@@clientLocation(VirtualMachineScaleSetVMS.simulateEviction,
  "VirtualMachineScaleSetVMs"
);
@@clientLocation(VirtualMachineScaleSetVMS.runCommand,
  "VirtualMachineScaleSetVMs"
);
@@clientName(VirtualMachineScaleSetVMS.runCommand::parameters.body,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetVM.properties);

@@clientName(VirtualMachines.createOrUpdate::parameters.resource, "parameters");
@@clientName(VirtualMachines.update::parameters.properties, "parameters");
@@clientName(VirtualMachines.capture::parameters.body, "parameters");
@@clientName(VirtualMachines.reimage::parameters.body, "parameters");
@@clientName(VirtualMachines.installPatches::parameters.body,
  "installPatchesInput"
);
@@clientName(VirtualMachines.runCommand::parameters.body, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachine.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineExtensionImage.properties);

@@clientName(AvailabilitySets.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(AvailabilitySets.update::parameters.properties, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AvailabilitySet.properties);

@@clientName(ProximityPlacementGroups.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(ProximityPlacementGroups.update::parameters.properties,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ProximityPlacementGroup.properties);

@@clientName(DedicatedHostGroups.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(DedicatedHostGroups.update::parameters.properties, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DedicatedHostGroup.properties);

@@clientName(DedicatedHosts.createOrUpdate::parameters.resource, "parameters");
@@clientName(DedicatedHosts.update::parameters.properties, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DedicatedHost.properties);

@@clientLocation(SshPublicKeyResources.get, "SshPublicKeys");
@@clientLocation(SshPublicKeyResources.create, "SshPublicKeys");
@@clientName(SshPublicKeyResources.create::parameters.resource, "parameters");
@@clientLocation(SshPublicKeyResources.update, "SshPublicKeys");
@@clientName(SshPublicKeyResources.update::parameters.properties, "parameters");
@@clientLocation(SshPublicKeyResources.delete, "SshPublicKeys");
@@clientLocation(SshPublicKeyResources.listByResourceGroup, "SshPublicKeys");
@@clientLocation(SshPublicKeyResources.listBySubscription, "SshPublicKeys");
@@clientLocation(SshPublicKeyResources.generateKeyPair, "SshPublicKeys");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SshPublicKeyResource.properties);

@@clientName(Images.createOrUpdate::parameters.resource, "parameters");
@@clientName(Images.update::parameters.properties, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Image.properties);

@@clientName(RestorePointCollections.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(RestorePointCollections.update::parameters.properties,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RestorePointCollection.properties);

@@clientName(RestorePoints.create::parameters.resource, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RestorePoint.properties);

@@clientName(CapacityReservationGroups.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(CapacityReservationGroups.update::parameters.properties,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CapacityReservationGroup.properties);

@@clientName(CapacityReservations.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(CapacityReservations.update::parameters.properties, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CapacityReservation.properties);

@@clientName(VirtualMachineRunCommands.createOrUpdate::parameters.resource,
  "runCommand"
);
@@clientName(VirtualMachineRunCommands.update::parameters.properties,
  "runCommand"
);
@@clientName(VirtualMachineScaleSetVMRunCommands.createOrUpdate::parameters.resource,
  "runCommand"
);
@@clientName(VirtualMachineScaleSetVMRunCommands.update::parameters.properties,
  "runCommand"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineRunCommand.properties);

@@clientName(Disks.createOrUpdate::parameters.resource, "disk");
@@clientName(Disks.update::parameters.properties, "disk");
@@clientName(Disks.grantAccess::parameters.body, "grantAccessData");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Disk.properties);

@@clientName(DiskAccesses.createOrUpdate::parameters.resource, "diskAccess");
@@clientName(DiskAccesses.update::parameters.properties, "diskAccess");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskAccess.properties);

@@clientLocation(PrivateEndpointConnections.getAPrivateEndpointConnection,
  DiskAccesses
);
@@clientLocation(PrivateEndpointConnections.updateAPrivateEndpointConnection,
  DiskAccesses
);
@@clientName(PrivateEndpointConnections.updateAPrivateEndpointConnection::parameters.resource,
  "privateEndpointConnection"
);
@@clientLocation(PrivateEndpointConnections.deleteAPrivateEndpointConnection,
  DiskAccesses
);
@@clientLocation(PrivateEndpointConnections.listPrivateEndpointConnections,
  DiskAccesses
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

@@clientName(DiskEncryptionSets.createOrUpdate::parameters.resource,
  "diskEncryptionSet"
);
@@clientName(DiskEncryptionSets.update::parameters.properties,
  "diskEncryptionSet"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskEncryptionSet.properties);

@@clientLocation(DiskRestorePoints.get, "DiskRestorePoint");
@@clientLocation(DiskRestorePoints.listByRestorePoint, "DiskRestorePoint");
@@clientLocation(DiskRestorePoints.grantAccess, "DiskRestorePoint");
@@clientName(DiskRestorePoints.grantAccess::parameters.body, "grantAccessData");
@@clientLocation(DiskRestorePoints.revokeAccess, "DiskRestorePoint");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskRestorePoint.properties);

@@clientName(Snapshots.createOrUpdate::parameters.resource, "snapshot");
@@clientName(Snapshots.update::parameters.properties, "snapshot");
@@clientName(Snapshots.grantAccess::parameters.body, "grantAccessData");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Snapshot.properties);

@@clientName(Galleries.createOrUpdate::parameters.resource, "gallery");
@@clientName(Galleries.update::parameters.properties, "gallery");
@@clientLocation(Galleries.gallerySharingProfileUpdate,
  "GallerySharingProfile"
);
@@clientName(Galleries.gallerySharingProfileUpdate, "Update");
@@clientName(Galleries.gallerySharingProfileUpdate::parameters.body,
  "sharingUpdate"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Gallery.properties);

@@clientName(GalleryImages.createOrUpdate::parameters.resource, "galleryImage");
@@clientName(GalleryImages.update::parameters.properties, "galleryImage");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryImage.properties);

@@clientName(GalleryImageVersions.createOrUpdate::parameters.resource,
  "galleryImageVersion"
);
@@clientName(GalleryImageVersions.update::parameters.properties,
  "galleryImageVersion"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryImageVersion.properties);

@@clientName(GalleryApplications.createOrUpdate::parameters.resource,
  "galleryApplication"
);
@@clientName(GalleryApplications.update::parameters.properties,
  "galleryApplication"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryApplication.properties);

@@clientName(GalleryApplicationVersions.createOrUpdate::parameters.resource,
  "galleryApplicationVersion"
);
@@clientName(GalleryApplicationVersions.update::parameters.properties,
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

@@clientName(CloudServices.createOrUpdate::parameters.resource, "parameters");
@@clientName(CloudServices.update::parameters.properties, "parameters");
@@clientName(CloudServices.restart::parameters.body, "parameters");
@@clientName(CloudServices.reimage::parameters.body, "parameters");
@@clientName(CloudServices.rebuild::parameters.body, "parameters");
@@clientName(CloudServices.deleteInstances::parameters.body, "parameters");
@@clientLocation(CloudServices.walkUpdateDomain, "CloudServicesUpdateDomain");
@@clientName(CloudServices.walkUpdateDomain::parameters.body, "parameters");
@@clientLocation(CloudServices.getUpdateDomain, "CloudServicesUpdateDomain");
@@clientLocation(CloudServices.listUpdateDomains, "CloudServicesUpdateDomain");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CloudService.properties);

@@clientLocation(OSVersions.getOSVersion, "CloudServiceOperatingSystems");
@@clientLocation(OSVersions.listOSVersions, "CloudServiceOperatingSystems");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OSVersion.properties);

@@clientLocation(OSFamilies.getOSFamily, "CloudServiceOperatingSystems");
@@clientLocation(OSFamilies.listOSFamilies, "CloudServiceOperatingSystems");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OSFamily.properties);

@@clientLocation(UsageOperationGroup.list, "Usage");

@@clientLocation(VirtualMachineSizesOperationGroup.list, "VirtualMachineSizes");

@@clientLocation(VirtualMachineScaleSetsOperationGroup.listByLocation,
  VirtualMachineScaleSets
);

@@clientLocation(VirtualMachinesOperationGroup.listByLocation, VirtualMachines);

@@clientLocation(VirtualMachineImagesOperationGroup.get,
  "VirtualMachineImages"
);
@@clientLocation(VirtualMachineImagesOperationGroup.list,
  "VirtualMachineImages"
);
@@clientLocation(VirtualMachineImagesOperationGroup.listOffers,
  "VirtualMachineImages"
);
@@clientLocation(VirtualMachineImagesOperationGroup.listPublishers,
  "VirtualMachineImages"
);
@@clientLocation(VirtualMachineImagesOperationGroup.listSkus,
  "VirtualMachineImages"
);
@@clientLocation(VirtualMachineImagesOperationGroup.listByEdgeZone,
  "VirtualMachineImages"
);

@@clientLocation(VirtualMachineImagesEdgeZoneOperationGroup.get,
  "VirtualMachineImagesEdgeZone"
);
@@clientLocation(VirtualMachineImagesEdgeZoneOperationGroup.list,
  "VirtualMachineImagesEdgeZone"
);
@@clientLocation(VirtualMachineImagesEdgeZoneOperationGroup.listOffers,
  "VirtualMachineImagesEdgeZone"
);
@@clientLocation(VirtualMachineImagesEdgeZoneOperationGroup.listPublishers,
  "VirtualMachineImagesEdgeZone"
);
@@clientLocation(VirtualMachineImagesEdgeZoneOperationGroup.listSkus,
  "VirtualMachineImagesEdgeZone"
);

@@clientLocation(LogAnalyticsOperationGroup.exportRequestRateByInterval,
  "LogAnalytics"
);
@@clientLocation(LogAnalyticsOperationGroup.exportThrottledRequests,
  "LogAnalytics"
);

@@clientLocation(VirtualMachineRunCommandsOperationGroup.list,
  VirtualMachineRunCommands
);
@@clientLocation(VirtualMachineRunCommandsOperationGroup.get,
  VirtualMachineRunCommands
);

@@clientLocation(ResourceSkusOperationGroup.list, "ResourceSkus");
