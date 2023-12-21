import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
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
@doc("An API for QnAMaker runtime")
namespace QnAMakerRuntimeClient;
