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

@@clientLocation(ApplicationOperationGroup.list, "Application");
@@clientLocation(ApplicationOperationGroup.get, "Application");

@@clientLocation(PoolOperationGroup.listUsageMetrics, "Pool");
@@clientLocation(PoolOperationGroup.getAllLifetimeStatistics, "Pool");
@@clientLocation(PoolOperationGroup.add, "Pool");
@@clientLocation(PoolOperationGroup.list, "Pool");
@@clientLocation(PoolOperationGroup.delete, "Pool");
@@clientLocation(PoolOperationGroup.exists, "Pool");
@@clientLocation(PoolOperationGroup.get, "Pool");
@@clientLocation(PoolOperationGroup.patch, "Pool");
@@clientLocation(PoolOperationGroup.disableAutoScale, "Pool");
@@clientLocation(PoolOperationGroup.enableAutoScale, "Pool");
@@clientLocation(PoolOperationGroup.evaluateAutoScale, "Pool");
@@clientLocation(PoolOperationGroup.resize, "Pool");
@@clientLocation(PoolOperationGroup.stopResize, "Pool");
@@clientLocation(PoolOperationGroup.updateProperties, "Pool");
@@clientLocation(PoolOperationGroup.removeNodes, "Pool");

@@clientLocation(AccountOperationGroup.listSupportedImages, "Account");
@@clientLocation(AccountOperationGroup.listPoolNodeCounts, "Account");

@@clientLocation(JobOperationGroup.getAllLifetimeStatistics, "Job");
@@clientLocation(JobOperationGroup.delete, "Job");
@@clientLocation(JobOperationGroup.get, "Job");
@@clientLocation(JobOperationGroup.patch, "Job");
@@clientLocation(JobOperationGroup.update, "Job");
@@clientLocation(JobOperationGroup.disable, "Job");
@@clientLocation(JobOperationGroup.enable, "Job");
@@clientLocation(JobOperationGroup.terminate, "Job");
@@clientLocation(JobOperationGroup.add, "Job");
@@clientLocation(JobOperationGroup.list, "Job");
@@clientLocation(JobOperationGroup.listFromJobSchedule, "Job");
@@clientLocation(JobOperationGroup.listPreparationAndReleaseTaskStatus, "Job");
@@clientLocation(JobOperationGroup.getTaskCounts, "Job");

@@clientLocation(CertificateOperationGroup.add, "Certificate");
@@clientLocation(CertificateOperationGroup.list, "Certificate");
@@clientLocation(CertificateOperationGroup.cancelDeletion, "Certificate");
@@clientLocation(CertificateOperationGroup.delete, "Certificate");
@@clientLocation(CertificateOperationGroup.get, "Certificate");

@@clientLocation(FileOperationGroup.deleteFromTask, "File");
@@clientLocation(FileOperationGroup.getFromTask, "File");
@@clientLocation(FileOperationGroup.getPropertiesFromTask, "File");
@@clientLocation(FileOperationGroup.deleteFromComputeNode, "File");
@@clientLocation(FileOperationGroup.getFromComputeNode, "File");
@@clientLocation(FileOperationGroup.getPropertiesFromComputeNode, "File");
@@clientLocation(FileOperationGroup.listFromTask, "File");
@@clientLocation(FileOperationGroup.listFromComputeNode, "File");

@@clientLocation(JobScheduleOperationGroup.exists, "JobSchedule");
@@clientLocation(JobScheduleOperationGroup.delete, "JobSchedule");
@@clientLocation(JobScheduleOperationGroup.get, "JobSchedule");
@@clientLocation(JobScheduleOperationGroup.patch, "JobSchedule");
@@clientLocation(JobScheduleOperationGroup.update, "JobSchedule");
@@clientLocation(JobScheduleOperationGroup.disable, "JobSchedule");
@@clientLocation(JobScheduleOperationGroup.enable, "JobSchedule");
@@clientLocation(JobScheduleOperationGroup.terminate, "JobSchedule");
@@clientLocation(JobScheduleOperationGroup.add, "JobSchedule");
@@clientLocation(JobScheduleOperationGroup.list, "JobSchedule");

@@clientLocation(TaskOperationGroup.add, "Task");
@@clientLocation(TaskOperationGroup.list, "Task");
@@clientLocation(TaskOperationGroup.addCollection, "Task");
@@clientLocation(TaskOperationGroup.delete, "Task");
@@clientLocation(TaskOperationGroup.get, "Task");
@@clientLocation(TaskOperationGroup.update, "Task");
@@clientLocation(TaskOperationGroup.listSubtasks, "Task");
@@clientLocation(TaskOperationGroup.terminate, "Task");
@@clientLocation(TaskOperationGroup.reactivate, "Task");

@@clientLocation(ComputeNodeOperationGroup.addUser, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.deleteUser, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.updateUser, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.get, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.reboot, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.reimage, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.disableScheduling, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.enableScheduling, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.getRemoteLoginSettings,
  "ComputeNode"
);
@@clientLocation(ComputeNodeOperationGroup.getRemoteDesktop, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.uploadBatchServiceLogs,
  "ComputeNode"
);
@@clientLocation(ComputeNodeOperationGroup.list, "ComputeNode");

@@clientLocation(ComputeNodeExtensionOperationGroup.get,
  "ComputeNodeExtension"
);
@@clientLocation(ComputeNodeExtensionOperationGroup.list,
  "ComputeNodeExtension"
);
