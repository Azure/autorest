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
@@clientName(PoolOperationGroup.listUsageMetrics, "ListUsageMetrics");
@@clientLocation(PoolOperationGroup.getAllLifetimeStatistics, "Pool");
@@clientName(PoolOperationGroup.getAllLifetimeStatistics,
  "GetAllLifetimeStatistics"
);
@@clientLocation(PoolOperationGroup.add, "Pool");
@@clientLocation(PoolOperationGroup.list, "Pool");
@@clientLocation(PoolOperationGroup.delete, "Pool");
@@clientLocation(PoolOperationGroup.exists, "Pool");
@@clientLocation(PoolOperationGroup.get, "Pool");
@@clientLocation(PoolOperationGroup.patch, "Pool");
@@clientLocation(PoolOperationGroup.disableAutoScale, "Pool");
@@clientName(PoolOperationGroup.disableAutoScale, "DisableAutoScale");
@@clientLocation(PoolOperationGroup.enableAutoScale, "Pool");
@@clientName(PoolOperationGroup.enableAutoScale, "EnableAutoScale");
@@clientLocation(PoolOperationGroup.evaluateAutoScale, "Pool");
@@clientName(PoolOperationGroup.evaluateAutoScale, "EvaluateAutoScale");
@@clientLocation(PoolOperationGroup.resize, "Pool");
@@clientLocation(PoolOperationGroup.stopResize, "Pool");
@@clientName(PoolOperationGroup.stopResize, "StopResize");
@@clientLocation(PoolOperationGroup.updateProperties, "Pool");
@@clientName(PoolOperationGroup.updateProperties, "UpdateProperties");
@@clientLocation(PoolOperationGroup.removeNodes, "Pool");
@@clientName(PoolOperationGroup.removeNodes, "RemoveNodes");

@@clientLocation(AccountOperationGroup.listSupportedImages, "Account");
@@clientName(AccountOperationGroup.listSupportedImages, "ListSupportedImages");
@@clientLocation(AccountOperationGroup.listPoolNodeCounts, "Account");
@@clientName(AccountOperationGroup.listPoolNodeCounts, "ListPoolNodeCounts");

@@clientLocation(JobOperationGroup.getAllLifetimeStatistics, "Job");
@@clientName(JobOperationGroup.getAllLifetimeStatistics,
  "GetAllLifetimeStatistics"
);
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
@@clientName(JobOperationGroup.listFromJobSchedule, "ListFromJobSchedule");
@@clientLocation(JobOperationGroup.listPreparationAndReleaseTaskStatus, "Job");
@@clientName(JobOperationGroup.listPreparationAndReleaseTaskStatus,
  "ListPreparationAndReleaseTaskStatus"
);
@@clientLocation(JobOperationGroup.getTaskCounts, "Job");
@@clientName(JobOperationGroup.getTaskCounts, "GetTaskCounts");

@@clientLocation(CertificateOperationGroup.add, "Certificate");
@@clientLocation(CertificateOperationGroup.list, "Certificate");
@@clientLocation(CertificateOperationGroup.cancelDeletion, "Certificate");
@@clientName(CertificateOperationGroup.cancelDeletion, "CancelDeletion");
@@clientLocation(CertificateOperationGroup.delete, "Certificate");
@@clientLocation(CertificateOperationGroup.get, "Certificate");

@@clientLocation(FileOperationGroup.deleteFromTask, "File");
@@clientName(FileOperationGroup.deleteFromTask, "DeleteFromTask");
@@clientLocation(FileOperationGroup.getFromTask, "File");
@@clientName(FileOperationGroup.getFromTask, "GetFromTask");
@@clientLocation(FileOperationGroup.getPropertiesFromTask, "File");
@@clientName(FileOperationGroup.getPropertiesFromTask, "GetPropertiesFromTask");
@@clientLocation(FileOperationGroup.deleteFromComputeNode, "File");
@@clientName(FileOperationGroup.deleteFromComputeNode, "DeleteFromComputeNode");
@@clientLocation(FileOperationGroup.getFromComputeNode, "File");
@@clientName(FileOperationGroup.getFromComputeNode, "GetFromComputeNode");
@@clientLocation(FileOperationGroup.getPropertiesFromComputeNode, "File");
@@clientName(FileOperationGroup.getPropertiesFromComputeNode,
  "GetPropertiesFromComputeNode"
);
@@clientLocation(FileOperationGroup.listFromTask, "File");
@@clientName(FileOperationGroup.listFromTask, "ListFromTask");
@@clientLocation(FileOperationGroup.listFromComputeNode, "File");
@@clientName(FileOperationGroup.listFromComputeNode, "ListFromComputeNode");

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
@@clientName(TaskOperationGroup.addCollection, "AddCollection");
@@clientLocation(TaskOperationGroup.delete, "Task");
@@clientLocation(TaskOperationGroup.get, "Task");
@@clientLocation(TaskOperationGroup.update, "Task");
@@clientLocation(TaskOperationGroup.listSubtasks, "Task");
@@clientName(TaskOperationGroup.listSubtasks, "ListSubtasks");
@@clientLocation(TaskOperationGroup.terminate, "Task");
@@clientLocation(TaskOperationGroup.reactivate, "Task");

@@clientLocation(ComputeNodeOperationGroup.addUser, "ComputeNode");
@@clientName(ComputeNodeOperationGroup.addUser, "AddUser");
@@clientLocation(ComputeNodeOperationGroup.deleteUser, "ComputeNode");
@@clientName(ComputeNodeOperationGroup.deleteUser, "DeleteUser");
@@clientLocation(ComputeNodeOperationGroup.updateUser, "ComputeNode");
@@clientName(ComputeNodeOperationGroup.updateUser, "UpdateUser");
@@clientLocation(ComputeNodeOperationGroup.get, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.reboot, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.reimage, "ComputeNode");
@@clientLocation(ComputeNodeOperationGroup.disableScheduling, "ComputeNode");
@@clientName(ComputeNodeOperationGroup.disableScheduling, "DisableScheduling");
@@clientLocation(ComputeNodeOperationGroup.enableScheduling, "ComputeNode");
@@clientName(ComputeNodeOperationGroup.enableScheduling, "EnableScheduling");
@@clientLocation(ComputeNodeOperationGroup.getRemoteLoginSettings,
  "ComputeNode"
);
@@clientName(ComputeNodeOperationGroup.getRemoteLoginSettings,
  "GetRemoteLoginSettings"
);
@@clientLocation(ComputeNodeOperationGroup.getRemoteDesktop, "ComputeNode");
@@clientName(ComputeNodeOperationGroup.getRemoteDesktop, "GetRemoteDesktop");
@@clientLocation(ComputeNodeOperationGroup.uploadBatchServiceLogs,
  "ComputeNode"
);
@@clientName(ComputeNodeOperationGroup.uploadBatchServiceLogs,
  "UploadBatchServiceLogs"
);
@@clientLocation(ComputeNodeOperationGroup.list, "ComputeNode");

@@clientLocation(ComputeNodeExtensionOperationGroup.get,
  "ComputeNodeExtension"
);
@@clientLocation(ComputeNodeExtensionOperationGroup.list,
  "ComputeNodeExtension"
);
