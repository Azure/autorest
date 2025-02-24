import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.Batch;

@@clientName(ApplicationListResult.`odata.nextLink`, "odataNextLink");

@@clientName(PoolListUsageMetricsResult.`odata.nextLink`, "odataNextLink");

@@clientName(AccountListSupportedImagesResult.`odata.nextLink`,
  "odataNextLink"
);

@@clientName(PoolNodeCountsListResult.`odata.nextLink`, "odataNextLink");

@@clientName(CertificateListResult.`odata.nextLink`, "odataNextLink");

@@clientName(NodeFileListResult.`odata.nextLink`, "odataNextLink");

@@clientName(ContainerRegistry.username, "userName");

@@clientName(UserIdentity.username, "userName");

@@clientName(BatchJobScheduleListResult.`odata.nextLink`, "odataNextLink");

@@clientName(BatchJobListResult.`odata.nextLink`, "odataNextLink");

@@clientName(BatchJobListPreparationAndReleaseTaskStatusResult.`odata.nextLink`,
  "odataNextLink"
);

@@clientName(BatchPoolListResult.`odata.nextLink`, "odataNextLink");

@@clientName(BatchTaskListResult.`odata.nextLink`, "odataNextLink");

@@clientName(InboundEndpoint.publicFQDN, "publicFqdn");

@@clientName(ComputeNodeListResult.`odata.nextLink`, "odataNextLink");

@@clientName(NodeVMExtensionList.`odata.nextLink`, "odataNextLink");
