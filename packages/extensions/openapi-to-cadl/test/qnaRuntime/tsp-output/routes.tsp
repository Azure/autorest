import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace QnAMakerRuntimeClient;

interface RuntimeOperations {
  @summary("GenerateAnswer call to query the knowledgebase.")
  @doc("GenerateAnswer call to query the knowledgebase.")
  @route("/knowledgebases/{kbId}/generateAnswer")
  @post
  GenerateAnswer is Azure.Core.Foundations.Operation<
    {
      @doc("Knowledgebase id.")
      @path
      kbId: string;

      @doc("Post body of the request.")
      @body
      generateAnswerPayload: QueryDTO;
    },
    QnASearchResultList
  >;

  @summary("Train call to add suggestions to the knowledgebase.")
  @doc("Train call to add suggestions to the knowledgebase.")
  @route("/knowledgebases/{kbId}/train")
  @post
  Train is Azure.Core.Foundations.Operation<
    {
      @doc("Knowledgebase id.")
      @path
      kbId: string;

      @doc("Post body of the request.")
      @body
      trainPayload: FeedbackRecordsDTO;
    },
    void
  >;
}
