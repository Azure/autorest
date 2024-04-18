import "@typespec/rest";
import "@typespec/http";
import "./routes.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.Versioning;
/**
 * The language service API is a suite of natural language processing (NLP) skills
 * built with best-in-class Microsoft machine learning algorithms.  The API can be
 * used to analyze unstructured text for tasks such as sentiment analysis, key
 * phrase extraction, language detection and question answering. Further
 * documentation can be found in <a
 * href="https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview">https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview</a>.
 */
@useAuth(
  AadOauth2Auth<["https://cognitiveservices.azure.com/.default"]> | ApiKeyAuth<
    ApiKeyLocation.header,
    "Ocp-Apim-Subscription-Key"
  >
)
@service({
  title: "QnA Maker",
})
@versioned(Versions)
@server(
  "{Endpoint}/language",
  "The language service API is a suite of natural language processing (NLP) skills built with best-in-class Microsoft machine learning algorithms.  The API can be used to analyze unstructured text for tasks such as sentiment analysis, key phrase extraction, language detection and question answering. Further documentation can be found in <a href=\"https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview\">https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/overview</a>.",
  {
    Endpoint: string,
  }
)
namespace Azure.Language.QnAMaker;

/**
 * The available API versions.
 */
enum Versions {
  /**
   * The 2022-07-01-preview API version.
   */
  @useDependency(Azure.Core.Versions.v1_0_Preview_1)
  v2022_07_01_preview: "2022-07-01-preview",
}
