import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Language.QnAMaker;

interface QuestionAnsweringOperations {
  /**
   * Answers the specified question using your knowledge base.
   */
  @summary("Answers the specified question using your knowledge base.")
  @route("/:query-knowledgebases")
  @post
  getAnswers is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the project to use.
       */
      @query("projectName")
      projectName: string;

      /**
       * The name of the specific deployment of the project to use.
       */
      @query("deploymentName")
      deploymentName: string;

      /**
       * Post body of the request.
       */
      @body
      knowledgeBaseQueryOptions: AnswersOptions;
    },
    AnswersResult
  >;

  /**
   * Answers the specified question using the provided text in the body.
   */
  @summary("Answers the specified question using the provided text in the body.")
  @route("/:query-text")
  @post
  getAnswersFromText is Azure.Core.Foundations.Operation<
    AnswersFromTextOptions,
    AnswersFromTextResult
  >;
}
