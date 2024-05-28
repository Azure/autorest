import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

namespace Azure.ResourceManager.MachineLearning;

interface Operations extends Azure.ResourceManager.Operations {}

/**
 * An enum describing the unit of usage measurement.
 */
enum UsageUnit {
  Count,
}

/**
 * Three lettered code specifying the currency of the VM price. Example: USD
 */
enum BillingCurrency {
  USD,
}

/**
 * The unit of time measurement for the specified VM price. Example: OneHour
 */
enum UnitOfMeasure {
  OneHour,
}

/**
 * Operating system type used by the VM.
 */
enum VMPriceOSType {
  Linux,
  Windows,
}

/**
 * The type of the VM.
 */
enum VMTier {
  Standard,
  LowPriority,
  Spot,
}

/**
 * An enum describing the unit of quota measurement.
 */
enum QuotaUnit {
  Count,
}

/**
 * Status of update workspace quota.
 */
enum Status {
  Undefined,
  Success,
  Failure,
  InvalidQuotaBelowClusterMinimum,
  InvalidQuotaExceedsSubscriptionLimit,
  InvalidVMFamilyName,
  OperationNotSupportedForSku,
  OperationNotEnabledForRegion,
}

/**
 * Type of managed service identity (where both SystemAssigned and UserAssigned types are allowed).
 */
enum ManagedServiceIdentityType {
  None,
  SystemAssigned,
  UserAssigned,
  `SystemAssigned,UserAssigned`,
}

/**
 * The type of compute
 */
enum ComputeType {
  AKS,
  Kubernetes,
  AmlCompute,
  ComputeInstance,
  DataFactory,
  VirtualMachine,
  HDInsight,
  Databricks,
  DataLakeAnalytics,
  SynapseSpark,
}

/**
 * The provision state of the cluster. Valid values are Unknown, Updating, Provisioning, Succeeded, and Failed.
 */
enum ProvisioningState {
  Unknown,
  Updating,
  Creating,
  Deleting,
  Succeeded,
  Failed,
  Canceled,
}

enum UnderlyingResourceAction {
  Delete,
  Detach,
}

/**
 * Type of the image. Possible values are: docker - For docker images. azureml - For AzureML images
 */
enum ImageType {
  docker,
  azureml,
}

/**
 * Type of the Environment Variable. Possible values are: local - For local variable
 */
enum EnvironmentVariableType {
  local,
}

/**
 * Protocol over which communication will happen over this endpoint
 */
enum Protocol {
  tcp,
  udp,
  http,
}

/**
 * Type of Volume Definition. Possible Values: bind,volume,tmpfs,npipe
 */
enum VolumeDefinitionType {
  bind,
  volume,
  tmpfs,
  npipe,
}

/**
 * State of the compute node. Values are idle, running, preparing, unusable, leaving and preempted.
 */
enum NodeState {
  idle,
  running,
  preparing,
  unusable,
  leaving,
  preempted,
}

/**
 * Provisioning state of registry asset.
 */
enum AssetProvisioningState {
  Succeeded,
  Failed,
  Canceled,
  Creating,
  Updating,
  Deleting,
}

enum AutoDeleteCondition {
  CreatedGreaterThan,
  LastAccessedGreaterThan,
}

/**
 * Type of storage to use for the pending upload location
 */
enum PendingUploadType {
  None,
  TemporaryBlobReference,
}

/**
 * Enum to determine the PendingUpload credentials type.
 */
enum PendingUploadCredentialType {
  SAS,
}

enum ListViewType {
  ActiveOnly,
  ArchivedOnly,
  All,
}

/**
 * Enum to determine the type of data.
 */
enum DataType {
  uri_file,
  uri_folder,
  mltable,
}

/**
 * Protection level associated with the Intellectual Property.
 */
enum ProtectionLevel {
  /**
   * All means Intellectual Property is fully protected.
   */
  All,

  /**
   * None means it is not an Intellectual Property.
   */
  None,
}

/**
 * AutoRebuild setting for the derived image
 */
enum AutoRebuildSetting {
  Disabled,
  OnBaseImageUpdate,
}

/**
 * Environment type is either user created or curated by Azure ML service
 */
enum EnvironmentType {
  Curated,
  UserCreated,
}

/**
 * The type of operating system.
 */
enum OperatingSystemType {
  Linux,
  Windows,
}

/**
 * Base environment type.
 */
enum BaseEnvironmentSourceType {
  EnvironmentAsset,
}

/**
 * Inferencing server type for various targets.
 */
enum InferencingServerType {
  AzureMLOnline,
  AzureMLBatch,
  Triton,
  Custom,
}

/**
 * Type of the inputs.
 */
enum PackageInputType {
  UriFile,
  UriFolder,
}

/**
 * Mounting type of the model or the inputs
 */
enum PackageInputDeliveryMode {
  Copy,
  Download,
}

/**
 * Input path type for package inputs.
 */
enum InputPathType {
  Url,
  PathId,
  PathVersion,
}

/**
 * Package build state returned in package response.
 */
enum PackageBuildState {
  NotStarted,
  Running,
  Succeeded,
  Failed,
}

/**
 * State of endpoint provisioning.
 */
enum EndpointProvisioningState {
  Creating,
  Deleting,
  Succeeded,
  Failed,
  Updating,
  Canceled,
}

/**
 * Enum to determine endpoint authentication mode.
 */
enum EndpointAuthMode {
  AMLToken,
  Key,
  AADToken,
}

/**
 * The enumerated property types for batch deployments.
 */
enum BatchDeploymentConfigurationType {
  Model,
  PipelineComponent,
}

/**
 * Log verbosity for batch inferencing.
 * Increasing verbosity order for logging is : Warning, Info and Debug.
 * The default value is Info.
 */
enum BatchLoggingLevel {
  Info,
  Warning,
  Debug,
}

/**
 * Enum to determine which reference method to use for an asset.
 */
enum ReferenceType {
  Id,
  DataPath,
  OutputPath,
}

/**
 * Enum to determine how batch inferencing will handle output
 */
enum BatchOutputAction {
  SummaryOnly,
  AppendRow,
}

/**
 * Possible values for DeploymentProvisioningState.
 */
enum DeploymentProvisioningState {
  Creating,
  Deleting,
  Scaling,
  Updating,
  Succeeded,
  Failed,
  Canceled,
}

/**
 * Enum to determine the datastore credentials type.
 */
enum CredentialsType {
  AccountKey,
  Certificate,
  None,
  Sas,
  ServicePrincipal,
  KerberosKeytab,
  KerberosPassword,
}

/**
 * Enum to determine the datastore contents type.
 */
enum DatastoreType {
  AzureBlob,
  AzureDataLakeGen1,
  AzureDataLakeGen2,
  AzureFile,
  Hdfs,
  OneLake,
}

/**
 * Enum to determine the datastore secrets type.
 */
enum SecretsType {
  AccountKey,
  Certificate,
  Sas,
  ServicePrincipal,
  KerberosPassword,
  KerberosKeytab,
}

enum FeatureDataType {
  String,
  Integer,
  Long,
  Float,
  Double,
  Binary,
  Datetime,
  Boolean,
}

/**
 * Enum to determine the email notification type.
 */
enum EmailNotificationEnableType {
  JobCompleted,
  JobFailed,
  JobCancelled,
}

/**
 * Enum to determine the webhook callback service type.
 */
enum WebhookType {
  AzureDevOps,
}

/**
 * Enum to describe the frequency of a recurrence schedule
 */
enum RecurrenceFrequency {
  /**
   * Minute frequency
   */
  Minute,

  /**
   * Hour frequency
   */
  Hour,

  /**
   * Day frequency
   */
  Day,

  /**
   * Week frequency
   */
  Week,

  /**
   * Month frequency
   */
  Month,
}

/**
 * Enum of weekday
 */
enum WeekDay {
  /**
   * Monday weekday
   */
  Monday,

  /**
   * Tuesday weekday
   */
  Tuesday,

  /**
   * Wednesday weekday
   */
  Wednesday,

  /**
   * Thursday weekday
   */
  Thursday,

  /**
   * Friday weekday
   */
  Friday,

  /**
   * Saturday weekday
   */
  Saturday,

  /**
   * Sunday weekday
   */
  Sunday,
}

enum TriggerType {
  Recurrence,
  Cron,
}

enum MaterializationStoreType {
  None,
  Online,
  Offline,
  OnlineAndOffline,
}

/**
 * The status of a job.
 */
enum JobStatus {
  /**
   * Run hasn't started yet.
   */
  NotStarted,

  /**
   * Run has started. The user has a run ID.
   */
  Starting,

  /**
   * (Not used currently) It will be used if ES is creating the compute target.
   */
  Provisioning,

  /**
   * The run environment is being prepared.
   */
  Preparing,

  /**
   * The job is queued in the compute target. For example, in BatchAI the job is in queued state, while waiting for all required nodes to be ready.
   */
  Queued,

  /**
   * The job started to run in the compute target.
   */
  Running,

  /**
   * Job is completed in the target. It is in output collection state now.
   */
  Finalizing,

  /**
   * Cancellation has been requested for the job.
   */
  CancelRequested,

  /**
   * Job completed successfully. This reflects that both the job itself and output collection states completed successfully
   */
  Completed,

  /**
   * Job failed.
   */
  Failed,

  /**
   * Following cancellation request, the job is now successfully canceled.
   */
  Canceled,

  /**
   * When heartbeat is enabled, if the run isn't updating any information to RunHistory then the run goes to NotResponding state.
   * NotResponding is the only state that is exempt from strict transition orders. A run can go from NotResponding to any of the previous states.
   */
  NotResponding,

  /**
   * The job is paused by users. Some adjustment to labeling jobs can be made only in paused state.
   */
  Paused,

  /**
   * Default job status if not mapped to all other statuses
   */
  Unknown,

  /**
   * The job is in a scheduled state. Job is not in any active state.
   */
  Scheduled,
}

enum FeaturestoreJobType {
  RecurrentMaterialization,
  BackfillMaterialization,
}

/**
 * Enum to determine identity framework.
 */
enum IdentityConfigurationType {
  Managed,
  AMLToken,
  UserIdentity,
}

/**
 * Enum to determine the type of job.
 */
enum JobType {
  AutoML,
  Command,
  Labeling,
  Sweep,
  Pipeline,
  Spark,
}

/**
 * The enumerated types for the nodes value
 */
enum NodesValueType {
  All,
  Custom,
}

/**
 * Whether IncrementalDataRefresh is enabled
 */
enum IncrementalDataRefresh {
  Enabled,
  Disabled,
}

/**
 * Whether multiSelect is enabled
 */
enum MultiSelect {
  Enabled,
  Disabled,
}

/**
 * Media type of data asset.
 */
enum MediaType {
  Image,
  Text,
}

enum MLAssistConfigurationType {
  Enabled,
  Disabled,
}

/**
 * Enum to determine the job provisioning state.
 */
enum JobProvisioningState {
  Succeeded,
  Failed,
  Canceled,
  InProgress,
}

enum StatusMessageLevel {
  Error,
  Information,
  Warning,
}

/**
 * The format of exported labels.
 */
enum ExportFormatType {
  Dataset,
  Coco,
  CSV,
}

/**
 * Enum to determine endpoint compute type.
 */
enum EndpointComputeType {
  Managed,
  Kubernetes,
  AzureMLCompute,
}

enum OrderString {
  CreatedAtDesc,
  CreatedAtAsc,
  UpdatedAtDesc,
  UpdatedAtAsc,
}

/**
 * Enum to determine whether PublicNetworkAccess is Enabled or Disabled.
 */
enum PublicNetworkAccessType {
  Enabled,
  Disabled,
}

enum DataCollectionMode {
  Enabled,
  Disabled,
}

enum RollingRateType {
  Year,
  Month,
  Day,
  Hour,
  Minute,
}

/**
 * Enum to determine whether PublicNetworkAccess is Enabled or Disabled for egress of a deployment.
 */
enum EgressPublicNetworkAccessType {
  Enabled,
  Disabled,
}

enum ScaleType {
  Default,
  TargetUtilization,
}

/**
 * The type of container to retrieve logs from.
 */
enum ContainerType {
  /**
   * The container used to download models and score script.
   */
  StorageInitializer,

  /**
   * The container used to serve user's request.
   */
  InferenceServer,

  /**
   * The container used to collect payload and custom logging when mdc is enabled.
   */
  ModelDataCollector,
}

/**
 * Node scaling setting for the compute sku.
 */
enum SkuScaleType {
  /**
   * Automatically scales node count.
   */
  Automatic,

  /**
   * Node count scaled upon user request.
   */
  Manual,

  /**
   * Fixed set of nodes.
   */
  None,
}

enum KeyType {
  Primary,
  Secondary,
}

enum ScheduleListViewType {
  EnabledOnly,
  DisabledOnly,
  All,
}

enum ScheduleActionType {
  CreateJob,
  InvokeBatchEndpoint,
  ImportData,
  CreateMonitor,
}

enum ScheduleProvisioningStatus {
  Creating,
  Updating,
  Deleting,
  Succeeded,
  Failed,
  Canceled,
}

/**
 * Connection status of the service consumer with the service provider
 */
enum EndpointServiceConnectionStatus {
  Approved,
  Pending,
  Rejected,
  Disconnected,
  Timeout,
}

/**
 * Indicates whether or not the encryption is enabled for the workspace.
 */
enum EncryptionStatus {
  Enabled,
  Disabled,
}

/**
 * Isolation mode for the managed network of a machine learning workspace.
 */
enum IsolationMode {
  Disabled,
  AllowInternetOutbound,
  AllowOnlyApprovedOutbound,
}

/**
 * Category of a managed network Outbound Rule of a machine learning workspace.
 */
enum RuleCategory {
  Required,
  Recommended,
  UserDefined,
}

/**
 * Type of a managed network Outbound Rule of a machine learning workspace.
 */
enum RuleStatus {
  Inactive,
  Active,
}

/**
 * Type of a managed network Outbound Rule of a machine learning workspace.
 */
enum RuleType {
  FQDN,
  PrivateEndpoint,
  ServiceTag,
}

/**
 * Status for the managed network of a machine learning workspace.
 */
enum ManagedNetworkStatus {
  Inactive,
  Active,
}

/**
 * The current provisioning state.
 */
enum PrivateEndpointConnectionProvisioningState {
  Succeeded,
  Creating,
  Deleting,
  Failed,
}

/**
 * Authentication type of the connection target
 */
enum ConnectionAuthType {
  PAT,
  ManagedIdentity,
  UsernamePassword,
  None,
  SAS,
  ServicePrincipal,
  AccessKey,
  ApiKey,
  CustomKeys,
}

/**
 * Category of the connection
 */
enum ConnectionCategory {
  PythonFeed,
  ContainerRegistry,
  Git,
  S3,
  Snowflake,
  AzureSqlDb,
  AzureSynapseAnalytics,
  AzureMySqlDb,
  AzurePostgresDb,
  ADLSGen2,
  Redis,
  ApiKey,
  AzureOpenAI,
  CognitiveSearch,
  CognitiveService,
  CustomKeys,
}

/**
 * Level of workspace setup error
 */
enum DiagnoseResultLevel {
  Warning,
  Error,
  Information,
}

/**
 * Intended usage of the cluster
 */
enum ClusterPurpose {
  FastProd,
  DenseProd,
  DevTest,
}

/**
 * Enable or disable ssl for scoring
 */
enum SslConfigStatus {
  Disabled,
  Enabled,
  Auto,
}

/**
 * Load Balancer Type
 */
enum LoadBalancerType {
  PublicIp,
  InternalLoadBalancer,
}

/**
 * Compute OS Type
 */
enum OsType {
  Linux,
  Windows,
}

/**
 * Virtual Machine priority
 */
enum VmPriority {
  Dedicated,
  LowPriority,
}

/**
 * State of the public SSH port. Possible values are: Disabled - Indicates that the public ssh port is closed on all nodes of the cluster. Enabled - Indicates that the public ssh port is open on all nodes of the cluster. NotSpecified - Indicates that the public ssh port is closed on all nodes of the cluster if VNet is defined, else is open all public nodes. It can be default only during cluster creation time, after creation it will be either enabled or disabled.
 */
enum RemoteLoginPortPublicAccess {
  Enabled,
  Disabled,
  NotSpecified,
}

/**
 * Allocation state of the compute. Possible values are: steady - Indicates that the compute is not resizing. There are no changes to the number of compute nodes in the compute in progress. A compute enters this state when it is created and when no operations are being performed on the compute to change the number of compute nodes. resizing - Indicates that the compute is resizing; that is, compute nodes are being added to or removed from the compute.
 */
enum AllocationState {
  Steady,
  Resizing,
}

/**
 * Policy for sharing applications on this compute instance among users of parent workspace. If Personal, only the creator can access applications on this compute instance. When Shared, any workspace user can access applications on this instance depending on his/her assigned role.
 */
enum ApplicationSharingPolicy {
  Personal,
  Shared,
}

/**
 * Indicates whether mlflow autologger is enabled for notebooks.
 */
enum MlflowAutologger {
  Enabled,
  Disabled,
}

/**
 * State of the public SSH port. Possible values are: Disabled - Indicates that the public ssh port is closed on this instance. Enabled - Indicates that the public ssh port is open and accessible according to the VNet/subnet policy if applicable.
 */
enum SshPublicAccess {
  Enabled,
  Disabled,
}

/**
 * Current state of an ComputeInstance.
 */
enum ComputeInstanceState {
  Creating,
  CreateFailed,
  Deleting,
  Running,
  Restarting,
  JobRunning,
  SettingUp,
  SetupFailed,
  Starting,
  Stopped,
  Stopping,
  UserSettingUp,
  UserSetupFailed,
  Unknown,
  Unusable,
}

/**
 * The Compute Instance Authorization type. Available values are personal (default).
 */
enum ComputeInstanceAuthorizationType {
  personal,
}

/**
 * Name of the last operation.
 */
enum OperationName {
  Create,
  Start,
  Stop,
  Restart,
  Reimage,
  Delete,
}

/**
 * Operation status.
 */
enum OperationStatus {
  InProgress,
  Succeeded,
  CreateFailed,
  StartFailed,
  StopFailed,
  RestartFailed,
  ReimageFailed,
  DeleteFailed,
}

/**
 * Trigger of operation.
 */
enum OperationTrigger {
  User,
  Schedule,
  IdleShutdown,
}

/**
 * The current deployment state of schedule.
 */
enum ProvisioningStatus {
  Completed,
  Provisioning,
  Failed,
}

/**
 * Is the schedule enabled or disabled?
 */
enum ScheduleStatus {
  Enabled,
  Disabled,
}

/**
 * [Required] The compute power action.
 */
enum ComputePowerAction {
  Start,
  Stop,
}

/**
 * The current deployment state of schedule.
 */
enum ScheduleProvisioningState {
  Completed,
  Provisioning,
  Failed,
}

/**
 * Auto save settings.
 */
enum Autosave {
  None,
  Local,
  Remote,
}

/**
 * network of this container.
 */
enum Network {
  Bridge,
  Host,
}

/**
 * Caching type of Data Disk.
 */
enum Caching {
  None,
  ReadOnly,
  ReadWrite,
}

/**
 * type of this storage account.
 */
enum StorageAccountType {
  Standard_LRS,
  Premium_LRS,
}

/**
 * Data source type.
 */
enum SourceType {
  Dataset,
  Datastore,
  URI,
}

/**
 * Mount Action.
 */
enum MountAction {
  Mount,
  Unmount,
}

/**
 * Mount state.
 */
enum MountState {
  MountRequested,
  Mounted,
  MountFailed,
  UnmountRequested,
  UnmountFailed,
  Unmounted,
}

enum MonitoringFeatureFilterType {
  /**
   * Includes all features.
   */
  AllFeatures,

  /**
   * Only includes the top contributing features, measured by feature attribution.
   */
  TopNByAttribution,

  /**
   * Includes a user-defined subset of features.
   */
  FeatureSubset,
}

/**
 * Monitor compute identity type enum.
 */
enum MonitorComputeIdentityType {
  /**
   * Authenticates through user's AML token.
   */
  AmlToken,

  /**
   * Authenticates through a user-provided managed identity.
   */
  ManagedIdentity,
}

/**
 * Enum to determine the input data delivery mode.
 */
enum InputDeliveryMode {
  ReadOnlyMount,
  ReadWriteMount,
  Download,
  Direct,
  EvalMount,
  EvalDownload,
}

/**
 * Output data delivery mode enums.
 */
enum OutputDeliveryMode {
  ReadWriteMount,
  Upload,
  Direct,
}

/**
 * Enum to determine forecast horizon selection mode.
 */
enum ForecastHorizonMode {
  /**
   * Forecast horizon to be determined automatically.
   */
  Auto,

  /**
   * Use the custom forecast horizon.
   */
  Custom,
}

/**
 * Enum to determine the Job Output Type.
 */
enum JobOutputType {
  uri_file,
  uri_folder,
  mltable,
  custom_model,
  mlflow_model,
  triton_model,
}

/**
 * Enum to determine the job tier.
 */
enum JobTier {
  Null,
  Spot,
  Basic,
  Standard,
  Premium,
}

/**
 * Enum for setting log verbosity.
 */
enum LogVerbosity {
  /**
   * No logs emitted.
   */
  NotSet,

  /**
   * Debug and above log statements logged.
   */
  Debug,

  /**
   * Info and above log statements logged.
   */
  Info,

  /**
   * Warning and above log statements logged.
   */
  Warning,

  /**
   * Error and above log statements logged.
   */
  Error,

  /**
   * Only critical statements logged.
   */
  Critical,
}

/**
 * AutoMLJob Task type.
 */
enum TaskType {
  /**
   * Classification in machine learning and statistics is a supervised learning approach in which
   * the computer program learns from the data given to it and make new observations or classifications.
   */
  Classification,

  /**
   * Regression means to predict the value using the input data. Regression models are used to predict a continuous value.
   */
  Regression,

  /**
   * Forecasting is a special kind of regression task that deals with time-series data and creates forecasting model
   * that can be used to predict the near future values based on the inputs.
   */
  Forecasting,

  /**
   * Image Classification. Multi-class image classification is used when an image is classified with only a single label
   * from a set of classes - e.g. each image is classified as either an image of a 'cat' or a 'dog' or a 'duck'.
   */
  ImageClassification,

  /**
   * Image Classification Multilabel. Multi-label image classification is used when an image could have one or more labels
   * from a set of labels - e.g. an image could be labeled with both 'cat' and 'dog'.
   */
  ImageClassificationMultilabel,

  /**
   * Image Object Detection. Object detection is used to identify objects in an image and locate each object with a
   * bounding box e.g. locate all dogs and cats in an image and draw a bounding box around each.
   */
  ImageObjectDetection,

  /**
   * Image Instance Segmentation. Instance segmentation is used to identify objects in an image at the pixel level,
   * drawing a polygon around each object in the image.
   */
  ImageInstanceSegmentation,

  /**
   * Text classification (also known as text tagging or text categorization) is the process of sorting texts into categories.
   * Categories are mutually exclusive.
   */
  TextClassification,

  /**
   * Multilabel classification task assigns each sample to a group (zero or more) of target labels.
   */
  TextClassificationMultilabel,

  /**
   * Text Named Entity Recognition a.k.a. TextNER.
   * Named Entity Recognition (NER) is the ability to take free-form text and identify the occurrences of entities such as people, locations, organizations, and more.
   */
  TextNER,
}

/**
 * Enum to determine the Job Input Type.
 */
enum JobInputType {
  literal,
  uri_file,
  uri_folder,
  mltable,
  custom_model,
  mlflow_model,
  triton_model,
}

/**
 * Determines how N-Cross validations value is determined.
 */
enum NCrossValidationsMode {
  /**
   * Determine N-Cross validations value automatically. Supported only for 'Forecasting' AutoML task.
   */
  Auto,

  /**
   * Use custom N-Cross validations value.
   */
  Custom,
}

/**
 * Forecasting seasonality mode.
 */
enum SeasonalityMode {
  /**
   * Seasonality to be determined automatically.
   */
  Auto,

  /**
   * Use the custom seasonality value.
   */
  Custom,
}

/**
 * Target lags selection modes.
 */
enum TargetLagsMode {
  /**
   * Target lags to be determined automatically.
   */
  Auto,

  /**
   * Use the custom target lags.
   */
  Custom,
}

/**
 * Target rolling windows size mode.
 */
enum TargetRollingWindowSizeMode {
  /**
   * Determine rolling windows size automatically.
   */
  Auto,

  /**
   * Use the specified rolling window size.
   */
  Custom,
}

/**
 * Enum to determine the state of mlflow autologger.
 */
enum MLFlowAutologgerState {
  Enabled,
  Disabled,
}

enum MonitoringAlertNotificationType {
  /**
   * Settings for Azure Monitor based alerting.
   */
  AzureMonitor,

  /**
   * Settings for AML email notifications.
   */
  Email,
}

enum ServiceDataAccessAuthIdentity {
  /**
   * Do not use any identity for service data access.
   */
  None,

  /**
   * Use the system assigned managed identity of the Workspace to authenticate service data access.
   */
  WorkspaceSystemAssignedIdentity,

  /**
   * Use the user assigned managed identity of the Workspace to authenticate service data access.
   */
  WorkspaceUserAssignedIdentity,
}

enum EarlyTerminationPolicyType {
  Bandit,
  MedianStopping,
  TruncationSelection,
}

enum SamplingAlgorithmType {
  Grid,
  Random,
  Bayesian,
}

enum CategoricalDataDriftMetric {
  /**
   * The Jensen Shannon Distance (JSD) metric.
   */
  JensenShannonDistance,

  /**
   * The Population Stability Index (PSI) metric.
   */
  PopulationStabilityIndex,

  /**
   * The Pearsons Chi Squared Test metric.
   */
  PearsonsChiSquaredTest,
}

enum MonitoringFeatureDataType {
  /**
   * Used for features of numerical data type.
   */
  Numerical,

  /**
   * Used for features of categorical data type.
   */
  Categorical,
}

enum CategoricalDataQualityMetric {
  /**
   * Calculates the rate of null values.
   */
  NullValueRate,

  /**
   * Calculates the rate of data type errors.
   */
  DataTypeErrorRate,

  /**
   * Calculates the rate values are out of bounds.
   */
  OutOfBoundsRate,
}

enum CategoricalPredictionDriftMetric {
  /**
   * The Jensen Shannon Distance (JSD) metric.
   */
  JensenShannonDistance,

  /**
   * The Population Stability Index (PSI) metric.
   */
  PopulationStabilityIndex,

  /**
   * The Pearsons Chi Squared Test metric.
   */
  PearsonsChiSquaredTest,
}

/**
 * Primary metrics for classification tasks.
 */
enum ClassificationPrimaryMetrics {
  /**
   * AUC is the Area under the curve.
   * This metric represents arithmetic mean of the score for each class,
   * weighted by the number of true instances in each class.
   */
  AUCWeighted,

  /**
   * Accuracy is the ratio of predictions that exactly match the true class labels.
   */
  Accuracy,

  /**
   * Normalized macro recall is recall macro-averaged and normalized, so that random
   * performance has a score of 0, and perfect performance has a score of 1.
   */
  NormMacroRecall,

  /**
   * The arithmetic mean of the average precision score for each class, weighted by
   * the number of true instances in each class.
   */
  AveragePrecisionScoreWeighted,

  /**
   * The arithmetic mean of precision for each class, weighted by number of true instances in each class.
   */
  PrecisionScoreWeighted,
}

/**
 * Enum for all classification models supported by AutoML.
 */
enum ClassificationModels {
  /**
   * Logistic regression is a fundamental classification technique.
   * It belongs to the group of linear classifiers and is somewhat similar to polynomial and linear regression.
   * Logistic regression is fast and relatively uncomplicated, and it's convenient for you to interpret the results.
   * Although it's essentially a method for binary classification, it can also be applied to multiclass problems.
   */
  LogisticRegression,

  /**
   * SGD: Stochastic gradient descent is an optimization algorithm often used in machine learning applications
   * to find the model parameters that correspond to the best fit between predicted and actual outputs.
   */
  SGD,

  /**
   * The multinomial Naive Bayes classifier is suitable for classification with discrete features (e.g., word counts for text classification).
   * The multinomial distribution normally requires integer feature counts. However, in practice, fractional counts such as tf-idf may also work.
   */
  MultinomialNaiveBayes,

  /**
   * Naive Bayes classifier for multivariate Bernoulli models.
   */
  BernoulliNaiveBayes,

  /**
   * A support vector machine (SVM) is a supervised machine learning model that uses classification algorithms for two-group classification problems.
   * After giving an SVM model sets of labeled training data for each category, they're able to categorize new text.
   */
  SVM,

  /**
   * A support vector machine (SVM) is a supervised machine learning model that uses classification algorithms for two-group classification problems.
   * After giving an SVM model sets of labeled training data for each category, they're able to categorize new text.
   * Linear SVM performs best when input data is linear, i.e., data can be easily classified by drawing the straight line between classified values on a plotted graph.
   */
  LinearSVM,

  /**
   * K-nearest neighbors (KNN) algorithm uses 'feature similarity' to predict the values of new datapoints
   * which further means that the new data point will be assigned a value based on how closely it matches the points in the training set.
   */
  KNN,

  /**
   * Decision Trees are a non-parametric supervised learning method used for both classification and regression tasks.
   * The goal is to create a model that predicts the value of a target variable by learning simple decision rules inferred from the data features.
   */
  DecisionTree,

  /**
   * Random forest is a supervised learning algorithm.
   * The "forest" it builds, is an ensemble of decision trees, usually trained with the bagging method.
   * The general idea of the bagging method is that a combination of learning models increases the overall result.
   */
  RandomForest,

  /**
   * Extreme Trees is an ensemble machine learning algorithm that combines the predictions from many decision trees. It is related to the widely used random forest algorithm.
   */
  ExtremeRandomTrees,

  /**
   * LightGBM is a gradient boosting framework that uses tree based learning algorithms.
   */
  LightGBM,

  /**
   * The technique of transiting week learners into a strong learner is called Boosting. The gradient boosting algorithm process works on this theory of execution.
   */
  GradientBoosting,

  /**
   * XGBoost: Extreme Gradient Boosting Algorithm. This algorithm is used for structured data where target column values can be divided into distinct class values.
   */
  XGBoostClassifier,
}

/**
 * The meta-learner is a model trained on the output of the individual heterogeneous models.
 * Default meta-learners are LogisticRegression for classification tasks (or LogisticRegressionCV if cross-validation is enabled) and ElasticNet for regression/forecasting tasks (or ElasticNetCV if cross-validation is enabled).
 * This parameter can be one of the following strings: LogisticRegression, LogisticRegressionCV, LightGBMClassifier, ElasticNet, ElasticNetCV, LightGBMRegressor, or LinearRegression
 */
enum StackMetaLearnerType {
  None,

  /**
   * Default meta-learners are LogisticRegression for classification tasks.
   */
  LogisticRegression,

  /**
   * Default meta-learners are LogisticRegression for classification task when CV is on.
   */
  LogisticRegressionCV,

  LightGBMClassifier,

  /**
   * Default meta-learners are LogisticRegression for regression task.
   */
  ElasticNet,

  /**
   * Default meta-learners are LogisticRegression for regression task when CV is on.
   */
  ElasticNetCV,

  LightGBMRegressor,
  LinearRegression,
}

/**
 * Training mode dictates whether to use distributed training or not
 */
enum TrainingMode {
  /**
   * Auto mode
   */
  Auto,

  /**
   * Distributed training mode
   */
  Distributed,

  /**
   * Non distributed training mode
   */
  NonDistributed,
}

/**
 * Enum for all classification models supported by AutoML.
 */
enum BlockedTransformers {
  /**
   * Target encoding for text data.
   */
  TextTargetEncoder,

  /**
   * Ohe hot encoding creates a binary feature transformation.
   */
  OneHotEncoder,

  /**
   * Target encoding for categorical data.
   */
  CatTargetEncoder,

  /**
   * Tf-Idf stands for, term-frequency times inverse document-frequency. This is a common term weighting scheme for identifying information from documents.
   */
  TfIdf,

  /**
   * Weight of Evidence encoding is a technique used to encode categorical variables. It uses the natural log of the P(1)/P(0) to create weights.
   */
  WoETargetEncoder,

  /**
   * Label encoder converts labels/categorical variables in a numerical form.
   */
  LabelEncoder,

  /**
   * Word embedding helps represents words or phrases as a vector, or a series of numbers.
   */
  WordEmbedding,

  /**
   * Naive Bayes is a classified that is used for classification of discrete features that are categorically distributed.
   */
  NaiveBayes,

  /**
   * Count Vectorizer converts a collection of text documents to a matrix of token counts.
   */
  CountVectorizer,

  /**
   * Hashing One Hot Encoder can turn categorical variables into a limited number of new features. This is often used for high-cardinality categorical features.
   */
  HashOneHotEncoder,
}

/**
 * Featurization mode - determines data featurization mode.
 */
enum FeaturizationMode {
  /**
   * Auto mode, system performs featurization without any custom featurization inputs.
   */
  Auto,

  /**
   * Custom featurization.
   */
  Custom,

  /**
   * Featurization off. 'Forecasting' task cannot use this value.
   */
  Off,
}

enum ClassificationModelPerformanceMetric {
  /**
   * Calculates the accuracy of the model predictions.
   */
  Accuracy,

  /**
   * Calculates the precision of the model predictions.
   */
  Precision,

  /**
   * Calculates the recall of the model predictions.
   */
  Recall,
}

enum MonitoringModelType {
  /**
   * A model trained for classification tasks.
   */
  Classification,

  /**
   * A model trained for regressions tasks.
   */
  Regression,
}

/**
 * Enum to determine the job distribution type.
 */
enum DistributionType {
  PyTorch,
  TensorFlow,
  Mpi,
  Ray,
}

enum JobLimitsType {
  Command,
  Sweep,
}

/**
 * Monitor compute type enum.
 */
enum MonitorComputeType {
  /**
   * Serverless Spark compute.
   */
  ServerlessSpark,
}

/**
 * Model task type enum.
 */
enum ModelTaskType {
  Classification,
  Regression,
  QuestionAnswering,
}

enum MonitoringNotificationMode {
  /**
   * Disabled notifications will not produce emails/metrics leveraged for alerting.
   */
  Disabled,

  /**
   * Enabled notification will produce emails/metrics leveraged for alerting.
   */
  Enabled,
}

enum MonitoringSignalType {
  /**
   * Tracks model input data distribution change, comparing against training data or past production data.
   */
  DataDrift,

  /**
   * Tracks prediction result data distribution change, comparing against validation/test label data or past production data.
   */
  PredictionDrift,

  /**
   * Tracks model input data integrity.
   */
  DataQuality,

  /**
   * Tracks feature importance change in production, comparing against feature importance at training time.
   */
  FeatureAttributionDrift,

  /**
   * Tracks a custom signal provided by users.
   */
  Custom,

  /**
   * Tracks model performance based on ground truth data.
   */
  ModelPerformance,

  /**
   * Tracks the safety and quality of generated content.
   */
  GenerationSafetyQuality,

  /**
   * Tracks the token usage of generative endpoints.
   */
  GenerationTokenStatistics,
}

/**
 * Monitoring input data type enum.
 */
enum MonitoringInputDataType {
  /**
   * An input data with a fixed window size.
   */
  Static,

  /**
   * An input data which trailing relatively to the monitor's current run.
   */
  Trailing,

  /**
   * An input data with tabular format which doesn't require preprocessing.
   */
  Fixed,
}

/**
 * Enum to determine the type of data.
 */
enum DataImportSourceType {
  database,
  file_system,
}

enum FeatureAttributionMetric {
  /**
   * The Normalized Discounted Cumulative Gain metric.
   */
  NormalizedDiscountedCumulativeGain,
}

/**
 * Flag for generating lags for the numeric features.
 */
enum FeatureLags {
  /**
   * No feature lags generated.
   */
  None,

  /**
   * System auto-generates feature lags.
   */
  Auto,
}

/**
 * The parameter defining how if AutoML should handle short time series.
 */
enum ShortSeriesHandlingConfiguration {
  /**
   * Represents no/null value.
   */
  None,

  /**
   * Short series will be padded if there are no long series, otherwise short series will be dropped.
   */
  Auto,

  /**
   * All the short series will be padded.
   */
  Pad,

  /**
   * All the short series will be dropped.
   */
  Drop,
}

/**
 * Target aggregate function.
 */
enum TargetAggregationFunction {
  /**
   * Represent no value set.
   */
  None,

  Sum,
  Max,
  Min,
  Mean,
}

/**
 * Configure STL Decomposition of the time-series target column.
 */
enum UseStl {
  /**
   * No stl decomposition.
   */
  None,

  Season,
  SeasonTrend,
}

/**
 * Primary metrics for Forecasting task.
 */
enum ForecastingPrimaryMetrics {
  /**
   * The Spearman's rank coefficient of correlation is a non-parametric measure of rank correlation.
   */
  SpearmanCorrelation,

  /**
   * The Normalized Root Mean Squared Error (NRMSE) the RMSE facilitates the comparison between models with different scales.
   */
  NormalizedRootMeanSquaredError,

  /**
   * The R2 score is one of the performance evaluation measures for forecasting-based machine learning models.
   */
  R2Score,

  /**
   * The Normalized Mean Absolute Error (NMAE) is a validation metric to compare the Mean Absolute Error (MAE) of (time) series with different scales.
   */
  NormalizedMeanAbsoluteError,
}

/**
 * Enum for all forecasting models supported by AutoML.
 */
enum ForecastingModels {
  /**
   * Auto-Autoregressive Integrated Moving Average (ARIMA) model uses time-series data and statistical analysis to interpret the data and make future predictions.
   * This model aims to explain data by using time series data on its past values and uses linear regression to make predictions.
   */
  AutoArima,

  /**
   * Prophet is a procedure for forecasting time series data based on an additive model where non-linear trends are fit with yearly, weekly, and daily seasonality, plus holiday effects.
   * It works best with time series that have strong seasonal effects and several seasons of historical data. Prophet is robust to missing data and shifts in the trend, and typically handles outliers well.
   */
  Prophet,

  /**
   * The Naive forecasting model makes predictions by carrying forward the latest target value for each time-series in the training data.
   */
  Naive,

  /**
   * The Seasonal Naive forecasting model makes predictions by carrying forward the latest season of target values for each time-series in the training data.
   */
  SeasonalNaive,

  /**
   * The Average forecasting model makes predictions by carrying forward the average of the target values for each time-series in the training data.
   */
  Average,

  /**
   * The Seasonal Average forecasting model makes predictions by carrying forward the average value of the latest season of data for each time-series in the training data.
   */
  SeasonalAverage,

  /**
   * Exponential smoothing is a time series forecasting method for univariate data that can be extended to support data with a systematic trend or seasonal component.
   */
  ExponentialSmoothing,

  /**
   * An Autoregressive Integrated Moving Average with Explanatory Variable (ARIMAX) model can be viewed as a multiple regression model with one or more autoregressive (AR) terms and/or one or more moving average (MA) terms.
   * This method is suitable for forecasting when data is stationary/non stationary, and multivariate with any type of data pattern, i.e., level/trend /seasonality/cyclicity.
   */
  Arimax,

  /**
   * TCNForecaster: Temporal Convolutional Networks Forecaster. //TODO: Ask forecasting team for brief intro.
   */
  TCNForecaster,

  /**
   * Elastic net is a popular type of regularized linear regression that combines two popular penalties, specifically the L1 and L2 penalty functions.
   */
  ElasticNet,

  /**
   * The technique of transiting week learners into a strong learner is called Boosting. The gradient boosting algorithm process works on this theory of execution.
   */
  GradientBoosting,

  /**
   * Decision Trees are a non-parametric supervised learning method used for both classification and regression tasks.
   * The goal is to create a model that predicts the value of a target variable by learning simple decision rules inferred from the data features.
   */
  DecisionTree,

  /**
   * K-nearest neighbors (KNN) algorithm uses 'feature similarity' to predict the values of new datapoints
   * which further means that the new data point will be assigned a value based on how closely it matches the points in the training set.
   */
  KNN,

  /**
   * Lasso model fit with Least Angle Regression a.k.a. Lars. It is a Linear Model trained with an L1 prior as regularizer.
   */
  LassoLars,

  /**
   * SGD: Stochastic gradient descent is an optimization algorithm often used in machine learning applications
   * to find the model parameters that correspond to the best fit between predicted and actual outputs.
   * It's an inexact but powerful technique.
   */
  SGD,

  /**
   * Random forest is a supervised learning algorithm.
   * The "forest" it builds, is an ensemble of decision trees, usually trained with the bagging method.
   * The general idea of the bagging method is that a combination of learning models increases the overall result.
   */
  RandomForest,

  /**
   * Extreme Trees is an ensemble machine learning algorithm that combines the predictions from many decision trees. It is related to the widely used random forest algorithm.
   */
  ExtremeRandomTrees,

  /**
   * LightGBM is a gradient boosting framework that uses tree based learning algorithms.
   */
  LightGBM,

  /**
   * XGBoostRegressor: Extreme Gradient Boosting Regressor is a supervised machine learning model using ensemble of base learners.
   */
  XGBoostRegressor,
}

/**
 * Generation safety quality metric enum.
 */
enum GenerationSafetyQualityMetric {
  AcceptableGroundednessScorePerInstance,
  AggregatedGroundednessPassRate,
  AcceptableCoherenceScorePerInstance,
  AggregatedCoherencePassRate,
  AcceptableFluencyScorePerInstance,
  AggregatedFluencyPassRate,
  AcceptableSimilarityScorePerInstance,
  AggregatedSimilarityPassRate,
  AcceptableRelevanceScorePerInstance,
  AggregatedRelevancePassRate,
}

/**
 * Generation token statistics metric enum.
 */
enum GenerationTokenStatisticsMetric {
  TotalTokenCount,
  TotalTokenCountPerGroup,
}

/**
 * Learning rate scheduler enum.
 */
enum LearningRateScheduler {
  /**
   * No learning rate scheduler selected.
   */
  None,

  /**
   * Cosine Annealing With Warmup.
   */
  WarmupCosine,

  /**
   * Step learning rate scheduler.
   */
  Step,
}

/**
 * Stochastic optimizer for image models.
 */
enum StochasticOptimizer {
  /**
   * No optimizer selected.
   */
  None,

  /**
   * Stochastic Gradient Descent optimizer.
   */
  Sgd,

  /**
   * Adam is algorithm the optimizes stochastic objective functions based on adaptive estimates of moments
   */
  Adam,

  /**
   * AdamW is a variant of the optimizer Adam that has an improved implementation of weight decay.
   */
  Adamw,
}

/**
 * Primary metrics for classification multilabel tasks.
 */
enum ClassificationMultilabelPrimaryMetrics {
  /**
   * AUC is the Area under the curve.
   * This metric represents arithmetic mean of the score for each class,
   * weighted by the number of true instances in each class.
   */
  AUCWeighted,

  /**
   * Accuracy is the ratio of predictions that exactly match the true class labels.
   */
  Accuracy,

  /**
   * Normalized macro recall is recall macro-averaged and normalized, so that random
   * performance has a score of 0, and perfect performance has a score of 1.
   */
  NormMacroRecall,

  /**
   * The arithmetic mean of the average precision score for each class, weighted by
   * the number of true instances in each class.
   */
  AveragePrecisionScoreWeighted,

  /**
   * The arithmetic mean of precision for each class, weighted by number of true instances in each class.
   */
  PrecisionScoreWeighted,

  /**
   * Intersection Over Union. Intersection of predictions divided by union of predictions.
   */
  IOU,
}

/**
 * Primary metrics for InstanceSegmentation tasks.
 */
enum InstanceSegmentationPrimaryMetrics {
  /**
   * Mean Average Precision (MAP) is the average of AP (Average Precision).
   * AP is calculated for each class and averaged to get the MAP.
   */
  MeanAveragePrecision,
}

enum LogTrainingMetrics {
  /**
   * Enable compute and log training metrics.
   */
  Enable,

  /**
   * Disable compute and log training metrics.
   */
  Disable,
}

enum LogValidationLoss {
  /**
   * Enable compute and log validation metrics.
   */
  Enable,

  /**
   * Disable compute and log validation metrics.
   */
  Disable,
}

/**
 * Image model size.
 */
enum ModelSize {
  /**
   * No value selected.
   */
  None,

  /**
   * Small size.
   */
  Small,

  /**
   * Medium size.
   */
  Medium,

  /**
   * Large size.
   */
  Large,

  /**
   * Extra large size.
   */
  ExtraLarge,
}

/**
 * Metric computation method to use for validation metrics in image tasks.
 */
enum ValidationMetricType {
  /**
   * No metric.
   */
  None,

  /**
   * Coco metric.
   */
  Coco,

  /**
   * Voc metric.
   */
  Voc,

  /**
   * CocoVoc metric.
   */
  CocoVoc,
}

/**
 * Primary metrics for Image ObjectDetection task.
 */
enum ObjectDetectionPrimaryMetrics {
  /**
   * Mean Average Precision (MAP) is the average of AP (Average Precision).
   * AP is calculated for each class and averaged to get the MAP.
   */
  MeanAveragePrecision,
}

/**
 * Annotation type of image data.
 */
enum ImageAnnotationType {
  Classification,
  BoundingBox,
  InstanceSegmentation,
}

/**
 * Annotation type of text data.
 */
enum TextAnnotationType {
  Classification,
  NamedEntityRecognition,
}

/**
 * Enum to determine OneLake artifact type.
 */
enum OneLakeArtifactType {
  LakeHouse,
}

/**
 * Enum of learning rate schedulers that aligns with those supported by HF
 */
enum NlpLearningRateScheduler {
  /**
   * No learning rate schedule.
   */
  None,

  /**
   * Linear warmup and decay.
   */
  Linear,

  /**
   * Linear warmup then cosine decay.
   */
  Cosine,

  /**
   * Linear warmup, cosine decay, then restart to initial LR.
   */
  CosineWithRestarts,

  /**
   * Increase linearly then polynomially decay.
   */
  Polynomial,

  /**
   * Constant learning rate.
   */
  Constant,

  /**
   * Linear warmup followed by constant value.
   */
  ConstantWithWarmup,
}

enum NumericalDataDriftMetric {
  /**
   * The Jensen Shannon Distance (JSD) metric.
   */
  JensenShannonDistance,

  /**
   * The Population Stability Index (PSI) metric.
   */
  PopulationStabilityIndex,

  /**
   * The Normalized Wasserstein Distance metric.
   */
  NormalizedWassersteinDistance,

  /**
   * The Two Sample Kolmogorov-Smirnov Test (two-sample K–S) metric.
   */
  TwoSampleKolmogorovSmirnovTest,
}

enum NumericalDataQualityMetric {
  /**
   * Calculates the rate of null values.
   */
  NullValueRate,

  /**
   * Calculates the rate of data type errors.
   */
  DataTypeErrorRate,

  /**
   * Calculates the rate values are out of bounds.
   */
  OutOfBoundsRate,
}

enum NumericalPredictionDriftMetric {
  /**
   * The Jensen Shannon Distance (JSD) metric.
   */
  JensenShannonDistance,

  /**
   * The Population Stability Index (PSI) metric.
   */
  PopulationStabilityIndex,

  /**
   * The Normalized Wasserstein Distance metric.
   */
  NormalizedWassersteinDistance,

  /**
   * The Two Sample Kolmogorov-Smirnov Test (two-sample K–S) metric.
   */
  TwoSampleKolmogorovSmirnovTest,
}

/**
 * Defines supported metric goals for hyperparameter tuning
 */
enum Goal {
  Minimize,
  Maximize,
}

/**
 * The specific type of random algorithm
 */
enum RandomSamplingAlgorithmRule {
  Random,
  Sobol,
}

/**
 * Primary metrics for Regression task.
 */
enum RegressionPrimaryMetrics {
  /**
   * The Spearman's rank coefficient of correlation is a nonparametric measure of rank correlation.
   */
  SpearmanCorrelation,

  /**
   * The Normalized Root Mean Squared Error (NRMSE) the RMSE facilitates the comparison between models with different scales.
   */
  NormalizedRootMeanSquaredError,

  /**
   * The R2 score is one of the performance evaluation measures for forecasting-based machine learning models.
   */
  R2Score,

  /**
   * The Normalized Mean Absolute Error (NMAE) is a validation metric to compare the Mean Absolute Error (MAE) of (time) series with different scales.
   */
  NormalizedMeanAbsoluteError,
}

/**
 * Enum for all Regression models supported by AutoML.
 */
enum RegressionModels {
  /**
   * Elastic net is a popular type of regularized linear regression that combines two popular penalties, specifically the L1 and L2 penalty functions.
   */
  ElasticNet,

  /**
   * The technique of transiting week learners into a strong learner is called Boosting. The gradient boosting algorithm process works on this theory of execution.
   */
  GradientBoosting,

  /**
   * Decision Trees are a non-parametric supervised learning method used for both classification and regression tasks.
   * The goal is to create a model that predicts the value of a target variable by learning simple decision rules inferred from the data features.
   */
  DecisionTree,

  /**
   * K-nearest neighbors (KNN) algorithm uses 'feature similarity' to predict the values of new datapoints
   * which further means that the new data point will be assigned a value based on how closely it matches the points in the training set.
   */
  KNN,

  /**
   * Lasso model fit with Least Angle Regression a.k.a. Lars. It is a Linear Model trained with an L1 prior as regularizer.
   */
  LassoLars,

  /**
   * SGD: Stochastic gradient descent is an optimization algorithm often used in machine learning applications
   * to find the model parameters that correspond to the best fit between predicted and actual outputs.
   * It's an inexact but powerful technique.
   */
  SGD,

  /**
   * Random forest is a supervised learning algorithm.
   * The "forest" it builds, is an ensemble of decision trees, usually trained with the bagging method.
   * The general idea of the bagging method is that a combination of learning models increases the overall result.
   */
  RandomForest,

  /**
   * Extreme Trees is an ensemble machine learning algorithm that combines the predictions from many decision trees. It is related to the widely used random forest algorithm.
   */
  ExtremeRandomTrees,

  /**
   * LightGBM is a gradient boosting framework that uses tree based learning algorithms.
   */
  LightGBM,

  /**
   * XGBoostRegressor: Extreme Gradient Boosting Regressor is a supervised machine learning model using ensemble of base learners.
   */
  XGBoostRegressor,
}

enum RegressionModelPerformanceMetric {
  /**
   * The Mean Absolute Error (MAE) metric.
   */
  MeanAbsoluteError,

  /**
   * The Root Mean Squared Error (RMSE) metric.
   */
  RootMeanSquaredError,

  /**
   * The Mean Squared Error (MSE) metric.
   */
  MeanSquaredError,
}

enum SparkJobEntryType {
  SparkJobPythonEntry,
  SparkJobScalaEntry,
}

/**
 * The action enum for networking rule.
 */
enum RuleAction {
  Allow,
  Deny,
}

/**
 * The List Usages operation response.
 */
model ListUsagesResult is Azure.Core.Page<Usage>;

/**
 * Describes AML Resource Usage.
 */
model Usage {
  /**
   * Specifies the resource ID.
   */
  @visibility("read")
  id?: string;

  /**
   * Region of the AML workspace in the id.
   */
  @visibility("read")
  amlWorkspaceLocation?: string;

  /**
   * Specifies the resource type.
   */
  @visibility("read")
  type?: string;

  /**
   * An enum describing the unit of usage measurement.
   */
  @visibility("read")
  unit?: UsageUnit;

  /**
   * The current usage of the resource.
   */
  @visibility("read")
  currentValue?: int64;

  /**
   * The maximum permitted usage of the resource.
   */
  @visibility("read")
  limit?: int64;

  /**
   * The name of the type of usage.
   */
  @visibility("read")
  name?: UsageName;
}

/**
 * The Usage Names.
 */
model UsageName {
  /**
   * The name of the resource.
   */
  @visibility("read")
  value?: string;

  /**
   * The localized name of the resource.
   */
  @visibility("read")
  localizedValue?: string;
}

/**
 * The List Virtual Machine size operation response.
 */
model VirtualMachineSizeListResult {
  /**
   * The list of virtual machine sizes supported by AmlCompute.
   */
  value?: VirtualMachineSize[];
}

/**
 * Describes the properties of a VM size.
 */
model VirtualMachineSize {
  /**
   * The name of the virtual machine size.
   */
  @visibility("read")
  name?: string;

  /**
   * The family name of the virtual machine size.
   */
  @visibility("read")
  family?: string;

  /**
   * The number of vCPUs supported by the virtual machine size.
   */
  @visibility("read")
  vCPUs?: int32;

  /**
   * The number of gPUs supported by the virtual machine size.
   */
  @visibility("read")
  gpus?: int32;

  /**
   * The OS VHD disk size, in MB, allowed by the virtual machine size.
   */
  @visibility("read")
  osVhdSizeMB?: int32;

  /**
   * The resource volume size, in MB, allowed by the virtual machine size.
   */
  @visibility("read")
  maxResourceVolumeMB?: int32;

  /**
   * The amount of memory, in GB, supported by the virtual machine size.
   */
  @visibility("read")
  memoryGB?: float64;

  /**
   * Specifies if the virtual machine size supports low priority VMs.
   */
  @visibility("read")
  lowPriorityCapable?: boolean;

  /**
   * Specifies if the virtual machine size supports premium IO.
   */
  @visibility("read")
  premiumIO?: boolean;

  /**
   * The estimated price information for using a VM.
   */
  estimatedVMPrices?: EstimatedVMPrices;

  /**
   * Specifies the compute types supported by the virtual machine size.
   */
  supportedComputeTypes?: string[];
}

/**
 * The estimated price info for using a VM.
 */
model EstimatedVMPrices {
  /**
   * Three lettered code specifying the currency of the VM price. Example: USD
   */
  billingCurrency: BillingCurrency;

  /**
   * The unit of time measurement for the specified VM price. Example: OneHour
   */
  unitOfMeasure: UnitOfMeasure;

  /**
   * The list of estimated prices for using a VM of a particular OS type, tier, etc.
   */
  values: EstimatedVMPrice[];
}

/**
 * The estimated price info for using a VM of a particular OS type, tier, etc.
 */
model EstimatedVMPrice {
  /**
   * The price charged for using the VM.
   */
  retailPrice: float64;

  /**
   * Operating system type used by the VM.
   */
  osType: VMPriceOSType;

  /**
   * The type of the VM.
   */
  vmTier: VMTier;
}

/**
 * Quota update parameters.
 */
model QuotaUpdateParameters {
  /**
   * The list for update quota.
   */
  value?: QuotaBaseProperties[];

  /**
   * Region of workspace quota to be updated.
   */
  location?: string;
}

/**
 * The properties for Quota update or retrieval.
 */
model QuotaBaseProperties {
  /**
   * Specifies the resource ID.
   */
  id?: string;

  /**
   * Specifies the resource type.
   */
  type?: string;

  /**
   * The maximum permitted quota of the resource.
   */
  limit?: int64;

  /**
   * An enum describing the unit of quota measurement.
   */
  unit?: QuotaUnit;
}

/**
 * The result of update workspace quota.
 */
model UpdateWorkspaceQuotasResult {
  /**
   * The list of workspace quota update result.
   */
  @visibility("read")
  value?: UpdateWorkspaceQuotas[];

  /**
   * The URI to fetch the next page of workspace quota update result. Call ListNext() with this to fetch the next page of Workspace Quota update result.
   */
  @visibility("read")
  nextLink?: string;
}

/**
 * The properties for update Quota response.
 */
model UpdateWorkspaceQuotas {
  /**
   * Specifies the resource ID.
   */
  @visibility("read")
  id?: string;

  /**
   * Specifies the resource type.
   */
  @visibility("read")
  type?: string;

  /**
   * The maximum permitted quota of the resource.
   */
  limit?: int64;

  /**
   * An enum describing the unit of quota measurement.
   */
  @visibility("read")
  unit?: QuotaUnit;

  /**
   * Status of update workspace quota.
   */
  status?: Status;
}

/**
 * The List WorkspaceQuotasByVMFamily operation response.
 */
model ListWorkspaceQuotas is Azure.Core.Page<ResourceQuota>;

/**
 * The quota assigned to a resource.
 */
model ResourceQuota {
  /**
   * Specifies the resource ID.
   */
  @visibility("read")
  id?: string;

  /**
   * Region of the AML workspace in the id.
   */
  @visibility("read")
  amlWorkspaceLocation?: string;

  /**
   * Specifies the resource type.
   */
  @visibility("read")
  type?: string;

  /**
   * Name of the resource.
   */
  @visibility("read")
  name?: ResourceName;

  /**
   * The maximum permitted quota of the resource.
   */
  @visibility("read")
  limit?: int64;

  /**
   * An enum describing the unit of quota measurement.
   */
  @visibility("read")
  unit?: QuotaUnit;
}

/**
 * The Resource Name.
 */
model ResourceName {
  /**
   * The name of the resource.
   */
  @visibility("read")
  value?: string;

  /**
   * The localized name of the resource.
   */
  @visibility("read")
  localizedValue?: string;
}

/**
 * The resource model definition representing SKU
 */
model Sku {
  /**
   * The name of the SKU. Ex - P3. It is typically a letter+number code
   */
  name: string;

  /**
   * This field is required to be implemented by the Resource Provider if the service has more than one tier, but is not required on a PUT.
   */
  tier?: SkuTier;

  /**
   * The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.
   */
  size?: string;

  /**
   * If the service has different generations of hardware, for the same SKU, then that can be captured here.
   */
  family?: string;

  /**
   * If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.
   */
  capacity?: int32;
}

/**
 * Common fields that are returned in the response for all Azure Resource Manager resources
 */
model Resource {
  /**
   * Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}
   */
  @visibility("read")
  id?: string;

  /**
   * The name of the resource
   */
  @visibility("read")
  name?: string;

  /**
   * The type of the resource. E.g. "Microsoft.Compute/virtualMachines" or "Microsoft.Storage/storageAccounts"
   */
  @visibility("read")
  type?: string;

  /**
   * Azure Resource Manager metadata containing createdBy and modifiedBy information.
   */
  @visibility("read")
  systemData?: SystemData;
}

model ComputeResourceSchema {
  /**
   * Compute properties
   */
  properties?: Compute;
}

/**
 * Machine Learning compute object.
 */
@discriminator("computeType")
model Compute {
  /**
   * Location for the underlying compute
   */
  @visibility("read", "create")
  computeLocation?: string;

  /**
   * The provision state of the cluster. Valid values are Unknown, Updating, Provisioning, Succeeded, and Failed.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * The description of the Machine Learning compute.
   */
  description?: string;

  /**
   * The time at which the compute was created.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  /**
   * The time at which the compute was last modified.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  modifiedOn?: utcDateTime;

  /**
   * ARM resource id of the underlying compute
   */
  resourceId?: string;

  /**
   * Errors during provisioning
   */
  @visibility("read")
  provisioningErrors?: ErrorResponse[];

  /**
   * Indicating whether the compute was provisioned by user and brought from outside if true, or machine learning service provisioned it if false.
   */
  @visibility("read")
  isAttachedCompute?: boolean;

  /**
   * Opt-out of local authentication and ensure customers can use only MSI and AAD exclusively for authentication.
   */
  @visibility("read", "create")
  disableLocalAuth?: boolean;
}

/**
 * AmlCompute update parameters.
 */
model ClusterUpdateParameters {
  /**
   * The properties of the amlCompute.
   */
  properties?: ClusterUpdateProperties;
}

/**
 * The properties of a amlCompute that need to be updated.
 */
model ClusterUpdateProperties {
  /**
   * Properties of ClusterUpdate
   */
  properties?: ScaleSettingsInformation;
}

/**
 * Desired scale settings for the amlCompute.
 */
model ScaleSettingsInformation {
  /**
   * scale settings for AML Compute
   */
  scaleSettings?: ScaleSettings;
}

/**
 * scale settings for AML Compute
 */
model ScaleSettings {
  /**
   * Max number of nodes to use
   */
  maxNodeCount: int32;

  /**
   * Min number of nodes to use
   */
  minNodeCount?: int32;

  /**
   * Node Idle Time before scaling down amlCompute. This string needs to be in the RFC Format.
   */
  nodeIdleTimeBeforeScaleDown?: duration;
}

/**
 * Specifies the custom service configuration
 */
model CustomService {
  ...Record<unknown>;

  /**
   * Name of the Custom Service
   */
  name?: string;

  /**
   * Describes the Image Specifications
   */
  image?: Image;

  /**
   * Environment Variable for the container
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  environmentVariables?: Record<EnvironmentVariable>;

  /**
   * Describes the docker settings for the image
   */
  docker?: Docker;

  /**
   * Configuring the endpoints for the container
   */
  endpoints?: Endpoint[];

  /**
   * Configuring the volumes for the container
   */
  volumes?: VolumeDefinition[];
}

model Image {
  ...Record<unknown>;

  /**
   * Type of the image. Possible values are: docker - For docker images. azureml - For AzureML images
   */
  type?: ImageType = ImageType.docker;

  /**
   * Image reference URL
   */
  reference?: string;
}

model EnvironmentVariable {
  ...Record<unknown>;

  /**
   * Type of the Environment Variable. Possible values are: local - For local variable
   */
  type?: EnvironmentVariableType = EnvironmentVariableType.local;

  /**
   * Value of the Environment variable
   */
  value?: string;
}

model Docker {
  ...Record<unknown>;

  /**
   * Indicate whether container shall run in privileged or non-privileged mode.
   */
  privileged?: boolean;
}

model Endpoint {
  /**
   * Protocol over which communication will happen over this endpoint
   */
  protocol?: Protocol = Protocol.tcp;

  /**
   * Name of the Endpoint
   */
  name?: string;

  /**
   * Application port inside the container.
   */
  target?: int32;

  /**
   * Port over which the application is exposed from container.
   */
  published?: int32;

  /**
   * Host IP over which the application is exposed from the container
   */
  hostIp?: string;
}

model VolumeDefinition {
  /**
   * Type of Volume Definition. Possible Values: bind,volume,tmpfs,npipe
   */
  type?: VolumeDefinitionType = VolumeDefinitionType.bind;

  /**
   * Indicate whether to mount volume as readOnly. Default value for this is false.
   */
  readOnly?: boolean;

  /**
   * Source of the mount. For bind mounts this is the host path.
   */
  source?: string;

  /**
   * Target of the mount. For bind mounts this is the path in the container.
   */
  target?: string;

  /**
   * Consistency of the volume
   */
  consistency?: string;

  /**
   * Bind Options of the mount
   */
  bind?: BindOptions;

  /**
   * Volume Options of the mount
   */
  volume?: VolumeOptions;

  /**
   * tmpfs option of the mount
   */
  tmpfs?: TmpfsOptions;
}

model BindOptions {
  /**
   * Type of Bind Option
   */
  propagation?: string;

  /**
   * Indicate whether to create host path.
   */
  createHostPath?: boolean;

  /**
   * Mention the selinux options.
   */
  selinux?: string;
}

model VolumeOptions {
  /**
   * Indicate whether volume is nocopy
   */
  nocopy?: boolean;
}

model TmpfsOptions {
  /**
   * Mention the Tmpfs size
   */
  size?: int32;
}

/**
 * Result of AmlCompute Nodes
 */
@pagedResult
model AmlComputeNodesInformation {
  /**
   * The collection of returned AmlCompute nodes details.
   */
  @visibility("read")
  @items
  nodes?: AmlComputeNodeInformation[];

  /**
   * The continuation token.
   */
  @visibility("read")
  @nextLink
  nextLink?: string;
}

/**
 * Compute node information related to a AmlCompute.
 */
model AmlComputeNodeInformation {
  /**
   * ID of the compute node.
   */
  @visibility("read")
  nodeId?: string;

  /**
   * Private IP address of the compute node.
   */
  @visibility("read")
  privateIpAddress?: string;

  /**
   * Public IP address of the compute node.
   */
  @visibility("read")
  publicIpAddress?: string;

  /**
   * SSH port number of the node.
   */
  @visibility("read")
  port?: int32;

  /**
   * State of the compute node. Values are idle, running, preparing, unusable, leaving and preempted.
   */
  @visibility("read")
  nodeState?: NodeState;

  /**
   * ID of the Experiment running on the node, if any else null.
   */
  @visibility("read")
  runId?: string;
}

/**
 * Secrets related to a Machine Learning compute. Might differ for every type of compute.
 */
@discriminator("computeType")
model ComputeSecrets {}

/**
 * Stops compute instance after user defined period of inactivity.
 */
model IdleShutdownSetting {
  /**
   * Time is defined in ISO8601 format. Minimum is 15 min, maximum is 3 days.
   */
  idleTimeBeforeShutdown?: string;
}

/**
 * Container for code asset versions.
 */
model CodeContainer extends AssetContainer {
  /**
   * Provisioning state for the code container.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

model AssetContainer extends ResourceBase {
  /**
   * Is the asset archived?
   */
  @visibility("read", "create", "update")
  isArchived?: boolean;

  /**
   * The latest version inside this container.
   */
  @visibility("read")
  latestVersion?: string;

  /**
   * The next auto incremental version
   */
  @visibility("read")
  nextVersion?: string;
}

model ResourceBase {
  /**
   * The asset description text.
   */
  description?: string;

  /**
   * The asset property dictionary.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  properties?: Record<string>;

  /**
   * Tag dictionary. Tags can be added, removed, and updated.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Code asset version details.
 */
model CodeVersion extends AssetBase {
  /**
   * Uri where code is located
   */
  codeUri?: string;

  /**
   * Provisioning state for the code version.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

model AssetBase extends ResourceBase {
  /**
   * Specifies the lifecycle setting of managed data asset.
   */
  @visibility("read", "create", "update")
  autoDeleteSetting?: AutoDeleteSetting;

  /**
   * If the name version are system generated (anonymous registration). For types where Stage is defined, when Stage is provided it will be used to populate IsAnonymous
   */
  @visibility("read", "create")
  isAnonymous?: boolean;

  /**
   * Is the asset archived? For types where Stage is defined, when Stage is provided it will be used to populate IsArchived
   */
  @visibility("read", "create", "update")
  isArchived?: boolean;
}

model AutoDeleteSetting {
  /**
   * When to check if an asset is expired
   */
  @visibility("read", "create", "update")
  condition?: AutoDeleteCondition;

  /**
   * Expiration condition value.
   */
  @visibility("read", "create", "update")
  value?: string;
}

model PendingUploadRequestDto {
  /**
   * If PendingUploadId = null then random guid will be used.
   */
  pendingUploadId?: string;

  /**
   * TemporaryBlobReference is the only supported type
   */
  pendingUploadType?: PendingUploadType;
}

model PendingUploadResponseDto {
  /**
   * Container level read, write, list SAS
   */
  blobReferenceForConsumption?: BlobReferenceForConsumptionDto;

  /**
   * ID for this upload request
   */
  pendingUploadId?: string;

  /**
   * TemporaryBlobReference is the only supported type
   */
  pendingUploadType?: PendingUploadType;
}

model BlobReferenceForConsumptionDto {
  /**
   * Blob URI path for client to upload data.
   * Example: https://blob.windows.core.net/Container/Path
   */
  blobUri?: url;

  /**
   * Credential info to access storage account
   */
  credential?: PendingUploadCredentialDto;

  /**
   * Arm ID of the storage account to use
   */
  storageAccountArmId?: string;
}

@discriminator("credentialType")
model PendingUploadCredentialDto {}

/**
 * Component container definition.
 * <see href="https://docs.microsoft.com/en-us/azure/machine-learning/reference-yaml-component-command" />
 */
model ComponentContainer extends AssetContainer {
  /**
   * Provisioning state for the component container.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

/**
 * Definition of a component version: defines resources that span component types.
 */
model ComponentVersion extends AssetBase {
  /**
   * Defines Component definition details.
   * <see href="https://docs.microsoft.com/en-us/azure/machine-learning/reference-yaml-component-command" />
   */
  @visibility("read", "create")
  componentSpec?: Record<unknown>;

  /**
   * Provisioning state for the component version.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;

  /**
   * Stage in the component lifecycle
   */
  stage?: string;
}

/**
 * Container for data asset versions.
 */
model DataContainer extends AssetContainer {
  /**
   * [Required] Specifies the type of data.
   */
  @visibility("read", "create")
  dataType: DataType;
}

/**
 * Data version base definition
 */
@discriminator("dataType")
model DataVersionBase extends AssetBase {
  /**
   * [Required] Uri of the data. Example: https://go.microsoft.com/fwlink/?linkid=2202330
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  dataUri: string;

  /**
   * Intellectual Property details. Used if data is an Intellectual Property.
   */
  @visibility("read", "create")
  intellectualProperty?: IntellectualProperty;

  /**
   * Stage in the data lifecycle assigned to this data asset
   */
  stage?: string;
}

/**
 * Intellectual Property details for a resource.
 */
model IntellectualProperty {
  /**
   * Protection level of the Intellectual Property.
   */
  protectionLevel?: ProtectionLevel;

  /**
   * [Required] Publisher of the Intellectual Property. Must be the same as Registry publisher name.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  publisher: string;
}

/**
 * Container for environment specification versions.
 */
model EnvironmentContainer extends AssetContainer {
  /**
   * Provisioning state for the environment container.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

/**
 * Environment version details.
 */
model EnvironmentVersion extends AssetBase {
  /**
   * Defines if image needs to be rebuilt based on base image changes.
   */
  @visibility("read", "create")
  autoRebuild?: AutoRebuildSetting;

  /**
   * Configuration settings for Docker build context.
   */
  @visibility("read", "create")
  build?: BuildContext;

  /**
   * Standard configuration file used by Conda that lets you install any kind of package, including Python, R, and C/C++ packages.
   * <see href="https://repo2docker.readthedocs.io/en/latest/config_files.html#environment-yml-install-a-conda-environment" />
   */
  @visibility("read", "create")
  condaFile?: string;

  /**
   * Environment type is either user managed or curated by the Azure ML service
   * <see href="https://docs.microsoft.com/en-us/azure/machine-learning/resource-curated-environments" />
   */
  @visibility("read")
  environmentType?: EnvironmentType;

  /**
   * Name of the image that will be used for the environment.
   * <seealso href="https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-custom-docker-image#use-a-custom-base-image" />
   */
  @visibility("read", "create")
  image?: string;

  /**
   * Defines configuration specific to inference.
   */
  @visibility("read", "create")
  inferenceConfig?: InferenceContainerProperties;

  /**
   * Intellectual Property details. Used if environment is an Intellectual Property.
   */
  @visibility("read", "create")
  intellectualProperty?: IntellectualProperty;

  /**
   * The OS type of the environment.
   */
  @visibility("read", "create")
  osType?: OperatingSystemType;

  /**
   * Provisioning state for the environment version.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;

  /**
   * Stage in the environment lifecycle assigned to this environment
   */
  stage?: string;
}

/**
 * Configuration settings for Docker build context
 */
model BuildContext {
  /**
   * [Required] URI of the Docker build context used to build the image. Supports blob URIs on environment creation and may return blob or Git URIs.
   * <seealso href="https://docs.docker.com/engine/reference/commandline/build/#extended-description" />
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  contextUri: string;

  /**
   * Path to the Dockerfile in the build context.
   * <seealso href="https://docs.docker.com/engine/reference/builder/" />
   */
  @visibility("read", "create")
  dockerfilePath?: string = "Dockerfile";
}

model InferenceContainerProperties {
  /**
   * The route to check the liveness of the inference server container.
   */
  livenessRoute?: Route;

  /**
   * The route to check the readiness of the inference server container.
   */
  readinessRoute?: Route;

  /**
   * The port to send the scoring requests to, within the inference server container.
   */
  scoringRoute?: Route;
}

model Route {
  /**
   * [Required] The path for the route.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  path: string;

  /**
   * [Required] The port for the route.
   */
  port: int32;
}

model ModelContainer extends AssetContainer {
  /**
   * Provisioning state for the model container.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

/**
 * Model asset version details.
 */
model ModelVersion extends AssetBase {
  /**
   * Mapping of model flavors to their properties.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  flavors?: Record<FlavorData>;

  /**
   * Intellectual Property details. Used if model is an Intellectual Property.
   */
  @visibility("read", "create")
  intellectualProperty?: IntellectualProperty;

  /**
   * Name of the training job which produced this model
   */
  jobName?: string;

  /**
   * The storage format for this entity. Used for NCD.
   */
  modelType?: string;

  /**
   * The URI path to the model contents.
   */
  modelUri?: string;

  /**
   * Provisioning state for the model version.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;

  /**
   * Stage in the model lifecycle assigned to this model
   */
  stage?: string;
}

model FlavorData {
  /**
   * Model flavor-specific data.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  data?: Record<string>;
}

/**
 * Model package operation request properties.
 */
model PackageRequest {
  /**
   * Base environment to start with.
   */
  @visibility("read", "create")
  baseEnvironmentSource?: BaseEnvironmentSource;

  /**
   * Collection of environment variables.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  environmentVariables?: Record<string>;

  /**
   * [Required] Inferencing server configurations.
   */
  @visibility("read", "create")
  inferencingServer: InferencingServer;

  /**
   * Collection of inputs.
   */
  @visibility("read", "create")
  inputs?: ModelPackageInput[];

  /**
   * Model configuration including the mount mode.
   */
  @visibility("read", "create")
  modelConfiguration?: ModelConfiguration;

  /**
   * Tag dictionary. Tags can be added, removed, and updated.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  tags?: Record<string>;

  /**
   * [Required] Arm ID of the target environment to be created by package operation.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  targetEnvironmentId: string;
}

@discriminator("baseEnvironmentSourceType")
model BaseEnvironmentSource {}

@discriminator("serverType")
model InferencingServer {}

/**
 * Model package input options.
 */
model ModelPackageInput {
  /**
   * [Required] Type of the input included in the target image.
   */
  inputType: PackageInputType;

  /**
   * Input delivery mode of the input.
   */
  mode?: PackageInputDeliveryMode;

  /**
   * Relative mount path of the input in the target image.
   */
  mountPath?: string;

  /**
   * [Required] Location of the input.
   */
  path: PackageInputPathBase;
}

@discriminator("inputPathType")
model PackageInputPathBase {}

/**
 * Model configuration options.
 */
model ModelConfiguration {
  /**
   * Input delivery mode for the model.
   */
  mode?: PackageInputDeliveryMode;

  /**
   * Relative mounting path of the model in the target image.
   */
  mountPath?: string;
}

/**
 * Package response returned after async package operation completes successfully.
 */
model PackageResponse {
  /**
   * Base environment to start with.
   */
  @visibility("read")
  baseEnvironmentSource?: BaseEnvironmentSource;

  /**
   * Build id of the image build operation.
   */
  @visibility("read")
  buildId?: string;

  /**
   * Build state of the image build operation.
   */
  @visibility("read")
  buildState?: PackageBuildState;

  /**
   * Collection of environment variables.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read")
  environmentVariables?: Record<string>;

  /**
   * Inferencing server configurations.
   */
  @visibility("read")
  inferencingServer?: InferencingServer;

  /**
   * Collection of inputs.
   */
  @visibility("read")
  inputs?: ModelPackageInput[];

  /**
   * Log url of the image build operation.
   */
  @visibility("read")
  logUrl?: string;

  /**
   * Model configuration including the mount mode.
   */
  @visibility("read")
  modelConfiguration?: ModelConfiguration;

  /**
   * Tag dictionary. Tags can be added, removed, and updated.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read")
  tags?: Record<string>;

  /**
   * Asset ID of the target environment created by package operation.
   */
  @visibility("read")
  targetEnvironmentId?: string;
}

/**
 * Batch endpoint configuration.
 */
model BatchEndpoint extends EndpointPropertiesBase {
  /**
   * Default values for Batch Endpoint.
   */
  defaults?: BatchEndpointDefaults;

  /**
   * Provisioning state for the endpoint.
   */
  @visibility("read")
  provisioningState?: EndpointProvisioningState;
}

/**
 * Batch endpoint default values
 */
model BatchEndpointDefaults {
  /**
   * Name of the deployment that will be default for the endpoint.
   * This deployment will end up getting 100% traffic when the endpoint scoring URL is invoked.
   */
  deploymentName?: string;
}

/**
 * Inference Endpoint base definition
 */
model EndpointPropertiesBase {
  /**
   * [Required] Use 'Key' for key based authentication and 'AMLToken' for Azure Machine Learning token-based authentication. 'Key' doesn't expire but 'AMLToken' does.
   */
  authMode: EndpointAuthMode;

  /**
   * Description of the inference endpoint.
   */
  description?: string;

  /**
   * EndpointAuthKeys to set initially on an Endpoint.
   * This property will always be returned as null. AuthKey values must be retrieved using the ListKeys API.
   */
  @visibility("create")
  keys?: EndpointAuthKeys;

  /**
   * Property dictionary. Properties can be added, but not removed or altered.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  properties?: Record<string>;

  /**
   * Endpoint URI.
   */
  @visibility("read")
  scoringUri?: url;

  /**
   * Endpoint Swagger URI.
   */
  @visibility("read")
  swaggerUri?: url;
}

/**
 * Keys for endpoint authentication.
 */
model EndpointAuthKeys {
  /**
   * The primary key.
   */
  @visibility("read", "create")
  primaryKey?: string;

  /**
   * The secondary key.
   */
  @visibility("read", "create")
  secondaryKey?: string;
}

/**
 * Strictly used in update requests.
 */
model PartialMinimalTrackedResourceWithIdentity
  extends PartialMinimalTrackedResource {
  /**
   * Managed service identity (system assigned and/or user assigned identities)
   */
  identity?: PartialManagedServiceIdentity;
}

/**
 * Managed service identity (system assigned and/or user assigned identities)
 */
model PartialManagedServiceIdentity {
  /**
   * Managed service identity (system assigned and/or user assigned identities)
   */
  type?: ManagedServiceIdentityType;

  /**
   * The set of user assigned identities associated with the resource. The userAssignedIdentities dictionary keys will be ARM resource ids in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}. The dictionary values can be empty objects ({}) in requests.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  userAssignedIdentities?: Record<Record<unknown>>;
}

/**
 * Strictly used in update requests.
 */
model PartialMinimalTrackedResource {
  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Batch inference settings per deployment.
 */
model BatchDeployment extends EndpointDeploymentPropertiesBase {
  /**
   * Compute target for batch inference operation.
   */
  compute?: string;

  /**
   * Properties relevant to different deployment types.
   */
  deploymentConfiguration?: BatchDeploymentConfiguration;

  /**
   * Error threshold, if the error count for the entire input goes above this value,
   * the batch inference will be aborted. Range is [-1, int.MaxValue].
   * For FileDataset, this value is the count of file failures.
   * For TabularDataset, this value is the count of record failures.
   * If set to -1 (the lower bound), all failures during batch inference will be ignored.
   */
  errorThreshold?: int32 = -1;

  /**
   * Logging level for batch inference operation.
   */
  loggingLevel?: BatchLoggingLevel;

  /**
   * Indicates maximum number of parallelism per instance.
   */
  maxConcurrencyPerInstance?: int32 = 1;

  /**
   * Size of the mini-batch passed to each batch invocation.
   * For FileDataset, this is the number of files per mini-batch.
   * For TabularDataset, this is the size of the records in bytes, per mini-batch.
   */
  miniBatchSize?: int64 = 10;

  /**
   * Reference to the model asset for the endpoint deployment.
   */
  `model`?: AssetReferenceBase;

  /**
   * Indicates how the output will be organized.
   */
  outputAction?: BatchOutputAction;

  /**
   * Customized output file name for append_row output action.
   */
  outputFileName?: string = "predictions.csv";

  /**
   * Provisioning state for the endpoint deployment.
   */
  @visibility("read")
  provisioningState?: DeploymentProvisioningState;

  /**
   * Indicates compute configuration for the job.
   * If not provided, will default to the defaults defined in ResourceConfiguration.
   */
  resources?: DeploymentResourceConfiguration;

  /**
   * Retry Settings for the batch inference operation.
   * If not provided, will default to the defaults defined in BatchRetrySettings.
   */
  retrySettings?: BatchRetrySettings;
}

/**
 * Properties relevant to different deployment types.
 */
@discriminator("deploymentConfigurationType")
model BatchDeploymentConfiguration {}

/**
 * Base definition for asset references.
 */
@discriminator("referenceType")
model AssetReferenceBase {}

model DeploymentResourceConfiguration extends ResourceConfiguration {}

model ResourceConfiguration {
  /**
   * Optional number of instances or nodes used by the compute target.
   */
  @visibility("read", "create")
  instanceCount?: int32 = 1;

  /**
   * Optional type of VM used as supported by the compute target.
   */
  @visibility("read", "create")
  instanceType?: string;

  /**
   * Locations where the job can run.
   */
  @visibility("read", "create")
  locations?: string[];

  /**
   * Optional max allowed number of instances or nodes to be used by the compute target.
   * For use with elastic training, currently supported by PyTorch distribution type only.
   */
  @visibility("read", "create")
  maxInstanceCount?: int32;

  /**
   * Additional properties bag.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  properties?: Record<Record<unknown>>;
}

/**
 * Retry settings for a batch inference operation.
 */
model BatchRetrySettings {
  /**
   * Maximum retry count for a mini-batch
   */
  maxRetries?: int32 = 3;

  /**
   * Invocation timeout for a mini-batch, in ISO 8601 format.
   */
  timeout?: duration;
}

/**
 * Base definition for endpoint deployment.
 */
model EndpointDeploymentPropertiesBase {
  /**
   * Code configuration for the endpoint deployment.
   */
  codeConfiguration?: CodeConfiguration;

  /**
   * Description of the endpoint deployment.
   */
  description?: string;

  /**
   * ARM resource ID of the environment specification for the endpoint deployment.
   */
  environmentId?: string;

  /**
   * Environment variables configuration for the deployment.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  environmentVariables?: Record<string>;

  /**
   * Property dictionary. Properties can be added, but not removed or altered.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  properties?: Record<string>;
}

/**
 * Configuration for a scoring code asset.
 */
model CodeConfiguration {
  /**
   * ARM resource ID of the code asset.
   */
  @visibility("read", "create")
  codeId?: string;

  /**
   * [Required] The script to execute on startup. eg. "score.py"
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  scoringScript: string;
}

/**
 * Strictly used in update requests.
 */
model PartialBatchDeploymentPartialMinimalTrackedResourceWithProperties {
  /**
   * Additional attributes of the entity.
   */
  properties?: PartialBatchDeployment;

  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Mutable batch inference settings per deployment.
 */
model PartialBatchDeployment {
  /**
   * Description of the endpoint deployment.
   */
  description?: string;
}

/**
 * Base definition for datastore contents configuration.
 */
@discriminator("datastoreType")
model Datastore extends ResourceBase {
  /**
   * [Required] Account credentials.
   */
  credentials: DatastoreCredentials;

  /**
   * Intellectual Property details.
   */
  @visibility("read", "create")
  intellectualProperty?: IntellectualProperty;

  /**
   * Readonly property to indicate if datastore is the workspace default datastore
   */
  @visibility("read")
  isDefault?: boolean;
}

/**
 * Base definition for datastore credentials.
 */
@discriminator("credentialsType")
model DatastoreCredentials {}

/**
 * Base definition for datastore secrets.
 */
@discriminator("secretsType")
model DatastoreSecrets {}

/**
 * Dto object representing feature set
 */
model FeaturesetContainerProperties extends AssetContainer {
  /**
   * Provisioning state for the featureset container.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

/**
 * Dto object representing feature
 */
model FeatureProperties extends ResourceBase {
  /**
   * Specifies type
   */
  dataType?: FeatureDataType;

  /**
   * Specifies name
   */
  featureName?: string;
}

/**
 * Dto object representing feature set version
 */
model FeaturesetVersionProperties extends AssetBase {
  /**
   * Specifies list of entities
   */
  entities?: string[];

  /**
   * Specifies the materialization settings
   */
  materializationSettings?: MaterializationSettings;

  /**
   * Provisioning state for the featureset version container.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;

  /**
   * Specifies the feature spec details
   */
  specification?: FeaturesetSpecification;

  /**
   * Specifies the asset stage
   */
  stage?: string;
}

model MaterializationSettings {
  /**
   * Specifies the notification details
   */
  notification?: NotificationSetting;

  /**
   * Specifies the compute resource settings
   */
  resource?: MaterializationComputeResource;

  /**
   * Specifies the schedule details
   */
  schedule?: RecurrenceTrigger;

  /**
   * Specifies the spark compute settings
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  sparkConfiguration?: Record<string>;

  /**
   * Specifies the stores to which materialization should happen
   */
  storeType?: MaterializationStoreType;
}

/**
 * Configuration for notification.
 */
model NotificationSetting {
  /**
   * Send email notification to user on specified notification type
   */
  @visibility("read", "create")
  emailOn?: EmailNotificationEnableType[];

  /**
   * This is the email recipient list which has a limitation of 499 characters in total concat with comma separator
   */
  @visibility("read", "create")
  emails?: string[];

  /**
   * Send webhook callback to a service. Key is a user-provided name for the webhook.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create", "update")
  webhooks?: Record<Webhook>;
}

/**
 * Webhook base
 */
@discriminator("webhookType")
model Webhook {
  /**
   * Send callback on a specified notification event
   */
  @visibility("read", "create")
  eventType?: string;
}

/**
 * Dto object representing compute resource
 */
model MaterializationComputeResource {
  /**
   * Specifies the instance type
   */
  instanceType?: string;
}

model RecurrenceTrigger extends TriggerBase {
  /**
   * [Required] The frequency to trigger schedule.
   */
  frequency: RecurrenceFrequency;

  /**
   * [Required] Specifies schedule interval in conjunction with frequency
   */
  interval: int32;

  /**
   * The recurrence schedule.
   */
  schedule?: RecurrenceSchedule;

  /**
   * [Required]
   */
  triggerType: "Recurrence";
}

model RecurrenceSchedule {
  /**
   * [Required] List of hours for the schedule.
   */
  hours: int32[];

  /**
   * [Required] List of minutes for the schedule.
   */
  minutes: int32[];

  /**
   * List of month days for the schedule
   */
  monthDays?: int32[];

  /**
   * List of days for the schedule.
   */
  weekDays?: WeekDay[];
}

@discriminator("triggerType")
model TriggerBase {
  /**
   * Specifies end time of schedule in ISO 8601, but without a UTC offset. Refer https://en.wikipedia.org/wiki/ISO_8601.
   * Recommented format would be "2022-06-01T00:00:01"
   * If not present, the schedule will run indefinitely
   */
  endTime?: string;

  /**
   * Specifies start time of schedule in ISO 8601 format, but without a UTC offset.
   */
  startTime?: string;

  /**
   * Specifies time zone in which the schedule runs.
   * TimeZone should follow Windows time zone format. Refer: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11
   */
  timeZone?: string = "UTC";
}

/**
 * Dto object representing specification
 */
model FeaturesetSpecification {
  /**
   * Specifies the spec path
   */
  path?: string;
}

/**
 * Request payload for creating a backfill request for a given feature set version
 */
model FeaturesetVersionBackfillRequest {
  /**
   * Specifies description
   */
  description?: string;

  /**
   * Specifies description
   */
  displayName?: string;

  /**
   * Specifies the backfill feature window to be materialized
   */
  featureWindow?: FeatureWindow;

  /**
   * Specifies the compute resource settings
   */
  resource?: MaterializationComputeResource;

  /**
   * Specifies the spark compute settings
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  sparkConfiguration?: Record<string>;

  /**
   * Specifies the tags
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Specifies the feature window
 */
model FeatureWindow {
  /**
   * Specifies the feature window end time
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  featureWindowEnd?: utcDateTime;

  /**
   * Specifies the feature window start time
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  featureWindowStart?: utcDateTime;
}

/**
 * Dto object representing the feature set job
 */
model FeaturesetJob {
  /**
   * Specifies the created date
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDate?: utcDateTime;

  /**
   * Specifies the display name
   */
  displayName?: string;

  /**
   * Specifies the duration
   */
  duration?: duration;

  /**
   * Specifies the experiment id
   */
  experimentId?: string;

  /**
   * Specifies the backfill feature window to be materialized
   */
  featureWindow?: FeatureWindow;

  /**
   * Specifies the job id
   */
  jobId?: string;

  /**
   * Specifies the job status
   */
  status?: JobStatus;

  /**
   * Specifies the tags if any
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;

  /**
   * Specifies the feature store job type
   */
  type?: FeaturestoreJobType;
}

/**
 * A paginated list of FeaturesetJob entities.
 */
model FeaturesetJobArmPaginatedResult is Azure.Core.Page<FeaturesetJob>;

/**
 * Dto object representing feature entity
 */
model FeaturestoreEntityContainerProperties extends AssetContainer {
  /**
   * Provisioning state for the featurestore entity container.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

/**
 * Dto object representing feature entity version
 */
model FeaturestoreEntityVersionProperties extends AssetBase {
  /**
   * Specifies index columns
   */
  indexColumns?: IndexColumn[];

  /**
   * Provisioning state for the featurestore entity version.
   */
  @visibility("read")
  provisioningState?: AssetProvisioningState;

  /**
   * Specifies the asset stage
   */
  stage?: string;
}

/**
 * Dto object representing index column
 */
model IndexColumn {
  /**
   * Specifies the column name
   */
  columnName?: string;

  /**
   * Specifies the data type
   */
  dataType?: FeatureDataType;
}

/**
 * Base definition for a job.
 */
@discriminator("jobType")
model JobBase extends ResourceBase {
  /**
   * ARM resource ID of the component resource.
   */
  @visibility("read", "create")
  componentId?: string;

  /**
   * ARM resource ID of the compute resource.
   */
  @visibility("read", "create")
  computeId?: string;

  /**
   * Display name of job.
   */
  @visibility("read", "create")
  displayName?: string;

  /**
   * The name of the experiment the job belongs to. If not set, the job is placed in the "Default" experiment.
   */
  @visibility("read", "create")
  experimentName?: string = "Default";

  /**
   * Identity configuration. If set, this should be one of AmlToken, ManagedIdentity, UserIdentity or null.
   * Defaults to AmlToken if null.
   */
  @visibility("read", "create")
  identity?: IdentityConfiguration;

  /**
   * Is the asset archived?
   */
  @visibility("read", "create", "update")
  isArchived?: boolean;

  /**
   * Notification setting for the job
   */
  @visibility("read", "create", "update")
  notificationSetting?: NotificationSetting;

  /**
   * Configuration for secrets to be made available during runtime.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  secretsConfiguration?: Record<SecretConfiguration>;

  /**
   * List of JobEndpoints.
   * For local jobs, a job endpoint will have an endpoint value of FileStreamObject.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  services?: Record<JobService>;

  /**
   * Status of the job.
   */
  @visibility("read")
  status?: JobStatus;
}

/**
 * Base definition for identity configuration.
 */
@discriminator("identityType")
model IdentityConfiguration {}

/**
 * Secret Configuration definition.
 */
model SecretConfiguration {
  /**
   * Secret Uri.
   * Sample Uri : https://myvault.vault.azure.net/secrets/mysecretname/secretversion
   */
  @visibility("read", "create")
  uri?: string;

  /**
   * Name of secret in workspace key vault.
   */
  @visibility("read", "create")
  workspaceSecretName?: string;
}

/**
 * Job endpoint definition
 */
model JobService {
  /**
   * Url for endpoint.
   */
  @visibility("read", "create")
  endpoint?: string;

  /**
   * Any error in the service.
   */
  @visibility("read")
  errorMessage?: string;

  /**
   * Endpoint type.
   */
  @visibility("read", "create")
  jobServiceType?: string;

  /**
   * Nodes that user would like to start the service on.
   * If Nodes is not set or set to null, the service will only be started on leader node.
   */
  nodes?: Nodes;

  /**
   * Port for endpoint set by user.
   */
  @visibility("read", "create")
  port?: int32;

  /**
   * Additional properties to set on the endpoint.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  properties?: Record<string>;

  /**
   * Status of endpoint.
   */
  @visibility("read")
  status?: string;
}

/**
 * Abstract Nodes definition
 */
@discriminator("nodesValueType")
model Nodes {}

/**
 * Azure Resource Manager resource envelope strictly used in update requests.
 */
model PartialJobBasePartialResource {
  /**
   * Additional attributes of the entity.
   */
  properties?: PartialJobBase;
}

/**
 * Mutable base definition for a job.
 */
model PartialJobBase {
  /**
   * Mutable notification setting for the job
   */
  notificationSetting?: PartialNotificationSetting;
}

/**
 * Mutable configuration for notification.
 */
model PartialNotificationSetting {
  /**
   * Send webhook callback to a service. Key is a user-provided name for the webhook.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  webhooks?: Record<Webhook>;
}

/**
 * Labeling job definition
 */
model LabelingJobProperties extends JobBase {
  /**
   * Created time of the job in UTC timezone.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * Configuration of data used in the job.
   */
  @visibility("read", "create")
  dataConfiguration?: LabelingDataConfiguration;

  /**
   * Labeling instructions of the job.
   */
  @visibility("read", "create", "update")
  jobInstructions?: LabelingJobInstructions;

  /**
   * Label categories of the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create", "update")
  labelCategories?: Record<LabelCategory>;

  /**
   * Media type specific properties in the job.
   */
  @visibility("read", "create")
  labelingJobMediaProperties?: LabelingJobMediaProperties;

  /**
   * Configuration of MLAssist feature in the job.
   */
  @visibility("read", "create")
  mlAssistConfiguration?: MLAssistConfiguration;

  /**
   * Progress metrics of the job.
   */
  @visibility("read")
  progressMetrics?: ProgressMetrics;

  /**
   * Internal id of the job(Previously called project).
   */
  @visibility("read")
  projectId?: string;

  /**
   * Specifies the labeling job provisioning state.
   */
  @visibility("read")
  provisioningState?: JobProvisioningState;

  /**
   * Status messages of the job.
   */
  @visibility("read")
  statusMessages?: StatusMessage[];

  /**
   * [Required] Specifies the type of job.
   */
  jobType: "Labeling";
}

/**
 * Labeling data configuration definition
 */
model LabelingDataConfiguration {
  /**
   * Resource Id of the data asset to perform labeling.
   */
  @visibility("read", "create")
  dataId?: string;

  /**
   * Indicates whether to enable incremental data refresh.
   */
  @visibility("read", "create", "update")
  incrementalDataRefresh?: IncrementalDataRefresh;
}

/**
 * Instructions for labeling job
 */
model LabelingJobInstructions {
  /**
   * The link to a page with detailed labeling instructions for labelers.
   */
  @visibility("read", "create", "update")
  uri?: string;
}

/**
 * Label category definition
 */
model LabelCategory {
  /**
   * Dictionary of label classes in this category.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create", "update")
  classes?: Record<LabelClass>;

  /**
   * Display name of the label category.
   */
  @visibility("read", "create")
  displayName?: string;

  /**
   * Indicates whether it is allowed to select multiple classes in this category.
   */
  @visibility("read", "create", "update")
  multiSelect?: MultiSelect;
}

/**
 * Label class definition
 */
model LabelClass {
  /**
   * Display name of the label class.
   */
  @visibility("read", "create")
  displayName?: string;

  /**
   * Dictionary of subclasses of the label class.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create", "update")
  subclasses?: Record<LabelClass>;
}

/**
 * Properties of a labeling job
 */
@discriminator("mediaType")
model LabelingJobMediaProperties {}

/**
 * Labeling MLAssist configuration definition
 */
@discriminator("mlAssist")
model MLAssistConfiguration {}

/**
 * Progress metrics definition
 */
model ProgressMetrics {
  /**
   * The completed datapoint count.
   */
  @visibility("read")
  completedDatapointCount?: int64;

  /**
   * The time of last successful incremental data refresh in UTC.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  incrementalDataLastRefreshDateTime?: utcDateTime;

  /**
   * The skipped datapoint count.
   */
  @visibility("read")
  skippedDatapointCount?: int64;

  /**
   * The total datapoint count.
   */
  @visibility("read")
  totalDatapointCount?: int64;
}

/**
 * Active message associated with project
 */
model StatusMessage {
  /**
   * Service-defined message code.
   */
  @visibility("read")
  code?: string;

  /**
   * Time in UTC at which the message was created.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * Severity level of message.
   */
  @visibility("read")
  level?: StatusMessageLevel;

  /**
   * A human-readable representation of the message code.
   */
  @visibility("read")
  message?: string;
}

@discriminator("format")
model ExportSummary {
  /**
   * The time when the export was completed.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  /**
   * The total number of labeled datapoints exported.
   */
  @visibility("read")
  exportedRowCount?: int64;

  /**
   * Name and identifier of the job containing exported labels.
   */
  @visibility("read")
  labelingJobId?: string;

  /**
   * The time when the export was requested.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;
}

/**
 * Online endpoint configuration
 */
model OnlineEndpoint extends EndpointPropertiesBase {
  /**
   * ARM resource ID of the compute if it exists.
   * optional
   */
  compute?: string;

  /**
   * Percentage of traffic to be mirrored to each deployment without using returned scoring. Traffic values need to sum to utmost 50.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  mirrorTraffic?: Record<int32>;

  /**
   * Provisioning state for the endpoint.
   */
  @visibility("read")
  provisioningState?: EndpointProvisioningState;

  /**
   * Set to "Enabled" for endpoints that should allow public access when Private Link is enabled.
   */
  publicNetworkAccess?: PublicNetworkAccessType;

  /**
   * Percentage of traffic from endpoint to divert to each deployment. Traffic values need to sum to 100.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  traffic?: Record<int32>;
}

@discriminator("endpointComputeType")
model OnlineDeployment extends EndpointDeploymentPropertiesBase {
  /**
   * If true, enables Application Insights logging.
   */
  appInsightsEnabled?: boolean;

  /**
   * The mdc configuration, we disable mdc when it's null.
   */
  dataCollector?: DataCollector;

  /**
   * If Enabled, allow egress public network access. If Disabled, this will create secure egress. Default: Enabled.
   */
  egressPublicNetworkAccess?: EgressPublicNetworkAccessType;

  /**
   * Compute instance type.
   */
  @visibility("read", "create")
  instanceType?: string;

  /**
   * Liveness probe monitors the health of the container regularly.
   */
  livenessProbe?: ProbeSettings;

  /**
   * The URI path to the model.
   */
  `model`?: string;

  /**
   * The path to mount the model in custom container.
   */
  modelMountPath?: string;

  /**
   * Provisioning state for the endpoint deployment.
   */
  @visibility("read")
  provisioningState?: DeploymentProvisioningState;

  /**
   * Readiness probe validates if the container is ready to serve traffic. The properties and defaults are the same as liveness probe.
   */
  readinessProbe?: ProbeSettings;

  /**
   * Request settings for the deployment.
   */
  requestSettings?: OnlineRequestSettings;

  /**
   * Scale settings for the deployment.
   * If it is null or not provided,
   * it defaults to TargetUtilizationScaleSettings for KubernetesOnlineDeployment
   * and to DefaultScaleSettings for ManagedOnlineDeployment.
   */
  scaleSettings?: OnlineScaleSettings;
}

model DataCollector {
  /**
   * [Required] The collection configuration. Each collection has it own configuration to collect model data and the name of collection can be arbitrary string.
   * Model data collector can be used for either payload logging or custom logging or both of them. Collection request and response are reserved for payload logging, others are for custom logging.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  collections: Record<Collection>;

  /**
   * The request logging configuration for mdc, it includes advanced logging settings for all collections. It's optional.
   */
  requestLogging?: RequestLogging;

  /**
   * When model data is collected to blob storage, we need to roll the data to different path to avoid logging all of them in a single blob file.
   * If the rolling rate is hour, all data will be collected in the blob path /yyyy/MM/dd/HH/.
   * If it's day, all data will be collected in blob path /yyyy/MM/dd/.
   * The other benefit of rolling path is that model monitoring ui is able to select a time range of data very quickly.
   */
  rollingRate?: RollingRateType;
}

model Collection {
  /**
   * The msi client id used to collect logging to blob storage. If it's null,backend will pick a registered endpoint identity to auth.
   */
  clientId?: string;

  /**
   * Enable or disable data collection.
   */
  dataCollectionMode?: DataCollectionMode;

  /**
   * The data asset arm resource id. Client side will ensure data asset is pointing to the blob storage, and backend will collect data to the blob storage.
   */
  dataId?: string;

  /**
   * The sampling rate for collection. Sampling rate 1.0 means we collect 100% of data by default.
   */
  samplingRate?: float64 = 1;
}

model RequestLogging {
  /**
   * For payload logging, we only collect payload by default. If customers also want to collect the specified headers, they can set them in captureHeaders so that backend will collect those headers along with payload.
   */
  captureHeaders?: string[];
}

/**
 * Deployment container liveness/readiness probe configuration.
 */
model ProbeSettings {
  /**
   * The number of failures to allow before returning an unhealthy status.
   */
  failureThreshold?: int32 = 30;

  /**
   * The delay before the first probe in ISO 8601 format.
   */
  initialDelay?: duration;

  /**
   * The length of time between probes in ISO 8601 format.
   */
  period?: duration;

  /**
   * The number of successful probes before returning a healthy status.
   */
  successThreshold?: int32 = 1;

  /**
   * The probe timeout in ISO 8601 format.
   */
  timeout?: duration;
}

/**
 * Online deployment scoring requests configuration.
 */
model OnlineRequestSettings {
  /**
   * The number of maximum concurrent requests per node allowed per deployment. Defaults to 1.
   */
  maxConcurrentRequestsPerInstance?: int32 = 1;

  /**
   * The maximum amount of time a request will stay in the queue in ISO 8601 format.
   * Defaults to 500ms.
   */
  maxQueueWait?: duration;

  /**
   * The scoring timeout in ISO 8601 format.
   * Defaults to 5000ms.
   */
  requestTimeout?: duration;
}

/**
 * Online deployment scaling configuration.
 */
@discriminator("scaleType")
model OnlineScaleSettings {}

/**
 * Strictly used in update requests.
 */
model PartialMinimalTrackedResourceWithSku
  extends PartialMinimalTrackedResource {
  /**
   * Sku details required for ARM contract for Autoscaling.
   */
  sku?: PartialSku;
}

/**
 * Common SKU definition.
 */
model PartialSku {
  /**
   * If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.
   */
  capacity?: int32;

  /**
   * If the service has different generations of hardware, for the same SKU, then that can be captured here.
   */
  family?: string;

  /**
   * The name of the SKU. Ex - P3. It is typically a letter+number code.
   */
  name?: string;

  /**
   * The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.
   */
  size?: string;

  /**
   * This field is required to be implemented by the Resource Provider if the service has more than one tier, but is not required on a PUT.
   */
  tier?: SkuTier;
}

model DeploymentLogsRequest {
  /**
   * The type of container to retrieve logs from.
   */
  containerType?: ContainerType;

  /**
   * The maximum number of lines to tail.
   */
  tail?: int32;
}

model DeploymentLogs {
  /**
   * The retrieved online deployment logs.
   */
  content?: string;
}

/**
 * A paginated list of SkuResource entities.
 */
model SkuResourceArmPaginatedResult is Azure.Core.Page<SkuResource>;

/**
 * Fulfills ARM Contract requirement to list all available SKUS for a resource.
 */
model SkuResource {
  /**
   * Gets or sets the Sku Capacity.
   */
  capacity?: SkuCapacity;

  /**
   * The resource type name.
   */
  @visibility("read")
  resourceType?: string;

  /**
   * Gets or sets the Sku.
   */
  sku?: SkuSetting;
}

/**
 * SKU capacity information
 */
model SkuCapacity {
  /**
   * Gets or sets the default capacity.
   */
  default?: int32;

  /**
   * Gets or sets the maximum.
   */
  maximum?: int32;

  /**
   * Gets or sets the minimum.
   */
  minimum?: int32;

  /**
   * Gets or sets the type of the scale.
   */
  scaleType?: SkuScaleType;
}

/**
 * SkuSetting fulfills the need for stripped down SKU info in ARM contract.
 */
model SkuSetting {
  /**
   * [Required] The name of the SKU. Ex - P3. It is typically a letter+number code.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  name: string;

  /**
   * This field is required to be implemented by the Resource Provider if the service has more than one tier, but is not required on a PUT.
   */
  tier?: SkuTier;
}

model RegenerateEndpointKeysRequest {
  /**
   * [Required] Specification for which type of key to generate. Primary or Secondary.
   */
  keyType: KeyType;

  /**
   * The value the key is set to.
   */
  keyValue?: string;
}

/**
 * Service Token
 */
model EndpointAuthToken {
  /**
   * Access token for endpoint authentication.
   */
  accessToken?: string;

  /**
   * Access token expiry time (UTC).
   */
  expiryTimeUtc?: plainTime;

  /**
   * Refresh access token after time (UTC).
   */
  refreshAfterTimeUtc?: plainTime;

  /**
   * Access token type.
   */
  tokenType?: string;
}

/**
 * Base definition of a schedule
 */
model ScheduleProperties extends ResourceBase {
  /**
   * [Required] Specifies the action of the schedule
   */
  @visibility("read", "create", "update")
  action: ScheduleActionBase;

  /**
   * Display name of schedule.
   */
  @visibility("read", "create")
  displayName?: string;

  /**
   * Is the schedule enabled?
   */
  @visibility("read", "create", "update")
  isEnabled?: boolean = true;

  /**
   * Provisioning state for the schedule.
   */
  @visibility("read")
  provisioningState?: ScheduleProvisioningStatus;

  /**
   * [Required] Specifies the trigger details
   */
  @visibility("read", "create", "update")
  trigger: TriggerBase;
}

@discriminator("actionType")
model ScheduleActionBase {}

/**
 * Details of the Registry
 */
model RegistryProperties {
  /**
   * Discovery URL for the Registry
   */
  discoveryUrl?: string;

  /**
   * IntellectualPropertyPublisher for the registry
   */
  intellectualPropertyPublisher?: string;

  /**
   * ResourceId of the managed RG if the registry has system created resources
   */
  managedResourceGroup?: ArmResourceId;

  /**
   * MLFlow Registry URI for the Registry
   */
  mlFlowRegistryUri?: string;

  /**
   * Private endpoint connections info used for pending connections in private link portal
   */
  privateEndpointConnections?: RegistryPrivateEndpointConnection[];

  /**
   * Is the Registry accessible from the internet?
   * Possible values: "Enabled" or "Disabled"
   */
  publicNetworkAccess?: string;

  /**
   * Details of each region the registry is in
   */
  regionDetails?: RegistryRegionArmDetails[];
}

/**
 * ARM ResourceId of a resource
 */
model ArmResourceId {
  /**
   * Arm ResourceId is in the format "/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Storage/storageAccounts/{StorageAccountName}"
   * or "/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{AcrName}"
   */
  resourceId?: string;
}

/**
 * Private endpoint connection definition.
 */
model RegistryPrivateEndpointConnection {
  /**
   * This is the private endpoint connection name created on SRP
   * Full resource id: /subscriptions/{subId}/resourceGroups/{rgName}/providers/Microsoft.MachineLearningServices/{resourceType}/{resourceName}/privateEndpointConnections/{peConnectionName}
   */
  id?: string;

  /**
   * Same as workspace location.
   */
  @visibility("read", "create")
  location?: string;

  /**
   * Properties of the Private Endpoint Connection
   */
  properties?: RegistryPrivateEndpointConnectionProperties;
}

/**
 * Properties of the Private Endpoint Connection
 */
model RegistryPrivateEndpointConnectionProperties {
  /**
   * The group ids
   */
  groupIds?: string[];

  /**
   * The PE network resource that is linked to this PE connection.
   */
  privateEndpoint?: PrivateEndpointResource;

  /**
   * The connection state.
   */
  privateLinkServiceConnectionState?: RegistryPrivateLinkServiceConnectionState;

  /**
   * One of null, "Succeeded", "Provisioning", "Failed". While not approved, it's null.
   */
  provisioningState?: string;
}

/**
 * The PE network resource that is linked to this PE connection.
 */
model PrivateEndpointResource extends PrivateEndpoint {
  /**
   * The subnetId that the private endpoint is connected to.
   */
  subnetArmId?: string;
}

/**
 * The Private Endpoint resource.
 */
model PrivateEndpoint {
  /**
   * The ARM identifier for Private Endpoint
   */
  @visibility("read")
  id?: string;
}

/**
 * The connection state.
 */
model RegistryPrivateLinkServiceConnectionState {
  /**
   * Some RP chose "None". Other RPs use this for region expansion.
   */
  actionsRequired?: string;

  /**
   * User-defined message that, per NRP doc, may be used for approval-related message.
   */
  description?: string;

  /**
   * Connection status of the service consumer with the service provider
   */
  status?: EndpointServiceConnectionStatus;
}

/**
 * Details for each region the registry is in
 */
model RegistryRegionArmDetails {
  /**
   * List of ACR accounts
   */
  acrDetails?: AcrDetails[];

  /**
   * The location where the registry exists
   */
  location?: string;

  /**
   * List of storage accounts
   */
  storageAccountDetails?: StorageAccountDetails[];
}

/**
 * Details of ACR account to be used for the Registry
 */
model AcrDetails {
  /**
   * Details of system created ACR account to be used for the Registry
   */
  systemCreatedAcrAccount?: SystemCreatedAcrAccount;

  /**
   * Details of user created ACR account to be used for the Registry. Not supported in most cases and will throw 400 error if provided.
   */
  userCreatedAcrAccount?: UserCreatedAcrAccount;
}

model SystemCreatedAcrAccount {
  /**
   * Name of the ACR account
   */
  acrAccountName?: string;

  /**
   * SKU of the ACR account
   */
  acrAccountSku?: string;

  /**
   * This is populated once the ACR account is created.
   */
  armResourceId?: ArmResourceId;
}

model UserCreatedAcrAccount {
  /**
   * ARM ResourceId of a resource
   */
  armResourceId?: ArmResourceId;
}

/**
 * Details of storage account to be used for the Registry
 */
model StorageAccountDetails {
  /**
   * Details of system created storage account to be used for the registry
   */
  systemCreatedStorageAccount?: SystemCreatedStorageAccount;

  /**
   * Details of user created storage account to be used for the registry.  Not supported in most cases and will throw 400 error if provided.
   */
  userCreatedStorageAccount?: UserCreatedStorageAccount;
}

model SystemCreatedStorageAccount {
  /**
   * Public blob access allowed
   */
  allowBlobPublicAccess?: boolean;

  /**
   * This is populated once the storage account is created.
   */
  armResourceId?: ArmResourceId;

  /**
   * HNS enabled for storage account
   */
  storageAccountHnsEnabled?: boolean;

  /**
   * Name of the storage account
   */
  storageAccountName?: string;

  /**
   * Allowed values:
   * "Standard_LRS",
   * "Standard_GRS",
   * "Standard_RAGRS",
   * "Standard_ZRS",
   * "Standard_GZRS",
   * "Standard_RAGZRS",
   * "Premium_LRS",
   * "Premium_ZRS"
   */
  storageAccountType?: string;
}

model UserCreatedStorageAccount {
  /**
   * ARM ResourceId of a resource
   */
  armResourceId?: ArmResourceId;
}

/**
 * Strictly used in update requests.
 */
model PartialRegistryPartialTrackedResource {
  /**
   * Managed service identity (system assigned and/or user assigned identities)
   */
  identity?: RegistryPartialManagedServiceIdentity;

  /**
   * Sku details required for ARM contract for Autoscaling.
   */
  sku?: PartialSku;

  /**
   * Resource tags.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Managed service identity (system assigned and/or user assigned identities)
 */
model RegistryPartialManagedServiceIdentity extends ManagedServiceIdentity {}

/**
 * The List Aml user feature operation response.
 */
model ListAmlUserFeatureResult is Azure.Core.Page<AmlUserFeature>;

/**
 * Features enabled for a workspace
 */
model AmlUserFeature {
  /**
   * Specifies the feature ID
   */
  id?: string;

  /**
   * Specifies the feature name
   */
  displayName?: string;

  /**
   * Describes the feature for user experience
   */
  description?: string;
}

/**
 * Azure Machine Learning team account REST API operation
 */
model AmlOperation {
  /**
   * Gets or sets display name of operation
   */
  display?: OperationDisplay;

  /**
   * Indicates whether the operation applies to data-plane
   */
  isDataAction?: boolean;

  /**
   * Gets or sets operation name: {provider}/{resource}/{operation}
   */
  name?: string;

  /**
   * The intended executor of the operation: user/system
   */
  origin?: string;
}

/**
 * The properties of a machine learning workspace.
 */
model WorkspaceProperties {
  /**
   * The flag to indicate whether to allow public access when behind VNet.
   */
  allowPublicAccessWhenBehindVnet?: boolean;

  /**
   * ARM id of the application insights associated with this workspace.
   */
  applicationInsights?: string;

  associatedWorkspaces?: string[];
  containerRegistries?: string[];

  /**
   * ARM id of the container registry associated with this workspace.
   */
  containerRegistry?: string;

  /**
   * The description of this workspace.
   */
  description?: string;

  /**
   * Url for the discovery service to identify regional endpoints for machine learning experimentation services
   */
  discoveryUrl?: string;

  enableDataIsolation?: boolean;
  encryption?: EncryptionProperty;
  existingWorkspaces?: string[];

  /**
   * Settings for feature store type workspace.
   */
  featureStoreSettings?: FeatureStoreSettings;

  /**
   * The friendly name for this workspace. This name in mutable
   */
  friendlyName?: string;

  /**
   * The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service
   */
  hbiWorkspace?: boolean;

  hubResourceId?: string;

  /**
   * The compute name for image build
   */
  imageBuildCompute?: string;

  /**
   * ARM id of the key vault associated with this workspace. This cannot be changed once the workspace has been created
   */
  keyVault?: string;

  keyVaults?: string[];

  /**
   * Managed Network settings for a machine learning workspace.
   */
  managedNetwork?: ManagedNetworkSettings;

  /**
   * The URI associated with this workspace that machine learning flow must point at to set up tracking.
   */
  @visibility("read")
  mlFlowTrackingUri?: string;

  /**
   * The notebook info of Azure ML workspace.
   */
  @visibility("read")
  notebookInfo?: NotebookResourceInfo;

  /**
   * The user assigned identity resource id that represents the workspace identity.
   */
  primaryUserAssignedIdentity?: string;

  /**
   * The list of private endpoint connections in the workspace.
   */
  @visibility("read")
  privateEndpointConnections?: PrivateEndpointConnection[];

  /**
   * Count of private connections in the workspace
   */
  @visibility("read")
  privateLinkCount?: int32;

  /**
   * The current deployment state of workspace resource. The provisioningState is to indicate states for resource provisioning.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * Whether requests from Public Network are allowed.
   */
  publicNetworkAccess?: PublicNetworkAccessType;

  /**
   * The service managed resource settings.
   */
  serviceManagedResourcesSettings?: ServiceManagedResourcesSettings;

  /**
   * The name of the managed resource group created by workspace RP in customer subscription if the workspace is CMK workspace
   */
  @visibility("read")
  serviceProvisionedResourceGroup?: string;

  /**
   * The list of shared private link resources in this workspace.
   */
  sharedPrivateLinkResources?: SharedPrivateLinkResource[];

  /**
   * Retention time in days after workspace get soft deleted.
   */
  softDeleteRetentionInDays?: int32;

  /**
   * ARM id of the storage account associated with this workspace. This cannot be changed once the workspace has been created
   */
  storageAccount?: string;

  storageAccounts?: string[];

  /**
   * If the storage associated with the workspace has hierarchical namespace(HNS) enabled.
   */
  @visibility("read")
  storageHnsEnabled?: boolean;

  /**
   * The auth mode used for accessing the system datastores of the workspace.
   */
  systemDatastoresAuthMode?: string;

  /**
   * The tenant id associated with this workspace.
   */
  @visibility("read")
  tenantId?: string;

  /**
   * Enabling v1_legacy_mode may prevent you from using features provided by the v2 API.
   */
  v1LegacyMode?: boolean;

  /**
   * WorkspaceHub's configuration object.
   */
  workspaceHubConfig?: WorkspaceHubConfig;

  /**
   * The immutable id associated with this workspace.
   */
  @visibility("read")
  workspaceId?: string;
}

model EncryptionProperty {
  /**
   * The byok cosmosdb account that customer brings to store customer's data
   * with encryption
   */
  cosmosDbResourceId?: string;

  /**
   * Identity to be used with the keyVault
   */
  identity?: IdentityForCmk;

  /**
   * KeyVault details to do the encryption
   */
  keyVaultProperties: KeyVaultProperties;

  /**
   * The byok search account that customer brings to store customer's data
   * with encryption
   */
  searchAccountResourceId?: string;

  /**
   * Indicates whether or not the encryption is enabled for the workspace.
   */
  status: EncryptionStatus;

  /**
   * The byok storage account that customer brings to store customer's data
   * with encryption
   */
  storageAccountResourceId?: string;
}

/**
 * Identity object used for encryption.
 */
model IdentityForCmk {
  /**
   * UserAssignedIdentity to be used to fetch the encryption key from keyVault
   */
  userAssignedIdentity?: string;
}

/**
 * Customer Key vault properties.
 */
model KeyVaultProperties {
  /**
   * Currently, we support only SystemAssigned MSI.
   * We need this when we support UserAssignedIdentities
   */
  identityClientId?: string;

  /**
   * KeyVault key identifier to encrypt the data
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  keyIdentifier: string;

  /**
   * KeyVault Arm Id that contains the data encryption key
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  keyVaultArmId: string;
}

model FeatureStoreSettings {
  computeRuntime?: ComputeRuntimeDto;
  offlineStoreConnectionName?: string;
  onlineStoreConnectionName?: string;
}

model ComputeRuntimeDto {
  sparkRuntimeVersion?: string;
}

/**
 * Managed Network settings for a machine learning workspace.
 */
model ManagedNetworkSettings {
  /**
   * Isolation mode for the managed network of a machine learning workspace.
   */
  isolationMode?: IsolationMode;

  @visibility("read")
  networkId?: string;

  /**
   * Dictionary of <OutboundRule>
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  outboundRules?: Record<OutboundRule>;

  /**
   * Status of the Provisioning for the managed network of a machine learning workspace.
   */
  status?: ManagedNetworkProvisionStatus;
}

/**
 * Outbound Rule for the managed network of a machine learning workspace.
 */
@discriminator("type")
model OutboundRule {
  /**
   * Category of a managed network Outbound Rule of a machine learning workspace.
   */
  category?: RuleCategory;

  /**
   * Type of a managed network Outbound Rule of a machine learning workspace.
   */
  status?: RuleStatus;
}

/**
 * Status of the Provisioning for the managed network of a machine learning workspace.
 */
model ManagedNetworkProvisionStatus {
  sparkReady?: boolean;

  /**
   * Status for the managed network of a machine learning workspace.
   */
  status?: ManagedNetworkStatus;
}

model NotebookResourceInfo {
  fqdn?: string;
  isPrivateLinkEnabled?: boolean;

  /**
   * The error that occurs when preparing notebook.
   */
  notebookPreparationError?: NotebookPreparationError;

  /**
   * the data plane resourceId that used to initialize notebook component
   */
  resourceId?: string;
}

model NotebookPreparationError {
  errorMessage?: string;
  statusCode?: int32;
}

/**
 * Private endpoint connection properties.
 */
model PrivateEndpointConnectionProperties {
  /**
   * The Private Endpoint resource.
   */
  privateEndpoint?: WorkspacePrivateEndpointResource;

  /**
   * The connection state.
   */
  privateLinkServiceConnectionState?: PrivateLinkServiceConnectionState;

  /**
   * The current provisioning state.
   */
  @visibility("read")
  provisioningState?: PrivateEndpointConnectionProvisioningState;
}

/**
 * The Private Endpoint resource.
 */
model WorkspacePrivateEndpointResource {
  /**
   * e.g. /subscriptions/{networkSubscriptionId}/resourceGroups/{rgName}/providers/Microsoft.Network/privateEndpoints/{privateEndpointName}
   */
  @visibility("read")
  id?: string;

  /**
   * The subnetId that the private endpoint is connected to.
   */
  @visibility("read")
  subnetArmId?: string;
}

/**
 * A collection of information about the state of the connection between service consumer and provider.
 */
model PrivateLinkServiceConnectionState {
  /**
   * Some RP chose "None". Other RPs use this for region expansion.
   */
  actionsRequired?: string;

  /**
   * User-defined message that, per NRP doc, may be used for approval-related message.
   */
  description?: string;

  /**
   * Connection status of the service consumer with the service provider
   */
  status?: EndpointServiceConnectionStatus;
}

model ServiceManagedResourcesSettings {
  cosmosDb?: CosmosDbSettings;
}

model CosmosDbSettings {
  collectionsThroughput?: int32;
}

model SharedPrivateLinkResource {
  /**
   * Unique name of the private link
   */
  name?: string;

  /**
   * Properties of a shared private link resource.
   */
  properties?: SharedPrivateLinkResourceProperty;
}

/**
 * Properties of a shared private link resource.
 */
model SharedPrivateLinkResourceProperty {
  /**
   * group id of the private link
   */
  groupId?: string;

  /**
   * the resource id that private link links to
   */
  privateLinkResourceId?: string;

  /**
   * Request message
   */
  requestMessage?: string;

  /**
   * Connection status of the service consumer with the service provider
   */
  status?: EndpointServiceConnectionStatus;
}

/**
 * WorkspaceHub's configuration object.
 */
model WorkspaceHubConfig {
  additionalWorkspaceStorageAccounts?: string[];
  defaultWorkspaceResourceGroup?: string;
}

/**
 * The parameters for updating a machine learning workspace.
 */
model WorkspaceUpdateParameters {
  /**
   * Managed service identity (system assigned and/or user assigned identities)
   */
  identity?: Azure.ResourceManager.Foundations.ManagedServiceIdentity;

  /**
   * The properties that the machine learning workspace will be updated with.
   */
  properties?: WorkspacePropertiesUpdateParameters;

  /**
   * Optional. This field is required to be implemented by the RP because AML is supporting more than one tier
   */
  sku?: Sku;

  /**
   * The resource tags for the machine learning workspace.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * The parameters for updating a machine learning workspace.
 */
model WorkspacePropertiesUpdateParameters {
  /**
   * ARM id of the application insights associated with this workspace.
   */
  applicationInsights?: string;

  /**
   * ARM id of the container registry associated with this workspace.
   */
  containerRegistry?: string;

  /**
   * The description of this workspace.
   */
  description?: string;

  enableDataIsolation?: boolean;
  encryption?: EncryptionUpdateProperties;

  /**
   * Settings for feature store type workspace.
   */
  featureStoreSettings?: FeatureStoreSettings;

  /**
   * The friendly name for this workspace. This name in mutable
   */
  friendlyName?: string;

  /**
   * The compute name for image build
   */
  imageBuildCompute?: string;

  /**
   * Managed Network settings for a machine learning workspace.
   */
  managedNetwork?: ManagedNetworkSettings;

  /**
   * The user assigned identity resource id that represents the workspace identity.
   */
  primaryUserAssignedIdentity?: string;

  /**
   * Whether requests from Public Network are allowed.
   */
  publicNetworkAccess?: PublicNetworkAccessType;

  /**
   * The service managed resource settings.
   */
  serviceManagedResourcesSettings?: ServiceManagedResourcesSettings;

  /**
   * Retention time in days after workspace get soft deleted.
   */
  softDeleteRetentionInDays?: int32;

  /**
   * Enabling v1_legacy_mode may prevent you from using features provided by the v2 API.
   */
  v1LegacyMode?: boolean;
}

model EncryptionUpdateProperties {
  keyVaultProperties: EncryptionKeyVaultUpdateProperties;
}

model EncryptionKeyVaultUpdateProperties {
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  keyIdentifier: string;
}

@discriminator("authType")
model WorkspaceConnectionPropertiesV2 {
  /**
   * Category of the connection
   */
  category?: ConnectionCategory;

  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryTime?: utcDateTime;

  /**
   * Any object
   */
  metadata?: Record<unknown>;

  target?: string;
}

/**
 * The properties that the machine learning workspace connection will be updated with.
 */
model WorkspaceConnectionUpdateParameter {
  /**
   * The properties that the machine learning workspace connection will be updated with.
   */
  properties?: WorkspaceConnectionPropertiesV2;
}

/**
 * Parameters to diagnose a workspace
 */
model DiagnoseWorkspaceParameters {
  value?: DiagnoseRequestProperties;
}

model DiagnoseRequestProperties {
  /**
   * Setting for diagnosing dependent application insights
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  applicationInsights?: Record<unknown>;

  /**
   * Setting for diagnosing dependent container registry
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  containerRegistry?: Record<unknown>;

  /**
   * Setting for diagnosing dns resolution
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  dnsResolution?: Record<unknown>;

  /**
   * Setting for diagnosing dependent key vault
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  keyVault?: Record<unknown>;

  /**
   * Setting for diagnosing network security group
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  nsg?: Record<unknown>;

  /**
   * Setting for diagnosing unclassified category of problems
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  others?: Record<unknown>;

  /**
   * Setting for diagnosing resource lock
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  resourceLock?: Record<unknown>;

  /**
   * Setting for diagnosing dependent storage account
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  storageAccount?: Record<unknown>;

  /**
   * Setting for diagnosing user defined routing
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  udr?: Record<unknown>;
}

model DiagnoseResponseResult {
  value?: DiagnoseResponseResultValue;
}

model DiagnoseResponseResultValue {
  userDefinedRouteResults?: DiagnoseResult[];
  networkSecurityRuleResults?: DiagnoseResult[];
  resourceLockResults?: DiagnoseResult[];
  dnsResolutionResults?: DiagnoseResult[];
  storageAccountResults?: DiagnoseResult[];
  keyVaultResults?: DiagnoseResult[];
  containerRegistryResults?: DiagnoseResult[];
  applicationInsightsResults?: DiagnoseResult[];
  otherResults?: DiagnoseResult[];
}

/**
 * Result of Diagnose
 */
model DiagnoseResult {
  /**
   * Code for workspace setup error
   */
  @visibility("read")
  code?: string;

  /**
   * Level of workspace setup error
   */
  @visibility("read")
  level?: DiagnoseResultLevel;

  /**
   * Message of workspace setup error
   */
  @visibility("read")
  message?: string;
}

model ListWorkspaceKeysResult {
  /**
   * The access key of the workspace app insights
   */
  @visibility("read")
  appInsightsInstrumentationKey?: string;

  containerRegistryCredentials?: RegistryListCredentialsResult;
  notebookAccessKeys?: ListNotebookKeysResult;

  /**
   * The arm Id key of the workspace storage
   */
  @visibility("read")
  userStorageArmId?: string;

  /**
   * The access key of the workspace storage
   */
  @visibility("read")
  userStorageKey?: string;
}

model RegistryListCredentialsResult {
  /**
   * The location of the workspace ACR
   */
  @visibility("read")
  location?: string;

  passwords?: Password[];

  /**
   * The username of the workspace ACR
   */
  @visibility("read")
  username?: string;
}

model Password {
  @visibility("read")
  name?: string;

  @visibility("read")
  value?: string;
}

model ListNotebookKeysResult {
  /**
   * The primary access key of the Notebook
   */
  @visibility("read")
  primaryAccessKey?: string;

  /**
   * The secondary access key of the Notebook
   */
  @visibility("read")
  secondaryAccessKey?: string;
}

model NotebookAccessTokenResult {
  @visibility("read")
  accessToken?: string;

  @visibility("read")
  expiresIn?: int32;

  @visibility("read")
  hostName?: string;

  @visibility("read")
  notebookResourceId?: string;

  @visibility("read")
  publicDns?: string;

  @visibility("read")
  refreshToken?: string;

  @visibility("read")
  scope?: string;

  @visibility("read")
  tokenType?: string;
}

model ListStorageAccountKeysResult {
  /**
   * The access key of the storage
   */
  @visibility("read")
  userStorageKey?: string;
}

model ExternalFqdnResponse {
  value?: FqdnEndpointsPropertyBag[];
}

/**
 * Property bag for FQDN endpoints result
 */
model FqdnEndpointsPropertyBag {
  properties?: FqdnEndpoints;
}

model FqdnEndpoints {
  category?: string;
  endpoints?: FqdnEndpoint[];
}

model FqdnEndpoint {
  domainName?: string;
  endpointDetails?: FqdnEndpointDetail[];
}

model FqdnEndpointDetail {
  port?: int32;
}

/**
 * A list of private link resources
 */
@pagedResult
model PrivateLinkResourceListResult {
  @items
  value?: PrivateLinkResource[];
}

/**
 * A private link resource
 */
model PrivateLinkResource extends Resource {
  /**
   * Managed service identity (system assigned and/or user assigned identities)
   */
  identity?: Azure.ResourceManager.Foundations.ManagedServiceIdentity;

  /**
   * Same as workspace location.
   */
  location?: string;

  /**
   * Properties of a private link resource.
   */
  properties?: PrivateLinkResourceProperties;

  /**
   * Optional. This field is required to be implemented by the RP because AML is supporting more than one tier
   */
  sku?: Sku;

  /**
   * Dictionary of <string>
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;
}

/**
 * Properties of a private link resource.
 */
model PrivateLinkResourceProperties {
  /**
   * The private link resource group id.
   */
  @visibility("read")
  groupId?: string;

  /**
   * The private link resource required member names.
   */
  @visibility("read")
  requiredMembers?: string[];

  /**
   * The private link resource Private link DNS zone name.
   */
  requiredZoneNames?: string[];
}

/**
 * Managed Network Provisioning options for managed network of a machine learning workspace.
 */
model ManagedNetworkProvisionOptions {
  includeSpark?: boolean;
}

/**
 * Represents a resource ID. For example, for a subnet, it is the resource URL for the subnet.
 */
model ResourceId {
  /**
   * The ID of the resource
   */
  id: string;
}

/**
 * A Machine Learning compute based on AKS.
 */
model AKS extends Compute {
  ...AKSSchema;

  /**
   * The type of compute
   */
  computeType: "AKS";
}

model AKSSchema {
  /**
   * AKS properties
   */
  properties?: AKSSchemaProperties;
}

/**
 * AKS properties
 */
model AKSSchemaProperties {
  /**
   * Cluster full qualified domain name
   */
  clusterFqdn?: string;

  /**
   * System services
   */
  @visibility("read")
  systemServices?: SystemService[];

  /**
   * Number of agents
   */
  agentCount?: int32;

  /**
   * Agent virtual machine size
   */
  agentVmSize?: string;

  /**
   * Intended usage of the cluster
   */
  clusterPurpose?: ClusterPurpose = ClusterPurpose.FastProd;

  /**
   * SSL configuration
   */
  sslConfiguration?: SslConfiguration;

  /**
   * AKS networking configuration for vnet
   */
  aksNetworkingConfiguration?: AksNetworkingConfiguration;

  /**
   * Load Balancer Type
   */
  loadBalancerType?: LoadBalancerType = LoadBalancerType.PublicIp;

  /**
   * Load Balancer Subnet
   */
  loadBalancerSubnet?: string;
}

/**
 * A system service running on a compute.
 */
model SystemService {
  /**
   * The type of this system service.
   */
  @visibility("read")
  systemServiceType?: string;

  /**
   * Public IP address
   */
  @visibility("read")
  publicIpAddress?: string;

  /**
   * The version for this type.
   */
  @visibility("read")
  version?: string;
}

/**
 * The ssl configuration for scoring
 */
model SslConfiguration {
  /**
   * Enable or disable ssl for scoring
   */
  status?: SslConfigStatus;

  /**
   * Cert data
   */
  cert?: string;

  /**
   * Key data
   */
  key?: string;

  /**
   * CNAME of the cert
   */
  cname?: string;

  /**
   * Leaf domain label of public endpoint
   */
  leafDomainLabel?: string;

  /**
   * Indicates whether to overwrite existing domain label.
   */
  overwriteExistingDomain?: boolean;
}

/**
 * Advance configuration for AKS networking
 */
model AksNetworkingConfiguration {
  /**
   * Virtual network subnet resource ID the compute nodes belong to
   */
  subnetId?: string;

  /**
   * A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.
   */
  @pattern("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$")
  serviceCidr?: string;

  /**
   * An IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.
   */
  @pattern("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$")
  dnsServiceIP?: string;

  /**
   * A CIDR notation IP range assigned to the Docker bridge network. It must not overlap with any Subnet IP ranges or the Kubernetes service address range.
   */
  @pattern("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$")
  dockerBridgeCidr?: string;
}

/**
 * A Machine Learning compute based on Kubernetes Compute.
 */
model Kubernetes extends Compute {
  ...KubernetesSchema;

  /**
   * The type of compute
   */
  computeType: "Kubernetes";
}

/**
 * Kubernetes Compute Schema
 */
model KubernetesSchema {
  /**
   * Properties of Kubernetes
   */
  properties?: KubernetesProperties;
}

/**
 * Kubernetes properties
 */
model KubernetesProperties {
  /**
   * Relay connection string.
   */
  relayConnectionString?: string;

  /**
   * ServiceBus connection string.
   */
  serviceBusConnectionString?: string;

  /**
   * Extension principal-id.
   */
  extensionPrincipalId?: string;

  /**
   * Extension instance release train.
   */
  extensionInstanceReleaseTrain?: string;

  /**
   * VC name.
   */
  vcName?: string;

  /**
   * Compute namespace
   */
  `namespace`?: string = "default";

  /**
   * Default instance type
   */
  defaultInstanceType?: string;

  /**
   * Instance Type Schema
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  instanceTypes?: Record<InstanceTypeSchema>;
}

/**
 * Instance type schema.
 */
model InstanceTypeSchema {
  /**
   * Node Selector
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  nodeSelector?: Record<string>;

  /**
   * Resource requests/limits for this instance type
   */
  resources?: InstanceTypeSchemaResources;
}

/**
 * Resource requests/limits for this instance type
 */
model InstanceTypeSchemaResources {
  /**
   * Resource requests for this instance type
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  requests?: Record<string>;

  /**
   * Resource limits for this instance type
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  limits?: Record<string>;
}

/**
 * AML Compute properties
 */
model AmlComputeProperties {
  /**
   * Compute OS Type
   */
  osType?: OsType = OsType.Linux;

  /**
   * Virtual Machine Size
   */
  vmSize?: string;

  /**
   * Virtual Machine priority
   */
  vmPriority?: VmPriority;

  /**
   * Virtual Machine image for AML Compute - windows only
   */
  virtualMachineImage?: VirtualMachineImage;

  /**
   * Network is isolated or not
   */
  isolatedNetwork?: boolean;

  /**
   * Scale settings for AML Compute
   */
  scaleSettings?: ScaleSettings;

  /**
   * Credentials for an administrator user account that will be created on each compute node.
   */
  userAccountCredentials?: UserAccountCredentials;

  /**
   * Virtual network subnet resource ID the compute nodes belong to.
   */
  subnet?: ResourceId;

  /**
   * State of the public SSH port. Possible values are: Disabled - Indicates that the public ssh port is closed on all nodes of the cluster. Enabled - Indicates that the public ssh port is open on all nodes of the cluster. NotSpecified - Indicates that the public ssh port is closed on all nodes of the cluster if VNet is defined, else is open all public nodes. It can be default only during cluster creation time, after creation it will be either enabled or disabled.
   */
  remoteLoginPortPublicAccess?: RemoteLoginPortPublicAccess = RemoteLoginPortPublicAccess.NotSpecified;

  /**
   * Allocation state of the compute. Possible values are: steady - Indicates that the compute is not resizing. There are no changes to the number of compute nodes in the compute in progress. A compute enters this state when it is created and when no operations are being performed on the compute to change the number of compute nodes. resizing - Indicates that the compute is resizing; that is, compute nodes are being added to or removed from the compute.
   */
  @visibility("read")
  allocationState?: AllocationState;

  /**
   * The time at which the compute entered its current allocation state.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  allocationStateTransitionTime?: utcDateTime;

  /**
   * Collection of errors encountered by various compute nodes during node setup.
   */
  @visibility("read")
  errors?: ErrorResponse[];

  /**
   * The number of compute nodes currently assigned to the compute.
   */
  @visibility("read")
  currentNodeCount?: int32;

  /**
   * The target number of compute nodes for the compute. If the allocationState is resizing, this property denotes the target node count for the ongoing resize operation. If the allocationState is steady, this property denotes the target node count for the previous resize operation.
   */
  @visibility("read")
  targetNodeCount?: int32;

  /**
   * Counts of various node states on the compute.
   */
  @visibility("read")
  nodeStateCounts?: NodeStateCounts;

  /**
   * Enable or disable node public IP address provisioning. Possible values are: Possible values are: true - Indicates that the compute nodes will have public IPs provisioned. false - Indicates that the compute nodes will have a private endpoint and no public IPs.
   */
  enableNodePublicIp?: boolean = true;

  /**
   * A property bag containing additional properties.
   */
  propertyBag?: Record<unknown>;
}

/**
 * Virtual Machine image for Windows AML Compute
 */
model VirtualMachineImage {
  /**
   * Virtual Machine image path
   */
  id: string;
}

/**
 * Settings for user account that gets created on each on the nodes of a compute.
 */
model UserAccountCredentials {
  /**
   * Name of the administrator user account which can be used to SSH to nodes.
   */
  adminUserName: string;

  /**
   * SSH public key of the administrator user account.
   */
  adminUserSshPublicKey?: string;

  /**
   * Password of the administrator user account.
   */
  adminUserPassword?: string;
}

/**
 * Counts of various compute node states on the amlCompute.
 */
model NodeStateCounts {
  /**
   * Number of compute nodes in idle state.
   */
  @visibility("read")
  idleNodeCount?: int32;

  /**
   * Number of compute nodes which are running jobs.
   */
  @visibility("read")
  runningNodeCount?: int32;

  /**
   * Number of compute nodes which are being prepared.
   */
  @visibility("read")
  preparingNodeCount?: int32;

  /**
   * Number of compute nodes which are in unusable state.
   */
  @visibility("read")
  unusableNodeCount?: int32;

  /**
   * Number of compute nodes which are leaving the amlCompute.
   */
  @visibility("read")
  leavingNodeCount?: int32;

  /**
   * Number of compute nodes which are in preempted state.
   */
  @visibility("read")
  preemptedNodeCount?: int32;
}

/**
 * An Azure Machine Learning compute.
 */
model AmlCompute extends Compute {
  ...AmlComputeSchema;

  /**
   * The type of compute
   */
  computeType: "AmlCompute";
}

/**
 * Properties(top level) of AmlCompute
 */
model AmlComputeSchema {
  /**
   * Properties of AmlCompute
   */
  properties?: AmlComputeProperties;
}

/**
 * Compute Instance properties
 */
model ComputeInstanceProperties {
  /**
   * Virtual Machine Size
   */
  vmSize?: string;

  /**
   * Virtual network subnet resource ID the compute nodes belong to.
   */
  subnet?: ResourceId;

  /**
   * Policy for sharing applications on this compute instance among users of parent workspace. If Personal, only the creator can access applications on this compute instance. When Shared, any workspace user can access applications on this instance depending on his/her assigned role.
   */
  applicationSharingPolicy?: ApplicationSharingPolicy = ApplicationSharingPolicy.Shared;

  /**
   * Specifies settings for autologger.
   */
  autologgerSettings?: ComputeInstanceAutologgerSettings;

  /**
   * Specifies policy and settings for SSH access.
   */
  sshSettings?: ComputeInstanceSshSettings;

  /**
   * List of Custom Services added to the compute.
   */
  customServices?: CustomService[];

  /**
   * Returns metadata about the operating system image for this compute instance.
   */
  @visibility("read")
  osImageMetadata?: ImageMetadata;

  /**
   * Describes all connectivity endpoints available for this ComputeInstance.
   */
  @visibility("read")
  connectivityEndpoints?: ComputeInstanceConnectivityEndpoints;

  /**
   * Describes available applications and their endpoints on this ComputeInstance.
   */
  @visibility("read")
  applications?: ComputeInstanceApplication[];

  /**
   * Describes information on user who created this ComputeInstance.
   */
  @visibility("read")
  createdBy?: ComputeInstanceCreatedBy;

  /**
   * Collection of errors encountered on this ComputeInstance.
   */
  @visibility("read")
  errors?: ErrorResponse[];

  /**
   * The current state of this ComputeInstance.
   */
  @visibility("read")
  state?: ComputeInstanceState;

  /**
   * The Compute Instance Authorization type. Available values are personal (default).
   */
  computeInstanceAuthorizationType?: ComputeInstanceAuthorizationType = ComputeInstanceAuthorizationType.personal;

  /**
   * Settings for a personal compute instance.
   */
  personalComputeInstanceSettings?: PersonalComputeInstanceSettings;

  /**
   * Details of customized scripts to execute for setting up the cluster.
   */
  setupScripts?: SetupScripts;

  /**
   * The last operation on ComputeInstance.
   */
  @visibility("read")
  lastOperation?: ComputeInstanceLastOperation;

  /**
   * The list of schedules to be applied on the computes.
   */
  schedules?: ComputeSchedules;

  /**
   * Stops compute instance after user defined period of inactivity. Time is defined in ISO8601 format. Minimum is 15 min, maximum is 3 days.
   */
  idleTimeBeforeShutdown?: string;

  /**
   * Enable or disable node public IP address provisioning. Possible values are: Possible values are: true - Indicates that the compute nodes will have public IPs provisioned. false - Indicates that the compute nodes will have a private endpoint and no public IPs.
   */
  enableNodePublicIp?: boolean = true;

  /**
   * Describes informations of containers on this ComputeInstance.
   */
  @visibility("read")
  containers?: ComputeInstanceContainer[];

  /**
   * Describes informations of dataDisks on this ComputeInstance.
   */
  @visibility("read")
  dataDisks?: ComputeInstanceDataDisk[];

  /**
   * Describes informations of dataMounts on this ComputeInstance.
   */
  @visibility("read")
  dataMounts?: ComputeInstanceDataMount[];

  /**
   * ComputeInstance version.
   */
  @visibility("read")
  versions?: ComputeInstanceVersion;
}

/**
 * Specifies settings for autologger.
 */
model ComputeInstanceAutologgerSettings {
  /**
   * Indicates whether mlflow autologger is enabled for notebooks.
   */
  mlflowAutologger?: MlflowAutologger;
}

/**
 * Specifies policy and settings for SSH access.
 */
model ComputeInstanceSshSettings {
  /**
   * State of the public SSH port. Possible values are: Disabled - Indicates that the public ssh port is closed on this instance. Enabled - Indicates that the public ssh port is open and accessible according to the VNet/subnet policy if applicable.
   */
  sshPublicAccess?: SshPublicAccess = SshPublicAccess.Disabled;

  /**
   * Describes the admin user name.
   */
  @visibility("read")
  adminUserName?: string;

  /**
   * Describes the port for connecting through SSH.
   */
  @visibility("read")
  sshPort?: int32;

  /**
   * Specifies the SSH rsa public key file as a string. Use "ssh-keygen -t rsa -b 2048" to generate your SSH key pairs.
   */
  adminPublicKey?: string;
}

/**
 * Returns metadata about the operating system image for this compute instance.
 */
model ImageMetadata {
  /**
   * Specifies the current operating system image version this compute instance is running on.
   */
  currentImageVersion?: string;

  /**
   * Specifies the latest available operating system image version.
   */
  latestImageVersion?: string;

  /**
   * Specifies whether this compute instance is running on the latest operating system image.
   */
  isLatestOsImageVersion?: boolean;
}

/**
 * Defines all connectivity endpoints and properties for an ComputeInstance.
 */
model ComputeInstanceConnectivityEndpoints {
  /**
   * Public IP Address of this ComputeInstance.
   */
  @visibility("read")
  publicIpAddress?: string;

  /**
   * Private IP Address of this ComputeInstance (local to the VNET in which the compute instance is deployed).
   */
  @visibility("read")
  privateIpAddress?: string;
}

/**
 * Defines an Aml Instance application and its connectivity endpoint URI.
 */
model ComputeInstanceApplication {
  /**
   * Name of the ComputeInstance application.
   */
  displayName?: string;

  /**
   * Application' endpoint URI.
   */
  endpointUri?: string;
}

/**
 * Describes information on user who created this ComputeInstance.
 */
model ComputeInstanceCreatedBy {
  /**
   * Name of the user.
   */
  @visibility("read")
  userName?: string;

  /**
   * Uniquely identifies user' Azure Active Directory organization.
   */
  @visibility("read")
  userOrgId?: string;

  /**
   * Uniquely identifies the user within his/her organization.
   */
  @visibility("read")
  userId?: string;
}

/**
 * Settings for a personal compute instance.
 */
model PersonalComputeInstanceSettings {
  /**
   * A user explicitly assigned to a personal compute instance.
   */
  assignedUser?: AssignedUser;
}

/**
 * A user that can be assigned to a compute instance.
 */
model AssignedUser {
  /**
   * User’s AAD Object Id.
   */
  objectId: string;

  /**
   * User’s AAD Tenant Id.
   */
  tenantId: string;
}

/**
 * Details of customized scripts to execute for setting up the cluster.
 */
model SetupScripts {
  /**
   * Customized setup scripts
   */
  scripts?: ScriptsToExecute;
}

/**
 * Customized setup scripts
 */
model ScriptsToExecute {
  /**
   * Script that's run every time the machine starts.
   */
  startupScript?: ScriptReference;

  /**
   * Script that's run only once during provision of the compute.
   */
  creationScript?: ScriptReference;
}

/**
 * Script reference
 */
model ScriptReference {
  /**
   * The storage source of the script: inline, workspace.
   */
  scriptSource?: string;

  /**
   * The location of scripts in the mounted volume.
   */
  scriptData?: string;

  /**
   * Optional command line arguments passed to the script to run.
   */
  scriptArguments?: string;

  /**
   * Optional time period passed to timeout command.
   */
  timeout?: string;
}

/**
 * The last operation on ComputeInstance.
 */
model ComputeInstanceLastOperation {
  /**
   * Name of the last operation.
   */
  operationName?: OperationName;

  /**
   * Time of the last operation.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  operationTime?: utcDateTime;

  /**
   * Operation status.
   */
  operationStatus?: OperationStatus;

  /**
   * Trigger of operation.
   */
  operationTrigger?: OperationTrigger;
}

/**
 * The list of schedules to be applied on the computes
 */
model ComputeSchedules {
  /**
   * The list of compute start stop schedules to be applied.
   */
  computeStartStop?: ComputeStartStopSchedule[];
}

/**
 * Compute start stop schedule properties
 */
model ComputeStartStopSchedule {
  /**
   * A system assigned id for the schedule.
   */
  @visibility("read")
  id?: string;

  /**
   * The current deployment state of schedule.
   */
  @visibility("read")
  provisioningStatus?: ProvisioningStatus;

  /**
   * Is the schedule enabled or disabled?
   */
  status?: ScheduleStatus;

  /**
   * [Required] The compute power action.
   */
  action?: ComputePowerAction;

  /**
   * [Required] The schedule trigger type.
   */
  triggerType?: TriggerType;

  /**
   * Required if triggerType is Recurrence.
   */
  recurrence?: Recurrence;

  /**
   * Required if triggerType is Cron.
   */
  cron?: Cron;

  /**
   * [Deprecated] Not used any more.
   */
  schedule?: ScheduleBase;
}

/**
 * The workflow trigger recurrence for ComputeStartStop schedule type.
 */
model Recurrence {
  /**
   * [Required] The frequency to trigger schedule.
   */
  frequency?: RecurrenceFrequency;

  /**
   * [Required] Specifies schedule interval in conjunction with frequency
   */
  interval?: int32;

  /**
   * The start time in yyyy-MM-ddTHH:mm:ss format.
   */
  startTime?: string;

  /**
   * Specifies time zone in which the schedule runs.
   * TimeZone should follow Windows time zone format. Refer: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11
   */
  timeZone?: string = "UTC";

  /**
   * [Required] The recurrence schedule.
   */
  schedule?: RecurrenceSchedule;
}

/**
 * The workflow trigger cron for ComputeStartStop schedule type.
 */
model Cron {
  /**
   * The start time in yyyy-MM-ddTHH:mm:ss format.
   */
  startTime?: string;

  /**
   * Specifies time zone in which the schedule runs.
   * TimeZone should follow Windows time zone format. Refer: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11
   */
  timeZone?: string = "UTC";

  /**
   * [Required] Specifies cron expression of schedule.
   * The expression should follow NCronTab format.
   */
  expression?: string;
}

model ScheduleBase {
  /**
   * A system assigned id for the schedule.
   */
  id?: string;

  /**
   * The current deployment state of schedule.
   */
  provisioningStatus?: ScheduleProvisioningState;

  /**
   * Is the schedule enabled or disabled?
   */
  status?: ScheduleStatus;
}

/**
 * Defines an Aml Instance container.
 */
model ComputeInstanceContainer {
  /**
   * Name of the ComputeInstance container.
   */
  name?: string;

  /**
   * Auto save settings.
   */
  autosave?: Autosave;

  /**
   * Information of GPU.
   */
  gpu?: string;

  /**
   * network of this container.
   */
  network?: Network;

  /**
   * Environment information of this container.
   */
  environment?: ComputeInstanceEnvironmentInfo;

  /**
   * services of this containers.
   */
  @visibility("read")
  services?: Record<unknown>[];
}

/**
 * Environment information
 */
model ComputeInstanceEnvironmentInfo {
  /**
   * name of environment.
   */
  name?: string;

  /**
   * version of environment.
   */
  version?: string;
}

/**
 * Defines an Aml Instance DataDisk.
 */
model ComputeInstanceDataDisk {
  /**
   * Caching type of Data Disk.
   */
  caching?: Caching;

  /**
   * The initial disk size in gigabytes.
   */
  diskSizeGB?: int32;

  /**
   * The lun is used to uniquely identify each data disk. If attaching multiple disks, each should have a distinct lun.
   */
  lun?: int32;

  /**
   * type of this storage account.
   */
  storageAccountType?: StorageAccountType = StorageAccountType.Standard_LRS;
}

/**
 * Defines an Aml Instance DataMount.
 */
model ComputeInstanceDataMount {
  /**
   * Source of the ComputeInstance data mount.
   */
  source?: string;

  /**
   * Data source type.
   */
  sourceType?: SourceType;

  /**
   * name of the ComputeInstance data mount.
   */
  mountName?: string;

  /**
   * Mount Action.
   */
  mountAction?: MountAction;

  /**
   * who this data mount created by.
   */
  createdBy?: string;

  /**
   * Path of this data mount.
   */
  mountPath?: string;

  /**
   * Mount state.
   */
  mountState?: MountState;

  /**
   * The time when the disk mounted.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  mountedOn?: utcDateTime;

  /**
   * Error of this data mount.
   */
  error?: string;
}

/**
 * Version of computeInstance.
 */
model ComputeInstanceVersion {
  /**
   * Runtime of compute instance.
   */
  runtime?: string;
}

/**
 * An Azure Machine Learning compute instance.
 */
model ComputeInstance extends Compute {
  ...ComputeInstanceSchema;

  /**
   * The type of compute
   */
  computeType: "ComputeInstance";
}

/**
 * Properties(top level) of ComputeInstance
 */
model ComputeInstanceSchema {
  /**
   * Properties of ComputeInstance
   */
  properties?: ComputeInstanceProperties;
}

/**
 * A Machine Learning compute based on Azure Virtual Machines.
 */
model VirtualMachine extends Compute {
  ...VirtualMachineSchema;

  /**
   * The type of compute
   */
  computeType: "VirtualMachine";
}

model VirtualMachineSchema {
  properties?: VirtualMachineSchemaProperties;
}

model VirtualMachineSchemaProperties {
  /**
   * Virtual Machine size
   */
  virtualMachineSize?: string;

  /**
   * Port open for ssh connections.
   */
  sshPort?: int32;

  /**
   * Notebook server port open for ssh connections.
   */
  notebookServerPort?: int32;

  /**
   * Public IP address of the virtual machine.
   */
  address?: string;

  /**
   * Admin credentials for virtual machine
   */
  administratorAccount?: VirtualMachineSshCredentials;

  /**
   * Indicates whether this compute will be used for running notebooks.
   */
  isNotebookInstanceCompute?: boolean;
}

/**
 * Admin credentials for virtual machine
 */
model VirtualMachineSshCredentials {
  /**
   * Username of admin account
   */
  username?: string;

  /**
   * Password of admin account
   */
  password?: string;

  /**
   * Public key data
   */
  publicKeyData?: string;

  /**
   * Private key data
   */
  privateKeyData?: string;
}

/**
 * HDInsight compute properties
 */
model HDInsightProperties {
  /**
   * Port open for ssh connections on the master node of the cluster.
   */
  sshPort?: int32;

  /**
   * Public IP address of the master node of the cluster.
   */
  address?: string;

  /**
   * Admin credentials for master node of the cluster
   */
  administratorAccount?: VirtualMachineSshCredentials;
}

/**
 * A HDInsight compute.
 */
model HDInsight extends Compute {
  ...HDInsightSchema;

  /**
   * The type of compute
   */
  computeType: "HDInsight";
}

model HDInsightSchema {
  /**
   * HDInsight compute properties
   */
  properties?: HDInsightProperties;
}

/**
 * A DataFactory compute.
 */
model DataFactory extends Compute {
  /**
   * The type of compute
   */
  computeType: "DataFactory";
}

/**
 * Properties of Databricks
 */
model DatabricksProperties {
  /**
   * Databricks access token
   */
  databricksAccessToken?: string;

  /**
   * Workspace Url
   */
  workspaceUrl?: string;
}

/**
 * A DataFactory compute.
 */
model Databricks extends Compute {
  ...DatabricksSchema;

  /**
   * The type of compute
   */
  computeType: "Databricks";
}

model DatabricksSchema {
  /**
   * Properties of Databricks
   */
  properties?: DatabricksProperties;
}

/**
 * A DataLakeAnalytics compute.
 */
model DataLakeAnalytics extends Compute {
  ...DataLakeAnalyticsSchema;

  /**
   * The type of compute
   */
  computeType: "DataLakeAnalytics";
}

model DataLakeAnalyticsSchema {
  properties?: DataLakeAnalyticsSchemaProperties;
}

model DataLakeAnalyticsSchemaProperties {
  /**
   * DataLake Store Account Name
   */
  dataLakeStoreAccountName?: string;
}

/**
 * A SynapseSpark compute.
 */
model SynapseSpark extends Compute {
  properties?: SynapseSparkProperties;

  /**
   * The type of compute
   */
  computeType: "SynapseSpark";
}

model SynapseSparkProperties {
  /**
   * Auto scale properties.
   */
  autoScaleProperties?: AutoScaleProperties;

  /**
   * Auto pause properties.
   */
  autoPauseProperties?: AutoPauseProperties;

  /**
   * Spark version.
   */
  sparkVersion?: string;

  /**
   * The number of compute nodes currently assigned to the compute.
   */
  nodeCount?: int32;

  /**
   * Node size.
   */
  nodeSize?: string;

  /**
   * Node size family.
   */
  nodeSizeFamily?: string;

  /**
   * Azure subscription identifier.
   */
  subscriptionId?: string;

  /**
   * Name of the resource group in which workspace is located.
   */
  resourceGroup?: string;

  /**
   * Name of Azure Machine Learning workspace.
   */
  workspaceName?: string;

  /**
   * Pool name.
   */
  poolName?: string;
}

/**
 * Auto scale properties
 */
model AutoScaleProperties {
  minNodeCount?: int32;
  enabled?: boolean;
  maxNodeCount?: int32;
}

/**
 * Auto pause properties
 */
model AutoPauseProperties {
  delayInMinutes?: int32;
  enabled?: boolean;
}

/**
 * Properties of AksComputeSecrets
 */
model AksComputeSecretsProperties {
  /**
   * Content of kubeconfig file that can be used to connect to the Kubernetes cluster.
   */
  userKubeConfig?: string;

  /**
   * Content of kubeconfig file that can be used to connect to the Kubernetes cluster.
   */
  adminKubeConfig?: string;

  /**
   * Image registry pull secret.
   */
  imagePullSecretName?: string;
}

/**
 * Secrets related to a Machine Learning compute based on AKS.
 */
model AksComputeSecrets extends ComputeSecrets {
  ...AksComputeSecretsProperties;

  /**
   * The type of compute
   */
  computeType: "AKS";
}

/**
 * Secrets related to a Machine Learning compute based on AKS.
 */
model VirtualMachineSecrets extends ComputeSecrets {
  ...VirtualMachineSecretsSchema;

  /**
   * The type of compute
   */
  computeType: "VirtualMachine";
}

model VirtualMachineSecretsSchema {
  /**
   * Admin credentials for virtual machine.
   */
  administratorAccount?: VirtualMachineSshCredentials;
}

/**
 * Properties of Databricks Compute Secrets
 */
model DatabricksComputeSecretsProperties {
  /**
   * access token for databricks account.
   */
  databricksAccessToken?: string;
}

/**
 * Secrets related to a Machine Learning compute based on Databricks.
 */
model DatabricksComputeSecrets extends ComputeSecrets {
  ...DatabricksComputeSecretsProperties;

  /**
   * The type of compute
   */
  computeType: "Databricks";
}

/**
 * Account key datastore credentials configuration.
 */
model AccountKeyDatastoreCredentials extends DatastoreCredentials {
  /**
   * [Required] Storage account secrets.
   */
  @visibility("create", "update")
  secrets: AccountKeyDatastoreSecrets;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  credentialsType: "AccountKey";
}

/**
 * Datastore account key secrets.
 */
model AccountKeyDatastoreSecrets extends DatastoreSecrets {
  /**
   * Storage account key.
   */
  key?: string;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  secretsType: "AccountKey";
}

model AllFeatures extends MonitoringFeatureFilterBase {
  /**
   * [Required] Specifies the feature filter to leverage when selecting features to calculate metrics over.
   */
  filterType: "AllFeatures";
}

@discriminator("filterType")
model MonitoringFeatureFilterBase {}

/**
 * All nodes means the service will be running on all of the nodes of the job
 */
model AllNodes extends Nodes {
  /**
   * [Required] Type of the Nodes value
   */
  nodesValueType: "All";
}

/**
 * AML Token identity configuration.
 */
model AmlToken extends IdentityConfiguration {
  /**
   * [Required] Specifies the type of identity framework.
   */
  identityType: "AMLToken";
}

/**
 * AML token compute identity definition.
 */
model AmlTokenComputeIdentity extends MonitorComputeIdentityBase {
  /**
   * [Required] Monitor compute identity type enum.
   */
  computeIdentityType: "AmlToken";
}

/**
 * Monitor compute identity base definition.
 */
@discriminator("computeIdentityType")
model MonitorComputeIdentityBase {}

/**
 * Asset input type.
 */
model AssetJobInput {
  /**
   * Input Asset Delivery Mode.
   */
  @visibility("read", "create")
  mode?: InputDeliveryMode;

  /**
   * [Required] Input Asset URI.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  uri: string;
}

/**
 * Asset output type.
 */
model AssetJobOutput {
  /**
   * Output Asset Name.
   */
  assetName?: string;

  /**
   * Output Asset Version.
   */
  assetVersion?: string;

  /**
   * Auto delete setting of output data asset.
   */
  @visibility("read", "create", "update")
  autoDeleteSetting?: AutoDeleteSetting;

  /**
   * Output Asset Delivery Mode.
   */
  @visibility("read", "create")
  mode?: OutputDeliveryMode;

  /**
   * Output Asset URI.
   */
  uri?: string;
}

/**
 * Forecast horizon determined automatically by system.
 */
model AutoForecastHorizon extends ForecastHorizon {
  /**
   * [Required] Set forecast horizon value selection mode.
   */
  mode: "Auto";
}

/**
 * The desired maximum forecast horizon in units of time-series frequency.
 */
@discriminator("mode")
model ForecastHorizon {}

/**
 * AutoMLJob class.
 * Use this class for executing AutoML tasks like Classification/Regression etc.
 * See TaskType enum for all the tasks supported.
 */
model AutoMLJob extends JobBase {
  /**
   * The ARM resource ID of the Environment specification for the job.
   * This is optional value to provide, if not provided, AutoML will default this to Production AutoML curated environment version when running the job.
   */
  @visibility("read", "create")
  environmentId?: string;

  /**
   * Environment variables included in the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  environmentVariables?: Record<string>;

  /**
   * Mapping of output data bindings used in the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  outputs?: Record<JobOutput>;

  /**
   * Queue settings for the job
   */
  @visibility("read", "create")
  queueSettings?: QueueSettings;

  /**
   * Compute Resource configuration for the job.
   */
  @visibility("read", "create")
  resources?: JobResourceConfiguration;

  /**
   * [Required] This represents scenario which can be one of Tables/NLP/Image
   */
  taskDetails: AutoMLVertical;

  /**
   * [Required] Specifies the type of job.
   */
  jobType: "AutoML";
}

/**
 * Job output definition container information on where to find job output/logs.
 */
@discriminator("jobOutputType")
model JobOutput {
  /**
   * Description for the output.
   */
  @visibility("read", "create")
  description?: string;
}

model QueueSettings {
  /**
   * Controls the compute job tier
   */
  @visibility("read", "create")
  jobTier?: JobTier;

  /**
   * Controls the priority of the job on a compute.
   */
  @visibility("read", "create")
  priority?: int32;
}

model JobResourceConfiguration extends ResourceConfiguration {
  /**
   * Extra arguments to pass to the Docker run command. This would override any parameters that have already been set by the system, or in this section. This parameter is only supported for Azure ML compute types.
   */
  @visibility("read", "create")
  dockerArgs?: string;

  /**
   * Size of the docker container's shared memory block. This should be in the format of (number)(unit) where number as to be greater than 0 and the unit can be one of b(bytes), k(kilobytes), m(megabytes), or g(gigabytes).
   */
  @visibility("read", "create")
  @pattern("\\d+[bBkKmMgG]")
  shmSize?: string = "2g";
}

/**
 * AutoML vertical class.
 * Base class for AutoML verticals - TableVertical/ImageVertical/NLPVertical
 */
@discriminator("taskType")
model AutoMLVertical {
  /**
   * Log verbosity for the job.
   */
  logVerbosity?: LogVerbosity;

  /**
   * Target column name: This is prediction values column.
   * Also known as label column name in context of classification tasks.
   */
  targetColumnName?: string;

  /**
   * [Required] Training data input.
   */
  trainingData: MLTableJobInput;
}

model MLTableJobInput extends JobInput {
  ...AssetJobInput;

  /**
   * [Required] Specifies the type of job.
   */
  jobInputType: "mltable";
}

/**
 * Command job definition.
 */
@discriminator("jobInputType")
model JobInput {
  /**
   * Description for the input.
   */
  @visibility("read", "create")
  description?: string;
}

/**
 * N-Cross validations determined automatically.
 */
model AutoNCrossValidations extends NCrossValidations {
  /**
   * [Required] Mode for determining N-Cross validations.
   */
  mode: "Auto";
}

/**
 * N-Cross validations value.
 */
@discriminator("mode")
model NCrossValidations {}

model AutoSeasonality extends Seasonality {
  /**
   * [Required] Seasonality mode.
   */
  mode: "Auto";
}

/**
 * Forecasting seasonality.
 */
@discriminator("mode")
model Seasonality {}

model AutoTargetLags extends TargetLags {
  /**
   * [Required] Set target lags mode - Auto/Custom
   */
  mode: "Auto";
}

/**
 * The number of past periods to lag from the target column.
 */
@discriminator("mode")
model TargetLags {}

/**
 * Target lags rolling window determined automatically.
 */
model AutoTargetRollingWindowSize extends TargetRollingWindowSize {
  /**
   * [Required] TargetRollingWindowSiz detection mode.
   */
  mode: "Auto";
}

/**
 * Forecasting target rolling window size.
 */
@discriminator("mode")
model TargetRollingWindowSize {}

/**
 * Settings for Autologger.
 */
model AutologgerSettings {
  /**
   * [Required] Indicates whether mlflow autologger is enabled.
   */
  @visibility("read", "create")
  mlflowAutologger: MLFlowAutologgerState;
}

model AzMonMonitoringAlertNotificationSettings
  extends MonitoringAlertNotificationSettingsBase {
  /**
   * [Required] Specifies the type of signal to monitor.
   */
  alertNotificationType: "AzureMonitor";
}

@discriminator("alertNotificationType")
model MonitoringAlertNotificationSettingsBase {}

/**
 * Azure Blob datastore configuration.
 */
model AzureBlobDatastore extends Datastore {
  ...AzureDatastore;

  /**
   * Storage account name.
   */
  @visibility("read", "create")
  accountName?: string;

  /**
   * Storage account container name.
   */
  @visibility("read", "create")
  containerName?: string;

  /**
   * Azure cloud endpoint for the storage account.
   */
  @visibility("read", "create")
  endpoint?: string;

  /**
   * Protocol used to communicate with the storage account.
   */
  @visibility("read", "create")
  protocol?: string;

  /**
   * Indicates which identity to use to authenticate service data access to customer's storage.
   */
  @visibility("read", "create")
  serviceDataAccessAuthIdentity?: ServiceDataAccessAuthIdentity;

  /**
   * [Required] Storage type backing the datastore.
   */
  datastoreType: "AzureBlob";
}

/**
 * Base definition for Azure datastore contents configuration.
 */
model AzureDatastore {
  /**
   * Azure Resource Group name
   */
  resourceGroup?: string;

  /**
   * Azure Subscription Id
   */
  subscriptionId?: string;
}

/**
 * Azure Data Lake Gen1 datastore configuration.
 */
model AzureDataLakeGen1Datastore extends Datastore {
  ...AzureDatastore;

  /**
   * Indicates which identity to use to authenticate service data access to customer's storage.
   */
  @visibility("read", "create")
  serviceDataAccessAuthIdentity?: ServiceDataAccessAuthIdentity;

  /**
   * [Required] Azure Data Lake store name.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  storeName: string;

  /**
   * [Required] Storage type backing the datastore.
   */
  datastoreType: "AzureDataLakeGen1";
}

/**
 * Azure Data Lake Gen2 datastore configuration.
 */
model AzureDataLakeGen2Datastore extends Datastore {
  ...AzureDatastore;

  /**
   * [Required] Storage account name.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  accountName: string;

  /**
   * Azure cloud endpoint for the storage account.
   */
  @visibility("read", "create")
  endpoint?: string;

  /**
   * [Required] The name of the Data Lake Gen2 filesystem.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  filesystem: string;

  /**
   * Protocol used to communicate with the storage account.
   */
  @visibility("read", "create")
  protocol?: string;

  /**
   * Indicates which identity to use to authenticate service data access to customer's storage.
   */
  @visibility("read", "create")
  serviceDataAccessAuthIdentity?: ServiceDataAccessAuthIdentity;

  /**
   * [Required] Storage type backing the datastore.
   */
  datastoreType: "AzureDataLakeGen2";
}

/**
 * Webhook details specific for Azure DevOps
 */
model AzureDevOpsWebhook extends Webhook {
  /**
   * [Required] Specifies the type of service to send a callback
   */
  webhookType: "AzureDevOps";
}

/**
 * Azure File datastore configuration.
 */
model AzureFileDatastore extends Datastore {
  ...AzureDatastore;

  /**
   * [Required] Storage account name.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  accountName: string;

  /**
   * Azure cloud endpoint for the storage account.
   */
  @visibility("read", "create")
  endpoint?: string;

  /**
   * [Required] The name of the Azure file share that the datastore points to.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  fileShareName: string;

  /**
   * Protocol used to communicate with the storage account.
   */
  @visibility("read", "create")
  protocol?: string;

  /**
   * Indicates which identity to use to authenticate service data access to customer's storage.
   */
  @visibility("read", "create")
  serviceDataAccessAuthIdentity?: ServiceDataAccessAuthIdentity;

  /**
   * [Required] Storage type backing the datastore.
   */
  datastoreType: "AzureFile";
}

/**
 * Azure ML batch inferencing server configurations.
 */
model AzureMLBatchInferencingServer extends InferencingServer {
  /**
   * Code configuration for AML batch inferencing server.
   */
  codeConfiguration?: CodeConfiguration;

  /**
   * [Required] Inferencing server type for various targets.
   */
  serverType: "AzureMLBatch";
}

/**
 * Azure ML online inferencing configurations.
 */
model AzureMLOnlineInferencingServer extends InferencingServer {
  /**
   * Code configuration for AML inferencing server.
   */
  codeConfiguration?: CodeConfiguration;

  /**
   * [Required] Inferencing server type for various targets.
   */
  serverType: "AzureMLOnline";
}

/**
 * Defines an early termination policy based on slack criteria, and a frequency and delay interval for evaluation
 */
model BanditPolicy extends EarlyTerminationPolicy {
  /**
   * Absolute distance allowed from the best performing run.
   */
  slackAmount?: float32;

  /**
   * Ratio of the allowed distance from the best performing run.
   */
  slackFactor?: float32;

  /**
   * [Required] Name of policy configuration
   */
  policyType: "Bandit";
}

/**
 * Early termination policies enable canceling poor-performing runs before they complete
 */
@discriminator("policyType")
model EarlyTerminationPolicy {
  /**
   * Number of intervals by which to delay the first evaluation.
   */
  delayEvaluation?: int32;

  /**
   * Interval (number of runs) between policy evaluations.
   */
  evaluationInterval?: int32;
}

/**
 * Base environment type.
 */
model BaseEnvironmentId extends BaseEnvironmentSource {
  /**
   * [Required] Resource id accepting ArmId or AzureMlId.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  resourceId: string;

  /**
   * [Required] Base environment type.
   */
  baseEnvironmentSourceType: "EnvironmentAsset";
}

/**
 * Properties for a Batch Pipeline Component Deployment.
 */
model BatchPipelineComponentDeploymentConfiguration
  extends BatchDeploymentConfiguration {
  /**
   * The ARM id of the component to be run.
   */
  componentId?: IdAssetReference;

  /**
   * The description which will be applied to the job.
   */
  description?: string;

  /**
   * Run-time settings for the pipeline job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  settings?: Record<string>;

  /**
   * The tags which will be applied to the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  tags?: Record<string>;

  /**
   * [Required] The type of the deployment
   */
  deploymentConfigurationType: "PipelineComponent";
}

/**
 * Reference to an asset via its ARM resource ID.
 */
model IdAssetReference extends AssetReferenceBase {
  /**
   * [Required] ARM resource ID of the asset.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  assetId: string;

  /**
   * [Required] Specifies the type of asset reference.
   */
  referenceType: "Id";
}

/**
 * Defines a Sampling Algorithm that generates values based on previous values
 */
model BayesianSamplingAlgorithm extends SamplingAlgorithm {
  /**
   * [Required] The algorithm used for generating hyperparameter values, along with configuration properties
   */
  samplingAlgorithmType: "Bayesian";
}

/**
 * The Sampling Algorithm used to generate hyperparameter values, along with properties to
 * configure the algorithm
 */
@discriminator("samplingAlgorithmType")
model SamplingAlgorithm {}

model CategoricalDataDriftMetricThreshold extends DataDriftMetricThresholdBase {
  /**
   * [Required] The categorical data drift metric to calculate.
   */
  @visibility("read", "create")
  metric: CategoricalDataDriftMetric;

  /**
   * [Required] Specifies the data type of the metric threshold.
   */
  dataType: "Categorical";
}

@discriminator("dataType")
model DataDriftMetricThresholdBase {
  /**
   * The threshold value. If null, a default value will be set depending on the selected metric.
   */
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

model MonitoringThreshold {
  /**
   * The threshold value. If null, the set default is dependent on the metric type.
   */
  @visibility("read", "create")
  value?: float64;
}

model CategoricalDataQualityMetricThreshold
  extends DataQualityMetricThresholdBase {
  /**
   * [Required] The categorical data quality metric to calculate.
   */
  @visibility("read", "create")
  metric: CategoricalDataQualityMetric;

  /**
   * [Required] Specifies the data type of the metric threshold.
   */
  dataType: "Categorical";
}

@discriminator("dataType")
model DataQualityMetricThresholdBase {
  /**
   * The threshold value. If null, a default value will be set depending on the selected metric.
   */
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

model CategoricalPredictionDriftMetricThreshold
  extends PredictionDriftMetricThresholdBase {
  /**
   * [Required] The categorical prediction drift metric to calculate.
   */
  @visibility("read", "create")
  metric: CategoricalPredictionDriftMetric;

  /**
   * [Required] Specifies the data type of the metric threshold.
   */
  dataType: "Categorical";
}

@discriminator("dataType")
model PredictionDriftMetricThresholdBase {
  /**
   * The threshold value. If null, a default value will be set depending on the selected metric.
   */
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

/**
 * Certificate datastore credentials configuration.
 */
model CertificateDatastoreCredentials extends DatastoreCredentials {
  /**
   * Authority URL used for authentication.
   */
  authorityUrl?: string;

  /**
   * [Required] Service principal client ID.
   */
  clientId: string;

  /**
   * Resource the service principal has access to.
   */
  resourceUrl?: string;

  /**
   * [Required] Service principal secrets.
   */
  @visibility("create", "update")
  secrets: CertificateDatastoreSecrets;

  /**
   * [Required] ID of the tenant to which the service principal belongs.
   */
  tenantId: string;

  /**
   * [Required] Thumbprint of the certificate used for authentication.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  thumbprint: string;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  credentialsType: "Certificate";
}

/**
 * Datastore certificate secrets.
 */
model CertificateDatastoreSecrets extends DatastoreSecrets {
  /**
   * Service principal certificate.
   */
  certificate?: string;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  secretsType: "Certificate";
}

/**
 * Classification task in AutoML Table vertical.
 */
model Classification extends AutoMLVertical {
  ...TableVertical;

  /**
   * Positive label for binary metrics calculation.
   */
  positiveLabel?: string;

  /**
   * Primary metric for the task.
   */
  primaryMetric?: ClassificationPrimaryMetrics;

  /**
   * Inputs for training phase for an AutoML Job.
   */
  trainingSettings?: ClassificationTrainingSettings;

  /**
   * [Required] Task type for AutoMLJob.
   */
  taskType: "Classification";
}

/**
 * Classification Training related configuration.
 */
model ClassificationTrainingSettings extends TrainingSettings {
  /**
   * Allowed models for classification task.
   */
  allowedTrainingAlgorithms?: ClassificationModels[];

  /**
   * Blocked models for classification task.
   */
  blockedTrainingAlgorithms?: ClassificationModels[];
}

/**
 * Training related configuration.
 */
model TrainingSettings {
  /**
   * Enable recommendation of DNN models.
   */
  enableDnnTraining?: boolean;

  /**
   * Flag to turn on explainability on best model.
   */
  enableModelExplainability?: boolean = true;

  /**
   * Flag for enabling onnx compatible models.
   */
  enableOnnxCompatibleModels?: boolean;

  /**
   * Enable stack ensemble run.
   */
  enableStackEnsemble?: boolean = true;

  /**
   * Enable voting ensemble run.
   */
  enableVoteEnsemble?: boolean = true;

  /**
   * During VotingEnsemble and StackEnsemble model generation, multiple fitted models from the previous child runs are downloaded.
   * Configure this parameter with a higher value than 300 secs, if more time is needed.
   */
  ensembleModelDownloadTimeout?: duration;

  /**
   * Stack ensemble settings for stack ensemble run.
   */
  stackEnsembleSettings?: StackEnsembleSettings;

  /**
   * TrainingMode mode - Setting to 'auto' is same as setting it to 'non-distributed' for now, however in the future may result in mixed mode or heuristics based mode selection. Default is 'auto'.
   * If 'Distributed' then only distributed featurization is used and distributed algorithms are chosen.
   * If 'NonDistributed' then only non distributed algorithms are chosen.
   */
  trainingMode?: TrainingMode;
}

/**
 * Advances setting to customize StackEnsemble run.
 */
model StackEnsembleSettings {
  /**
   * Optional parameters to pass to the initializer of the meta-learner.
   */
  stackMetaLearnerKWargs?: Record<unknown>;

  /**
   * Specifies the proportion of the training set (when choosing train and validation type of training) to be reserved for training the meta-learner. Default value is 0.2.
   */
  stackMetaLearnerTrainPercentage?: float64 = 0.2;

  /**
   * The meta-learner is a model trained on the output of the individual heterogeneous models.
   */
  stackMetaLearnerType?: StackMetaLearnerType;
}

/**
 * Abstract class for AutoML tasks that use table dataset as input - such as Classification/Regression/Forecasting.
 */
model TableVertical {
  /**
   * Columns to use for CVSplit data.
   */
  cvSplitColumnNames?: string[];

  /**
   * Featurization inputs needed for AutoML job.
   */
  featurizationSettings?: TableVerticalFeaturizationSettings;

  /**
   * Model/training parameters that will remain constant throughout training.
   */
  fixedParameters?: TableFixedParameters;

  /**
   * Execution constraints for AutoMLJob.
   */
  limitSettings?: TableVerticalLimitSettings;

  /**
   * Number of cross validation folds to be applied on training dataset
   * when validation dataset is not provided.
   */
  nCrossValidations?: NCrossValidations;

  /**
   * Search space for sampling different combinations of models and their hyperparameters.
   */
  searchSpace?: TableParameterSubspace[];

  /**
   * Settings for model sweeping and hyperparameter tuning.
   */
  sweepSettings?: TableSweepSettings;

  /**
   * Test data input.
   */
  testData?: MLTableJobInput;

  /**
   * The fraction of test dataset that needs to be set aside for validation purpose.
   * Values between (0.0 , 1.0)
   * Applied when validation dataset is not provided.
   */
  testDataSize?: float64;

  /**
   * Validation data inputs.
   */
  validationData?: MLTableJobInput;

  /**
   * The fraction of training dataset that needs to be set aside for validation purpose.
   * Values between (0.0 , 1.0)
   * Applied when validation dataset is not provided.
   */
  validationDataSize?: float64;

  /**
   * The name of the sample weight column. Automated ML supports a weighted column as an input, causing rows in the data to be weighted up or down.
   */
  weightColumnName?: string;
}

/**
 * Featurization Configuration.
 */
model TableVerticalFeaturizationSettings extends FeaturizationSettings {
  /**
   * These transformers shall not be used in featurization.
   */
  blockedTransformers?: BlockedTransformers[];

  /**
   * Dictionary of column name and its type (int, float, string, datetime etc).
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  columnNameAndTypes?: Record<string>;

  /**
   * Determines whether to use Dnn based featurizers for data featurization.
   */
  enableDnnFeaturization?: boolean;

  /**
   * Featurization mode - User can keep the default 'Auto' mode and AutoML will take care of necessary transformation of the data in featurization phase.
   * If 'Off' is selected then no featurization is done.
   * If 'Custom' is selected then user can specify additional inputs to customize how featurization is done.
   */
  mode?: FeaturizationMode;

  /**
   * User can specify additional transformers to be used along with the columns to which it would be applied and parameters for the transformer constructor.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  transformerParams?: Record<ColumnTransformer[]>;
}

/**
 * Column transformer parameters.
 */
model ColumnTransformer {
  /**
   * Fields to apply transformer logic on.
   */
  fields?: string[];

  /**
   * Different properties to be passed to transformer.
   * Input expected is dictionary of key,value pairs in JSON format.
   */
  parameters?: Record<unknown>;
}

/**
 * Featurization Configuration.
 */
model FeaturizationSettings {
  /**
   * Dataset language, useful for the text data.
   */
  datasetLanguage?: string;
}

/**
 * Fixed training parameters that won't be swept over during AutoML Table training.
 */
model TableFixedParameters {
  /**
   * Specify the boosting type, e.g gbdt for XGBoost.
   */
  booster?: string;

  /**
   * Specify the boosting type, e.g gbdt for LightGBM.
   */
  boostingType?: string;

  /**
   * Specify the grow policy, which controls the way new nodes are added to the tree.
   */
  growPolicy?: string;

  /**
   * The learning rate for the training procedure.
   */
  learningRate?: float64;

  /**
   * Specify the Maximum number of discrete bins to bucket continuous features .
   */
  maxBin?: int32;

  /**
   * Specify the max depth to limit the tree depth explicitly.
   */
  maxDepth?: int32;

  /**
   * Specify the max leaves to limit the tree leaves explicitly.
   */
  maxLeaves?: int32;

  /**
   * The minimum number of data per leaf.
   */
  minDataInLeaf?: int32;

  /**
   * Minimum loss reduction required to make a further partition on a leaf node of the tree.
   */
  minSplitGain?: float64;

  /**
   * The name of the model to train.
   */
  modelName?: string;

  /**
   * Specify the number of trees (or rounds) in an model.
   */
  nEstimators?: int32;

  /**
   * Specify the number of leaves.
   */
  numLeaves?: int32;

  /**
   * The name of the preprocessor to use.
   */
  preprocessorName?: string;

  /**
   * L1 regularization term on weights.
   */
  regAlpha?: float64;

  /**
   * L2 regularization term on weights.
   */
  regLambda?: float64;

  /**
   * Subsample ratio of the training instance.
   */
  subsample?: float64;

  /**
   * Frequency of subsample.
   */
  subsampleFreq?: float64;

  /**
   * Specify the tree method.
   */
  treeMethod?: string;

  /**
   * If true, center before scaling the data with StandardScalar.
   */
  withMean?: boolean;

  /**
   * If true, scaling the data with Unit Variance with StandardScalar.
   */
  withStd?: boolean;
}

/**
 * Job execution constraints.
 */
model TableVerticalLimitSettings {
  /**
   * Enable early termination, determines whether or not if AutoMLJob will terminate early if there is no score improvement in last 20 iterations.
   */
  enableEarlyTermination?: boolean = true;

  /**
   * Exit score for the AutoML job.
   */
  exitScore?: float64;

  /**
   * Maximum Concurrent iterations.
   */
  maxConcurrentTrials?: int32 = 1;

  /**
   * Max cores per iteration.
   */
  maxCoresPerTrial?: int32 = -1;

  /**
   * Maximum nodes to use for the experiment.
   */
  maxNodes?: int32 = 1;

  /**
   * Number of iterations.
   */
  maxTrials?: int32 = 1000;

  /**
   * Number of concurrent sweeping runs that user wants to trigger.
   */
  sweepConcurrentTrials?: int32;

  /**
   * Number of sweeping runs that user wants to trigger.
   */
  sweepTrials?: int32;

  /**
   * AutoML job timeout.
   */
  timeout?: duration;

  /**
   * Iteration timeout.
   */
  trialTimeout?: duration;
}

model TableParameterSubspace {
  /**
   * Specify the boosting type, e.g gbdt for XGBoost.
   */
  booster?: string;

  /**
   * Specify the boosting type, e.g gbdt for LightGBM.
   */
  boostingType?: string;

  /**
   * Specify the grow policy, which controls the way new nodes are added to the tree.
   */
  growPolicy?: string;

  /**
   * The learning rate for the training procedure.
   */
  learningRate?: string;

  /**
   * Specify the Maximum number of discrete bins to bucket continuous features .
   */
  maxBin?: string;

  /**
   * Specify the max depth to limit the tree depth explicitly.
   */
  maxDepth?: string;

  /**
   * Specify the max leaves to limit the tree leaves explicitly.
   */
  maxLeaves?: string;

  /**
   * The minimum number of data per leaf.
   */
  minDataInLeaf?: string;

  /**
   * Minimum loss reduction required to make a further partition on a leaf node of the tree.
   */
  minSplitGain?: string;

  /**
   * The name of the model to train.
   */
  modelName?: string;

  /**
   * Specify the number of trees (or rounds) in an model.
   */
  nEstimators?: string;

  /**
   * Specify the number of leaves.
   */
  numLeaves?: string;

  /**
   * The name of the preprocessor to use.
   */
  preprocessorName?: string;

  /**
   * L1 regularization term on weights.
   */
  regAlpha?: string;

  /**
   * L2 regularization term on weights.
   */
  regLambda?: string;

  /**
   * Subsample ratio of the training instance.
   */
  subsample?: string;

  /**
   * Frequency of subsample
   */
  subsampleFreq?: string;

  /**
   * Specify the tree method.
   */
  treeMethod?: string;

  /**
   * If true, center before scaling the data with StandardScalar.
   */
  withMean?: string;

  /**
   * If true, scaling the data with Unit Variance with StandardScalar.
   */
  withStd?: string;
}

model TableSweepSettings {
  /**
   * Type of early termination policy for the sweeping job.
   */
  earlyTermination?: EarlyTerminationPolicy;

  /**
   * [Required] Type of sampling algorithm.
   */
  samplingAlgorithm: SamplingAlgorithmType;
}

model ClassificationModelPerformanceMetricThreshold
  extends ModelPerformanceMetricThresholdBase {
  /**
   * [Required] The classification model performance to calculate.
   */
  @visibility("read", "create")
  metric: ClassificationModelPerformanceMetric;

  /**
   * [Required] Specifies the data type of the metric threshold.
   */
  modelType: "Classification";
}

@discriminator("modelType")
model ModelPerformanceMetricThresholdBase {
  /**
   * The threshold value. If null, a default value will be set depending on the selected metric.
   */
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

model CocoExportSummary extends ExportSummary {
  /**
   * The container name to which the labels will be exported.
   */
  @visibility("read")
  containerName?: string;

  /**
   * The output path where the labels will be exported.
   */
  @visibility("read")
  snapshotPath?: string;

  /**
   * [Required] The format of exported labels, also as the discriminator.
   */
  format: "Coco";
}

/**
 * Command job definition.
 */
model CommandJob extends JobBase {
  /**
   * Distribution configuration of the job. If set, this should be one of Mpi, Tensorflow, PyTorch, or null.
   */
  @visibility("read", "create")
  autologgerSettings?: AutologgerSettings;

  /**
   * ARM resource ID of the code asset.
   */
  @visibility("read", "create")
  codeId?: string;

  /**
   * [Required] The command to execute on startup of the job. eg. "python train.py"
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  command: string;

  /**
   * Distribution configuration of the job. If set, this should be one of Mpi, Tensorflow, PyTorch, Ray, or null.
   */
  @visibility("read", "create")
  distribution?: DistributionConfiguration;

  /**
   * [Required] The ARM resource ID of the Environment specification for the job.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  environmentId: string;

  /**
   * Environment variables included in the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  environmentVariables?: Record<string>;

  /**
   * Mapping of input data bindings used in the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  inputs?: Record<JobInput>;

  /**
   * Command Job limit.
   */
  @visibility("read", "create")
  limits?: CommandJobLimits;

  /**
   * Mapping of output data bindings used in the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  outputs?: Record<JobOutput>;

  /**
   * Input parameters.
   */
  @visibility("read")
  parameters?: Record<unknown>;

  /**
   * Queue settings for the job
   */
  @visibility("read", "create")
  queueSettings?: QueueSettings;

  /**
   * Compute Resource configuration for the job.
   */
  @visibility("read", "create")
  resources?: JobResourceConfiguration;

  /**
   * [Required] Specifies the type of job.
   */
  jobType: "Command";
}

/**
 * Base definition for job distribution configuration.
 */
@discriminator("distributionType")
model DistributionConfiguration {}

/**
 * Command Job limit class.
 */
model CommandJobLimits extends JobLimits {
  /**
   * [Required] JobLimit type.
   */
  jobLimitsType: "Command";
}

@discriminator("jobLimitsType")
model JobLimits {
  /**
   * The max run duration in ISO 8601 format, after which the job will be cancelled. Only supports duration with precision as low as Seconds.
   */
  timeout?: duration;
}

/**
 * Resource requirements for each container instance within an online deployment.
 */
model ContainerResourceRequirements {
  /**
   * Container resource limit info:
   */
  containerResourceLimits?: ContainerResourceSettings;

  /**
   * Container resource request info:
   */
  containerResourceRequests?: ContainerResourceSettings;
}

model ContainerResourceSettings {
  /**
   * Number of vCPUs request/limit for container. More info:
   * https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
   */
  cpu?: string;

  /**
   * Number of Nvidia GPU cards request/limit for container. More info:
   * https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
   */
  gpu?: string;

  /**
   * Memory size request/limit for container. More info:
   * https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
   */
  memory?: string;
}

model CreateMonitorAction extends ScheduleActionBase {
  /**
   * [Required] Defines the monitor.
   */
  @visibility("read", "create")
  monitorDefinition: MonitorDefinition;

  /**
   * [Required] Specifies the action type of the schedule
   */
  actionType: "CreateMonitor";
}

model MonitorDefinition {
  /**
   * The monitor's notification settings.
   */
  @visibility("read", "create")
  alertNotificationSetting?: MonitoringAlertNotificationSettingsBase;

  /**
   * [Required] The ARM resource ID of the compute resource to run the monitoring job on.
   */
  @visibility("read", "create")
  computeConfiguration: MonitorComputeConfigurationBase;

  /**
   * The ARM resource ID of either the model or deployment targeted by this monitor.
   */
  @visibility("read", "create")
  monitoringTarget?: MonitoringTarget;

  /**
   * [Required] The signals to monitor.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  signals: Record<MonitoringSignalBase>;
}

/**
 * Monitor compute configuration base definition.
 */
@discriminator("computeType")
model MonitorComputeConfigurationBase {}

/**
 * Monitoring target definition.
 */
model MonitoringTarget {
  /**
   * The ARM resource ID of either the deployment targeted by this monitor.
   */
  @visibility("read", "create")
  deploymentId?: string;

  /**
   * The ARM resource ID of either the model targeted by this monitor.
   */
  @visibility("read", "create")
  modelId?: string;

  /**
   * [Required] The machine learning task type of the model.
   */
  @visibility("read", "create")
  taskType: ModelTaskType;
}

@discriminator("signalType")
model MonitoringSignalBase {
  /**
   * The current notification mode for this signal.
   */
  @visibility("read", "create")
  mode?: MonitoringNotificationMode;

  /**
   * Property dictionary. Properties can be added, but not removed or altered.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  properties?: Record<string>;
}

model CronTrigger extends TriggerBase {
  /**
   * [Required] Specifies cron expression of schedule.
   * The expression should follow NCronTab format.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  expression: string;

  /**
   * [Required]
   */
  triggerType: "Cron";
}

model CsvExportSummary extends ExportSummary {
  /**
   * The container name to which the labels will be exported.
   */
  @visibility("read")
  containerName?: string;

  /**
   * The output path where the labels will be exported.
   */
  @visibility("read")
  snapshotPath?: string;

  /**
   * [Required] The format of exported labels, also as the discriminator.
   */
  format: "CSV";
}

/**
 * The desired maximum forecast horizon in units of time-series frequency.
 */
model CustomForecastHorizon extends ForecastHorizon {
  /**
   * [Required] Forecast horizon value.
   */
  value: int32;

  /**
   * [Required] Set forecast horizon value selection mode.
   */
  mode: "Custom";
}

/**
 * Custom inference server configurations.
 */
model CustomInferencingServer extends InferencingServer {
  /**
   * Inference configuration for custom inferencing.
   */
  inferenceConfiguration?: OnlineInferenceConfiguration;

  /**
   * [Required] Inferencing server type for various targets.
   */
  serverType: "Custom";
}

/**
 * Online inference configuration options.
 */
model OnlineInferenceConfiguration {
  /**
   * Additional configurations
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  configurations?: Record<string>;

  /**
   * Entry script or command to invoke.
   */
  entryScript?: string;

  /**
   * The route to check the liveness of the inference server container.
   */
  livenessRoute?: Route;

  /**
   * The route to check the readiness of the inference server container.
   */
  readinessRoute?: Route;

  /**
   * The port to send the scoring requests to, within the inference server container.
   */
  scoringRoute?: Route;
}

model CustomMetricThreshold {
  /**
   * [Required] The user-defined metric to calculate.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  metric: string;

  /**
   * The threshold value. If null, a default value will be set depending on the selected metric.
   */
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

model CustomModelJobInput extends JobInput {
  ...AssetJobInput;

  /**
   * [Required] Specifies the type of job.
   */
  jobInputType: "custom_model";
}

model CustomModelJobOutput extends JobOutput {
  ...AssetJobOutput;

  /**
   * [Required] Specifies the type of job.
   */
  jobOutputType: "custom_model";
}

model CustomMonitoringSignal extends MonitoringSignalBase {
  /**
   * [Required] ARM resource ID of the component resource used to calculate the custom metrics.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  componentId: string;

  /**
   * Monitoring assets to take as input. Key is the component input port name, value is the data asset.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  inputAssets?: Record<MonitoringInputDataBase>;

  /**
   * Extra component parameters to take as input. Key is the component literal input port name, value is the parameter value.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  inputs?: Record<JobInput>;

  /**
   * [Required] A list of metrics to calculate and their associated thresholds.
   */
  @visibility("read", "create")
  metricThresholds: CustomMetricThreshold[];

  /**
   * [Required] A list of metrics to calculate and their associated thresholds.
   */
  @visibility("read", "create")
  workspaceConnection: MonitoringWorkspaceConnection;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  signalType: "Custom";
}

/**
 * Monitoring input data base definition.
 */
@discriminator("inputDataType")
model MonitoringInputDataBase {
  /**
   * Mapping of column names to special uses.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  columns?: Record<string>;

  /**
   * The context metadata of the data source.
   */
  @visibility("read", "create")
  dataContext?: string;

  /**
   * [Required] Specifies the type of job.
   */
  @visibility("read", "create")
  jobInputType: JobInputType;

  /**
   * [Required] Input Asset URI.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  uri: string;
}

/**
 * Monitoring workspace connection definition.
 */
model MonitoringWorkspaceConnection {
  /**
   * The properties of a workspace service connection to store as environment variables in the submitted jobs.
   * Key is workspace connection property path, name is environment variable key.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  environmentVariables?: Record<string>;

  /**
   * The properties of a workspace service connection to store as secrets in the submitted jobs.
   * Key is workspace connection property path, name is secret key.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  secrets?: Record<string>;
}

/**
 * N-Cross validations are specified by user.
 */
model CustomNCrossValidations extends NCrossValidations {
  /**
   * [Required] N-Cross validations value.
   */
  value: int32;

  /**
   * [Required] Mode for determining N-Cross validations.
   */
  mode: "Custom";
}

model CustomSeasonality extends Seasonality {
  /**
   * [Required] Seasonality value.
   */
  value: int32;

  /**
   * [Required] Seasonality mode.
   */
  mode: "Custom";
}

model CustomTargetLags extends TargetLags {
  /**
   * [Required] Set target lags values.
   */
  values: int32[];

  /**
   * [Required] Set target lags mode - Auto/Custom
   */
  mode: "Custom";
}

model CustomTargetRollingWindowSize extends TargetRollingWindowSize {
  /**
   * [Required] TargetRollingWindowSize value.
   */
  value: int32;

  /**
   * [Required] TargetRollingWindowSiz detection mode.
   */
  mode: "Custom";
}

model DataDriftMonitoringSignal extends MonitoringSignalBase {
  /**
   * The data segment used for scoping on a subset of the data population.
   */
  @visibility("read", "create")
  dataSegment?: MonitoringDataSegment;

  /**
   * A dictionary that maps feature names to their respective data types.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  featureDataTypeOverride?: Record<MonitoringFeatureDataType>;

  /**
   * The feature filter which identifies which feature to calculate drift over.
   */
  @visibility("read", "create")
  features?: MonitoringFeatureFilterBase;

  /**
   * [Required] A list of metrics to calculate and their associated thresholds.
   */
  @visibility("read", "create")
  metricThresholds: DataDriftMetricThresholdBase[];

  /**
   * [Required] The data which drift will be calculated for.
   */
  @visibility("read", "create")
  productionData: MonitoringInputDataBase;

  /**
   * [Required] The data to calculate drift against.
   */
  @visibility("read", "create")
  referenceData: MonitoringInputDataBase;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  signalType: "DataDrift";
}

model MonitoringDataSegment {
  /**
   * The feature to segment the data on.
   */
  @visibility("read", "create")
  feature?: string;

  /**
   * Filters for only the specified values of the given segmented feature.
   */
  @visibility("read", "create")
  values?: string[];
}

model DataImport extends DataVersionBase {
  /**
   * Name of the asset for data import job to create
   */
  assetName?: string;

  /**
   * Source data of the asset to import from
   */
  source?: DataImportSource;

  /**
   * [Required] Specifies the type of data.
   */
  dataType: "uri_folder";
}

@discriminator("sourceType")
model DataImportSource {
  /**
   * Workspace connection for data import source storage
   */
  connection?: string;
}

/**
 * Reference to an asset via its path in a datastore.
 */
model DataPathAssetReference extends AssetReferenceBase {
  /**
   * ARM resource ID of the datastore where the asset is located.
   */
  datastoreId?: string;

  /**
   * The path of the file/directory in the datastore.
   */
  path?: string;

  /**
   * [Required] Specifies the type of asset reference.
   */
  referenceType: "DataPath";
}

model DataQualityMonitoringSignal extends MonitoringSignalBase {
  /**
   * A dictionary that maps feature names to their respective data types.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  featureDataTypeOverride?: Record<MonitoringFeatureDataType>;

  /**
   * The features to calculate drift over.
   */
  @visibility("read", "create")
  features?: MonitoringFeatureFilterBase;

  /**
   * [Required] A list of metrics to calculate and their associated thresholds.
   */
  @visibility("read", "create")
  metricThresholds: DataQualityMetricThresholdBase[];

  /**
   * [Required] The data produced by the production service which drift will be calculated for.
   */
  @visibility("read", "create")
  productionData: MonitoringInputDataBase;

  /**
   * [Required] The data to calculate drift against.
   */
  @visibility("read", "create")
  referenceData: MonitoringInputDataBase;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  signalType: "DataQuality";
}

model DatabaseSource extends DataImportSource {
  /**
   * SQL Query statement for data import Database source
   */
  query?: string;

  /**
   * SQL StoredProcedure on data import Database source
   */
  storedProcedure?: string;

  /**
   * SQL StoredProcedure parameters
   */
  storedProcedureParams?: Record<string>[];

  /**
   * Name of the table on data import Database source
   */
  tableName?: string;

  /**
   * [Required] Specifies the type of data.
   */
  sourceType: "database";
}

model DatasetExportSummary extends ExportSummary {
  /**
   * The unique name of the labeled data asset.
   */
  @visibility("read")
  labeledAssetName?: string;

  /**
   * [Required] The format of exported labels, also as the discriminator.
   */
  format: "Dataset";
}

model DefaultScaleSettings extends OnlineScaleSettings {
  /**
   * [Required] Type of deployment scaling algorithm
   */
  scaleType: "Default";
}

model EmailMonitoringAlertNotificationSettings
  extends MonitoringAlertNotificationSettingsBase {
  /**
   * Configuration for notification.
   */
  @visibility("read", "create")
  emailNotificationSetting?: NotificationSetting;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  alertNotificationType: "Email";
}

model EndpointScheduleAction extends ScheduleActionBase {
  /**
   * [Required] Defines Schedule action definition details.
   * <see href="TBD" />
   */
  @visibility("read", "create", "update")
  endpointInvocationDefinition: Record<unknown>;

  /**
   * [Required] Specifies the action type of the schedule
   */
  actionType: "InvokeBatchEndpoint";
}

model FeatureAttributionDriftMonitoringSignal extends MonitoringSignalBase {
  /**
   * [Required] A list of metrics to calculate and their associated thresholds.
   */
  @visibility("read", "create")
  metricThreshold: FeatureAttributionMetricThreshold;

  /**
   * [Required] The data which drift will be calculated for.
   */
  @visibility("read", "create")
  productionData: MonitoringInputDataBase[];

  /**
   * [Required] The data to calculate drift against.
   */
  @visibility("read", "create")
  referenceData: MonitoringInputDataBase;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  signalType: "FeatureAttributionDrift";
}

model FeatureAttributionMetricThreshold {
  /**
   * [Required] The feature attribution metric to calculate.
   */
  @visibility("read", "create")
  metric: FeatureAttributionMetric;

  /**
   * The threshold value. If null, a default value will be set depending on the selected metric.
   */
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

model FeatureSubset extends MonitoringFeatureFilterBase {
  /**
   * [Required] The list of features to include.
   */
  @visibility("read", "create")
  features: string[];

  /**
   * [Required] Specifies the feature filter to leverage when selecting features to calculate metrics over.
   */
  filterType: "FeatureSubset";
}

model FileSystemSource extends DataImportSource {
  /**
   * Path on data import FileSystem source
   */
  path?: string;

  /**
   * [Required] Specifies the type of data.
   */
  sourceType: "file_system";
}

/**
 * Fixed input data definition.
 */
model FixedInputData extends MonitoringInputDataBase {
  /**
   * [Required] Specifies the type of signal to monitor.
   */
  inputDataType: "Fixed";
}

/**
 * Forecasting task in AutoML Table vertical.
 */
model Forecasting extends AutoMLVertical {
  ...TableVertical;

  /**
   * Forecasting task specific inputs.
   */
  forecastingSettings?: ForecastingSettings;

  /**
   * Primary metric for forecasting task.
   */
  primaryMetric?: ForecastingPrimaryMetrics;

  /**
   * Inputs for training phase for an AutoML Job.
   */
  trainingSettings?: ForecastingTrainingSettings;

  /**
   * [Required] Task type for AutoMLJob.
   */
  taskType: "Forecasting";
}

/**
 * Forecasting specific parameters.
 */
model ForecastingSettings {
  /**
   * Country or region for holidays for forecasting tasks.
   * These should be ISO 3166 two-letter country/region codes, for example 'US' or 'GB'.
   */
  countryOrRegionForHolidays?: string;

  /**
   * Number of periods between the origin time of one CV fold and the next fold. For
   * example, if `CVStepSize` = 3 for daily data, the origin time for each fold will be
   * three days apart.
   */
  cvStepSize?: int32;

  /**
   * Flag for generating lags for the numeric features with 'auto' or null.
   */
  featureLags?: FeatureLags;

  /**
   * The feature columns that are available for training but unknown at the time of forecast/inference.
   * If features_unknown_at_forecast_time is not set, it is assumed that all the feature columns in the dataset are known at inference time.
   */
  featuresUnknownAtForecastTime?: string[];

  /**
   * The desired maximum forecast horizon in units of time-series frequency.
   */
  forecastHorizon?: ForecastHorizon;

  /**
   * When forecasting, this parameter represents the period with which the forecast is desired, for example daily, weekly, yearly, etc. The forecast frequency is dataset frequency by default.
   */
  frequency?: string;

  /**
   * Set time series seasonality as an integer multiple of the series frequency.
   * If seasonality is set to 'auto', it will be inferred.
   */
  seasonality?: Seasonality;

  /**
   * The parameter defining how if AutoML should handle short time series.
   */
  shortSeriesHandlingConfig?: ShortSeriesHandlingConfiguration;

  /**
   * The function to be used to aggregate the time series target column to conform to a user specified frequency.
   * If the TargetAggregateFunction is set i.e. not 'None', but the freq parameter is not set, the error is raised. The possible target aggregation functions are: "sum", "max", "min" and "mean".
   */
  targetAggregateFunction?: TargetAggregationFunction;

  /**
   * The number of past periods to lag from the target column.
   */
  targetLags?: TargetLags;

  /**
   * The number of past periods used to create a rolling window average of the target column.
   */
  targetRollingWindowSize?: TargetRollingWindowSize;

  /**
   * The name of the time column. This parameter is required when forecasting to specify the datetime column in the input data used for building the time series and inferring its frequency.
   */
  timeColumnName?: string;

  /**
   * The names of columns used to group a timeseries. It can be used to create multiple series.
   * If grain is not defined, the data set is assumed to be one time-series. This parameter is used with task type forecasting.
   */
  timeSeriesIdColumnNames?: string[];

  /**
   * Configure STL Decomposition of the time-series target column.
   */
  useStl?: UseStl;
}

/**
 * Forecasting Training related configuration.
 */
model ForecastingTrainingSettings extends TrainingSettings {
  /**
   * Allowed models for forecasting task.
   */
  allowedTrainingAlgorithms?: ForecastingModels[];

  /**
   * Blocked models for forecasting task.
   */
  blockedTrainingAlgorithms?: ForecastingModels[];
}

/**
 * Generation safety quality metric threshold definition.
 */
model GenerationSafetyQualityMetricThreshold {
  /**
   * [Required] Gets or sets the feature attribution metric to calculate.
   */
  @visibility("read", "create")
  metric: GenerationSafetyQualityMetric;

  /**
   * Gets or sets the threshold value.
   * If null, a default value will be set depending on the selected metric.
   */
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

/**
 * Generation safety quality monitoring signal definition.
 */
model GenerationSafetyQualityMonitoringSignal extends MonitoringSignalBase {
  /**
   * [Required] Gets or sets the metrics to calculate and the corresponding thresholds.
   */
  @visibility("read", "create")
  metricThresholds: GenerationSafetyQualityMetricThreshold[];

  /**
   * Gets or sets the target data for computing metrics.
   */
  @visibility("read", "create")
  productionData?: MonitoringInputDataBase[];

  /**
   * [Required] The sample rate of the target data, should be greater than 0 and at most 1.
   */
  @visibility("read", "create")
  samplingRate: float64;

  /**
   * Gets or sets the workspace connection ID used to connect to the content generation endpoint.
   */
  @visibility("read", "create")
  workspaceConnectionId?: string;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  signalType: "GenerationSafetyQuality";
}

/**
 * Generation token statistics metric threshold definition.
 */
model GenerationTokenStatisticsMetricThreshold {
  /**
   * [Required] Gets or sets the feature attribution metric to calculate.
   */
  @visibility("read", "create")
  metric: GenerationTokenStatisticsMetric;

  /**
   * Gets or sets the threshold value.
   * If null, a default value will be set depending on the selected metric.
   */
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

/**
 * Generation token statistics signal definition.
 */
model GenerationTokenStatisticsSignal extends MonitoringSignalBase {
  /**
   * [Required] Gets or sets the metrics to calculate and the corresponding thresholds.
   */
  @visibility("read", "create")
  metricThresholds: GenerationTokenStatisticsMetricThreshold[];

  /**
   * Gets or sets the target data for computing metrics.
   */
  @visibility("read", "create")
  productionData?: MonitoringInputDataBase;

  /**
   * [Required] The sample rate of the target data, should be greater than 0 and at most 1.
   */
  @visibility("read", "create")
  samplingRate: float64;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  signalType: "GenerationTokenStatistics";
}

/**
 * Defines a Sampling Algorithm that exhaustively generates every value combination in the space
 */
model GridSamplingAlgorithm extends SamplingAlgorithm {
  /**
   * [Required] The algorithm used for generating hyperparameter values, along with configuration properties
   */
  samplingAlgorithmType: "Grid";
}

model HdfsDatastore extends Datastore {
  /**
   * The TLS cert of the HDFS server. Needs to be a base64 encoded string. Required if "Https" protocol is selected.
   */
  @visibility("read", "create")
  hdfsServerCertificate?: string;

  /**
   * [Required] IP Address or DNS HostName.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  nameNodeAddress: string;

  /**
   * Protocol used to communicate with the storage account (Https/Http).
   */
  @visibility("read", "create")
  protocol?: string = "http";

  /**
   * [Required] Storage type backing the datastore.
   */
  datastoreType: "Hdfs";
}

/**
 * Image Classification. Multi-class image classification is used when an image is classified with only a single label
 * from a set of classes - e.g. each image is classified as either an image of a 'cat' or a 'dog' or a 'duck'.
 */
model ImageClassification extends AutoMLVertical {
  ...ImageClassificationBase;

  /**
   * Primary metric to optimize for this task.
   */
  primaryMetric?: ClassificationPrimaryMetrics;

  /**
   * [Required] Task type for AutoMLJob.
   */
  taskType: "ImageClassification";
}

model ImageClassificationBase extends ImageVertical {
  /**
   * Settings used for training the model.
   */
  modelSettings?: ImageModelSettingsClassification;

  /**
   * Search space for sampling different combinations of models and their hyperparameters.
   */
  searchSpace?: ImageModelDistributionSettingsClassification[];
}

/**
 * Settings used for training the model.
 * For more information on the available settings please visit the official documentation:
 * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
 */
model ImageModelSettingsClassification extends ImageModelSettings {
  /**
   * Image crop size that is input to the neural network for the training dataset. Must be a positive integer.
   */
  trainingCropSize?: int32;

  /**
   * Image crop size that is input to the neural network for the validation dataset. Must be a positive integer.
   */
  validationCropSize?: int32;

  /**
   * Image size to which to resize before cropping for validation dataset. Must be a positive integer.
   */
  validationResizeSize?: int32;

  /**
   * Weighted loss. The accepted values are 0 for no weighted loss.
   * 1 for weighted loss with sqrt.(class_weights). 2 for weighted loss with class_weights. Must be 0 or 1 or 2.
   */
  weightedLoss?: int32;
}

/**
 * Settings used for training the model.
 * For more information on the available settings please visit the official documentation:
 * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
 */
model ImageModelSettings {
  /**
   * Settings for advanced scenarios.
   */
  advancedSettings?: string;

  /**
   * Enable AMSGrad when optimizer is 'adam' or 'adamw'.
   */
  amsGradient?: boolean;

  /**
   * Settings for using Augmentations.
   */
  augmentations?: string;

  /**
   * Value of 'beta1' when optimizer is 'adam' or 'adamw'. Must be a float in the range [0, 1].
   */
  beta1?: float32;

  /**
   * Value of 'beta2' when optimizer is 'adam' or 'adamw'. Must be a float in the range [0, 1].
   */
  beta2?: float32;

  /**
   * Frequency to store model checkpoints. Must be a positive integer.
   */
  checkpointFrequency?: int32;

  /**
   * The pretrained checkpoint model for incremental training.
   */
  checkpointModel?: MLFlowModelJobInput;

  /**
   * The id of a previous run that has a pretrained checkpoint for incremental training.
   */
  checkpointRunId?: string;

  /**
   * Whether to use distributed training.
   */
  distributed?: boolean;

  /**
   * Enable early stopping logic during training.
   */
  earlyStopping?: boolean;

  /**
   * Minimum number of epochs or validation evaluations to wait before primary metric improvement
   * is tracked for early stopping. Must be a positive integer.
   */
  earlyStoppingDelay?: int32;

  /**
   * Minimum number of epochs or validation evaluations with no primary metric improvement before
   * the run is stopped. Must be a positive integer.
   */
  earlyStoppingPatience?: int32;

  /**
   * Enable normalization when exporting ONNX model.
   */
  enableOnnxNormalization?: boolean;

  /**
   * Frequency to evaluate validation dataset to get metric scores. Must be a positive integer.
   */
  evaluationFrequency?: int32;

  /**
   * Gradient accumulation means running a configured number of "GradAccumulationStep" steps without
   * updating the model weights while accumulating the gradients of those steps, and then using
   * the accumulated gradients to compute the weight updates. Must be a positive integer.
   */
  gradientAccumulationStep?: int32;

  /**
   * Number of layers to freeze for the model. Must be a positive integer.
   * For instance, passing 2 as value for 'seresnext' means
   * freezing layer0 and layer1. For a full list of models supported and details on layer freeze, please
   * see: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
   */
  layersToFreeze?: int32;

  /**
   * Initial learning rate. Must be a float in the range [0, 1].
   */
  learningRate?: float32;

  /**
   * Type of learning rate scheduler. Must be 'warmup_cosine' or 'step'.
   */
  learningRateScheduler?: LearningRateScheduler;

  /**
   * Name of the model to use for training.
   * For more information on the available models please visit the official documentation:
   * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
   */
  modelName?: string;

  /**
   * Value of momentum when optimizer is 'sgd'. Must be a float in the range [0, 1].
   */
  momentum?: float32;

  /**
   * Enable nesterov when optimizer is 'sgd'.
   */
  nesterov?: boolean;

  /**
   * Number of training epochs. Must be a positive integer.
   */
  numberOfEpochs?: int32;

  /**
   * Number of data loader workers. Must be a non-negative integer.
   */
  numberOfWorkers?: int32;

  /**
   * Type of optimizer.
   */
  optimizer?: StochasticOptimizer;

  /**
   * Random seed to be used when using deterministic training.
   */
  randomSeed?: int32;

  /**
   * Value of gamma when learning rate scheduler is 'step'. Must be a float in the range [0, 1].
   */
  stepLRGamma?: float32;

  /**
   * Value of step size when learning rate scheduler is 'step'. Must be a positive integer.
   */
  stepLRStepSize?: int32;

  /**
   * Training batch size. Must be a positive integer.
   */
  trainingBatchSize?: int32;

  /**
   * Validation batch size. Must be a positive integer.
   */
  validationBatchSize?: int32;

  /**
   * Value of cosine cycle when learning rate scheduler is 'warmup_cosine'. Must be a float in the range [0, 1].
   */
  warmupCosineLRCycles?: float32;

  /**
   * Value of warmup epochs when learning rate scheduler is 'warmup_cosine'. Must be a positive integer.
   */
  warmupCosineLRWarmupEpochs?: int32;

  /**
   * Value of weight decay when optimizer is 'sgd', 'adam', or 'adamw'. Must be a float in the range[0, 1].
   */
  weightDecay?: float32;
}

model MLFlowModelJobInput extends JobInput {
  ...AssetJobInput;

  /**
   * [Required] Specifies the type of job.
   */
  jobInputType: "mlflow_model";
}

/**
 * Distribution expressions to sweep over values of model settings.
 * <example>
 * Some examples are:
 * ```
 * ModelName = "choice('seresnext', 'resnest50')";
 * LearningRate = "uniform(0.001, 0.01)";
 * LayersToFreeze = "choice(0, 2)";
 * ```</example>
 * For more details on how to compose distribution expressions please check the documentation:
 * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-tune-hyperparameters
 * For more information on the available settings please visit the official documentation:
 * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
 */
model ImageModelDistributionSettingsClassification
  extends ImageModelDistributionSettings {
  /**
   * Image crop size that is input to the neural network for the training dataset. Must be a positive integer.
   */
  trainingCropSize?: string;

  /**
   * Image crop size that is input to the neural network for the validation dataset. Must be a positive integer.
   */
  validationCropSize?: string;

  /**
   * Image size to which to resize before cropping for validation dataset. Must be a positive integer.
   */
  validationResizeSize?: string;

  /**
   * Weighted loss. The accepted values are 0 for no weighted loss.
   * 1 for weighted loss with sqrt.(class_weights). 2 for weighted loss with class_weights. Must be 0 or 1 or 2.
   */
  weightedLoss?: string;
}

/**
 * Distribution expressions to sweep over values of model settings.
 * <example>
 * Some examples are:
 * ```
 * ModelName = "choice('seresnext', 'resnest50')";
 * LearningRate = "uniform(0.001, 0.01)";
 * LayersToFreeze = "choice(0, 2)";
 * ```</example>
 * All distributions can be specified as distribution_name(min, max) or choice(val1, val2, ..., valn)
 * where distribution name can be: uniform, quniform, loguniform, etc
 * For more details on how to compose distribution expressions please check the documentation:
 * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-tune-hyperparameters
 * For more information on the available settings please visit the official documentation:
 * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
 */
model ImageModelDistributionSettings {
  /**
   * Enable AMSGrad when optimizer is 'adam' or 'adamw'.
   */
  amsGradient?: string;

  /**
   * Settings for using Augmentations.
   */
  augmentations?: string;

  /**
   * Value of 'beta1' when optimizer is 'adam' or 'adamw'. Must be a float in the range [0, 1].
   */
  beta1?: string;

  /**
   * Value of 'beta2' when optimizer is 'adam' or 'adamw'. Must be a float in the range [0, 1].
   */
  beta2?: string;

  /**
   * Whether to use distributer training.
   */
  distributed?: string;

  /**
   * Enable early stopping logic during training.
   */
  earlyStopping?: string;

  /**
   * Minimum number of epochs or validation evaluations to wait before primary metric improvement
   * is tracked for early stopping. Must be a positive integer.
   */
  earlyStoppingDelay?: string;

  /**
   * Minimum number of epochs or validation evaluations with no primary metric improvement before
   * the run is stopped. Must be a positive integer.
   */
  earlyStoppingPatience?: string;

  /**
   * Enable normalization when exporting ONNX model.
   */
  enableOnnxNormalization?: string;

  /**
   * Frequency to evaluate validation dataset to get metric scores. Must be a positive integer.
   */
  evaluationFrequency?: string;

  /**
   * Gradient accumulation means running a configured number of "GradAccumulationStep" steps without
   * updating the model weights while accumulating the gradients of those steps, and then using
   * the accumulated gradients to compute the weight updates. Must be a positive integer.
   */
  gradientAccumulationStep?: string;

  /**
   * Number of layers to freeze for the model. Must be a positive integer.
   * For instance, passing 2 as value for 'seresnext' means
   * freezing layer0 and layer1. For a full list of models supported and details on layer freeze, please
   * see: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
   */
  layersToFreeze?: string;

  /**
   * Initial learning rate. Must be a float in the range [0, 1].
   */
  learningRate?: string;

  /**
   * Type of learning rate scheduler. Must be 'warmup_cosine' or 'step'.
   */
  learningRateScheduler?: string;

  /**
   * Name of the model to use for training.
   * For more information on the available models please visit the official documentation:
   * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
   */
  modelName?: string;

  /**
   * Value of momentum when optimizer is 'sgd'. Must be a float in the range [0, 1].
   */
  momentum?: string;

  /**
   * Enable nesterov when optimizer is 'sgd'.
   */
  nesterov?: string;

  /**
   * Number of training epochs. Must be a positive integer.
   */
  numberOfEpochs?: string;

  /**
   * Number of data loader workers. Must be a non-negative integer.
   */
  numberOfWorkers?: string;

  /**
   * Type of optimizer. Must be either 'sgd', 'adam', or 'adamw'.
   */
  optimizer?: string;

  /**
   * Random seed to be used when using deterministic training.
   */
  randomSeed?: string;

  /**
   * Value of gamma when learning rate scheduler is 'step'. Must be a float in the range [0, 1].
   */
  stepLRGamma?: string;

  /**
   * Value of step size when learning rate scheduler is 'step'. Must be a positive integer.
   */
  stepLRStepSize?: string;

  /**
   * Training batch size. Must be a positive integer.
   */
  trainingBatchSize?: string;

  /**
   * Validation batch size. Must be a positive integer.
   */
  validationBatchSize?: string;

  /**
   * Value of cosine cycle when learning rate scheduler is 'warmup_cosine'. Must be a float in the range [0, 1].
   */
  warmupCosineLRCycles?: string;

  /**
   * Value of warmup epochs when learning rate scheduler is 'warmup_cosine'. Must be a positive integer.
   */
  warmupCosineLRWarmupEpochs?: string;

  /**
   * Value of weight decay when optimizer is 'sgd', 'adam', or 'adamw'. Must be a float in the range[0, 1].
   */
  weightDecay?: string;
}

/**
 * Abstract class for AutoML tasks that train image (computer vision) models -
 * such as Image Classification / Image Classification Multilabel / Image Object Detection / Image Instance Segmentation.
 */
model ImageVertical {
  /**
   * [Required] Limit settings for the AutoML job.
   */
  limitSettings: ImageLimitSettings;

  /**
   * Model sweeping and hyperparameter sweeping related settings.
   */
  sweepSettings?: ImageSweepSettings;

  /**
   * Validation data inputs.
   */
  validationData?: MLTableJobInput;

  /**
   * The fraction of training dataset that needs to be set aside for validation purpose.
   * Values between (0.0 , 1.0)
   * Applied when validation dataset is not provided.
   */
  validationDataSize?: float64;
}

/**
 * Limit settings for the AutoML job.
 */
model ImageLimitSettings {
  /**
   * Maximum number of concurrent AutoML iterations.
   */
  maxConcurrentTrials?: int32 = 1;

  /**
   * Maximum number of AutoML iterations.
   */
  maxTrials?: int32 = 1;

  /**
   * AutoML job timeout.
   */
  timeout?: duration;
}

/**
 * Model sweeping and hyperparameter sweeping related settings.
 */
model ImageSweepSettings {
  /**
   * Type of early termination policy.
   */
  earlyTermination?: EarlyTerminationPolicy;

  /**
   * [Required] Type of the hyperparameter sampling algorithms.
   */
  samplingAlgorithm: SamplingAlgorithmType;
}

/**
 * Image Classification Multilabel. Multi-label image classification is used when an image could have one or more labels
 * from a set of labels - e.g. an image could be labeled with both 'cat' and 'dog'.
 */
model ImageClassificationMultilabel extends AutoMLVertical {
  ...ImageClassificationBase;

  /**
   * Primary metric to optimize for this task.
   */
  primaryMetric?: ClassificationMultilabelPrimaryMetrics;

  /**
   * [Required] Task type for AutoMLJob.
   */
  taskType: "ImageClassificationMultilabel";
}

/**
 * Image Instance Segmentation. Instance segmentation is used to identify objects in an image at the pixel level,
 * drawing a polygon around each object in the image.
 */
model ImageInstanceSegmentation extends AutoMLVertical {
  ...ImageObjectDetectionBase;

  /**
   * Primary metric to optimize for this task.
   */
  primaryMetric?: InstanceSegmentationPrimaryMetrics;

  /**
   * [Required] Task type for AutoMLJob.
   */
  taskType: "ImageInstanceSegmentation";
}

model ImageObjectDetectionBase extends ImageVertical {
  /**
   * Settings used for training the model.
   */
  modelSettings?: ImageModelSettingsObjectDetection;

  /**
   * Search space for sampling different combinations of models and their hyperparameters.
   */
  searchSpace?: ImageModelDistributionSettingsObjectDetection[];
}

/**
 * Settings used for training the model.
 * For more information on the available settings please visit the official documentation:
 * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
 */
model ImageModelSettingsObjectDetection extends ImageModelSettings {
  /**
   * Maximum number of detections per image, for all classes. Must be a positive integer.
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  boxDetectionsPerImage?: int32;

  /**
   * During inference, only return proposals with a classification score greater than
   * BoxScoreThreshold. Must be a float in the range[0, 1].
   */
  boxScoreThreshold?: float32;

  /**
   * Image size for train and validation. Must be a positive integer.
   * Note: The training run may get into CUDA OOM if the size is too big.
   * Note: This settings is only supported for the 'yolov5' algorithm.
   */
  imageSize?: int32;

  /**
   * Enable computing and logging training metrics.
   */
  logTrainingMetrics?: LogTrainingMetrics;

  /**
   * Enable computing and logging validation loss.
   */
  logValidationLoss?: LogValidationLoss;

  /**
   * Maximum size of the image to be rescaled before feeding it to the backbone.
   * Must be a positive integer. Note: training run may get into CUDA OOM if the size is too big.
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  maxSize?: int32;

  /**
   * Minimum size of the image to be rescaled before feeding it to the backbone.
   * Must be a positive integer. Note: training run may get into CUDA OOM if the size is too big.
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  minSize?: int32;

  /**
   * Model size. Must be 'small', 'medium', 'large', or 'xlarge'.
   * Note: training run may get into CUDA OOM if the model size is too big.
   * Note: This settings is only supported for the 'yolov5' algorithm.
   */
  modelSize?: ModelSize;

  /**
   * Enable multi-scale image by varying image size by +/- 50%.
   * Note: training run may get into CUDA OOM if no sufficient GPU memory.
   * Note: This settings is only supported for the 'yolov5' algorithm.
   */
  multiScale?: boolean;

  /**
   * IOU threshold used during inference in NMS post processing. Must be a float in the range [0, 1].
   */
  nmsIouThreshold?: float32;

  /**
   * The grid size to use for tiling each image. Note: TileGridSize must not be
   * None to enable small object detection logic. A string containing two integers in mxn format.
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  tileGridSize?: string;

  /**
   * Overlap ratio between adjacent tiles in each dimension. Must be float in the range [0, 1).
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  tileOverlapRatio?: float32;

  /**
   * The IOU threshold to use to perform NMS while merging predictions from tiles and image.
   * Used in validation/ inference. Must be float in the range [0, 1].
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  tilePredictionsNmsThreshold?: float32;

  /**
   * IOU threshold to use when computing validation metric. Must be float in the range [0, 1].
   */
  validationIouThreshold?: float32;

  /**
   * Metric computation method to use for validation metrics.
   */
  validationMetricType?: ValidationMetricType;
}

/**
 * Distribution expressions to sweep over values of model settings.
 * <example>
 * Some examples are:
 * ```
 * ModelName = "choice('seresnext', 'resnest50')";
 * LearningRate = "uniform(0.001, 0.01)";
 * LayersToFreeze = "choice(0, 2)";
 * ```</example>
 * For more details on how to compose distribution expressions please check the documentation:
 * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-tune-hyperparameters
 * For more information on the available settings please visit the official documentation:
 * https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
 */
model ImageModelDistributionSettingsObjectDetection
  extends ImageModelDistributionSettings {
  /**
   * Maximum number of detections per image, for all classes. Must be a positive integer.
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  boxDetectionsPerImage?: string;

  /**
   * During inference, only return proposals with a classification score greater than
   * BoxScoreThreshold. Must be a float in the range[0, 1].
   */
  boxScoreThreshold?: string;

  /**
   * Image size for train and validation. Must be a positive integer.
   * Note: The training run may get into CUDA OOM if the size is too big.
   * Note: This settings is only supported for the 'yolov5' algorithm.
   */
  imageSize?: string;

  /**
   * Maximum size of the image to be rescaled before feeding it to the backbone.
   * Must be a positive integer. Note: training run may get into CUDA OOM if the size is too big.
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  maxSize?: string;

  /**
   * Minimum size of the image to be rescaled before feeding it to the backbone.
   * Must be a positive integer. Note: training run may get into CUDA OOM if the size is too big.
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  minSize?: string;

  /**
   * Model size. Must be 'small', 'medium', 'large', or 'xlarge'.
   * Note: training run may get into CUDA OOM if the model size is too big.
   * Note: This settings is only supported for the 'yolov5' algorithm.
   */
  modelSize?: string;

  /**
   * Enable multi-scale image by varying image size by +/- 50%.
   * Note: training run may get into CUDA OOM if no sufficient GPU memory.
   * Note: This settings is only supported for the 'yolov5' algorithm.
   */
  multiScale?: string;

  /**
   * IOU threshold used during inference in NMS post processing. Must be float in the range [0, 1].
   */
  nmsIouThreshold?: string;

  /**
   * The grid size to use for tiling each image. Note: TileGridSize must not be
   * None to enable small object detection logic. A string containing two integers in mxn format.
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  tileGridSize?: string;

  /**
   * Overlap ratio between adjacent tiles in each dimension. Must be float in the range [0, 1).
   * Note: This settings is not supported for the 'yolov5' algorithm.
   */
  tileOverlapRatio?: string;

  /**
   * The IOU threshold to use to perform NMS while merging predictions from tiles and image.
   * Used in validation/ inference. Must be float in the range [0, 1].
   * Note: This settings is not supported for the 'yolov5' algorithm.
   * NMS: Non-maximum suppression
   */
  tilePredictionsNmsThreshold?: string;

  /**
   * IOU threshold to use when computing validation metric. Must be float in the range [0, 1].
   */
  validationIouThreshold?: string;

  /**
   * Metric computation method to use for validation metrics. Must be 'none', 'coco', 'voc', or 'coco_voc'.
   */
  validationMetricType?: string;
}

/**
 * Image Object Detection. Object detection is used to identify objects in an image and locate each object with a
 * bounding box e.g. locate all dogs and cats in an image and draw a bounding box around each.
 */
model ImageObjectDetection extends AutoMLVertical {
  ...ImageObjectDetectionBase;

  /**
   * Primary metric to optimize for this task.
   */
  primaryMetric?: ObjectDetectionPrimaryMetrics;

  /**
   * [Required] Task type for AutoMLJob.
   */
  taskType: "ImageObjectDetection";
}

model ImportDataAction extends ScheduleActionBase {
  /**
   * [Required] Defines Schedule action definition details.
   */
  @visibility("read", "create", "update")
  dataImportDefinition: DataImport;

  /**
   * [Required] Specifies the action type of the schedule
   */
  actionType: "ImportData";
}

model JobScheduleAction extends ScheduleActionBase {
  /**
   * [Required] Defines Schedule action definition details.
   */
  @visibility("read", "create", "update")
  jobDefinition: JobBase;

  /**
   * [Required] Specifies the action type of the schedule
   */
  actionType: "CreateJob";
}

model KerberosCredentials {
  /**
   * [Required] IP Address or DNS HostName.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  kerberosKdcAddress: string;

  /**
   * [Required] Kerberos Username
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  kerberosPrincipal: string;

  /**
   * [Required] Domain over which a Kerberos authentication server has the authority to authenticate a user, host or service.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  kerberosRealm: string;
}

model KerberosKeytabCredentials extends DatastoreCredentials {
  ...KerberosCredentials;

  /**
   * [Required] Keytab secrets.
   */
  @visibility("create", "update")
  secrets: KerberosKeytabSecrets;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  credentialsType: "KerberosKeytab";
}

model KerberosKeytabSecrets extends DatastoreSecrets {
  /**
   * Kerberos keytab secret.
   */
  kerberosKeytab?: string;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  secretsType: "KerberosKeytab";
}

model KerberosPasswordCredentials extends DatastoreCredentials {
  ...KerberosCredentials;

  /**
   * [Required] Kerberos password secrets.
   */
  @visibility("create", "update")
  secrets: KerberosPasswordSecrets;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  credentialsType: "KerberosPassword";
}

model KerberosPasswordSecrets extends DatastoreSecrets {
  /**
   * Kerberos password secret.
   */
  kerberosPassword?: string;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  secretsType: "KerberosPassword";
}

/**
 * Properties specific to a KubernetesOnlineDeployment.
 */
model KubernetesOnlineDeployment extends OnlineDeployment {
  /**
   * The resource requirements for the container (cpu and memory).
   */
  containerResourceRequirements?: ContainerResourceRequirements;

  /**
   * [Required] The compute type of the endpoint.
   */
  endpointComputeType: "Kubernetes";
}

/**
 * Properties of a labeling job for image data
 */
model LabelingJobImageProperties extends LabelingJobMediaProperties {
  /**
   * Annotation type of image labeling job.
   */
  @visibility("read", "create")
  annotationType?: ImageAnnotationType;

  /**
   * [Required] Media type of the job.
   */
  mediaType: "Image";
}

/**
 * Properties of a labeling job for text data
 */
model LabelingJobTextProperties extends LabelingJobMediaProperties {
  /**
   * Annotation type of text labeling job.
   */
  @visibility("read", "create")
  annotationType?: TextAnnotationType;

  /**
   * [Required] Media type of the job.
   */
  mediaType: "Text";
}

model LakeHouseArtifact extends OneLakeArtifact {
  /**
   * [Required] OneLake artifact type
   */
  artifactType: "LakeHouse";
}

/**
 * OneLake artifact (data source) configuration.
 */
@discriminator("artifactType")
model OneLakeArtifact {
  /**
   * [Required] OneLake artifact name
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  artifactName: string;
}

/**
 * Literal input type.
 */
model LiteralJobInput extends JobInput {
  /**
   * [Required] Literal value for the input.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  value: string;

  /**
   * [Required] Specifies the type of job.
   */
  jobInputType: "literal";
}

/**
 * Labeling MLAssist configuration definition when MLAssist is disabled
 */
model MLAssistConfigurationDisabled extends MLAssistConfiguration {
  /**
   * [Required] Indicates whether MLAssist feature is enabled.
   */
  mlAssist: "Disabled";
}

/**
 * Labeling MLAssist configuration definition when MLAssist is enabled
 */
model MLAssistConfigurationEnabled extends MLAssistConfiguration {
  /**
   * [Required] AML compute binding used in inferencing.
   */
  @visibility("read", "create", "update")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  inferencingComputeBinding: string;

  /**
   * [Required] AML compute binding used in training.
   */
  @visibility("read", "create", "update")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  trainingComputeBinding: string;

  /**
   * [Required] Indicates whether MLAssist feature is enabled.
   */
  mlAssist: "Enabled";
}

model MLFlowModelJobOutput extends JobOutput {
  ...AssetJobOutput;

  /**
   * [Required] Specifies the type of job.
   */
  jobOutputType: "mlflow_model";
}

/**
 * MLTable data definition
 */
model MLTableData extends DataVersionBase {
  /**
   * Uris referenced in the MLTable definition (required for lineage)
   */
  @visibility("read", "create")
  referencedUris?: string[];

  /**
   * [Required] Specifies the type of data.
   */
  dataType: "mltable";
}

model MLTableJobOutput extends JobOutput {
  ...AssetJobOutput;

  /**
   * [Required] Specifies the type of job.
   */
  jobOutputType: "mltable";
}

/**
 * Managed compute identity definition.
 */
model ManagedComputeIdentity extends MonitorComputeIdentityBase {
  /**
   * Managed service identity (system assigned and/or user assigned identities)
   */
  identity?: Azure.ResourceManager.Foundations.ManagedServiceIdentity;

  /**
   * [Required] Monitor compute identity type enum.
   */
  computeIdentityType: "ManagedIdentity";
}

/**
 * Managed identity configuration.
 */
model ManagedIdentity extends IdentityConfiguration {
  /**
   * Specifies a user-assigned identity by client ID. For system-assigned, do not set this field.
   */
  @visibility("read", "create")
  clientId?: string;

  /**
   * Specifies a user-assigned identity by object ID. For system-assigned, do not set this field.
   */
  @visibility("read", "create")
  objectId?: string;

  /**
   * Specifies a user-assigned identity by ARM resource ID. For system-assigned, do not set this field.
   */
  @visibility("read", "create")
  resourceId?: string;

  /**
   * [Required] Specifies the type of identity framework.
   */
  identityType: "Managed";
}

/**
 * Properties specific to a ManagedOnlineDeployment.
 */
model ManagedOnlineDeployment extends OnlineDeployment {
  /**
   * [Required] The compute type of the endpoint.
   */
  endpointComputeType: "Managed";
}

/**
 * Defines an early termination policy based on running averages of the primary metric of all runs
 */
model MedianStoppingPolicy extends EarlyTerminationPolicy {
  /**
   * [Required] Name of policy configuration
   */
  policyType: "MedianStopping";
}

/**
 * Model performance signal definition.
 */
model ModelPerformanceSignal extends MonitoringSignalBase {
  /**
   * The data segment.
   */
  @visibility("read", "create")
  dataSegment?: MonitoringDataSegment;

  /**
   * [Required] A list of metrics to calculate and their associated thresholds.
   */
  @visibility("read", "create")
  metricThreshold: ModelPerformanceMetricThresholdBase;

  /**
   * [Required] The data produced by the production service which drift will be calculated for.
   */
  @visibility("read", "create")
  productionData: MonitoringInputDataBase[];

  /**
   * [Required] The data to calculate drift against.
   */
  @visibility("read", "create")
  referenceData: MonitoringInputDataBase;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  signalType: "ModelPerformance";
}

/**
 * Monitor serverless spark compute definition.
 */
model MonitorServerlessSparkCompute extends MonitorComputeConfigurationBase {
  /**
   * [Required] The identity scheme leveraged to by the spark jobs running on serverless Spark.
   */
  @visibility("read", "create")
  computeIdentity: MonitorComputeIdentityBase;

  /**
   * [Required] The instance type running the Spark job.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  instanceType: string;

  /**
   * [Required] The Spark runtime version.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  runtimeVersion: string;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  computeType: "ServerlessSpark";
}

/**
 * MPI distribution configuration.
 */
model Mpi extends DistributionConfiguration {
  /**
   * Number of processes per MPI node.
   */
  @visibility("read", "create")
  processCountPerInstance?: int32;

  /**
   * [Required] Specifies the type of distribution framework.
   */
  distributionType: "Mpi";
}

/**
 * Fixed training parameters that won't be swept over during AutoML NLP training.
 */
model NlpFixedParameters {
  /**
   * Number of steps to accumulate gradients over before running a backward pass.
   */
  gradientAccumulationSteps?: int32;

  /**
   * The learning rate for the training procedure.
   */
  learningRate?: float32;

  /**
   * The type of learning rate schedule to use during the training procedure.
   */
  learningRateScheduler?: NlpLearningRateScheduler;

  /**
   * The name of the model to train.
   */
  modelName?: string;

  /**
   * Number of training epochs.
   */
  numberOfEpochs?: int32;

  /**
   * The batch size for the training procedure.
   */
  trainingBatchSize?: int32;

  /**
   * The batch size to be used during evaluation.
   */
  validationBatchSize?: int32;

  /**
   * The warmup ratio, used alongside LrSchedulerType.
   */
  warmupRatio?: float32;

  /**
   * The weight decay for the training procedure.
   */
  weightDecay?: float32;
}

/**
 * Stringified search spaces for each parameter. See below examples.
 */
model NlpParameterSubspace {
  /**
   * Number of steps to accumulate gradients over before running a backward pass.
   */
  gradientAccumulationSteps?: string;

  /**
   * The learning rate for the training procedure.
   */
  learningRate?: string;

  /**
   * The type of learning rate schedule to use during the training procedure.
   */
  learningRateScheduler?: string;

  /**
   * The name of the model to train.
   */
  modelName?: string;

  /**
   * Number of training epochs.
   */
  numberOfEpochs?: string;

  /**
   * The batch size for the training procedure.
   */
  trainingBatchSize?: string;

  /**
   * The batch size to be used during evaluation.
   */
  validationBatchSize?: string;

  /**
   * The warmup ratio, used alongside LrSchedulerType.
   */
  warmupRatio?: string;

  /**
   * The weight decay for the training procedure.
   */
  weightDecay?: string;
}

/**
 * Model sweeping and hyperparameter tuning related settings.
 */
model NlpSweepSettings {
  /**
   * Type of early termination policy for the sweeping job.
   */
  earlyTermination?: EarlyTerminationPolicy;

  /**
   * [Required] Type of sampling algorithm.
   */
  samplingAlgorithm: SamplingAlgorithmType;
}

/**
 * Abstract class for NLP related AutoML tasks.
 * NLP - Natural Language Processing.
 */
model NlpVertical {
  /**
   * Featurization inputs needed for AutoML job.
   */
  featurizationSettings?: NlpVerticalFeaturizationSettings;

  /**
   * Model/training parameters that will remain constant throughout training.
   */
  fixedParameters?: NlpFixedParameters;

  /**
   * Execution constraints for AutoMLJob.
   */
  limitSettings?: NlpVerticalLimitSettings;

  /**
   * Search space for sampling different combinations of models and their hyperparameters.
   */
  searchSpace?: NlpParameterSubspace[];

  /**
   * Settings for model sweeping and hyperparameter tuning.
   */
  sweepSettings?: NlpSweepSettings;

  /**
   * Validation data inputs.
   */
  validationData?: MLTableJobInput;
}

model NlpVerticalFeaturizationSettings extends FeaturizationSettings {}

/**
 * Job execution constraints.
 */
model NlpVerticalLimitSettings {
  /**
   * Maximum Concurrent AutoML iterations.
   */
  maxConcurrentTrials?: int32 = 1;

  /**
   * Maximum nodes to use for the experiment.
   */
  maxNodes?: int32 = 1;

  /**
   * Number of AutoML iterations.
   */
  maxTrials?: int32 = 1;

  /**
   * AutoML job timeout.
   */
  timeout?: duration;

  /**
   * Timeout for individual HD trials.
   */
  trialTimeout?: duration;
}

/**
 * Empty/none datastore credentials.
 */
model NoneDatastoreCredentials extends DatastoreCredentials {
  /**
   * [Required] Credential type used to authentication with storage.
   */
  credentialsType: "None";
}

model NumericalDataDriftMetricThreshold extends DataDriftMetricThresholdBase {
  /**
   * [Required] The numerical data drift metric to calculate.
   */
  metric: NumericalDataDriftMetric;

  /**
   * [Required] Specifies the data type of the metric threshold.
   */
  dataType: "Numerical";
}

model NumericalDataQualityMetricThreshold
  extends DataQualityMetricThresholdBase {
  /**
   * [Required] The numerical data quality metric to calculate.
   */
  @visibility("read", "create")
  metric: NumericalDataQualityMetric;

  /**
   * [Required] Specifies the data type of the metric threshold.
   */
  dataType: "Numerical";
}

model NumericalPredictionDriftMetricThreshold
  extends PredictionDriftMetricThresholdBase {
  /**
   * [Required] The numerical prediction drift metric to calculate.
   */
  @visibility("read", "create")
  metric: NumericalPredictionDriftMetric;

  /**
   * [Required] Specifies the data type of the metric threshold.
   */
  dataType: "Numerical";
}

/**
 * Optimization objective.
 */
model Objective {
  /**
   * [Required] Defines supported metric goals for hyperparameter tuning
   */
  goal: Goal;

  /**
   * [Required] Name of the metric to optimize.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  primaryMetric: string;
}

/**
 * OneLake (Trident) datastore configuration.
 */
model OneLakeDatastore extends Datastore {
  /**
   * [Required] OneLake artifact backing the datastore.
   */
  @visibility("read", "create")
  artifact: OneLakeArtifact;

  /**
   * OneLake endpoint to use for the datastore.
   */
  @visibility("read", "create")
  endpoint?: string;

  /**
   * [Required] OneLake workspace name.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  oneLakeWorkspaceName: string;

  /**
   * Indicates which identity to use to authenticate service data access to customer's storage.
   */
  @visibility("read", "create")
  serviceDataAccessAuthIdentity?: ServiceDataAccessAuthIdentity;

  /**
   * [Required] Storage type backing the datastore.
   */
  datastoreType: "OneLake";
}

/**
 * Reference to an asset via its path in a job output.
 */
model OutputPathAssetReference extends AssetReferenceBase {
  /**
   * ARM resource ID of the job.
   */
  jobId?: string;

  /**
   * The path of the file/directory in the job output.
   */
  path?: string;

  /**
   * [Required] Specifies the type of asset reference.
   */
  referenceType: "OutputPath";
}

/**
 * Package input path specified with a resource id.
 */
model PackageInputPathId extends PackageInputPathBase {
  /**
   * Input resource id.
   */
  resourceId?: string;

  /**
   * [Required] Input path type for package inputs.
   */
  inputPathType: "PathId";
}

/**
 * Package input path specified as an url.
 */
model PackageInputPathUrl extends PackageInputPathBase {
  /**
   * Input path url.
   */
  url?: string;

  /**
   * [Required] Input path type for package inputs.
   */
  inputPathType: "Url";
}

/**
 * Package input path specified with name and version.
 */
model PackageInputPathVersion extends PackageInputPathBase {
  /**
   * Input resource name.
   */
  resourceName?: string;

  /**
   * Input resource version.
   */
  resourceVersion?: string;

  /**
   * [Required] Input path type for package inputs.
   */
  inputPathType: "PathVersion";
}

/**
 * Pipeline Job definition: defines generic to MFE attributes.
 */
model PipelineJob extends JobBase {
  /**
   * Inputs for the pipeline job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  inputs?: Record<JobInput>;

  /**
   * Jobs construct the Pipeline Job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  jobs?: Record<Record<unknown>>;

  /**
   * Outputs for the pipeline job
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  outputs?: Record<JobOutput>;

  /**
   * Pipeline settings, for things like ContinueRunOnStepFailure etc.
   */
  @visibility("read", "create")
  settings?: Record<unknown>;

  /**
   * ARM resource ID of source job.
   */
  @visibility("read", "create")
  sourceJobId?: string;

  /**
   * [Required] Specifies the type of job.
   */
  jobType: "Pipeline";
}

model PredictionDriftMonitoringSignal extends MonitoringSignalBase {
  /**
   * [Required] A list of metrics to calculate and their associated thresholds.
   */
  @visibility("read", "create")
  metricThresholds: PredictionDriftMetricThresholdBase[];

  /**
   * [Required] The type of the model monitored.
   */
  @visibility("read", "create")
  modelType: MonitoringModelType;

  /**
   * [Required] The data which drift will be calculated for.
   */
  @visibility("read", "create")
  productionData: MonitoringInputDataBase;

  /**
   * [Required] The data to calculate drift against.
   */
  @visibility("read", "create")
  referenceData: MonitoringInputDataBase;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  signalType: "PredictionDrift";
}

/**
 * PyTorch distribution configuration.
 */
model PyTorch extends DistributionConfiguration {
  /**
   * Number of processes per node.
   */
  processCountPerInstance?: int32;

  /**
   * [Required] Specifies the type of distribution framework.
   */
  distributionType: "PyTorch";
}

/**
 * Defines a Sampling Algorithm that generates values randomly
 */
model RandomSamplingAlgorithm extends SamplingAlgorithm {
  /**
   * An optional positive number or e in string format to be used as base for log based random sampling
   */
  logbase?: string;

  /**
   * The specific type of random algorithm
   */
  rule?: RandomSamplingAlgorithmRule;

  /**
   * An optional integer to use as the seed for random number generation
   */
  seed?: int32;

  /**
   * [Required] The algorithm used for generating hyperparameter values, along with configuration properties
   */
  samplingAlgorithmType: "Random";
}

/**
 * Ray distribution configuration.
 */
model Ray extends DistributionConfiguration {
  /**
   * The address of Ray head node.
   */
  address?: string;

  /**
   * The port to bind the dashboard server to.
   */
  dashboardPort?: int32;

  /**
   * Additional arguments passed to ray start in head node.
   */
  headNodeAdditionalArgs?: string;

  /**
   * Provide this argument to start the Ray dashboard GUI.
   */
  includeDashboard?: boolean;

  /**
   * The port of the head ray process.
   */
  port?: int32;

  /**
   * Additional arguments passed to ray start in worker node.
   */
  workerNodeAdditionalArgs?: string;

  /**
   * [Required] Specifies the type of distribution framework.
   */
  distributionType: "Ray";
}

/**
 * Regression task in AutoML Table vertical.
 */
model Regression extends AutoMLVertical {
  ...TableVertical;

  /**
   * Primary metric for regression task.
   */
  primaryMetric?: RegressionPrimaryMetrics;

  /**
   * Inputs for training phase for an AutoML Job.
   */
  trainingSettings?: RegressionTrainingSettings;

  /**
   * [Required] Task type for AutoMLJob.
   */
  taskType: "Regression";
}

/**
 * Regression Training related configuration.
 */
model RegressionTrainingSettings extends TrainingSettings {
  /**
   * Allowed models for regression task.
   */
  allowedTrainingAlgorithms?: RegressionModels[];

  /**
   * Blocked models for regression task.
   */
  blockedTrainingAlgorithms?: RegressionModels[];
}

model RegressionModelPerformanceMetricThreshold
  extends ModelPerformanceMetricThresholdBase {
  /**
   * [Required] The regression model performance metric to calculate.
   */
  @visibility("read", "create")
  metric: RegressionModelPerformanceMetric;

  /**
   * [Required] Specifies the data type of the metric threshold.
   */
  modelType: "Regression";
}

model SASCredentialDto extends PendingUploadCredentialDto {
  /**
   * Full SAS Uri, including the storage, container/blob path and SAS token
   */
  sasUri?: url;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  credentialType: "SAS";
}

/**
 * SAS datastore credentials configuration.
 */
model SasDatastoreCredentials extends DatastoreCredentials {
  /**
   * [Required] Storage container secrets.
   */
  @visibility("create", "update")
  secrets: SasDatastoreSecrets;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  credentialsType: "Sas";
}

/**
 * Datastore SAS secrets.
 */
model SasDatastoreSecrets extends DatastoreSecrets {
  /**
   * Storage container SAS token.
   */
  sasToken?: string;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  secretsType: "Sas";
}

/**
 * Service Principal datastore credentials configuration.
 */
model ServicePrincipalDatastoreCredentials extends DatastoreCredentials {
  /**
   * Authority URL used for authentication.
   */
  authorityUrl?: string;

  /**
   * [Required] Service principal client ID.
   */
  clientId: string;

  /**
   * Resource the service principal has access to.
   */
  resourceUrl?: string;

  /**
   * [Required] Service principal secrets.
   */
  @visibility("create", "update")
  secrets: ServicePrincipalDatastoreSecrets;

  /**
   * [Required] ID of the tenant to which the service principal belongs.
   */
  tenantId: string;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  credentialsType: "ServicePrincipal";
}

/**
 * Datastore Service Principal secrets.
 */
model ServicePrincipalDatastoreSecrets extends DatastoreSecrets {
  /**
   * Service principal secret.
   */
  clientSecret?: string;

  /**
   * [Required] Credential type used to authentication with storage.
   */
  secretsType: "ServicePrincipal";
}

/**
 * Spark job definition.
 */
model SparkJob extends JobBase {
  /**
   * Archive files used in the job.
   */
  @visibility("read", "create")
  archives?: string[];

  /**
   * Arguments for the job.
   */
  @visibility("read", "create")
  args?: string;

  /**
   * [Required] ARM resource ID of the code asset.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  codeId: string;

  /**
   * Spark configured properties.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  conf?: Record<string>;

  /**
   * [Required] The entry to execute on startup of the job.
   */
  @visibility("read", "create")
  entry: SparkJobEntry;

  /**
   * The ARM resource ID of the Environment specification for the job.
   */
  @visibility("read", "create")
  environmentId?: string;

  /**
   * Files used in the job.
   */
  @visibility("read", "create")
  files?: string[];

  /**
   * Mapping of input data bindings used in the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  inputs?: Record<JobInput>;

  /**
   * Jar files used in the job.
   */
  @visibility("read", "create")
  jars?: string[];

  /**
   * Mapping of output data bindings used in the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  outputs?: Record<JobOutput>;

  /**
   * Python files used in the job.
   */
  @visibility("read", "create")
  pyFiles?: string[];

  /**
   * Queue settings for the job
   */
  @visibility("read", "create")
  queueSettings?: QueueSettings;

  /**
   * Compute Resource configuration for the job.
   */
  @visibility("read", "create")
  resources?: SparkResourceConfiguration;

  /**
   * [Required] Specifies the type of job.
   */
  jobType: "Spark";
}

/**
 * Spark job entry point definition.
 */
@discriminator("sparkJobEntryType")
model SparkJobEntry {}

model SparkResourceConfiguration {
  /**
   * Optional type of VM used as supported by the compute target.
   */
  @visibility("read", "create")
  instanceType?: string;

  /**
   * Version of spark runtime used for the job.
   */
  @visibility("read", "create")
  runtimeVersion?: string = "3.1";
}

model SparkJobPythonEntry extends SparkJobEntry {
  /**
   * [Required] Relative python file path for job entry point.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  file: string;

  /**
   * [Required] Type of the job's entry point.
   */
  sparkJobEntryType: "SparkJobPythonEntry";
}

model SparkJobScalaEntry extends SparkJobEntry {
  /**
   * [Required] Scala class name used as entry point.
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  className: string;

  /**
   * [Required] Type of the job's entry point.
   */
  sparkJobEntryType: "SparkJobScalaEntry";
}

/**
 * Static input data definition.
 */
model StaticInputData extends MonitoringInputDataBase {
  /**
   * The ARM resource ID of the component resource used to preprocess the data.
   */
  @visibility("read", "create")
  preprocessingComponentId?: string;

  /**
   * [Required] The end date of the data window.
   */
  @visibility("read", "create")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  windowEnd: utcDateTime;

  /**
   * [Required] The start date of the data window.
   */
  @visibility("read", "create")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  windowStart: utcDateTime;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  inputDataType: "Static";
}

/**
 * Sweep job definition.
 */
model SweepJob extends JobBase {
  /**
   * Early termination policies enable canceling poor-performing runs before they complete
   */
  earlyTermination?: EarlyTerminationPolicy;

  /**
   * Mapping of input data bindings used in the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  inputs?: Record<JobInput>;

  /**
   * Sweep Job limit.
   */
  @visibility("read", "create")
  limits?: SweepJobLimits;

  /**
   * [Required] Optimization objective.
   */
  objective: Objective;

  /**
   * Mapping of output data bindings used in the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  outputs?: Record<JobOutput>;

  /**
   * Queue settings for the job
   */
  @visibility("read", "create")
  queueSettings?: QueueSettings;

  /**
   * [Required] The hyperparameter sampling algorithm
   */
  samplingAlgorithm: SamplingAlgorithm;

  /**
   * [Required] A dictionary containing each parameter and its distribution. The dictionary key is the name of the parameter
   */
  searchSpace: Record<unknown>;

  /**
   * [Required] Trial component definition.
   */
  trial: TrialComponent;

  /**
   * [Required] Specifies the type of job.
   */
  jobType: "Sweep";
}

/**
 * Sweep Job limit class.
 */
model SweepJobLimits extends JobLimits {
  /**
   * Sweep Job max concurrent trials.
   */
  maxConcurrentTrials?: int32;

  /**
   * Sweep Job max total trials.
   */
  maxTotalTrials?: int32;

  /**
   * Sweep Job Trial timeout value.
   */
  trialTimeout?: duration;

  /**
   * [Required] JobLimit type.
   */
  jobLimitsType: "Sweep";
}

/**
 * Trial component definition.
 */
model TrialComponent {
  /**
   * ARM resource ID of the code asset.
   */
  @visibility("read", "create")
  codeId?: string;

  /**
   * [Required] The command to execute on startup of the job. eg. "python train.py"
   */
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  command: string;

  /**
   * Distribution configuration of the job. If set, this should be one of Mpi, Tensorflow, PyTorch, or null.
   */
  @visibility("read", "create")
  distribution?: DistributionConfiguration;

  /**
   * [Required] The ARM resource ID of the Environment specification for the job.
   */
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  environmentId: string;

  /**
   * Environment variables included in the job.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  @visibility("read", "create")
  environmentVariables?: Record<string>;

  /**
   * Compute Resource configuration for the job.
   */
  @visibility("read", "create")
  resources?: JobResourceConfiguration;
}

model TargetUtilizationScaleSettings extends OnlineScaleSettings {
  /**
   * The maximum number of instances that the deployment can scale to. The quota will be reserved for max_instances.
   */
  maxInstances?: int32 = 1;

  /**
   * The minimum number of instances to always be present.
   */
  minInstances?: int32 = 1;

  /**
   * The polling interval in ISO 8691 format. Only supports duration with precision as low as Seconds.
   */
  pollingInterval?: duration;

  /**
   * Target CPU usage for the autoscaler.
   */
  targetUtilizationPercentage?: int32 = 70;

  /**
   * [Required] Type of deployment scaling algorithm
   */
  scaleType: "TargetUtilization";
}

/**
 * TensorFlow distribution configuration.
 */
model TensorFlow extends DistributionConfiguration {
  /**
   * Number of parameter server tasks.
   */
  @visibility("read", "create")
  parameterServerCount?: int32;

  /**
   * Number of workers. If not specified, will default to the instance count.
   */
  @visibility("read", "create")
  workerCount?: int32;

  /**
   * [Required] Specifies the type of distribution framework.
   */
  distributionType: "TensorFlow";
}

/**
 * Text Classification task in AutoML NLP vertical.
 * NLP - Natural Language Processing.
 */
model TextClassification extends AutoMLVertical {
  ...NlpVertical;

  /**
   * Primary metric for Text-Classification task.
   */
  primaryMetric?: ClassificationPrimaryMetrics;

  /**
   * [Required] Task type for AutoMLJob.
   */
  taskType: "TextClassification";
}

/**
 * Text Classification Multilabel task in AutoML NLP vertical.
 * NLP - Natural Language Processing.
 */
model TextClassificationMultilabel extends AutoMLVertical {
  ...NlpVertical;

  /**
   * Primary metric for Text-Classification-Multilabel task.
   * Currently only Accuracy is supported as primary metric, hence user need not set it explicitly.
   */
  @visibility("read")
  primaryMetric?: ClassificationMultilabelPrimaryMetrics;

  /**
   * [Required] Task type for AutoMLJob.
   */
  taskType: "TextClassificationMultilabel";
}

/**
 * Text-NER task in AutoML NLP vertical.
 * NER - Named Entity Recognition.
 * NLP - Natural Language Processing.
 */
model TextNer extends AutoMLVertical {
  ...NlpVertical;

  /**
   * Primary metric for Text-NER task.
   * Only 'Accuracy' is supported for Text-NER, so user need not set this explicitly.
   */
  @visibility("read")
  primaryMetric?: ClassificationPrimaryMetrics;

  /**
   * [Required] Task type for AutoMLJob.
   */
  taskType: "TextNER";
}

model TopNFeaturesByAttribution extends MonitoringFeatureFilterBase {
  /**
   * The number of top features to include.
   */
  @visibility("read", "create")
  top?: int32 = 10;

  /**
   * [Required] Specifies the feature filter to leverage when selecting features to calculate metrics over.
   */
  filterType: "TopNByAttribution";
}

/**
 * Trailing input data definition.
 */
model TrailingInputData extends MonitoringInputDataBase {
  /**
   * The ARM resource ID of the component resource used to preprocess the data.
   */
  @visibility("read", "create")
  preprocessingComponentId?: string;

  /**
   * [Required] The time offset between the end of the data window and the monitor's current run time.
   */
  @visibility("read", "create")
  windowOffset: duration;

  /**
   * [Required] The size of the trailing data window.
   */
  @visibility("read", "create")
  windowSize: duration;

  /**
   * [Required] Specifies the type of signal to monitor.
   */
  inputDataType: "Trailing";
}

/**
 * Triton inferencing server configurations.
 */
model TritonInferencingServer extends InferencingServer {
  /**
   * Inference configuration for Triton.
   */
  inferenceConfiguration?: OnlineInferenceConfiguration;

  /**
   * [Required] Inferencing server type for various targets.
   */
  serverType: "Triton";
}

model TritonModelJobInput extends JobInput {
  ...AssetJobInput;

  /**
   * [Required] Specifies the type of job.
   */
  jobInputType: "triton_model";
}

model TritonModelJobOutput extends JobOutput {
  ...AssetJobOutput;

  /**
   * [Required] Specifies the type of job.
   */
  jobOutputType: "triton_model";
}

/**
 * Defines an early termination policy that cancels a given percentage of runs at each evaluation interval.
 */
model TruncationSelectionPolicy extends EarlyTerminationPolicy {
  /**
   * The percentage of runs to cancel at each evaluation interval.
   */
  truncationPercentage?: int32;

  /**
   * [Required] Name of policy configuration
   */
  policyType: "TruncationSelection";
}

/**
 * uri-file data version entity
 */
model UriFileDataVersion extends DataVersionBase {
  /**
   * [Required] Specifies the type of data.
   */
  dataType: "uri_file";
}

model UriFileJobInput extends JobInput {
  ...AssetJobInput;

  /**
   * [Required] Specifies the type of job.
   */
  jobInputType: "uri_file";
}

model UriFileJobOutput extends JobOutput {
  ...AssetJobOutput;

  /**
   * [Required] Specifies the type of job.
   */
  jobOutputType: "uri_file";
}

/**
 * uri-folder data version entity
 */
model UriFolderDataVersion extends DataVersionBase {
  /**
   * [Required] Specifies the type of data.
   */
  dataType: "uri_folder";
}

model UriFolderJobInput extends JobInput {
  ...AssetJobInput;

  /**
   * [Required] Specifies the type of job.
   */
  jobInputType: "uri_folder";
}

model UriFolderJobOutput extends JobOutput {
  ...AssetJobOutput;

  /**
   * [Required] Specifies the type of job.
   */
  jobOutputType: "uri_folder";
}

/**
 * User identity configuration.
 */
model UserIdentity extends IdentityConfiguration {
  /**
   * [Required] Specifies the type of identity framework.
   */
  identityType: "UserIdentity";
}

model AccessKeyAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionAccessKey;

  /**
   * Authentication type of the connection target
   */
  authType: "AccessKey";
}

model WorkspaceConnectionAccessKey {
  accessKeyId?: string;
  secretAccessKey?: string;
}

/**
 * This connection type covers the generic ApiKey auth connection categories, for examples:
 * AzureOpenAI:
 *     Category:= AzureOpenAI
 *     AuthType:= ApiKey (as type discriminator)
 *     Credentials:= {ApiKey} as Microsoft.MachineLearning.AccountRP.Contracts.WorkspaceConnection.ApiKey
 *     Target:= {ApiBase}
 *
 * CognitiveService:
 *     Category:= CognitiveService
 *     AuthType:= ApiKey (as type discriminator)
 *     Credentials:= {SubscriptionKey} as Microsoft.MachineLearning.AccountRP.Contracts.WorkspaceConnection.ApiKey
 *     Target:= ServiceRegion={serviceRegion}
 *
 * CognitiveSearch:
 *     Category:= CognitiveSearch
 *     AuthType:= ApiKey (as type discriminator)
 *     Credentials:= {Key} as Microsoft.MachineLearning.AccountRP.Contracts.WorkspaceConnection.ApiKey
 *     Target:= {Endpoint}
 *
 * Use Metadata property bag for ApiType, ApiVersion, Kind and other metadata fields
 */
model ApiKeyAuthWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  /**
   * Api key object for workspace connection credential.
   */
  credentials?: WorkspaceConnectionApiKey;

  /**
   * Authentication type of the connection target
   */
  authType: "ApiKey";
}

/**
 * Api key object for workspace connection credential.
 */
model WorkspaceConnectionApiKey {
  key?: string;
}

/**
 * Custom Keys credential object
 */
model CustomKeys {
  /**
   * Dictionary of <string>
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-no-record" "For backward compatibility"
  keys?: Record<string>;
}

/**
 * Category:= CustomKeys
 * AuthType:= CustomKeys (as type discriminator)
 * Credentials:= {CustomKeys} as Microsoft.MachineLearning.AccountRP.Contracts.WorkspaceConnection.CustomKeys
 * Target:= {any value}
 * Use Metadata property bag for ApiVersion and other metadata fields
 */
model CustomKeysWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  /**
   * Custom Keys credential object
   */
  credentials?: CustomKeys;

  /**
   * Authentication type of the connection target
   */
  authType: "CustomKeys";
}

/**
 * FQDN Outbound Rule for the managed network of a machine learning workspace.
 */
model FqdnOutboundRule extends OutboundRule {
  destination?: string;

  /**
   * Type of a managed network Outbound Rule of a machine learning workspace.
   */
  type: "FQDN";
}

model ManagedIdentityAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionManagedIdentity;

  /**
   * Authentication type of the connection target
   */
  authType: "ManagedIdentity";
}

model WorkspaceConnectionManagedIdentity {
  clientId?: string;
  resourceId?: string;
}

model NoneAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  /**
   * Authentication type of the connection target
   */
  authType: "None";
}

model PATAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionPersonalAccessToken;

  /**
   * Authentication type of the connection target
   */
  authType: "PAT";
}

model WorkspaceConnectionPersonalAccessToken {
  pat?: string;
}

/**
 * Private Endpoint destination for a Private Endpoint Outbound Rule for the managed network of a machine learning workspace.
 */
model PrivateEndpointDestination {
  serviceResourceId?: string;
  sparkEnabled?: boolean;

  /**
   * Type of a managed network Outbound Rule of a machine learning workspace.
   */
  sparkStatus?: RuleStatus;

  subresourceTarget?: string;
}

/**
 * Private Endpoint Outbound Rule for the managed network of a machine learning workspace.
 */
model PrivateEndpointOutboundRule extends OutboundRule {
  /**
   * Private Endpoint destination for a Private Endpoint Outbound Rule for the managed network of a machine learning workspace.
   */
  destination?: PrivateEndpointDestination;

  /**
   * Type of a managed network Outbound Rule of a machine learning workspace.
   */
  type: "PrivateEndpoint";
}

model SASAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionSharedAccessSignature;

  /**
   * Authentication type of the connection target
   */
  authType: "SAS";
}

model WorkspaceConnectionSharedAccessSignature {
  sas?: string;
}

model ServicePrincipalAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionServicePrincipal;

  /**
   * Authentication type of the connection target
   */
  authType: "ServicePrincipal";
}

model WorkspaceConnectionServicePrincipal {
  clientId?: string;
  clientSecret?: string;
  tenantId?: string;
}

/**
 * Service Tag destination for a Service Tag Outbound Rule for the managed network of a machine learning workspace.
 */
model ServiceTagDestination {
  /**
   * The action enum for networking rule.
   */
  action?: RuleAction;

  /**
   * Optional, if provided, the ServiceTag property will be ignored.
   */
  @visibility("read")
  addressPrefixes?: string[];

  portRanges?: string;
  protocol?: string;
  serviceTag?: string;
}

/**
 * Service Tag Outbound Rule for the managed network of a machine learning workspace.
 */
model ServiceTagOutboundRule extends OutboundRule {
  /**
   * Service Tag destination for a Service Tag Outbound Rule for the managed network of a machine learning workspace.
   */
  destination?: ServiceTagDestination;

  /**
   * Type of a managed network Outbound Rule of a machine learning workspace.
   */
  type: "ServiceTag";
}

model UsernamePasswordAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionUsernamePassword;

  /**
   * Authentication type of the connection target
   */
  authType: "UsernamePassword";
}

model WorkspaceConnectionUsernamePassword {
  password?: string;
  username?: string;
}
