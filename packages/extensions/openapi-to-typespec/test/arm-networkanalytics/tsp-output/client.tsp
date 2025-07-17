import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.NetworkAnalytics;

@@clientLocation(DataProducts.get, "DataProducts");
@@clientLocation(DataProducts.create, "DataProducts");
@@clientLocation(DataProducts.update, "DataProducts");
@@clientLocation(DataProducts.delete, "DataProducts");
@@clientLocation(DataProducts.listByResourceGroup, "DataProducts");
@@clientName(DataProducts.listByResourceGroup, "ListByResourceGroup");
@@clientLocation(DataProducts.listBySubscription, "DataProducts");
@@clientName(DataProducts.listBySubscription, "ListBySubscription");
@@clientLocation(DataProducts.addUserRole, "DataProducts");
@@clientName(DataProducts.addUserRole, "AddUserRole");
@@clientLocation(DataProducts.generateStorageAccountSasToken, "DataProducts");
@@clientName(DataProducts.generateStorageAccountSasToken,
  "GenerateStorageAccountSasToken"
);
@@clientLocation(DataProducts.listRolesAssignments, "DataProducts");
@@clientName(DataProducts.listRolesAssignments, "ListRolesAssignments");
@@clientLocation(DataProducts.removeUserRole, "DataProducts");
@@clientName(DataProducts.removeUserRole, "RemoveUserRole");
@@clientLocation(DataProducts.rotateKey, "DataProducts");
@@clientName(DataProducts.rotateKey, "RotateKey");

@@clientLocation(DataProductsCatalogs.get, "DataProductsCatalogs");
@@clientLocation(DataProductsCatalogs.listByResourceGroup,
  "DataProductsCatalogs"
);
@@clientName(DataProductsCatalogs.listByResourceGroup, "ListByResourceGroup");
@@clientLocation(DataProductsCatalogs.listBySubscription,
  "DataProductsCatalogs"
);
@@clientName(DataProductsCatalogs.listBySubscription, "ListBySubscription");

@@clientLocation(DataTypes.get, "DataTypes");
@@clientLocation(DataTypes.create, "DataTypes");
@@clientLocation(DataTypes.update, "DataTypes");
@@clientLocation(DataTypes.delete, "DataTypes");
@@clientLocation(DataTypes.listByDataProduct, "DataTypes");
@@clientName(DataTypes.listByDataProduct, "ListByDataProduct");
@@clientLocation(DataTypes.deleteData, "DataTypes");
@@clientName(DataTypes.deleteData, "DeleteData");
@@clientLocation(DataTypes.generateStorageContainerSasToken, "DataTypes");
@@clientName(DataTypes.generateStorageContainerSasToken,
  "GenerateStorageContainerSasToken"
);
