import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
@service({
  title: "Microsoft Cognitive Language Service - Analyze Text Authoring",
})
@versioned(Versions)
@server(
  "{ledgerEndpoint}",
  "The ConfidentialLedgerClient writes and retrieves ledger entries against the Confidential Ledger service.",
  {
    ledgerEndpoint: string,
  }
)
@doc("""
The ConfidentialLedgerClient writes and retrieves ledger entries against the
Confidential Ledger service.
""")
namespace Azure.Language.Authoring;

@doc("The available API versions.")
enum Versions {
  v2022_05_13: "2022-05-13",
}