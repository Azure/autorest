import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace Azure.Batch;

@Azure.Core.fixed
enum OSType {
  @doc("The Linux operating system.") linux,
  @doc("The Windows operating system.") windows,
}
@Azure.Core.fixed
enum VerificationType {
  @doc("""
The Image is guaranteed to be compatible with the associated Compute Node agent
SKU and all Batch features have been confirmed to work as expected.
""")
  verified,
  @doc("""
The associated Compute Node agent SKU should have binary compatibility with the
Image, but specific functionality has not been verified.
""")
  unverified,
}
@Azure.Core.fixed
enum CertificateState {
  @doc("The Certificate is available for use in Pools.") active,
  @doc("""
The user has requested that the Certificate be deleted, but the delete
operation has not yet completed. You may not reference the Certificate when
creating or updating Pools.
""")
  deleting,
  @doc("""
The user requested that the Certificate be deleted, but there are Pools that
still have references to the Certificate, or it is still installed on one or
more Nodes. (The latter can occur if the Certificate has been removed from the
Pool, but the Compute Node has not yet restarted. Compute Nodes refresh their
Certificates only when they restart.) You may use the cancel Certificate delete
operation to cancel the delete, or the delete Certificate operation to retry
the delete.
""")
  deleteFailed: "deletefailed",
}
@Azure.Core.fixed
enum CertificateFormat {
  @doc("The Certificate is a PFX (PKCS#12) formatted Certificate or Certificate chain.")
  pfx,
  @doc("The Certificate is a base64-encoded X.509 Certificate.") cer,
}
@Azure.Core.fixed
enum JobScheduleState {
  @doc("The Job Schedule is active and will create Jobs as per its schedule.")
  active,
  @doc("""
The Job Schedule has terminated, either by reaching its end time or by the user
terminating it explicitly.
""")
  completed,
  @doc("""
The user has disabled the Job Schedule. The scheduler will not initiate any new
Jobs will on this schedule, but any existing active Job will continue to run.
""")
  disabled,
  @doc("""
The Job Schedule has no more work to do, or has been explicitly terminated by
the user, but the termination operation is still in progress. The scheduler
will not initiate any new Jobs for this Job Schedule, nor is any existing Job
active.
""")
  terminating,
  @doc("""
The user has requested that the Job Schedule be deleted, but the delete
operation is still in progress. The scheduler will not initiate any new Jobs
for this Job Schedule, and will delete any existing Jobs and Tasks under the
Job Schedule, including any active Job. The Job Schedule will be deleted when
all Jobs and Tasks under the Job Schedule have been deleted.
""")
  deleting,
}
@Azure.Core.fixed
enum OnAllTasksComplete {
  @doc("""
Do nothing. The Job remains active unless terminated or disabled by some other
means.
""")
  noAction: "noaction",
  @doc("Terminate the Job. The Job's terminateReason is set to 'AllTasksComplete'.")
  terminateJob: "terminatejob",
}
@Azure.Core.fixed
enum OnTaskFailure {
  @doc("""
Do nothing. The Job remains active unless terminated or disabled by some other
means.
""")
  noAction: "noaction",
  @doc("""
Take the action associated with the Task exit condition in the Task's
exitConditions collection. (This may still result in no action being taken, if
that is what the Task specifies.)
""")
  performExitOptionsJobAction: "performexitoptionsjobaction",
}
@Azure.Core.fixed
enum ContainerWorkingDirectory {
  @doc("""
Use the standard Batch service Task working directory, which will contain the
Task Resource Files populated by Batch.
""")
  taskWorkingDirectory,
  @doc("""
Use the working directory defined in the container Image. Beware that this
directory will not contain the Resource Files downloaded by Batch.
""")
  containerImageDefault,
}
@Azure.Core.fixed
enum OutputFileUploadCondition {
  @doc("Upload the file(s) only after the Task process exits with an exit code of 0.")
  taskSuccess: "tasksuccess",
  @doc("Upload the file(s) only after the Task process exits with a nonzero exit code.")
  taskFailure: "taskfailure",
  @doc("""
Upload the file(s) after the Task process exits, no matter what the exit code
was.
""")
  taskCompletion: "taskcompletion",
}
@Azure.Core.fixed
enum AutoUserScope {
  @doc("Specifies that the service should create a new user for the Task.")
  task,
  @doc("""
Specifies that the Task runs as the common auto user Account which is created
on every Compute Node in a Pool.
""")
  pool,
}
@Azure.Core.fixed
enum ElevationLevel {
  @doc("The user is a standard user without elevated access.")
  nonAdmin: "nonadmin",
  @doc("""
The user is a user with elevated access and operates with full Administrator
permissions.
""")
  admin,
}
@Azure.Core.fixed
enum PoolLifetimeOption {
  @doc("""
The Pool exists for the lifetime of the Job Schedule. The Batch Service creates
the Pool when it creates the first Job on the schedule. You may apply this
option only to Job Schedules, not to Jobs.
""")
  jobSchedule: "jobschedule",
  @doc("""
The Pool exists for the lifetime of the Job to which it is dedicated. The Batch
service creates the Pool when it creates the Job. If the 'job' option is
applied to a Job Schedule, the Batch service creates a new auto Pool for every
Job created on the schedule.
""")
  job,
}
@Azure.Core.fixed
enum CachingType {
  @doc("The caching mode for the disk is not enabled.") none,
  @doc("The caching mode for the disk is read only.") readOnly: "readonly",
  @doc("The caching mode for the disk is read and write.")
  readWrite: "readwrite",
}
@Azure.Core.fixed
enum StorageAccountType {
  @doc("The data disk should use standard locally redundant storage.")
  StandardLRS: "standard_lrs",
  @doc("The data disk should use premium locally redundant storage.")
  PremiumLRS: "premium_lrs",
}
@Azure.Core.fixed
enum DiskEncryptionTarget {
  @doc("The OS Disk on the compute node is encrypted.") OsDisk: "osdisk",
  @doc("""
The temporary disk on the compute node is encrypted. On Linux this encryption
applies to other partitions (such as those on mounted data disks) when
encryption occurs at boot time.
""")
  TemporaryDisk: "temporarydisk",
}
@Azure.Core.fixed
enum NodePlacementPolicyType {
  @doc("All nodes in the pool will be allocated in the same region.") regional,
  @doc("""
Nodes in the pool will be spread across different availability zones with best
effort balancing.
""")
  zonal,
}
@Azure.Core.fixed
enum ComputeNodeFillType {
  @doc("Tasks should be assigned evenly across all Compute Nodes in the Pool.")
  spread,
  @doc("""
As many Tasks as possible (taskSlotsPerNode) should be assigned to each Compute
Node in the Pool before any Tasks are assigned to the next Compute Node in the
Pool.
""")
  pack,
}
@Azure.Core.fixed
enum DynamicVNetAssignmentScope {
  @doc("No dynamic VNet assignment is enabled.") none,
  @doc("Dynamic VNet assignment is done per-job.") job,
}
@Azure.Core.fixed
enum InboundEndpointProtocol {
  @doc("Use TCP for the endpoint.") tcp,
  @doc("Use UDP for the endpoint.") udp,
}
@Azure.Core.fixed
enum NetworkSecurityGroupRuleAccess {
  @doc("Allow access.") allow,
  @doc("Deny access.") deny,
}
@Azure.Core.fixed
enum IPAddressProvisioningType {
  @doc("""
A public IP will be created and managed by Batch. There may be multiple public
IPs depending on the size of the Pool.
""")
  batchManaged: "batchmanaged",
  @doc("""
Public IPs are provided by the user and will be used to provision the Compute
Nodes.
""")
  userManaged: "usermanaged",
  @doc("No public IP Address will be created.")
  noPublicIPAddresses: "nopublicipaddresses",
}
@Azure.Core.fixed
enum CertificateStoreLocation {
  @doc("Certificates should be installed to the CurrentUser Certificate store.")
  currentUser: "currentuser",
  @doc("Certificates should be installed to the LocalMachine Certificate store.")
  localMachine: "localmachine",
}
@Azure.Core.fixed
enum CertificateVisibility {
  @doc("""
The Certificate should be visible to the user account under which the StartTask
is run. Note that if AutoUser Scope is Pool for both the StartTask and a Task,
this certificate will be visible to the Task as well.
""")
  startTask: "starttask",
  @doc("""
The Certificate should be visible to the user accounts under which Job Tasks
are run.
""")
  task,
  @doc("""
The Certificate should be visible to the user accounts under which users
remotely access the Compute Node.
""")
  remoteUser: "remoteuser",
}
@Azure.Core.fixed
enum LoginMode {
  @doc("""
The LOGON32_LOGON_BATCH Win32 login mode. The batch login mode is recommended
for long running parallel processes.
""")
  batch,
  @doc("""
The LOGON32_LOGON_INTERACTIVE Win32 login mode. UAC is enabled on Windows
VirtualMachineConfiguration Pools. If this option is used with an elevated user
identity in a Windows VirtualMachineConfiguration Pool, the user session will
not be elevated unless the application executed by the Task command line is
configured to always require administrative privilege or to always require
maximum privilege.
""")
  interactive,
}
@Azure.Core.fixed
enum JobState {
  @doc("The Job is available to have Tasks scheduled.") active,
  @doc("""
A user has requested that the Job be disabled, but the disable operation is
still in progress (for example, waiting for Tasks to terminate).
""")
  disabling,
  @doc("""
A user has disabled the Job. No Tasks are running, and no new Tasks will be
scheduled.
""")
  disabled,
  @doc("""
A user has requested that the Job be enabled, but the enable operation is still
in progress.
""")
  enabling,
  @doc("""
The Job is about to complete, either because a Job Manager Task has completed
or because the user has terminated the Job, but the terminate operation is
still in progress (for example, because Job Release Tasks are running).
""")
  terminating,
  @doc("""
All Tasks have terminated, and the system will not accept any more Tasks or any
further changes to the Job.
""")
  completed,
  @doc("""
A user has requested that the Job be deleted, but the delete operation is still
in progress (for example, because the system is still terminating running
Tasks).
""")
  deleting,
}
@Azure.Core.fixed
enum ErrorCategory {
  @doc("The error is due to a user issue, such as misconfiguration.")
  userError: "usererror",
  @doc("The error is due to an internal server issue.")
  serverError: "servererror",
}
@Azure.Core.fixed
enum DisableJobOption {
  @doc("""
Terminate running Tasks and requeue them. The Tasks will run again when the Job
is enabled.
""")
  requeue,
  @doc("""
Terminate running Tasks. The Tasks will be completed with failureInfo
indicating that they were terminated, and will not run again.
""")
  terminate,
  @doc("Allow currently running Tasks to complete.") wait,
}
@Azure.Core.fixed
enum JobPreparationTaskState {
  @doc("The Task is currently running (including retrying).") running,
  @doc("""
The Task has exited with exit code 0, or the Task has exhausted its retry
limit, or the Batch service was unable to start the Task due to Task
preparation errors (such as resource file download failures).
""")
  completed,
}
@Azure.Core.fixed
enum TaskExecutionResult {
  @doc("The Task ran successfully.") success,
  @doc("""
There was an error during processing of the Task. The failure may have occurred
before the Task process was launched, while the Task process was executing, or
after the Task process exited.
""")
  failure,
}
@Azure.Core.fixed
enum JobReleaseTaskState {
  @doc("The Task is currently running (including retrying).") running,
  @doc("""
The Task has exited with exit code 0, or the Task has exhausted its retry
limit, or the Batch service was unable to start the Task due to Task
preparation errors (such as resource file download failures).
""")
  completed,
}
@Azure.Core.fixed
enum PoolState {
  @doc("The Pool is available to run Tasks subject to the availability of Compute Nodes.")
  active,
  @doc("""
The user has requested that the Pool be deleted, but the delete operation has
not yet completed.
""")
  deleting,
}
@Azure.Core.fixed
enum AllocationState {
  @doc("""
The Pool is not resizing. There are no changes to the number of Compute Nodes
in the Pool in progress. A Pool enters this state when it is created and when
no operations are being performed on the Pool to change the number of Compute
Nodes.
""")
  steady,
  @doc("""
The Pool is resizing; that is, Compute Nodes are being added to or removed from
the Pool.
""")
  resizing,
  @doc("""
The Pool was resizing, but the user has requested that the resize be stopped,
but the stop request has not yet been completed.
""")
  stopping,
}
@Azure.Core.fixed
enum PoolIdentityType {
  @doc("Batch pool has user assigned identities with it.") UserAssigned,
  @doc("""
Batch pool has no identity associated with it. Setting `None` in update pool
will remove existing identities.
""")
  None,
}
@Azure.Core.fixed
enum ComputeNodeDeallocationOption {
  @doc("""
Terminate running Task processes and requeue the Tasks. The Tasks will run
again when a Compute Node is available. Remove Compute Nodes as soon as Tasks
have been terminated.
""")
  requeue,
  @doc("""
Terminate running Tasks. The Tasks will be completed with failureInfo
indicating that they were terminated, and will not run again. Remove Compute
Nodes as soon as Tasks have been terminated.
""")
  terminate,
  @doc("""
Allow currently running Tasks to complete. Schedule no new Tasks while waiting.
Remove Compute Nodes when all Tasks have completed.
""")
  taskCompletion: "taskcompletion",
  @doc("""
Allow currently running Tasks to complete, then wait for all Task data
retention periods to expire. Schedule no new Tasks while waiting. Remove
Compute Nodes when all Task retention periods have expired.
""")
  retainedData: "retaineddata",
}
@Azure.Core.fixed
enum JobAction {
  @doc("Take no action.") none,
  @doc("""
Disable the Job. This is equivalent to calling the disable Job API, with a
disableTasks value of requeue.
""")
  disable,
  @doc("""
Terminate the Job. The terminateReason in the Job's executionInfo is set to
\"TaskFailed\".
""")
  terminate,
}
@Azure.Core.fixed
enum DependencyAction {
  @doc("""
Satisfy tasks waiting on this task; once all dependencies are satisfied, the
task will be scheduled to run.
""")
  satisfy,
  @doc("Blocks tasks waiting on this task, preventing them from being scheduled.")
  block,
}
@Azure.Core.fixed
enum TaskState {
  @doc("""
The Task is queued and able to run, but is not currently assigned to a Compute
Node. A Task enters this state when it is created, when it is enabled after
being disabled, or when it is awaiting a retry after a failed run.
""")
  active,
  @doc("""
The Task has been assigned to a Compute Node, but is waiting for a required Job
Preparation Task to complete on the Compute Node. If the Job Preparation Task
succeeds, the Task will move to running. If the Job Preparation Task fails, the
Task will return to active and will be eligible to be assigned to a different
Compute Node.
""")
  preparing,
  @doc("""
The Task is running on a Compute Node. This includes task-level preparation
such as downloading resource files or deploying Packages specified on the Task
- it does not necessarily mean that the Task command line has started
executing.
""")
  running,
  @doc("""
The Task is no longer eligible to run, usually because the Task has finished
successfully, or the Task has finished unsuccessfully and has exhausted its
retry limit. A Task is also marked as completed if an error occurred launching
the Task, or when the Task has been terminated.
""")
  completed,
}
@Azure.Core.fixed
enum TaskAddStatus {
  @doc("The Task was added successfully.") success,
  @doc("""
The Task failed to add due to a client error and should not be retried without
modifying the request as appropriate.
""")
  clientError: "clienterror",
  @doc("""
Task failed to add due to a server error and can be retried without
modification.
""")
  serverError: "servererror",
}
@Azure.Core.fixed
enum SubtaskState {
  @doc("""
The Task has been assigned to a Compute Node, but is waiting for a required Job
Preparation Task to complete on the Compute Node. If the Job Preparation Task
succeeds, the Task will move to running. If the Job Preparation Task fails, the
Task will return to active and will be eligible to be assigned to a different
Compute Node.
""")
  preparing,
  @doc("""
The Task is running on a Compute Node. This includes task-level preparation
such as downloading resource files or deploying Packages specified on the Task
- it does not necessarily mean that the Task command line has started
executing.
""")
  running,
  @doc("""
The Task is no longer eligible to run, usually because the Task has finished
successfully, or the Task has finished unsuccessfully and has exhausted its
retry limit. A Task is also marked as completed if an error occurred launching
the Task, or when the Task has been terminated.
""")
  completed,
}
@Azure.Core.fixed
enum ComputeNodeState {
  @doc("The Compute Node is not currently running a Task.") idle,
  @doc("The Compute Node is rebooting.") rebooting,
  @doc("The Compute Node is reimaging.") reimaging,
  @doc("The Compute Node is running one or more Tasks (other than a StartTask).")
  running,
  @doc("The Compute Node cannot be used for Task execution due to errors.")
  unusable,
  @doc("""
The Batch service has obtained the underlying virtual machine from Azure
Compute, but it has not yet started to join the Pool.
""")
  creating,
  @doc("The Batch service is starting on the underlying virtual machine.")
  starting,
  @doc("""
The StartTask has started running on the Compute Node, but waitForSuccess is
set and the StartTask has not yet completed.
""")
  waitingForStartTask: "waitingforstarttask",
  @doc("""
The StartTask has failed on the Compute Node (and exhausted all retries), and
waitForSuccess is set. The Compute Node is not usable for running Tasks.
""")
  startTaskFailed: "starttaskfailed",
  @doc("""
The Batch service has lost contact with the Compute Node, and does not know its
true state.
""")
  `unknown`,
  @doc("""
The Compute Node is leaving the Pool, either because the user explicitly
removed it or because the Pool is resizing or autoscaling down.
""")
  leavingPool: "leavingpool",
  @doc("""
The Compute Node is not currently running a Task, and scheduling of new Tasks
to the Compute Node is disabled.
""")
  offline,
  @doc("""
The Spot/Low-priority Compute Node has been preempted. Tasks which were running
on the Compute Node when it was preempted will be rescheduled when another
Compute Node becomes available.
""")
  preempted,
}
@Azure.Core.fixed
enum SchedulingState {
  @doc("Tasks can be scheduled on the Compute Node.") enabled,
  @doc("""
No new Tasks will be scheduled on the Compute Node. Tasks already running on
the Compute Node may still run to completion. All Compute Nodes start with
scheduling enabled.
""")
  disabled,
}
@Azure.Core.fixed
enum StartTaskState {
  @doc("The StartTask is currently running.") running,
  @doc("""
The StartTask has exited with exit code 0, or the StartTask has failed and the
retry limit has reached, or the StartTask process did not run due to Task
preparation errors (such as resource file download failures).
""")
  completed,
}
@Azure.Core.fixed
enum ComputeNodeRebootOption {
  @doc("""
Terminate running Task processes and requeue the Tasks. The Tasks will run
again when a Compute Node is available. Restart the Compute Node as soon as
Tasks have been terminated.
""")
  requeue,
  @doc("""
Terminate running Tasks. The Tasks will be completed with failureInfo
indicating that they were terminated, and will not run again. Restart the
Compute Node as soon as Tasks have been terminated.
""")
  terminate,
  @doc("""
Allow currently running Tasks to complete. Schedule no new Tasks while waiting.
Restart the Compute Node when all Tasks have completed.
""")
  taskCompletion: "taskcompletion",
  @doc("""
Allow currently running Tasks to complete, then wait for all Task data
retention periods to expire. Schedule no new Tasks while waiting. Restart the
Compute Node when all Task retention periods have expired.
""")
  retainedData: "retaineddata",
}
@Azure.Core.fixed
enum ComputeNodeReimageOption {
  @doc("""
Terminate running Task processes and requeue the Tasks. The Tasks will run
again when a Compute Node is available. Reimage the Compute Node as soon as
Tasks have been terminated.
""")
  requeue,
  @doc("""
Terminate running Tasks. The Tasks will be completed with failureInfo
indicating that they were terminated, and will not run again. Reimage the
Compute Node as soon as Tasks have been terminated.
""")
  terminate,
  @doc("""
Allow currently running Tasks to complete. Schedule no new Tasks while waiting.
Reimage the Compute Node when all Tasks have completed.
""")
  taskCompletion: "taskcompletion",
  @doc("""
Allow currently running Tasks to complete, then wait for all Task data
retention periods to expire. Schedule no new Tasks while waiting. Reimage the
Compute Node when all Task retention periods have expired.
""")
  retainedData: "retaineddata",
}
@Azure.Core.fixed
enum DisableComputeNodeSchedulingOption {
  @doc("""
Terminate running Task processes and requeue the Tasks. The Tasks may run again
on other Compute Nodes, or when Task scheduling is re-enabled on this Compute
Node. Enter offline state as soon as Tasks have been terminated.
""")
  requeue,
  @doc("""
Terminate running Tasks. The Tasks will be completed with failureInfo
indicating that they were terminated, and will not run again. Enter offline
state as soon as Tasks have been terminated.
""")
  terminate,
  @doc("""
Allow currently running Tasks to complete. Schedule no new Tasks while waiting.
Enter offline state when all Tasks have completed.
""")
  taskCompletion: "taskcompletion",
}
@Azure.Core.fixed
enum StatusLevelTypes {
  Error,
  Info,
  Warning,
}

@doc("The result of listing the applications available in an Account.")
@pagedResult
model ApplicationListResult {
  @doc("The list of applications available in the Account.")
  @items
  value?: Application[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("Contains information about an application in an Azure Batch Account.")
@resource("applications")
model Application {
  @doc("A string that uniquely identifies the application within the Account.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  id: string;

  @doc("The display name for the application.")
  displayName: string;

  @doc("The list of available versions of the application.")
  versions: string[];
}

@doc("An error response received from the Azure Batch service.")
@error
model BatchError {
  @doc("""
An identifier for the error. Codes are invariant and are intended to be
consumed programmatically.
""")
  code?: string;

  @doc("An error message received in an Azure Batch error response.")
  message?: ErrorMessage;

  @doc("A collection of key-value pairs containing additional details about the error.")
  values?: BatchErrorDetail[];
}

@doc("An error message received in an Azure Batch error response.")
model ErrorMessage {
  @doc("The language code of the error message")
  lang?: string;

  @doc("The text of the message.")
  value?: string;
}

@doc("An item of additional information included in an Azure Batch error response.")
model BatchErrorDetail {
  @doc("An identifier specifying the meaning of the Value property.")
  key?: string;

  @doc("The additional information included with the error response.")
  value?: string;
}

@doc("The result of a listing the usage metrics for an Account.")
@pagedResult
model PoolListUsageMetricsResult {
  @doc("The Pool usage metrics data.")
  @items
  value?: PoolUsageMetrics[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("Usage metrics for a Pool across an aggregation interval.")
@resource("poolusagemetrics")
model PoolUsageMetrics {
  @doc("The ID of the Pool whose metrics are aggregated in this entry.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  poolId: string;

  @doc("The start time of the aggregation interval covered by this entry.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("The end time of the aggregation interval covered by this entry.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime: utcDateTime;

  @doc("""
For information about available sizes of virtual machines in Pools, see Choose
a VM size for Compute Nodes in an Azure Batch Pool
(https://docs.microsoft.com/azure/batch/batch-pool-vm-sizes).
""")
  vmSize: string;

  @doc("The total core hours used in the Pool during this aggregation interval.")
  totalCoreHours: float32;
}

@doc("The result of listing the supported Virtual Machine Images.")
@pagedResult
model AccountListSupportedImagesResult {
  @doc("The list of supported Virtual Machine Images.")
  @items
  value?: ImageInformation[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("""
A reference to the Azure Virtual Machines Marketplace Image and additional
information about the Image.
""")
@resource("supportedimages")
model ImageInformation {
  @doc("The ID of the Compute Node agent SKU which the Image supports.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  nodeAgentSKUId: string;

  @doc("""
A reference to an Azure Virtual Machines Marketplace Image or a Shared Image
Gallery Image. To get the list of all Azure Marketplace Image references
verified by Azure Batch, see the 'List Supported Images' operation.
""")
  imageReference: ImageReference;

  @doc("The type of operating system (e.g. Windows or Linux) of the Image.")
  osType: OSType;

  @doc("""
Not every capability of the Image is listed. Capabilities in this list are
considered of special interest and are generally related to integration with
other features in the Azure Batch service.
""")
  capabilities?: string[];

  @doc("""
The time when the Azure Batch service will stop accepting create Pool requests
for the Image.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  batchSupportEndOfLife?: utcDateTime;

  @doc("""
Whether the Azure Batch service actively verifies that the Image is compatible
with the associated Compute Node agent SKU.
""")
  verificationType: VerificationType;
}

@doc("""
A reference to an Azure Virtual Machines Marketplace Image or a Shared Image
Gallery Image. To get the list of all Azure Marketplace Image references
verified by Azure Batch, see the 'List Supported Images' operation.
""")
model ImageReference {
  @doc("For example, Canonical or MicrosoftWindowsServer.")
  publisher?: string;

  @doc("For example, UbuntuServer or WindowsServer.")
  offer?: string;

  @doc("For example, 18.04-LTS or 2019-Datacenter.")
  sku?: string;

  @doc("""
A value of 'latest' can be specified to select the latest version of an Image.
If omitted, the default is 'latest'.
""")
  version?: string;

  @doc("""
This property is mutually exclusive with other ImageReference properties. The
Shared Image Gallery Image must have replicas in the same region and must be in
the same subscription as the Azure Batch account. If the image version is not
specified in the imageId, the latest version will be used. For information
about the firewall settings for the Batch Compute Node agent to communicate
with the Batch service see
https://docs.microsoft.com/en-us/azure/batch/batch-api-basics#virtual-network-vnet-and-firewall-configuration.
""")
  virtualMachineImageId?: string;

  @doc("""
The specific version of the platform image or marketplace image used to create
the node. This read-only field differs from 'version' only if the value
specified for 'version' when the pool was created was 'latest'.
""")
  @visibility("read")
  exactVersion?: string;
}

@doc("The result of listing the Compute Node counts in the Account.")
@pagedResult
model PoolNodeCountsListResult {
  @doc("A list of Compute Node counts by Pool.")
  @items
  value?: PoolNodeCounts[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("The number of Compute Nodes in each state for a Pool.")
@resource("nodecounts")
model PoolNodeCounts {
  @doc("The ID of the Pool.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  poolId: string;

  @doc("The number of Compute Nodes in each Compute Node state.")
  dedicated?: NodeCounts;

  @doc("The number of Compute Nodes in each Compute Node state.")
  lowPriority?: NodeCounts;
}

@doc("The number of Compute Nodes in each Compute Node state.")
model NodeCounts {
  @doc("The number of Compute Nodes in the creating state.")
  creating: int32;

  @doc("The number of Compute Nodes in the idle state.")
  idle: int32;

  @doc("The number of Compute Nodes in the offline state.")
  offline: int32;

  @doc("The number of Compute Nodes in the preempted state.")
  preempted: int32;

  @doc("The count of Compute Nodes in the rebooting state.")
  rebooting: int32;

  @doc("The number of Compute Nodes in the reimaging state.")
  reimaging: int32;

  @doc("The number of Compute Nodes in the running state.")
  running: int32;

  @doc("The number of Compute Nodes in the starting state.")
  starting: int32;

  @doc("The number of Compute Nodes in the startTaskFailed state.")
  startTaskFailed: int32;

  @doc("The number of Compute Nodes in the leavingPool state.")
  leavingPool: int32;

  @doc("The number of Compute Nodes in the unknown state.")
  `unknown`: int32;

  @doc("The number of Compute Nodes in the unusable state.")
  unusable: int32;

  @doc("The number of Compute Nodes in the waitingForStartTask state.")
  waitingForStartTask: int32;

  @doc("The total number of Compute Nodes.")
  total: int32;
}

@doc("Contains utilization and resource usage statistics for the lifetime of a Pool.")
model PoolStatistics {
  @doc("The URL for the statistics.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  url: string;

  @doc("The start time of the time range covered by the statistics.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("""
The time at which the statistics were last updated. All statistics are limited
to the range between startTime and lastUpdateTime.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdateTime: utcDateTime;

  @doc("Statistics related to Pool usage information.")
  usageStats?: UsageStatistics;

  @doc("Statistics related to resource consumption by Compute Nodes in a Pool.")
  resourceStats?: ResourceStatistics;
}

@doc("Statistics related to Pool usage information.")
model UsageStatistics {
  @doc("The start time of the time range covered by the statistics.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("""
The time at which the statistics were last updated. All statistics are limited
to the range between startTime and lastUpdateTime.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdateTime: utcDateTime;

  @doc("""
The aggregated wall-clock time of the dedicated Compute Node cores being part
of the Pool.
""")
  dedicatedCoreTime: duration;
}

@doc("Statistics related to resource consumption by Compute Nodes in a Pool.")
model ResourceStatistics {
  @doc("The start time of the time range covered by the statistics.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("""
The time at which the statistics were last updated. All statistics are limited
to the range between startTime and lastUpdateTime.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdateTime: utcDateTime;

  @doc("""
The average CPU usage across all Compute Nodes in the Pool (percentage per
node).
""")
  avgCPUPercentage: float32;

  @doc("The average memory usage in GiB across all Compute Nodes in the Pool.")
  avgMemoryGiB: float32;

  @doc("The peak memory usage in GiB across all Compute Nodes in the Pool.")
  peakMemoryGiB: float32;

  @doc("The average used disk space in GiB across all Compute Nodes in the Pool.")
  avgDiskGiB: float32;

  @doc("The peak used disk space in GiB across all Compute Nodes in the Pool.")
  peakDiskGiB: float32;

  @doc("The total number of disk read operations across all Compute Nodes in the Pool.")
  diskReadIOps: int32;

  @doc("The total number of disk write operations across all Compute Nodes in the Pool.")
  diskWriteIOps: int32;

  @doc("""
The total amount of data in GiB of disk reads across all Compute Nodes in the
Pool.
""")
  diskReadGiB: float32;

  @doc("""
The total amount of data in GiB of disk writes across all Compute Nodes in the
Pool.
""")
  diskWriteGiB: float32;

  @doc("""
The total amount of data in GiB of network reads across all Compute Nodes in
the Pool.
""")
  networkReadGiB: float32;

  @doc("""
The total amount of data in GiB of network writes across all Compute Nodes in
the Pool.
""")
  networkWriteGiB: float32;
}

@doc("Resource usage statistics for a Job.")
model JobStatistics {
  @doc("The URL of the statistics.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  url: string;

  @doc("The start time of the time range covered by the statistics.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("""
The time at which the statistics were last updated. All statistics are limited
to the range between startTime and lastUpdateTime.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdateTime: utcDateTime;

  @doc("""
The total user mode CPU time (summed across all cores and all Compute Nodes)
consumed by all Tasks in the Job.
""")
  userCPUTime: duration;

  @doc("""
The total kernel mode CPU time (summed across all cores and all Compute Nodes)
consumed by all Tasks in the Job.
""")
  kernelCPUTime: duration;

  @doc("""
 The wall clock time is the elapsed time from when the Task started running on
a Compute Node to when it finished (or to the last time the statistics were
updated, if the Task had not finished by then). If a Task was retried, this
includes the wall clock time of all the Task retries.
""")
  wallClockTime: duration;

  @doc("The total number of disk read operations made by all Tasks in the Job.")
  readIOps: int32;

  @doc("The total number of disk write operations made by all Tasks in the Job.")
  writeIOps: int32;

  @doc("The total amount of data in GiB read from disk by all Tasks in the Job.")
  readIOGiB: float32;

  @doc("The total amount of data in GiB written to disk by all Tasks in the Job.")
  writeIOGiB: float32;

  @doc("A Task completes successfully if it returns exit code 0.")
  numSucceededTasks: int32;

  @doc("""
A Task fails if it exhausts its maximum retry count without returning exit code
0.
""")
  numFailedTasks: int32;

  @doc("""
The total number of retries on all the Tasks in the Job during the given time
range.
""")
  numTaskRetries: int32;

  @doc("""
The wait time for a Task is defined as the elapsed time between the creation of
the Task and the start of Task execution. (If the Task is retried due to
failures, the wait time is the time to the most recent Task execution.) This
value is only reported in the Account lifetime statistics; it is not included
in the Job statistics.
""")
  waitTime: duration;
}

@doc("""
A Certificate that can be installed on Compute Nodes and can be used to
authenticate operations on the machine.
""")
model Certificate {
  @doc("""
The X.509 thumbprint of the Certificate. This is a sequence of up to 40 hex
digits.
""")
  thumbprint?: string;

  @doc("The algorithm used to derive the thumbprint.")
  thumbprintAlgorithm?: string;

  @doc("The URL of the Certificate.")
  @visibility("read")
  url?: string;

  @doc("The state of the Certificate.")
  @visibility("read")
  state?: CertificateState;

  @doc("The time at which the Certificate entered its current state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  stateTransitionTime?: utcDateTime;

  @doc("This property is not set if the Certificate is in its initial active state.")
  @visibility("read")
  previousState?: CertificateState;

  @doc("This property is not set if the Certificate is in its initial Active state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  previousStateTransitionTime?: utcDateTime;

  @doc("The public part of the Certificate as a base-64 encoded .cer file.")
  @visibility("read")
  publicData?: string;

  @doc("This property is set only if the Certificate is in the DeleteFailed state.")
  @visibility("read")
  deleteCertificateError?: DeleteCertificateError;

  @doc("The base64-encoded contents of the Certificate. The maximum size is 10KB.")
  data?: string;

  @doc("The format of the Certificate data.")
  certificateFormat?: CertificateFormat;

  @doc("This must be omitted if the Certificate format is cer.")
  password?: string;
}

@doc("An error encountered by the Batch service when deleting a Certificate.")
model DeleteCertificateError {
  @doc("""
An identifier for the Certificate deletion error. Codes are invariant and are
intended to be consumed programmatically.
""")
  code?: string;

  @doc("""
A message describing the Certificate deletion error, intended to be suitable
for display in a user interface.
""")
  message?: string;

  @doc("""
This list includes details such as the active Pools and Compute Nodes
referencing this Certificate. However, if a large number of resources reference
the Certificate, the list contains only about the first hundred.
""")
  values?: NameValuePair[];
}

@doc("Represents a name-value pair.")
model NameValuePair {
  @doc("The name in the name-value pair.")
  name?: string;

  @doc("The value in the name-value pair.")
  value?: string;
}

@doc("The result of listing the Certificates in the Account.")
@pagedResult
model CertificateListResult {
  @doc("The list of Certificates.")
  @items
  value?: Certificate[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("""
The result of listing the files on a Compute Node, or the files associated with
a Task on a Compute Node.
""")
@pagedResult
model NodeFileListResult {
  @doc("The list of files.")
  @items
  value?: NodeFile[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("Information about a file or directory on a Compute Node.")
model NodeFile {
  @doc("The file path.")
  name?: string;

  @doc("The URL of the file.")
  url?: string;

  @doc("Whether the object represents a directory.")
  isDirectory?: boolean;

  @doc("The properties of a file on a Compute Node.")
  properties?: FileProperties;
}

@doc("The properties of a file on a Compute Node.")
model FileProperties {
  @doc("The creation time is not returned for files on Linux Compute Nodes.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  creationTime?: utcDateTime;

  @doc("The time at which the file was last modified.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModified: utcDateTime;

  @doc("The length of the file.")
  contentLength: int32;

  @doc("The content type of the file.")
  contentType?: string;

  @doc("The file mode is returned only for files on Linux Compute Nodes.")
  fileMode?: string;
}

@doc("""
A Job Schedule that allows recurring Jobs by specifying when to run Jobs and a
specification used to create each Job.
""")
model BatchJobSchedule {
  @doc("A string that uniquely identifies the schedule within the Account.")
  id?: string;

  @doc("The display name for the schedule.")
  displayName?: string;

  @doc("The URL of the Job Schedule.")
  @visibility("read")
  url?: string;

  @doc("""
This is an opaque string. You can use it to detect whether the Job Schedule has
changed between requests. In particular, you can be pass the ETag with an
Update Job Schedule request to specify that your changes should take effect
only if nobody else has modified the schedule in the meantime.
""")
  @visibility("read")
  eTag?: string;

  @doc("""
This is the last time at which the schedule level data, such as the Job
specification or recurrence information, changed. It does not factor in
job-level changes such as new Jobs being created or Jobs changing state.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModified?: utcDateTime;

  @doc("The creation time of the Job Schedule.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  creationTime?: utcDateTime;

  @doc("The state of the Job Schedule.")
  @visibility("read")
  state?: JobScheduleState;

  @doc("The time at which the Job Schedule entered the current state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  stateTransitionTime?: utcDateTime;

  @doc("This property is not present if the Job Schedule is in its initial active state.")
  @visibility("read")
  previousState?: JobScheduleState;

  @doc("This property is not present if the Job Schedule is in its initial active state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  previousStateTransitionTime?: utcDateTime;

  @doc("""
All times are fixed respective to UTC and are not impacted by daylight saving
time.
""")
  schedule?: Schedule;

  @doc("Specifies details of the Jobs to be created on a schedule.")
  jobSpecification?: JobSpecification;

  @doc("""
Contains information about Jobs that have been and will be run under a Job
Schedule.
""")
  @visibility("read")
  executionInfo?: JobScheduleExecutionInformation;

  @doc("""
The Batch service does not assign any meaning to metadata; it is solely for the
use of user code.
""")
  metadata?: MetadataItem[];

  @doc("Resource usage statistics for a Job Schedule.")
  @visibility("read")
  stats?: JobScheduleStatistics;
}

@doc("""
The schedule according to which Jobs will be created. All times are fixed
respective to UTC and are not impacted by daylight saving time.
""")
model Schedule {
  @doc("""
If you do not specify a doNotRunUntil time, the schedule becomes ready to
create Jobs immediately.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  doNotRunUntil?: utcDateTime;

  @doc("""
If you do not specify a doNotRunAfter time, and you are creating a recurring
Job Schedule, the Job Schedule will remain active until you explicitly
terminate it.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  doNotRunAfter?: utcDateTime;

  @doc("""
If a Job is not created within the startWindow interval, then the 'opportunity'
is lost; no Job will be created until the next recurrence of the schedule. If
the schedule is recurring, and the startWindow is longer than the recurrence
interval, then this is equivalent to an infinite startWindow, because the Job
that is 'due' in one recurrenceInterval is not carried forward into the next
recurrence interval. The default is infinite. The minimum value is 1 minute. If
you specify a lower value, the Batch service rejects the schedule with an
error; if you are calling the REST API directly, the HTTP status code is 400
(Bad Request).
""")
  startWindow?: duration;

  @doc("""
Because a Job Schedule can have at most one active Job under it at any given
time, if it is time to create a new Job under a Job Schedule, but the previous
Job is still running, the Batch service will not create the new Job until the
previous Job finishes. If the previous Job does not finish within the
startWindow period of the new recurrenceInterval, then no new Job will be
scheduled for that interval. For recurring Jobs, you should normally specify a
jobManagerTask in the jobSpecification. If you do not use jobManagerTask, you
will need an external process to monitor when Jobs are created, add Tasks to
the Jobs and terminate the Jobs ready for the next recurrence. The default is
that the schedule does not recur: one Job is created, within the startWindow
after the doNotRunUntil time, and the schedule is complete as soon as that Job
finishes. The minimum value is 1 minute. If you specify a lower value, the
Batch service rejects the schedule with an error; if you are calling the REST
API directly, the HTTP status code is 400 (Bad Request).
""")
  recurrenceInterval?: duration;
}

@doc("Specifies details of the Jobs to be created on a schedule.")
model JobSpecification {
  @doc("""
Priority values can range from -1000 to 1000, with -1000 being the lowest
priority and 1000 being the highest priority. The default value is 0. This
priority is used as the default for all Jobs under the Job Schedule. You can
update a Job's priority after it has been created using by using the update Job
API.
""")
  priority?: int32;

  @doc("""
If the value is set to True, other high priority jobs submitted to the system
will take precedence and will be able requeue tasks from this job. You can
update a job's allowTaskPreemption after it has been created using the update
job API.
""")
  allowTaskPreemption?: boolean;

  @doc("""
The value of maxParallelTasks must be -1 or greater than 0 if specified. If not
specified, the default value is -1, which means there's no limit to the number
of tasks that can be run at once. You can update a job's maxParallelTasks after
it has been created using the update job API.
""")
  maxParallelTasks?: int32;

  @doc("""
The name need not be unique and can contain any Unicode characters up to a
maximum length of 1024.
""")
  displayName?: string;

  @doc("""
Whether Tasks in the Job can define dependencies on each other. The default is
false.
""")
  usesTaskDependencies?: boolean;

  @doc("""
Note that if a Job contains no Tasks, then all Tasks are considered complete.
This option is therefore most commonly used with a Job Manager task; if you
want to use automatic Job termination without a Job Manager, you should
initially set onAllTasksComplete to noaction and update the Job properties to
set onAllTasksComplete to terminatejob once you have finished adding Tasks. The
default is noaction.
""")
  onAllTasksComplete?: OnAllTasksComplete;

  @doc("The default is noaction.")
  onTaskFailure?: OnTaskFailure;

  @doc("The network configuration for the Job.")
  networkConfiguration?: JobNetworkConfiguration;

  @doc("The execution constraints for a Job.")
  constraints?: JobConstraints;

  @doc("""
If the Job does not specify a Job Manager Task, the user must explicitly add
Tasks to the Job using the Task API. If the Job does specify a Job Manager
Task, the Batch service creates the Job Manager Task when the Job is created,
and will try to schedule the Job Manager Task before scheduling other Tasks in
the Job.
""")
  jobManagerTask?: JobManagerTask;

  @doc("""
If a Job has a Job Preparation Task, the Batch service will run the Job
Preparation Task on a Node before starting any Tasks of that Job on that
Compute Node.
""")
  jobPreparationTask?: JobPreparationTask;

  @doc("""
The primary purpose of the Job Release Task is to undo changes to Nodes made by
the Job Preparation Task. Example activities include deleting local files, or
shutting down services that were started as part of Job preparation. A Job
Release Task cannot be specified without also specifying a Job Preparation Task
for the Job. The Batch service runs the Job Release Task on the Compute Nodes
that have run the Job Preparation Task.
""")
  jobReleaseTask?: JobReleaseTask;

  @doc("""
Individual Tasks can override an environment setting specified here by
specifying the same setting name with a different value.
""")
  commonEnvironmentSettings?: EnvironmentSetting[];

  @doc("Specifies how a Job should be assigned to a Pool.")
  poolInfo: PoolInformation;

  @doc("""
The Batch service does not assign any meaning to metadata; it is solely for the
use of user code.
""")
  metadata?: MetadataItem[];
}

@doc("The network configuration for the Job.")
model JobNetworkConfiguration {
  @doc("""
The virtual network must be in the same region and subscription as the Azure
Batch Account. The specified subnet should have enough free IP addresses to
accommodate the number of Compute Nodes which will run Tasks from the Job. This
can be up to the number of Compute Nodes in the Pool. The 'MicrosoftAzureBatch'
service principal must have the 'Classic Virtual Machine Contributor'
Role-Based Access Control (RBAC) role for the specified VNet so that Azure
Batch service can schedule Tasks on the Nodes. This can be verified by checking
if the specified VNet has any associated Network Security Groups (NSG). If
communication to the Nodes in the specified subnet is denied by an NSG, then
the Batch service will set the state of the Compute Nodes to unusable. This is
of the form
/subscriptions/{subscription}/resourceGroups/{group}/providers/{provider}/virtualNetworks/{network}/subnets/{subnet}.
If the specified VNet has any associated Network Security Groups (NSG), then a
few reserved system ports must be enabled for inbound communication from the
Azure Batch service. For Pools created with a Virtual Machine configuration,
enable ports 29876 and 29877, as well as port 22 for Linux and port 3389 for
Windows. Port 443 is also required to be open for outbound connections for
communications to Azure Storage. For more details see:
https://docs.microsoft.com/en-us/azure/batch/batch-api-basics#virtual-network-vnet-and-firewall-configuration
""")
  subnetId: string;
}

@doc("The execution constraints for a Job.")
model JobConstraints {
  @doc("""
If the Job does not complete within the time limit, the Batch service
terminates it and any Tasks that are still running. In this case, the
termination reason will be MaxWallClockTimeExpiry. If this property is not
specified, there is no time limit on how long the Job may run.
""")
  maxWallClockTime?: duration;

  @doc("""
Note that this value specifically controls the number of retries. The Batch
service will try each Task once, and may then retry up to this limit. For
example, if the maximum retry count is 3, Batch tries a Task up to 4 times (one
initial try and 3 retries). If the maximum retry count is 0, the Batch service
does not retry Tasks. If the maximum retry count is -1, the Batch service
retries the Task without limit, however this is not recommended for a start
task or any task. The default value is 0 (no retries)
""")
  maxTaskRetryCount?: int32;
}

@doc("""
The Job Manager Task is automatically started when the Job is created. The
Batch service tries to schedule the Job Manager Task before any other Tasks in
the Job. When shrinking a Pool, the Batch service tries to preserve Nodes where
Job Manager Tasks are running for as long as possible (that is, Compute Nodes
running 'normal' Tasks are removed before Compute Nodes running Job Manager
Tasks). When a Job Manager Task fails and needs to be restarted, the system
tries to schedule it at the highest priority. If there are no idle Compute
Nodes available, the system may terminate one of the running Tasks in the Pool
and return it to the queue in order to make room for the Job Manager Task to
restart. Note that a Job Manager Task in one Job does not have priority over
Tasks in other Jobs. Across Jobs, only Job level priorities are observed. For
example, if a Job Manager in a priority 0 Job needs to be restarted, it will
not displace Tasks of a priority 1 Job. Batch will retry Tasks when a recovery
operation is triggered on a Node. Examples of recovery operations include (but
are not limited to) when an unhealthy Node is rebooted or a Compute Node
disappeared due to host failure. Retries due to recovery operations are
independent of and are not counted against the maxTaskRetryCount. Even if the
maxTaskRetryCount is 0, an internal retry due to a recovery operation may
occur. Because of this, all Tasks should be idempotent. This means Tasks need
to tolerate being interrupted and restarted without causing any corruption or
duplicate data. The best practice for long running Tasks is to use some form of
checkpointing.
""")
model JobManagerTask {
  @doc("""
The ID can contain any combination of alphanumeric characters including hyphens
and underscores and cannot contain more than 64 characters.
""")
  id: string;

  @doc("""
It need not be unique and can contain any Unicode characters up to a maximum
length of 1024.
""")
  displayName?: string;

  @doc("""
The command line does not run under a shell, and therefore cannot take
advantage of shell features such as environment variable expansion. If you want
to take advantage of such features, you should invoke the shell in the command
line, for example using \"cmd /c MyCommand\" in Windows or \"/bin/sh -c
MyCommand\" in Linux. If the command line refers to file paths, it should use a
relative path (relative to the Task working directory), or use the Batch
provided environment variable
(https://docs.microsoft.com/en-us/azure/batch/batch-compute-node-environment-variables).
""")
  commandLine: string;

  @doc("""
If the Pool that will run this Task has containerConfiguration set, this must
be set as well. If the Pool that will run this Task doesn't have
containerConfiguration set, this must not be set. When this is specified, all
directories recursively below the AZ_BATCH_NODE_ROOT_DIR (the root of Azure
Batch directories on the node) are mapped into the container, all Task
environment variables are mapped into the container, and the Task command line
is executed in the container. Files produced in the container outside of
AZ_BATCH_NODE_ROOT_DIR might not be reflected to the host disk, meaning that
Batch file APIs will not be able to access those files.
""")
  containerSettings?: TaskContainerSettings;

  @doc("""
Files listed under this element are located in the Task's working directory.
There is a maximum size for the list of resource files.  When the max size is
exceeded, the request will fail and the response error code will be
RequestEntityTooLarge. If this occurs, the collection of ResourceFiles must be
reduced in size. This can be achieved using .zip files, Application Packages,
or Docker Containers.
""")
  resourceFiles?: ResourceFile[];

  @doc("""
For multi-instance Tasks, the files will only be uploaded from the Compute Node
on which the primary Task is executed.
""")
  outputFiles?: OutputFile[];

  @doc("A list of environment variable settings for the Job Manager Task.")
  environmentSettings?: EnvironmentSetting[];

  @doc("Execution constraints to apply to a Task.")
  constraints?: TaskConstraints;

  @doc("""
The default is 1. A Task can only be scheduled to run on a compute node if the
node has enough free scheduling slots available. For multi-instance Tasks, this
property is not supported and must not be specified.
""")
  requiredSlots?: int32;

  @doc("""
If true, when the Job Manager Task completes, the Batch service marks the Job
as complete. If any Tasks are still running at this time (other than Job
Release), those Tasks are terminated. If false, the completion of the Job
Manager Task does not affect the Job status. In this case, you should either
use the onAllTasksComplete attribute to terminate the Job, or have a client or
user terminate the Job explicitly. An example of this is if the Job Manager
creates a set of Tasks but then takes no further role in their execution. The
default value is true. If you are using the onAllTasksComplete and
onTaskFailure attributes to control Job lifetime, and using the Job Manager
Task only to create the Tasks for the Job (not to monitor progress), then it is
important to set killJobOnCompletion to false.
""")
  killJobOnCompletion?: boolean;

  @doc("If omitted, the Task runs as a non-administrative user unique to the Task.")
  userIdentity?: UserIdentity;

  @doc("""
If true, no other Tasks will run on the same Node for as long as the Job
Manager is running. If false, other Tasks can run simultaneously with the Job
Manager on a Compute Node. The Job Manager Task counts normally against the
Compute Node's concurrent Task limit, so this is only relevant if the Compute
Node allows multiple concurrent Tasks. The default value is true.
""")
  runExclusive?: boolean;

  @doc("""
Application Packages are downloaded and deployed to a shared directory, not the
Task working directory. Therefore, if a referenced Application Package is
already on the Compute Node, and is up to date, then it is not re-downloaded;
the existing copy on the Compute Node is used. If a referenced Application
Package cannot be installed, for example because the package has been deleted
or because download failed, the Task fails.
""")
  applicationPackageReferences?: ApplicationPackageReference[];

  @doc("""
If this property is set, the Batch service provides the Task with an
authentication token which can be used to authenticate Batch service operations
without requiring an Account access key. The token is provided via the
AZ_BATCH_AUTHENTICATION_TOKEN environment variable. The operations that the
Task can carry out using the token depend on the settings. For example, a Task
can request Job permissions in order to add other Tasks to the Job, or check
the status of the Job or of other Tasks under the Job.
""")
  authenticationTokenSettings?: AuthenticationTokenSettings;

  @doc("The default value is true.")
  allowLowPriorityNode?: boolean;
}

@doc("The container settings for a Task.")
model TaskContainerSettings {
  @doc("""
These additional options are supplied as arguments to the \"docker create\"
command, in addition to those controlled by the Batch Service.
""")
  containerRunOptions?: string;

  @doc("""
This is the full Image reference, as would be specified to \"docker pull\". If
no tag is provided as part of the Image name, the tag \":latest\" is used as a
default.
""")
  imageName: string;

  @doc("This setting can be omitted if was already provided at Pool creation.")
  registry?: ContainerRegistry;

  @doc("The default is 'taskWorkingDirectory'.")
  workingDirectory?: ContainerWorkingDirectory;
}

@doc("A private container registry.")
model ContainerRegistry {
  @doc("The user name to log into the registry server.")
  @projectedName("json", "username")
  userName?: string;

  @doc("The password to log into the registry server.")
  password?: string;

  @doc("If omitted, the default is \"docker.io\".")
  registryServer?: string;

  @doc("""
The reference to a user assigned identity associated with the Batch pool which
a compute node will use.
""")
  identityReference?: ComputeNodeIdentityReference;
}

@doc("""
The reference to a user assigned identity associated with the Batch pool which
a compute node will use.
""")
model ComputeNodeIdentityReference {
  @doc("The ARM resource id of the user assigned identity.")
  resourceId?: string;
}

@doc("A single file or multiple files to be downloaded to a Compute Node.")
model ResourceFile {
  @doc("""
The autoStorageContainerName, storageContainerUrl and httpUrl properties are
mutually exclusive and one of them must be specified.
""")
  autoStorageContainerName?: string;

  @doc("""
The autoStorageContainerName, storageContainerUrl and httpUrl properties are
mutually exclusive and one of them must be specified. This URL must be readable
and listable from compute nodes. There are three ways to get such a URL for a
container in Azure storage: include a Shared Access Signature (SAS) granting
read and list permissions on the container, use a managed identity with read
and list permissions, or set the ACL for the container to allow public access.
""")
  storageContainerUrl?: string;

  @doc("""
The autoStorageContainerName, storageContainerUrl and httpUrl properties are
mutually exclusive and one of them must be specified. If the URL points to
Azure Blob Storage, it must be readable from compute nodes. There are three
ways to get such a URL for a blob in Azure storage: include a Shared Access
Signature (SAS) granting read permissions on the blob, use a managed identity
with read permission, or set the ACL for the blob or its container to allow
public access.
""")
  httpUrl?: string;

  @doc("""
The property is valid only when autoStorageContainerName or storageContainerUrl
is used. This prefix can be a partial filename or a subdirectory. If a prefix
is not specified, all the files in the container will be downloaded.
""")
  blobPrefix?: string;

  @doc("""
If the httpUrl property is specified, the filePath is required and describes
the path which the file will be downloaded to, including the filename.
Otherwise, if the autoStorageContainerName or storageContainerUrl property is
specified, filePath is optional and is the directory to download the files to.
In the case where filePath is used as a directory, any directory structure
already associated with the input data will be retained in full and appended to
the specified filePath directory. The specified relative path cannot break out
of the Task's working directory (for example by using '..').
""")
  filePath?: string;

  @doc("""
This property applies only to files being downloaded to Linux Compute Nodes. It
will be ignored if it is specified for a resourceFile which will be downloaded
to a Windows Compute Node. If this property is not specified for a Linux
Compute Node, then a default value of 0770 is applied to the file.
""")
  fileMode?: string;

  @doc("""
The reference to a user assigned identity associated with the Batch pool which
a compute node will use.
""")
  identityReference?: ComputeNodeIdentityReference;
}

@doc("""
On every file uploads, Batch service writes two log files to the compute node,
'fileuploadout.txt' and 'fileuploaderr.txt'. These log files are used to learn
more about a specific failure.
""")
model OutputFile {
  @doc("""
Both relative and absolute paths are supported. Relative paths are relative to
the Task working directory. The following wildcards are supported: * matches 0
or more characters (for example pattern abc* would match abc or abcdef), **
matches any directory, ? matches any single character, [abc] matches one
character in the brackets, and [a-c] matches one character in the range.
Brackets can include a negation to match any character not specified (for
example [!abc] matches any character but a, b, or c). If a file name starts
with \".\" it is ignored by default but may be matched by specifying it
explicitly (for example *.gif will not match .a.gif, but .*.gif will). A simple
example: **\\*.txt matches any file that does not start in '.' and ends with
.txt in the Task working directory or any subdirectory. If the filename
contains a wildcard character it can be escaped using brackets (for example
abc[*] would match a file named abc*). Note that both \\ and / are treated as
directory separators on Windows, but only / is on Linux. Environment variables
(%var% on Windows or $var on Linux) are expanded prior to the pattern being
applied.
""")
  filePattern: string;

  @doc("The destination to which a file should be uploaded.")
  destination: OutputFileDestination;

  @doc("""
Details about an output file upload operation, including under what conditions
to perform the upload.
""")
  uploadOptions: OutputFileUploadOptions;
}

@doc("The destination to which a file should be uploaded.")
model OutputFileDestination {
  @doc("Specifies a file upload destination within an Azure blob storage container.")
  container?: OutputFileBlobContainerDestination;
}

@doc("Specifies a file upload destination within an Azure blob storage container.")
model OutputFileBlobContainerDestination {
  @doc("""
If filePattern refers to a specific file (i.e. contains no wildcards), then
path is the name of the blob to which to upload that file. If filePattern
contains one or more wildcards (and therefore may match multiple files), then
path is the name of the blob virtual directory (which is prepended to each blob
name) to which to upload the file(s). If omitted, file(s) are uploaded to the
root of the container with a blob name matching their file name.
""")
  path?: string;

  @doc("""
If not using a managed identity, the URL must include a Shared Access Signature
(SAS) granting write permissions to the container.
""")
  containerUrl: string;

  @doc("The identity must have write access to the Azure Blob Storage container")
  identityReference?: ComputeNodeIdentityReference;

  @doc("""
These headers will be specified when uploading files to Azure Storage. For more
information, see [Request Headers (All Blob
Types)](https://docs.microsoft.com/rest/api/storageservices/put-blob#request-headers-all-blob-types).
""")
  uploadHeaders?: HttpHeader[];
}

@doc("An HTTP header name-value pair")
model HttpHeader {
  @doc("The case-insensitive name of the header to be used while uploading output files")
  name: string;

  @doc("The value of the header to be used while uploading output files")
  value?: string;
}

@doc("""
Details about an output file upload operation, including under what conditions
to perform the upload.
""")
model OutputFileUploadOptions {
  @doc("The default is taskcompletion.")
  uploadCondition: OutputFileUploadCondition;
}

@doc("An environment variable to be set on a Task process.")
model EnvironmentSetting {
  @doc("The name of the environment variable.")
  name: string;

  @doc("The value of the environment variable.")
  value?: string;
}

@doc("Execution constraints to apply to a Task.")
model TaskConstraints {
  @doc("If this is not specified, there is no time limit on how long the Task may run.")
  maxWallClockTime?: duration;

  @doc("""
The default is 7 days, i.e. the Task directory will be retained for 7 days
unless the Compute Node is removed or the Job is deleted.
""")
  retentionTime?: duration;

  @doc("""
Note that this value specifically controls the number of retries for the Task
executable due to a nonzero exit code. The Batch service will try the Task
once, and may then retry up to this limit. For example, if the maximum retry
count is 3, Batch tries the Task up to 4 times (one initial try and 3 retries).
If the maximum retry count is 0, the Batch service does not retry the Task
after the first attempt. If the maximum retry count is -1, the Batch service
retries the Task without limit, however this is not recommended for a start
task or any task. The default value is 0 (no retries)
""")
  maxTaskRetryCount?: int32;
}

@doc("Specify either the userName or autoUser property, but not both.")
model UserIdentity {
  @doc("""
The userName and autoUser properties are mutually exclusive; you must specify
one but not both.
""")
  @projectedName("json", "username")
  userName?: string;

  @doc("""
The userName and autoUser properties are mutually exclusive; you must specify
one but not both.
""")
  autoUser?: AutoUserSpecification;
}

@doc("""
Specifies the parameters for the auto user that runs a Task on the Batch
service.
""")
model AutoUserSpecification {
  @doc("""
The default value is pool. If the pool is running Windows a value of Task
should be specified if stricter isolation between tasks is required. For
example, if the task mutates the registry in a way which could impact other
tasks, or if certificates have been specified on the pool which should not be
accessible by normal tasks but should be accessible by StartTasks.
""")
  scope?: AutoUserScope;

  @doc("The default value is nonAdmin.")
  elevationLevel?: ElevationLevel;
}

@doc("A reference to an Package to be deployed to Compute Nodes.")
model ApplicationPackageReference {
  @doc("The ID of the application to deploy.")
  applicationId: string;

  @doc("""
If this is omitted on a Pool, and no default version is specified for this
application, the request fails with the error code
InvalidApplicationPackageReferences and HTTP status code 409. If this is
omitted on a Task, and no default version is specified for this application,
the Task fails with a pre-processing error.
""")
  version?: string;
}

@doc("""
The settings for an authentication token that the Task can use to perform Batch
service operations.
""")
model AuthenticationTokenSettings {
  @doc("""
The authentication token grants access to a limited set of Batch service
operations. Currently the only supported value for the access property is
'job', which grants access to all operations related to the Job which contains
the Task.
""")
  access?: "job"[];
}

@doc("""
You can use Job Preparation to prepare a Node to run Tasks for the Job.
Activities commonly performed in Job Preparation include: Downloading common
resource files used by all the Tasks in the Job. The Job Preparation Task can
download these common resource files to the shared location on the Node.
(AZ_BATCH_NODE_ROOT_DIR\\shared), or starting a local service on the Node so
that all Tasks of that Job can communicate with it. If the Job Preparation Task
fails (that is, exhausts its retry count before exiting with exit code 0),
Batch will not run Tasks of this Job on the Node. The Compute Node remains
ineligible to run Tasks of this Job until it is reimaged. The Compute Node
remains active and can be used for other Jobs. The Job Preparation Task can run
multiple times on the same Node. Therefore, you should write the Job
Preparation Task to handle re-execution. If the Node is rebooted, the Job
Preparation Task is run again on the Compute Node before scheduling any other
Task of the Job, if rerunOnNodeRebootAfterSuccess is true or if the Job
Preparation Task did not previously complete. If the Node is reimaged, the Job
Preparation Task is run again before scheduling any Task of the Job. Batch will
retry Tasks when a recovery operation is triggered on a Node. Examples of
recovery operations include (but are not limited to) when an unhealthy Node is
rebooted or a Compute Node disappeared due to host failure. Retries due to
recovery operations are independent of and are not counted against the
maxTaskRetryCount. Even if the maxTaskRetryCount is 0, an internal retry due to
a recovery operation may occur. Because of this, all Tasks should be
idempotent. This means Tasks need to tolerate being interrupted and restarted
without causing any corruption or duplicate data. The best practice for long
running Tasks is to use some form of checkpointing.
""")
model JobPreparationTask {
  @doc("""
The ID can contain any combination of alphanumeric characters including hyphens
and underscores and cannot contain more than 64 characters. If you do not
specify this property, the Batch service assigns a default value of
'jobpreparation'. No other Task in the Job can have the same ID as the Job
Preparation Task. If you try to submit a Task with the same id, the Batch
service rejects the request with error code TaskIdSameAsJobPreparationTask; if
you are calling the REST API directly, the HTTP status code is 409 (Conflict).
""")
  id?: string;

  @doc("""
The command line does not run under a shell, and therefore cannot take
advantage of shell features such as environment variable expansion. If you want
to take advantage of such features, you should invoke the shell in the command
line, for example using \"cmd /c MyCommand\" in Windows or \"/bin/sh -c
MyCommand\" in Linux. If the command line refers to file paths, it should use a
relative path (relative to the Task working directory), or use the Batch
provided environment variable
(https://docs.microsoft.com/en-us/azure/batch/batch-compute-node-environment-variables).
""")
  commandLine: string;

  @doc("""
When this is specified, all directories recursively below the
AZ_BATCH_NODE_ROOT_DIR (the root of Azure Batch directories on the node) are
mapped into the container, all Task environment variables are mapped into the
container, and the Task command line is executed in the container. Files
produced in the container outside of AZ_BATCH_NODE_ROOT_DIR might not be
reflected to the host disk, meaning that Batch file APIs will not be able to
access those files.
""")
  containerSettings?: TaskContainerSettings;

  @doc("""
Files listed under this element are located in the Task's working directory. 
There is a maximum size for the list of resource files.  When the max size is
exceeded, the request will fail and the response error code will be
RequestEntityTooLarge. If this occurs, the collection of ResourceFiles must be
reduced in size. This can be achieved using .zip files, Application Packages,
or Docker Containers.
""")
  resourceFiles?: ResourceFile[];

  @doc("A list of environment variable settings for the Job Preparation Task.")
  environmentSettings?: EnvironmentSetting[];

  @doc("Execution constraints to apply to a Task.")
  constraints?: TaskConstraints;

  @doc("""
If true and the Job Preparation Task fails on a Node, the Batch service retries
the Job Preparation Task up to its maximum retry count (as specified in the
constraints element). If the Task has still not completed successfully after
all retries, then the Batch service will not schedule Tasks of the Job to the
Node. The Node remains active and eligible to run Tasks of other Jobs. If
false, the Batch service will not wait for the Job Preparation Task to
complete. In this case, other Tasks of the Job can start executing on the
Compute Node while the Job Preparation Task is still running; and even if the
Job Preparation Task fails, new Tasks will continue to be scheduled on the
Compute Node. The default value is true.
""")
  waitForSuccess?: boolean;

  @doc("""
If omitted, the Task runs as a non-administrative user unique to the Task on
Windows Compute Nodes, or a non-administrative user unique to the Pool on Linux
Compute Nodes.
""")
  userIdentity?: UserIdentity;

  @doc("""
The Job Preparation Task is always rerun if a Compute Node is reimaged, or if
the Job Preparation Task did not complete (e.g. because the reboot occurred
while the Task was running). Therefore, you should always write a Job
Preparation Task to be idempotent and to behave correctly if run multiple
times. The default value is true.
""")
  rerunOnNodeRebootAfterSuccess?: boolean;
}

@doc("""
The Job Release Task runs when the Job ends, because of one of the following:
The user calls the Terminate Job API, or the Delete Job API while the Job is
still active, the Job's maximum wall clock time constraint is reached, and the
Job is still active, or the Job's Job Manager Task completed, and the Job is
configured to terminate when the Job Manager completes. The Job Release Task
runs on each Node where Tasks of the Job have run and the Job Preparation Task
ran and completed. If you reimage a Node after it has run the Job Preparation
Task, and the Job ends without any further Tasks of the Job running on that
Node (and hence the Job Preparation Task does not re-run), then the Job Release
Task does not run on that Compute Node. If a Node reboots while the Job Release
Task is still running, the Job Release Task runs again when the Compute Node
starts up. The Job is not marked as complete until all Job Release Tasks have
completed. The Job Release Task runs in the background. It does not occupy a
scheduling slot; that is, it does not count towards the taskSlotsPerNode limit
specified on the Pool.
""")
model JobReleaseTask {
  @doc("""
The ID can contain any combination of alphanumeric characters including hyphens
and underscores and cannot contain more than 64 characters. If you do not
specify this property, the Batch service assigns a default value of
'jobrelease'. No other Task in the Job can have the same ID as the Job Release
Task. If you try to submit a Task with the same id, the Batch service rejects
the request with error code TaskIdSameAsJobReleaseTask; if you are calling the
REST API directly, the HTTP status code is 409 (Conflict).
""")
  id?: string;

  @doc("""
The command line does not run under a shell, and therefore cannot take
advantage of shell features such as environment variable expansion. If you want
to take advantage of such features, you should invoke the shell in the command
line, for example using \"cmd /c MyCommand\" in Windows or \"/bin/sh -c
MyCommand\" in Linux. If the command line refers to file paths, it should use a
relative path (relative to the Task working directory), or use the Batch
provided environment variable
(https://docs.microsoft.com/en-us/azure/batch/batch-compute-node-environment-variables).
""")
  commandLine: string;

  @doc("""
When this is specified, all directories recursively below the
AZ_BATCH_NODE_ROOT_DIR (the root of Azure Batch directories on the node) are
mapped into the container, all Task environment variables are mapped into the
container, and the Task command line is executed in the container. Files
produced in the container outside of AZ_BATCH_NODE_ROOT_DIR might not be
reflected to the host disk, meaning that Batch file APIs will not be able to
access those files.
""")
  containerSettings?: TaskContainerSettings;

  @doc("Files listed under this element are located in the Task's working directory.")
  resourceFiles?: ResourceFile[];

  @doc("A list of environment variable settings for the Job Release Task.")
  environmentSettings?: EnvironmentSetting[];

  @doc("""
The maximum elapsed time that the Job Release Task may run on a given Compute
Node, measured from the time the Task starts. If the Task does not complete
within the time limit, the Batch service terminates it. The default value is 15
minutes. You may not specify a timeout longer than 15 minutes. If you do, the
Batch service rejects it with an error; if you are calling the REST API
directly, the HTTP status code is 400 (Bad Request).
""")
  maxWallClockTime?: duration;

  @doc("""
The default is 7 days, i.e. the Task directory will be retained for 7 days
unless the Compute Node is removed or the Job is deleted.
""")
  retentionTime?: duration;

  @doc("If omitted, the Task runs as a non-administrative user unique to the Task.")
  userIdentity?: UserIdentity;
}

@doc("Specifies how a Job should be assigned to a Pool.")
model PoolInformation {
  @doc("""
You must ensure that the Pool referenced by this property exists. If the Pool
does not exist at the time the Batch service tries to schedule a Job, no Tasks
for the Job will run until you create a Pool with that id. Note that the Batch
service will not reject the Job request; it will simply not run Tasks until the
Pool exists. You must specify either the Pool ID or the auto Pool
specification, but not both.
""")
  poolId?: string;

  @doc("""
If auto Pool creation fails, the Batch service moves the Job to a completed
state, and the Pool creation error is set in the Job's scheduling error
property. The Batch service manages the lifetime (both creation and, unless
keepAlive is specified, deletion) of the auto Pool. Any user actions that
affect the lifetime of the auto Pool while the Job is active will result in
unexpected behavior. You must specify either the Pool ID or the auto Pool
specification, but not both.
""")
  autoPoolSpecification?: AutoPoolSpecification;
}

@doc("""
Specifies characteristics for a temporary 'auto pool'. The Batch service will
create this auto Pool when the Job is submitted.
""")
model AutoPoolSpecification {
  @doc("""
The Batch service assigns each auto Pool a unique identifier on creation. To
distinguish between Pools created for different purposes, you can specify this
element to add a prefix to the ID that is assigned. The prefix can be up to 20
characters long.
""")
  autoPoolIdPrefix?: string;

  @doc("""
The minimum lifetime of created auto Pools, and how multiple Jobs on a schedule
are assigned to Pools.
""")
  poolLifetimeOption: PoolLifetimeOption;

  @doc("""
If false, the Batch service deletes the Pool once its lifetime (as determined
by the poolLifetimeOption setting) expires; that is, when the Job or Job
Schedule completes. If true, the Batch service does not delete the Pool
automatically. It is up to the user to delete auto Pools created with this
option.
""")
  keepAlive?: boolean;

  @doc("Specification for creating a new Pool.")
  pool?: PoolSpecification;
}

@doc("Specification for creating a new Pool.")
model PoolSpecification {
  @doc("""
The display name need not be unique and can contain any Unicode characters up
to a maximum length of 1024.
""")
  displayName?: string;

  @doc("""
For information about available sizes of virtual machines in Pools, see Choose
a VM size for Compute Nodes in an Azure Batch Pool
(https://docs.microsoft.com/azure/batch/batch-pool-vm-sizes).
""")
  vmSize: string;

  @doc("""
This property must be specified if the Pool needs to be created with Azure PaaS
VMs. This property and virtualMachineConfiguration are mutually exclusive and
one of the properties must be specified. If neither is specified then the Batch
service returns an error; if you are calling the REST API directly, the HTTP
status code is 400 (Bad Request). This property cannot be specified if the
Batch Account was created with its poolAllocationMode property set to
'UserSubscription'.
""")
  cloudServiceConfiguration?: CloudServiceConfiguration;

  @doc("""
This property must be specified if the Pool needs to be created with Azure IaaS
VMs. This property and cloudServiceConfiguration are mutually exclusive and one
of the properties must be specified. If neither is specified then the Batch
service returns an error; if you are calling the REST API directly, the HTTP
status code is 400 (Bad Request).
""")
  virtualMachineConfiguration?: VirtualMachineConfiguration;

  @doc("""
The default value is 1. The maximum value is the smaller of 4 times the number
of cores of the vmSize of the pool or 256.
""")
  taskSlotsPerNode?: int32;

  @doc("If not specified, the default is spread.")
  taskSchedulingPolicy?: TaskSchedulingPolicy;

  @doc("""
This timeout applies only to manual scaling; it has no effect when
enableAutoScale is set to true. The default value is 15 minutes. The minimum
value is 5 minutes. If you specify a value less than 5 minutes, the Batch
service rejects the request with an error; if you are calling the REST API
directly, the HTTP status code is 400 (Bad Request).
""")
  resizeTimeout?: duration;

  @doc("""
This property must not be specified if enableAutoScale is set to true. If
enableAutoScale is set to false, then you must set either targetDedicatedNodes,
targetLowPriorityNodes, or both.
""")
  targetDedicatedNodes?: int32;

  @doc("""
This property must not be specified if enableAutoScale is set to true. If
enableAutoScale is set to false, then you must set either targetDedicatedNodes,
targetLowPriorityNodes, or both.
""")
  targetLowPriorityNodes?: int32;

  @doc("""
If false, at least one of targetDedicatedNodes and targetLowPriorityNodes must
be specified. If true, the autoScaleFormula element is required. The Pool
automatically resizes according to the formula. The default value is false.
""")
  enableAutoScale?: boolean;

  @doc("""
This property must not be specified if enableAutoScale is set to false. It is
required if enableAutoScale is set to true. The formula is checked for validity
before the Pool is created. If the formula is not valid, the Batch service
rejects the request with detailed error information.
""")
  autoScaleFormula?: string;

  @doc("""
The default value is 15 minutes. The minimum and maximum value are 5 minutes
and 168 hours respectively. If you specify a value less than 5 minutes or
greater than 168 hours, the Batch service rejects the request with an invalid
property value error; if you are calling the REST API directly, the HTTP status
code is 400 (Bad Request).
""")
  autoScaleEvaluationInterval?: duration;

  @doc("""
Enabling inter-node communication limits the maximum size of the Pool due to
deployment restrictions on the Compute Nodes of the Pool. This may result in
the Pool not reaching its desired size. The default value is false.
""")
  enableInterNodeCommunication?: boolean;

  @doc("The network configuration for a Pool.")
  networkConfiguration?: NetworkConfiguration;

  @doc("""
Batch will retry Tasks when a recovery operation is triggered on a Node.
Examples of recovery operations include (but are not limited to) when an
unhealthy Node is rebooted or a Compute Node disappeared due to host failure.
Retries due to recovery operations are independent of and are not counted
against the maxTaskRetryCount. Even if the maxTaskRetryCount is 0, an internal
retry due to a recovery operation may occur. Because of this, all Tasks should
be idempotent. This means Tasks need to tolerate being interrupted and
restarted without causing any corruption or duplicate data. The best practice
for long running Tasks is to use some form of checkpointing. In some cases the
StartTask may be re-run even though the Compute Node was not rebooted. Special
care should be taken to avoid StartTasks which create breakaway process or
install/launch services from the StartTask working directory, as this will
block Batch from being able to re-run the StartTask.
""")
  startTask?: StartTask;

  @doc("""
For Windows Nodes, the Batch service installs the Certificates to the specified
Certificate store and location. For Linux Compute Nodes, the Certificates are
stored in a directory inside the Task working directory and an environment
variable AZ_BATCH_CERTIFICATES_DIR is supplied to the Task to query for this
location. For Certificates with visibility of 'remoteUser', a 'certs' directory
is created in the user's home directory (e.g., /home/{user-name}/certs) and
Certificates are placed in that directory.
""")
  certificateReferences?: CertificateReference[];

  @doc("""
Changes to Package references affect all new Nodes joining the Pool, but do not
affect Compute Nodes that are already in the Pool until they are rebooted or
reimaged. There is a maximum of 10 Package references on any given Pool.
""")
  applicationPackageReferences?: ApplicationPackageReference[];

  @doc("""
The list of application licenses must be a subset of available Batch service
application licenses. If a license is requested which is not supported, Pool
creation will fail. The permitted licenses available on the Pool are 'maya',
'vray', '3dsmax', 'arnold'. An additional charge applies for each application
license added to the Pool.
""")
  applicationLicenses?: string[];

  @doc("The list of user Accounts to be created on each Compute Node in the Pool.")
  userAccounts?: UserAccount[];

  @doc("""
The Batch service does not assign any meaning to metadata; it is solely for the
use of user code.
""")
  metadata?: MetadataItem[];

  @doc("This supports Azure Files, NFS, CIFS/SMB, and Blobfuse.")
  mountConfiguration?: MountConfiguration[];
}

@doc("""
The configuration for Compute Nodes in a Pool based on the Azure Cloud Services
platform.
""")
model CloudServiceConfiguration {
  @doc("""
Possible values are:
2 - OS Family 2, equivalent to Windows Server 2008 R2
SP1.
3 - OS Family 3, equivalent to Windows Server 2012.
4 - OS Family 4,
equivalent to Windows Server 2012 R2.
5 - OS Family 5, equivalent to Windows
Server 2016.
6 - OS Family 6, equivalent to Windows Server 2019. For more
information, see Azure Guest OS Releases
(https://azure.microsoft.com/documentation/articles/cloud-services-guestos-update-matrix/#releases).
""")
  osFamily: string;

  @doc("""
The default value is * which specifies the latest operating system version for
the specified OS family.
""")
  osVersion?: string;
}

@doc("""
The configuration for Compute Nodes in a Pool based on the Azure Virtual
Machines infrastructure.
""")
model VirtualMachineConfiguration {
  @doc("""
A reference to an Azure Virtual Machines Marketplace Image or a Shared Image
Gallery Image. To get the list of all Azure Marketplace Image references
verified by Azure Batch, see the 'List Supported Images' operation.
""")
  imageReference: ImageReference;

  @doc("""
The Batch Compute Node agent is a program that runs on each Compute Node in the
Pool, and provides the command-and-control interface between the Compute Node
and the Batch service. There are different implementations of the Compute Node
agent, known as SKUs, for different operating systems. You must specify a
Compute Node agent SKU which matches the selected Image reference. To get the
list of supported Compute Node agent SKUs along with their list of verified
Image references, see the 'List supported Compute Node agent SKUs' operation.
""")
  nodeAgentSKUId: string;

  @doc("""
This property must not be specified if the imageReference property specifies a
Linux OS Image.
""")
  windowsConfiguration?: WindowsConfiguration;

  @doc("""
This property must be specified if the Compute Nodes in the Pool need to have
empty data disks attached to them. This cannot be updated. Each Compute Node
gets its own disk (the disk is not a file share). Existing disks cannot be
attached, each attached disk is empty. When the Compute Node is removed from
the Pool, the disk and all data associated with it is also deleted. The disk is
not formatted after being attached, it must be formatted before use - for more
information see
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/classic/attach-disk#initialize-a-new-data-disk-in-linux
and
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/attach-disk-ps#add-an-empty-data-disk-to-a-virtual-machine.
""")
  dataDisks?: DataDisk[];

  @doc("""
This only applies to Images that contain the Windows operating system, and
should only be used when you hold valid on-premises licenses for the Compute
Nodes which will be deployed. If omitted, no on-premises licensing discount is
applied. Values are:

 Windows_Server - The on-premises license is for Windows
Server.
 Windows_Client - The on-premises license is for Windows Client.

""")
  licenseType?: string;

  @doc("""
If specified, setup is performed on each Compute Node in the Pool to allow
Tasks to run in containers. All regular Tasks and Job manager Tasks run on this
Pool must specify the containerSettings property, and all other Tasks may
specify it.
""")
  containerConfiguration?: ContainerConfiguration;

  @doc("""
If specified, encryption is performed on each node in the pool during node
provisioning.
""")
  diskEncryptionConfiguration?: DiskEncryptionConfiguration;

  @doc("""
This configuration will specify rules on how nodes in the pool will be
physically allocated.
""")
  nodePlacementConfiguration?: NodePlacementConfiguration;

  @doc("""
If specified, the extensions mentioned in this configuration will be installed
on each node.
""")
  extensions?: VMExtension[];

  @doc("Settings for the operating system disk of the compute node (VM).")
  osDisk?: OSDisk;
}

@doc("Windows operating system settings to apply to the virtual machine.")
model WindowsConfiguration {
  @doc("If omitted, the default value is true.")
  enableAutomaticUpdates?: boolean;
}

@doc("""
Settings which will be used by the data disks associated to Compute Nodes in
the Pool. When using attached data disks, you need to mount and format the
disks from within a VM to use them.
""")
model DataDisk {
  @doc("""
The lun is used to uniquely identify each data disk. If attaching multiple
disks, each should have a distinct lun. The value must be between 0 and 63,
inclusive.
""")
  lun: int32;

  @doc("""
The default value for caching is readwrite. For information about the caching
options see:
https://blogs.msdn.microsoft.com/windowsazurestorage/2012/06/27/exploring-windows-azure-drives-disks-and-images/.
""")
  caching?: CachingType;

  @doc("The initial disk size in gigabytes.")
  diskSizeGB: int32;

  @doc("If omitted, the default is \"standard_lrs\".")
  storageAccountType?: StorageAccountType;
}

@doc("The configuration for container-enabled Pools.")
model ContainerConfiguration {
  @doc("The container technology to be used.")
  type: "dockerCompatible";

  @doc("""
This is the full Image reference, as would be specified to \"docker pull\". An
Image will be sourced from the default Docker registry unless the Image is
fully qualified with an alternative registry.
""")
  containerImageNames?: string[];

  @doc("""
If any Images must be downloaded from a private registry which requires
credentials, then those credentials must be provided here.
""")
  containerRegistries?: ContainerRegistry[];
}

@doc("""
The disk encryption configuration applied on compute nodes in the pool. Disk
encryption configuration is not supported on Linux pool created with Shared
Image Gallery Image.
""")
model DiskEncryptionConfiguration {
  @doc("""
If omitted, no disks on the compute nodes in the pool will be encrypted. On
Linux pool, only \"TemporaryDisk\" is supported; on Windows pool, \"OsDisk\"
and \"TemporaryDisk\" must be specified.
""")
  targets?: DiskEncryptionTarget[];
}

@doc("""
For regional placement, nodes in the pool will be allocated in the same region.
For zonal placement, nodes in the pool will be spread across different zones
with best effort balancing.
""")
model NodePlacementConfiguration {
  @doc("""
Allocation policy used by Batch Service to provision the nodes. If not
specified, Batch will use the regional policy.
""")
  policy?: NodePlacementPolicyType;
}

@doc("The configuration for virtual machine extensions.")
model VMExtension {
  @doc("The name of the virtual machine extension.")
  name: string;

  @doc("The name of the extension handler publisher.")
  publisher: string;

  @doc("The type of the extension.")
  type: string;

  @doc("The version of script handler.")
  typeHandlerVersion?: string;

  @doc("""
Indicates whether the extension should use a newer minor version if one is
available at deployment time. Once deployed, however, the extension will not
upgrade minor versions unless redeployed, even with this property set to true.
""")
  autoUpgradeMinorVersion?: boolean;

  @doc("JSON formatted public settings for the extension.")
  settings?: unknown;

  @doc("""
The extension can contain either protectedSettings or
protectedSettingsFromKeyVault or no protected settings at all. 
""")
  protectedSettings?: unknown;

  @doc("""
Collection of extension names after which this extension needs to be
provisioned.
""")
  provisionAfterExtensions?: string[];
}

@doc("Settings for the operating system disk of the compute node (VM).")
model OSDisk {
  @doc("""
Specifies the ephemeral Disk Settings for the operating system disk used by the
compute node (VM).
""")
  ephemeralOSDiskSettings?: DiffDiskSettings;
}

@doc("""
Specifies the ephemeral Disk Settings for the operating system disk used by the
compute node (VM).
""")
model DiffDiskSettings {
  @doc("""
This property can be used by user in the request to choose the location e.g.,
cache disk space for Ephemeral OS disk provisioning. For more information on
Ephemeral OS disk size requirements, please refer to Ephemeral OS disk size
requirements for Windows VMs at
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/ephemeral-os-disks#size-requirements
and Linux VMs at
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/ephemeral-os-disks#size-requirements.
""")
  placement?: "CacheDisk";
}

@doc("Specifies how Tasks should be distributed across Compute Nodes.")
model TaskSchedulingPolicy {
  @doc("If not specified, the default is spread.")
  nodeFillType: ComputeNodeFillType;
}

@doc("The network configuration for a Pool.")
model NetworkConfiguration {
  @doc("""
The virtual network must be in the same region and subscription as the Azure
Batch Account. The specified subnet should have enough free IP addresses to
accommodate the number of Compute Nodes in the Pool. If the subnet doesn't have
enough free IP addresses, the Pool will partially allocate Nodes and a resize
error will occur. The 'MicrosoftAzureBatch' service principal must have the
'Classic Virtual Machine Contributor' Role-Based Access Control (RBAC) role for
the specified VNet. The specified subnet must allow communication from the
Azure Batch service to be able to schedule Tasks on the Nodes. This can be
verified by checking if the specified VNet has any associated Network Security
Groups (NSG). If communication to the Nodes in the specified subnet is denied
by an NSG, then the Batch service will set the state of the Compute Nodes to
unusable. For Pools created with virtualMachineConfiguration only ARM virtual
networks ('Microsoft.Network/virtualNetworks') are supported, but for Pools
created with cloudServiceConfiguration both ARM and classic virtual networks
are supported. If the specified VNet has any associated Network Security Groups
(NSG), then a few reserved system ports must be enabled for inbound
communication. For Pools created with a virtual machine configuration, enable
ports 29876 and 29877, as well as port 22 for Linux and port 3389 for Windows.
For Pools created with a cloud service configuration, enable ports 10100,
20100, and 30100. Also enable outbound connections to Azure Storage on port
443. For more details see:
https://docs.microsoft.com/en-us/azure/batch/batch-api-basics#virtual-network-vnet-and-firewall-configuration
""")
  subnetId?: string;

  @doc("The scope of dynamic vnet assignment.")
  dynamicVNetAssignmentScope?: DynamicVNetAssignmentScope;

  @doc("""
Pool endpoint configuration is only supported on Pools with the
virtualMachineConfiguration property.
""")
  endpointConfiguration?: PoolEndpointConfiguration;

  @doc("""
Public IP configuration property is only supported on Pools with the
virtualMachineConfiguration property.
""")
  publicIPAddressConfiguration?: PublicIPAddressConfiguration;
}

@doc("The endpoint configuration for a Pool.")
model PoolEndpointConfiguration {
  @doc("""
The maximum number of inbound NAT Pools per Batch Pool is 5. If the maximum
number of inbound NAT Pools is exceeded the request fails with HTTP status code
400. This cannot be specified if the IPAddressProvisioningType is
NoPublicIPAddresses.
""")
  inboundNATPools: InboundNATPool[];
}

@doc("""
A inbound NAT Pool that can be used to address specific ports on Compute Nodes
in a Batch Pool externally.
""")
model InboundNATPool {
  @doc("""
The name must be unique within a Batch Pool, can contain letters, numbers,
underscores, periods, and hyphens. Names must start with a letter or number,
must end with a letter, number, or underscore, and cannot exceed 77 characters.
 If any invalid values are provided the request fails with HTTP status code
400.
""")
  name: string;

  @doc("The protocol of the endpoint.")
  protocol: InboundEndpointProtocol;

  @doc("""
This must be unique within a Batch Pool. Acceptable values are between 1 and
65535 except for 22, 3389, 29876 and 29877 as these are reserved. If any
reserved values are provided the request fails with HTTP status code 400.
""")
  backendPort: int32;

  @doc("""
Acceptable values range between 1 and 65534 except ports from 50000 to 55000
which are reserved. All ranges within a Pool must be distinct and cannot
overlap. Each range must contain at least 40 ports. If any reserved or
overlapping values are provided the request fails with HTTP status code 400.
""")
  frontendPortRangeStart: int32;

  @doc("""
Acceptable values range between 1 and 65534 except ports from 50000 to 55000
which are reserved by the Batch service. All ranges within a Pool must be
distinct and cannot overlap. Each range must contain at least 40 ports. If any
reserved or overlapping values are provided the request fails with HTTP status
code 400.
""")
  frontendPortRangeEnd: int32;

  @doc("""
The maximum number of rules that can be specified across all the endpoints on a
Batch Pool is 25. If no network security group rules are specified, a default
rule will be created to allow inbound access to the specified backendPort. If
the maximum number of network security group rules is exceeded the request
fails with HTTP status code 400.
""")
  networkSecurityGroupRules?: NetworkSecurityGroupRule[];
}

@doc("A network security group rule to apply to an inbound endpoint.")
model NetworkSecurityGroupRule {
  @doc("""
Priorities within a Pool must be unique and are evaluated in order of priority.
The lower the number the higher the priority. For example, rules could be
specified with order numbers of 150, 250, and 350. The rule with the order
number of 150 takes precedence over the rule that has an order of 250. Allowed
priorities are 150 to 4096. If any reserved or duplicate values are provided
the request fails with HTTP status code 400.
""")
  priority: int32;

  @doc("The action that should be taken for a specified IP address, subnet range or tag.")
  access: NetworkSecurityGroupRuleAccess;

  @doc("""
Valid values are a single IP address (i.e. 10.10.10.10), IP subnet (i.e.
192.168.1.0/24), default tag, or * (for all addresses).  If any other values
are provided the request fails with HTTP status code 400.
""")
  sourceAddressPrefix: string;

  @doc("""
Valid values are '*' (for all ports 0 - 65535), a specific port (i.e. 22), or a
port range (i.e. 100-200). The ports must be in the range of 0 to 65535. Each
entry in this collection must not overlap any other entry (either a range or an
individual port). If any other values are provided the request fails with HTTP
status code 400. The default value is '*'.
""")
  sourcePortRanges?: string[];
}

@doc("The public IP Address configuration of the networking configuration of a Pool.")
model PublicIPAddressConfiguration {
  @doc("The default value is BatchManaged.")
  provision?: IPAddressProvisioningType;

  @doc("""
The number of IPs specified here limits the maximum size of the Pool - 100
dedicated nodes or 100 Spot/Low-priority nodes can be allocated for each public
IP. For example, a pool needing 250 dedicated VMs would need at least 3 public
IPs specified. Each element of this collection is of the form:
/subscriptions/{subscription}/resourceGroups/{group}/providers/Microsoft.Network/publicIPAddresses/{ip}.
""")
  ipAddressIds?: string[];
}

@doc("""
Batch will retry Tasks when a recovery operation is triggered on a Node.
Examples of recovery operations include (but are not limited to) when an
unhealthy Node is rebooted or a Compute Node disappeared due to host failure.
Retries due to recovery operations are independent of and are not counted
against the maxTaskRetryCount. Even if the maxTaskRetryCount is 0, an internal
retry due to a recovery operation may occur. Because of this, all Tasks should
be idempotent. This means Tasks need to tolerate being interrupted and
restarted without causing any corruption or duplicate data. The best practice
for long running Tasks is to use some form of checkpointing. In some cases the
StartTask may be re-run even though the Compute Node was not rebooted. Special
care should be taken to avoid StartTasks which create breakaway process or
install/launch services from the StartTask working directory, as this will
block Batch from being able to re-run the StartTask.
""")
model StartTask {
  @doc("""
The command line does not run under a shell, and therefore cannot take
advantage of shell features such as environment variable expansion. If you want
to take advantage of such features, you should invoke the shell in the command
line, for example using \"cmd /c MyCommand\" in Windows or \"/bin/sh -c
MyCommand\" in Linux. If the command line refers to file paths, it should use a
relative path (relative to the Task working directory), or use the Batch
provided environment variable
(https://docs.microsoft.com/en-us/azure/batch/batch-compute-node-environment-variables).
""")
  commandLine: string;

  @doc("""
When this is specified, all directories recursively below the
AZ_BATCH_NODE_ROOT_DIR (the root of Azure Batch directories on the node) are
mapped into the container, all Task environment variables are mapped into the
container, and the Task command line is executed in the container. Files
produced in the container outside of AZ_BATCH_NODE_ROOT_DIR might not be
reflected to the host disk, meaning that Batch file APIs will not be able to
access those files.
""")
  containerSettings?: TaskContainerSettings;

  @doc("Files listed under this element are located in the Task's working directory.")
  resourceFiles?: ResourceFile[];

  @doc("A list of environment variable settings for the StartTask.")
  environmentSettings?: EnvironmentSetting[];

  @doc("If omitted, the Task runs as a non-administrative user unique to the Task.")
  userIdentity?: UserIdentity;

  @doc("""
The Batch service retries a Task if its exit code is nonzero. Note that this
value specifically controls the number of retries. The Batch service will try
the Task once, and may then retry up to this limit. For example, if the maximum
retry count is 3, Batch tries the Task up to 4 times (one initial try and 3
retries). If the maximum retry count is 0, the Batch service does not retry the
Task. If the maximum retry count is -1, the Batch service retries the Task
without limit, however this is not recommended for a start task or any task.
The default value is 0 (no retries)
""")
  maxTaskRetryCount?: int32;

  @doc("""
If true and the StartTask fails on a Node, the Batch service retries the
StartTask up to its maximum retry count (maxTaskRetryCount). If the Task has
still not completed successfully after all retries, then the Batch service
marks the Node unusable, and will not schedule Tasks to it. This condition can
be detected via the Compute Node state and failure info details. If false, the
Batch service will not wait for the StartTask to complete. In this case, other
Tasks can start executing on the Compute Node while the StartTask is still
running; and even if the StartTask fails, new Tasks will continue to be
scheduled on the Compute Node. The default is true.
""")
  waitForSuccess?: boolean;
}

@doc("A reference to a Certificate to be installed on Compute Nodes in a Pool.")
model CertificateReference {
  @doc("The thumbprint of the Certificate.")
  thumbprint: string;

  @doc("The algorithm with which the thumbprint is associated. This must be sha1.")
  thumbprintAlgorithm: string;

  @doc("""
The default value is currentuser. This property is applicable only for Pools
configured with Windows Compute Nodes (that is, created with
cloudServiceConfiguration, or with virtualMachineConfiguration using a Windows
Image reference). For Linux Compute Nodes, the Certificates are stored in a
directory inside the Task working directory and an environment variable
AZ_BATCH_CERTIFICATES_DIR is supplied to the Task to query for this location.
For Certificates with visibility of 'remoteUser', a 'certs' directory is
created in the user's home directory (e.g., /home/{user-name}/certs) and
Certificates are placed in that directory.
""")
  storeLocation?: CertificateStoreLocation;

  @doc("""
This property is applicable only for Pools configured with Windows Compute
Nodes (that is, created with cloudServiceConfiguration, or with
virtualMachineConfiguration using a Windows Image reference). Common store
names include: My, Root, CA, Trust, Disallowed, TrustedPeople,
TrustedPublisher, AuthRoot, AddressBook, but any custom store name can also be
used. The default value is My.
""")
  storeName?: string;

  @doc("""
You can specify more than one visibility in this collection. The default is all
Accounts.
""")
  visibility?: CertificateVisibility[];
}

@doc("""
Properties used to create a user used to execute Tasks on an Azure Batch
Compute Node.
""")
model UserAccount {
  @doc("The name of the user Account.")
  name: string;

  @doc("The password for the user Account.")
  password: string;

  @doc("The default value is nonAdmin.")
  elevationLevel?: ElevationLevel;

  @doc("""
This property is ignored if specified on a Windows Pool. If not specified, the
user is created with the default options.
""")
  linuxUserConfiguration?: LinuxUserConfiguration;

  @doc("""
This property can only be specified if the user is on a Windows Pool. If not
specified and on a Windows Pool, the user is created with the default options.
""")
  windowsUserConfiguration?: WindowsUserConfiguration;
}

@doc("Properties used to create a user Account on a Linux Compute Node.")
model LinuxUserConfiguration {
  @doc("""
The uid and gid properties must be specified together or not at all. If not
specified the underlying operating system picks the uid.
""")
  uid?: int32;

  @doc("""
The uid and gid properties must be specified together or not at all. If not
specified the underlying operating system picks the gid.
""")
  gid?: int32;

  @doc("""
The private key must not be password protected. The private key is used to
automatically configure asymmetric-key based authentication for SSH between
Compute Nodes in a Linux Pool when the Pool's enableInterNodeCommunication
property is true (it is ignored if enableInterNodeCommunication is false). It
does this by placing the key pair into the user's .ssh directory. If not
specified, password-less SSH is not configured between Compute Nodes (no
modification of the user's .ssh directory is done).
""")
  sshPrivateKey?: string;
}

@doc("Properties used to create a user Account on a Windows Compute Node.")
model WindowsUserConfiguration {
  @doc("""
The default value for VirtualMachineConfiguration Pools is 'batch' and for
CloudServiceConfiguration Pools is 'interactive'.
""")
  loginMode?: LoginMode;
}

@doc("""
The Batch service does not assign any meaning to this metadata; it is solely
for the use of user code.
""")
model MetadataItem {
  @doc("The name of the metadata item.")
  name: string;

  @doc("The value of the metadata item.")
  value: string;
}

@doc("The file system to mount on each node.")
model MountConfiguration {
  @doc("This property is mutually exclusive with all other properties.")
  azureBlobFileSystemConfiguration?: AzureBlobFileSystemConfiguration;

  @doc("This property is mutually exclusive with all other properties.")
  nfsMountConfiguration?: NFSMountConfiguration;

  @doc("This property is mutually exclusive with all other properties.")
  cifsMountConfiguration?: CifsMountConfiguration;

  @doc("This property is mutually exclusive with all other properties.")
  azureFileShareConfiguration?: AzureFileShareConfiguration;
}

@doc("Information used to connect to an Azure Storage Container using Blobfuse.")
model AzureBlobFileSystemConfiguration {
  @doc("The Azure Storage Account name.")
  accountName: string;

  @doc("The Azure Blob Storage Container name.")
  containerName: string;

  @doc("""
This property is mutually exclusive with both sasKey and identity; exactly one
must be specified.
""")
  accountKey?: string;

  @doc("""
This property is mutually exclusive with both accountKey and identity; exactly
one must be specified.
""")
  sasKey?: string;

  @doc("These are 'net use' options in Windows and 'mount' options in Linux.")
  blobfuseOptions?: string;

  @doc("""
All file systems are mounted relative to the Batch mounts directory, accessible
via the AZ_BATCH_NODE_MOUNTS_DIR environment variable.
""")
  relativeMountPath: string;

  @doc("""
This property is mutually exclusive with both accountKey and sasKey; exactly
one must be specified.
""")
  identityReference?: ComputeNodeIdentityReference;
}

@doc("Information used to connect to an NFS file system.")
model NFSMountConfiguration {
  @doc("The URI of the file system to mount.")
  source: string;

  @doc("""
All file systems are mounted relative to the Batch mounts directory, accessible
via the AZ_BATCH_NODE_MOUNTS_DIR environment variable.
""")
  relativeMountPath: string;

  @doc("These are 'net use' options in Windows and 'mount' options in Linux.")
  mountOptions?: string;
}

@doc("Information used to connect to a CIFS file system.")
model CifsMountConfiguration {
  @doc("The user to use for authentication against the CIFS file system.")
  username: string;

  @doc("The URI of the file system to mount.")
  source: string;

  @doc("""
All file systems are mounted relative to the Batch mounts directory, accessible
via the AZ_BATCH_NODE_MOUNTS_DIR environment variable.
""")
  relativeMountPath: string;

  @doc("These are 'net use' options in Windows and 'mount' options in Linux.")
  mountOptions?: string;

  @doc("The password to use for authentication against the CIFS file system.")
  password: string;
}

@doc("Information used to connect to an Azure Fileshare.")
model AzureFileShareConfiguration {
  @doc("The Azure Storage account name.")
  accountName: string;

  @doc("This is of the form 'https://{account}.file.core.windows.net/'.")
  azureFileUrl: string;

  @doc("The Azure Storage account key.")
  accountKey: string;

  @doc("""
All file systems are mounted relative to the Batch mounts directory, accessible
via the AZ_BATCH_NODE_MOUNTS_DIR environment variable.
""")
  relativeMountPath: string;

  @doc("These are 'net use' options in Windows and 'mount' options in Linux.")
  mountOptions?: string;
}

@doc("""
Contains information about Jobs that have been and will be run under a Job
Schedule.
""")
model JobScheduleExecutionInformation {
  @doc("""
This property is meaningful only if the schedule is in the active state when
the time comes around. For example, if the schedule is disabled, no Job will be
created at nextRunTime unless the Job is enabled before then.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  nextRunTime?: utcDateTime;

  @doc("""
This property is present only if the at least one Job has run under the
schedule.
""")
  recentJob?: RecentJob;

  @doc("This property is set only if the Job Schedule is in the completed state.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;
}

@doc("Information about the most recent Job to run under the Job Schedule.")
model RecentJob {
  @doc("The ID of the Job.")
  id?: string;

  @doc("The URL of the Job.")
  url?: string;
}

@doc("Resource usage statistics for a Job Schedule.")
model JobScheduleStatistics {
  @doc("The URL of the statistics.")
  url: string;

  @doc("The start time of the time range covered by the statistics.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("""
The time at which the statistics were last updated. All statistics are limited
to the range between startTime and lastUpdateTime.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdateTime: utcDateTime;

  @doc("""
The total user mode CPU time (summed across all cores and all Compute Nodes)
consumed by all Tasks in all Jobs created under the schedule.
""")
  userCPUTime: duration;

  @doc("""
The total kernel mode CPU time (summed across all cores and all Compute Nodes)
consumed by all Tasks in all Jobs created under the schedule.
""")
  kernelCPUTime: duration;

  @doc("""
The wall clock time is the elapsed time from when the Task started running on a
Compute Node to when it finished (or to the last time the statistics were
updated, if the Task had not finished by then). If a Task was retried, this
includes the wall clock time of all the Task retries.
""")
  wallClockTime: duration;

  @doc("""
The total number of disk read operations made by all Tasks in all Jobs created
under the schedule.
""")
  readIOps: int32;

  @doc("""
The total number of disk write operations made by all Tasks in all Jobs created
under the schedule.
""")
  writeIOps: int32;

  @doc("""
The total gibibytes read from disk by all Tasks in all Jobs created under the
schedule.
""")
  readIOGiB: float32;

  @doc("""
The total gibibytes written to disk by all Tasks in all Jobs created under the
schedule.
""")
  writeIOGiB: float32;

  @doc("""
The total number of Tasks successfully completed during the given time range in
Jobs created under the schedule. A Task completes successfully if it returns
exit code 0.
""")
  numSucceededTasks: int32;

  @doc("""
The total number of Tasks that failed during the given time range in Jobs
created under the schedule. A Task fails if it exhausts its maximum retry count
without returning exit code 0.
""")
  numFailedTasks: int32;

  @doc("""
The total number of retries during the given time range on all Tasks in all
Jobs created under the schedule.
""")
  numTaskRetries: int32;

  @doc("""
This value is only reported in the Account lifetime statistics; it is not
included in the Job statistics.
""")
  waitTime: duration;
}

@doc("The set of changes to be made to a Job Schedule.")
model BatchJobScheduleUpdate {
  @doc("""
All times are fixed respective to UTC and are not impacted by daylight saving
time. If you do not specify this element, the existing schedule is left
unchanged.
""")
  schedule?: Schedule;

  @doc("""
Updates affect only Jobs that are started after the update has taken place. Any
currently active Job continues with the older specification.
""")
  jobSpecification?: JobSpecification;

  @doc("If you do not specify this element, existing metadata is left unchanged.")
  metadata?: MetadataItem[];
}

@doc("The result of listing the Job Schedules in an Account.")
@pagedResult
model BatchJobScheduleListResult {
  @doc("The list of Job Schedules.")
  @items
  value?: BatchJobSchedule[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("An Azure Batch Job.")
model BatchJob {
  @doc("""
The ID is case-preserving and case-insensitive (that is, you may not have two
IDs within an Account that differ only by case).
""")
  id?: string;

  @doc("The display name for the Job.")
  displayName?: string;

  @doc("""
Whether Tasks in the Job can define dependencies on each other. The default is
false.
""")
  usesTaskDependencies?: boolean;

  @doc("The URL of the Job.")
  @visibility("read")
  url?: string;

  @doc("""
This is an opaque string. You can use it to detect whether the Job has changed
between requests. In particular, you can be pass the ETag when updating a Job
to specify that your changes should take effect only if nobody else has
modified the Job in the meantime.
""")
  @visibility("read")
  eTag?: string;

  @doc("""
This is the last time at which the Job level data, such as the Job state or
priority, changed. It does not factor in task-level changes such as adding new
Tasks or Tasks changing state.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModified?: utcDateTime;

  @doc("The creation time of the Job.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  creationTime?: utcDateTime;

  @doc("The state of the Job.")
  @visibility("read")
  state?: JobState;

  @doc("The time at which the Job entered its current state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  stateTransitionTime?: utcDateTime;

  @doc("This property is not set if the Job is in its initial Active state.")
  @visibility("read")
  previousState?: JobState;

  @doc("This property is not set if the Job is in its initial Active state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  previousStateTransitionTime?: utcDateTime;

  @doc("""
Priority values can range from -1000 to 1000, with -1000 being the lowest
priority and 1000 being the highest priority. The default value is 0.
""")
  priority?: int32;

  @doc("""
If the value is set to True, other high priority jobs submitted to the system
will take precedence and will be able requeue tasks from this job. You can
update a job's allowTaskPreemption after it has been created using the update
job API.
""")
  allowTaskPreemption?: boolean;

  @doc("""
The value of maxParallelTasks must be -1 or greater than 0 if specified. If not
specified, the default value is -1, which means there's no limit to the number
of tasks that can be run at once. You can update a job's maxParallelTasks after
it has been created using the update job API.
""")
  maxParallelTasks?: int32;

  @doc("The execution constraints for a Job.")
  constraints?: JobConstraints;

  @doc("""
The Job Manager Task is automatically started when the Job is created. The
Batch service tries to schedule the Job Manager Task before any other Tasks in
the Job. When shrinking a Pool, the Batch service tries to preserve Nodes where
Job Manager Tasks are running for as long as possible (that is, Compute Nodes
running 'normal' Tasks are removed before Compute Nodes running Job Manager
Tasks). When a Job Manager Task fails and needs to be restarted, the system
tries to schedule it at the highest priority. If there are no idle Compute
Nodes available, the system may terminate one of the running Tasks in the Pool
and return it to the queue in order to make room for the Job Manager Task to
restart. Note that a Job Manager Task in one Job does not have priority over
Tasks in other Jobs. Across Jobs, only Job level priorities are observed. For
example, if a Job Manager in a priority 0 Job needs to be restarted, it will
not displace Tasks of a priority 1 Job. Batch will retry Tasks when a recovery
operation is triggered on a Node. Examples of recovery operations include (but
are not limited to) when an unhealthy Node is rebooted or a Compute Node
disappeared due to host failure. Retries due to recovery operations are
independent of and are not counted against the maxTaskRetryCount. Even if the
maxTaskRetryCount is 0, an internal retry due to a recovery operation may
occur. Because of this, all Tasks should be idempotent. This means Tasks need
to tolerate being interrupted and restarted without causing any corruption or
duplicate data. The best practice for long running Tasks is to use some form of
checkpointing.
""")
  jobManagerTask?: JobManagerTask;

  @doc("""
The Job Preparation Task is a special Task run on each Compute Node before any
other Task of the Job.
""")
  jobPreparationTask?: JobPreparationTask;

  @doc("""
The Job Release Task is a special Task run at the end of the Job on each
Compute Node that has run any other Task of the Job.
""")
  jobReleaseTask?: JobReleaseTask;

  @doc("""
Individual Tasks can override an environment setting specified here by
specifying the same setting name with a different value.
""")
  commonEnvironmentSettings?: EnvironmentSetting[];

  @doc("Specifies how a Job should be assigned to a Pool.")
  poolInfo?: PoolInformation;

  @doc("The default is noaction.")
  onAllTasksComplete?: OnAllTasksComplete;

  @doc("""
A Task is considered to have failed if has a failureInfo. A failureInfo is set
if the Task completes with a non-zero exit code after exhausting its retry
count, or if there was an error starting the Task, for example due to a
resource file download error. The default is noaction.
""")
  onTaskFailure?: OnTaskFailure;

  @doc("The network configuration for the Job.")
  networkConfiguration?: JobNetworkConfiguration;

  @doc("""
The Batch service does not assign any meaning to metadata; it is solely for the
use of user code.
""")
  metadata?: MetadataItem[];

  @doc("Contains information about the execution of a Job in the Azure Batch service.")
  @visibility("read")
  executionInfo?: JobExecutionInformation;

  @doc("""
This property is populated only if the CloudJob was retrieved with an expand
clause including the 'stats' attribute; otherwise it is null. The statistics
may not be immediately available. The Batch service performs periodic roll-up
of statistics. The typical delay is about 30 minutes.
""")
  @visibility("read")
  stats?: JobStatistics;
}

@doc("Contains information about the execution of a Job in the Azure Batch service.")
model JobExecutionInformation {
  @doc("This is the time at which the Job was created.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("This property is set only if the Job is in the completed state.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  @doc("""
This element contains the actual Pool where the Job is assigned. When you get
Job details from the service, they also contain a poolInfo element, which
contains the Pool configuration data from when the Job was added or updated.
That poolInfo element may also contain a poolId element. If it does, the two
IDs are the same. If it does not, it means the Job ran on an auto Pool, and
this property contains the ID of that auto Pool.
""")
  poolId?: string;

  @doc("This property is not set if there was no error starting the Job.")
  schedulingError?: JobSchedulingError;

  @doc("""
This property is set only if the Job is in the completed state. If the Batch
service terminates the Job, it sets the reason as follows: JMComplete - the Job
Manager Task completed, and killJobOnCompletion was set to true.
MaxWallClockTimeExpiry - the Job reached its maxWallClockTime constraint.
TerminateJobSchedule - the Job ran as part of a schedule, and the schedule
terminated. AllTasksComplete - the Job's onAllTasksComplete attribute is set to
terminatejob, and all Tasks in the Job are complete. TaskFailed - the Job's
onTaskFailure attribute is set to performExitOptionsJobAction, and a Task in
the Job failed with an exit condition that specified a jobAction of
terminatejob. Any other string is a user-defined reason specified in a call to
the 'Terminate a Job' operation.
""")
  terminateReason?: string;
}

@doc("An error encountered by the Batch service when scheduling a Job.")
model JobSchedulingError {
  @doc("The category of the error.")
  category: ErrorCategory;

  @doc("""
An identifier for the Job scheduling error. Codes are invariant and are
intended to be consumed programmatically.
""")
  code?: string;

  @doc("""
A message describing the Job scheduling error, intended to be suitable for
display in a user interface.
""")
  message?: string;

  @doc("A list of additional error details related to the scheduling error.")
  details?: NameValuePair[];
}

@doc("The set of changes to be made to a Job.")
model BatchJobUpdate {
  @doc("""
Priority values can range from -1000 to 1000, with -1000 being the lowest
priority and 1000 being the highest priority. If omitted, the priority of the
Job is left unchanged.
""")
  priority?: int32;

  @doc("""
The value of maxParallelTasks must be -1 or greater than 0 if specified. If not
specified, the default value is -1, which means there's no limit to the number
of tasks that can be run at once. You can update a job's maxParallelTasks after
it has been created using the update job API.
""")
  maxParallelTasks?: int32;

  @doc("""
If the value is set to True, other high priority jobs submitted to the system
will take precedence and will be able requeue tasks from this job. You can
update a job's allowTaskPreemption after it has been created using the update
job API.
""")
  allowTaskPreemption?: boolean;

  @doc("""
If omitted, the completion behavior is left unchanged. You may not change the
value from terminatejob to noaction - that is, once you have engaged automatic
Job termination, you cannot turn it off again. If you try to do this, the
request fails with an 'invalid property value' error response; if you are
calling the REST API directly, the HTTP status code is 400 (Bad Request).
""")
  onAllTasksComplete?: OnAllTasksComplete;

  @doc("If omitted, the existing execution constraints are left unchanged.")
  constraints?: JobConstraints;

  @doc("""
You may change the Pool for a Job only when the Job is disabled. The Patch Job
call will fail if you include the poolInfo element and the Job is not disabled.
If you specify an autoPoolSpecification in the poolInfo, only the keepAlive
property of the autoPoolSpecification can be updated, and then only if the
autoPoolSpecification has a poolLifetimeOption of Job (other job properties can
be updated as normal). If omitted, the Job continues to run on its current
Pool.
""")
  poolInfo?: PoolInformation;

  @doc("If omitted, the existing Job metadata is left unchanged.")
  metadata?: MetadataItem[];
}

@doc("Options when disabling a Job.")
model BatchJobDisableParameters {
  @doc("What to do with active Tasks associated with the Job.")
  disableTasks: DisableJobOption;
}

@doc("Options when terminating a Job.")
model BatchJobTerminateParameters {
  @doc("""
The text you want to appear as the Job's TerminateReason. The default is
'UserTerminate'.
""")
  terminateReason?: string;
}

@doc("The result of listing the Jobs in an Account.")
@pagedResult
model BatchJobListResult {
  @doc("The list of Jobs.")
  @items
  value?: BatchJob[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("""
The result of listing the status of the Job Preparation and Job Release Tasks
for a Job.
""")
@pagedResult
model BatchJobListPreparationAndReleaseTaskStatusResult {
  @doc("A list of Job Preparation and Job Release Task execution information.")
  @items
  value?: JobPreparationAndReleaseTaskExecutionInformation[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("The status of the Job Preparation and Job Release Tasks on a Compute Node.")
model JobPreparationAndReleaseTaskExecutionInformation {
  @doc("The ID of the Pool containing the Compute Node to which this entry refers.")
  poolId?: string;

  @doc("The ID of the Compute Node to which this entry refers.")
  nodeId?: string;

  @doc("The URL of the Compute Node to which this entry refers.")
  nodeUrl?: string;

  @doc("""
Contains information about the execution of a Job Preparation Task on a Compute
Node.
""")
  jobPreparationTaskExecutionInfo?: JobPreparationTaskExecutionInformation;

  @doc("This property is set only if the Job Release Task has run on the Compute Node.")
  jobReleaseTaskExecutionInfo?: JobReleaseTaskExecutionInformation;
}

@doc("""
Contains information about the execution of a Job Preparation Task on a Compute
Node.
""")
model JobPreparationTaskExecutionInformation {
  @doc("""
If the Task has been restarted or retried, this is the most recent time at
which the Task started running.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("This property is set only if the Task is in the Completed state.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  @doc("The current state of the Job Preparation Task on the Compute Node.")
  state: JobPreparationTaskState;

  @doc("""
The root directory of the Job Preparation Task on the Compute Node. You can use
this path to retrieve files created by the Task, such as log files.
""")
  taskRootDirectory?: string;

  @doc("The URL to the root directory of the Job Preparation Task on the Compute Node.")
  taskRootDirectoryUrl?: string;

  @doc("""
This parameter is returned only if the Task is in the completed state. The exit
code for a process reflects the specific convention implemented by the
application developer for that process. If you use the exit code value to make
decisions in your code, be sure that you know the exit code convention used by
the application process. Note that the exit code may also be generated by the
Compute Node operating system, such as when a process is forcibly terminated.
""")
  exitCode?: int32;

  @doc("This property is set only if the Task runs in a container context.")
  containerInfo?: TaskContainerExecutionInformation;

  @doc("""
This property is set only if the Task is in the completed state and encountered
a failure.
""")
  failureInfo?: TaskFailureInformation;

  @doc("""
Task application failures (non-zero exit code) are retried, pre-processing
errors (the Task could not be run) and file upload errors are not retried. The
Batch service will retry the Task up to the limit specified by the constraints.
""")
  retryCount: int32;

  @doc("""
This property is set only if the Task was retried (i.e. retryCount is nonzero).
If present, this is typically the same as startTime, but may be different if
the Task has been restarted for reasons other than retry; for example, if the
Compute Node was rebooted during a retry, then the startTime is updated but the
lastRetryTime is not.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastRetryTime?: utcDateTime;

  @doc("""
If the value is 'failed', then the details of the failure can be found in the
failureInfo property.
""")
  result?: TaskExecutionResult;
}

@doc("Contains information about the container which a Task is executing.")
model TaskContainerExecutionInformation {
  @doc("The ID of the container.")
  containerId?: string;

  @doc("""
This is the state of the container according to the Docker service. It is
equivalent to the status field returned by \"docker inspect\".
""")
  state?: string;

  @doc("""
This is the detailed error string from the Docker service, if available. It is
equivalent to the error field returned by \"docker inspect\".
""")
  error?: string;
}

@doc("Information about a Task failure.")
model TaskFailureInformation {
  @doc("The category of the error.")
  category: ErrorCategory;

  @doc("""
An identifier for the Task error. Codes are invariant and are intended to be
consumed programmatically.
""")
  code?: string;

  @doc("""
A message describing the Task error, intended to be suitable for display in a
user interface.
""")
  message?: string;

  @doc("A list of additional details related to the error.")
  details?: NameValuePair[];
}

@doc("""
Contains information about the execution of a Job Release Task on a Compute
Node.
""")
model JobReleaseTaskExecutionInformation {
  @doc("""
If the Task has been restarted or retried, this is the most recent time at
which the Task started running.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("This property is set only if the Task is in the Completed state.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  @doc("The current state of the Job Release Task on the Compute Node.")
  state: JobReleaseTaskState;

  @doc("""
The root directory of the Job Release Task on the Compute Node. You can use
this path to retrieve files created by the Task, such as log files.
""")
  taskRootDirectory?: string;

  @doc("The URL to the root directory of the Job Release Task on the Compute Node.")
  taskRootDirectoryUrl?: string;

  @doc("""
This parameter is returned only if the Task is in the completed state. The exit
code for a process reflects the specific convention implemented by the
application developer for that process. If you use the exit code value to make
decisions in your code, be sure that you know the exit code convention used by
the application process. Note that the exit code may also be generated by the
Compute Node operating system, such as when a process is forcibly terminated.
""")
  exitCode?: int32;

  @doc("This property is set only if the Task runs in a container context.")
  containerInfo?: TaskContainerExecutionInformation;

  @doc("""
This property is set only if the Task is in the completed state and encountered
a failure.
""")
  failureInfo?: TaskFailureInformation;

  @doc("""
If the value is 'failed', then the details of the failure can be found in the
failureInfo property.
""")
  result?: TaskExecutionResult;
}

@doc("The Task and TaskSlot counts for a Job.")
model TaskCountsResult {
  @doc("The Task counts for a Job.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  taskCounts: TaskCounts;

  @doc("The TaskSlot counts for a Job.")
  taskSlotCounts: TaskSlotCounts;
}

@doc("The Task counts for a Job.")
model TaskCounts {
  @doc("The number of Tasks in the active state.")
  active: int32;

  @doc("The number of Tasks in the running or preparing state.")
  running: int32;

  @doc("The number of Tasks in the completed state.")
  completed: int32;

  @doc("""
The number of Tasks which succeeded. A Task succeeds if its result (found in
the executionInfo property) is 'success'.
""")
  succeeded: int32;

  @doc("""
The number of Tasks which failed. A Task fails if its result (found in the
executionInfo property) is 'failure'.
""")
  failed: int32;
}

@doc("The TaskSlot counts for a Job.")
model TaskSlotCounts {
  @doc("The number of TaskSlots for active Tasks.")
  active: int32;

  @doc("The number of TaskSlots for running Tasks.")
  running: int32;

  @doc("The number of TaskSlots for completed Tasks.")
  completed: int32;

  @doc("The number of TaskSlots for succeeded Tasks.")
  succeeded: int32;

  @doc("The number of TaskSlots for failed Tasks.")
  failed: int32;
}

@doc("A Pool in the Azure Batch service.")
model BatchPool {
  @doc("""
The ID can contain any combination of alphanumeric characters including hyphens
and underscores, and cannot contain more than 64 characters. The ID is
case-preserving and case-insensitive (that is, you may not have two IDs within
an Account that differ only by case).
""")
  id?: string;

  @doc("""
The display name need not be unique and can contain any Unicode characters up
to a maximum length of 1024.
""")
  displayName?: string;

  @doc("The URL of the Pool.")
  @visibility("read")
  url?: string;

  @doc("""
This is an opaque string. You can use it to detect whether the Pool has changed
between requests. In particular, you can be pass the ETag when updating a Pool
to specify that your changes should take effect only if nobody else has
modified the Pool in the meantime.
""")
  @visibility("read")
  eTag?: string;

  @doc("""
This is the last time at which the Pool level data, such as the
targetDedicatedNodes or enableAutoscale settings, changed. It does not factor
in node-level changes such as a Compute Node changing state.
""")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModified?: utcDateTime;

  @doc("The creation time of the Pool.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  creationTime?: utcDateTime;

  @doc("The current state of the Pool.")
  @visibility("read")
  state?: PoolState;

  @doc("The time at which the Pool entered its current state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  stateTransitionTime?: utcDateTime;

  @doc("Whether the Pool is resizing.")
  @visibility("read")
  allocationState?: AllocationState;

  @doc("The time at which the Pool entered its current allocation state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  allocationStateTransitionTime?: utcDateTime;

  @doc("""
For information about available sizes of virtual machines in Pools, see Choose
a VM size for Compute Nodes in an Azure Batch Pool
(https://docs.microsoft.com/azure/batch/batch-pool-vm-sizes).
""")
  vmSize?: string;

  @doc("""
This property and virtualMachineConfiguration are mutually exclusive and one of
the properties must be specified. This property cannot be specified if the
Batch Account was created with its poolAllocationMode property set to
'UserSubscription'.
""")
  cloudServiceConfiguration?: CloudServiceConfiguration;

  @doc("""
This property and cloudServiceConfiguration are mutually exclusive and one of
the properties must be specified.
""")
  virtualMachineConfiguration?: VirtualMachineConfiguration;

  @doc("""
This is the timeout for the most recent resize operation. (The initial sizing
when the Pool is created counts as a resize.) The default value is 15 minutes.
""")
  resizeTimeout?: duration;

  @doc("""
This property is set only if one or more errors occurred during the last Pool
resize, and only when the Pool allocationState is Steady.
""")
  @visibility("read")
  resizeErrors?: ResizeError[];

  @doc("The number of dedicated Compute Nodes currently in the Pool.")
  @visibility("read")
  currentDedicatedNodes?: int32;

  @doc("""
Spot/Low-priority Compute Nodes which have been preempted are included in this
count.
""")
  @visibility("read")
  currentLowPriorityNodes?: int32;

  @doc("The desired number of dedicated Compute Nodes in the Pool.")
  targetDedicatedNodes?: int32;

  @doc("The desired number of Spot/Low-priority Compute Nodes in the Pool.")
  targetLowPriorityNodes?: int32;

  @doc("""
If false, at least one of targetDedicatedNodes and targetLowPriorityNodes must
be specified. If true, the autoScaleFormula property is required and the Pool
automatically resizes according to the formula. The default value is false.
""")
  enableAutoScale?: boolean;

  @doc("""
This property is set only if the Pool automatically scales, i.e.
enableAutoScale is true.
""")
  autoScaleFormula?: string;

  @doc("""
This property is set only if the Pool automatically scales, i.e.
enableAutoScale is true.
""")
  autoScaleEvaluationInterval?: duration;

  @doc("""
This property is set only if the Pool automatically scales, i.e.
enableAutoScale is true.
""")
  @visibility("read")
  autoScaleRun?: AutoScaleRun;

  @doc("""
This imposes restrictions on which Compute Nodes can be assigned to the Pool.
Specifying this value can reduce the chance of the requested number of Compute
Nodes to be allocated in the Pool.
""")
  enableInterNodeCommunication?: boolean;

  @doc("The network configuration for a Pool.")
  networkConfiguration?: NetworkConfiguration;

  @doc("""
Batch will retry Tasks when a recovery operation is triggered on a Node.
Examples of recovery operations include (but are not limited to) when an
unhealthy Node is rebooted or a Compute Node disappeared due to host failure.
Retries due to recovery operations are independent of and are not counted
against the maxTaskRetryCount. Even if the maxTaskRetryCount is 0, an internal
retry due to a recovery operation may occur. Because of this, all Tasks should
be idempotent. This means Tasks need to tolerate being interrupted and
restarted without causing any corruption or duplicate data. The best practice
for long running Tasks is to use some form of checkpointing. In some cases the
StartTask may be re-run even though the Compute Node was not rebooted. Special
care should be taken to avoid StartTasks which create breakaway process or
install/launch services from the StartTask working directory, as this will
block Batch from being able to re-run the StartTask.
""")
  startTask?: StartTask;

  @doc("""
For Windows Nodes, the Batch service installs the Certificates to the specified
Certificate store and location. For Linux Compute Nodes, the Certificates are
stored in a directory inside the Task working directory and an environment
variable AZ_BATCH_CERTIFICATES_DIR is supplied to the Task to query for this
location. For Certificates with visibility of 'remoteUser', a 'certs' directory
is created in the user's home directory (e.g., /home/{user-name}/certs) and
Certificates are placed in that directory.
""")
  certificateReferences?: CertificateReference[];

  @doc("""
Changes to Package references affect all new Nodes joining the Pool, but do not
affect Compute Nodes that are already in the Pool until they are rebooted or
reimaged. There is a maximum of 10 Package references on any given Pool.
""")
  applicationPackageReferences?: ApplicationPackageReference[];

  @doc("""
The list of application licenses must be a subset of available Batch service
application licenses. If a license is requested which is not supported, Pool
creation will fail.
""")
  applicationLicenses?: string[];

  @doc("""
The default value is 1. The maximum value is the smaller of 4 times the number
of cores of the vmSize of the pool or 256.
""")
  taskSlotsPerNode?: int32;

  @doc("If not specified, the default is spread.")
  taskSchedulingPolicy?: TaskSchedulingPolicy;

  @doc("The list of user Accounts to be created on each Compute Node in the Pool.")
  userAccounts?: UserAccount[];

  @doc("A list of name-value pairs associated with the Pool as metadata.")
  metadata?: MetadataItem[];

  @doc("""
This property is populated only if the CloudPool was retrieved with an expand
clause including the 'stats' attribute; otherwise it is null. The statistics
may not be immediately available. The Batch service performs periodic roll-up
of statistics. The typical delay is about 30 minutes.
""")
  @visibility("read")
  stats?: PoolStatistics;

  @doc("This supports Azure Files, NFS, CIFS/SMB, and Blobfuse.")
  mountConfiguration?: MountConfiguration[];

  @doc("""
The list of user identities associated with the Batch pool. The user identity
dictionary key references will be ARM resource ids in the form:
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
""")
  @visibility("read")
  identity?: BatchPoolIdentity;
}

@doc("An error that occurred when resizing a Pool.")
model ResizeError {
  @doc("""
An identifier for the Pool resize error. Codes are invariant and are intended
to be consumed programmatically.
""")
  code?: string;

  @doc("""
A message describing the Pool resize error, intended to be suitable for display
in a user interface.
""")
  message?: string;

  @doc("A list of additional error details related to the Pool resize error.")
  values?: NameValuePair[];
}

@doc("The results and errors from an execution of a Pool autoscale formula.")
model AutoScaleRun {
  @doc("The time at which the autoscale formula was last evaluated.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp: utcDateTime;

  @doc("""
Each variable value is returned in the form $variable=value, and variables are
separated by semicolons.
""")
  results?: string;

  @doc("An error that occurred when executing or evaluating a Pool autoscale formula.")
  error?: AutoScaleRunError;
}

@doc("An error that occurred when executing or evaluating a Pool autoscale formula.")
model AutoScaleRunError {
  @doc("""
An identifier for the autoscale error. Codes are invariant and are intended to
be consumed programmatically.
""")
  code?: string;

  @doc("""
A message describing the autoscale error, intended to be suitable for display
in a user interface.
""")
  message?: string;

  @doc("A list of additional error details related to the autoscale error.")
  values?: NameValuePair[];
}

@doc("The identity of the Batch pool, if configured.")
model BatchPoolIdentity {
  @doc("""
The list of user identities associated with the Batch pool. The user identity
dictionary key references will be ARM resource ids in the form:
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
""")
  type: PoolIdentityType;

  @doc("""
The user identity dictionary key references will be ARM resource ids in the
form:
'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}'.
""")
  userAssignedIdentities?: UserAssignedIdentity[];
}

@doc("The user assigned Identity")
model UserAssignedIdentity {
  @doc("The ARM resource id of the user assigned identity")
  resourceId: string;

  @doc("The client id of the user assigned identity.")
  @visibility("read")
  clientId?: string;

  @doc("The principal id of the user assigned identity.")
  @visibility("read")
  principalId?: string;
}

@doc("The result of listing the Pools in an Account.")
@pagedResult
model BatchPoolListResult {
  @doc("The list of Pools.")
  @items
  value?: BatchPool[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("The set of changes to be made to a Pool.")
model BatchPoolUpdate {
  @doc("""
If this element is present, it overwrites any existing StartTask. If omitted,
any existing StartTask is left unchanged.
""")
  startTask?: StartTask;

  @doc("""
If this element is present, it replaces any existing Certificate references
configured on the Pool. If omitted, any existing Certificate references are
left unchanged. For Windows Nodes, the Batch service installs the Certificates
to the specified Certificate store and location. For Linux Compute Nodes, the
Certificates are stored in a directory inside the Task working directory and an
environment variable AZ_BATCH_CERTIFICATES_DIR is supplied to the Task to query
for this location. For Certificates with visibility of 'remoteUser', a 'certs'
directory is created in the user's home directory (e.g.,
/home/{user-name}/certs) and Certificates are placed in that directory.
""")
  certificateReferences?: CertificateReference[];

  @doc("""
Changes to Package references affect all new Nodes joining the Pool, but do not
affect Compute Nodes that are already in the Pool until they are rebooted or
reimaged. If this element is present, it replaces any existing Package
references. If you specify an empty collection, then all Package references are
removed from the Pool. If omitted, any existing Package references are left
unchanged.
""")
  applicationPackageReferences?: ApplicationPackageReference[];

  @doc("""
If this element is present, it replaces any existing metadata configured on the
Pool. If you specify an empty collection, any metadata is removed from the
Pool. If omitted, any existing metadata is left unchanged.
""")
  metadata?: MetadataItem[];
}

@doc("Options for enabling automatic scaling on a Pool.")
model BatchPoolEnableAutoScaleParameters {
  @doc("""
The formula is checked for validity before it is applied to the Pool. If the
formula is not valid, the Batch service rejects the request with detailed error
information. For more information about specifying this formula, see
Automatically scale Compute Nodes in an Azure Batch Pool
(https://azure.microsoft.com/en-us/documentation/articles/batch-automatic-scaling).
""")
  autoScaleFormula?: string;

  @doc("""
The default value is 15 minutes. The minimum and maximum value are 5 minutes
and 168 hours respectively. If you specify a value less than 5 minutes or
greater than 168 hours, the Batch service rejects the request with an invalid
property value error; if you are calling the REST API directly, the HTTP status
code is 400 (Bad Request). If you specify a new interval, then the existing
autoscale evaluation schedule will be stopped and a new autoscale evaluation
schedule will be started, with its starting time being the time when this
request was issued.
""")
  autoScaleEvaluationInterval?: duration;
}

@doc("Options for evaluating an automatic scaling formula on a Pool.")
model BatchPoolEvaluateAutoScaleParameters {
  @doc("""
The formula is validated and its results calculated, but it is not applied to
the Pool. To apply the formula to the Pool, 'Enable automatic scaling on a
Pool'. For more information about specifying this formula, see Automatically
scale Compute Nodes in an Azure Batch Pool
(https://azure.microsoft.com/en-us/documentation/articles/batch-automatic-scaling).
""")
  autoScaleFormula: string;
}

@doc("Options for changing the size of a Pool.")
model BatchPoolResizeParameters {
  @doc("The desired number of dedicated Compute Nodes in the Pool.")
  targetDedicatedNodes?: int32;

  @doc("The desired number of Spot/Low-priority Compute Nodes in the Pool.")
  targetLowPriorityNodes?: int32;

  @doc("""
The default value is 15 minutes. The minimum value is 5 minutes. If you specify
a value less than 5 minutes, the Batch service returns an error; if you are
calling the REST API directly, the HTTP status code is 400 (Bad Request).
""")
  resizeTimeout?: duration;

  @doc("The default value is requeue.")
  nodeDeallocationOption?: ComputeNodeDeallocationOption;
}

@doc("Options for removing Compute Nodes from a Pool.")
model NodeRemoveParameters {
  @doc("A maximum of 100 nodes may be removed per request.")
  nodeList: string[];

  @doc("""
The default value is 15 minutes. The minimum value is 5 minutes. If you specify
a value less than 5 minutes, the Batch service returns an error; if you are
calling the REST API directly, the HTTP status code is 400 (Bad Request).
""")
  resizeTimeout?: duration;

  @doc("The default value is requeue.")
  nodeDeallocationOption?: ComputeNodeDeallocationOption;
}

@doc("""
Batch will retry Tasks when a recovery operation is triggered on a Node.
Examples of recovery operations include (but are not limited to) when an
unhealthy Node is rebooted or a Compute Node disappeared due to host failure.
Retries due to recovery operations are independent of and are not counted
against the maxTaskRetryCount. Even if the maxTaskRetryCount is 0, an internal
retry due to a recovery operation may occur. Because of this, all Tasks should
be idempotent. This means Tasks need to tolerate being interrupted and
restarted without causing any corruption or duplicate data. The best practice
for long running Tasks is to use some form of checkpointing.
""")
model BatchTask {
  @doc("""
The ID can contain any combination of alphanumeric characters including hyphens
and underscores, and cannot contain more than 64 characters.
""")
  id?: string;

  @doc("""
The display name need not be unique and can contain any Unicode characters up
to a maximum length of 1024.
""")
  displayName?: string;

  @doc("The URL of the Task.")
  @visibility("read")
  url?: string;

  @doc("""
This is an opaque string. You can use it to detect whether the Task has changed
between requests. In particular, you can be pass the ETag when updating a Task
to specify that your changes should take effect only if nobody else has
modified the Task in the meantime.
""")
  @visibility("read")
  eTag?: string;

  @doc("The last modified time of the Task.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModified?: utcDateTime;

  @doc("The creation time of the Task.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  creationTime?: utcDateTime;

  @doc("How the Batch service should respond when the Task completes.")
  exitConditions?: ExitConditions;

  @doc("The state of the Task.")
  @visibility("read")
  state?: TaskState;

  @doc("The time at which the Task entered its current state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  stateTransitionTime?: utcDateTime;

  @doc("This property is not set if the Task is in its initial Active state.")
  @visibility("read")
  previousState?: TaskState;

  @doc("This property is not set if the Task is in its initial Active state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  previousStateTransitionTime?: utcDateTime;

  @doc("""
For multi-instance Tasks, the command line is executed as the primary Task,
after the primary Task and all subtasks have finished executing the
coordination command line. The command line does not run under a shell, and
therefore cannot take advantage of shell features such as environment variable
expansion. If you want to take advantage of such features, you should invoke
the shell in the command line, for example using \"cmd /c MyCommand\" in
Windows or \"/bin/sh -c MyCommand\" in Linux. If the command line refers to
file paths, it should use a relative path (relative to the Task working
directory), or use the Batch provided environment variable
(https://docs.microsoft.com/en-us/azure/batch/batch-compute-node-environment-variables).
""")
  commandLine?: string;

  @doc("""
If the Pool that will run this Task has containerConfiguration set, this must
be set as well. If the Pool that will run this Task doesn't have
containerConfiguration set, this must not be set. When this is specified, all
directories recursively below the AZ_BATCH_NODE_ROOT_DIR (the root of Azure
Batch directories on the node) are mapped into the container, all Task
environment variables are mapped into the container, and the Task command line
is executed in the container. Files produced in the container outside of
AZ_BATCH_NODE_ROOT_DIR might not be reflected to the host disk, meaning that
Batch file APIs will not be able to access those files.
""")
  containerSettings?: TaskContainerSettings;

  @doc("""
For multi-instance Tasks, the resource files will only be downloaded to the
Compute Node on which the primary Task is executed. There is a maximum size for
the list of resource files.  When the max size is exceeded, the request will
fail and the response error code will be RequestEntityTooLarge. If this occurs,
the collection of ResourceFiles must be reduced in size. This can be achieved
using .zip files, Application Packages, or Docker Containers.
""")
  resourceFiles?: ResourceFile[];

  @doc("""
For multi-instance Tasks, the files will only be uploaded from the Compute Node
on which the primary Task is executed.
""")
  outputFiles?: OutputFile[];

  @doc("A list of environment variable settings for the Task.")
  environmentSettings?: EnvironmentSetting[];

  @doc("""
A locality hint that can be used by the Batch service to select a Compute Node
on which to start a Task.
""")
  affinityInfo?: AffinityInformation;

  @doc("Execution constraints to apply to a Task.")
  constraints?: TaskConstraints;

  @doc("""
The default is 1. A Task can only be scheduled to run on a compute node if the
node has enough free scheduling slots available. For multi-instance Tasks, this
must be 1.
""")
  requiredSlots?: int32;

  @doc("If omitted, the Task runs as a non-administrative user unique to the Task.")
  userIdentity?: UserIdentity;

  @doc("Information about the execution of a Task.")
  @visibility("read")
  executionInfo?: TaskExecutionInformation;

  @doc("Information about the Compute Node on which a Task ran.")
  @visibility("read")
  nodeInfo?: ComputeNodeInformation;

  @doc("""
Multi-instance Tasks are commonly used to support MPI Tasks. In the MPI case,
if any of the subtasks fail (for example due to exiting with a non-zero exit
code) the entire multi-instance Task fails. The multi-instance Task is then
terminated and retried, up to its retry limit.
""")
  multiInstanceSettings?: MultiInstanceSettings;

  @doc("Resource usage statistics for a Task.")
  @visibility("read")
  stats?: TaskStatistics;

  @doc("""
This Task will not be scheduled until all Tasks that it depends on have
completed successfully. If any of those Tasks fail and exhaust their retry
counts, this Task will never be scheduled.
""")
  dependsOn?: TaskDependencies;

  @doc("""
Application packages are downloaded and deployed to a shared directory, not the
Task working directory. Therefore, if a referenced package is already on the
Node, and is up to date, then it is not re-downloaded; the existing copy on the
Compute Node is used. If a referenced Package cannot be installed, for example
because the package has been deleted or because download failed, the Task
fails.
""")
  applicationPackageReferences?: ApplicationPackageReference[];

  @doc("""
If this property is set, the Batch service provides the Task with an
authentication token which can be used to authenticate Batch service operations
without requiring an Account access key. The token is provided via the
AZ_BATCH_AUTHENTICATION_TOKEN environment variable. The operations that the
Task can carry out using the token depend on the settings. For example, a Task
can request Job permissions in order to add other Tasks to the Job, or check
the status of the Job or of other Tasks under the Job.
""")
  authenticationTokenSettings?: AuthenticationTokenSettings;
}

@doc("Specifies how the Batch service should respond when the Task completes.")
model ExitConditions {
  @doc("""
A list of individual Task exit codes and how the Batch service should respond
to them.
""")
  exitCodes?: ExitCodeMapping[];

  @doc("""
A list of Task exit code ranges and how the Batch service should respond to
them.
""")
  exitCodeRanges?: ExitCodeRangeMapping[];

  @doc("Specifies how the Batch service responds to a particular exit condition.")
  preProcessingError?: ExitOptions;

  @doc("""
If the Task exited with an exit code that was specified via exitCodes or
exitCodeRanges, and then encountered a file upload error, then the action
specified by the exit code takes precedence.
""")
  fileUploadError?: ExitOptions;

  @doc("""
This value is used if the Task exits with any nonzero exit code not listed in
the exitCodes or exitCodeRanges collection, with a pre-processing error if the
preProcessingError property is not present, or with a file upload error if the
fileUploadError property is not present. If you want non-default behavior on
exit code 0, you must list it explicitly using the exitCodes or exitCodeRanges
collection.
""")
  default?: ExitOptions;
}

@doc("""
How the Batch service should respond if a Task exits with a particular exit
code.
""")
model ExitCodeMapping {
  @doc("A process exit code.")
  code: int32;

  @doc("Specifies how the Batch service responds to a particular exit condition.")
  exitOptions: ExitOptions;
}

@doc("Specifies how the Batch service responds to a particular exit condition.")
model ExitOptions {
  @doc("""
The default is none for exit code 0 and terminate for all other exit
conditions. If the Job's onTaskFailed property is noaction, then specifying
this property returns an error and the add Task request fails with an invalid
property value error; if you are calling the REST API directly, the HTTP status
code is 400 (Bad Request).
""")
  jobAction?: JobAction;

  @doc("""
Possible values are 'satisfy' (allowing dependent tasks to progress) and
'block' (dependent tasks continue to wait). Batch does not yet support
cancellation of dependent tasks.
""")
  dependencyAction?: DependencyAction;
}

@doc("""
A range of exit codes and how the Batch service should respond to exit codes
within that range.
""")
model ExitCodeRangeMapping {
  @doc("The first exit code in the range.")
  start: int32;

  @doc("The last exit code in the range.")
  end: int32;

  @doc("Specifies how the Batch service responds to a particular exit condition.")
  exitOptions: ExitOptions;
}

@doc("""
A locality hint that can be used by the Batch service to select a Compute Node
on which to start a Task.
""")
model AffinityInformation {
  @doc("""
You can pass the affinityId of a Node to indicate that this Task needs to run
on that Compute Node. Note that this is just a soft affinity. If the target
Compute Node is busy or unavailable at the time the Task is scheduled, then the
Task will be scheduled elsewhere.
""")
  affinityId: string;
}

@doc("Information about the execution of a Task.")
model TaskExecutionInformation {
  @doc("""
'Running' corresponds to the running state, so if the Task specifies resource
files or Packages, then the start time reflects the time at which the Task
started downloading or deploying these. If the Task has been restarted or
retried, this is the most recent time at which the Task started running. This
property is present only for Tasks that are in the running or completed state.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  @doc("This property is set only if the Task is in the Completed state.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  @doc("""
This property is set only if the Task is in the completed state. In general,
the exit code for a process reflects the specific convention implemented by the
application developer for that process. If you use the exit code value to make
decisions in your code, be sure that you know the exit code convention used by
the application process. However, if the Batch service terminates the Task (due
to timeout, or user termination via the API) you may see an operating
system-defined exit code.
""")
  exitCode?: int32;

  @doc("This property is set only if the Task runs in a container context.")
  containerInfo?: TaskContainerExecutionInformation;

  @doc("""
This property is set only if the Task is in the completed state and encountered
a failure.
""")
  failureInfo?: TaskFailureInformation;

  @doc("""
Task application failures (non-zero exit code) are retried, pre-processing
errors (the Task could not be run) and file upload errors are not retried. The
Batch service will retry the Task up to the limit specified by the constraints.
""")
  retryCount: int32;

  @doc("""
This element is present only if the Task was retried (i.e. retryCount is
nonzero). If present, this is typically the same as startTime, but may be
different if the Task has been restarted for reasons other than retry; for
example, if the Compute Node was rebooted during a retry, then the startTime is
updated but the lastRetryTime is not.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastRetryTime?: utcDateTime;

  @doc("""
When the user removes Compute Nodes from a Pool (by resizing/shrinking the
pool) or when the Job is being disabled, the user can specify that running
Tasks on the Compute Nodes be requeued for execution. This count tracks how
many times the Task has been requeued for these reasons.
""")
  requeueCount: int32;

  @doc("This property is set only if the requeueCount is nonzero.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastRequeueTime?: utcDateTime;

  @doc("""
If the value is 'failed', then the details of the failure can be found in the
failureInfo property.
""")
  result?: TaskExecutionResult;
}

@doc("Information about the Compute Node on which a Task ran.")
model ComputeNodeInformation {
  @doc("""
An identifier for the Node on which the Task ran, which can be passed when
adding a Task to request that the Task be scheduled on this Compute Node.
""")
  affinityId?: string;

  @doc("The URL of the Compute Node on which the Task ran. ")
  nodeUrl?: string;

  @doc("The ID of the Pool on which the Task ran.")
  poolId?: string;

  @doc("The ID of the Compute Node on which the Task ran.")
  nodeId?: string;

  @doc("The root directory of the Task on the Compute Node.")
  taskRootDirectory?: string;

  @doc("The URL to the root directory of the Task on the Compute Node.")
  taskRootDirectoryUrl?: string;
}

@doc("""
Multi-instance Tasks are commonly used to support MPI Tasks. In the MPI case,
if any of the subtasks fail (for example due to exiting with a non-zero exit
code) the entire multi-instance Task fails. The multi-instance Task is then
terminated and retried, up to its retry limit.
""")
model MultiInstanceSettings {
  @doc("If omitted, the default is 1.")
  numberOfInstances?: int32;

  @doc("""
A typical coordination command line launches a background service and verifies
that the service is ready to process inter-node messages.
""")
  coordinationCommandLine: string;

  @doc("""
The difference between common resource files and Task resource files is that
common resource files are downloaded for all subtasks including the primary,
whereas Task resource files are downloaded only for the primary. Also note that
these resource files are not downloaded to the Task working directory, but
instead are downloaded to the Task root directory (one directory above the
working directory).  There is a maximum size for the list of resource files. 
When the max size is exceeded, the request will fail and the response error
code will be RequestEntityTooLarge. If this occurs, the collection of
ResourceFiles must be reduced in size. This can be achieved using .zip files,
Application Packages, or Docker Containers.
""")
  commonResourceFiles?: ResourceFile[];
}

@doc("Resource usage statistics for a Task.")
model TaskStatistics {
  @doc("The URL of the statistics.")
  url: string;

  @doc("The start time of the time range covered by the statistics.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("""
The time at which the statistics were last updated. All statistics are limited
to the range between startTime and lastUpdateTime.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdateTime: utcDateTime;

  @doc("""
The total user mode CPU time (summed across all cores and all Compute Nodes)
consumed by the Task.
""")
  userCPUTime: duration;

  @doc("""
The total kernel mode CPU time (summed across all cores and all Compute Nodes)
consumed by the Task.
""")
  kernelCPUTime: duration;

  @doc("""
The wall clock time is the elapsed time from when the Task started running on a
Compute Node to when it finished (or to the last time the statistics were
updated, if the Task had not finished by then). If the Task was retried, this
includes the wall clock time of all the Task retries.
""")
  wallClockTime: duration;

  @doc("The total number of disk read operations made by the Task.")
  readIOps: int32;

  @doc("The total number of disk write operations made by the Task.")
  writeIOps: int32;

  @doc("The total gibibytes read from disk by the Task.")
  readIOGiB: float32;

  @doc("The total gibibytes written to disk by the Task.")
  writeIOGiB: float32;

  @doc("""
The total wait time of the Task. The wait time for a Task is defined as the
elapsed time between the creation of the Task and the start of Task execution.
(If the Task is retried due to failures, the wait time is the time to the most
recent Task execution.)
""")
  waitTime: duration;
}

@doc("""
Specifies any dependencies of a Task. Any Task that is explicitly specified or
within a dependency range must complete before the dependant Task will be
scheduled.
""")
model TaskDependencies {
  @doc("""
The taskIds collection is limited to 64000 characters total (i.e. the combined
length of all Task IDs). If the taskIds collection exceeds the maximum length,
the Add Task request fails with error code TaskDependencyListTooLong. In this
case consider using Task ID ranges instead.
""")
  taskIds?: string[];

  @doc("""
The list of Task ID ranges that this Task depends on. All Tasks in all ranges
must complete successfully before the dependent Task can be scheduled.
""")
  taskIdRanges?: TaskIdRange[];
}

@doc("""
The start and end of the range are inclusive. For example, if a range has start
9 and end 12, then it represents Tasks '9', '10', '11' and '12'.
""")
model TaskIdRange {
  @doc("The first Task ID in the range.")
  start: int32;

  @doc("The last Task ID in the range.")
  end: int32;
}

@doc("The result of listing the Tasks in a Job.")
@pagedResult
model BatchTaskListResult {
  @doc("The list of Tasks.")
  @items
  value?: BatchTask[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("A collection of Azure Batch Tasks to add.")
model BatchTaskCollection {
  @doc("""
The total serialized size of this collection must be less than 1MB. If it is
greater than 1MB (for example if each Task has 100's of resource files or
environment variables), the request will fail with code 'RequestBodyTooLarge'
and should be retried again with fewer Tasks.
""")
  value: BatchTask[];
}

@doc("The result of adding a collection of Tasks to a Job.")
model TaskAddCollectionResult {
  @doc("The results of the add Task collection operation.")
  value?: TaskAddResult[];
}

@doc("Result for a single Task added as part of an add Task collection operation.")
model TaskAddResult {
  @doc("The status of the add Task request.")
  status: TaskAddStatus;

  @doc("The ID of the Task for which this is the result.")
  taskId: string;

  @doc("""
You can use this to detect whether the Task has changed between requests. In
particular, you can be pass the ETag with an Update Task request to specify
that your changes should take effect only if nobody else has modified the Job
in the meantime.
""")
  eTag?: string;

  @doc("The last modified time of the Task.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModified?: utcDateTime;

  @doc("The URL of the Task, if the Task was successfully added.")
  location?: string;

  @doc("An error response received from the Azure Batch service.")
  error?: BatchError;
}

@doc("The result of listing the subtasks of a Task.")
model BatchTaskListSubtasksResult {
  @doc("The list of subtasks.")
  value?: SubtaskInformation[];
}

@doc("Information about an Azure Batch subtask.")
model SubtaskInformation {
  @doc("The ID of the subtask.")
  id?: int32;

  @doc("Information about the Compute Node on which a Task ran.")
  nodeInfo?: ComputeNodeInformation;

  @doc("""
The time at which the subtask started running. If the subtask has been
restarted or retried, this is the most recent time at which the subtask started
running.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime?: utcDateTime;

  @doc("This property is set only if the subtask is in the Completed state.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  @doc("""
This property is set only if the subtask is in the completed state. In general,
the exit code for a process reflects the specific convention implemented by the
application developer for that process. If you use the exit code value to make
decisions in your code, be sure that you know the exit code convention used by
the application process. However, if the Batch service terminates the subtask
(due to timeout, or user termination via the API) you may see an operating
system-defined exit code.
""")
  exitCode?: int32;

  @doc("This property is set only if the Task runs in a container context.")
  containerInfo?: TaskContainerExecutionInformation;

  @doc("""
This property is set only if the Task is in the completed state and encountered
a failure.
""")
  failureInfo?: TaskFailureInformation;

  @doc("The state of the subtask.")
  state?: SubtaskState;

  @doc("The time at which the subtask entered its current state.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  stateTransitionTime?: utcDateTime;

  @doc("This property is not set if the subtask is in its initial running state.")
  previousState?: SubtaskState;

  @doc("This property is not set if the subtask is in its initial running state.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  previousStateTransitionTime?: utcDateTime;

  @doc("""
If the value is 'failed', then the details of the failure can be found in the
failureInfo property.
""")
  result?: TaskExecutionResult;
}

@doc("A user Account for RDP or SSH access on a Compute Node.")
model ComputeNodeUser {
  @doc("The user name of the Account.")
  name: string;

  @doc("The default value is false.")
  isAdmin?: boolean;

  @doc("""
If omitted, the default is 1 day from the current time. For Linux Compute
Nodes, the expiryTime has a precision up to a day.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryTime?: utcDateTime;

  @doc("""
The password is required for Windows Compute Nodes (those created with
'cloudServiceConfiguration', or created with 'virtualMachineConfiguration'
using a Windows Image reference). For Linux Compute Nodes, the password can
optionally be specified along with the sshPublicKey property.
""")
  password?: string;

  @doc("""
The public key should be compatible with OpenSSH encoding and should be base 64
encoded. This property can be specified only for Linux Compute Nodes. If this
is specified for a Windows Compute Node, then the Batch service rejects the
request; if you are calling the REST API directly, the HTTP status code is 400
(Bad Request).
""")
  sshPublicKey?: string;
}

@doc("The set of changes to be made to a user Account on a Compute Node.")
model NodeUpdateUserParameters {
  @doc("""
The password is required for Windows Compute Nodes (those created with
'cloudServiceConfiguration', or created with 'virtualMachineConfiguration'
using a Windows Image reference). For Linux Compute Nodes, the password can
optionally be specified along with the sshPublicKey property. If omitted, any
existing password is removed.
""")
  password?: string;

  @doc("""
If omitted, the default is 1 day from the current time. For Linux Compute
Nodes, the expiryTime has a precision up to a day.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryTime?: utcDateTime;

  @doc("""
The public key should be compatible with OpenSSH encoding and should be base 64
encoded. This property can be specified only for Linux Compute Nodes. If this
is specified for a Windows Compute Node, then the Batch service rejects the
request; if you are calling the REST API directly, the HTTP status code is 400
(Bad Request). If omitted, any existing SSH public key is removed.
""")
  sshPublicKey?: string;
}

@doc("A Compute Node in the Batch service.")
model ComputeNode {
  @doc("""
Every Compute Node that is added to a Pool is assigned a unique ID. Whenever a
Compute Node is removed from a Pool, all of its local files are deleted, and
the ID is reclaimed and could be reused for new Compute Nodes.
""")
  id?: string;

  @doc("The URL of the Compute Node.")
  url?: string;

  @doc("""
The Spot/Low-priority Compute Node has been preempted. Tasks which were running
on the Compute Node when it was preempted will be rescheduled when another
Compute Node becomes available.
""")
  state?: ComputeNodeState;

  @doc("Whether the Compute Node is available for Task scheduling.")
  schedulingState?: SchedulingState;

  @doc("The time at which the Compute Node entered its current state.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  stateTransitionTime?: utcDateTime;

  @doc("This property may not be present if the Compute Node state is unusable.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastBootTime?: utcDateTime;

  @doc("""
This is the time when the Compute Node was initially allocated and doesn't
change once set. It is not updated when the Compute Node is service healed or
preempted.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  allocationTime?: utcDateTime;

  @doc("""
Every Compute Node that is added to a Pool is assigned a unique IP address.
Whenever a Compute Node is removed from a Pool, all of its local files are
deleted, and the IP address is reclaimed and could be reused for new Compute
Nodes.
""")
  ipAddress?: string;

  @doc("""
Note that this is just a soft affinity. If the target Compute Node is busy or
unavailable at the time the Task is scheduled, then the Task will be scheduled
elsewhere.
""")
  affinityId?: string;

  @doc("""
For information about available sizes of virtual machines in Pools, see Choose
a VM size for Compute Nodes in an Azure Batch Pool
(https://docs.microsoft.com/azure/batch/batch-pool-vm-sizes).
""")
  vmSize?: string;

  @doc("""
The total number of Job Tasks completed on the Compute Node. This includes Job
Manager Tasks and normal Tasks, but not Job Preparation, Job Release or Start
Tasks.
""")
  totalTasksRun?: int32;

  @doc("""
The total number of currently running Job Tasks on the Compute Node. This
includes Job Manager Tasks and normal Tasks, but not Job Preparation, Job
Release or Start Tasks.
""")
  runningTasksCount?: int32;

  @doc("""
The total number of scheduling slots used by currently running Job Tasks on the
Compute Node. This includes Job Manager Tasks and normal Tasks, but not Job
Preparation, Job Release or Start Tasks.
""")
  runningTaskSlotsCount?: int32;

  @doc("""
The total number of Job Tasks which completed successfully (with exitCode 0) on
the Compute Node. This includes Job Manager Tasks and normal Tasks, but not Job
Preparation, Job Release or Start Tasks.
""")
  totalTasksSucceeded?: int32;

  @doc("""
This property is present only if at least one Task has run on this Compute Node
since it was assigned to the Pool.
""")
  recentTasks?: TaskInformation[];

  @doc("""
Batch will retry Tasks when a recovery operation is triggered on a Node.
Examples of recovery operations include (but are not limited to) when an
unhealthy Node is rebooted or a Compute Node disappeared due to host failure.
Retries due to recovery operations are independent of and are not counted
against the maxTaskRetryCount. Even if the maxTaskRetryCount is 0, an internal
retry due to a recovery operation may occur. Because of this, all Tasks should
be idempotent. This means Tasks need to tolerate being interrupted and
restarted without causing any corruption or duplicate data. The best practice
for long running Tasks is to use some form of checkpointing. In some cases the
StartTask may be re-run even though the Compute Node was not rebooted. Special
care should be taken to avoid StartTasks which create breakaway process or
install/launch services from the StartTask working directory, as this will
block Batch from being able to re-run the StartTask.
""")
  startTask?: StartTask;

  @doc("Information about a StartTask running on a Compute Node.")
  startTaskInfo?: StartTaskInformation;

  @doc("""
For Windows Nodes, the Batch service installs the Certificates to the specified
Certificate store and location. For Linux Compute Nodes, the Certificates are
stored in a directory inside the Task working directory and an environment
variable AZ_BATCH_CERTIFICATES_DIR is supplied to the Task to query for this
location. For Certificates with visibility of 'remoteUser', a 'certs' directory
is created in the user's home directory (e.g., /home/{user-name}/certs) and
Certificates are placed in that directory.
""")
  certificateReferences?: CertificateReference[];

  @doc("The list of errors that are currently being encountered by the Compute Node.")
  errors?: ComputeNodeError[];

  @doc("""
Whether this Compute Node is a dedicated Compute Node. If false, the Compute
Node is a Spot/Low-priority Compute Node.
""")
  isDedicated?: boolean;

  @doc("The endpoint configuration for the Compute Node.")
  endpointConfiguration?: ComputeNodeEndpointConfiguration;

  @doc("""
The Batch Compute Node agent is a program that runs on each Compute Node in the
Pool and provides Batch capability on the Compute Node.
""")
  nodeAgentInfo?: NodeAgentInformation;

  @doc("Info about the current state of the virtual machine.")
  virtualMachineInfo?: VirtualMachineInfo;
}

@doc("Information about a Task running on a Compute Node.")
model TaskInformation {
  @doc("The URL of the Task.")
  taskUrl?: string;

  @doc("The ID of the Job to which the Task belongs.")
  jobId?: string;

  @doc("The ID of the Task.")
  taskId?: string;

  @doc("The ID of the subtask if the Task is a multi-instance Task.")
  subtaskId?: int32;

  @doc("The state of the Task.")
  taskState: TaskState;

  @doc("Information about the execution of a Task.")
  executionInfo?: TaskExecutionInformation;
}

@doc("Information about a StartTask running on a Compute Node.")
model StartTaskInformation {
  @doc("The state of the StartTask on the Compute Node.")
  state: StartTaskState;

  @doc("""
This value is reset every time the Task is restarted or retried (that is, this
is the most recent time at which the StartTask started running).
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("""
This is the end time of the most recent run of the StartTask, if that run has
completed (even if that run failed and a retry is pending). This element is not
present if the StartTask is currently running.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  @doc("""
This property is set only if the StartTask is in the completed state. In
general, the exit code for a process reflects the specific convention
implemented by the application developer for that process. If you use the exit
code value to make decisions in your code, be sure that you know the exit code
convention used by the application process. However, if the Batch service
terminates the StartTask (due to timeout, or user termination via the API) you
may see an operating system-defined exit code.
""")
  exitCode?: int32;

  @doc("This property is set only if the Task runs in a container context.")
  containerInfo?: TaskContainerExecutionInformation;

  @doc("""
This property is set only if the Task is in the completed state and encountered
a failure.
""")
  failureInfo?: TaskFailureInformation;

  @doc("""
Task application failures (non-zero exit code) are retried, pre-processing
errors (the Task could not be run) and file upload errors are not retried. The
Batch service will retry the Task up to the limit specified by the constraints.
""")
  retryCount: int32;

  @doc("""
This element is present only if the Task was retried (i.e. retryCount is
nonzero). If present, this is typically the same as startTime, but may be
different if the Task has been restarted for reasons other than retry; for
example, if the Compute Node was rebooted during a retry, then the startTime is
updated but the lastRetryTime is not.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastRetryTime?: utcDateTime;

  @doc("""
If the value is 'failed', then the details of the failure can be found in the
failureInfo property.
""")
  result?: TaskExecutionResult;
}

@doc("An error encountered by a Compute Node.")
model ComputeNodeError {
  @doc("""
An identifier for the Compute Node error. Codes are invariant and are intended
to be consumed programmatically.
""")
  code?: string;

  @doc("""
A message describing the Compute Node error, intended to be suitable for
display in a user interface.
""")
  message?: string;

  @doc("The list of additional error details related to the Compute Node error.")
  errorDetails?: NameValuePair[];
}

@doc("The endpoint configuration for the Compute Node.")
model ComputeNodeEndpointConfiguration {
  @doc("The list of inbound endpoints that are accessible on the Compute Node.")
  inboundEndpoints: InboundEndpoint[];
}

@doc("An inbound endpoint on a Compute Node.")
model InboundEndpoint {
  @doc("The name of the endpoint.")
  name: string;

  @doc("The protocol of the endpoint.")
  protocol: InboundEndpointProtocol;

  @doc("The public IP address of the Compute Node.")
  publicIPAddress: string;

  @doc("The public fully qualified domain name for the Compute Node.")
  @projectedName("json", "publicFQDN")
  publicFqdn: string;

  @doc("The public port number of the endpoint.")
  frontendPort: int32;

  @doc("The backend port number of the endpoint.")
  backendPort: int32;
}

@doc("""
The Batch Compute Node agent is a program that runs on each Compute Node in the
Pool and provides Batch capability on the Compute Node.
""")
model NodeAgentInformation {
  @doc("""
This version number can be checked against the Compute Node agent release notes
located at
https://github.com/Azure/Batch/blob/master/changelogs/nodeagent/CHANGELOG.md.
""")
  version: string;

  @doc("""
This is the most recent time that the Compute Node agent was updated to a new
version.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdateTime: utcDateTime;
}

@doc("Info about the current state of the virtual machine.")
model VirtualMachineInfo {
  @doc("""
A reference to an Azure Virtual Machines Marketplace Image or a Shared Image
Gallery Image. To get the list of all Azure Marketplace Image references
verified by Azure Batch, see the 'List Supported Images' operation.
""")
  imageReference?: ImageReference;
}

@doc("Options for rebooting a Compute Node.")
model NodeRebootParameters {
  @doc("The default value is requeue.")
  nodeRebootOption?: ComputeNodeRebootOption;
}

@doc("Options for reimaging a Compute Node.")
model NodeReimageParameters {
  @doc("The default value is requeue.")
  nodeReimageOption?: ComputeNodeReimageOption;
}

@doc("Options for disabling scheduling on a Compute Node.")
model NodeDisableSchedulingParameters {
  @doc("The default value is requeue.")
  nodeDisableSchedulingOption?: DisableComputeNodeSchedulingOption;
}

@doc("The remote login settings for a Compute Node.")
model ComputeNodeGetRemoteLoginSettingsResult {
  @doc("The IP address used for remote login to the Compute Node.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  remoteLoginIPAddress: string;

  @doc("The port used for remote login to the Compute Node.")
  remoteLoginPort: int32;
}

@doc("The Azure Batch service log files upload configuration for a Compute Node.")
model UploadBatchServiceLogsConfiguration {
  @doc("""
If a user assigned managed identity is not being used, the URL must include a
Shared Access Signature (SAS) granting write permissions to the container. The
SAS duration must allow enough time for the upload to finish. The start time
for SAS is optional and recommended to not be specified.
""")
  containerUrl: string;

  @doc("""
Any log file containing a log message in the time range will be uploaded. This
means that the operation might retrieve more logs than have been requested
since the entire log file is always uploaded, but the operation should not
retrieve fewer logs than have been requested.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("""
Any log file containing a log message in the time range will be uploaded. This
means that the operation might retrieve more logs than have been requested
since the entire log file is always uploaded, but the operation should not
retrieve fewer logs than have been requested. If omitted, the default is to
upload all logs available after the startTime.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime?: utcDateTime;

  @doc("The identity must have write access to the Azure Blob Storage container.")
  identityReference?: ComputeNodeIdentityReference;
}

@doc("The result of uploading Batch service log files from a specific Compute Node.")
@resource("pools/{poolId}/nodes/{nodeId}/uploadbatchservicelogs")
model UploadBatchServiceLogsResult {
  @doc("""
The virtual directory name is part of the blob name for each log file uploaded,
and it is built based poolId, nodeId and a unique identifier.
""")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  virtualDirectoryName: string;

  @doc("The number of log files which will be uploaded.")
  numberOfFilesUploaded: int32;
}

@doc("The result of listing the Compute Nodes in a Pool.")
@pagedResult
model ComputeNodeListResult {
  @doc("The list of Compute Nodes.")
  @items
  value?: ComputeNode[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@doc("The configuration for virtual machine extension instance view.")
model NodeVMExtension {
  @doc("The provisioning state of the virtual machine extension.")
  provisioningState?: string;

  @doc("The configuration for virtual machine extensions.")
  vmExtension?: VMExtension;

  @doc("The vm extension instance view.")
  instanceView?: VMExtensionInstanceView;
}

@doc("The vm extension instance view.")
model VMExtensionInstanceView {
  @doc("The name of the vm extension instance view.")
  name?: string;

  @doc("The resource status information.")
  statuses?: InstanceViewStatus[];

  @doc("The resource status information.")
  subStatuses?: InstanceViewStatus[];
}

@doc("The instance view status.")
model InstanceViewStatus {
  @doc("The status code.")
  code?: string;

  @doc("The localized label for the status.")
  displayStatus?: string;

  @doc("Level code.")
  level?: StatusLevelTypes;

  @doc("The detailed status message.")
  message?: string;

  @doc("The time of the status.")
  time?: string;
}

@doc("The result of listing the Compute Node extensions in a Node.")
@pagedResult
model NodeVMExtensionList {
  @doc("The list of Compute Node extensions.")
  @items
  value?: NodeVMExtension[];

  @doc("The URL to get the next set of results.")
  @nextLink
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}
