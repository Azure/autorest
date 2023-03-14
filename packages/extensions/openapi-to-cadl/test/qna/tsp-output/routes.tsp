import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Language.QnAMaker;

interface QuestionAnsweringOperations {
  @summary("Answers the specified question using your knowledge base.")
  @doc("Answers the specified question using your knowledge base.")
  @route("/:query-knowledgebases")
  @post
  GetAnswers is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the project to use.")
      @query
      projectName: string;

      @doc("The name of the specific deployment of the project to use.")
      @query
      deploymentName: string;

      @doc("Post body of the request.")
      @body
      knowledgeBaseQueryOptions: AnswersOptions;
    },
    AnswersResult
  >;

  @summary("Answers the specified question using the provided text in the body.")
  @doc("Answers the specified question using the provided text in the body.")
  @route("/:query-text")
  @post
  GetAnswersFromText is Azure.Core.Foundations.Operation<
    {
      @doc("Post body of the request.")
      @body
      textQueryOptions: AnswersFromTextOptions;
    },
    AnswersFromTextResult
  >;
}
