import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace AzureWebPubSubServiceRESTAPI;

union WebPubSubClientType {
  string,

  /**
   * Default
   */
  Default: "Default",

  /**
   * MQTT
   */
  MQTT: "MQTT",
}

union WebPubSubPermission {
  string,

  /**
   * sendToGroup
   */
  sendToGroup: "sendToGroup",

  /**
   * joinLeaveGroup
   */
  joinLeaveGroup: "joinLeaveGroup",
}

/**
 * Content type for upload
 */
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

/**
 * Represents a page of elements as a LIST REST API result.
 */
model GroupMemberPagedValues is Azure.Core.Page<GroupMember>;

@resource("api/hubs/{hub}/groups/{group}/connections")
model GroupMember {
  /**
   * A unique identifier of a connection.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  connectionId: string;

  /**
   * The user ID of the connection. A user can have multiple connections.
   */
  userId?: string;
}
