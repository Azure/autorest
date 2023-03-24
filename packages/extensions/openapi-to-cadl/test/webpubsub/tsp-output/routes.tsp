import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureMessagingWebPubSubServiceClient;

interface HealthApiOperations {
  @summary("Get service health status.")
  @doc("Get service health status.")
  @route("/api/health")
  @head
  GetServiceStatus is Azure.Core.Foundations.Operation<{}, void>;
}

interface WebPubSubOperations {
  @summary("Close the connections in the hub.")
  @doc("Close the connections in the hub.")
  @route("/api/hubs/{hub}/:closeConnections")
  @post
  CloseAllConnections is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Exclude these connectionIds when closing the connections in the hub.")
      @query
      excluded: string[];

      @doc("The reason closing the client connection.")
      @query
      reason: string;
    },
    void
  >;

  @summary("Generate token for the client to connect Azure Web PubSub service.")
  @doc("Generate token for the client to connect Azure Web PubSub service.")
  @route("/api/hubs/{hub}/:generateToken")
  @post
  GenerateClientToken is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("User Id.")
      @query
      userId: string;

      @doc("Roles that the connection with the generated token will have.")
      @query
      role: string[];

      @doc("The expire time of the generated token.")
      @query
      minutesToExpire: int32;

      @doc("Groups that the connection will join when it connects.")
      @query
      group: string[];

      @doc("Accept header")
      @header
      Accept: "application/json, text/json";
    },
    ClientTokenResponse
  >;

  @summary("Broadcast content inside request body to all the connected client connections.")
  @doc("Broadcast content inside request body to all the connected client connections.")
  @route("/api/hubs/{hub}/:send")
  @post
  SendToAll is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Excluded connection Ids.")
      @query
      excluded: string[];

      @doc("""
Following OData filter syntax to filter out the subscribers receiving the
messages.
""")
      @query
      filter: string;

      @doc("Upload file type")
      @header
      `Content-Type`: ContentType;

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
  CloseConnection is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target connection Id.")
      @path
      connectionId: string;

      @doc("The reason closing the client connection.")
      @query
      reason: string;
    },
    void
  >;

  @summary("Check if the connection with the given connectionId exists.")
  @doc("Check if the connection with the given connectionId exists.")
  @route("/api/hubs/{hub}/connections/{connectionId}")
  @head
  ConnectionExists is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("The connection Id.")
      @path
      connectionId: string;
    },
    void
  >;

  @summary("Send content inside request body to the specific connection.")
  @doc("Send content inside request body to the specific connection.")
  @route("/api/hubs/{hub}/connections/{connectionId}/:send")
  @post
  SendToConnection is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("The connection Id.")
      @path
      connectionId: string;

      @doc("Upload file type")
      @header
      `Content-Type`: ContentType;

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
  RemoveConnectionFromAllGroups is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target connection Id.")
      @path
      connectionId: string;
    },
    void
  >;

  @summary("Check if there are any client connections inside the given group")
  @doc("Check if there are any client connections inside the given group")
  @route("/api/hubs/{hub}/groups/{group}")
  @head
  GroupExists is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @path
      group: string;
    },
    void
  >;

  @summary("Close connections in the specific group.")
  @doc("Close connections in the specific group.")
  @route("/api/hubs/{hub}/groups/{group}/:closeConnections")
  @post
  CloseGroupConnections is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @path
      group: string;

      @doc("Exclude these connectionIds when closing the connections in the group.")
      @query
      excluded: string[];

      @doc("The reason closing the client connection.")
      @query
      reason: string;
    },
    void
  >;

  @summary("Send content inside request body to a group of connections.")
  @doc("Send content inside request body to a group of connections.")
  @route("/api/hubs/{hub}/groups/{group}/:send")
  @post
  SendToGroup is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @path
      group: string;

      @doc("Excluded connection Ids")
      @query
      excluded: string[];

      @doc("""
Following OData filter syntax to filter out the subscribers receiving the
messages.
""")
      @query
      filter: string;

      @doc("Upload file type")
      @header
      `Content-Type`: ContentType;

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
  RemoveConnectionFromGroup is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @path
      group: string;

      @doc("Target connection Id.")
      @path
      connectionId: string;
    },
    void
  >;

  @summary("Add a connection to the target group.")
  @doc("Add a connection to the target group.")
  @route("/api/hubs/{hub}/groups/{group}/connections/{connectionId}")
  @put
  AddConnectionToGroup is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @path
      group: string;

      @doc("Target connection Id")
      @path
      connectionId: string;
    },
    void
  >;

  @summary("Revoke permission for the connection.")
  @doc("Revoke permission for the connection.")
  @route("/api/hubs/{hub}/permissions/{permission}/connections/{connectionId}")
  @delete
  RevokePermission is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("The permission: current supported actions are joinLeaveGroup and sendToGroup.")
      @path
      permission: WebPubSubPermission;

      @doc("Target connection Id.")
      @path
      connectionId: string;

      @doc("""
The meaning of the target depends on the specific permission. For
joinLeaveGroup and sendToGroup, targetName is a required parameter standing for
the group name.
""")
      @query
      targetName: string;
    },
    void
  >;

  @summary("Check if a connection has permission to the specified action.")
  @doc("Check if a connection has permission to the specified action.")
  @route("/api/hubs/{hub}/permissions/{permission}/connections/{connectionId}")
  @head
  CheckPermission is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("The permission: current supported actions are joinLeaveGroup and sendToGroup.")
      @path
      permission: WebPubSubPermission;

      @doc("Target connection Id.")
      @path
      connectionId: string;

      @doc("""
The meaning of the target depends on the specific permission. For
joinLeaveGroup and sendToGroup, targetName is a required parameter standing for
the group name.
""")
      @query
      targetName: string;
    },
    void
  >;

  @summary("Grant permission to the connection.")
  @doc("Grant permission to the connection.")
  @route("/api/hubs/{hub}/permissions/{permission}/connections/{connectionId}")
  @put
  GrantPermission is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("The permission: current supported actions are joinLeaveGroup and sendToGroup.")
      @path
      permission: WebPubSubPermission;

      @doc("Target connection Id.")
      @path
      connectionId: string;

      @doc("""
The meaning of the target depends on the specific permission. For
joinLeaveGroup and sendToGroup, targetName is a required parameter standing for
the group name.
""")
      @query
      targetName: string;
    },
    void
  >;

  @summary("Check if there are any client connections connected for the given user.")
  @doc("Check if there are any client connections connected for the given user.")
  @route("/api/hubs/{hub}/users/{userId}")
  @head
  UserExists is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target user Id.")
      @path
      userId: string;
    },
    void
  >;

  @summary("Close connections for the specific user.")
  @doc("Close connections for the specific user.")
  @route("/api/hubs/{hub}/users/{userId}/:closeConnections")
  @post
  CloseUserConnections is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("The user Id.")
      @path
      userId: string;

      @doc("Exclude these connectionIds when closing the connections for the user.")
      @query
      excluded: string[];

      @doc("The reason closing the client connection.")
      @query
      reason: string;
    },
    void
  >;

  @summary("Send content inside request body to the specific user.")
  @doc("Send content inside request body to the specific user.")
  @route("/api/hubs/{hub}/users/{userId}/:send")
  @post
  SendToUser is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("The user Id.")
      @path
      userId: string;

      @doc("""
Following OData filter syntax to filter out the subscribers receiving the
messages.
""")
      @query
      filter: string;

      @doc("Upload file type")
      @header
      `Content-Type`: ContentType;

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
  RemoveUserFromAllGroups is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target user Id.")
      @path
      userId: string;
    },
    void
  >;

  @summary("Remove a user from the target group.")
  @doc("Remove a user from the target group.")
  @route("/api/hubs/{hub}/users/{userId}/groups/{group}")
  @delete
  RemoveUserFromGroup is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @path
      group: string;

      @doc("Target user Id.")
      @path
      userId: string;
    },
    void
  >;

  @summary("Add a user to the target group.")
  @doc("Add a user to the target group.")
  @route("/api/hubs/{hub}/users/{userId}/groups/{group}")
  @put
  AddUserToGroup is Azure.Core.Foundations.Operation<
    {
      @doc("""
Target hub name, which should start with alphabetic characters and only contain
alpha-numeric characters or underscore.
""")
      @path
      hub: string;

      @doc("Target group name, which length should be greater than 0 and less than 1025.")
      @path
      group: string;

      @doc("Target user Id.")
      @path
      userId: string;
    },
    void
  >;
}
