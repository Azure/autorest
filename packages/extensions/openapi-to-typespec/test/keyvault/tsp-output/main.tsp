import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
/**
 * The key vault client performs cryptographic key operations and vault operations
 * against the Key Vault service.
 */
@service({
  title: "Azure Keyvault Service",
})
@versioned(Versions)
@server(
  "{vaultBaseUrl}",
  "The key vault client performs cryptographic key operations and vault operations against the Key Vault service.",
  {
    vaultBaseUrl: string,
  }
)
namespace Azure.Keyvault;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 7.4-preview.1 API version.
   */
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v7_4_preview_1: "7.4-preview.1",
}
