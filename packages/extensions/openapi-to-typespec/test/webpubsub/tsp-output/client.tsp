import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using AzureWebPubSubServiceRESTAPI;

@@clientLocation(HealthApiOperationGroup.getServiceStatus, "HealthApi");

@@clientLocation(WebPubSubOperationGroup.addConnectionsToGroups, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.closeAllConnections, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.generateClientToken, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.removeConnectionsFromGroups,
  "WebPubSub"
);
@@clientLocation(WebPubSubOperationGroup.sendToAll, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.closeConnection, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.connectionExists, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.sendToConnection, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.removeConnectionFromAllGroups,
  "WebPubSub"
);
@@clientLocation(WebPubSubOperationGroup.groupExists, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.closeGroupConnections, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.sendToGroup, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.listConnectionsInGroup, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.removeConnectionFromGroup,
  "WebPubSub"
);
@@clientLocation(WebPubSubOperationGroup.addConnectionToGroup, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.revokePermission, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.checkPermission, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.grantPermission, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.userExists, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.closeUserConnections, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.sendToUser, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.removeUserFromAllGroups, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.removeUserFromGroup, "WebPubSub");
@@clientLocation(WebPubSubOperationGroup.addUserToGroup, "WebPubSub");
