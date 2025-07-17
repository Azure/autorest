import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Storage;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Operation.properties);
@@clientName(Operation.properties, "operationProperties");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(StorageAccountCreateParameters.properties);

@@clientName(StorageAccountPropertiesCreateParameters.networkAcls,
  "networkRuleSet"
);
@@clientName(StorageAccountPropertiesCreateParameters.supportsHttpsTrafficOnly,
  "enableHttpsTrafficOnly"
);
@@clientName(StorageAccountPropertiesCreateParameters.isSftpEnabled,
  "IsSftpEnabled"
);
@@clientName(StorageAccountPropertiesCreateParameters.isLocalUserEnabled,
  "IsLocalUserEnabled"
);
@@clientName(StorageAccountPropertiesCreateParameters.isHnsEnabled,
  "IsHnsEnabled"
);
@@clientName(StorageAccountPropertiesCreateParameters.isNfsV3Enabled,
  "enableNfsV3"
);

@@clientName(Encryption.keyvaultproperties, "keyVaultProperties");
@@clientName(Encryption.identity, "encryptionIdentity");

@@clientName(KeyVaultProperties.keyname, "keyName");
@@clientName(KeyVaultProperties.keyversion, "keyVersion");
@@clientName(KeyVaultProperties.keyvaulturi, "keyVaultUri");

@@clientName(EncryptionIdentity.userAssignedIdentity,
  "encryptionUserAssignedIdentity"
);
@@clientName(EncryptionIdentity.federatedIdentityClientId,
  "encryptionFederatedIdentityClientId"
);

@@clientName(VirtualNetworkRule.id, "virtualNetworkResourceId");

@@clientName(IPRule.value, "IPAddressOrRange");

@@clientName(StorageAccountProperties.supportsHttpsTrafficOnly,
  "enableHttpsTrafficOnly"
);
@@clientName(StorageAccountProperties.networkAcls, "networkRuleSet");
@@clientName(StorageAccountProperties.isSftpEnabled, "IsSftpEnabled");
@@clientName(StorageAccountProperties.isLocalUserEnabled, "IsLocalUserEnabled");
@@clientName(StorageAccountProperties.isHnsEnabled, "IsHnsEnabled");
@@clientName(StorageAccountProperties.isNfsV3Enabled, "enableNfsV3");

@@clientName(BlobRestoreParameters.timetoRestore, "timeToRestore");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(StorageAccountUpdateParameters.properties);

@@clientName(StorageAccountPropertiesUpdateParameters.supportsHttpsTrafficOnly,
  "enableHttpsTrafficOnly"
);
@@clientName(StorageAccountPropertiesUpdateParameters.isSftpEnabled,
  "IsSftpEnabled"
);
@@clientName(StorageAccountPropertiesUpdateParameters.isLocalUserEnabled,
  "IsLocalUserEnabled"
);
@@clientName(StorageAccountPropertiesUpdateParameters.networkAcls,
  "networkRuleSet"
);

@@clientName(AccountSasParameters.signedServices, "services");
@@clientName(AccountSasParameters.signedResourceTypes, "resourceTypes");
@@clientName(AccountSasParameters.signedPermission, "permissions");
@@clientName(AccountSasParameters.signedIp, "IPAddressOrRange");
@@clientName(AccountSasParameters.signedProtocol, "protocols");
@@clientName(AccountSasParameters.signedStart, "sharedAccessStartTime");
@@clientName(AccountSasParameters.signedExpiry, "sharedAccessExpiryTime");

@@clientName(ServiceSasParameters.signedResource, "resource");
@@clientName(ServiceSasParameters.signedPermission, "permissions");
@@clientName(ServiceSasParameters.signedIp, "IPAddressOrRange");
@@clientName(ServiceSasParameters.signedProtocol, "protocols");
@@clientName(ServiceSasParameters.signedStart, "sharedAccessStartTime");
@@clientName(ServiceSasParameters.signedExpiry, "sharedAccessExpiryTime");
@@clientName(ServiceSasParameters.signedIdentifier, "identifier");
@@clientName(ServiceSasParameters.startPk, "partitionKeyStart");
@@clientName(ServiceSasParameters.endPk, "partitionKeyEnd");
@@clientName(ServiceSasParameters.startRk, "rowKeyStart");
@@clientName(ServiceSasParameters.endRk, "rowKeyEnd");
@@clientName(ServiceSasParameters.rscc, "cacheControl");
@@clientName(ServiceSasParameters.rscd, "contentDisposition");
@@clientName(ServiceSasParameters.rsce, "contentEncoding");
@@clientName(ServiceSasParameters.rscl, "contentLanguage");
@@clientName(ServiceSasParameters.rsct, "contentType");

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateLinkResource.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ImmutabilityPolicyProperties.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ListContainerItem.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(FileShareItem.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ListQueue.properties);
@@clientName(ListQueue.properties, "queueProperties");

@@clientLocation(StorageAccounts.getProperties, "StorageAccounts");
@@clientName(StorageAccounts.getProperties, "GetProperties");
@@clientLocation(StorageAccounts.create, "StorageAccounts");
@@clientName(StorageAccounts.create::parameters.resource, "parameters");
@@clientLocation(StorageAccounts.update, "StorageAccounts");
@@clientName(StorageAccounts.update::parameters.properties, "parameters");
@@clientLocation(StorageAccounts.delete, "StorageAccounts");
@@clientLocation(StorageAccounts.listByResourceGroup, "StorageAccounts");
@@clientName(StorageAccounts.listByResourceGroup, "ListByResourceGroup");
@@clientLocation(StorageAccounts.list, "StorageAccounts");
@@clientLocation(StorageAccounts.listKeys, "StorageAccounts");
@@clientName(StorageAccounts.listKeys, "ListKeys");
@@clientLocation(StorageAccounts.regenerateKey, "StorageAccounts");
@@clientName(StorageAccounts.regenerateKey, "RegenerateKey");
@@clientName(StorageAccounts.regenerateKey::parameters.body, "regenerateKey");
@@clientLocation(StorageAccounts.listAccountSAS, "StorageAccounts");
@@clientName(StorageAccounts.listAccountSAS, "ListAccountSAS");
@@clientName(StorageAccounts.listAccountSAS::parameters.body, "parameters");
@@clientLocation(StorageAccounts.listServiceSAS, "StorageAccounts");
@@clientName(StorageAccounts.listServiceSAS, "ListServiceSAS");
@@clientName(StorageAccounts.listServiceSAS::parameters.body, "parameters");
@@clientLocation(StorageAccounts.failover, "StorageAccounts");
@@clientLocation(StorageAccounts.hierarchicalNamespaceMigration,
  "StorageAccounts"
);
@@clientName(StorageAccounts.hierarchicalNamespaceMigration,
  "HierarchicalNamespaceMigration"
);
@@clientLocation(StorageAccounts.abortHierarchicalNamespaceMigration,
  "StorageAccounts"
);
@@clientName(StorageAccounts.abortHierarchicalNamespaceMigration,
  "AbortHierarchicalNamespaceMigration"
);
@@clientLocation(StorageAccounts.restoreBlobRanges, "StorageAccounts");
@@clientName(StorageAccounts.restoreBlobRanges, "RestoreBlobRanges");
@@clientName(StorageAccounts.restoreBlobRanges::parameters.body, "parameters");
@@clientLocation(StorageAccounts.revokeUserDelegationKeys, "StorageAccounts");
@@clientName(StorageAccounts.revokeUserDelegationKeys,
  "RevokeUserDelegationKeys"
);
@@clientLocation(StorageAccounts.listByStorageAccount, "PrivateLinkResources");
@@clientName(StorageAccounts.listByStorageAccount, "ListByStorageAccount");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(StorageAccount.properties);

@@clientLocation(PrivateEndpointConnections.get, "PrivateEndpointConnections");
@@clientLocation(PrivateEndpointConnections.put, "PrivateEndpointConnections");
@@clientName(PrivateEndpointConnections.put::parameters.resource, "properties");
@@clientLocation(PrivateEndpointConnections.delete,
  "PrivateEndpointConnections"
);
@@clientLocation(PrivateEndpointConnections.list, "PrivateEndpointConnections");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

@@clientLocation(DeletedAccounts.get, "DeletedAccounts");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DeletedAccount.properties);

@@clientLocation(ManagementPolicies.get, "ManagementPolicies");
@@clientLocation(ManagementPolicies.createOrUpdate, "ManagementPolicies");
@@clientName(ManagementPolicies.createOrUpdate, "CreateOrUpdate");
@@clientName(ManagementPolicies.createOrUpdate::parameters.resource,
  "properties"
);
@@clientLocation(ManagementPolicies.delete, "ManagementPolicies");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ManagementPolicy.properties);

@@clientLocation(BlobInventoryPolicies.get, "BlobInventoryPolicies");
@@clientLocation(BlobInventoryPolicies.createOrUpdate, "BlobInventoryPolicies");
@@clientName(BlobInventoryPolicies.createOrUpdate, "CreateOrUpdate");
@@clientName(BlobInventoryPolicies.createOrUpdate::parameters.resource,
  "properties"
);
@@clientLocation(BlobInventoryPolicies.delete, "BlobInventoryPolicies");
@@clientLocation(BlobInventoryPolicies.list, "BlobInventoryPolicies");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BlobInventoryPolicy.properties);

@@clientLocation(ObjectReplicationPolicyOperationGroup.get,
  "ObjectReplicationPolicies"
);
@@clientLocation(ObjectReplicationPolicyOperationGroup.createOrUpdate,
  "ObjectReplicationPolicies"
);
@@clientName(ObjectReplicationPolicyOperationGroup.createOrUpdate,
  "CreateOrUpdate"
);
@@clientName(ObjectReplicationPolicyOperationGroup.createOrUpdate::parameters.resource,
  "properties"
);
@@clientLocation(ObjectReplicationPolicyOperationGroup.delete,
  "ObjectReplicationPolicies"
);
@@clientLocation(ObjectReplicationPolicyOperationGroup.list,
  "ObjectReplicationPolicies"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ObjectReplicationPolicy.properties);

@@clientLocation(LocalUserOperationGroup.get, "LocalUsers");
@@clientLocation(LocalUserOperationGroup.createOrUpdate, "LocalUsers");
@@clientName(LocalUserOperationGroup.createOrUpdate, "CreateOrUpdate");
@@clientName(LocalUserOperationGroup.createOrUpdate::parameters.resource,
  "properties"
);
@@clientLocation(LocalUserOperationGroup.delete, "LocalUsers");
@@clientLocation(LocalUserOperationGroup.list, "LocalUsers");
@@clientLocation(LocalUserOperationGroup.listKeys, "LocalUsers");
@@clientName(LocalUserOperationGroup.listKeys, "ListKeys");
@@clientLocation(LocalUserOperationGroup.regeneratePassword, "LocalUsers");
@@clientName(LocalUserOperationGroup.regeneratePassword, "RegeneratePassword");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(LocalUser.properties);

@@clientLocation(EncryptionScopes.get, "EncryptionScopes");
@@clientLocation(EncryptionScopes.put, "EncryptionScopes");
@@clientName(EncryptionScopes.put::parameters.resource, "encryptionScope");
@@clientLocation(EncryptionScopes.patch, "EncryptionScopes");
@@clientName(EncryptionScopes.patch::parameters.properties, "encryptionScope");
@@clientLocation(EncryptionScopes.list, "EncryptionScopes");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(EncryptionScope.properties);

@@clientLocation(BlobServices.getServiceProperties, "BlobServices");
@@clientName(BlobServices.getServiceProperties, "GetServiceProperties");
@@clientLocation(BlobServices.setServiceProperties, "BlobServices");
@@clientName(BlobServices.setServiceProperties, "SetServiceProperties");
@@clientName(BlobServices.setServiceProperties::parameters.resource,
  "parameters"
);
@@clientLocation(BlobServices.list, "BlobServices");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BlobServiceProperties.properties);

@@clientLocation(BlobContainers.get, "BlobContainers");
@@clientLocation(BlobContainers.create, "BlobContainers");
@@clientName(BlobContainers.create::parameters.resource, "blobContainer");
@@clientLocation(BlobContainers.update, "BlobContainers");
@@clientName(BlobContainers.update::parameters.properties, "blobContainer");
@@clientLocation(BlobContainers.delete, "BlobContainers");
@@clientLocation(BlobContainers.list, "BlobContainers");
@@clientLocation(BlobContainers.setLegalHold, "BlobContainers");
@@clientName(BlobContainers.setLegalHold, "SetLegalHold");
@@clientName(BlobContainers.setLegalHold::parameters.body, "LegalHold");
@@clientLocation(BlobContainers.clearLegalHold, "BlobContainers");
@@clientName(BlobContainers.clearLegalHold, "ClearLegalHold");
@@clientName(BlobContainers.clearLegalHold::parameters.body, "LegalHold");
@@clientLocation(BlobContainers.lease, "BlobContainers");
@@clientName(BlobContainers.lease::parameters.body, "parameters");
@@clientLocation(BlobContainers.objectLevelWorm, "BlobContainers");
@@clientName(BlobContainers.objectLevelWorm, "ObjectLevelWorm");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BlobContainer.properties);

@@clientLocation(ImmutabilityPolicies.getImmutabilityPolicy, "BlobContainers");
@@clientName(ImmutabilityPolicies.getImmutabilityPolicy,
  "GetImmutabilityPolicy"
);
@@clientLocation(ImmutabilityPolicies.createOrUpdateImmutabilityPolicy,
  "BlobContainers"
);
@@clientName(ImmutabilityPolicies.createOrUpdateImmutabilityPolicy,
  "CreateOrUpdateImmutabilityPolicy"
);
@@clientName(ImmutabilityPolicies.createOrUpdateImmutabilityPolicy::parameters.resource,
  "parameters"
);
@@clientLocation(ImmutabilityPolicies.deleteImmutabilityPolicy,
  "BlobContainers"
);
@@clientName(ImmutabilityPolicies.deleteImmutabilityPolicy,
  "DeleteImmutabilityPolicy"
);
@@clientLocation(ImmutabilityPolicies.lockImmutabilityPolicy, "BlobContainers");
@@clientName(ImmutabilityPolicies.lockImmutabilityPolicy,
  "LockImmutabilityPolicy"
);
@@clientLocation(ImmutabilityPolicies.extendImmutabilityPolicy,
  "BlobContainers"
);
@@clientName(ImmutabilityPolicies.extendImmutabilityPolicy,
  "ExtendImmutabilityPolicy"
);
@@clientName(ImmutabilityPolicies.extendImmutabilityPolicy::parameters.body,
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ImmutabilityPolicy.properties);

@@clientLocation(FileServices.getServiceProperties, "FileServices");
@@clientName(FileServices.getServiceProperties, "GetServiceProperties");
@@clientLocation(FileServices.setServiceProperties, "FileServices");
@@clientName(FileServices.setServiceProperties, "SetServiceProperties");
@@clientName(FileServices.setServiceProperties::parameters.resource,
  "parameters"
);
@@clientLocation(FileServices.list, "FileServices");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(FileServiceProperties.properties);

@@clientLocation(FileShares.get, "FileShares");
@@clientLocation(FileShares.create, "FileShares");
@@clientName(FileShares.create::parameters.resource, "fileShare");
@@clientLocation(FileShares.update, "FileShares");
@@clientName(FileShares.update::parameters.properties, "fileShare");
@@clientLocation(FileShares.delete, "FileShares");
@@clientLocation(FileShares.list, "FileShares");
@@clientLocation(FileShares.restore, "FileShares");
@@clientName(FileShares.restore::parameters.body, "deletedShare");
@@clientLocation(FileShares.lease, "FileShares");
@@clientName(FileShares.lease::parameters.body, "parameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(FileShare.properties);

@@clientLocation(QueueServices.getServiceProperties, "QueueServices");
@@clientName(QueueServices.getServiceProperties, "GetServiceProperties");
@@clientLocation(QueueServices.setServiceProperties, "QueueServices");
@@clientName(QueueServices.setServiceProperties, "SetServiceProperties");
@@clientName(QueueServices.setServiceProperties::parameters.resource,
  "parameters"
);
@@clientLocation(QueueServices.list, "QueueServices");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QueueServiceProperties.properties);

@@clientLocation(StorageQueues.get, "Queue");
@@clientLocation(StorageQueues.create, "Queue");
@@clientName(StorageQueues.create::parameters.resource, "queue");
@@clientLocation(StorageQueues.update, "Queue");
@@clientName(StorageQueues.update::parameters.properties, "queue");
@@clientLocation(StorageQueues.delete, "Queue");
@@clientLocation(StorageQueues.list, "Queue");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(StorageQueue.properties);

@@clientLocation(TableServices.getServiceProperties, "TableServices");
@@clientName(TableServices.getServiceProperties, "GetServiceProperties");
@@clientLocation(TableServices.setServiceProperties, "TableServices");
@@clientName(TableServices.setServiceProperties, "SetServiceProperties");
@@clientName(TableServices.setServiceProperties::parameters.resource,
  "parameters"
);
@@clientLocation(TableServices.list, "TableServices");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TableServiceProperties.properties);

@@clientLocation(Tables.get, "Table");
@@clientLocation(Tables.create, "Table");
@@clientName(Tables.create::parameters.resource, "parameters");
@@clientLocation(Tables.update, "Table");
@@clientName(Tables.update::parameters.properties, "parameters");
@@clientLocation(Tables.delete, "Table");
@@clientLocation(Tables.list, "Table");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Table.properties);

@@clientLocation(SkusOperationGroup.list, "Skus");

@@clientLocation(StorageAccountsOperationGroup.checkNameAvailability,
  "StorageAccounts"
);
@@clientName(StorageAccountsOperationGroup.checkNameAvailability,
  "CheckNameAvailability"
);

@@clientLocation(DeletedAccountsOperationGroup.list, "DeletedAccounts");

@@clientLocation(UsagesOperationGroup.listByLocation, "Usages");
@@clientName(UsagesOperationGroup.listByLocation, "ListByLocation");
