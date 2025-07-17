import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using AzureWebPubSubServiceRESTAPI;

@@clientLocation(HealthApiOperationGroup.getServiceStatus, "HealthApi");
@@clientName(HealthApiOperationGroup.getServiceStatus, "GetServiceStatus");

@@clientLocation(WebPubSubOperationGroup.addConnectionsToGroups, "WebPubSub");
@@clientName(WebPubSubOperationGroup.addConnectionsToGroups,
  "AddConnectionsToGroups"
);
@@clientLocation(WebPubSubOperationGroup.closeAllConnections, "WebPubSub");
@@clientName(WebPubSubOperationGroup.closeAllConnections,
  "CloseAllConnections"
);
@@clientLocation(WebPubSubOperationGroup.generateClientToken, "WebPubSub");
@@clientName(WebPubSubOperationGroup.generateClientToken,
  "GenerateClientToken"
);
@@clientLocation(WebPubSubOperationGroup.removeConnectionsFromGroups,
  "WebPubSub"
);
@@clientName(WebPubSubOperationGroup.removeConnectionsFromGroups,
  "RemoveConnectionsFromGroups"
);
@@clientLocation(WebPubSubOperationGroup.sendToAll, "WebPubSub");
@@clientName(WebPubSubOperationGroup.sendToAll, "SendToAll");
@@clientLocation(WebPubSubOperationGroup.closeConnection, "WebPubSub");
@@clientName(WebPubSubOperationGroup.closeConnection, "CloseConnection");
@@clientLocation(WebPubSubOperationGroup.connectionExists, "WebPubSub");
@@clientName(WebPubSubOperationGroup.connectionExists, "ConnectionExists");
@@clientLocation(WebPubSubOperationGroup.sendToConnection, "WebPubSub");
@@clientName(WebPubSubOperationGroup.sendToConnection, "SendToConnection");
@@clientLocation(WebPubSubOperationGroup.removeConnectionFromAllGroups,
  "WebPubSub"
);
@@clientName(WebPubSubOperationGroup.removeConnectionFromAllGroups,
  "RemoveConnectionFromAllGroups"
);
@@clientLocation(WebPubSubOperationGroup.groupExists, "WebPubSub");
@@clientName(WebPubSubOperationGroup.groupExists, "GroupExists");
@@clientLocation(WebPubSubOperationGroup.closeGroupConnections, "WebPubSub");
@@clientName(WebPubSubOperationGroup.closeGroupConnections,
  "CloseGroupConnections"
);
@@clientLocation(WebPubSubOperationGroup.sendToGroup, "WebPubSub");
@@clientName(WebPubSubOperationGroup.sendToGroup, "SendToGroup");
@@clientLocation(WebPubSubOperationGroup.listConnectionsInGroup, "WebPubSub");
@@clientName(WebPubSubOperationGroup.listConnectionsInGroup,
  "ListConnectionsInGroup"
);
@@clientLocation(WebPubSubOperationGroup.removeConnectionFromGroup,
  "WebPubSub"
);
@@clientName(WebPubSubOperationGroup.removeConnectionFromGroup,
  "RemoveConnectionFromGroup"
);
@@clientLocation(WebPubSubOperationGroup.addConnectionToGroup, "WebPubSub");
@@clientName(WebPubSubOperationGroup.addConnectionToGroup,
  "AddConnectionToGroup"
);
@@clientLocation(WebPubSubOperationGroup.revokePermission, "WebPubSub");
@@clientName(WebPubSubOperationGroup.revokePermission, "RevokePermission");
@@clientLocation(WebPubSubOperationGroup.checkPermission, "WebPubSub");
@@clientName(WebPubSubOperationGroup.checkPermission, "CheckPermission");
@@clientLocation(WebPubSubOperationGroup.grantPermission, "WebPubSub");
@@clientName(WebPubSubOperationGroup.grantPermission, "GrantPermission");
@@clientLocation(WebPubSubOperationGroup.userExists, "WebPubSub");
@@clientName(WebPubSubOperationGroup.userExists, "UserExists");
@@clientLocation(WebPubSubOperationGroup.closeUserConnections, "WebPubSub");
@@clientName(WebPubSubOperationGroup.closeUserConnections,
  "CloseUserConnections"
);
@@clientLocation(WebPubSubOperationGroup.sendToUser, "WebPubSub");
@@clientName(WebPubSubOperationGroup.sendToUser, "SendToUser");
@@clientLocation(WebPubSubOperationGroup.removeUserFromAllGroups, "WebPubSub");
@@clientName(WebPubSubOperationGroup.removeUserFromAllGroups,
  "RemoveUserFromAllGroups"
);
@@clientLocation(WebPubSubOperationGroup.removeUserFromGroup, "WebPubSub");
@@clientName(WebPubSubOperationGroup.removeUserFromGroup,
  "RemoveUserFromGroup"
);
@@clientLocation(WebPubSubOperationGroup.addUserToGroup, "WebPubSub");
@@clientName(WebPubSubOperationGroup.addUserToGroup, "AddUserToGroup");
