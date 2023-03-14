import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.AI.OpenAI;

interface completionsOperations {
  @summary("Create a completion from a chosen model")
  @doc("Create a completion from a chosen model")
  @route("/deployments/{deployment-id}/completions")
  @post
  create is Azure.Core.Foundations.Operation<
    {
      @path `deployment-id`: string;
      @body
      body: Paths1Vtxb06DeploymentsDeploymentIdCompletionsPostRequestbodyContentApplicationJsonSchema;
    },
    PathsMaorw9DeploymentsDeploymentIdCompletionsPostResponses200ContentApplicationJsonSchema
  >;
}

interface embeddingsOperations {
  @summary("Return the embeddings for a given prompt.")
  @doc("Return the embeddings for a given prompt.")
  @route("/deployments/{deployment-id}/embeddings")
  @post
  create is Azure.Core.Foundations.Operation<
    {
      @doc("deployment id of the model which was deployed")
      @path
      `deployment-id`: string;
      @body
      body: Paths13PiqocDeploymentsDeploymentIdEmbeddingsPostRequestbodyContentApplicationJsonSchema;
    },
    void
  >;
}
