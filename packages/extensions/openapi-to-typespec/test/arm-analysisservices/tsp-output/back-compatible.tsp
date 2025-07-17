import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.Analysis;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AnalysisServicesServerUpdateParameters.properties);

@@clientName(Servers.getDetails, "GetDetails");
@@clientName(Servers.create::parameters.resource, "serverParameters");
@@clientName(Servers.update::parameters.properties, "serverUpdateParameters");
@@clientName(Servers.listByResourceGroup, "ListByResourceGroup");
@@clientName(Servers.listSkusForExisting, "ListSkusForExisting");
@@clientName(Servers.listGatewayStatus, "ListGatewayStatus");
@@clientName(Servers.dissociateGateway, "DissociateGateway");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AnalysisServicesServer.properties);

@@clientLocation(ServersOperationGroup.listSkusForNew, "Servers");
@@clientName(ServersOperationGroup.listSkusForNew, "ListSkusForNew");
@@clientLocation(ServersOperationGroup.checkNameAvailability, "Servers");
@@clientName(ServersOperationGroup.checkNameAvailability,
  "CheckNameAvailability"
);
