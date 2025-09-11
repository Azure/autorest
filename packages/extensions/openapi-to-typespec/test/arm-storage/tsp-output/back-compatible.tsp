import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Storage;

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(Operation.properties);
@@clientName(Operation.properties, "operationProperties");

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(StorageAccountCreateParameters.properties);

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

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(StorageAccountUpdateParameters.properties);

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

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PrivateLinkResource.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ImmutabilityPolicyProperties.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ListContainerItem.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(FileShareItem.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ListQueue.properties);
@@clientName(ListQueue.properties, "queueProperties");

@@clientName(StorageAccounts.create::parameters.resource, "parameters");
@@clientName(StorageAccounts.update::parameters.properties, "parameters");
@@clientName(StorageAccounts.regenerateKey::parameters.body, "regenerateKey");
@@clientName(StorageAccounts.listAccountSAS::parameters.body, "parameters");
@@clientName(StorageAccounts.listServiceSAS::parameters.body, "parameters");
@@clientName(StorageAccounts.restoreBlobRanges::parameters.body, "parameters");
@@clientLocation(StorageAccounts.listByStorageAccount, "PrivateLinkResources");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(StorageAccount.properties);

@@clientName(PrivateEndpointConnections.put::parameters.resource, "properties");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PrivateEndpointConnection.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DeletedAccount.properties);

@@clientName(ManagementPolicies.createOrUpdate::parameters.resource,
  "properties"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ManagementPolicy.properties);

@@clientName(BlobInventoryPolicies.createOrUpdate::parameters.resource,
  "properties"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(BlobInventoryPolicy.properties);

@@clientLocation(ObjectReplicationPolicyOperationGroup.get,
  "ObjectReplicationPolicies"
);
@@clientLocation(ObjectReplicationPolicyOperationGroup.createOrUpdate,
  "ObjectReplicationPolicies"
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
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ObjectReplicationPolicy.properties);

@@clientLocation(LocalUserOperationGroup.get, "LocalUsers");
@@clientLocation(LocalUserOperationGroup.createOrUpdate, "LocalUsers");
@@clientName(LocalUserOperationGroup.createOrUpdate::parameters.resource,
  "properties"
);
@@clientLocation(LocalUserOperationGroup.delete, "LocalUsers");
@@clientLocation(LocalUserOperationGroup.list, "LocalUsers");
@@clientLocation(LocalUserOperationGroup.listKeys, "LocalUsers");
@@clientLocation(LocalUserOperationGroup.regeneratePassword, "LocalUsers");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(LocalUser.properties);

@@clientName(EncryptionScopes.put::parameters.resource, "encryptionScope");
@@clientName(EncryptionScopes.patch::parameters.properties, "encryptionScope");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(EncryptionScope.properties);

@@clientName(BlobServices.setServiceProperties::parameters.resource,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(BlobServiceProperties.properties);

@@clientName(BlobContainers.create::parameters.resource, "blobContainer");
@@clientName(BlobContainers.update::parameters.properties, "blobContainer");
@@clientName(BlobContainers.setLegalHold::parameters.body, "LegalHold");
@@clientName(BlobContainers.clearLegalHold::parameters.body, "LegalHold");
@@clientName(BlobContainers.lease::parameters.body, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(BlobContainer.properties);

@@clientLocation(ImmutabilityPolicies.getImmutabilityPolicy, BlobContainers);
@@clientLocation(ImmutabilityPolicies.createOrUpdateImmutabilityPolicy,
  BlobContainers
);
@@clientName(ImmutabilityPolicies.createOrUpdateImmutabilityPolicy::parameters.resource,
  "parameters"
);
@@clientLocation(ImmutabilityPolicies.deleteImmutabilityPolicy, BlobContainers);
@@clientLocation(ImmutabilityPolicies.lockImmutabilityPolicy, BlobContainers);
@@clientLocation(ImmutabilityPolicies.extendImmutabilityPolicy, BlobContainers);
@@clientName(ImmutabilityPolicies.extendImmutabilityPolicy::parameters.body,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(ImmutabilityPolicy.properties);

@@clientName(FileServices.setServiceProperties::parameters.resource,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(FileServiceProperties.properties);

@@clientName(FileShares.create::parameters.resource, "fileShare");
@@clientName(FileShares.update::parameters.properties, "fileShare");
@@clientName(FileShares.restore::parameters.body, "deletedShare");
@@clientName(FileShares.lease::parameters.body, "parameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(FileShare.properties);

@@clientName(QueueServices.setServiceProperties::parameters.resource,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(QueueServiceProperties.properties);

@@clientLocation(StorageQueues.get, "Queue");
@@clientLocation(StorageQueues.create, "Queue");
@@clientName(StorageQueues.create::parameters.resource, "queue");
@@clientLocation(StorageQueues.update, "Queue");
@@clientName(StorageQueues.update::parameters.properties, "queue");
@@clientLocation(StorageQueues.delete, "Queue");
@@clientLocation(StorageQueues.list, "Queue");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(StorageQueue.properties);

@@clientName(TableServices.setServiceProperties::parameters.resource,
  "parameters"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(TableServiceProperties.properties);

@@clientLocation(Tables.get, "Table");
@@clientLocation(Tables.create, "Table");
@@clientName(Tables.create::parameters.resource, "parameters");
@@clientLocation(Tables.update, "Table");
@@clientName(Tables.update::parameters.properties, "parameters");
@@clientLocation(Tables.delete, "Table");
@@clientLocation(Tables.list, "Table");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(Table.properties);

@@clientLocation(SkusOperationGroup.list, "Skus");

@@clientLocation(StorageAccountsOperationGroup.checkNameAvailability,
  StorageAccounts
);

@@clientLocation(DeletedAccountsOperationGroup.list, DeletedAccounts);

@@clientLocation(UsagesOperationGroup.listByLocation, "Usages");
