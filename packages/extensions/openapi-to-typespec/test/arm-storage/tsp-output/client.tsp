import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Storage;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(StorageAccountCreateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(StorageAccountUpdateParameters.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateLinkResource.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ImmutabilityPolicyProperties.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ListContainerItem.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(FileShareItem.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ListQueue.queueProperties);

@@clientName(StorageAccounts.update,
  "StorageAccounts.update::parameters.properties",
  "parameters"
);
@@clientName(StorageAccounts.regenerateKey,
  "StorageAccounts.regenerateKey::parameters.body",
  "regenerateKey"
);
@@clientName(StorageAccounts.listAccountSAS,
  "StorageAccounts.listAccountSAS::parameters.body",
  "parameters"
);
@@clientName(StorageAccounts.listServiceSAS,
  "StorageAccounts.listServiceSAS::parameters.body",
  "parameters"
);
@@clientName(StorageAccounts.restoreBlobRanges,
  "StorageAccounts.restoreBlobRanges::parameters.body",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(StorageAccount.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DeletedAccount.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ManagementPolicy.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BlobInventoryPolicy.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ObjectReplicationPolicy.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(LocalUser.properties);

@@clientName(EncryptionScopes.patch,
  "EncryptionScopes.patch::parameters.properties",
  "encryptionScope"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(EncryptionScope.properties);

@@clientName(BlobServicePropertiesOperationGroup, "BlobServiceProperties");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BlobServiceProperties.properties);

@@clientName(BlobContainers.update,
  "BlobContainers.update::parameters.properties",
  "blobContainer"
);
@@clientName(BlobContainers.setLegalHold,
  "BlobContainers.setLegalHold::parameters.body",
  "LegalHold"
);
@@clientName(BlobContainers.clearLegalHold,
  "BlobContainers.clearLegalHold::parameters.body",
  "LegalHold"
);
@@clientName(BlobContainers.lease,
  "BlobContainers.lease::parameters.body",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BlobContainer.properties);

@@clientName(ImmutabilityPolicies.extendImmutabilityPolicy,
  "ImmutabilityPolicies.extendImmutabilityPolicy::parameters.body",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ImmutabilityPolicy.properties);

@@clientName(FileServicePropertiesOperationGroup, "FileServiceProperties");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(FileServiceProperties.properties);

@@clientName(FileShares.update,
  "FileShares.update::parameters.properties",
  "fileShare"
);
@@clientName(FileShares.restore,
  "FileShares.restore::parameters.body",
  "deletedShare"
);
@@clientName(FileShares.lease,
  "FileShares.lease::parameters.body",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(FileShare.properties);

@@clientName(QueueServicePropertiesOperationGroup, "QueueServiceProperties");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QueueServiceProperties.properties);

@@clientName(StorageQueues.update,
  "StorageQueues.update::parameters.properties",
  "queue"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(StorageQueue.properties);

@@clientName(TableServicePropertiesOperationGroup, "TableServiceProperties");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TableServiceProperties.properties);

@@clientName(Tables.update,
  "Tables.update::parameters.properties",
  "parameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Table.properties);
