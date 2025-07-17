import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace QnAMakerRuntimeClient;

interface RuntimeOperationGroup {
  /**
   * GenerateAnswer call to query the knowledgebase.
   */
  @summary("GenerateAnswer call to query the knowledgebase.")
  @operationId("Runtime_GenerateAnswer")
  @route("/knowledgebases/{kbId}/generateAnswer")
  @post
  generateAnswer is Azure.Core.Foundations.Operation<
    {
      /**
       * Knowledgebase id.
       */
      @path
      kbId: string;

      /**
       * Post body of the request.
       */
      @bodyRoot
      generateAnswerPayload: QueryDTO;
    },
    QnASearchResultList
  >;

  /**
   * Train call to add suggestions to the knowledgebase.
   */
  @summary("Train call to add suggestions to the knowledgebase.")
  @operationId("Runtime_Train")
  @route("/knowledgebases/{kbId}/train")
  @post
  train is Azure.Core.Foundations.Operation<
    {
      /**
       * Knowledgebase id.
       */
      @path
      kbId: string;

      /**
       * Post body of the request.
       */
      @bodyRoot
      trainPayload: FeedbackRecordsDTO;
    },
    void
  >;
}
