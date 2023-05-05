import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureMessagingWebPubSubServiceClient;

enum WebPubSubPermission {
  sendToGroup,
  joinLeaveGroup,
}
@Azure.Core.fixed
enum ContentType {
  @doc("Content Type 'application/json'") `application/json`,
  @doc("Content Type 'application/octet-stream'") `application/octet-stream`,
  @doc("Content Type 'text/plain'") `text/plain`,
}

@doc("The error object.")
@error
model ErrorDetail {
  @doc("One of a server-defined set of error codes.")
  code?: string;

  @doc("A human-readable representation of the error.")
  message?: string;

  @doc("The target of the error.")
  target?: string;

  @doc("An array of details about specific errors that led to this reported error.")
  details?: ErrorDetail[];
  inner?: InnerError;
}

model InnerError {
  @doc("A more specific error code than was provided by the containing error.")
  code?: string;
  inner?: InnerError;
}

@doc("The response object containing the token for the client")
model ClientTokenResponse {
  @doc("The token value for the WebSocket client to connect to the service")
  token: string;
}
