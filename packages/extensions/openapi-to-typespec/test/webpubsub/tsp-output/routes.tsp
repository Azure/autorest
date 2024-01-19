import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureWebPubSubServiceRESTAPI;

interface HealthApiOperations {
  /**
   * Get service health status.
   */
  @summary("Get service health status.")
  @route("/api/health")
  @head
  getServiceStatus is Azure.Core.Foundations.Operation<{}, void>;
}

interface WebPubSubOperations {
  /**
   * Add filtered connections to multiple groups.
   */
  @summary("Add filtered connections to multiple groups.")
  @route("/api/hubs/{hub}/:addToGroups")
  @post
  addConnectionsToGroups is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target groups and connection filter.
       */
      @body
      groupsToAdd: AddToGroupsRequest;
    },
    void
  >;

  /**
   * Close the connections in the hub.
   */
  @summary("Close the connections in the hub.")
  @route("/api/hubs/{hub}/:closeConnections")
  @post
  closeAllConnections is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Exclude these connectionIds when closing the connections in the hub.
       */
      @query({
        name: "excluded",
        format: "multi",
      })
      excluded?: string[];

      /**
       * The reason closing the client connection.
       */
      @query("reason")
      reason?: string;
    },
    void
  >;

  /**
   * Generate token for the client to connect Azure Web PubSub service.
   */
  @summary("Generate token for the client to connect Azure Web PubSub service.")
  @route("/api/hubs/{hub}/:generateToken")
  @post
  generateClientToken is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * User Id.
       */
      @query("userId")
      userId?: string;

      /**
       * Roles that the connection with the generated token will have.
       */
      @query({
        name: "role",
        format: "multi",
      })
      role?: string[];

      /**
       * The expire time of the generated token.
       */
      @minValue(1)
      @query("minutesToExpire")
      minutesToExpire?: int32 = 60;

      /**
       * Groups that the connection will join when it connects.
       */
      @query({
        name: "group",
        format: "multi",
      })
      group?: string[];

      /**
       * Accept header
       */
      @header
      accept: "application/json, text/json";
    },
    ClientTokenResponse
  >;

  /**
   * Remove filtered connections from multiple groups.
   */
  @summary("Remove filtered connections from multiple groups.")
  @route("/api/hubs/{hub}/:removeFromGroups")
  @post
  removeConnectionsFromGroups is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target groups and connection filter.
       */
      @body
      groupsToRemove: RemoveFromGroupsRequest;
    },
    void
  >;

  /**
   * Broadcast content inside request body to all the connected client connections.
   */
  @summary("Broadcast content inside request body to all the connected client connections.")
  @route("/api/hubs/{hub}/:send")
  @post
  sendToAll is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Excluded connection Ids.
       */
      @query({
        name: "excluded",
        format: "multi",
      })
      excluded?: string[];

      /**
       * Following OData filter syntax to filter out the subscribers receiving the
       * messages.
       */
      @query("filter")
      filter?: string;

      /**
       * The time-to-live (TTL) value in seconds for messages sent to the service. 0 is
       * the default value, which means the message never expires. 300 is the maximum
       * value. If this parameter is non-zero, messages that are not consumed by the
       * client within the specified TTL will be dropped by the service. This parameter
       * can help when the client's bandwidth is limited.
       */
      @maxValue(300)
      @query("messageTtlSeconds")
      messageTtlSeconds?: int32;

      /**
       * Upload file type
       */
      @header
      `content-type`: ContentType;

      /**
       * The payload body.
       */
      @body
      message: bytes;
    },
    void
  >;

  /**
   * Close the client connection.
   */
  @summary("Close the client connection.")
  @route("/api/hubs/{hub}/connections/{connectionId}")
  @delete
  closeConnection is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target connection Id.
       */
      @minLength(1)
      @path
      connectionId: string;

      /**
       * The reason closing the client connection.
       */
      @query("reason")
      reason?: string;
    },
    void
  >;

  /**
   * Check if the connection with the given connectionId exists.
   */
  @summary("Check if the connection with the given connectionId exists.")
  @route("/api/hubs/{hub}/connections/{connectionId}")
  @head
  connectionExists is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * The connection Id.
       */
      @minLength(1)
      @path
      connectionId: string;
    },
    void
  >;

  /**
   * Send content inside request body to the specific connection.
   */
  @summary("Send content inside request body to the specific connection.")
  @route("/api/hubs/{hub}/connections/{connectionId}/:send")
  @post
  sendToConnection is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * The connection Id.
       */
      @minLength(1)
      @path
      connectionId: string;

      /**
       * The time-to-live (TTL) value in seconds for messages sent to the service. 0 is
       * the default value, which means the message never expires. 300 is the maximum
       * value. If this parameter is non-zero, messages that are not consumed by the
       * client within the specified TTL will be dropped by the service. This parameter
       * can help when the client's bandwidth is limited.
       */
      @maxValue(300)
      @query("messageTtlSeconds")
      messageTtlSeconds?: int32;

      /**
       * Upload file type
       */
      @header
      `content-type`: ContentType;

      /**
       * The payload body.
       */
      @body
      message: bytes;
    },
    void
  >;

  /**
   * Remove a connection from all groups.
   */
  @summary("Remove a connection from all groups.")
  @route("/api/hubs/{hub}/connections/{connectionId}/groups")
  @delete
  removeConnectionFromAllGroups is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target connection Id.
       */
      @minLength(1)
      @path
      connectionId: string;
    },
    void
  >;

  /**
   * Check if there are any client connections inside the given group
   */
  @summary("Check if there are any client connections inside the given group")
  @route("/api/hubs/{hub}/groups/{group}")
  @head
  groupExists is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target group name, which length should be greater than 0 and less than 1025.
       */
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;
    },
    void
  >;

  /**
   * Close connections in the specific group.
   */
  @summary("Close connections in the specific group.")
  @route("/api/hubs/{hub}/groups/{group}/:closeConnections")
  @post
  closeGroupConnections is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target group name, which length should be greater than 0 and less than 1025.
       */
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      /**
       * Exclude these connectionIds when closing the connections in the group.
       */
      @query({
        name: "excluded",
        format: "multi",
      })
      excluded?: string[];

      /**
       * The reason closing the client connection.
       */
      @query("reason")
      reason?: string;
    },
    void
  >;

  /**
   * Send content inside request body to a group of connections.
   */
  @summary("Send content inside request body to a group of connections.")
  @route("/api/hubs/{hub}/groups/{group}/:send")
  @post
  sendToGroup is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target group name, which length should be greater than 0 and less than 1025.
       */
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      /**
       * Excluded connection Ids
       */
      @query({
        name: "excluded",
        format: "multi",
      })
      excluded?: string[];

      /**
       * Following OData filter syntax to filter out the subscribers receiving the
       * messages.
       */
      @query("filter")
      filter?: string;

      /**
       * The time-to-live (TTL) value in seconds for messages sent to the service. 0 is
       * the default value, which means the message never expires. 300 is the maximum
       * value. If this parameter is non-zero, messages that are not consumed by the
       * client within the specified TTL will be dropped by the service. This parameter
       * can help when the client's bandwidth is limited.
       */
      @maxValue(300)
      @query("messageTtlSeconds")
      messageTtlSeconds?: int32;

      /**
       * Upload file type
       */
      @header
      `content-type`: ContentType;

      /**
       * The payload body.
       */
      @body
      message: bytes;
    },
    void
  >;

  /**
   * Remove a connection from the target group.
   */
  @summary("Remove a connection from the target group.")
  @route("/api/hubs/{hub}/groups/{group}/connections/{connectionId}")
  @delete
  removeConnectionFromGroup is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target group name, which length should be greater than 0 and less than 1025.
       */
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      /**
       * Target connection Id.
       */
      @minLength(1)
      @path
      connectionId: string;
    },
    void
  >;

  /**
   * Add a connection to the target group.
   */
  @summary("Add a connection to the target group.")
  @route("/api/hubs/{hub}/groups/{group}/connections/{connectionId}")
  @put
  addConnectionToGroup is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target group name, which length should be greater than 0 and less than 1025.
       */
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      /**
       * Target connection Id
       */
      @minLength(1)
      @path
      connectionId: string;
    },
    void
  >;

  /**
   * Revoke permission for the connection.
   */
  @summary("Revoke permission for the connection.")
  @route("/api/hubs/{hub}/permissions/{permission}/connections/{connectionId}")
  @delete
  revokePermission is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * The permission: current supported actions are joinLeaveGroup and sendToGroup.
       */
      @path
      permission: WebPubSubPermission;

      /**
       * Target connection Id.
       */
      @minLength(1)
      @path
      connectionId: string;

      /**
       * The meaning of the target depends on the specific permission. For
       * joinLeaveGroup and sendToGroup, targetName is a required parameter standing for
       * the group name.
       */
      @query("targetName")
      targetName?: string;
    },
    void
  >;

  /**
   * Check if a connection has permission to the specified action.
   */
  @summary("Check if a connection has permission to the specified action.")
  @route("/api/hubs/{hub}/permissions/{permission}/connections/{connectionId}")
  @head
  checkPermission is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * The permission: current supported actions are joinLeaveGroup and sendToGroup.
       */
      @path
      permission: WebPubSubPermission;

      /**
       * Target connection Id.
       */
      @minLength(1)
      @path
      connectionId: string;

      /**
       * The meaning of the target depends on the specific permission. For
       * joinLeaveGroup and sendToGroup, targetName is a required parameter standing for
       * the group name.
       */
      @query("targetName")
      targetName?: string;
    },
    void
  >;

  /**
   * Grant permission to the connection.
   */
  @summary("Grant permission to the connection.")
  @route("/api/hubs/{hub}/permissions/{permission}/connections/{connectionId}")
  @put
  grantPermission is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * The permission: current supported actions are joinLeaveGroup and sendToGroup.
       */
      @path
      permission: WebPubSubPermission;

      /**
       * Target connection Id.
       */
      @minLength(1)
      @path
      connectionId: string;

      /**
       * The meaning of the target depends on the specific permission. For
       * joinLeaveGroup and sendToGroup, targetName is a required parameter standing for
       * the group name.
       */
      @query("targetName")
      targetName?: string;
    },
    void
  >;

  /**
   * Check if there are any client connections connected for the given user.
   */
  @summary("Check if there are any client connections connected for the given user.")
  @route("/api/hubs/{hub}/users/{userId}")
  @head
  userExists is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target user Id.
       */
      @minLength(1)
      @path
      userId: string;
    },
    void
  >;

  /**
   * Close connections for the specific user.
   */
  @summary("Close connections for the specific user.")
  @route("/api/hubs/{hub}/users/{userId}/:closeConnections")
  @post
  closeUserConnections is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * The user Id.
       */
      @minLength(1)
      @path
      userId: string;

      /**
       * Exclude these connectionIds when closing the connections for the user.
       */
      @query({
        name: "excluded",
        format: "multi",
      })
      excluded?: string[];

      /**
       * The reason closing the client connection.
       */
      @query("reason")
      reason?: string;
    },
    void
  >;

  /**
   * Send content inside request body to the specific user.
   */
  @summary("Send content inside request body to the specific user.")
  @route("/api/hubs/{hub}/users/{userId}/:send")
  @post
  sendToUser is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * The user Id.
       */
      @minLength(1)
      @path
      userId: string;

      /**
       * Following OData filter syntax to filter out the subscribers receiving the
       * messages.
       */
      @query("filter")
      filter?: string;

      /**
       * The time-to-live (TTL) value in seconds for messages sent to the service. 0 is
       * the default value, which means the message never expires. 300 is the maximum
       * value. If this parameter is non-zero, messages that are not consumed by the
       * client within the specified TTL will be dropped by the service. This parameter
       * can help when the client's bandwidth is limited.
       */
      @maxValue(300)
      @query("messageTtlSeconds")
      messageTtlSeconds?: int32;

      /**
       * Upload file type
       */
      @header
      `content-type`: ContentType;

      /**
       * The payload body.
       */
      @body
      message: bytes;
    },
    void
  >;

  /**
   * Remove a user from all groups.
   */
  @summary("Remove a user from all groups.")
  @route("/api/hubs/{hub}/users/{userId}/groups")
  @delete
  removeUserFromAllGroups is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target user Id.
       */
      @minLength(1)
      @path
      userId: string;
    },
    void
  >;

  /**
   * Remove a user from the target group.
   */
  @summary("Remove a user from the target group.")
  @route("/api/hubs/{hub}/users/{userId}/groups/{group}")
  @delete
  removeUserFromGroup is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target group name, which length should be greater than 0 and less than 1025.
       */
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      /**
       * Target user Id.
       */
      @minLength(1)
      @path
      userId: string;
    },
    void
  >;

  /**
   * Add a user to the target group.
   */
  @summary("Add a user to the target group.")
  @route("/api/hubs/{hub}/users/{userId}/groups/{group}")
  @put
  addUserToGroup is Azure.Core.Foundations.Operation<
    {
      /**
       * Target hub name, which should start with alphabetic characters and only contain
       * alpha-numeric characters or underscore.
       */
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      /**
       * Target group name, which length should be greater than 0 and less than 1025.
       */
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      /**
       * Target user Id.
       */
      @minLength(1)
      @path
      userId: string;
    },
    void
  >;
}
