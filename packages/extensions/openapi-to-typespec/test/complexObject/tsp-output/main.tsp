import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
/**
 * Some cool documentation.
 */
@service({
  title: "Complex Model Client",
})
@versioned(Versions)
@server(
  "{$host}",
  "Some cool documentation.",
  {
    $host: string,
  }
)
namespace ComplexModelClient;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2014-04-01-preview API version.
   */
  v2014_04_01_preview: "2014-04-01-preview",
}
