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

@@clientLocation(DataConnectors.get, "DataConnectors");
@@clientLocation(DataConnectors.createOrUpdate, "DataConnectors");
@@clientName(DataConnectors.createOrUpdate, "CreateOrUpdate");
@@clientName(DataConnectors.createOrUpdate::parameters.resource, "body");
@@clientLocation(DataConnectors.delete, "DataConnectors");
@@clientLocation(DataConnectors.list, "DataConnectors");

@@clientLocation(DataManagerForAgricultureExtensions.get,
  "DataManagerForAgricultureExtensions"
);
@@clientLocation(DataManagerForAgricultureExtensions.list,
  "DataManagerForAgricultureExtensions"
);

@@clientLocation(DataManagerForAgricultures.get,
  "DataManagerForAgricultureResources"
);
@@clientLocation(DataManagerForAgricultures.createOrUpdate,
  "DataManagerForAgricultureResources"
);
@@clientName(DataManagerForAgricultures.createOrUpdate, "CreateOrUpdate");
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
@@clientName(DataManagerForAgricultures.listByResourceGroup,
  "ListByResourceGroup"
);
@@clientLocation(DataManagerForAgricultures.listBySubscription,
  "DataManagerForAgricultureResources"
);
@@clientName(DataManagerForAgricultures.listBySubscription,
  "ListBySubscription"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DataManagerForAgriculture.properties);

@@clientLocation(PrivateEndpointConnections.get, "PrivateEndpointConnections");
@@clientLocation(PrivateEndpointConnections.createOrUpdate,
  "PrivateEndpointConnections"
);
@@clientName(PrivateEndpointConnections.createOrUpdate, "CreateOrUpdate");
@@clientName(PrivateEndpointConnections.createOrUpdate::parameters.resource,
  "request"
);
@@clientLocation(PrivateEndpointConnections.delete,
  "PrivateEndpointConnections"
);
@@clientLocation(PrivateEndpointConnections.listByResource,
  "PrivateEndpointConnections"
);
@@clientName(PrivateEndpointConnections.listByResource, "ListByResource");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateEndpointConnection.properties);

@@clientName(Extensions.createOrUpdate, "CreateOrUpdate");
@@clientName(Extensions.createOrUpdate::parameters.resource, "requestBody");
@@clientName(Extensions.listByDataManagerForAgriculture,
  "ListByDataManagerForAgriculture"
);
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(Extension.properties);

@@clientLocation(PrivateLinkResources.get, "PrivateLinkResources");
@@clientLocation(PrivateLinkResources.listByResource, "PrivateLinkResources");
@@clientName(PrivateLinkResources.listByResource, "ListByResource");
#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(PrivateLinkResource.properties);

@@clientName(Solutions.createOrUpdate, "CreateOrUpdate");
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
@@clientName(CheckNameAvailabilityOperationGroup.checkNameAvailability,
  "CheckNameAvailability"
);

@@clientLocation(OperationResultsOperationGroup.get, "OperationResults");
