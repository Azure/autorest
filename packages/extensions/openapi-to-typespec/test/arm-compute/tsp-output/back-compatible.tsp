import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Compute;

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ComputeOperationValue.display);

@@clientName(VirtualMachineScaleSetDataDisk.diskIOPSReadWrite,
  "diskIopsReadWrite"
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetNetworkConfiguration.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetIPConfiguration.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetPublicIPAddressConfiguration.properties
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetUpdateNetworkConfiguration.properties
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetUpdateIPConfiguration.properties
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetUpdatePublicIPAddressConfiguration.properties
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetExtensionUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetVMExtensionUpdate.properties);

@@clientName(DataDisk.diskIOPSReadWrite, "diskIopsReadWrite");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(NetworkInterfaceReference.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineNetworkInterfaceConfiguration.properties
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineNetworkInterfaceIPConfiguration.properties
);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachinePublicIPAddressConfiguration.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineExtensionUpdate.properties);

@@clientName(VirtualMachineCaptureResult.$schema, "schema");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineImage.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AvailabilitySetUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DedicatedHostGroupUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DedicatedHostUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SshPublicKeyUpdateResource.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ImageUpdate.properties);

@@clientName(RestorePointSourceVMStorageProfile.dataDisks, "dataDiskList");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RestorePointCollectionUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CapacityReservationGroupUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CapacityReservationUpdate.properties);

@@clientName(RunCommandDocumentBase.$schema, "schema");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineRunCommandUpdate.properties);

@@clientName(DiskProperties.diskIOPSReadWrite, "diskIopsReadWrite");
@@clientName(DiskProperties.diskIOPSReadOnly, "diskIopsReadOnly");
@@clientName(DiskProperties.LastOwnershipUpdateTime, "lastOwnershipUpdateTime");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DiskUpdate.properties);

@@clientName(DiskUpdateProperties.diskIOPSReadWrite, "diskIopsReadWrite");
@@clientName(DiskUpdateProperties.diskIOPSReadOnly, "diskIopsReadOnly");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PrivateLinkResource.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DiskEncryptionSetUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SnapshotUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GalleryUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GalleryImageUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GalleryImageVersionUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GalleryApplicationUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GalleryApplicationVersionUpdate.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PirSharedGalleryResource.identifier);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PirCommunityGalleryResource.identifier);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(LoadBalancerConfiguration.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(LoadBalancerFrontendIpConfiguration.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(Extension.properties);

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
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSet.properties);

@@clientName(VirtualMachineScaleSetExtensions.createOrUpdate::parameters.resource,
  "extensionParameters"
);
@@clientName(VirtualMachineScaleSetExtensions.update::parameters.properties,
  "extensionParameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetExtension.properties);

@@clientName(VirtualMachineExtensions.createOrUpdate::parameters.resource,
  "extensionParameters"
);
@@clientName(VirtualMachineExtensions.update::parameters.properties,
  "extensionParameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineExtension.properties);

@@clientLocation(RollingUpgradeStatusInfos.getLatest,
  "VirtualMachineScaleSetRollingUpgrades"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RollingUpgradeStatusInfo.properties);

@@clientName(VirtualMachineScaleSetVMExtensions.createOrUpdate::parameters.resource,
  "extensionParameters"
);
@@clientName(VirtualMachineScaleSetVMExtensions.update::parameters.properties,
  "extensionParameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetVMExtension.properties);

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
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineScaleSetVM.properties);

@@clientName(VirtualMachines.createOrUpdate::parameters.resource, "parameters");
@@clientName(VirtualMachines.update::parameters.properties, "parameters");
@@clientName(VirtualMachines.capture::parameters.body, "parameters");
@@clientName(VirtualMachines.reimage::parameters.body, "parameters");
@@clientName(VirtualMachines.installPatches::parameters.body,
  "installPatchesInput"
);
@@clientName(VirtualMachines.runCommand::parameters.body, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachine.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineExtensionImage.properties);

@@clientName(AvailabilitySets.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(AvailabilitySets.update::parameters.properties, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AvailabilitySet.properties);

@@clientName(ProximityPlacementGroups.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(ProximityPlacementGroups.update::parameters.properties,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ProximityPlacementGroup.properties);

@@clientName(DedicatedHostGroups.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(DedicatedHostGroups.update::parameters.properties, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DedicatedHostGroup.properties);

@@clientName(DedicatedHosts.createOrUpdate::parameters.resource, "parameters");
@@clientName(DedicatedHosts.update::parameters.properties, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DedicatedHost.properties);

@@clientLocation(SshPublicKeyResources.get, "SshPublicKeys");
@@clientLocation(SshPublicKeyResources.create, "SshPublicKeys");
@@clientName(SshPublicKeyResources.create::parameters.resource, "parameters");
@@clientLocation(SshPublicKeyResources.update, "SshPublicKeys");
@@clientName(SshPublicKeyResources.update::parameters.properties, "parameters");
@@clientLocation(SshPublicKeyResources.delete, "SshPublicKeys");
@@clientLocation(SshPublicKeyResources.listByResourceGroup, "SshPublicKeys");
@@clientLocation(SshPublicKeyResources.listBySubscription, "SshPublicKeys");
@@clientLocation(SshPublicKeyResources.generateKeyPair, "SshPublicKeys");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SshPublicKeyResource.properties);

@@clientName(Images.createOrUpdate::parameters.resource, "parameters");
@@clientName(Images.update::parameters.properties, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(Image.properties);

@@clientName(RestorePointCollections.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(RestorePointCollections.update::parameters.properties,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RestorePointCollection.properties);

@@clientName(RestorePoints.create::parameters.resource, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RestorePoint.properties);

@@clientName(CapacityReservationGroups.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(CapacityReservationGroups.update::parameters.properties,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CapacityReservationGroup.properties);

@@clientName(CapacityReservations.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientName(CapacityReservations.update::parameters.properties, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CapacityReservation.properties);

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
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(VirtualMachineRunCommand.properties);

@@clientName(Disks.createOrUpdate::parameters.resource, "disk");
@@clientName(Disks.update::parameters.properties, "disk");
@@clientName(Disks.grantAccess::parameters.body, "grantAccessData");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(Disk.properties);

@@clientName(DiskAccesses.createOrUpdate::parameters.resource, "diskAccess");
@@clientName(DiskAccesses.update::parameters.properties, "diskAccess");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DiskAccess.properties);

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
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PrivateEndpointConnection.properties);

@@clientName(DiskEncryptionSets.createOrUpdate::parameters.resource,
  "diskEncryptionSet"
);
@@clientName(DiskEncryptionSets.update::parameters.properties,
  "diskEncryptionSet"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DiskEncryptionSet.properties);

@@clientLocation(DiskRestorePoints.get, "DiskRestorePoint");
@@clientLocation(DiskRestorePoints.listByRestorePoint, "DiskRestorePoint");
@@clientLocation(DiskRestorePoints.grantAccess, "DiskRestorePoint");
@@clientName(DiskRestorePoints.grantAccess::parameters.body, "grantAccessData");
@@clientLocation(DiskRestorePoints.revokeAccess, "DiskRestorePoint");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DiskRestorePoint.properties);

@@clientName(Snapshots.createOrUpdate::parameters.resource, "snapshot");
@@clientName(Snapshots.update::parameters.properties, "snapshot");
@@clientName(Snapshots.grantAccess::parameters.body, "grantAccessData");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(Snapshot.properties);

@@clientName(Galleries.createOrUpdate::parameters.resource, "gallery");
@@clientName(Galleries.update::parameters.properties, "gallery");
@@clientLocation(Galleries.gallerySharingProfileUpdate,
  "GallerySharingProfile"
);
@@clientName(Galleries.gallerySharingProfileUpdate, "Update");
@@clientName(Galleries.gallerySharingProfileUpdate::parameters.body,
  "sharingUpdate"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(Gallery.properties);

@@clientName(GalleryImages.createOrUpdate::parameters.resource, "galleryImage");
@@clientName(GalleryImages.update::parameters.properties, "galleryImage");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GalleryImage.properties);

@@clientName(GalleryImageVersions.createOrUpdate::parameters.resource,
  "galleryImageVersion"
);
@@clientName(GalleryImageVersions.update::parameters.properties,
  "galleryImageVersion"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GalleryImageVersion.properties);

@@clientName(GalleryApplications.createOrUpdate::parameters.resource,
  "galleryApplication"
);
@@clientName(GalleryApplications.update::parameters.properties,
  "galleryApplication"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GalleryApplication.properties);

@@clientName(GalleryApplicationVersions.createOrUpdate::parameters.resource,
  "galleryApplicationVersion"
);
@@clientName(GalleryApplicationVersions.update::parameters.properties,
  "galleryApplicationVersion"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(GalleryApplicationVersion.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SharedGallery.identifier);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SharedGalleryImage.identifier);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SharedGalleryImage.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SharedGalleryImageVersion.identifier);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(SharedGalleryImageVersion.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CommunityGallery.identifier);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CommunityGalleryImage.identifier);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CommunityGalleryImage.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CommunityGalleryImageVersion.identifier);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CommunityGalleryImageVersion.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(RoleInstance.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CloudServiceRole.properties);

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
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(CloudService.properties);

@@clientLocation(OSVersions.getOSVersion, "CloudServiceOperatingSystems");
@@clientLocation(OSVersions.listOSVersions, "CloudServiceOperatingSystems");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(OSVersion.properties);

@@clientLocation(OSFamilies.getOSFamily, "CloudServiceOperatingSystems");
@@clientLocation(OSFamilies.listOSFamilies, "CloudServiceOperatingSystems");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(OSFamily.properties);

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
