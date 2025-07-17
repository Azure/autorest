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

@@clientLocation(VirtualMachineScaleSets.get, "VirtualMachineScaleSets");
@@clientLocation(VirtualMachineScaleSets.createOrUpdate,
  "VirtualMachineScaleSets"
);
@@clientName(VirtualMachineScaleSets.createOrUpdate, "CreateOrUpdate");
@@clientName(VirtualMachineScaleSets.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(VirtualMachineScaleSets.update, "VirtualMachineScaleSets");
@@clientName(VirtualMachineScaleSets.update::parameters.properties,
  "parameters"
);
@@clientLocation(VirtualMachineScaleSets.delete, "VirtualMachineScaleSets");
@@clientLocation(VirtualMachineScaleSets.list, "VirtualMachineScaleSets");
@@clientLocation(VirtualMachineScaleSets.listAll, "VirtualMachineScaleSets");
@@clientName(VirtualMachineScaleSets.listAll, "ListAll");
@@clientLocation(VirtualMachineScaleSets.deallocate, "VirtualMachineScaleSets");
@@clientName(VirtualMachineScaleSets.deallocate::parameters.body,
  "vmInstanceIDs"
);
@@clientLocation(VirtualMachineScaleSets.deleteInstances,
  "VirtualMachineScaleSets"
);
@@clientName(VirtualMachineScaleSets.deleteInstances, "DeleteInstances");
@@clientName(VirtualMachineScaleSets.deleteInstances::parameters.body,
  "vmInstanceIDs"
);
@@clientLocation(VirtualMachineScaleSets.getInstanceView,
  "VirtualMachineScaleSets"
);
@@clientName(VirtualMachineScaleSets.getInstanceView, "GetInstanceView");
@@clientLocation(VirtualMachineScaleSets.listSkus, "VirtualMachineScaleSets");
@@clientName(VirtualMachineScaleSets.listSkus, "ListSkus");
@@clientLocation(VirtualMachineScaleSets.getOSUpgradeHistory,
  "VirtualMachineScaleSets"
);
@@clientName(VirtualMachineScaleSets.getOSUpgradeHistory,
  "GetOSUpgradeHistory"
);
@@clientLocation(VirtualMachineScaleSets.powerOff, "VirtualMachineScaleSets");
@@clientName(VirtualMachineScaleSets.powerOff, "PowerOff");
@@clientName(VirtualMachineScaleSets.powerOff::parameters.body,
  "vmInstanceIDs"
);
@@clientLocation(VirtualMachineScaleSets.restart, "VirtualMachineScaleSets");
@@clientName(VirtualMachineScaleSets.restart::parameters.body, "vmInstanceIDs");
@@clientLocation(VirtualMachineScaleSets.start, "VirtualMachineScaleSets");
@@clientName(VirtualMachineScaleSets.start::parameters.body, "vmInstanceIDs");
@@clientLocation(VirtualMachineScaleSets.reapply, "VirtualMachineScaleSets");
@@clientLocation(VirtualMachineScaleSets.redeploy, "VirtualMachineScaleSets");
@@clientName(VirtualMachineScaleSets.redeploy::parameters.body,
  "vmInstanceIDs"
);
@@clientLocation(VirtualMachineScaleSets.performMaintenance,
  "VirtualMachineScaleSets"
);
@@clientName(VirtualMachineScaleSets.performMaintenance, "PerformMaintenance");
@@clientName(VirtualMachineScaleSets.performMaintenance::parameters.body,
  "vmInstanceIDs"
);
@@clientLocation(VirtualMachineScaleSets.updateInstances,
  "VirtualMachineScaleSets"
);
@@clientName(VirtualMachineScaleSets.updateInstances, "UpdateInstances");
@@clientName(VirtualMachineScaleSets.updateInstances::parameters.body,
  "vmInstanceIDs"
);
@@clientLocation(VirtualMachineScaleSets.reimage, "VirtualMachineScaleSets");
@@clientName(VirtualMachineScaleSets.reimage::parameters.body,
  "vmScaleSetReimageInput"
);
@@clientLocation(VirtualMachineScaleSets.reimageAll, "VirtualMachineScaleSets");
@@clientName(VirtualMachineScaleSets.reimageAll, "ReimageAll");
@@clientName(VirtualMachineScaleSets.reimageAll::parameters.body,
  "vmInstanceIDs"
);
@@clientLocation(VirtualMachineScaleSets.forceRecoveryServiceFabricPlatformUpdateDomainWalk,
  "VirtualMachineScaleSets"
);
@@clientName(VirtualMachineScaleSets.forceRecoveryServiceFabricPlatformUpdateDomainWalk,
  "ForceRecoveryServiceFabricPlatformUpdateDomainWalk"
);
@@clientLocation(VirtualMachineScaleSets.convertToSinglePlacementGroup,
  "VirtualMachineScaleSets"
);
@@clientName(VirtualMachineScaleSets.convertToSinglePlacementGroup,
  "ConvertToSinglePlacementGroup"
);
@@clientName(VirtualMachineScaleSets.convertToSinglePlacementGroup::parameters.body,
  "parameters"
);
@@clientLocation(VirtualMachineScaleSets.setOrchestrationServiceState,
  "VirtualMachineScaleSets"
);
@@clientName(VirtualMachineScaleSets.setOrchestrationServiceState,
  "SetOrchestrationServiceState"
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
@@clientName(VirtualMachineScaleSets.startOSUpgrade, "StartOSUpgrade");
@@clientLocation(VirtualMachineScaleSets.startExtensionUpgrade,
  "VirtualMachineScaleSetRollingUpgrades"
);
@@clientName(VirtualMachineScaleSets.startExtensionUpgrade,
  "StartExtensionUpgrade"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSet.properties);

@@clientLocation(VirtualMachineScaleSetExtensions.get,
  "VirtualMachineScaleSetExtensions"
);
@@clientLocation(VirtualMachineScaleSetExtensions.createOrUpdate,
  "VirtualMachineScaleSetExtensions"
);
@@clientName(VirtualMachineScaleSetExtensions.createOrUpdate, "CreateOrUpdate");
@@clientName(VirtualMachineScaleSetExtensions.createOrUpdate::parameters.resource,
  "extensionParameters"
);
@@clientLocation(VirtualMachineScaleSetExtensions.update,
  "VirtualMachineScaleSetExtensions"
);
@@clientName(VirtualMachineScaleSetExtensions.update::parameters.properties,
  "extensionParameters"
);
@@clientLocation(VirtualMachineScaleSetExtensions.delete,
  "VirtualMachineScaleSetExtensions"
);
@@clientLocation(VirtualMachineScaleSetExtensions.list,
  "VirtualMachineScaleSetExtensions"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetExtension.properties);

@@clientLocation(VirtualMachineExtensions.get, "VirtualMachineExtensions");
@@clientLocation(VirtualMachineExtensions.createOrUpdate,
  "VirtualMachineExtensions"
);
@@clientName(VirtualMachineExtensions.createOrUpdate, "CreateOrUpdate");
@@clientName(VirtualMachineExtensions.createOrUpdate::parameters.resource,
  "extensionParameters"
);
@@clientLocation(VirtualMachineExtensions.update, "VirtualMachineExtensions");
@@clientName(VirtualMachineExtensions.update::parameters.properties,
  "extensionParameters"
);
@@clientLocation(VirtualMachineExtensions.delete, "VirtualMachineExtensions");
@@clientLocation(VirtualMachineExtensions.list, "VirtualMachineExtensions");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineExtension.properties);

@@clientLocation(RollingUpgradeStatusInfos.getLatest,
  "VirtualMachineScaleSetRollingUpgrades"
);
@@clientName(RollingUpgradeStatusInfos.getLatest, "GetLatest");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RollingUpgradeStatusInfo.properties);

@@clientLocation(VirtualMachineScaleSetVMExtensions.get,
  "VirtualMachineScaleSetVMExtensions"
);
@@clientLocation(VirtualMachineScaleSetVMExtensions.createOrUpdate,
  "VirtualMachineScaleSetVMExtensions"
);
@@clientName(VirtualMachineScaleSetVMExtensions.createOrUpdate,
  "CreateOrUpdate"
);
@@clientName(VirtualMachineScaleSetVMExtensions.createOrUpdate::parameters.resource,
  "extensionParameters"
);
@@clientLocation(VirtualMachineScaleSetVMExtensions.update,
  "VirtualMachineScaleSetVMExtensions"
);
@@clientName(VirtualMachineScaleSetVMExtensions.update::parameters.properties,
  "extensionParameters"
);
@@clientLocation(VirtualMachineScaleSetVMExtensions.delete,
  "VirtualMachineScaleSetVMExtensions"
);
@@clientLocation(VirtualMachineScaleSetVMExtensions.list,
  "VirtualMachineScaleSetVMExtensions"
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
@@clientName(VirtualMachineScaleSetVMS.reimageAll, "ReimageAll");
@@clientLocation(VirtualMachineScaleSetVMS.deallocate,
  "VirtualMachineScaleSetVMs"
);
@@clientLocation(VirtualMachineScaleSetVMS.getInstanceView,
  "VirtualMachineScaleSetVMs"
);
@@clientName(VirtualMachineScaleSetVMS.getInstanceView, "GetInstanceView");
@@clientLocation(VirtualMachineScaleSetVMS.powerOff,
  "VirtualMachineScaleSetVMs"
);
@@clientName(VirtualMachineScaleSetVMS.powerOff, "PowerOff");
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
@@clientName(VirtualMachineScaleSetVMS.retrieveBootDiagnosticsData,
  "RetrieveBootDiagnosticsData"
);
@@clientLocation(VirtualMachineScaleSetVMS.performMaintenance,
  "VirtualMachineScaleSetVMs"
);
@@clientName(VirtualMachineScaleSetVMS.performMaintenance,
  "PerformMaintenance"
);
@@clientLocation(VirtualMachineScaleSetVMS.simulateEviction,
  "VirtualMachineScaleSetVMs"
);
@@clientName(VirtualMachineScaleSetVMS.simulateEviction, "SimulateEviction");
@@clientLocation(VirtualMachineScaleSetVMS.runCommand,
  "VirtualMachineScaleSetVMs"
);
@@clientName(VirtualMachineScaleSetVMS.runCommand, "RunCommand");
@@clientName(VirtualMachineScaleSetVMS.runCommand::parameters.body,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineScaleSetVM.properties);

@@clientLocation(VirtualMachines.get, "VirtualMachines");
@@clientLocation(VirtualMachines.createOrUpdate, "VirtualMachines");
@@clientName(VirtualMachines.createOrUpdate, "CreateOrUpdate");
@@clientName(VirtualMachines.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(VirtualMachines.update, "VirtualMachines");
@@clientName(VirtualMachines.update::parameters.properties, "parameters");
@@clientLocation(VirtualMachines.delete, "VirtualMachines");
@@clientLocation(VirtualMachines.list, "VirtualMachines");
@@clientLocation(VirtualMachines.listAll, "VirtualMachines");
@@clientName(VirtualMachines.listAll, "ListAll");
@@clientLocation(VirtualMachines.capture, "VirtualMachines");
@@clientName(VirtualMachines.capture::parameters.body, "parameters");
@@clientLocation(VirtualMachines.instanceView, "VirtualMachines");
@@clientName(VirtualMachines.instanceView, "InstanceView");
@@clientLocation(VirtualMachines.convertToManagedDisks, "VirtualMachines");
@@clientName(VirtualMachines.convertToManagedDisks, "ConvertToManagedDisks");
@@clientLocation(VirtualMachines.deallocate, "VirtualMachines");
@@clientLocation(VirtualMachines.generalize, "VirtualMachines");
@@clientLocation(VirtualMachines.listAvailableSizes, "VirtualMachines");
@@clientName(VirtualMachines.listAvailableSizes, "ListAvailableSizes");
@@clientLocation(VirtualMachines.powerOff, "VirtualMachines");
@@clientName(VirtualMachines.powerOff, "PowerOff");
@@clientLocation(VirtualMachines.reapply, "VirtualMachines");
@@clientLocation(VirtualMachines.restart, "VirtualMachines");
@@clientLocation(VirtualMachines.start, "VirtualMachines");
@@clientLocation(VirtualMachines.redeploy, "VirtualMachines");
@@clientLocation(VirtualMachines.reimage, "VirtualMachines");
@@clientName(VirtualMachines.reimage::parameters.body, "parameters");
@@clientLocation(VirtualMachines.retrieveBootDiagnosticsData,
  "VirtualMachines"
);
@@clientName(VirtualMachines.retrieveBootDiagnosticsData,
  "RetrieveBootDiagnosticsData"
);
@@clientLocation(VirtualMachines.performMaintenance, "VirtualMachines");
@@clientName(VirtualMachines.performMaintenance, "PerformMaintenance");
@@clientLocation(VirtualMachines.simulateEviction, "VirtualMachines");
@@clientName(VirtualMachines.simulateEviction, "SimulateEviction");
@@clientLocation(VirtualMachines.assessPatches, "VirtualMachines");
@@clientName(VirtualMachines.assessPatches, "AssessPatches");
@@clientLocation(VirtualMachines.installPatches, "VirtualMachines");
@@clientName(VirtualMachines.installPatches, "InstallPatches");
@@clientName(VirtualMachines.installPatches::parameters.body,
  "installPatchesInput"
);
@@clientLocation(VirtualMachines.runCommand, "VirtualMachines");
@@clientName(VirtualMachines.runCommand, "RunCommand");
@@clientName(VirtualMachines.runCommand::parameters.body, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachine.properties);

@@clientLocation(VirtualMachineExtensionImages.get,
  "VirtualMachineExtensionImages"
);
@@clientLocation(VirtualMachineExtensionImages.listTypes,
  "VirtualMachineExtensionImages"
);
@@clientName(VirtualMachineExtensionImages.listTypes, "ListTypes");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineExtensionImage.properties);

@@clientLocation(AvailabilitySets.get, "AvailabilitySets");
@@clientLocation(AvailabilitySets.createOrUpdate, "AvailabilitySets");
@@clientName(AvailabilitySets.createOrUpdate, "CreateOrUpdate");
@@clientName(AvailabilitySets.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(AvailabilitySets.update, "AvailabilitySets");
@@clientName(AvailabilitySets.update::parameters.properties, "parameters");
@@clientLocation(AvailabilitySets.delete, "AvailabilitySets");
@@clientLocation(AvailabilitySets.list, "AvailabilitySets");
@@clientLocation(AvailabilitySets.listBySubscription, "AvailabilitySets");
@@clientName(AvailabilitySets.listBySubscription, "ListBySubscription");
@@clientLocation(AvailabilitySets.listAvailableSizes, "AvailabilitySets");
@@clientName(AvailabilitySets.listAvailableSizes, "ListAvailableSizes");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AvailabilitySet.properties);

@@clientLocation(ProximityPlacementGroups.get, "ProximityPlacementGroups");
@@clientLocation(ProximityPlacementGroups.createOrUpdate,
  "ProximityPlacementGroups"
);
@@clientName(ProximityPlacementGroups.createOrUpdate, "CreateOrUpdate");
@@clientName(ProximityPlacementGroups.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(ProximityPlacementGroups.update, "ProximityPlacementGroups");
@@clientName(ProximityPlacementGroups.update::parameters.properties,
  "parameters"
);
@@clientLocation(ProximityPlacementGroups.delete, "ProximityPlacementGroups");
@@clientLocation(ProximityPlacementGroups.listByResourceGroup,
  "ProximityPlacementGroups"
);
@@clientName(ProximityPlacementGroups.listByResourceGroup,
  "ListByResourceGroup"
);
@@clientLocation(ProximityPlacementGroups.listBySubscription,
  "ProximityPlacementGroups"
);
@@clientName(ProximityPlacementGroups.listBySubscription, "ListBySubscription");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ProximityPlacementGroup.properties);

@@clientLocation(DedicatedHostGroups.get, "DedicatedHostGroups");
@@clientLocation(DedicatedHostGroups.createOrUpdate, "DedicatedHostGroups");
@@clientName(DedicatedHostGroups.createOrUpdate, "CreateOrUpdate");
@@clientName(DedicatedHostGroups.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(DedicatedHostGroups.update, "DedicatedHostGroups");
@@clientName(DedicatedHostGroups.update::parameters.properties, "parameters");
@@clientLocation(DedicatedHostGroups.delete, "DedicatedHostGroups");
@@clientLocation(DedicatedHostGroups.listByResourceGroup,
  "DedicatedHostGroups"
);
@@clientName(DedicatedHostGroups.listByResourceGroup, "ListByResourceGroup");
@@clientLocation(DedicatedHostGroups.listBySubscription, "DedicatedHostGroups");
@@clientName(DedicatedHostGroups.listBySubscription, "ListBySubscription");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DedicatedHostGroup.properties);

@@clientLocation(DedicatedHosts.get, "DedicatedHosts");
@@clientLocation(DedicatedHosts.createOrUpdate, "DedicatedHosts");
@@clientName(DedicatedHosts.createOrUpdate, "CreateOrUpdate");
@@clientName(DedicatedHosts.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(DedicatedHosts.update, "DedicatedHosts");
@@clientName(DedicatedHosts.update::parameters.properties, "parameters");
@@clientLocation(DedicatedHosts.delete, "DedicatedHosts");
@@clientLocation(DedicatedHosts.listByHostGroup, "DedicatedHosts");
@@clientName(DedicatedHosts.listByHostGroup, "ListByHostGroup");
@@clientLocation(DedicatedHosts.restart, "DedicatedHosts");
@@clientLocation(DedicatedHosts.listAvailableSizes, "DedicatedHosts");
@@clientName(DedicatedHosts.listAvailableSizes, "ListAvailableSizes");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DedicatedHost.properties);

@@clientLocation(SshPublicKeyResources.get, "SshPublicKeys");
@@clientLocation(SshPublicKeyResources.create, "SshPublicKeys");
@@clientName(SshPublicKeyResources.create::parameters.resource, "parameters");
@@clientLocation(SshPublicKeyResources.update, "SshPublicKeys");
@@clientName(SshPublicKeyResources.update::parameters.properties, "parameters");
@@clientLocation(SshPublicKeyResources.delete, "SshPublicKeys");
@@clientLocation(SshPublicKeyResources.listByResourceGroup, "SshPublicKeys");
@@clientName(SshPublicKeyResources.listByResourceGroup, "ListByResourceGroup");
@@clientLocation(SshPublicKeyResources.listBySubscription, "SshPublicKeys");
@@clientName(SshPublicKeyResources.listBySubscription, "ListBySubscription");
@@clientLocation(SshPublicKeyResources.generateKeyPair, "SshPublicKeys");
@@clientName(SshPublicKeyResources.generateKeyPair, "GenerateKeyPair");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SshPublicKeyResource.properties);

@@clientName(Images.createOrUpdate, "CreateOrUpdate");
@@clientName(Images.createOrUpdate::parameters.resource, "parameters");
@@clientName(Images.update::parameters.properties, "parameters");
@@clientName(Images.listByResourceGroup, "ListByResourceGroup");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Image.properties);

@@clientLocation(RestorePointCollections.get, "RestorePointCollections");
@@clientLocation(RestorePointCollections.createOrUpdate,
  "RestorePointCollections"
);
@@clientName(RestorePointCollections.createOrUpdate, "CreateOrUpdate");
@@clientName(RestorePointCollections.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(RestorePointCollections.update, "RestorePointCollections");
@@clientName(RestorePointCollections.update::parameters.properties,
  "parameters"
);
@@clientLocation(RestorePointCollections.delete, "RestorePointCollections");
@@clientLocation(RestorePointCollections.list, "RestorePointCollections");
@@clientLocation(RestorePointCollections.listAll, "RestorePointCollections");
@@clientName(RestorePointCollections.listAll, "ListAll");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RestorePointCollection.properties);

@@clientLocation(RestorePoints.get, "RestorePoints");
@@clientLocation(RestorePoints.create, "RestorePoints");
@@clientName(RestorePoints.create::parameters.resource, "parameters");
@@clientLocation(RestorePoints.delete, "RestorePoints");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RestorePoint.properties);

@@clientLocation(CapacityReservationGroups.get, "CapacityReservationGroups");
@@clientLocation(CapacityReservationGroups.createOrUpdate,
  "CapacityReservationGroups"
);
@@clientName(CapacityReservationGroups.createOrUpdate, "CreateOrUpdate");
@@clientName(CapacityReservationGroups.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(CapacityReservationGroups.update, "CapacityReservationGroups");
@@clientName(CapacityReservationGroups.update::parameters.properties,
  "parameters"
);
@@clientLocation(CapacityReservationGroups.delete, "CapacityReservationGroups");
@@clientLocation(CapacityReservationGroups.listByResourceGroup,
  "CapacityReservationGroups"
);
@@clientName(CapacityReservationGroups.listByResourceGroup,
  "ListByResourceGroup"
);
@@clientLocation(CapacityReservationGroups.listBySubscription,
  "CapacityReservationGroups"
);
@@clientName(CapacityReservationGroups.listBySubscription,
  "ListBySubscription"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CapacityReservationGroup.properties);

@@clientLocation(CapacityReservations.get, "CapacityReservations");
@@clientLocation(CapacityReservations.createOrUpdate, "CapacityReservations");
@@clientName(CapacityReservations.createOrUpdate, "CreateOrUpdate");
@@clientName(CapacityReservations.createOrUpdate::parameters.resource,
  "parameters"
);
@@clientLocation(CapacityReservations.update, "CapacityReservations");
@@clientName(CapacityReservations.update::parameters.properties, "parameters");
@@clientLocation(CapacityReservations.delete, "CapacityReservations");
@@clientLocation(CapacityReservations.listByCapacityReservationGroup,
  "CapacityReservations"
);
@@clientName(CapacityReservations.listByCapacityReservationGroup,
  "ListByCapacityReservationGroup"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CapacityReservation.properties);

@@clientLocation(VirtualMachineRunCommands.getByVirtualMachine,
  "VirtualMachineRunCommands"
);
@@clientName(VirtualMachineRunCommands.getByVirtualMachine,
  "GetByVirtualMachine"
);
@@clientLocation(VirtualMachineRunCommands.createOrUpdate,
  "VirtualMachineRunCommands"
);
@@clientName(VirtualMachineRunCommands.createOrUpdate, "CreateOrUpdate");
@@clientName(VirtualMachineRunCommands.createOrUpdate::parameters.resource,
  "runCommand"
);
@@clientLocation(VirtualMachineRunCommands.update, "VirtualMachineRunCommands");
@@clientName(VirtualMachineRunCommands.update::parameters.properties,
  "runCommand"
);
@@clientLocation(VirtualMachineRunCommands.delete, "VirtualMachineRunCommands");
@@clientLocation(VirtualMachineRunCommands.listByVirtualMachine,
  "VirtualMachineRunCommands"
);
@@clientName(VirtualMachineRunCommands.listByVirtualMachine,
  "ListByVirtualMachine"
);
@@clientLocation(VirtualMachineScaleSetVMRunCommands.get,
  "VirtualMachineScaleSetVMRunCommands"
);
@@clientLocation(VirtualMachineScaleSetVMRunCommands.createOrUpdate,
  "VirtualMachineScaleSetVMRunCommands"
);
@@clientName(VirtualMachineScaleSetVMRunCommands.createOrUpdate,
  "CreateOrUpdate"
);
@@clientName(VirtualMachineScaleSetVMRunCommands.createOrUpdate::parameters.resource,
  "runCommand"
);
@@clientLocation(VirtualMachineScaleSetVMRunCommands.update,
  "VirtualMachineScaleSetVMRunCommands"
);
@@clientName(VirtualMachineScaleSetVMRunCommands.update::parameters.properties,
  "runCommand"
);
@@clientLocation(VirtualMachineScaleSetVMRunCommands.delete,
  "VirtualMachineScaleSetVMRunCommands"
);
@@clientLocation(VirtualMachineScaleSetVMRunCommands.list,
  "VirtualMachineScaleSetVMRunCommands"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(VirtualMachineRunCommand.properties);

@@clientName(Disks.createOrUpdate, "CreateOrUpdate");
@@clientName(Disks.createOrUpdate::parameters.resource, "disk");
@@clientName(Disks.update::parameters.properties, "disk");
@@clientName(Disks.listByResourceGroup, "ListByResourceGroup");
@@clientName(Disks.grantAccess, "GrantAccess");
@@clientName(Disks.grantAccess::parameters.body, "grantAccessData");
@@clientName(Disks.revokeAccess, "RevokeAccess");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Disk.properties);

@@clientLocation(DiskAccesses.get, "DiskAccesses");
@@clientLocation(DiskAccesses.createOrUpdate, "DiskAccesses");
@@clientName(DiskAccesses.createOrUpdate, "CreateOrUpdate");
@@clientName(DiskAccesses.createOrUpdate::parameters.resource, "diskAccess");
@@clientLocation(DiskAccesses.update, "DiskAccesses");
@@clientName(DiskAccesses.update::parameters.properties, "diskAccess");
@@clientLocation(DiskAccesses.delete, "DiskAccesses");
@@clientLocation(DiskAccesses.listByResourceGroup, "DiskAccesses");
@@clientName(DiskAccesses.listByResourceGroup, "ListByResourceGroup");
@@clientLocation(DiskAccesses.list, "DiskAccesses");
@@clientLocation(DiskAccesses.getPrivateLinkResources, "DiskAccesses");
@@clientName(DiskAccesses.getPrivateLinkResources, "GetPrivateLinkResources");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskAccess.properties);

@@clientLocation(PrivateEndpointConnections.getAPrivateEndpointConnection,
  "DiskAccesses"
);
@@clientName(PrivateEndpointConnections.getAPrivateEndpointConnection,
  "GetAPrivateEndpointConnection"
);
@@clientLocation(PrivateEndpointConnections.updateAPrivateEndpointConnection,
  "DiskAccesses"
);
@@clientName(PrivateEndpointConnections.updateAPrivateEndpointConnection,
  "UpdateAPrivateEndpointConnection"
);
@@clientName(PrivateEndpointConnections.updateAPrivateEndpointConnection::parameters.resource,
  "privateEndpointConnection"
);
@@clientLocation(PrivateEndpointConnections.deleteAPrivateEndpointConnection,
  "DiskAccesses"
);
@@clientName(PrivateEndpointConnections.deleteAPrivateEndpointConnection,
  "DeleteAPrivateEndpointConnection"
);
@@clientLocation(PrivateEndpointConnections.listPrivateEndpointConnections,
  "DiskAccesses"
);
@@clientName(PrivateEndpointConnections.listPrivateEndpointConnections,
  "ListPrivateEndpointConnections"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

@@clientLocation(DiskEncryptionSets.get, "DiskEncryptionSets");
@@clientLocation(DiskEncryptionSets.createOrUpdate, "DiskEncryptionSets");
@@clientName(DiskEncryptionSets.createOrUpdate, "CreateOrUpdate");
@@clientName(DiskEncryptionSets.createOrUpdate::parameters.resource,
  "diskEncryptionSet"
);
@@clientLocation(DiskEncryptionSets.update, "DiskEncryptionSets");
@@clientName(DiskEncryptionSets.update::parameters.properties,
  "diskEncryptionSet"
);
@@clientLocation(DiskEncryptionSets.delete, "DiskEncryptionSets");
@@clientLocation(DiskEncryptionSets.listByResourceGroup, "DiskEncryptionSets");
@@clientName(DiskEncryptionSets.listByResourceGroup, "ListByResourceGroup");
@@clientLocation(DiskEncryptionSets.list, "DiskEncryptionSets");
@@clientLocation(DiskEncryptionSets.listAssociatedResources,
  "DiskEncryptionSets"
);
@@clientName(DiskEncryptionSets.listAssociatedResources,
  "ListAssociatedResources"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskEncryptionSet.properties);

@@clientLocation(DiskRestorePoints.get, "DiskRestorePoint");
@@clientLocation(DiskRestorePoints.listByRestorePoint, "DiskRestorePoint");
@@clientName(DiskRestorePoints.listByRestorePoint, "ListByRestorePoint");
@@clientLocation(DiskRestorePoints.grantAccess, "DiskRestorePoint");
@@clientName(DiskRestorePoints.grantAccess, "GrantAccess");
@@clientName(DiskRestorePoints.grantAccess::parameters.body, "grantAccessData");
@@clientLocation(DiskRestorePoints.revokeAccess, "DiskRestorePoint");
@@clientName(DiskRestorePoints.revokeAccess, "RevokeAccess");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DiskRestorePoint.properties);

@@clientName(Snapshots.createOrUpdate, "CreateOrUpdate");
@@clientName(Snapshots.createOrUpdate::parameters.resource, "snapshot");
@@clientName(Snapshots.update::parameters.properties, "snapshot");
@@clientName(Snapshots.listByResourceGroup, "ListByResourceGroup");
@@clientName(Snapshots.grantAccess, "GrantAccess");
@@clientName(Snapshots.grantAccess::parameters.body, "grantAccessData");
@@clientName(Snapshots.revokeAccess, "RevokeAccess");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Snapshot.properties);

@@clientName(Galleries.createOrUpdate, "CreateOrUpdate");
@@clientName(Galleries.createOrUpdate::parameters.resource, "gallery");
@@clientName(Galleries.update::parameters.properties, "gallery");
@@clientName(Galleries.listByResourceGroup, "ListByResourceGroup");
@@clientLocation(Galleries.gallerySharingProfileUpdate,
  "GallerySharingProfile"
);
@@clientName(Galleries.gallerySharingProfileUpdate, "Update");
@@clientName(Galleries.gallerySharingProfileUpdate::parameters.body,
  "sharingUpdate"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Gallery.properties);

@@clientLocation(GalleryImages.get, "GalleryImages");
@@clientLocation(GalleryImages.createOrUpdate, "GalleryImages");
@@clientName(GalleryImages.createOrUpdate, "CreateOrUpdate");
@@clientName(GalleryImages.createOrUpdate::parameters.resource, "galleryImage");
@@clientLocation(GalleryImages.update, "GalleryImages");
@@clientName(GalleryImages.update::parameters.properties, "galleryImage");
@@clientLocation(GalleryImages.delete, "GalleryImages");
@@clientLocation(GalleryImages.listByGallery, "GalleryImages");
@@clientName(GalleryImages.listByGallery, "ListByGallery");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryImage.properties);

@@clientLocation(GalleryImageVersions.get, "GalleryImageVersions");
@@clientLocation(GalleryImageVersions.createOrUpdate, "GalleryImageVersions");
@@clientName(GalleryImageVersions.createOrUpdate, "CreateOrUpdate");
@@clientName(GalleryImageVersions.createOrUpdate::parameters.resource,
  "galleryImageVersion"
);
@@clientLocation(GalleryImageVersions.update, "GalleryImageVersions");
@@clientName(GalleryImageVersions.update::parameters.properties,
  "galleryImageVersion"
);
@@clientLocation(GalleryImageVersions.delete, "GalleryImageVersions");
@@clientLocation(GalleryImageVersions.listByGalleryImage,
  "GalleryImageVersions"
);
@@clientName(GalleryImageVersions.listByGalleryImage, "ListByGalleryImage");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryImageVersion.properties);

@@clientLocation(GalleryApplications.get, "GalleryApplications");
@@clientLocation(GalleryApplications.createOrUpdate, "GalleryApplications");
@@clientName(GalleryApplications.createOrUpdate, "CreateOrUpdate");
@@clientName(GalleryApplications.createOrUpdate::parameters.resource,
  "galleryApplication"
);
@@clientLocation(GalleryApplications.update, "GalleryApplications");
@@clientName(GalleryApplications.update::parameters.properties,
  "galleryApplication"
);
@@clientLocation(GalleryApplications.delete, "GalleryApplications");
@@clientLocation(GalleryApplications.listByGallery, "GalleryApplications");
@@clientName(GalleryApplications.listByGallery, "ListByGallery");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryApplication.properties);

@@clientLocation(GalleryApplicationVersions.get, "GalleryApplicationVersions");
@@clientLocation(GalleryApplicationVersions.createOrUpdate,
  "GalleryApplicationVersions"
);
@@clientName(GalleryApplicationVersions.createOrUpdate, "CreateOrUpdate");
@@clientName(GalleryApplicationVersions.createOrUpdate::parameters.resource,
  "galleryApplicationVersion"
);
@@clientLocation(GalleryApplicationVersions.update,
  "GalleryApplicationVersions"
);
@@clientName(GalleryApplicationVersions.update::parameters.properties,
  "galleryApplicationVersion"
);
@@clientLocation(GalleryApplicationVersions.delete,
  "GalleryApplicationVersions"
);
@@clientLocation(GalleryApplicationVersions.listByGalleryApplication,
  "GalleryApplicationVersions"
);
@@clientName(GalleryApplicationVersions.listByGalleryApplication,
  "ListByGalleryApplication"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(GalleryApplicationVersion.properties);

@@clientLocation(SharedGalleries.get, "SharedGalleries");
@@clientLocation(SharedGalleries.list, "SharedGalleries");

@@clientLocation(SharedGalleryImages.get, "SharedGalleryImages");
@@clientLocation(SharedGalleryImages.list, "SharedGalleryImages");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SharedGalleryImage.properties);

@@clientLocation(SharedGalleryImageVersions.get, "SharedGalleryImageVersions");
@@clientLocation(SharedGalleryImageVersions.list, "SharedGalleryImageVersions");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(SharedGalleryImageVersion.properties);

@@clientLocation(CommunityGalleries.get, "CommunityGalleries");

@@clientLocation(CommunityGalleryImages.get, "CommunityGalleryImages");
@@clientLocation(CommunityGalleryImages.list, "CommunityGalleryImages");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CommunityGalleryImage.properties);

@@clientLocation(CommunityGalleryImageVersions.get,
  "CommunityGalleryImageVersions"
);
@@clientLocation(CommunityGalleryImageVersions.list,
  "CommunityGalleryImageVersions"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CommunityGalleryImageVersion.properties);

@@clientLocation(CloudServiceRoleInstances.get, "CloudServiceRoleInstances");
@@clientLocation(CloudServiceRoleInstances.delete, "CloudServiceRoleInstances");
@@clientLocation(CloudServiceRoleInstances.list, "CloudServiceRoleInstances");
@@clientLocation(CloudServiceRoleInstances.getInstanceView,
  "CloudServiceRoleInstances"
);
@@clientName(CloudServiceRoleInstances.getInstanceView, "GetInstanceView");
@@clientLocation(CloudServiceRoleInstances.restart,
  "CloudServiceRoleInstances"
);
@@clientLocation(CloudServiceRoleInstances.reimage,
  "CloudServiceRoleInstances"
);
@@clientLocation(CloudServiceRoleInstances.rebuild,
  "CloudServiceRoleInstances"
);
@@clientLocation(CloudServiceRoleInstances.getRemoteDesktopFile,
  "CloudServiceRoleInstances"
);
@@clientName(CloudServiceRoleInstances.getRemoteDesktopFile,
  "GetRemoteDesktopFile"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleInstance.properties);

@@clientLocation(CloudServiceRoles.get, "CloudServiceRoles");
@@clientLocation(CloudServiceRoles.list, "CloudServiceRoles");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CloudServiceRole.properties);

@@clientLocation(CloudServices.get, "CloudServices");
@@clientLocation(CloudServices.createOrUpdate, "CloudServices");
@@clientName(CloudServices.createOrUpdate, "CreateOrUpdate");
@@clientName(CloudServices.createOrUpdate::parameters.resource, "parameters");
@@clientLocation(CloudServices.update, "CloudServices");
@@clientName(CloudServices.update::parameters.properties, "parameters");
@@clientLocation(CloudServices.delete, "CloudServices");
@@clientLocation(CloudServices.list, "CloudServices");
@@clientLocation(CloudServices.listAll, "CloudServices");
@@clientName(CloudServices.listAll, "ListAll");
@@clientLocation(CloudServices.getInstanceView, "CloudServices");
@@clientName(CloudServices.getInstanceView, "GetInstanceView");
@@clientLocation(CloudServices.start, "CloudServices");
@@clientLocation(CloudServices.powerOff, "CloudServices");
@@clientName(CloudServices.powerOff, "PowerOff");
@@clientLocation(CloudServices.restart, "CloudServices");
@@clientName(CloudServices.restart::parameters.body, "parameters");
@@clientLocation(CloudServices.reimage, "CloudServices");
@@clientName(CloudServices.reimage::parameters.body, "parameters");
@@clientLocation(CloudServices.rebuild, "CloudServices");
@@clientName(CloudServices.rebuild::parameters.body, "parameters");
@@clientLocation(CloudServices.deleteInstances, "CloudServices");
@@clientName(CloudServices.deleteInstances, "DeleteInstances");
@@clientName(CloudServices.deleteInstances::parameters.body, "parameters");
@@clientLocation(CloudServices.walkUpdateDomain, "CloudServicesUpdateDomain");
@@clientName(CloudServices.walkUpdateDomain, "WalkUpdateDomain");
@@clientName(CloudServices.walkUpdateDomain::parameters.body, "parameters");
@@clientLocation(CloudServices.getUpdateDomain, "CloudServicesUpdateDomain");
@@clientName(CloudServices.getUpdateDomain, "GetUpdateDomain");
@@clientLocation(CloudServices.listUpdateDomains, "CloudServicesUpdateDomain");
@@clientName(CloudServices.listUpdateDomains, "ListUpdateDomains");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(CloudService.properties);

@@clientLocation(OSVersions.getOSVersion, "CloudServiceOperatingSystems");
@@clientName(OSVersions.getOSVersion, "GetOSVersion");
@@clientLocation(OSVersions.listOSVersions, "CloudServiceOperatingSystems");
@@clientName(OSVersions.listOSVersions, "ListOSVersions");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OSVersion.properties);

@@clientLocation(OSFamilies.getOSFamily, "CloudServiceOperatingSystems");
@@clientName(OSFamilies.getOSFamily, "GetOSFamily");
@@clientLocation(OSFamilies.listOSFamilies, "CloudServiceOperatingSystems");
@@clientName(OSFamilies.listOSFamilies, "ListOSFamilies");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(OSFamily.properties);

@@clientLocation(UsageOperationGroup.list, "Usage");

@@clientLocation(VirtualMachineSizesOperationGroup.list, "VirtualMachineSizes");

@@clientLocation(VirtualMachineScaleSetsOperationGroup.listByLocation,
  "VirtualMachineScaleSets"
);
@@clientName(VirtualMachineScaleSetsOperationGroup.listByLocation,
  "ListByLocation"
);

@@clientLocation(VirtualMachinesOperationGroup.listByLocation,
  "VirtualMachines"
);
@@clientName(VirtualMachinesOperationGroup.listByLocation, "ListByLocation");

@@clientLocation(VirtualMachineImagesOperationGroup.get,
  "VirtualMachineImages"
);
@@clientLocation(VirtualMachineImagesOperationGroup.list,
  "VirtualMachineImages"
);
@@clientLocation(VirtualMachineImagesOperationGroup.listOffers,
  "VirtualMachineImages"
);
@@clientName(VirtualMachineImagesOperationGroup.listOffers, "ListOffers");
@@clientLocation(VirtualMachineImagesOperationGroup.listPublishers,
  "VirtualMachineImages"
);
@@clientName(VirtualMachineImagesOperationGroup.listPublishers,
  "ListPublishers"
);
@@clientLocation(VirtualMachineImagesOperationGroup.listSkus,
  "VirtualMachineImages"
);
@@clientName(VirtualMachineImagesOperationGroup.listSkus, "ListSkus");
@@clientLocation(VirtualMachineImagesOperationGroup.listByEdgeZone,
  "VirtualMachineImages"
);
@@clientName(VirtualMachineImagesOperationGroup.listByEdgeZone,
  "ListByEdgeZone"
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
@@clientName(VirtualMachineImagesEdgeZoneOperationGroup.listOffers,
  "ListOffers"
);
@@clientLocation(VirtualMachineImagesEdgeZoneOperationGroup.listPublishers,
  "VirtualMachineImagesEdgeZone"
);
@@clientName(VirtualMachineImagesEdgeZoneOperationGroup.listPublishers,
  "ListPublishers"
);
@@clientLocation(VirtualMachineImagesEdgeZoneOperationGroup.listSkus,
  "VirtualMachineImagesEdgeZone"
);
@@clientName(VirtualMachineImagesEdgeZoneOperationGroup.listSkus, "ListSkus");

@@clientLocation(LogAnalyticsOperationGroup.exportRequestRateByInterval,
  "LogAnalytics"
);
@@clientName(LogAnalyticsOperationGroup.exportRequestRateByInterval,
  "ExportRequestRateByInterval"
);
@@clientLocation(LogAnalyticsOperationGroup.exportThrottledRequests,
  "LogAnalytics"
);
@@clientName(LogAnalyticsOperationGroup.exportThrottledRequests,
  "ExportThrottledRequests"
);

@@clientLocation(VirtualMachineRunCommandsOperationGroup.list,
  "VirtualMachineRunCommands"
);
@@clientLocation(VirtualMachineRunCommandsOperationGroup.get,
  "VirtualMachineRunCommands"
);

@@clientLocation(ResourceSkusOperationGroup.list, "ResourceSkus");
