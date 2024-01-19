import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.AI.OpenAI;

interface completionsOperations {
  /**
   * Create a completion from a chosen model
   */
  @summary("Create a completion from a chosen model")
  @route("/deployments/{deployment-id}/completions")
  @post
  create is Azure.Core.Foundations.Operation<
    {
      @path
      `deployment-id`: string;

      @body
      body: Paths1Vtxb06DeploymentsDeploymentIdCompletionsPostRequestbodyContentApplicationJsonSchema;
    },
    PathsMaorw9DeploymentsDeploymentIdCompletionsPostResponses200ContentApplicationJsonSchema
  >;
}

interface embeddingsOperations {
  /**
   * Return the embeddings for a given prompt.
   */
  @summary("Return the embeddings for a given prompt.")
  @route("/deployments/{deployment-id}/embeddings")
  @post
  create is Azure.Core.Foundations.Operation<
    {
      /**
       * deployment id of the model which was deployed
       */
      @path
      `deployment-id`: string;

      @body
      body: Paths13PiqocDeploymentsDeploymentIdEmbeddingsPostRequestbodyContentApplicationJsonSchema;
    },
    void
  >;
}
