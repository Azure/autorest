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
/**
 * The Azure Storage Management API.
 */
@armProviderNamespace
@useAuth(AadOauth2Auth<["user_impersonation"]>)
@service({
  title: "Azure Storage resource management API.",
})
@versioned(Versions)
// FIXME: Common type version v1 is not supported for now.
// @armCommonTypesVersion(Azure.ResourceManager.CommonTypes.Versions.v1)
namespace Microsoft.Storage;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2022-09-01 API version.
   */
  @useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_09_01: "2022-09-01",
}
