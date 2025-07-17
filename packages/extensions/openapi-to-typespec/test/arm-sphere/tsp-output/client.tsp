import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.AzureSphere;

@@clientName(Catalogs.createOrUpdate, "CreateOrUpdate");
@@clientName(Catalogs.listByResourceGroup, "ListByResourceGroup");
@@clientName(Catalogs.listBySubscription, "ListBySubscription");
@@clientName(Catalogs.countDevices, "CountDevices");
@@clientName(Catalogs.listDeployments, "ListDeployments");
@@clientName(Catalogs.listDeviceGroups, "ListDeviceGroups");
@@clientName(Catalogs.listDeviceInsights, "ListDeviceInsights");
@@clientName(Catalogs.listDevices, "ListDevices");

@@clientName(Certificates.listByCatalog, "ListByCatalog");
@@clientName(Certificates.retrieveCertChain, "RetrieveCertChain");
@@clientName(Certificates.retrieveProofOfPossessionNonce,
  "RetrieveProofOfPossessionNonce"
);

@@clientName(Images.createOrUpdate, "CreateOrUpdate");
@@clientName(Images.listByCatalog, "ListByCatalog");

@@clientName(Deployments.createOrUpdate, "CreateOrUpdate");
@@clientName(Deployments.listByDeviceGroup, "ListByDeviceGroup");

@@clientLocation(DeviceGroups.get, "DeviceGroups");
@@clientLocation(DeviceGroups.createOrUpdate, "DeviceGroups");
@@clientName(DeviceGroups.createOrUpdate, "CreateOrUpdate");
@@clientLocation(DeviceGroups.update, "DeviceGroups");
@@clientLocation(DeviceGroups.delete, "DeviceGroups");
@@clientLocation(DeviceGroups.listByProduct, "DeviceGroups");
@@clientName(DeviceGroups.listByProduct, "ListByProduct");
@@clientLocation(DeviceGroups.claimDevices, "DeviceGroups");
@@clientName(DeviceGroups.claimDevices, "ClaimDevices");
@@clientLocation(DeviceGroups.countDevices, "DeviceGroups");
@@clientName(DeviceGroups.countDevices, "CountDevices");

@@clientName(Devices.createOrUpdate, "CreateOrUpdate");
@@clientName(Devices.listByDeviceGroup, "ListByDeviceGroup");
@@clientName(Devices.generateCapabilityImage, "GenerateCapabilityImage");

@@clientName(Products.createOrUpdate, "CreateOrUpdate");
@@clientName(Products.listByCatalog, "ListByCatalog");
@@clientName(Products.countDevices, "CountDevices");
@@clientName(Products.generateDefaultDeviceGroups,
  "GenerateDefaultDeviceGroups"
);
