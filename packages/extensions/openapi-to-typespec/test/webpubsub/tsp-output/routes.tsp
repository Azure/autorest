import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureWebPubSubServiceRESTAPI;

interface HealthApiOperations {
  @summary("Get service health status.")
  @doc("Get service health status.")
  @route("/api/health")
  @head
  getServiceStatus is Azure.Core.Foundations.Operation<{}, void>;
}

interface WebPubSubOperations {
  @summary("Add filtered connections to multiple groups.")
  @doc("Add filtered connections to multiple groups.")
  @route("/api/hubs/{hub}/:addToGroups")
  @post
  addConnectionsToGroups is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target groups and connection filter.")
      @body
      groupsToAdd: AddToGroupsRequest;
    },
    void
  >;

  @summary("Close the connections in the hub.")
  @doc("Close the connections in the hub.")
  @route("/api/hubs/{hub}/:closeConnections")
  @post
  closeAllConnections is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Exclude these connectionIds when closing the connections in the hub.")
      @query({
        name: "excluded",
        format: "multi",
      })
      excluded?: string[];

      @doc("The reason closing the client connection.")
      @query("reason")
      reason?: string;
    },
    void
  >;

  @summary("Generate token for the client to connect Azure Web PubSub service.")
  @doc("Generate token for the client to connect Azure Web PubSub service.")
  @route("/api/hubs/{hub}/:generateToken")
  @post
  generateClientToken is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("User Id.")
      @query("userId")
      userId?: string;

      @doc("Roles that the connection with the generated token will have.")
      @query({
        name: "role",
        format: "multi",
      })
      role?: string[];

      @doc("The expire time of the generated token.")
      @minValue(1)
      @query("minutesToExpire")
      minutesToExpire?: int32 = 60;

      @doc("Groups that the connection will join when it connects.")
      @query({
        name: "group",
        format: "multi",
      })
      group?: string[];

      @doc("Accept header")
      @header
      accept: "application/json, text/json";
    },
    ClientTokenResponse
  >;

  @summary("Remove filtered connections from multiple groups.")
  @doc("Remove filtered connections from multiple groups.")
  @route("/api/hubs/{hub}/:removeFromGroups")
  @post
  removeConnectionsFromGroups is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target groups and connection filter.")
      @body
      groupsToRemove: RemoveFromGroupsRequest;
    },
    void
  >;

  @summary("Broadcast content inside request body to all the connected client connections.")
  @doc("Broadcast content inside request body to all the connected client connections.")
  @route("/api/hubs/{hub}/:send")
  @post
  sendToAll is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Excluded connection Ids.")
      @query({
        name: "excluded",
        format: "multi",
      })
      excluded?: string[];

      @doc("""
Following OData filter syntax to filter out the subscribers receiving the
messages.
""")
      @query("filter")
      filter?: string;

      @doc("""
The time-to-live (TTL) value in seconds for messages sent to the service. 0 is
the default value, which means the message never expires. 300 is the maximum
value. If this parameter is non-zero, messages that are not consumed by the
client within the specified TTL will be dropped by the service. This parameter
can help when the client's bandwidth is limited.
""")
      @maxValue(300)
      @query("messageTtlSeconds")
      messageTtlSeconds?: int32;

      @doc("Upload file type")
      @header
      `content-type`: ContentType;

      @doc("The payload body.")
      @body
      message: bytes;
    },
    void
  >;

  @summary("Close the client connection.")
  @doc("Close the client connection.")
  @route("/api/hubs/{hub}/connections/{connectionId}")
  @delete
  closeConnection is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target connection Id.")
      @minLength(1)
      @path
      connectionId: string;

      @doc("The reason closing the client connection.")
      @query("reason")
      reason?: string;
    },
    void
  >;

  @summary("Check if the connection with the given connectionId exists.")
  @doc("Check if the connection with the given connectionId exists.")
  @route("/api/hubs/{hub}/connections/{connectionId}")
  @head
  connectionExists is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("The connection Id.")
      @minLength(1)
      @path
      connectionId: string;
    },
    void
  >;

  @summary("Send content inside request body to the specific connection.")
  @doc("Send content inside request body to the specific connection.")
  @route("/api/hubs/{hub}/connections/{connectionId}/:send")
  @post
  sendToConnection is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("The connection Id.")
      @minLength(1)
      @path
      connectionId: string;

      @doc("""
The time-to-live (TTL) value in seconds for messages sent to the service. 0 is
the default value, which means the message never expires. 300 is the maximum
value. If this parameter is non-zero, messages that are not consumed by the
client within the specified TTL will be dropped by the service. This parameter
can help when the client's bandwidth is limited.
""")
      @maxValue(300)
      @query("messageTtlSeconds")
      messageTtlSeconds?: int32;

      @doc("Upload file type")
      @header
      `content-type`: ContentType;

      @doc("The payload body.")
      @body
      message: bytes;
    },
    void
  >;

  @summary("Remove a connection from all groups.")
  @doc("Remove a connection from all groups.")
  @route("/api/hubs/{hub}/connections/{connectionId}/groups")
  @delete
  removeConnectionFromAllGroups is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target connection Id.")
      @minLength(1)
      @path
      connectionId: string;
    },
    void
  >;

  @summary("Check if there are any client connections inside the given group")
  @doc("Check if there are any client connections inside the given group")
  @route("/api/hubs/{hub}/groups/{group}")
  @head
  groupExists is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;
    },
    void
  >;

  @summary("Close connections in the specific group.")
  @doc("Close connections in the specific group.")
  @route("/api/hubs/{hub}/groups/{group}/:closeConnections")
  @post
  closeGroupConnections is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      @doc("Exclude these connectionIds when closing the connections in the group.")
      @query({
        name: "excluded",
        format: "multi",
      })
      excluded?: string[];

      @doc("The reason closing the client connection.")
      @query("reason")
      reason?: string;
    },
    void
  >;

  @summary("Send content inside request body to a group of connections.")
  @doc("Send content inside request body to a group of connections.")
  @route("/api/hubs/{hub}/groups/{group}/:send")
  @post
  sendToGroup is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      @doc("Excluded connection Ids")
      @query({
        name: "excluded",
        format: "multi",
      })
      excluded?: string[];

      @doc("""
Following OData filter syntax to filter out the subscribers receiving the
messages.
""")
      @query("filter")
      filter?: string;

      @doc("""
The time-to-live (TTL) value in seconds for messages sent to the service. 0 is
the default value, which means the message never expires. 300 is the maximum
value. If this parameter is non-zero, messages that are not consumed by the
client within the specified TTL will be dropped by the service. This parameter
can help when the client's bandwidth is limited.
""")
      @maxValue(300)
      @query("messageTtlSeconds")
      messageTtlSeconds?: int32;

      @doc("Upload file type")
      @header
      `content-type`: ContentType;

      @doc("The payload body.")
      @body
      message: bytes;
    },
    void
  >;

  @summary("Remove a connection from the target group.")
  @doc("Remove a connection from the target group.")
  @route("/api/hubs/{hub}/groups/{group}/connections/{connectionId}")
  @delete
  removeConnectionFromGroup is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      @doc("Target connection Id.")
      @minLength(1)
      @path
      connectionId: string;
    },
    void
  >;

  @summary("Add a connection to the target group.")
  @doc("Add a connection to the target group.")
  @route("/api/hubs/{hub}/groups/{group}/connections/{connectionId}")
  @put
  addConnectionToGroup is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      @doc("Target connection Id")
      @minLength(1)
      @path
      connectionId: string;
    },
    void
  >;

  @summary("Revoke permission for the connection.")
  @doc("Revoke permission for the connection.")
  @route("/api/hubs/{hub}/permissions/{permission}/connections/{connectionId}")
  @delete
  revokePermission is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("The permission: current supported actions are joinLeaveGroup and sendToGroup.")
      @path
      permission: WebPubSubPermission;

      @doc("Target connection Id.")
      @minLength(1)
      @path
      connectionId: string;

      @doc("""
The meaning of the target depends on the specific permission. For
joinLeaveGroup and sendToGroup, targetName is a required parameter standing for
the group name.
""")
      @query("targetName")
      targetName?: string;
    },
    void
  >;

  @summary("Check if a connection has permission to the specified action.")
  @doc("Check if a connection has permission to the specified action.")
  @route("/api/hubs/{hub}/permissions/{permission}/connections/{connectionId}")
  @head
  checkPermission is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("The permission: current supported actions are joinLeaveGroup and sendToGroup.")
      @path
      permission: WebPubSubPermission;

      @doc("Target connection Id.")
      @minLength(1)
      @path
      connectionId: string;

      @doc("""
The meaning of the target depends on the specific permission. For
joinLeaveGroup and sendToGroup, targetName is a required parameter standing for
the group name.
""")
      @query("targetName")
      targetName?: string;
    },
    void
  >;

  @summary("Grant permission to the connection.")
  @doc("Grant permission to the connection.")
  @route("/api/hubs/{hub}/permissions/{permission}/connections/{connectionId}")
  @put
  grantPermission is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("The permission: current supported actions are joinLeaveGroup and sendToGroup.")
      @path
      permission: WebPubSubPermission;

      @doc("Target connection Id.")
      @minLength(1)
      @path
      connectionId: string;

      @doc("""
The meaning of the target depends on the specific permission. For
joinLeaveGroup and sendToGroup, targetName is a required parameter standing for
the group name.
""")
      @query("targetName")
      targetName?: string;
    },
    void
  >;

  @summary("Check if there are any client connections connected for the given user.")
  @doc("Check if there are any client connections connected for the given user.")
  @route("/api/hubs/{hub}/users/{userId}")
  @head
  userExists is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target user Id.")
      @minLength(1)
      @path
      userId: string;
    },
    void
  >;

  @summary("Close connections for the specific user.")
  @doc("Close connections for the specific user.")
  @route("/api/hubs/{hub}/users/{userId}/:closeConnections")
  @post
  closeUserConnections is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("The user Id.")
      @minLength(1)
      @path
      userId: string;

      @doc("Exclude these connectionIds when closing the connections for the user.")
      @query({
        name: "excluded",
        format: "multi",
      })
      excluded?: string[];

      @doc("The reason closing the client connection.")
      @query("reason")
      reason?: string;
    },
    void
  >;

  @summary("Send content inside request body to the specific user.")
  @doc("Send content inside request body to the specific user.")
  @route("/api/hubs/{hub}/users/{userId}/:send")
  @post
  sendToUser is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("The user Id.")
      @minLength(1)
      @path
      userId: string;

      @doc("""
Following OData filter syntax to filter out the subscribers receiving the
messages.
""")
      @query("filter")
      filter?: string;

      @doc("""
The time-to-live (TTL) value in seconds for messages sent to the service. 0 is
the default value, which means the message never expires. 300 is the maximum
value. If this parameter is non-zero, messages that are not consumed by the
client within the specified TTL will be dropped by the service. This parameter
can help when the client's bandwidth is limited.
""")
      @maxValue(300)
      @query("messageTtlSeconds")
      messageTtlSeconds?: int32;

      @doc("Upload file type")
      @header
      `content-type`: ContentType;

      @doc("The payload body.")
      @body
      message: bytes;
    },
    void
  >;

  @summary("Remove a user from all groups.")
  @doc("Remove a user from all groups.")
  @route("/api/hubs/{hub}/users/{userId}/groups")
  @delete
  removeUserFromAllGroups is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target user Id.")
      @minLength(1)
      @path
      userId: string;
    },
    void
  >;

  @summary("Remove a user from the target group.")
  @doc("Remove a user from the target group.")
  @route("/api/hubs/{hub}/users/{userId}/groups/{group}")
  @delete
  removeUserFromGroup is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      @doc("Target user Id.")
      @minLength(1)
      @path
      userId: string;
    },
    void
  >;

  @summary("Add a user to the target group.")
  @doc("Add a user to the target group.")
  @route("/api/hubs/{hub}/users/{userId}/groups/{group}")
  @put
  addUserToGroup is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @pattern("^[A-Za-z][A-Za-z0-9_`,.[\\]]{0,127}$")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @maxLength(1024)
      @minLength(1)
      @pattern("^(?!\\s+$).+$")
      @path
      group: string;

      @doc("Target user Id.")
      @minLength(1)
      @path
      userId: string;
    },
    void
  >;
}
