import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace AzureWebPubSubServiceRESTAPI;

enum WebPubSubPermission {
  sendToGroup,
  joinLeaveGroup,
}

/**
 * Content type for upload
 */
@fixed
enum ContentType {
  /**
   * Content Type 'application/json'
   */
  `application/json`,

  /**
   * Content Type 'application/octet-stream'
   */
  `application/octet-stream`,

  /**
   * Content Type 'text/plain'
   */
  `text/plain`,
}

/**
 * The request object containing targets groups and a connection filter
 */
model AddToGroupsRequest {
  /**
   * A list of groups which target connections will be added into
   */
  groups?: string[];

  /**
   * An OData filter which target connections satisfy
   */
  filter?: string;
}

/**
 * The error object.
 */
@error
model ErrorDetail {
  /**
   * One of a server-defined set of error codes.
   */
  code?: string;

  /**
   * A human-readable representation of the error.
   */
  message?: string;

  /**
   * The target of the error.
   */
  target?: string;

  /**
   * An array of details about specific errors that led to this reported error.
   */
  details?: ErrorDetail[];

  inner?: InnerError;
}

model InnerError {
  /**
   * A more specific error code than was provided by the containing error.
   */
  code?: string;

  inner?: InnerError;
}

/**
 * The response object containing the token for the client
 */
model ClientTokenResponse {
  /**
   * The token value for the WebSocket client to connect to the service
   */
  token: string;
}

/**
 * The request object containing targets groups and a connection filter
 */
model RemoveFromGroupsRequest {
  /**
   * A list of groups which target connections will be removed from
   */
  groups?: string[];

  /**
   * An OData filter which target connections satisfy
   */
  filter?: string;
}
