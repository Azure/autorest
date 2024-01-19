import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
/**
 * An API for QnAMaker runtime
 */
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
