import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.Analysis;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AnalysisServicesServerUpdateParameters.properties);

@@clientName(Servers.create::parameters.resource, "serverParameters");
@@clientName(Servers.update::parameters.properties, "serverUpdateParameters");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AnalysisServicesServer.properties);

@@clientLocation(ServersOperationGroup.listSkusForNew, Servers);
@@clientLocation(ServersOperationGroup.checkNameAvailability, Servers);
