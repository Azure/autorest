import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.AgFoodPlatform;

@@clientName(DataManagerForAgricultureExtensionListResponse.$skipToken,
  "skipToken"
);

@@clientName(DataManagerForAgricultureListResponse.$skipToken, "skipToken");

@@clientName(ExtensionListResponse.$skipToken, "skipToken");

@@clientName(SolutionListResponse.$skipToken, "skipToken");

@@clientName(DataManagerForAgricultureSolutionListResponse.$skipToken,
  "skipToken"
);

@@clientName(DataConnectors.createOrUpdate::parameters.resource, "body");

@@clientLocation(DataManagerForAgricultures.get,
  "DataManagerForAgricultureResources"
);
@@clientLocation(DataManagerForAgricultures.createOrUpdate,
  "DataManagerForAgricultureResources"
);
@@clientName(DataManagerForAgricultures.createOrUpdate::parameters.resource,
  "request"
);
@@clientLocation(DataManagerForAgricultures.update,
  "DataManagerForAgricultureResources"
);
@@clientName(DataManagerForAgricultures.update::parameters.properties,
  "request"
);
@@clientLocation(DataManagerForAgricultures.delete,
  "DataManagerForAgricultureResources"
);
@@clientLocation(DataManagerForAgricultures.listByResourceGroup,
  "DataManagerForAgricultureResources"
);
@@clientLocation(DataManagerForAgricultures.listBySubscription,
  "DataManagerForAgricultureResources"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DataManagerForAgriculture.properties);

@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "request"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

@@clientName(Extensions.createOrUpdate::parameters.resource, "requestBody");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Extension.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateLinkResource.properties);

@@clientName(Solutions.createOrUpdate::parameters.resource, "requestBody");

@@clientLocation(DataManagerForAgricultureSolutions.get,
  "SolutionsDiscoverability"
);
@@clientLocation(DataManagerForAgricultureSolutions.list,
  "SolutionsDiscoverability"
);

@@clientLocation(CheckNameAvailabilityOperationGroup.checkNameAvailability,
  "CheckNameAvailability"
);

@@clientLocation(OperationResultsOperationGroup.get, "OperationResults");
