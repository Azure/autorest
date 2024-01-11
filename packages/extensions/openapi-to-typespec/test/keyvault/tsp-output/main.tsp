import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
    title: "Azure Keyvault Service"
  })
@versioned(Versions)
@server("{vaultBaseUrl}", "The key vault client performs cryptographic key operations and vault operations against the Key Vault service."
, {
vaultBaseUrl: string 
}
)
@doc("""
The key vault client performs cryptographic key operations and vault operations
against the Key Vault service.
""")
namespace Azure.Keyvault;

@doc("The available API versions.")
enum Versions {
@doc("The 7.4-preview.1 API version.")
v7.4_preview.1: "7.4-preview.1",
}