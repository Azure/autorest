import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Azure Keyvault Service",
  version: "7.4-preview.1",
})
@server(
  "{vaultBaseUrl}",
  "The key vault client performs cryptographic key operations and vault operations against the Key Vault service.",
  {
    vaultBaseUrl: string,
  }
)
@doc("""
The key vault client performs cryptographic key operations and vault operations
against the Key Vault service.
""")
namespace Azure.Keyvault;
