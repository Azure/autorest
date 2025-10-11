import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace QnAMakerRuntimeClient;

interface RuntimeOperationGroup {
  /** GenerateAnswer call to query the knowledgebase. */
  @summary("GenerateAnswer call to query the knowledgebase.")
  @route("/knowledgebases/{kbId}/generateAnswer")
  @post
  generateAnswer is Azure.Core.Foundations.Operation<
    {
      /** Knowledgebase id. */
      @path
      kbId: string;

      /** Post body of the request. */
      @bodyRoot
      generateAnswerPayload: QueryDTO;
    },
    QnASearchResultList
  >;

  /** Train call to add suggestions to the knowledgebase. */
  @summary("Train call to add suggestions to the knowledgebase.")
  @route("/knowledgebases/{kbId}/train")
  @post
  train is Azure.Core.Foundations.Operation<
    {
      /** Knowledgebase id. */
      @path
      kbId: string;

      /** Post body of the request. */
      @bodyRoot
      trainPayload: FeedbackRecordsDTO;
    },
    void
  >;
}
