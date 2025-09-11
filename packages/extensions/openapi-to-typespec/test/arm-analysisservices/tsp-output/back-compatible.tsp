import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.Analysis;

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AnalysisServicesServerUpdateParameters.properties);

@@clientName(Servers.create::parameters.resource, "serverParameters");
@@clientName(Servers.update::parameters.properties, "serverUpdateParameters");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(AnalysisServicesServer.properties);

@@clientLocation(ServersOperationGroup.listSkusForNew, Servers);
@@clientLocation(ServersOperationGroup.checkNameAvailability, Servers);
