import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.AI.OpenAI;

@@clientName(Paths1Vtxb06DeploymentsDeploymentIdCompletionsPostRequestbodyContentApplicationJsonSchema.max_tokens,
  "maxTokens"
);
@@clientName(Paths1Vtxb06DeploymentsDeploymentIdCompletionsPostRequestbodyContentApplicationJsonSchema.top_p,
  "topP"
);
@@clientName(Paths1Vtxb06DeploymentsDeploymentIdCompletionsPostRequestbodyContentApplicationJsonSchema.logit_bias,
  "logitBias"
);
@@clientName(Paths1Vtxb06DeploymentsDeploymentIdCompletionsPostRequestbodyContentApplicationJsonSchema.completion_config,
  "completionConfig"
);
@@clientName(Paths1Vtxb06DeploymentsDeploymentIdCompletionsPostRequestbodyContentApplicationJsonSchema.cache_level,
  "cacheLevel"
);
@@clientName(Paths1Vtxb06DeploymentsDeploymentIdCompletionsPostRequestbodyContentApplicationJsonSchema.presence_penalty,
  "presencePenalty"
);
@@clientName(Paths1Vtxb06DeploymentsDeploymentIdCompletionsPostRequestbodyContentApplicationJsonSchema.frequency_penalty,
  "frequencyPenalty"
);
@@clientName(Paths1Vtxb06DeploymentsDeploymentIdCompletionsPostRequestbodyContentApplicationJsonSchema.best_of,
  "bestOf"
);

@@clientName(Post200ApplicationJsonPropertiesItemsItem.finish_reason,
  "finishReason"
);

@@clientName(PostResponses200ContentApplicationJsonSchemaChoicesItemLogprobs.token_logprobs,
  "tokenLogprobs"
);
@@clientName(PostResponses200ContentApplicationJsonSchemaChoicesItemLogprobs.top_logprobs,
  "topLogprobs"
);
@@clientName(PostResponses200ContentApplicationJsonSchemaChoicesItemLogprobs.text_offset,
  "textOffset"
);

@@clientName(Paths13PiqocDeploymentsDeploymentIdEmbeddingsPostRequestbodyContentApplicationJsonSchema.input_type,
  "inputType"
);
