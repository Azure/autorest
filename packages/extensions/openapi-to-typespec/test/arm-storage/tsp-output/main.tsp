import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./models.tsp";
import "./StorageAccount.tsp";
import "./DeletedAccount.tsp";
import "./ManagementPolicy.tsp";
import "./BlobInventoryPolicy.tsp";
import "./PrivateEndpointConnection.tsp";
import "./ObjectReplicationPolicy.tsp";
import "./LocalUser.tsp";
import "./EncryptionScope.tsp";
import "./BlobServiceProperties.tsp";
import "./BlobContainer.tsp";
import "./ImmutabilityPolicy.tsp";
import "./FileServiceProperties.tsp";
import "./FileShare.tsp";
import "./QueueServiceProperties.tsp";
import "./StorageQueue.tsp";
import "./TableServiceProperties.tsp";
import "./Table.tsp";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.ResourceManager;
using TypeSpec.Versioning;
@armProviderNamespace
@service({
  title: "Azure Storage resource management API.",
})
@versioned(Versions)
@armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v1)
@doc("The Azure Storage Management API.")
namespace Microsoft.Storage;

@doc("The available API versions.")
enum Versions {
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_09_01: "2022-09-01",
}