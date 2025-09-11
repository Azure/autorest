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
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(DataManagerForAgriculture.properties);

@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "request"
);
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PrivateEndpointConnection.properties);

@@clientName(Extensions.createOrUpdate::parameters.resource, "requestBody");
#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(Extension.properties);

#suppress "@azure-tools/typespec-azure-core/no-legacy-usage" "Property flatten for SDK backward compatibility."
@@Legacy.flattenProperty(PrivateLinkResource.properties);

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
