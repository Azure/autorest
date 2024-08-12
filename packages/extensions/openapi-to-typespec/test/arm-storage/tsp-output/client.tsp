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

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(EncryptionScope.properties);

@@clientName(BlobServicePropertiesOperationGroup, "BlobServiceProperties");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BlobServiceProperties.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(BlobContainer.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(ImmutabilityPolicy.properties);

@@clientName(FileServicePropertiesOperationGroup, "FileServiceProperties");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(FileServiceProperties.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(FileShare.properties);

@@clientName(QueueServicePropertiesOperationGroup, "QueueServiceProperties");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(QueueServiceProperties.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(StorageQueue.properties);

@@clientName(TableServicePropertiesOperationGroup, "TableServiceProperties");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(TableServiceProperties.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Table.properties);
