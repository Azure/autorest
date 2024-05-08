import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
/**
 * An API for QnAMaker runtime
 */
@useAuth(ApiKeyAuth<ApiKeyLocation.header, "Authorization">)
@service({
  title: "QnAMaker Runtime Client",
})
@server(
  "{RuntimeEndpoint}/qnamaker",
  "An API for QnAMaker runtime",
  {
    RuntimeEndpoint: string,
  }
)
namespace QnAMakerRuntimeClient;
