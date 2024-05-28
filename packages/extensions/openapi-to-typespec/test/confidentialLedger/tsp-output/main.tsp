import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
/**
 * The ConfidentialLedgerClient writes and retrieves ledger entries against the
 * Confidential Ledger service.
 */
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
namespace Azure.Language.Authoring;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2022-05-13 API version.
   */
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_05_13: "2022-05-13",
}
