import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.ResourceManager.Analysis;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AnalysisServicesServerUpdateParameters.properties);

@@clientName(AnalysisServicesServersOperationGroup.create::parameters.resource,
  "serverParameters"
);
@@clientName(AnalysisServicesServersOperationGroup.update::parameters.properties,
  "serverUpdateParameters"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AnalysisServicesServer.properties);
