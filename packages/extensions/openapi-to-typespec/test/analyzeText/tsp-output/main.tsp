import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
/**
 * The language service API is a suite of natural language processing (NLP) skills
 * built with best-in-class Microsoft machine learning algorithms. The API can be
 * used to analyze unstructured text for tasks such as sentiment analysis, key
 * phrase extraction, language detection and question answering. Further
 * documentation can be found in <a
 * href="https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/overview">https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/overview</a>.
 */
@useAuth(ApiKeyAuth<ApiKeyLocation.header, "Ocp-Apim-Subscription-Key">)
@service({
  title: "Microsoft Cognitive Language Service - Analyze Text Authoring",
})
@versioned(Versions)
@server(
  "{Endpoint}/language",
  "The language service API is a suite of natural language processing (NLP) skills built with best-in-class Microsoft machine learning algorithms. The API can be used to analyze unstructured text for tasks such as sentiment analysis, key phrase extraction, language detection and question answering. Further documentation can be found in <a href=\"https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/overview\">https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/overview</a>.",
  {
    Endpoint: string,
  }
)
namespace Azure.Language.Authoring;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2022-05-01 API version.
   */
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_05_01: "2022-05-01",
}
