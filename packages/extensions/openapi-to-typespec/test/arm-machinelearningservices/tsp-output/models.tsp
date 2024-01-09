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

enum UsageUnit {
  Count,
}

enum BillingCurrency {
  USD,
}

enum UnitOfMeasure {
  OneHour,
}

enum VMPriceOSType {
  Linux,
  Windows,
}

enum VMTier {
  Standard,
  LowPriority,
  Spot,
}

enum QuotaUnit {
  Count,
}

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

enum ManagedServiceIdentityType {
  None,
  SystemAssigned,
  UserAssigned,
  `SystemAssigned,UserAssigned`,
}

enum CreatedByType {
  User,
  Application,
  ManagedIdentity,
  Key,
}

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

enum ImageType {
  docker,
  azureml,
}

enum EnvironmentVariableType {
  local,
}

enum Protocol {
  tcp,
  udp,
  http,
}

enum VolumeDefinitionType {
  bind,
  volume,
  tmpfs,
  npipe,
}

enum NodeState {
  idle,
  running,
  preparing,
  unusable,
  leaving,
  preempted,
}

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

enum PendingUploadType {
  None,
  TemporaryBlobReference,
}

enum PendingUploadCredentialType {
  SAS,
}

enum ListViewType {
  ActiveOnly,
  ArchivedOnly,
  All,
}

enum DataType {
  uri_file,
  uri_folder,
  mltable,
}

enum ProtectionLevel {
  @doc("All means Intellectual Property is fully protected.") All,
  @doc("None means it is not an Intellectual Property.") None,
}

enum AutoRebuildSetting {
  Disabled,
  OnBaseImageUpdate,
}

enum EnvironmentType {
  Curated,
  UserCreated,
}

enum OperatingSystemType {
  Linux,
  Windows,
}

enum BaseEnvironmentSourceType {
  EnvironmentAsset,
}

enum InferencingServerType {
  AzureMLOnline,
  AzureMLBatch,
  Triton,
  Custom,
}

enum PackageInputType {
  UriFile,
  UriFolder,
}

enum PackageInputDeliveryMode {
  Copy,
  Download,
}

enum InputPathType {
  Url,
  PathId,
  PathVersion,
}

enum PackageBuildState {
  NotStarted,
  Running,
  Succeeded,
  Failed,
}

enum EndpointProvisioningState {
  Creating,
  Deleting,
  Succeeded,
  Failed,
  Updating,
  Canceled,
}

enum EndpointAuthMode {
  AMLToken,
  Key,
  AADToken,
}

enum BatchDeploymentConfigurationType {
  Model,
  PipelineComponent,
}

enum BatchLoggingLevel {
  Info,
  Warning,
  Debug,
}

enum ReferenceType {
  Id,
  DataPath,
  OutputPath,
}

enum BatchOutputAction {
  SummaryOnly,
  AppendRow,
}

enum DeploymentProvisioningState {
  Creating,
  Deleting,
  Scaling,
  Updating,
  Succeeded,
  Failed,
  Canceled,
}

enum CredentialsType {
  AccountKey,
  Certificate,
  None,
  Sas,
  ServicePrincipal,
  KerberosKeytab,
  KerberosPassword,
}

enum DatastoreType {
  AzureBlob,
  AzureDataLakeGen1,
  AzureDataLakeGen2,
  AzureFile,
  Hdfs,
  OneLake,
}

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

enum EmailNotificationEnableType {
  JobCompleted,
  JobFailed,
  JobCancelled,
}

enum WebhookType {
  AzureDevOps,
}

enum RecurrenceFrequency {
  @doc("Minute frequency") Minute,
  @doc("Hour frequency") Hour,
  @doc("Day frequency") Day,
  @doc("Week frequency") Week,
  @doc("Month frequency") Month,
}

enum WeekDay {
  @doc("Monday weekday") Monday,
  @doc("Tuesday weekday") Tuesday,
  @doc("Wednesday weekday") Wednesday,
  @doc("Thursday weekday") Thursday,
  @doc("Friday weekday") Friday,
  @doc("Saturday weekday") Saturday,
  @doc("Sunday weekday") Sunday,
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

enum JobStatus {
  @doc("Run hasn't started yet.") NotStarted,
  @doc("Run has started. The user has a run ID.") Starting,
  @doc("(Not used currently) It will be used if ES is creating the compute target.")
  Provisioning,
  @doc("The run environment is being prepared.") Preparing,
  @doc("The job is queued in the compute target. For example, in BatchAI the job is in queued state, while waiting for all required nodes to be ready.")
  Queued,
  @doc("The job started to run in the compute target.") Running,
  @doc("Job is completed in the target. It is in output collection state now.")
  Finalizing,
  @doc("Cancellation has been requested for the job.") CancelRequested,
  @doc("Job completed successfully. This reflects that both the job itself and output collection states completed successfully")
  Completed,
  @doc("Job failed.") Failed,
  @doc("Following cancellation request, the job is now successfully canceled.")
  Canceled,
  @doc("""
When heartbeat is enabled, if the run isn't updating any information to RunHistory then the run goes to NotResponding state.
NotResponding is the only state that is exempt from strict transition orders. A run can go from NotResponding to any of the previous states.
""")
  NotResponding,
  @doc("The job is paused by users. Some adjustment to labeling jobs can be made only in paused state.")
  Paused,
  @doc("Default job status if not mapped to all other statuses") Unknown,
  @doc("The job is in a scheduled state. Job is not in any active state.")
  Scheduled,
}

enum FeaturestoreJobType {
  RecurrentMaterialization,
  BackfillMaterialization,
}

enum IdentityConfigurationType {
  Managed,
  AMLToken,
  UserIdentity,
}

enum JobType {
  AutoML,
  Command,
  Labeling,
  Sweep,
  Pipeline,
  Spark,
}

enum NodesValueType {
  All,
  Custom,
}

enum IncrementalDataRefresh {
  Enabled,
  Disabled,
}

enum MultiSelect {
  Enabled,
  Disabled,
}

enum MediaType {
  Image,
  Text,
}

enum MLAssistConfigurationType {
  Enabled,
  Disabled,
}

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

enum ExportFormatType {
  Dataset,
  Coco,
  CSV,
}

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

enum EgressPublicNetworkAccessType {
  Enabled,
  Disabled,
}

enum ScaleType {
  Default,
  TargetUtilization,
}

enum ContainerType {
  @doc("The container used to download models and score script.")
  StorageInitializer,
  @doc("The container used to serve user's request.") InferenceServer,
  @doc("The container used to collect payload and custom logging when mdc is enabled.")
  ModelDataCollector,
}

enum SkuScaleType {
  @doc("Automatically scales node count.") Automatic,
  @doc("Node count scaled upon user request.") Manual,
  @doc("Fixed set of nodes.") None,
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

enum EndpointServiceConnectionStatus {
  Approved,
  Pending,
  Rejected,
  Disconnected,
  Timeout,
}

enum EncryptionStatus {
  Enabled,
  Disabled,
}

enum IsolationMode {
  Disabled,
  AllowInternetOutbound,
  AllowOnlyApprovedOutbound,
}

enum RuleCategory {
  Required,
  Recommended,
  UserDefined,
}

enum RuleStatus {
  Inactive,
  Active,
}

enum RuleType {
  FQDN,
  PrivateEndpoint,
  ServiceTag,
}

enum ManagedNetworkStatus {
  Inactive,
  Active,
}

enum PrivateEndpointConnectionProvisioningState {
  Succeeded,
  Creating,
  Deleting,
  Failed,
}

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

enum DiagnoseResultLevel {
  Warning,
  Error,
  Information,
}

enum ClusterPurpose {
  FastProd,
  DenseProd,
  DevTest,
}

enum SslConfigStatus {
  Disabled,
  Enabled,
  Auto,
}

enum LoadBalancerType {
  PublicIp,
  InternalLoadBalancer,
}

enum OsType {
  Linux,
  Windows,
}

enum VmPriority {
  Dedicated,
  LowPriority,
}

enum RemoteLoginPortPublicAccess {
  Enabled,
  Disabled,
  NotSpecified,
}

enum AllocationState {
  Steady,
  Resizing,
}

enum ApplicationSharingPolicy {
  Personal,
  Shared,
}

enum MlflowAutologger {
  Enabled,
  Disabled,
}

enum SshPublicAccess {
  Enabled,
  Disabled,
}

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

enum ComputeInstanceAuthorizationType {
  personal,
}

enum OperationName {
  Create,
  Start,
  Stop,
  Restart,
  Reimage,
  Delete,
}

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

enum OperationTrigger {
  User,
  Schedule,
  IdleShutdown,
}

enum ProvisioningStatus {
  Completed,
  Provisioning,
  Failed,
}

enum ScheduleStatus {
  Enabled,
  Disabled,
}

enum ComputePowerAction {
  Start,
  Stop,
}

enum ScheduleProvisioningState {
  Completed,
  Provisioning,
  Failed,
}

enum Autosave {
  None,
  Local,
  Remote,
}

enum Network {
  Bridge,
  Host,
}

enum Caching {
  None,
  ReadOnly,
  ReadWrite,
}

enum StorageAccountType {
  Standard_LRS,
  Premium_LRS,
}

enum SourceType {
  Dataset,
  Datastore,
  URI,
}

enum MountAction {
  Mount,
  Unmount,
}

enum MountState {
  MountRequested,
  Mounted,
  MountFailed,
  UnmountRequested,
  UnmountFailed,
  Unmounted,
}

enum MonitoringFeatureFilterType {
  @doc("Includes all features.") AllFeatures,
  @doc("Only includes the top contributing features, measured by feature attribution.")
  TopNByAttribution,
  @doc("Includes a user-defined subset of features.") FeatureSubset,
}

enum MonitorComputeIdentityType {
  @doc("Authenticates through user's AML token.") AmlToken,
  @doc("Authenticates through a user-provided managed identity.")
  ManagedIdentity,
}

enum InputDeliveryMode {
  ReadOnlyMount,
  ReadWriteMount,
  Download,
  Direct,
  EvalMount,
  EvalDownload,
}

enum OutputDeliveryMode {
  ReadWriteMount,
  Upload,
  Direct,
}

enum ForecastHorizonMode {
  @doc("Forecast horizon to be determined automatically.") Auto,
  @doc("Use the custom forecast horizon.") Custom,
}

enum JobOutputType {
  uri_file,
  uri_folder,
  mltable,
  custom_model,
  mlflow_model,
  triton_model,
}

enum JobTier {
  Null,
  Spot,
  Basic,
  Standard,
  Premium,
}

enum LogVerbosity {
  @doc("No logs emitted.") NotSet,
  @doc("Debug and above log statements logged.") Debug,
  @doc("Info and above log statements logged.") Info,
  @doc("Warning and above log statements logged.") Warning,
  @doc("Error and above log statements logged.") Error,
  @doc("Only critical statements logged.") Critical,
}

enum TaskType {
  @doc("""
Classification in machine learning and statistics is a supervised learning approach in which
the computer program learns from the data given to it and make new observations or classifications.
""")
  Classification,
  @doc("Regression means to predict the value using the input data. Regression models are used to predict a continuous value.")
  Regression,
  @doc("""
Forecasting is a special kind of regression task that deals with time-series data and creates forecasting model
that can be used to predict the near future values based on the inputs.
""")
  Forecasting,
  @doc("""
Image Classification. Multi-class image classification is used when an image is classified with only a single label
from a set of classes - e.g. each image is classified as either an image of a 'cat' or a 'dog' or a 'duck'.
""")
  ImageClassification,
  @doc("""
Image Classification Multilabel. Multi-label image classification is used when an image could have one or more labels
from a set of labels - e.g. an image could be labeled with both 'cat' and 'dog'.
""")
  ImageClassificationMultilabel,
  @doc("""
Image Object Detection. Object detection is used to identify objects in an image and locate each object with a
bounding box e.g. locate all dogs and cats in an image and draw a bounding box around each.
""")
  ImageObjectDetection,
  @doc("""
Image Instance Segmentation. Instance segmentation is used to identify objects in an image at the pixel level,
drawing a polygon around each object in the image.
""")
  ImageInstanceSegmentation,
  @doc("""
Text classification (also known as text tagging or text categorization) is the process of sorting texts into categories.
Categories are mutually exclusive.
""")
  TextClassification,
  @doc("Multilabel classification task assigns each sample to a group (zero or more) of target labels.")
  TextClassificationMultilabel,
  @doc("""
Text Named Entity Recognition a.k.a. TextNER.
Named Entity Recognition (NER) is the ability to take free-form text and identify the occurrences of entities such as people, locations, organizations, and more.
""")
  TextNER,
}

enum JobInputType {
  literal,
  uri_file,
  uri_folder,
  mltable,
  custom_model,
  mlflow_model,
  triton_model,
}

enum NCrossValidationsMode {
  @doc("Determine N-Cross validations value automatically. Supported only for 'Forecasting' AutoML task.")
  Auto,
  @doc("Use custom N-Cross validations value.") Custom,
}

enum SeasonalityMode {
  @doc("Seasonality to be determined automatically.") Auto,
  @doc("Use the custom seasonality value.") Custom,
}

enum TargetLagsMode {
  @doc("Target lags to be determined automatically.") Auto,
  @doc("Use the custom target lags.") Custom,
}

enum TargetRollingWindowSizeMode {
  @doc("Determine rolling windows size automatically.") Auto,
  @doc("Use the specified rolling window size.") Custom,
}

enum MLFlowAutologgerState {
  Enabled,
  Disabled,
}

enum MonitoringAlertNotificationType {
  @doc("Settings for Azure Monitor based alerting.") AzureMonitor,
  @doc("Settings for AML email notifications.") Email,
}

enum ServiceDataAccessAuthIdentity {
  @doc("Do not use any identity for service data access.") None,
  @doc("Use the system assigned managed identity of the Workspace to authenticate service data access.")
  WorkspaceSystemAssignedIdentity,
  @doc("Use the user assigned managed identity of the Workspace to authenticate service data access.")
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
  @doc("The Jensen Shannon Distance (JSD) metric.") JensenShannonDistance,
  @doc("The Population Stability Index (PSI) metric.") PopulationStabilityIndex,
  @doc("The Pearsons Chi Squared Test metric.") PearsonsChiSquaredTest,
}

enum MonitoringFeatureDataType {
  @doc("Used for features of numerical data type.") Numerical,
  @doc("Used for features of categorical data type.") Categorical,
}

enum CategoricalDataQualityMetric {
  @doc("Calculates the rate of null values.") NullValueRate,
  @doc("Calculates the rate of data type errors.") DataTypeErrorRate,
  @doc("Calculates the rate values are out of bounds.") OutOfBoundsRate,
}

enum CategoricalPredictionDriftMetric {
  @doc("The Jensen Shannon Distance (JSD) metric.") JensenShannonDistance,
  @doc("The Population Stability Index (PSI) metric.") PopulationStabilityIndex,
  @doc("The Pearsons Chi Squared Test metric.") PearsonsChiSquaredTest,
}

enum ClassificationPrimaryMetrics {
  @doc("""
AUC is the Area under the curve.
This metric represents arithmetic mean of the score for each class,
weighted by the number of true instances in each class.
""")
  AUCWeighted,
  @doc("Accuracy is the ratio of predictions that exactly match the true class labels.")
  Accuracy,
  @doc("""
Normalized macro recall is recall macro-averaged and normalized, so that random
performance has a score of 0, and perfect performance has a score of 1.
""")
  NormMacroRecall,
  @doc("""
The arithmetic mean of the average precision score for each class, weighted by
the number of true instances in each class.
""")
  AveragePrecisionScoreWeighted,
  @doc("The arithmetic mean of precision for each class, weighted by number of true instances in each class.")
  PrecisionScoreWeighted,
}

enum ClassificationModels {
  @doc("""
Logistic regression is a fundamental classification technique.
It belongs to the group of linear classifiers and is somewhat similar to polynomial and linear regression.
Logistic regression is fast and relatively uncomplicated, and it's convenient for you to interpret the results.
Although it's essentially a method for binary classification, it can also be applied to multiclass problems.
""")
  LogisticRegression,
  @doc("""
SGD: Stochastic gradient descent is an optimization algorithm often used in machine learning applications
to find the model parameters that correspond to the best fit between predicted and actual outputs.
""")
  SGD,
  @doc("""
The multinomial Naive Bayes classifier is suitable for classification with discrete features (e.g., word counts for text classification).
The multinomial distribution normally requires integer feature counts. However, in practice, fractional counts such as tf-idf may also work.
""")
  MultinomialNaiveBayes,
  @doc("Naive Bayes classifier for multivariate Bernoulli models.")
  BernoulliNaiveBayes,
  @doc("""
A support vector machine (SVM) is a supervised machine learning model that uses classification algorithms for two-group classification problems.
After giving an SVM model sets of labeled training data for each category, they're able to categorize new text.
""")
  SVM,
  @doc("""
A support vector machine (SVM) is a supervised machine learning model that uses classification algorithms for two-group classification problems.
After giving an SVM model sets of labeled training data for each category, they're able to categorize new text.
Linear SVM performs best when input data is linear, i.e., data can be easily classified by drawing the straight line between classified values on a plotted graph.
""")
  LinearSVM,
  @doc("""
K-nearest neighbors (KNN) algorithm uses 'feature similarity' to predict the values of new datapoints
which further means that the new data point will be assigned a value based on how closely it matches the points in the training set.
""")
  KNN,
  @doc("""
Decision Trees are a non-parametric supervised learning method used for both classification and regression tasks.
The goal is to create a model that predicts the value of a target variable by learning simple decision rules inferred from the data features.
""")
  DecisionTree,
  @doc("""
Random forest is a supervised learning algorithm.
The \"forest\" it builds, is an ensemble of decision trees, usually trained with the bagging method.
The general idea of the bagging method is that a combination of learning models increases the overall result.
""")
  RandomForest,
  @doc("Extreme Trees is an ensemble machine learning algorithm that combines the predictions from many decision trees. It is related to the widely used random forest algorithm.")
  ExtremeRandomTrees,
  @doc("LightGBM is a gradient boosting framework that uses tree based learning algorithms.")
  LightGBM,
  @doc("The technique of transiting week learners into a strong learner is called Boosting. The gradient boosting algorithm process works on this theory of execution.")
  GradientBoosting,
  @doc("XGBoost: Extreme Gradient Boosting Algorithm. This algorithm is used for structured data where target column values can be divided into distinct class values.")
  XGBoostClassifier,
}

enum StackMetaLearnerType {
  None,
  @doc("Default meta-learners are LogisticRegression for classification tasks.")
  LogisticRegression,
  @doc("Default meta-learners are LogisticRegression for classification task when CV is on.")
  LogisticRegressionCV,
  LightGBMClassifier,
  @doc("Default meta-learners are LogisticRegression for regression task.")
  ElasticNet,
  @doc("Default meta-learners are LogisticRegression for regression task when CV is on.")
  ElasticNetCV,
  LightGBMRegressor,
  LinearRegression,
}

enum TrainingMode {
  @doc("Auto mode") Auto,
  @doc("Distributed training mode") Distributed,
  @doc("Non distributed training mode") NonDistributed,
}

enum BlockedTransformers {
  @doc("Target encoding for text data.") TextTargetEncoder,
  @doc("Ohe hot encoding creates a binary feature transformation.")
  OneHotEncoder,
  @doc("Target encoding for categorical data.") CatTargetEncoder,
  @doc("Tf-Idf stands for, term-frequency times inverse document-frequency. This is a common term weighting scheme for identifying information from documents.")
  TfIdf,
  @doc("Weight of Evidence encoding is a technique used to encode categorical variables. It uses the natural log of the P(1)/P(0) to create weights.")
  WoETargetEncoder,
  @doc("Label encoder converts labels/categorical variables in a numerical form.")
  LabelEncoder,
  @doc("Word embedding helps represents words or phrases as a vector, or a series of numbers.")
  WordEmbedding,
  @doc("Naive Bayes is a classified that is used for classification of discrete features that are categorically distributed.")
  NaiveBayes,
  @doc("Count Vectorizer converts a collection of text documents to a matrix of token counts.")
  CountVectorizer,
  @doc("Hashing One Hot Encoder can turn categorical variables into a limited number of new features. This is often used for high-cardinality categorical features.")
  HashOneHotEncoder,
}

enum FeaturizationMode {
  @doc("Auto mode, system performs featurization without any custom featurization inputs.")
  Auto,
  @doc("Custom featurization.") Custom,
  @doc("Featurization off. 'Forecasting' task cannot use this value.") Off,
}

enum ClassificationModelPerformanceMetric {
  @doc("Calculates the accuracy of the model predictions.") Accuracy,
  @doc("Calculates the precision of the model predictions.") Precision,
  @doc("Calculates the recall of the model predictions.") Recall,
}

enum MonitoringModelType {
  @doc("A model trained for classification tasks.") Classification,
  @doc("A model trained for regressions tasks.") Regression,
}

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

enum MonitorComputeType {
  @doc("Serverless Spark compute.") ServerlessSpark,
}

enum ModelTaskType {
  Classification,
  Regression,
  QuestionAnswering,
}

enum MonitoringNotificationMode {
  @doc("Disabled notifications will not produce emails/metrics leveraged for alerting.")
  Disabled,
  @doc("Enabled notification will produce emails/metrics leveraged for alerting.")
  Enabled,
}

enum MonitoringSignalType {
  @doc("Tracks model input data distribution change, comparing against training data or past production data.")
  DataDrift,
  @doc("Tracks prediction result data distribution change, comparing against validation/test label data or past production data.")
  PredictionDrift,
  @doc("Tracks model input data integrity.") DataQuality,
  @doc("Tracks feature importance change in production, comparing against feature importance at training time.")
  FeatureAttributionDrift,
  @doc("Tracks a custom signal provided by users.") Custom,
  @doc("Tracks model performance based on ground truth data.") ModelPerformance,
  @doc("Tracks the safety and quality of generated content.")
  GenerationSafetyQuality,
  @doc("Tracks the token usage of generative endpoints.")
  GenerationTokenStatistics,
}

enum MonitoringInputDataType {
  @doc("An input data with a fixed window size.") Static,
  @doc("An input data which trailing relatively to the monitor's current run.")
  Trailing,
  @doc("An input data with tabular format which doesn't require preprocessing.")
  Fixed,
}

enum DataImportSourceType {
  database,
  file_system,
}

enum FeatureAttributionMetric {
  @doc("The Normalized Discounted Cumulative Gain metric.")
  NormalizedDiscountedCumulativeGain,
}

enum FeatureLags {
  @doc("No feature lags generated.") None,
  @doc("System auto-generates feature lags.") Auto,
}

enum ShortSeriesHandlingConfiguration {
  @doc("Represents no/null value.") None,
  @doc("Short series will be padded if there are no long series, otherwise short series will be dropped.")
  Auto,
  @doc("All the short series will be padded.") Pad,
  @doc("All the short series will be dropped.") Drop,
}

enum TargetAggregationFunction {
  @doc("Represent no value set.") None,
  Sum,
  Max,
  Min,
  Mean,
}

enum UseStl {
  @doc("No stl decomposition.") None,
  Season,
  SeasonTrend,
}

enum ForecastingPrimaryMetrics {
  @doc("The Spearman's rank coefficient of correlation is a non-parametric measure of rank correlation.")
  SpearmanCorrelation,
  @doc("The Normalized Root Mean Squared Error (NRMSE) the RMSE facilitates the comparison between models with different scales.")
  NormalizedRootMeanSquaredError,
  @doc("The R2 score is one of the performance evaluation measures for forecasting-based machine learning models.")
  R2Score,
  @doc("The Normalized Mean Absolute Error (NMAE) is a validation metric to compare the Mean Absolute Error (MAE) of (time) series with different scales.")
  NormalizedMeanAbsoluteError,
}

enum ForecastingModels {
  @doc("""
Auto-Autoregressive Integrated Moving Average (ARIMA) model uses time-series data and statistical analysis to interpret the data and make future predictions.
This model aims to explain data by using time series data on its past values and uses linear regression to make predictions.
""")
  AutoArima,
  @doc("""
Prophet is a procedure for forecasting time series data based on an additive model where non-linear trends are fit with yearly, weekly, and daily seasonality, plus holiday effects.
It works best with time series that have strong seasonal effects and several seasons of historical data. Prophet is robust to missing data and shifts in the trend, and typically handles outliers well.
""")
  Prophet,
  @doc("The Naive forecasting model makes predictions by carrying forward the latest target value for each time-series in the training data.")
  Naive,
  @doc("The Seasonal Naive forecasting model makes predictions by carrying forward the latest season of target values for each time-series in the training data.")
  SeasonalNaive,
  @doc("The Average forecasting model makes predictions by carrying forward the average of the target values for each time-series in the training data.")
  Average,
  @doc("The Seasonal Average forecasting model makes predictions by carrying forward the average value of the latest season of data for each time-series in the training data.")
  SeasonalAverage,
  @doc("Exponential smoothing is a time series forecasting method for univariate data that can be extended to support data with a systematic trend or seasonal component.")
  ExponentialSmoothing,
  @doc("""
An Autoregressive Integrated Moving Average with Explanatory Variable (ARIMAX) model can be viewed as a multiple regression model with one or more autoregressive (AR) terms and/or one or more moving average (MA) terms.
This method is suitable for forecasting when data is stationary/non stationary, and multivariate with any type of data pattern, i.e., level/trend /seasonality/cyclicity.
""")
  Arimax,
  @doc("TCNForecaster: Temporal Convolutional Networks Forecaster. //TODO: Ask forecasting team for brief intro.")
  TCNForecaster,
  @doc("Elastic net is a popular type of regularized linear regression that combines two popular penalties, specifically the L1 and L2 penalty functions.")
  ElasticNet,
  @doc("The technique of transiting week learners into a strong learner is called Boosting. The gradient boosting algorithm process works on this theory of execution.")
  GradientBoosting,
  @doc("""
Decision Trees are a non-parametric supervised learning method used for both classification and regression tasks.
The goal is to create a model that predicts the value of a target variable by learning simple decision rules inferred from the data features.
""")
  DecisionTree,
  @doc("""
K-nearest neighbors (KNN) algorithm uses 'feature similarity' to predict the values of new datapoints
which further means that the new data point will be assigned a value based on how closely it matches the points in the training set.
""")
  KNN,
  @doc("Lasso model fit with Least Angle Regression a.k.a. Lars. It is a Linear Model trained with an L1 prior as regularizer.")
  LassoLars,
  @doc("""
SGD: Stochastic gradient descent is an optimization algorithm often used in machine learning applications
to find the model parameters that correspond to the best fit between predicted and actual outputs.
It's an inexact but powerful technique.
""")
  SGD,
  @doc("""
Random forest is a supervised learning algorithm.
The \"forest\" it builds, is an ensemble of decision trees, usually trained with the bagging method.
The general idea of the bagging method is that a combination of learning models increases the overall result.
""")
  RandomForest,
  @doc("Extreme Trees is an ensemble machine learning algorithm that combines the predictions from many decision trees. It is related to the widely used random forest algorithm.")
  ExtremeRandomTrees,
  @doc("LightGBM is a gradient boosting framework that uses tree based learning algorithms.")
  LightGBM,
  @doc("XGBoostRegressor: Extreme Gradient Boosting Regressor is a supervised machine learning model using ensemble of base learners.")
  XGBoostRegressor,
}

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

enum GenerationTokenStatisticsMetric {
  TotalTokenCount,
  TotalTokenCountPerGroup,
}

enum LearningRateScheduler {
  @doc("No learning rate scheduler selected.") None,
  @doc("Cosine Annealing With Warmup.") WarmupCosine,
  @doc("Step learning rate scheduler.") Step,
}

enum StochasticOptimizer {
  @doc("No optimizer selected.") None,
  @doc("Stochastic Gradient Descent optimizer.") Sgd,
  @doc("Adam is algorithm the optimizes stochastic objective functions based on adaptive estimates of moments")
  Adam,
  @doc("AdamW is a variant of the optimizer Adam that has an improved implementation of weight decay.")
  Adamw,
}

enum ClassificationMultilabelPrimaryMetrics {
  @doc("""
AUC is the Area under the curve.
This metric represents arithmetic mean of the score for each class,
weighted by the number of true instances in each class.
""")
  AUCWeighted,
  @doc("Accuracy is the ratio of predictions that exactly match the true class labels.")
  Accuracy,
  @doc("""
Normalized macro recall is recall macro-averaged and normalized, so that random
performance has a score of 0, and perfect performance has a score of 1.
""")
  NormMacroRecall,
  @doc("""
The arithmetic mean of the average precision score for each class, weighted by
the number of true instances in each class.
""")
  AveragePrecisionScoreWeighted,
  @doc("The arithmetic mean of precision for each class, weighted by number of true instances in each class.")
  PrecisionScoreWeighted,
  @doc("Intersection Over Union. Intersection of predictions divided by union of predictions.")
  IOU,
}

enum InstanceSegmentationPrimaryMetrics {
  @doc("""
Mean Average Precision (MAP) is the average of AP (Average Precision).
AP is calculated for each class and averaged to get the MAP.
""")
  MeanAveragePrecision,
}

enum LogTrainingMetrics {
  @doc("Enable compute and log training metrics.") Enable,
  @doc("Disable compute and log training metrics.") Disable,
}

enum LogValidationLoss {
  @doc("Enable compute and log validation metrics.") Enable,
  @doc("Disable compute and log validation metrics.") Disable,
}

enum ModelSize {
  @doc("No value selected.") None,
  @doc("Small size.") Small,
  @doc("Medium size.") Medium,
  @doc("Large size.") Large,
  @doc("Extra large size.") ExtraLarge,
}

enum ValidationMetricType {
  @doc("No metric.") None,
  @doc("Coco metric.") Coco,
  @doc("Voc metric.") Voc,
  @doc("CocoVoc metric.") CocoVoc,
}

enum ObjectDetectionPrimaryMetrics {
  @doc("""
Mean Average Precision (MAP) is the average of AP (Average Precision).
AP is calculated for each class and averaged to get the MAP.
""")
  MeanAveragePrecision,
}

enum ImageAnnotationType {
  Classification,
  BoundingBox,
  InstanceSegmentation,
}

enum TextAnnotationType {
  Classification,
  NamedEntityRecognition,
}

enum OneLakeArtifactType {
  LakeHouse,
}

enum NlpLearningRateScheduler {
  @doc("No learning rate schedule.") None,
  @doc("Linear warmup and decay.") Linear,
  @doc("Linear warmup then cosine decay.") Cosine,
  @doc("Linear warmup, cosine decay, then restart to initial LR.")
  CosineWithRestarts,
  @doc("Increase linearly then polynomially decay.") Polynomial,
  @doc("Constant learning rate.") Constant,
  @doc("Linear warmup followed by constant value.") ConstantWithWarmup,
}

enum NumericalDataDriftMetric {
  @doc("The Jensen Shannon Distance (JSD) metric.") JensenShannonDistance,
  @doc("The Population Stability Index (PSI) metric.") PopulationStabilityIndex,
  @doc("The Normalized Wasserstein Distance metric.")
  NormalizedWassersteinDistance,
  @doc("The Two Sample Kolmogorov-Smirnov Test (two-sample K–S) metric.")
  TwoSampleKolmogorovSmirnovTest,
}

enum NumericalDataQualityMetric {
  @doc("Calculates the rate of null values.") NullValueRate,
  @doc("Calculates the rate of data type errors.") DataTypeErrorRate,
  @doc("Calculates the rate values are out of bounds.") OutOfBoundsRate,
}

enum NumericalPredictionDriftMetric {
  @doc("The Jensen Shannon Distance (JSD) metric.") JensenShannonDistance,
  @doc("The Population Stability Index (PSI) metric.") PopulationStabilityIndex,
  @doc("The Normalized Wasserstein Distance metric.")
  NormalizedWassersteinDistance,
  @doc("The Two Sample Kolmogorov-Smirnov Test (two-sample K–S) metric.")
  TwoSampleKolmogorovSmirnovTest,
}

enum Goal {
  Minimize,
  Maximize,
}

enum RandomSamplingAlgorithmRule {
  Random,
  Sobol,
}

enum RegressionPrimaryMetrics {
  @doc("The Spearman's rank coefficient of correlation is a nonparametric measure of rank correlation.")
  SpearmanCorrelation,
  @doc("The Normalized Root Mean Squared Error (NRMSE) the RMSE facilitates the comparison between models with different scales.")
  NormalizedRootMeanSquaredError,
  @doc("The R2 score is one of the performance evaluation measures for forecasting-based machine learning models.")
  R2Score,
  @doc("The Normalized Mean Absolute Error (NMAE) is a validation metric to compare the Mean Absolute Error (MAE) of (time) series with different scales.")
  NormalizedMeanAbsoluteError,
}

enum RegressionModels {
  @doc("Elastic net is a popular type of regularized linear regression that combines two popular penalties, specifically the L1 and L2 penalty functions.")
  ElasticNet,
  @doc("The technique of transiting week learners into a strong learner is called Boosting. The gradient boosting algorithm process works on this theory of execution.")
  GradientBoosting,
  @doc("""
Decision Trees are a non-parametric supervised learning method used for both classification and regression tasks.
The goal is to create a model that predicts the value of a target variable by learning simple decision rules inferred from the data features.
""")
  DecisionTree,
  @doc("""
K-nearest neighbors (KNN) algorithm uses 'feature similarity' to predict the values of new datapoints
which further means that the new data point will be assigned a value based on how closely it matches the points in the training set.
""")
  KNN,
  @doc("Lasso model fit with Least Angle Regression a.k.a. Lars. It is a Linear Model trained with an L1 prior as regularizer.")
  LassoLars,
  @doc("""
SGD: Stochastic gradient descent is an optimization algorithm often used in machine learning applications
to find the model parameters that correspond to the best fit between predicted and actual outputs.
It's an inexact but powerful technique.
""")
  SGD,
  @doc("""
Random forest is a supervised learning algorithm.
The \"forest\" it builds, is an ensemble of decision trees, usually trained with the bagging method.
The general idea of the bagging method is that a combination of learning models increases the overall result.
""")
  RandomForest,
  @doc("Extreme Trees is an ensemble machine learning algorithm that combines the predictions from many decision trees. It is related to the widely used random forest algorithm.")
  ExtremeRandomTrees,
  @doc("LightGBM is a gradient boosting framework that uses tree based learning algorithms.")
  LightGBM,
  @doc("XGBoostRegressor: Extreme Gradient Boosting Regressor is a supervised machine learning model using ensemble of base learners.")
  XGBoostRegressor,
}

enum RegressionModelPerformanceMetric {
  @doc("The Mean Absolute Error (MAE) metric.") MeanAbsoluteError,
  @doc("The Root Mean Squared Error (RMSE) metric.") RootMeanSquaredError,
  @doc("The Mean Squared Error (MSE) metric.") MeanSquaredError,
}

enum SparkJobEntryType {
  SparkJobPythonEntry,
  SparkJobScalaEntry,
}

enum RuleAction {
  Allow,
  Deny,
}
@fixed
enum SkuTier {
  Free,
  Basic,
  Standard,
  Premium,
}

@doc("The List Usages operation response.")
model ListUsagesResult is Azure.Core.Page<Usage>;

@doc("Describes AML Resource Usage.")
model Usage {
  @doc("Specifies the resource ID.")
  @visibility("read")
  id?: string;

  @doc("Region of the AML workspace in the id.")
  @visibility("read")
  amlWorkspaceLocation?: string;

  @doc("Specifies the resource type.")
  @visibility("read")
  type?: string;

  @doc("An enum describing the unit of usage measurement.")
  @visibility("read")
  unit?: UsageUnit;

  @doc("The current usage of the resource.")
  @visibility("read")
  currentValue?: int32;

  @doc("The maximum permitted usage of the resource.")
  @visibility("read")
  limit?: int32;

  @doc("The name of the type of usage.")
  @visibility("read")
  name?: UsageName;
}

@doc("The Usage Names.")
model UsageName {
  @doc("The name of the resource.")
  @visibility("read")
  value?: string;

  @doc("The localized name of the resource.")
  @visibility("read")
  localizedValue?: string;
}

@doc("The List Virtual Machine size operation response.")
model VirtualMachineSizeListResult {
  @doc("The list of virtual machine sizes supported by AmlCompute.")
  value?: VirtualMachineSize[];
}

@doc("Describes the properties of a VM size.")
model VirtualMachineSize {
  @doc("The name of the virtual machine size.")
  @visibility("read")
  name?: string;

  @doc("The family name of the virtual machine size.")
  @visibility("read")
  family?: string;

  @doc("The number of vCPUs supported by the virtual machine size.")
  @visibility("read")
  vCPUs?: int32;

  @doc("The number of gPUs supported by the virtual machine size.")
  @visibility("read")
  gpus?: int32;

  @doc("The OS VHD disk size, in MB, allowed by the virtual machine size.")
  @visibility("read")
  osVhdSizeMB?: int32;

  @doc("The resource volume size, in MB, allowed by the virtual machine size.")
  @visibility("read")
  maxResourceVolumeMB?: int32;

  @doc("The amount of memory, in GB, supported by the virtual machine size.")
  @visibility("read")
  memoryGB?: float32;

  @doc("Specifies if the virtual machine size supports low priority VMs.")
  @visibility("read")
  lowPriorityCapable?: boolean;

  @doc("Specifies if the virtual machine size supports premium IO.")
  @visibility("read")
  premiumIO?: boolean;

  @doc("The estimated price information for using a VM.")
  estimatedVMPrices?: EstimatedVMPrices;

  @doc("Specifies the compute types supported by the virtual machine size.")
  supportedComputeTypes?: string[];
}

@doc("The estimated price info for using a VM.")
model EstimatedVMPrices {
  @doc("Three lettered code specifying the currency of the VM price. Example: USD")
  billingCurrency: BillingCurrency;

  @doc("The unit of time measurement for the specified VM price. Example: OneHour")
  unitOfMeasure: UnitOfMeasure;

  @doc("The list of estimated prices for using a VM of a particular OS type, tier, etc.")
  values: EstimatedVMPrice[];
}

@doc("The estimated price info for using a VM of a particular OS type, tier, etc.")
model EstimatedVMPrice {
  @doc("The price charged for using the VM.")
  retailPrice: float32;

  @doc("Operating system type used by the VM.")
  osType: VMPriceOSType;

  @doc("The type of the VM.")
  vmTier: VMTier;
}

@doc("Quota update parameters.")
model QuotaUpdateParameters {
  @doc("The list for update quota.")
  value?: QuotaBaseProperties[];

  @doc("Region of workspace quota to be updated.")
  location?: string;
}

@doc("The properties for Quota update or retrieval.")
model QuotaBaseProperties {
  @doc("Specifies the resource ID.")
  id?: string;

  @doc("Specifies the resource type.")
  type?: string;

  @doc("The maximum permitted quota of the resource.")
  limit?: int32;

  @doc("An enum describing the unit of quota measurement.")
  unit?: QuotaUnit;
}

@doc("The result of update workspace quota.")
model UpdateWorkspaceQuotasResult {
  @doc("The list of workspace quota update result.")
  @visibility("read")
  value?: UpdateWorkspaceQuotas[];

  @doc("The URI to fetch the next page of workspace quota update result. Call ListNext() with this to fetch the next page of Workspace Quota update result.")
  @visibility("read")
  nextLink?: string;
}

@doc("The properties for update Quota response.")
model UpdateWorkspaceQuotas {
  @doc("Specifies the resource ID.")
  @visibility("read")
  id?: string;

  @doc("Specifies the resource type.")
  @visibility("read")
  type?: string;

  @doc("The maximum permitted quota of the resource.")
  limit?: int32;

  @doc("An enum describing the unit of quota measurement.")
  @visibility("read")
  unit?: QuotaUnit;

  @doc("Status of update workspace quota.")
  status?: Status;
}

@doc("The List WorkspaceQuotasByVMFamily operation response.")
model ListWorkspaceQuotas is Azure.Core.Page<ResourceQuota>;

@doc("The quota assigned to a resource.")
model ResourceQuota {
  @doc("Specifies the resource ID.")
  @visibility("read")
  id?: string;

  @doc("Region of the AML workspace in the id.")
  @visibility("read")
  amlWorkspaceLocation?: string;

  @doc("Specifies the resource type.")
  @visibility("read")
  type?: string;

  @doc("Name of the resource.")
  @visibility("read")
  name?: ResourceName;

  @doc("The maximum permitted quota of the resource.")
  @visibility("read")
  limit?: int32;

  @doc("An enum describing the unit of quota measurement.")
  @visibility("read")
  unit?: QuotaUnit;
}

@doc("The Resource Name.")
model ResourceName {
  @doc("The name of the resource.")
  @visibility("read")
  value?: string;

  @doc("The localized name of the resource.")
  @visibility("read")
  localizedValue?: string;
}

@doc("The resource model definition representing SKU")
model Sku {
  @doc("The name of the SKU. Ex - P3. It is typically a letter+number code")
  name: string;

  @doc("This field is required to be implemented by the Resource Provider if the service has more than one tier, but is not required on a PUT.")
  tier?: SkuTier;

  @doc("The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code. ")
  size?: string;

  @doc("If the service has different generations of hardware, for the same SKU, then that can be captured here.")
  family?: string;

  @doc("If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.")
  capacity?: int32;
}

@doc("Common fields that are returned in the response for all Azure Resource Manager resources")
model Resource {
  @doc("Fully qualified resource ID for the resource. Ex - /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{resourceType}/{resourceName}")
  @visibility("read")
  id?: string;

  @doc("The name of the resource")
  @visibility("read")
  name?: string;

  @doc("The type of the resource. E.g. \"Microsoft.Compute/virtualMachines\" or \"Microsoft.Storage/storageAccounts\"")
  @visibility("read")
  type?: string;

  @doc("Azure Resource Manager metadata containing createdBy and modifiedBy information.")
  @visibility("read")
  systemData?: SystemData;
}

model ComputeResourceSchema {
  @doc("Compute properties")
  properties?: Compute;
}

@doc("Machine Learning compute object.")
@discriminator("computeType")
model Compute {
  @doc("Location for the underlying compute")
  @visibility("read", "create")
  computeLocation?: string;

  @doc("The provision state of the cluster. Valid values are Unknown, Updating, Provisioning, Succeeded, and Failed.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("The description of the Machine Learning compute.")
  description?: string;

  @doc("The time at which the compute was created.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdOn?: utcDateTime;

  @doc("The time at which the compute was last modified.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  modifiedOn?: utcDateTime;

  @doc("ARM resource id of the underlying compute")
  resourceId?: string;

  @doc("Errors during provisioning")
  @visibility("read")
  provisioningErrors?: ErrorResponse[];

  @doc("Indicating whether the compute was provisioned by user and brought from outside if true, or machine learning service provisioned it if false.")
  @visibility("read")
  isAttachedCompute?: boolean;

  @doc("Opt-out of local authentication and ensure customers can use only MSI and AAD exclusively for authentication.")
  @visibility("read", "create")
  disableLocalAuth?: boolean;
}

@doc("AmlCompute update parameters.")
model ClusterUpdateParameters {
  @doc("The properties of the amlCompute.")
  properties?: ClusterUpdateProperties;
}

@doc("The properties of a amlCompute that need to be updated.")
model ClusterUpdateProperties {
  @doc("Properties of ClusterUpdate")
  properties?: ScaleSettingsInformation;
}

@doc("Desired scale settings for the amlCompute.")
model ScaleSettingsInformation {
  @doc("scale settings for AML Compute")
  scaleSettings?: ScaleSettings;
}

@doc("scale settings for AML Compute")
model ScaleSettings {
  @doc("Max number of nodes to use")
  maxNodeCount: int32;

  @doc("Min number of nodes to use")
  minNodeCount?: int32;

  @doc("Node Idle Time before scaling down amlCompute. This string needs to be in the RFC Format.")
  nodeIdleTimeBeforeScaleDown?: duration;
}

@doc("Specifies the custom service configuration")
model CustomService extends Record<unknown> {
  @doc("Name of the Custom Service")
  name?: string;

  @doc("Describes the Image Specifications")
  image?: Image;

  @doc("Environment Variable for the container")
  environmentVariables?: Record<EnvironmentVariable>;

  @doc("Describes the docker settings for the image")
  docker?: Docker;

  @doc("Configuring the endpoints for the container")
  endpoints?: Endpoint[];

  @doc("Configuring the volumes for the container")
  volumes?: VolumeDefinition[];
}

model Image extends Record<unknown> {
  @doc("Type of the image. Possible values are: docker - For docker images. azureml - For AzureML images")
  type?: ImageType;

  @doc("Image reference URL")
  reference?: string;
}

model EnvironmentVariable extends Record<unknown> {
  @doc("Type of the Environment Variable. Possible values are: local - For local variable")
  type?: EnvironmentVariableType;

  @doc("Value of the Environment variable")
  value?: string;
}

model Docker extends Record<unknown> {
  @doc("Indicate whether container shall run in privileged or non-privileged mode.")
  privileged?: boolean;
}

model Endpoint {
  @doc("Protocol over which communication will happen over this endpoint")
  protocol?: Protocol;

  @doc("Name of the Endpoint")
  name?: string;

  @doc("Application port inside the container.")
  target?: int32;

  @doc("Port over which the application is exposed from container.")
  published?: int32;

  @doc("Host IP over which the application is exposed from the container")
  hostIp?: string;
}

model VolumeDefinition {
  @doc("Type of Volume Definition. Possible Values: bind,volume,tmpfs,npipe")
  type?: VolumeDefinitionType;

  @doc("Indicate whether to mount volume as readOnly. Default value for this is false.")
  readOnly?: boolean;

  @doc("Source of the mount. For bind mounts this is the host path.")
  source?: string;

  @doc("Target of the mount. For bind mounts this is the path in the container.")
  target?: string;

  @doc("Consistency of the volume")
  consistency?: string;

  @doc("Bind Options of the mount")
  bind?: BindOptions;

  @doc("Volume Options of the mount")
  volume?: VolumeOptions;

  @doc("tmpfs option of the mount")
  tmpfs?: TmpfsOptions;
}

model BindOptions {
  @doc("Type of Bind Option")
  propagation?: string;

  @doc("Indicate whether to create host path.")
  createHostPath?: boolean;

  @doc("Mention the selinux options.")
  selinux?: string;
}

model VolumeOptions {
  @doc("Indicate whether volume is nocopy")
  nocopy?: boolean;
}

model TmpfsOptions {
  @doc("Mention the Tmpfs size")
  size?: int32;
}

@doc("Result of AmlCompute Nodes")
@pagedResult
model AmlComputeNodesInformation {
  @doc("The collection of returned AmlCompute nodes details.")
  @visibility("read")
  @items
  nodes?: AmlComputeNodeInformation[];

  @doc("The continuation token.")
  @visibility("read")
  @nextLink
  nextLink?: string;
}

@doc("Compute node information related to a AmlCompute.")
model AmlComputeNodeInformation {
  @doc("ID of the compute node.")
  @visibility("read")
  nodeId?: string;

  @doc("Private IP address of the compute node.")
  @visibility("read")
  privateIpAddress?: string;

  @doc("Public IP address of the compute node.")
  @visibility("read")
  publicIpAddress?: string;

  @doc("SSH port number of the node.")
  @visibility("read")
  port?: int32;

  @doc("State of the compute node. Values are idle, running, preparing, unusable, leaving and preempted.")
  @visibility("read")
  nodeState?: NodeState;

  @doc("ID of the Experiment running on the node, if any else null.")
  @visibility("read")
  runId?: string;
}

@doc("Secrets related to a Machine Learning compute. Might differ for every type of compute.")
@discriminator("computeType")
model ComputeSecrets {}

@doc("Stops compute instance after user defined period of inactivity.")
model IdleShutdownSetting {
  @doc("Time is defined in ISO8601 format. Minimum is 15 min, maximum is 3 days.")
  idleTimeBeforeShutdown?: string;
}

@doc("Container for code asset versions.")
model CodeContainer extends AssetContainer {
  @doc("Provisioning state for the code container.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

model AssetContainer extends ResourceBase {
  @doc("Is the asset archived?")
  @visibility("read", "create", "update")
  isArchived?: boolean;

  @doc("The latest version inside this container.")
  @visibility("read")
  latestVersion?: string;

  @doc("The next auto incremental version")
  @visibility("read")
  nextVersion?: string;
}

model ResourceBase {
  @doc("The asset description text.")
  description?: string;

  @doc("The asset property dictionary.")
  properties?: Record<string>;

  @doc("Tag dictionary. Tags can be added, removed, and updated.")
  tags?: Record<string>;
}

@doc("Code asset version details.")
model CodeVersion extends AssetBase {
  @doc("Uri where code is located")
  codeUri?: string;

  @doc("Provisioning state for the code version.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

model AssetBase extends ResourceBase {
  @doc("Specifies the lifecycle setting of managed data asset.")
  @visibility("read", "create", "update")
  autoDeleteSetting?: AutoDeleteSetting;

  @doc("If the name version are system generated (anonymous registration). For types where Stage is defined, when Stage is provided it will be used to populate IsAnonymous")
  @visibility("read", "create")
  isAnonymous?: boolean;

  @doc("Is the asset archived? For types where Stage is defined, when Stage is provided it will be used to populate IsArchived")
  @visibility("read", "create", "update")
  isArchived?: boolean;
}

model AutoDeleteSetting {
  @doc("When to check if an asset is expired")
  @visibility("read", "create", "update")
  condition?: AutoDeleteCondition;

  @doc("Expiration condition value.")
  @visibility("read", "create", "update")
  value?: string;
}

model PendingUploadRequestDto {
  @doc("If PendingUploadId = null then random guid will be used.")
  pendingUploadId?: string;

  @doc("TemporaryBlobReference is the only supported type")
  pendingUploadType?: PendingUploadType;
}

model PendingUploadResponseDto {
  @doc("Container level read, write, list SAS")
  blobReferenceForConsumption?: BlobReferenceForConsumptionDto;

  @doc("ID for this upload request")
  pendingUploadId?: string;

  @doc("TemporaryBlobReference is the only supported type")
  pendingUploadType?: PendingUploadType;
}

model BlobReferenceForConsumptionDto {
  @doc("""
Blob URI path for client to upload data.
Example: https://blob.windows.core.net/Container/Path
""")
  blobUri?: string;

  @doc("Credential info to access storage account")
  credential?: PendingUploadCredentialDto;

  @doc("Arm ID of the storage account to use")
  storageAccountArmId?: string;
}

@discriminator("credentialType")
model PendingUploadCredentialDto {}

@doc("""
Component container definition.
<see href=\"https://docs.microsoft.com/en-us/azure/machine-learning/reference-yaml-component-command\" />
""")
model ComponentContainer extends AssetContainer {
  @doc("Provisioning state for the component container.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

@doc("Definition of a component version: defines resources that span component types.")
model ComponentVersion extends AssetBase {
  @doc("""
Defines Component definition details.
<see href=\"https://docs.microsoft.com/en-us/azure/machine-learning/reference-yaml-component-command\" />
""")
  @visibility("read", "create")
  componentSpec?: Record<unknown>;

  @doc("Provisioning state for the component version.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;

  @doc("Stage in the component lifecycle")
  stage?: string;
}

@doc("Container for data asset versions.")
model DataContainer extends AssetContainer {
  @doc("[Required] Specifies the type of data.")
  @visibility("read", "create")
  dataType: DataType;
}

@doc("Data version base definition")
@discriminator("dataType")
model DataVersionBase extends AssetBase {
  @doc("[Required] Uri of the data. Example: https://go.microsoft.com/fwlink/?linkid=2202330")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  dataUri: string;

  @doc("Intellectual Property details. Used if data is an Intellectual Property.")
  @visibility("read", "create")
  intellectualProperty?: IntellectualProperty;

  @doc("Stage in the data lifecycle assigned to this data asset")
  stage?: string;
}

@doc("Intellectual Property details for a resource.")
model IntellectualProperty {
  @doc("Protection level of the Intellectual Property.")
  protectionLevel?: ProtectionLevel;

  @doc("[Required] Publisher of the Intellectual Property. Must be the same as Registry publisher name.")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  publisher: string;
}

@doc("Container for environment specification versions.")
model EnvironmentContainer extends AssetContainer {
  @doc("Provisioning state for the environment container.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

@doc("Environment version details.")
model EnvironmentVersion extends AssetBase {
  @doc("Defines if image needs to be rebuilt based on base image changes.")
  @visibility("read", "create")
  autoRebuild?: AutoRebuildSetting;

  @doc("Configuration settings for Docker build context.")
  @visibility("read", "create")
  build?: BuildContext;

  @doc("""
Standard configuration file used by Conda that lets you install any kind of package, including Python, R, and C/C++ packages.
<see href=\"https://repo2docker.readthedocs.io/en/latest/config_files.html#environment-yml-install-a-conda-environment\" />
""")
  @visibility("read", "create")
  condaFile?: string;

  @doc("""
Environment type is either user managed or curated by the Azure ML service
<see href=\"https://docs.microsoft.com/en-us/azure/machine-learning/resource-curated-environments\" />
""")
  @visibility("read")
  environmentType?: EnvironmentType;

  @doc("""
Name of the image that will be used for the environment.
<seealso href=\"https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-custom-docker-image#use-a-custom-base-image\" />
""")
  @visibility("read", "create")
  image?: string;

  @doc("Defines configuration specific to inference.")
  @visibility("read", "create")
  inferenceConfig?: InferenceContainerProperties;

  @doc("Intellectual Property details. Used if environment is an Intellectual Property.")
  @visibility("read", "create")
  intellectualProperty?: IntellectualProperty;

  @doc("The OS type of the environment.")
  @visibility("read", "create")
  osType?: OperatingSystemType;

  @doc("Provisioning state for the environment version.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;

  @doc("Stage in the environment lifecycle assigned to this environment")
  stage?: string;
}

@doc("Configuration settings for Docker build context")
model BuildContext {
  @doc("""
[Required] URI of the Docker build context used to build the image. Supports blob URIs on environment creation and may return blob or Git URIs.
<seealso href=\"https://docs.docker.com/engine/reference/commandline/build/#extended-description\" />
""")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  contextUri: string;

  @doc("""
Path to the Dockerfile in the build context.
<seealso href=\"https://docs.docker.com/engine/reference/builder/\" />
""")
  @visibility("read", "create")
  dockerfilePath?: string;
}

model InferenceContainerProperties {
  @doc("The route to check the liveness of the inference server container.")
  livenessRoute?: Route;

  @doc("The route to check the readiness of the inference server container.")
  readinessRoute?: Route;

  @doc("The port to send the scoring requests to, within the inference server container.")
  scoringRoute?: Route;
}

model Route {
  @doc("[Required] The path for the route.")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  path: string;

  @doc("[Required] The port for the route.")
  port: int32;
}

model ModelContainer extends AssetContainer {
  @doc("Provisioning state for the model container.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

@doc("Model asset version details.")
model ModelVersion extends AssetBase {
  @doc("Mapping of model flavors to their properties.")
  flavors?: Record<FlavorData>;

  @doc("Intellectual Property details. Used if model is an Intellectual Property.")
  @visibility("read", "create")
  intellectualProperty?: IntellectualProperty;

  @doc("Name of the training job which produced this model")
  jobName?: string;

  @doc("The storage format for this entity. Used for NCD.")
  modelType?: string;

  @doc("The URI path to the model contents.")
  modelUri?: string;

  @doc("Provisioning state for the model version.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;

  @doc("Stage in the model lifecycle assigned to this model")
  stage?: string;
}

model FlavorData {
  @doc("Model flavor-specific data.")
  data?: Record<string>;
}

@doc("Model package operation request properties.")
model PackageRequest {
  @doc("Base environment to start with.")
  @visibility("read", "create")
  baseEnvironmentSource?: BaseEnvironmentSource;

  @doc("Collection of environment variables.")
  @visibility("read", "create")
  environmentVariables?: Record<string>;

  @doc("[Required] Inferencing server configurations.")
  @visibility("read", "create")
  inferencingServer: InferencingServer;

  @doc("Collection of inputs.")
  @visibility("read", "create")
  inputs?: ModelPackageInput[];

  @doc("Model configuration including the mount mode.")
  @visibility("read", "create")
  modelConfiguration?: ModelConfiguration;

  @doc("Tag dictionary. Tags can be added, removed, and updated.")
  @visibility("read", "create")
  tags?: Record<string>;

  @doc("[Required] Arm ID of the target environment to be created by package operation.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  targetEnvironmentId: string;
}

@discriminator("baseEnvironmentSourceType")
model BaseEnvironmentSource {}

@discriminator("serverType")
model InferencingServer {}

@doc("Model package input options.")
model ModelPackageInput {
  @doc("[Required] Type of the input included in the target image.")
  inputType: PackageInputType;

  @doc("Input delivery mode of the input.")
  mode?: PackageInputDeliveryMode;

  @doc("Relative mount path of the input in the target image.")
  mountPath?: string;

  @doc("[Required] Location of the input.")
  path: PackageInputPathBase;
}

@discriminator("inputPathType")
model PackageInputPathBase {}

@doc("Model configuration options.")
model ModelConfiguration {
  @doc("Input delivery mode for the model.")
  mode?: PackageInputDeliveryMode;

  @doc("Relative mounting path of the model in the target image.")
  mountPath?: string;
}

@doc("Package response returned after async package operation completes successfully.")
model PackageResponse {
  @doc("Base environment to start with.")
  @visibility("read")
  baseEnvironmentSource?: BaseEnvironmentSource;

  @doc("Build id of the image build operation.")
  @visibility("read")
  buildId?: string;

  @doc("Build state of the image build operation.")
  @visibility("read")
  buildState?: PackageBuildState;

  @doc("Collection of environment variables.")
  @visibility("read")
  environmentVariables?: Record<string>;

  @doc("Inferencing server configurations.")
  @visibility("read")
  inferencingServer?: InferencingServer;

  @doc("Collection of inputs.")
  @visibility("read")
  inputs?: ModelPackageInput[];

  @doc("Log url of the image build operation.")
  @visibility("read")
  logUrl?: string;

  @doc("Model configuration including the mount mode.")
  @visibility("read")
  modelConfiguration?: ModelConfiguration;

  @doc("Tag dictionary. Tags can be added, removed, and updated.")
  @visibility("read")
  tags?: Record<string>;

  @doc("Asset ID of the target environment created by package operation.")
  @visibility("read")
  targetEnvironmentId?: string;
}

@doc("Batch endpoint configuration.")
model BatchEndpoint extends EndpointPropertiesBase {
  @doc("Default values for Batch Endpoint.")
  defaults?: BatchEndpointDefaults;

  @doc("Provisioning state for the endpoint.")
  @visibility("read")
  provisioningState?: EndpointProvisioningState;
}

@doc("Batch endpoint default values")
model BatchEndpointDefaults {
  @doc("""
Name of the deployment that will be default for the endpoint.
This deployment will end up getting 100% traffic when the endpoint scoring URL is invoked.
""")
  deploymentName?: string;
}

@doc("Inference Endpoint base definition")
model EndpointPropertiesBase {
  @doc("[Required] Use 'Key' for key based authentication and 'AMLToken' for Azure Machine Learning token-based authentication. 'Key' doesn't expire but 'AMLToken' does.")
  authMode: EndpointAuthMode;

  @doc("Description of the inference endpoint.")
  description?: string;

  @doc("""
EndpointAuthKeys to set initially on an Endpoint.
This property will always be returned as null. AuthKey values must be retrieved using the ListKeys API.
""")
  @visibility("create")
  keys?: EndpointAuthKeys;

  @doc("Property dictionary. Properties can be added, but not removed or altered.")
  properties?: Record<string>;

  @doc("Endpoint URI.")
  @visibility("read")
  scoringUri?: string;

  @doc("Endpoint Swagger URI.")
  @visibility("read")
  swaggerUri?: string;
}

@doc("Keys for endpoint authentication.")
model EndpointAuthKeys {
  @doc("The primary key.")
  @visibility("read", "create")
  primaryKey?: string;

  @doc("The secondary key.")
  @visibility("read", "create")
  secondaryKey?: string;
}

@doc("Strictly used in update requests.")
model PartialMinimalTrackedResourceWithIdentity
  extends PartialMinimalTrackedResource {
  @doc("Managed service identity (system assigned and/or user assigned identities)")
  identity?: PartialManagedServiceIdentity;
}

@doc("Managed service identity (system assigned and/or user assigned identities)")
model PartialManagedServiceIdentity {
  @doc("Managed service identity (system assigned and/or user assigned identities)")
  type?: ManagedServiceIdentityType;

  @doc("The set of user assigned identities associated with the resource. The userAssignedIdentities dictionary keys will be ARM resource ids in the form: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}. The dictionary values can be empty objects ({}) in requests.")
  userAssignedIdentities?: Record<Record<unknown>>;
}

@doc("Strictly used in update requests.")
model PartialMinimalTrackedResource {
  @doc("Resource tags.")
  tags?: Record<string>;
}

@doc("Batch inference settings per deployment.")
model BatchDeployment extends EndpointDeploymentPropertiesBase {
  @doc("Compute target for batch inference operation.")
  compute?: string;

  @doc("Properties relevant to different deployment types.")
  deploymentConfiguration?: BatchDeploymentConfiguration;

  @doc("""
Error threshold, if the error count for the entire input goes above this value,
the batch inference will be aborted. Range is [-1, int.MaxValue].
For FileDataset, this value is the count of file failures.
For TabularDataset, this value is the count of record failures.
If set to -1 (the lower bound), all failures during batch inference will be ignored.
""")
  errorThreshold?: int32;

  @doc("Logging level for batch inference operation.")
  loggingLevel?: BatchLoggingLevel;

  @doc("Indicates maximum number of parallelism per instance.")
  maxConcurrencyPerInstance?: int32;

  @doc("""
Size of the mini-batch passed to each batch invocation.
For FileDataset, this is the number of files per mini-batch.
For TabularDataset, this is the size of the records in bytes, per mini-batch.
""")
  miniBatchSize?: int32;

  @doc("Reference to the model asset for the endpoint deployment.")
  `model`?: AssetReferenceBase;

  @doc("Indicates how the output will be organized.")
  outputAction?: BatchOutputAction;

  @doc("Customized output file name for append_row output action.")
  outputFileName?: string;

  @doc("Provisioning state for the endpoint deployment.")
  @visibility("read")
  provisioningState?: DeploymentProvisioningState;

  @doc("""
Indicates compute configuration for the job.
If not provided, will default to the defaults defined in ResourceConfiguration.
""")
  resources?: DeploymentResourceConfiguration;

  @doc("""
Retry Settings for the batch inference operation.
If not provided, will default to the defaults defined in BatchRetrySettings.
""")
  retrySettings?: BatchRetrySettings;
}

@doc("Properties relevant to different deployment types.")
@discriminator("deploymentConfigurationType")
model BatchDeploymentConfiguration {}

@doc("Base definition for asset references.")
@discriminator("referenceType")
model AssetReferenceBase {}

model DeploymentResourceConfiguration extends ResourceConfiguration {}

model ResourceConfiguration {
  @doc("Optional number of instances or nodes used by the compute target.")
  @visibility("read", "create")
  instanceCount?: int32;

  @doc("Optional type of VM used as supported by the compute target.")
  @visibility("read", "create")
  instanceType?: string;

  @doc("Locations where the job can run.")
  @visibility("read", "create")
  locations?: string[];

  @doc("""
Optional max allowed number of instances or nodes to be used by the compute target.
For use with elastic training, currently supported by PyTorch distribution type only.
""")
  @visibility("read", "create")
  maxInstanceCount?: int32;

  @doc("Additional properties bag.")
  @visibility("read", "create")
  properties?: Record<Record<unknown>>;
}

@doc("Retry settings for a batch inference operation.")
model BatchRetrySettings {
  @doc("Maximum retry count for a mini-batch")
  maxRetries?: int32;

  @doc("Invocation timeout for a mini-batch, in ISO 8601 format.")
  timeout?: duration;
}

@doc("Base definition for endpoint deployment.")
model EndpointDeploymentPropertiesBase {
  @doc("Code configuration for the endpoint deployment.")
  codeConfiguration?: CodeConfiguration;

  @doc("Description of the endpoint deployment.")
  description?: string;

  @doc("ARM resource ID of the environment specification for the endpoint deployment.")
  environmentId?: string;

  @doc("Environment variables configuration for the deployment.")
  environmentVariables?: Record<string>;

  @doc("Property dictionary. Properties can be added, but not removed or altered.")
  properties?: Record<string>;
}

@doc("Configuration for a scoring code asset.")
model CodeConfiguration {
  @doc("ARM resource ID of the code asset.")
  @visibility("read", "create")
  codeId?: string;

  @doc("[Required] The script to execute on startup. eg. \"score.py\"")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  scoringScript: string;
}

@doc("Strictly used in update requests.")
model PartialBatchDeploymentPartialMinimalTrackedResourceWithProperties {
  @doc("Additional attributes of the entity.")
  properties?: PartialBatchDeployment;

  @doc("Resource tags.")
  tags?: Record<string>;
}

@doc("Mutable batch inference settings per deployment.")
model PartialBatchDeployment {
  @doc("Description of the endpoint deployment.")
  description?: string;
}

@doc("Base definition for datastore contents configuration.")
@discriminator("datastoreType")
model Datastore extends ResourceBase {
  @doc("[Required] Account credentials.")
  credentials: DatastoreCredentials;

  @doc("Intellectual Property details.")
  @visibility("read", "create")
  intellectualProperty?: IntellectualProperty;

  @doc("Readonly property to indicate if datastore is the workspace default datastore")
  @visibility("read")
  isDefault?: boolean;
}

@doc("Base definition for datastore credentials.")
@discriminator("credentialsType")
model DatastoreCredentials {}

@doc("Base definition for datastore secrets.")
@discriminator("secretsType")
model DatastoreSecrets {}

@doc("Dto object representing feature set")
model FeaturesetContainerProperties extends AssetContainer {
  @doc("Provisioning state for the featureset container.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

@doc("Dto object representing feature")
model FeatureProperties extends ResourceBase {
  @doc("Specifies type")
  dataType?: FeatureDataType;

  @doc("Specifies name")
  featureName?: string;
}

@doc("Dto object representing feature set version")
model FeaturesetVersionProperties extends AssetBase {
  @doc("Specifies list of entities")
  entities?: string[];

  @doc("Specifies the materialization settings")
  materializationSettings?: MaterializationSettings;

  @doc("Provisioning state for the featureset version container.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;

  @doc("Specifies the feature spec details")
  specification?: FeaturesetSpecification;

  @doc("Specifies the asset stage")
  stage?: string;
}

model MaterializationSettings {
  @doc("Specifies the notification details")
  notification?: NotificationSetting;

  @doc("Specifies the compute resource settings")
  resource?: MaterializationComputeResource;

  @doc("Specifies the schedule details")
  schedule?: RecurrenceTrigger;

  @doc("Specifies the spark compute settings")
  sparkConfiguration?: Record<string>;

  @doc("Specifies the stores to which materialization should happen")
  storeType?: MaterializationStoreType;
}

@doc("Configuration for notification.")
model NotificationSetting {
  @doc("Send email notification to user on specified notification type")
  @visibility("read", "create")
  emailOn?: EmailNotificationEnableType[];

  @doc("This is the email recipient list which has a limitation of 499 characters in total concat with comma separator")
  @visibility("read", "create")
  emails?: string[];

  @doc("Send webhook callback to a service. Key is a user-provided name for the webhook.")
  @visibility("read", "create", "update")
  webhooks?: Record<Webhook>;
}

@doc("Webhook base")
@discriminator("webhookType")
model Webhook {
  @doc("Send callback on a specified notification event")
  @visibility("read", "create")
  eventType?: string;
}

@doc("Dto object representing compute resource")
model MaterializationComputeResource {
  @doc("Specifies the instance type")
  instanceType?: string;
}

model RecurrenceTrigger extends TriggerBase {
  @doc("[Required] The frequency to trigger schedule.")
  frequency: RecurrenceFrequency;

  @doc("[Required] Specifies schedule interval in conjunction with frequency")
  interval: int32;

  @doc("The recurrence schedule.")
  schedule?: RecurrenceSchedule;

  @doc("[Required] ")
  triggerType: "Recurrence";
}

model RecurrenceSchedule {
  @doc("[Required] List of hours for the schedule.")
  hours: int32[];

  @doc("[Required] List of minutes for the schedule.")
  minutes: int32[];

  @doc("List of month days for the schedule")
  monthDays?: int32[];

  @doc("List of days for the schedule.")
  weekDays?: WeekDay[];
}

@discriminator("triggerType")
model TriggerBase {
  @doc("""
Specifies end time of schedule in ISO 8601, but without a UTC offset. Refer https://en.wikipedia.org/wiki/ISO_8601.
Recommented format would be \"2022-06-01T00:00:01\"
If not present, the schedule will run indefinitely
""")
  endTime?: string;

  @doc("Specifies start time of schedule in ISO 8601 format, but without a UTC offset.")
  startTime?: string;

  @doc("""
Specifies time zone in which the schedule runs.
TimeZone should follow Windows time zone format. Refer: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11
""")
  timeZone?: string;
}

@doc("Dto object representing specification")
model FeaturesetSpecification {
  @doc("Specifies the spec path")
  path?: string;
}

@doc("Request payload for creating a backfill request for a given feature set version")
model FeaturesetVersionBackfillRequest {
  @doc("Specifies description")
  description?: string;

  @doc("Specifies description")
  displayName?: string;

  @doc("Specifies the backfill feature window to be materialized")
  featureWindow?: FeatureWindow;

  @doc("Specifies the compute resource settings")
  resource?: MaterializationComputeResource;

  @doc("Specifies the spark compute settings")
  sparkConfiguration?: Record<string>;

  @doc("Specifies the tags")
  tags?: Record<string>;
}

@doc("Specifies the feature window")
model FeatureWindow {
  @doc("Specifies the feature window end time")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  featureWindowEnd?: utcDateTime;

  @doc("Specifies the feature window start time")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  featureWindowStart?: utcDateTime;
}

@doc("Dto object representing the feature set job")
model FeaturesetJob {
  @doc("Specifies the created date")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDate?: utcDateTime;

  @doc("Specifies the display name")
  displayName?: string;

  @doc("Specifies the duration")
  duration?: duration;

  @doc("Specifies the experiment id")
  experimentId?: string;

  @doc("Specifies the backfill feature window to be materialized")
  featureWindow?: FeatureWindow;

  @doc("Specifies the job id")
  jobId?: string;

  @doc("Specifies the job status")
  status?: JobStatus;

  @doc("Specifies the tags if any")
  tags?: Record<string>;

  @doc("Specifies the feature store job type")
  type?: FeaturestoreJobType;
}

@doc("A paginated list of FeaturesetJob entities.")
model FeaturesetJobArmPaginatedResult is Azure.Core.Page<FeaturesetJob>;

@doc("Dto object representing feature entity")
model FeaturestoreEntityContainerProperties extends AssetContainer {
  @doc("Provisioning state for the featurestore entity container.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;
}

@doc("Dto object representing feature entity version")
model FeaturestoreEntityVersionProperties extends AssetBase {
  @doc("Specifies index columns")
  indexColumns?: IndexColumn[];

  @doc("Provisioning state for the featurestore entity version.")
  @visibility("read")
  provisioningState?: AssetProvisioningState;

  @doc("Specifies the asset stage")
  stage?: string;
}

@doc("Dto object representing index column")
model IndexColumn {
  @doc("Specifies the column name")
  columnName?: string;

  @doc("Specifies the data type")
  dataType?: FeatureDataType;
}

@doc("Base definition for a job.")
@discriminator("jobType")
model JobBase extends ResourceBase {
  @doc("ARM resource ID of the component resource.")
  @visibility("read", "create")
  componentId?: string;

  @doc("ARM resource ID of the compute resource.")
  @visibility("read", "create")
  computeId?: string;

  @doc("Display name of job.")
  @visibility("read", "create")
  displayName?: string;

  @doc("The name of the experiment the job belongs to. If not set, the job is placed in the \"Default\" experiment.")
  @visibility("read", "create")
  experimentName?: string;

  @doc("""
Identity configuration. If set, this should be one of AmlToken, ManagedIdentity, UserIdentity or null.
Defaults to AmlToken if null.
""")
  @visibility("read", "create")
  identity?: IdentityConfiguration;

  @doc("Is the asset archived?")
  @visibility("read", "create", "update")
  isArchived?: boolean;

  @doc("Notification setting for the job")
  @visibility("read", "create", "update")
  notificationSetting?: NotificationSetting;

  @doc("Configuration for secrets to be made available during runtime.")
  @visibility("read", "create")
  secretsConfiguration?: Record<SecretConfiguration>;

  @doc("""
List of JobEndpoints.
For local jobs, a job endpoint will have an endpoint value of FileStreamObject.
""")
  services?: Record<JobService>;

  @doc("Status of the job.")
  @visibility("read")
  status?: JobStatus;
}

@doc("Base definition for identity configuration.")
@discriminator("identityType")
model IdentityConfiguration {}

@doc("Secret Configuration definition.")
model SecretConfiguration {
  @doc("""
Secret Uri.
Sample Uri : https://myvault.vault.azure.net/secrets/mysecretname/secretversion
""")
  @visibility("read", "create")
  uri?: string;

  @doc("Name of secret in workspace key vault.")
  @visibility("read", "create")
  workspaceSecretName?: string;
}

@doc("Job endpoint definition")
model JobService {
  @doc("Url for endpoint.")
  @visibility("read", "create")
  endpoint?: string;

  @doc("Any error in the service.")
  @visibility("read")
  errorMessage?: string;

  @doc("Endpoint type.")
  @visibility("read", "create")
  jobServiceType?: string;

  @doc("""
Nodes that user would like to start the service on.
If Nodes is not set or set to null, the service will only be started on leader node.
""")
  nodes?: Nodes;

  @doc("Port for endpoint set by user.")
  @visibility("read", "create")
  port?: int32;

  @doc("Additional properties to set on the endpoint.")
  properties?: Record<string>;

  @doc("Status of endpoint.")
  @visibility("read")
  status?: string;
}

@doc("Abstract Nodes definition")
@discriminator("nodesValueType")
model Nodes {}

@doc("Azure Resource Manager resource envelope strictly used in update requests.")
model PartialJobBasePartialResource {
  @doc("Additional attributes of the entity.")
  properties?: PartialJobBase;
}

@doc("Mutable base definition for a job.")
model PartialJobBase {
  @doc("Mutable notification setting for the job")
  notificationSetting?: PartialNotificationSetting;
}

@doc("Mutable configuration for notification.")
model PartialNotificationSetting {
  @doc("Send webhook callback to a service. Key is a user-provided name for the webhook.")
  webhooks?: Record<Webhook>;
}

@doc("Labeling job definition")
model LabelingJobProperties extends JobBase {
  @doc("Created time of the job in UTC timezone.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("Configuration of data used in the job.")
  @visibility("read", "create")
  dataConfiguration?: LabelingDataConfiguration;

  @doc("Labeling instructions of the job.")
  @visibility("read", "create", "update")
  jobInstructions?: LabelingJobInstructions;

  @doc("Label categories of the job.")
  @visibility("read", "create", "update")
  labelCategories?: Record<LabelCategory>;

  @doc("Media type specific properties in the job.")
  @visibility("read", "create")
  labelingJobMediaProperties?: LabelingJobMediaProperties;

  @doc("Configuration of MLAssist feature in the job.")
  @visibility("read", "create")
  mlAssistConfiguration?: MLAssistConfiguration;

  @doc("Progress metrics of the job.")
  @visibility("read")
  progressMetrics?: ProgressMetrics;

  @doc("Internal id of the job(Previously called project).")
  @visibility("read")
  projectId?: string;

  @doc("Specifies the labeling job provisioning state.")
  @visibility("read")
  provisioningState?: JobProvisioningState;

  @doc("Status messages of the job.")
  @visibility("read")
  statusMessages?: StatusMessage[];

  @doc("[Required] Specifies the type of job.")
  jobType: "Labeling";
}

@doc("Labeling data configuration definition")
model LabelingDataConfiguration {
  @doc("Resource Id of the data asset to perform labeling.")
  @visibility("read", "create")
  dataId?: string;

  @doc("Indicates whether to enable incremental data refresh.")
  @visibility("read", "create", "update")
  incrementalDataRefresh?: IncrementalDataRefresh;
}

@doc("Instructions for labeling job")
model LabelingJobInstructions {
  @doc("The link to a page with detailed labeling instructions for labelers.")
  @visibility("read", "create", "update")
  uri?: string;
}

@doc("Label category definition")
model LabelCategory {
  @doc("Dictionary of label classes in this category.")
  @visibility("read", "create", "update")
  classes?: Record<LabelClass>;

  @doc("Display name of the label category.")
  @visibility("read", "create")
  displayName?: string;

  @doc("Indicates whether it is allowed to select multiple classes in this category.")
  @visibility("read", "create", "update")
  multiSelect?: MultiSelect;
}

@doc("Label class definition")
model LabelClass {
  @doc("Display name of the label class.")
  @visibility("read", "create")
  displayName?: string;

  @doc("Dictionary of subclasses of the label class.")
  @visibility("read", "create", "update")
  subclasses?: Record<LabelClass>;
}

@doc("Properties of a labeling job")
@discriminator("mediaType")
model LabelingJobMediaProperties {}

@doc("Labeling MLAssist configuration definition")
@discriminator("mlAssist")
model MLAssistConfiguration {}

@doc("Progress metrics definition")
model ProgressMetrics {
  @doc("The completed datapoint count.")
  @visibility("read")
  completedDatapointCount?: int32;

  @doc("The time of last successful incremental data refresh in UTC.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  incrementalDataLastRefreshDateTime?: utcDateTime;

  @doc("The skipped datapoint count.")
  @visibility("read")
  skippedDatapointCount?: int32;

  @doc("The total datapoint count.")
  @visibility("read")
  totalDatapointCount?: int32;
}

@doc("Active message associated with project")
model StatusMessage {
  @doc("Service-defined message code.")
  @visibility("read")
  code?: string;

  @doc("Time in UTC at which the message was created.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("Severity level of message.")
  @visibility("read")
  level?: StatusMessageLevel;

  @doc("A human-readable representation of the message code.")
  @visibility("read")
  message?: string;
}

@discriminator("format")
model ExportSummary {
  @doc("The time when the export was completed.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  @doc("The total number of labeled datapoints exported.")
  @visibility("read")
  exportedRowCount?: int32;

  @doc("Name and identifier of the job containing exported labels.")
  @visibility("read")
  labelingJobId?: string;

  @doc("The time when the export was requested.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;
}

@doc("Online endpoint configuration")
model OnlineEndpoint extends EndpointPropertiesBase {
  @doc("""
ARM resource ID of the compute if it exists.
optional
""")
  compute?: string;

  @doc("Percentage of traffic to be mirrored to each deployment without using returned scoring. Traffic values need to sum to utmost 50.")
  mirrorTraffic?: Record<int32>;

  @doc("Provisioning state for the endpoint.")
  @visibility("read")
  provisioningState?: EndpointProvisioningState;

  @doc("Set to \"Enabled\" for endpoints that should allow public access when Private Link is enabled.")
  publicNetworkAccess?: PublicNetworkAccessType;

  @doc("Percentage of traffic from endpoint to divert to each deployment. Traffic values need to sum to 100.")
  traffic?: Record<int32>;
}

@discriminator("endpointComputeType")
model OnlineDeployment extends EndpointDeploymentPropertiesBase {
  @doc("If true, enables Application Insights logging.")
  appInsightsEnabled?: boolean;

  @doc("The mdc configuration, we disable mdc when it's null.")
  dataCollector?: DataCollector;

  @doc("If Enabled, allow egress public network access. If Disabled, this will create secure egress. Default: Enabled.")
  egressPublicNetworkAccess?: EgressPublicNetworkAccessType;

  @doc("Compute instance type.")
  @visibility("read", "create")
  instanceType?: string;

  @doc("Liveness probe monitors the health of the container regularly.")
  livenessProbe?: ProbeSettings;

  @doc("The URI path to the model.")
  `model`?: string;

  @doc("The path to mount the model in custom container.")
  modelMountPath?: string;

  @doc("Provisioning state for the endpoint deployment.")
  @visibility("read")
  provisioningState?: DeploymentProvisioningState;

  @doc("Readiness probe validates if the container is ready to serve traffic. The properties and defaults are the same as liveness probe.")
  readinessProbe?: ProbeSettings;

  @doc("Request settings for the deployment.")
  requestSettings?: OnlineRequestSettings;

  @doc("""
Scale settings for the deployment.
If it is null or not provided,
it defaults to TargetUtilizationScaleSettings for KubernetesOnlineDeployment
and to DefaultScaleSettings for ManagedOnlineDeployment.
""")
  scaleSettings?: OnlineScaleSettings;
}

model DataCollector {
  @doc("""
[Required] The collection configuration. Each collection has it own configuration to collect model data and the name of collection can be arbitrary string.
Model data collector can be used for either payload logging or custom logging or both of them. Collection request and response are reserved for payload logging, others are for custom logging.
""")
  collections: Record<Collection>;

  @doc("The request logging configuration for mdc, it includes advanced logging settings for all collections. It's optional.")
  requestLogging?: RequestLogging;

  @doc("""
When model data is collected to blob storage, we need to roll the data to different path to avoid logging all of them in a single blob file.
If the rolling rate is hour, all data will be collected in the blob path /yyyy/MM/dd/HH/.
If it's day, all data will be collected in blob path /yyyy/MM/dd/.
The other benefit of rolling path is that model monitoring ui is able to select a time range of data very quickly.
""")
  rollingRate?: RollingRateType;
}

model Collection {
  @doc("The msi client id used to collect logging to blob storage. If it's null,backend will pick a registered endpoint identity to auth.")
  clientId?: string;

  @doc("Enable or disable data collection.")
  dataCollectionMode?: DataCollectionMode;

  @doc("The data asset arm resource id. Client side will ensure data asset is pointing to the blob storage, and backend will collect data to the blob storage.")
  dataId?: string;

  @doc("The sampling rate for collection. Sampling rate 1.0 means we collect 100% of data by default.")
  samplingRate?: float32;
}

model RequestLogging {
  @doc("For payload logging, we only collect payload by default. If customers also want to collect the specified headers, they can set them in captureHeaders so that backend will collect those headers along with payload.")
  captureHeaders?: string[];
}

@doc("Deployment container liveness/readiness probe configuration.")
model ProbeSettings {
  @doc("The number of failures to allow before returning an unhealthy status.")
  failureThreshold?: int32;

  @doc("The delay before the first probe in ISO 8601 format.")
  initialDelay?: duration;

  @doc("The length of time between probes in ISO 8601 format.")
  period?: duration;

  @doc("The number of successful probes before returning a healthy status.")
  successThreshold?: int32;

  @doc("The probe timeout in ISO 8601 format.")
  timeout?: duration;
}

@doc("Online deployment scoring requests configuration.")
model OnlineRequestSettings {
  @doc("The number of maximum concurrent requests per node allowed per deployment. Defaults to 1.")
  maxConcurrentRequestsPerInstance?: int32;

  @doc("""
The maximum amount of time a request will stay in the queue in ISO 8601 format.
Defaults to 500ms.
""")
  maxQueueWait?: duration;

  @doc("""
The scoring timeout in ISO 8601 format.
Defaults to 5000ms.
""")
  requestTimeout?: duration;
}

@doc("Online deployment scaling configuration.")
@discriminator("scaleType")
model OnlineScaleSettings {}

@doc("Strictly used in update requests.")
model PartialMinimalTrackedResourceWithSku
  extends PartialMinimalTrackedResource {
  @doc("Sku details required for ARM contract for Autoscaling.")
  sku?: PartialSku;
}

@doc("Common SKU definition.")
model PartialSku {
  @doc("If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.")
  capacity?: int32;

  @doc("If the service has different generations of hardware, for the same SKU, then that can be captured here.")
  family?: string;

  @doc("The name of the SKU. Ex - P3. It is typically a letter+number code.")
  name?: string;

  @doc("The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.")
  size?: string;

  @doc("This field is required to be implemented by the Resource Provider if the service has more than one tier, but is not required on a PUT.")
  tier?: SkuTier;
}

model DeploymentLogsRequest {
  @doc("The type of container to retrieve logs from.")
  containerType?: ContainerType;

  @doc("The maximum number of lines to tail.")
  tail?: int32;
}

model DeploymentLogs {
  @doc("The retrieved online deployment logs.")
  content?: string;
}

@doc("A paginated list of SkuResource entities.")
model SkuResourceArmPaginatedResult is Azure.Core.Page<SkuResource>;

@doc("Fulfills ARM Contract requirement to list all available SKUS for a resource.")
model SkuResource {
  @doc("Gets or sets the Sku Capacity.")
  capacity?: SkuCapacity;

  @doc("The resource type name.")
  @visibility("read")
  resourceType?: string;

  @doc("Gets or sets the Sku.")
  sku?: SkuSetting;
}

@doc("SKU capacity information")
model SkuCapacity {
  @doc("Gets or sets the default capacity.")
  default?: int32;

  @doc("Gets or sets the maximum.")
  maximum?: int32;

  @doc("Gets or sets the minimum.")
  minimum?: int32;

  @doc("Gets or sets the type of the scale.")
  scaleType?: SkuScaleType;
}

@doc("SkuSetting fulfills the need for stripped down SKU info in ARM contract.")
model SkuSetting {
  @doc("[Required] The name of the SKU. Ex - P3. It is typically a letter+number code.")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  name: string;

  @doc("This field is required to be implemented by the Resource Provider if the service has more than one tier, but is not required on a PUT.")
  tier?: SkuTier;
}

model RegenerateEndpointKeysRequest {
  @doc("[Required] Specification for which type of key to generate. Primary or Secondary.")
  keyType: KeyType;

  @doc("The value the key is set to.")
  keyValue?: string;
}

@doc("Service Token")
model EndpointAuthToken {
  @doc("Access token for endpoint authentication.")
  accessToken?: string;

  @doc("Access token expiry time (UTC).")
  expiryTimeUtc?: plainTime;

  @doc("Refresh access token after time (UTC).")
  refreshAfterTimeUtc?: plainTime;

  @doc("Access token type.")
  tokenType?: string;
}

@doc("Base definition of a schedule")
model ScheduleProperties extends ResourceBase {
  @doc("[Required] Specifies the action of the schedule")
  @visibility("read", "create", "update")
  action: ScheduleActionBase;

  @doc("Display name of schedule.")
  @visibility("read", "create")
  displayName?: string;

  @doc("Is the schedule enabled?")
  @visibility("read", "create", "update")
  isEnabled?: boolean;

  @doc("Provisioning state for the schedule.")
  @visibility("read")
  provisioningState?: ScheduleProvisioningStatus;

  @doc("[Required] Specifies the trigger details")
  @visibility("read", "create", "update")
  trigger: TriggerBase;
}

@discriminator("actionType")
model ScheduleActionBase {}

@doc("Details of the Registry")
model RegistryProperties {
  @doc("Discovery URL for the Registry")
  discoveryUrl?: string;

  @doc("IntellectualPropertyPublisher for the registry")
  intellectualPropertyPublisher?: string;

  @doc("ResourceId of the managed RG if the registry has system created resources")
  managedResourceGroup?: ArmResourceId;

  @doc("MLFlow Registry URI for the Registry")
  mlFlowRegistryUri?: string;

  @doc("Private endpoint connections info used for pending connections in private link portal")
  privateEndpointConnections?: RegistryPrivateEndpointConnection[];

  @doc("""
Is the Registry accessible from the internet?
Possible values: \"Enabled\" or \"Disabled\"
""")
  publicNetworkAccess?: string;

  @doc("Details of each region the registry is in")
  regionDetails?: RegistryRegionArmDetails[];
}

@doc("ARM ResourceId of a resource")
model ArmResourceId {
  @doc("""
Arm ResourceId is in the format \"/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Storage/storageAccounts/{StorageAccountName}\"
or \"/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.ContainerRegistry/registries/{AcrName}\"
""")
  resourceId?: string;
}

@doc("Private endpoint connection definition.")
model RegistryPrivateEndpointConnection {
  @doc("""
This is the private endpoint connection name created on SRP
Full resource id: /subscriptions/{subId}/resourceGroups/{rgName}/providers/Microsoft.MachineLearningServices/{resourceType}/{resourceName}/privateEndpointConnections/{peConnectionName}
""")
  id?: string;

  @doc("Same as workspace location.")
  @visibility("read", "create")
  location?: string;

  @doc("Properties of the Private Endpoint Connection")
  properties?: RegistryPrivateEndpointConnectionProperties;
}

@doc("Properties of the Private Endpoint Connection")
model RegistryPrivateEndpointConnectionProperties {
  @doc("The group ids")
  groupIds?: string[];

  @doc("The PE network resource that is linked to this PE connection.")
  privateEndpoint?: PrivateEndpointResource;

  @doc("The connection state.")
  privateLinkServiceConnectionState?: RegistryPrivateLinkServiceConnectionState;

  @doc("One of null, \"Succeeded\", \"Provisioning\", \"Failed\". While not approved, it's null.")
  provisioningState?: string;
}

@doc("The PE network resource that is linked to this PE connection.")
model PrivateEndpointResource extends PrivateEndpoint {
  @doc("The subnetId that the private endpoint is connected to.")
  subnetArmId?: string;
}

@doc("The Private Endpoint resource.")
model PrivateEndpoint {
  @doc("The ARM identifier for Private Endpoint")
  @visibility("read")
  id?: string;
}

@doc("The connection state.")
model RegistryPrivateLinkServiceConnectionState {
  @doc("Some RP chose \"None\". Other RPs use this for region expansion.")
  actionsRequired?: string;

  @doc("User-defined message that, per NRP doc, may be used for approval-related message.")
  description?: string;

  @doc("Connection status of the service consumer with the service provider")
  status?: EndpointServiceConnectionStatus;
}

@doc("Details for each region the registry is in")
model RegistryRegionArmDetails {
  @doc("List of ACR accounts")
  acrDetails?: AcrDetails[];

  @doc("The location where the registry exists")
  location?: string;

  @doc("List of storage accounts")
  storageAccountDetails?: StorageAccountDetails[];
}

@doc("Details of ACR account to be used for the Registry")
model AcrDetails {
  @doc("Details of system created ACR account to be used for the Registry")
  systemCreatedAcrAccount?: SystemCreatedAcrAccount;

  @doc("Details of user created ACR account to be used for the Registry. Not supported in most cases and will throw 400 error if provided.")
  userCreatedAcrAccount?: UserCreatedAcrAccount;
}

model SystemCreatedAcrAccount {
  @doc("Name of the ACR account")
  acrAccountName?: string;

  @doc("SKU of the ACR account")
  acrAccountSku?: string;

  @doc("This is populated once the ACR account is created.")
  armResourceId?: ArmResourceId;
}

model UserCreatedAcrAccount {
  @doc("ARM ResourceId of a resource")
  armResourceId?: ArmResourceId;
}

@doc("Details of storage account to be used for the Registry")
model StorageAccountDetails {
  @doc("Details of system created storage account to be used for the registry")
  systemCreatedStorageAccount?: SystemCreatedStorageAccount;

  @doc("Details of user created storage account to be used for the registry.  Not supported in most cases and will throw 400 error if provided.")
  userCreatedStorageAccount?: UserCreatedStorageAccount;
}

model SystemCreatedStorageAccount {
  @doc("Public blob access allowed")
  allowBlobPublicAccess?: boolean;

  @doc("This is populated once the storage account is created.")
  armResourceId?: ArmResourceId;

  @doc("HNS enabled for storage account")
  storageAccountHnsEnabled?: boolean;

  @doc("Name of the storage account")
  storageAccountName?: string;

  @doc("""
Allowed values:
\"Standard_LRS\",
\"Standard_GRS\",
\"Standard_RAGRS\",
\"Standard_ZRS\",
\"Standard_GZRS\",
\"Standard_RAGZRS\",
\"Premium_LRS\",
\"Premium_ZRS\"
""")
  storageAccountType?: string;
}

model UserCreatedStorageAccount {
  @doc("ARM ResourceId of a resource")
  armResourceId?: ArmResourceId;
}

@doc("Strictly used in update requests.")
model PartialRegistryPartialTrackedResource {
  @doc("Managed service identity (system assigned and/or user assigned identities)")
  identity?: RegistryPartialManagedServiceIdentity;

  @doc("Sku details required for ARM contract for Autoscaling.")
  sku?: PartialSku;

  @doc("Resource tags.")
  tags?: Record<string>;
}

@doc("Managed service identity (system assigned and/or user assigned identities)")
model RegistryPartialManagedServiceIdentity extends ManagedServiceIdentity {}

@doc("The List Aml user feature operation response.")
model ListAmlUserFeatureResult is Azure.Core.Page<AmlUserFeature>;

@doc("Features enabled for a workspace")
model AmlUserFeature {
  @doc("Specifies the feature ID")
  id?: string;

  @doc("Specifies the feature name ")
  displayName?: string;

  @doc("Describes the feature for user experience")
  description?: string;
}

@doc("Azure Machine Learning team account REST API operation")
model AmlOperation {
  @doc("Gets or sets display name of operation")
  display?: OperationDisplay;

  @doc("Indicates whether the operation applies to data-plane")
  isDataAction?: boolean;

  @doc("Gets or sets operation name: {provider}/{resource}/{operation}")
  name?: string;

  @doc("The intended executor of the operation: user/system")
  origin?: string;
}

@doc("The properties of a machine learning workspace.")
model WorkspaceProperties {
  @doc("The flag to indicate whether to allow public access when behind VNet.")
  allowPublicAccessWhenBehindVnet?: boolean;

  @doc("ARM id of the application insights associated with this workspace.")
  applicationInsights?: string;

  associatedWorkspaces?: string[];
  containerRegistries?: string[];

  @doc("ARM id of the container registry associated with this workspace.")
  containerRegistry?: string;

  @doc("The description of this workspace.")
  description?: string;

  @doc("Url for the discovery service to identify regional endpoints for machine learning experimentation services")
  discoveryUrl?: string;

  enableDataIsolation?: boolean;
  encryption?: EncryptionProperty;
  existingWorkspaces?: string[];

  @doc("Settings for feature store type workspace.")
  featureStoreSettings?: FeatureStoreSettings;

  @doc("The friendly name for this workspace. This name in mutable")
  friendlyName?: string;

  @doc("The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service")
  hbiWorkspace?: boolean;

  hubResourceId?: string;

  @doc("The compute name for image build")
  imageBuildCompute?: string;

  @doc("ARM id of the key vault associated with this workspace. This cannot be changed once the workspace has been created")
  keyVault?: string;

  keyVaults?: string[];

  @doc("Managed Network settings for a machine learning workspace.")
  managedNetwork?: ManagedNetworkSettings;

  @doc("The URI associated with this workspace that machine learning flow must point at to set up tracking.")
  @visibility("read")
  mlFlowTrackingUri?: string;

  @doc("The notebook info of Azure ML workspace.")
  @visibility("read")
  notebookInfo?: NotebookResourceInfo;

  @doc("The user assigned identity resource id that represents the workspace identity.")
  primaryUserAssignedIdentity?: string;

  @doc("The list of private endpoint connections in the workspace.")
  @visibility("read")
  privateEndpointConnections?: PrivateEndpointConnection[];

  @doc("Count of private connections in the workspace")
  @visibility("read")
  privateLinkCount?: int32;

  @doc("The current deployment state of workspace resource. The provisioningState is to indicate states for resource provisioning.")
  @visibility("read")
  provisioningState?: ProvisioningState;

  @doc("Whether requests from Public Network are allowed.")
  publicNetworkAccess?: PublicNetworkAccessType;

  @doc("The service managed resource settings.")
  serviceManagedResourcesSettings?: ServiceManagedResourcesSettings;

  @doc("The name of the managed resource group created by workspace RP in customer subscription if the workspace is CMK workspace")
  @visibility("read")
  serviceProvisionedResourceGroup?: string;

  @doc("The list of shared private link resources in this workspace.")
  sharedPrivateLinkResources?: SharedPrivateLinkResource[];

  @doc("Retention time in days after workspace get soft deleted.")
  softDeleteRetentionInDays?: int32;

  @doc("ARM id of the storage account associated with this workspace. This cannot be changed once the workspace has been created")
  storageAccount?: string;

  storageAccounts?: string[];

  @doc("If the storage associated with the workspace has hierarchical namespace(HNS) enabled.")
  @visibility("read")
  storageHnsEnabled?: boolean;

  @doc("The auth mode used for accessing the system datastores of the workspace.")
  systemDatastoresAuthMode?: string;

  @doc("The tenant id associated with this workspace.")
  @visibility("read")
  tenantId?: string;

  @doc("Enabling v1_legacy_mode may prevent you from using features provided by the v2 API.")
  v1LegacyMode?: boolean;

  @doc("WorkspaceHub's configuration object.")
  workspaceHubConfig?: WorkspaceHubConfig;

  @doc("The immutable id associated with this workspace.")
  @visibility("read")
  workspaceId?: string;
}

model EncryptionProperty {
  @doc("""
The byok cosmosdb account that customer brings to store customer's data
with encryption
""")
  cosmosDbResourceId?: string;

  @doc("Identity to be used with the keyVault")
  identity?: IdentityForCmk;

  @doc("KeyVault details to do the encryption")
  keyVaultProperties: KeyVaultProperties;

  @doc("""
The byok search account that customer brings to store customer's data
with encryption
""")
  searchAccountResourceId?: string;

  @doc("Indicates whether or not the encryption is enabled for the workspace.")
  status: EncryptionStatus;

  @doc("""
The byok storage account that customer brings to store customer's data
with encryption
""")
  storageAccountResourceId?: string;
}

@doc("Identity object used for encryption.")
model IdentityForCmk {
  @doc("UserAssignedIdentity to be used to fetch the encryption key from keyVault")
  userAssignedIdentity?: string;
}

@doc("Customer Key vault properties.")
model KeyVaultProperties {
  @doc("""
Currently, we support only SystemAssigned MSI.
We need this when we support UserAssignedIdentities
""")
  identityClientId?: string;

  @doc("KeyVault key identifier to encrypt the data")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  keyIdentifier: string;

  @doc("KeyVault Arm Id that contains the data encryption key")
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

@doc("Managed Network settings for a machine learning workspace.")
model ManagedNetworkSettings {
  @doc("Isolation mode for the managed network of a machine learning workspace.")
  isolationMode?: IsolationMode;

  @visibility("read")
  networkId?: string;

  @doc("Dictionary of <OutboundRule>")
  outboundRules?: Record<OutboundRule>;

  @doc("Status of the Provisioning for the managed network of a machine learning workspace.")
  status?: ManagedNetworkProvisionStatus;
}

@doc("Outbound Rule for the managed network of a machine learning workspace.")
@discriminator("type")
model OutboundRule {
  @doc("Category of a managed network Outbound Rule of a machine learning workspace.")
  category?: RuleCategory;

  @doc("Type of a managed network Outbound Rule of a machine learning workspace.")
  status?: RuleStatus;
}

@doc("Status of the Provisioning for the managed network of a machine learning workspace.")
model ManagedNetworkProvisionStatus {
  sparkReady?: boolean;

  @doc("Status for the managed network of a machine learning workspace.")
  status?: ManagedNetworkStatus;
}

model NotebookResourceInfo {
  fqdn?: string;
  isPrivateLinkEnabled?: boolean;

  @doc("The error that occurs when preparing notebook.")
  notebookPreparationError?: NotebookPreparationError;

  @doc("the data plane resourceId that used to initialize notebook component")
  resourceId?: string;
}

model NotebookPreparationError {
  errorMessage?: string;
  statusCode?: int32;
}

@doc("Private endpoint connection properties.")
model PrivateEndpointConnectionProperties {
  @doc("The Private Endpoint resource.")
  privateEndpoint?: WorkspacePrivateEndpointResource;

  @doc("The connection state.")
  privateLinkServiceConnectionState?: PrivateLinkServiceConnectionState;

  @doc("The current provisioning state.")
  @visibility("read")
  provisioningState?: PrivateEndpointConnectionProvisioningState;
}

@doc("The Private Endpoint resource.")
model WorkspacePrivateEndpointResource {
  @doc("e.g. /subscriptions/{networkSubscriptionId}/resourceGroups/{rgName}/providers/Microsoft.Network/privateEndpoints/{privateEndpointName}")
  @visibility("read")
  id?: string;

  @doc("The subnetId that the private endpoint is connected to.")
  @visibility("read")
  subnetArmId?: string;
}

@doc("A collection of information about the state of the connection between service consumer and provider.")
model PrivateLinkServiceConnectionState {
  @doc("Some RP chose \"None\". Other RPs use this for region expansion.")
  actionsRequired?: string;

  @doc("User-defined message that, per NRP doc, may be used for approval-related message.")
  description?: string;

  @doc("Connection status of the service consumer with the service provider")
  status?: EndpointServiceConnectionStatus;
}

model ServiceManagedResourcesSettings {
  cosmosDb?: CosmosDbSettings;
}

model CosmosDbSettings {
  collectionsThroughput?: int32;
}

model SharedPrivateLinkResource {
  @doc("Unique name of the private link")
  name?: string;

  @doc("Properties of a shared private link resource.")
  properties?: SharedPrivateLinkResourceProperty;
}

@doc("Properties of a shared private link resource.")
model SharedPrivateLinkResourceProperty {
  @doc("group id of the private link")
  groupId?: string;

  @doc("the resource id that private link links to")
  privateLinkResourceId?: string;

  @doc("Request message")
  requestMessage?: string;

  @doc("Connection status of the service consumer with the service provider")
  status?: EndpointServiceConnectionStatus;
}

@doc("WorkspaceHub's configuration object.")
model WorkspaceHubConfig {
  additionalWorkspaceStorageAccounts?: string[];
  defaultWorkspaceResourceGroup?: string;
}

@doc("The parameters for updating a machine learning workspace.")
model WorkspaceUpdateParameters {
  @doc("Managed service identity (system assigned and/or user assigned identities)")
  identity?: ManagedServiceIdentity;

  @doc("The properties that the machine learning workspace will be updated with.")
  properties?: WorkspacePropertiesUpdateParameters;

  @doc("Optional. This field is required to be implemented by the RP because AML is supporting more than one tier")
  sku?: Sku;

  @doc("The resource tags for the machine learning workspace.")
  tags?: Record<string>;
}

@doc("The parameters for updating a machine learning workspace.")
model WorkspacePropertiesUpdateParameters {
  @doc("ARM id of the application insights associated with this workspace.")
  applicationInsights?: string;

  @doc("ARM id of the container registry associated with this workspace.")
  containerRegistry?: string;

  @doc("The description of this workspace.")
  description?: string;

  enableDataIsolation?: boolean;
  encryption?: EncryptionUpdateProperties;

  @doc("Settings for feature store type workspace.")
  featureStoreSettings?: FeatureStoreSettings;

  @doc("The friendly name for this workspace. This name in mutable")
  friendlyName?: string;

  @doc("The compute name for image build")
  imageBuildCompute?: string;

  @doc("Managed Network settings for a machine learning workspace.")
  managedNetwork?: ManagedNetworkSettings;

  @doc("The user assigned identity resource id that represents the workspace identity.")
  primaryUserAssignedIdentity?: string;

  @doc("Whether requests from Public Network are allowed.")
  publicNetworkAccess?: PublicNetworkAccessType;

  @doc("The service managed resource settings.")
  serviceManagedResourcesSettings?: ServiceManagedResourcesSettings;

  @doc("Retention time in days after workspace get soft deleted.")
  softDeleteRetentionInDays?: int32;

  @doc("Enabling v1_legacy_mode may prevent you from using features provided by the v2 API.")
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
  @doc("Category of the connection")
  category?: ConnectionCategory;

  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expiryTime?: utcDateTime;

  @doc("Any object")
  metadata?: Record<unknown>;

  target?: string;
}

@doc("The properties that the machine learning workspace connection will be updated with.")
model WorkspaceConnectionUpdateParameter {
  @doc("The properties that the machine learning workspace connection will be updated with.")
  properties?: WorkspaceConnectionPropertiesV2;
}

@doc("Parameters to diagnose a workspace")
model DiagnoseWorkspaceParameters {
  value?: DiagnoseRequestProperties;
}

model DiagnoseRequestProperties {
  @doc("Setting for diagnosing dependent application insights")
  applicationInsights?: Record<unknown>;

  @doc("Setting for diagnosing dependent container registry")
  containerRegistry?: Record<unknown>;

  @doc("Setting for diagnosing dns resolution")
  dnsResolution?: Record<unknown>;

  @doc("Setting for diagnosing dependent key vault")
  keyVault?: Record<unknown>;

  @doc("Setting for diagnosing network security group")
  nsg?: Record<unknown>;

  @doc("Setting for diagnosing unclassified category of problems")
  others?: Record<unknown>;

  @doc("Setting for diagnosing resource lock")
  resourceLock?: Record<unknown>;

  @doc("Setting for diagnosing dependent storage account")
  storageAccount?: Record<unknown>;

  @doc("Setting for diagnosing user defined routing")
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

@doc("Result of Diagnose")
model DiagnoseResult {
  @doc("Code for workspace setup error")
  @visibility("read")
  code?: string;

  @doc("Level of workspace setup error")
  @visibility("read")
  level?: DiagnoseResultLevel;

  @doc("Message of workspace setup error")
  @visibility("read")
  message?: string;
}

model ListWorkspaceKeysResult {
  @doc("The access key of the workspace app insights")
  @visibility("read")
  appInsightsInstrumentationKey?: string;

  containerRegistryCredentials?: RegistryListCredentialsResult;
  notebookAccessKeys?: ListNotebookKeysResult;

  @doc("The arm Id key of the workspace storage")
  @visibility("read")
  userStorageArmId?: string;

  @doc("The access key of the workspace storage")
  @visibility("read")
  userStorageKey?: string;
}

model RegistryListCredentialsResult {
  @doc("The location of the workspace ACR")
  @visibility("read")
  location?: string;

  passwords?: Password[];

  @doc("The username of the workspace ACR")
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
  @doc("The primary access key of the Notebook")
  @visibility("read")
  primaryAccessKey?: string;

  @doc("The secondary access key of the Notebook")
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
  @doc("The access key of the storage")
  @visibility("read")
  userStorageKey?: string;
}

model ExternalFqdnResponse {
  value?: FqdnEndpointsPropertyBag[];
}

@doc("Property bag for FQDN endpoints result")
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

@doc("A list of private link resources")
@pagedResult
model PrivateLinkResourceListResult {
  @items
  value?: PrivateLinkResource[];
}

@doc("A private link resource")
model PrivateLinkResource extends Resource {
  @doc("Managed service identity (system assigned and/or user assigned identities)")
  identity?: ManagedServiceIdentity;

  @doc("Same as workspace location.")
  location?: string;

  @doc("Properties of a private link resource.")
  properties?: PrivateLinkResourceProperties;

  @doc("Optional. This field is required to be implemented by the RP because AML is supporting more than one tier")
  sku?: Sku;

  @doc("Dictionary of <string>")
  tags?: Record<string>;
}

@doc("Properties of a private link resource.")
model PrivateLinkResourceProperties {
  @doc("The private link resource group id.")
  @visibility("read")
  groupId?: string;

  @doc("The private link resource required member names.")
  @visibility("read")
  requiredMembers?: string[];

  @doc("The private link resource Private link DNS zone name.")
  requiredZoneNames?: string[];
}

@doc("Managed Network Provisioning options for managed network of a machine learning workspace.")
model ManagedNetworkProvisionOptions {
  includeSpark?: boolean;
}

@doc("Represents a resource ID. For example, for a subnet, it is the resource URL for the subnet.")
model ResourceId {
  @doc("The ID of the resource")
  id: string;
}

@doc("A Machine Learning compute based on AKS.")
model AKS extends Compute {
  ...AKSSchema;

  @doc("The type of compute")
  computeType: "AKS";
}

model AKSSchema {
  @doc("AKS properties")
  properties?: AKSSchemaProperties;
}

@doc("AKS properties")
model AKSSchemaProperties {
  @doc("Cluster full qualified domain name")
  clusterFqdn?: string;

  @doc("System services")
  @visibility("read")
  systemServices?: SystemService[];

  @doc("Number of agents")
  agentCount?: int32;

  @doc("Agent virtual machine size")
  agentVmSize?: string;

  @doc("Intended usage of the cluster")
  clusterPurpose?: ClusterPurpose;

  @doc("SSL configuration")
  sslConfiguration?: SslConfiguration;

  @doc("AKS networking configuration for vnet")
  aksNetworkingConfiguration?: AksNetworkingConfiguration;

  @doc("Load Balancer Type")
  loadBalancerType?: LoadBalancerType;

  @doc("Load Balancer Subnet")
  loadBalancerSubnet?: string;
}

@doc("A system service running on a compute.")
model SystemService {
  @doc("The type of this system service.")
  @visibility("read")
  systemServiceType?: string;

  @doc("Public IP address")
  @visibility("read")
  publicIpAddress?: string;

  @doc("The version for this type.")
  @visibility("read")
  version?: string;
}

@doc("The ssl configuration for scoring")
model SslConfiguration {
  @doc("Enable or disable ssl for scoring")
  status?: SslConfigStatus;

  @doc("Cert data")
  cert?: string;

  @doc("Key data")
  key?: string;

  @doc("CNAME of the cert")
  cname?: string;

  @doc("Leaf domain label of public endpoint")
  leafDomainLabel?: string;

  @doc("Indicates whether to overwrite existing domain label.")
  overwriteExistingDomain?: boolean;
}

@doc("Advance configuration for AKS networking")
model AksNetworkingConfiguration {
  @doc("Virtual network subnet resource ID the compute nodes belong to")
  subnetId?: string;

  @doc("A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.")
  @pattern("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$")
  serviceCidr?: string;

  @doc("An IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.")
  @pattern("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$")
  dnsServiceIP?: string;

  @doc("A CIDR notation IP range assigned to the Docker bridge network. It must not overlap with any Subnet IP ranges or the Kubernetes service address range.")
  @pattern("^([0-9]{1,3}\\.){3}[0-9]{1,3}(\\/([0-9]|[1-2][0-9]|3[0-2]))?$")
  dockerBridgeCidr?: string;
}

@doc("A Machine Learning compute based on Kubernetes Compute.")
model Kubernetes extends Compute {
  ...KubernetesSchema;

  @doc("The type of compute")
  computeType: "Kubernetes";
}

@doc("Kubernetes Compute Schema")
model KubernetesSchema {
  @doc("Properties of Kubernetes")
  properties?: KubernetesProperties;
}

@doc("Kubernetes properties")
model KubernetesProperties {
  @doc("Relay connection string.")
  relayConnectionString?: string;

  @doc("ServiceBus connection string.")
  serviceBusConnectionString?: string;

  @doc("Extension principal-id.")
  extensionPrincipalId?: string;

  @doc("Extension instance release train.")
  extensionInstanceReleaseTrain?: string;

  @doc("VC name.")
  vcName?: string;

  @doc("Compute namespace")
  `namespace`?: string;

  @doc("Default instance type")
  defaultInstanceType?: string;

  @doc("Instance Type Schema")
  instanceTypes?: Record<InstanceTypeSchema>;
}

@doc("Instance type schema.")
model InstanceTypeSchema {
  @doc("Node Selector")
  nodeSelector?: Record<string>;

  @doc("Resource requests/limits for this instance type")
  resources?: InstanceTypeSchemaResources;
}

@doc("Resource requests/limits for this instance type")
model InstanceTypeSchemaResources {
  @doc("Resource requests for this instance type")
  requests?: Record<string>;

  @doc("Resource limits for this instance type")
  limits?: Record<string>;
}

@doc("AML Compute properties")
model AmlComputeProperties {
  @doc("Compute OS Type")
  osType?: OsType;

  @doc("Virtual Machine Size")
  vmSize?: string;

  @doc("Virtual Machine priority")
  vmPriority?: VmPriority;

  @doc("Virtual Machine image for AML Compute - windows only")
  virtualMachineImage?: VirtualMachineImage;

  @doc("Network is isolated or not")
  isolatedNetwork?: boolean;

  @doc("Scale settings for AML Compute")
  scaleSettings?: ScaleSettings;

  @doc("Credentials for an administrator user account that will be created on each compute node.")
  userAccountCredentials?: UserAccountCredentials;

  @doc("Virtual network subnet resource ID the compute nodes belong to.")
  subnet?: ResourceId;

  @doc("State of the public SSH port. Possible values are: Disabled - Indicates that the public ssh port is closed on all nodes of the cluster. Enabled - Indicates that the public ssh port is open on all nodes of the cluster. NotSpecified - Indicates that the public ssh port is closed on all nodes of the cluster if VNet is defined, else is open all public nodes. It can be default only during cluster creation time, after creation it will be either enabled or disabled.")
  remoteLoginPortPublicAccess?: RemoteLoginPortPublicAccess;

  @doc("Allocation state of the compute. Possible values are: steady - Indicates that the compute is not resizing. There are no changes to the number of compute nodes in the compute in progress. A compute enters this state when it is created and when no operations are being performed on the compute to change the number of compute nodes. resizing - Indicates that the compute is resizing; that is, compute nodes are being added to or removed from the compute.")
  @visibility("read")
  allocationState?: AllocationState;

  @doc("The time at which the compute entered its current allocation state.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  allocationStateTransitionTime?: utcDateTime;

  @doc("Collection of errors encountered by various compute nodes during node setup.")
  @visibility("read")
  errors?: ErrorResponse[];

  @doc("The number of compute nodes currently assigned to the compute.")
  @visibility("read")
  currentNodeCount?: int32;

  @doc("The target number of compute nodes for the compute. If the allocationState is resizing, this property denotes the target node count for the ongoing resize operation. If the allocationState is steady, this property denotes the target node count for the previous resize operation.")
  @visibility("read")
  targetNodeCount?: int32;

  @doc("Counts of various node states on the compute.")
  @visibility("read")
  nodeStateCounts?: NodeStateCounts;

  @doc("Enable or disable node public IP address provisioning. Possible values are: Possible values are: true - Indicates that the compute nodes will have public IPs provisioned. false - Indicates that the compute nodes will have a private endpoint and no public IPs.")
  enableNodePublicIp?: boolean;

  @doc("A property bag containing additional properties.")
  propertyBag?: Record<unknown>;
}

@doc("Virtual Machine image for Windows AML Compute")
model VirtualMachineImage {
  @doc("Virtual Machine image path")
  id: string;
}

@doc("Settings for user account that gets created on each on the nodes of a compute.")
model UserAccountCredentials {
  @doc("Name of the administrator user account which can be used to SSH to nodes.")
  adminUserName: string;

  @doc("SSH public key of the administrator user account.")
  adminUserSshPublicKey?: string;

  @doc("Password of the administrator user account.")
  adminUserPassword?: string;
}

@doc("Counts of various compute node states on the amlCompute.")
model NodeStateCounts {
  @doc("Number of compute nodes in idle state.")
  @visibility("read")
  idleNodeCount?: int32;

  @doc("Number of compute nodes which are running jobs.")
  @visibility("read")
  runningNodeCount?: int32;

  @doc("Number of compute nodes which are being prepared.")
  @visibility("read")
  preparingNodeCount?: int32;

  @doc("Number of compute nodes which are in unusable state.")
  @visibility("read")
  unusableNodeCount?: int32;

  @doc("Number of compute nodes which are leaving the amlCompute.")
  @visibility("read")
  leavingNodeCount?: int32;

  @doc("Number of compute nodes which are in preempted state.")
  @visibility("read")
  preemptedNodeCount?: int32;
}

@doc("An Azure Machine Learning compute.")
model AmlCompute extends Compute {
  ...AmlComputeSchema;

  @doc("The type of compute")
  computeType: "AmlCompute";
}

@doc("Properties(top level) of AmlCompute")
model AmlComputeSchema {
  @doc("Properties of AmlCompute")
  properties?: AmlComputeProperties;
}

@doc("Compute Instance properties")
model ComputeInstanceProperties {
  @doc("Virtual Machine Size")
  vmSize?: string;

  @doc("Virtual network subnet resource ID the compute nodes belong to.")
  subnet?: ResourceId;

  @doc("Policy for sharing applications on this compute instance among users of parent workspace. If Personal, only the creator can access applications on this compute instance. When Shared, any workspace user can access applications on this instance depending on his/her assigned role.")
  applicationSharingPolicy?: ApplicationSharingPolicy;

  @doc("Specifies settings for autologger.")
  autologgerSettings?: ComputeInstanceAutologgerSettings;

  @doc("Specifies policy and settings for SSH access.")
  sshSettings?: ComputeInstanceSshSettings;

  @doc("List of Custom Services added to the compute.")
  customServices?: CustomService[];

  @doc("Returns metadata about the operating system image for this compute instance.")
  @visibility("read")
  osImageMetadata?: ImageMetadata;

  @doc("Describes all connectivity endpoints available for this ComputeInstance.")
  @visibility("read")
  connectivityEndpoints?: ComputeInstanceConnectivityEndpoints;

  @doc("Describes available applications and their endpoints on this ComputeInstance.")
  @visibility("read")
  applications?: ComputeInstanceApplication[];

  @doc("Describes information on user who created this ComputeInstance.")
  @visibility("read")
  createdBy?: ComputeInstanceCreatedBy;

  @doc("Collection of errors encountered on this ComputeInstance.")
  @visibility("read")
  errors?: ErrorResponse[];

  @doc("The current state of this ComputeInstance.")
  @visibility("read")
  state?: ComputeInstanceState;

  @doc("The Compute Instance Authorization type. Available values are personal (default).")
  computeInstanceAuthorizationType?: ComputeInstanceAuthorizationType;

  @doc("Settings for a personal compute instance.")
  personalComputeInstanceSettings?: PersonalComputeInstanceSettings;

  @doc("Details of customized scripts to execute for setting up the cluster.")
  setupScripts?: SetupScripts;

  @doc("The last operation on ComputeInstance.")
  @visibility("read")
  lastOperation?: ComputeInstanceLastOperation;

  @doc("The list of schedules to be applied on the computes.")
  schedules?: ComputeSchedules;

  @doc("Stops compute instance after user defined period of inactivity. Time is defined in ISO8601 format. Minimum is 15 min, maximum is 3 days.")
  idleTimeBeforeShutdown?: string;

  @doc("Enable or disable node public IP address provisioning. Possible values are: Possible values are: true - Indicates that the compute nodes will have public IPs provisioned. false - Indicates that the compute nodes will have a private endpoint and no public IPs.")
  enableNodePublicIp?: boolean;

  @doc("Describes informations of containers on this ComputeInstance.")
  @visibility("read")
  containers?: ComputeInstanceContainer[];

  @doc("Describes informations of dataDisks on this ComputeInstance.")
  @visibility("read")
  dataDisks?: ComputeInstanceDataDisk[];

  @doc("Describes informations of dataMounts on this ComputeInstance.")
  @visibility("read")
  dataMounts?: ComputeInstanceDataMount[];

  @doc("ComputeInstance version.")
  @visibility("read")
  versions?: ComputeInstanceVersion;
}

@doc("Specifies settings for autologger.")
model ComputeInstanceAutologgerSettings {
  @doc("Indicates whether mlflow autologger is enabled for notebooks.")
  mlflowAutologger?: MlflowAutologger;
}

@doc("Specifies policy and settings for SSH access.")
model ComputeInstanceSshSettings {
  @doc("State of the public SSH port. Possible values are: Disabled - Indicates that the public ssh port is closed on this instance. Enabled - Indicates that the public ssh port is open and accessible according to the VNet/subnet policy if applicable.")
  sshPublicAccess?: SshPublicAccess;

  @doc("Describes the admin user name.")
  @visibility("read")
  adminUserName?: string;

  @doc("Describes the port for connecting through SSH.")
  @visibility("read")
  sshPort?: int32;

  @doc("Specifies the SSH rsa public key file as a string. Use \"ssh-keygen -t rsa -b 2048\" to generate your SSH key pairs.")
  adminPublicKey?: string;
}

@doc("Returns metadata about the operating system image for this compute instance.")
model ImageMetadata {
  @doc("Specifies the current operating system image version this compute instance is running on.")
  currentImageVersion?: string;

  @doc("Specifies the latest available operating system image version.")
  latestImageVersion?: string;

  @doc("Specifies whether this compute instance is running on the latest operating system image.")
  isLatestOsImageVersion?: boolean;
}

@doc("Defines all connectivity endpoints and properties for an ComputeInstance.")
model ComputeInstanceConnectivityEndpoints {
  @doc("Public IP Address of this ComputeInstance.")
  @visibility("read")
  publicIpAddress?: string;

  @doc("Private IP Address of this ComputeInstance (local to the VNET in which the compute instance is deployed).")
  @visibility("read")
  privateIpAddress?: string;
}

@doc("Defines an Aml Instance application and its connectivity endpoint URI.")
model ComputeInstanceApplication {
  @doc("Name of the ComputeInstance application.")
  displayName?: string;

  @doc("Application' endpoint URI.")
  endpointUri?: string;
}

@doc("Describes information on user who created this ComputeInstance.")
model ComputeInstanceCreatedBy {
  @doc("Name of the user.")
  @visibility("read")
  userName?: string;

  @doc("Uniquely identifies user' Azure Active Directory organization.")
  @visibility("read")
  userOrgId?: string;

  @doc("Uniquely identifies the user within his/her organization.")
  @visibility("read")
  userId?: string;
}

@doc("Settings for a personal compute instance.")
model PersonalComputeInstanceSettings {
  @doc("A user explicitly assigned to a personal compute instance.")
  assignedUser?: AssignedUser;
}

@doc("A user that can be assigned to a compute instance.")
model AssignedUser {
  @doc("User’s AAD Object Id.")
  objectId: string;

  @doc("User’s AAD Tenant Id.")
  tenantId: string;
}

@doc("Details of customized scripts to execute for setting up the cluster.")
model SetupScripts {
  @doc("Customized setup scripts")
  scripts?: ScriptsToExecute;
}

@doc("Customized setup scripts")
model ScriptsToExecute {
  @doc("Script that's run every time the machine starts.")
  startupScript?: ScriptReference;

  @doc("Script that's run only once during provision of the compute.")
  creationScript?: ScriptReference;
}

@doc("Script reference")
model ScriptReference {
  @doc("The storage source of the script: inline, workspace.")
  scriptSource?: string;

  @doc("The location of scripts in the mounted volume.")
  scriptData?: string;

  @doc("Optional command line arguments passed to the script to run.")
  scriptArguments?: string;

  @doc("Optional time period passed to timeout command.")
  timeout?: string;
}

@doc("The last operation on ComputeInstance.")
model ComputeInstanceLastOperation {
  @doc("Name of the last operation.")
  operationName?: OperationName;

  @doc("Time of the last operation.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  operationTime?: utcDateTime;

  @doc("Operation status.")
  operationStatus?: OperationStatus;

  @doc("Trigger of operation.")
  operationTrigger?: OperationTrigger;
}

@doc("The list of schedules to be applied on the computes")
model ComputeSchedules {
  @doc("The list of compute start stop schedules to be applied.")
  computeStartStop?: ComputeStartStopSchedule[];
}

@doc("Compute start stop schedule properties")
model ComputeStartStopSchedule {
  @doc("A system assigned id for the schedule.")
  @visibility("read")
  id?: string;

  @doc("The current deployment state of schedule.")
  @visibility("read")
  provisioningStatus?: ProvisioningStatus;

  @doc("Is the schedule enabled or disabled?")
  status?: ScheduleStatus;

  @doc("[Required] The compute power action.")
  action?: ComputePowerAction;

  @doc("[Required] The schedule trigger type.")
  triggerType?: TriggerType;

  @doc("Required if triggerType is Recurrence.")
  recurrence?: Recurrence;

  @doc("Required if triggerType is Cron.")
  cron?: Cron;

  @doc("[Deprecated] Not used any more.")
  schedule?: ScheduleBase;
}

@doc("The workflow trigger recurrence for ComputeStartStop schedule type.")
model Recurrence {
  @doc("[Required] The frequency to trigger schedule.")
  frequency?: RecurrenceFrequency;

  @doc("[Required] Specifies schedule interval in conjunction with frequency")
  interval?: int32;

  @doc("The start time in yyyy-MM-ddTHH:mm:ss format.")
  startTime?: string;

  @doc("""
Specifies time zone in which the schedule runs.
TimeZone should follow Windows time zone format. Refer: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11
""")
  timeZone?: string;

  @doc("[Required] The recurrence schedule.")
  schedule?: RecurrenceSchedule;
}

@doc("The workflow trigger cron for ComputeStartStop schedule type.")
model Cron {
  @doc("The start time in yyyy-MM-ddTHH:mm:ss format.")
  startTime?: string;

  @doc("""
Specifies time zone in which the schedule runs.
TimeZone should follow Windows time zone format. Refer: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11
""")
  timeZone?: string;

  @doc("""
[Required] Specifies cron expression of schedule.
The expression should follow NCronTab format.
""")
  expression?: string;
}

model ScheduleBase {
  @doc("A system assigned id for the schedule.")
  id?: string;

  @doc("The current deployment state of schedule.")
  provisioningStatus?: ScheduleProvisioningState;

  @doc("Is the schedule enabled or disabled?")
  status?: ScheduleStatus;
}

@doc("Defines an Aml Instance container.")
model ComputeInstanceContainer {
  @doc("Name of the ComputeInstance container.")
  name?: string;

  @doc("Auto save settings.")
  autosave?: Autosave;

  @doc("Information of GPU.")
  gpu?: string;

  @doc("network of this container.")
  network?: Network;

  @doc("Environment information of this container.")
  environment?: ComputeInstanceEnvironmentInfo;

  @doc("services of this containers.")
  @visibility("read")
  services?: Record<unknown>[];
}

@doc("Environment information")
model ComputeInstanceEnvironmentInfo {
  @doc("name of environment.")
  name?: string;

  @doc("version of environment.")
  version?: string;
}

@doc("Defines an Aml Instance DataDisk.")
model ComputeInstanceDataDisk {
  @doc("Caching type of Data Disk.")
  caching?: Caching;

  @doc("The initial disk size in gigabytes.")
  diskSizeGB?: int32;

  @doc("The lun is used to uniquely identify each data disk. If attaching multiple disks, each should have a distinct lun.")
  lun?: int32;

  @doc("type of this storage account.")
  storageAccountType?: StorageAccountType;
}

@doc("Defines an Aml Instance DataMount.")
model ComputeInstanceDataMount {
  @doc("Source of the ComputeInstance data mount.")
  source?: string;

  @doc("Data source type.")
  sourceType?: SourceType;

  @doc("name of the ComputeInstance data mount.")
  mountName?: string;

  @doc("Mount Action.")
  mountAction?: MountAction;

  @doc("who this data mount created by.")
  createdBy?: string;

  @doc("Path of this data mount.")
  mountPath?: string;

  @doc("Mount state.")
  mountState?: MountState;

  @doc("The time when the disk mounted.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  mountedOn?: utcDateTime;

  @doc("Error of this data mount.")
  error?: string;
}

@doc("Version of computeInstance.")
model ComputeInstanceVersion {
  @doc("Runtime of compute instance.")
  runtime?: string;
}

@doc("An Azure Machine Learning compute instance.")
model ComputeInstance extends Compute {
  ...ComputeInstanceSchema;

  @doc("The type of compute")
  computeType: "ComputeInstance";
}

@doc("Properties(top level) of ComputeInstance")
model ComputeInstanceSchema {
  @doc("Properties of ComputeInstance")
  properties?: ComputeInstanceProperties;
}

@doc("A Machine Learning compute based on Azure Virtual Machines.")
model VirtualMachine extends Compute {
  ...VirtualMachineSchema;

  @doc("The type of compute")
  computeType: "VirtualMachine";
}

model VirtualMachineSchema {
  properties?: VirtualMachineSchemaProperties;
}

model VirtualMachineSchemaProperties {
  @doc("Virtual Machine size")
  virtualMachineSize?: string;

  @doc("Port open for ssh connections.")
  sshPort?: int32;

  @doc("Notebook server port open for ssh connections.")
  notebookServerPort?: int32;

  @doc("Public IP address of the virtual machine.")
  address?: string;

  @doc("Admin credentials for virtual machine")
  administratorAccount?: VirtualMachineSshCredentials;

  @doc("Indicates whether this compute will be used for running notebooks.")
  isNotebookInstanceCompute?: boolean;
}

@doc("Admin credentials for virtual machine")
model VirtualMachineSshCredentials {
  @doc("Username of admin account")
  username?: string;

  @doc("Password of admin account")
  password?: string;

  @doc("Public key data")
  publicKeyData?: string;

  @doc("Private key data")
  privateKeyData?: string;
}

@doc("HDInsight compute properties")
model HDInsightProperties {
  @doc("Port open for ssh connections on the master node of the cluster.")
  sshPort?: int32;

  @doc("Public IP address of the master node of the cluster.")
  address?: string;

  @doc("Admin credentials for master node of the cluster")
  administratorAccount?: VirtualMachineSshCredentials;
}

@doc("A HDInsight compute.")
model HDInsight extends Compute {
  ...HDInsightSchema;

  @doc("The type of compute")
  computeType: "HDInsight";
}

model HDInsightSchema {
  @doc("HDInsight compute properties")
  properties?: HDInsightProperties;
}

@doc("A DataFactory compute.")
model DataFactory extends Compute {
  @doc("The type of compute")
  computeType: "DataFactory";
}

@doc("Properties of Databricks")
model DatabricksProperties {
  @doc("Databricks access token")
  databricksAccessToken?: string;

  @doc("Workspace Url")
  workspaceUrl?: string;
}

@doc("A DataFactory compute.")
model Databricks extends Compute {
  ...DatabricksSchema;

  @doc("The type of compute")
  computeType: "Databricks";
}

model DatabricksSchema {
  @doc("Properties of Databricks")
  properties?: DatabricksProperties;
}

@doc("A DataLakeAnalytics compute.")
model DataLakeAnalytics extends Compute {
  ...DataLakeAnalyticsSchema;

  @doc("The type of compute")
  computeType: "DataLakeAnalytics";
}

model DataLakeAnalyticsSchema {
  properties?: DataLakeAnalyticsSchemaProperties;
}

model DataLakeAnalyticsSchemaProperties {
  @doc("DataLake Store Account Name")
  dataLakeStoreAccountName?: string;
}

@doc("A SynapseSpark compute.")
model SynapseSpark extends Compute {
  properties?: SynapseSparkProperties;

  @doc("The type of compute")
  computeType: "SynapseSpark";
}

model SynapseSparkProperties {
  @doc("Auto scale properties.")
  autoScaleProperties?: AutoScaleProperties;

  @doc("Auto pause properties.")
  autoPauseProperties?: AutoPauseProperties;

  @doc("Spark version.")
  sparkVersion?: string;

  @doc("The number of compute nodes currently assigned to the compute.")
  nodeCount?: int32;

  @doc("Node size.")
  nodeSize?: string;

  @doc("Node size family.")
  nodeSizeFamily?: string;

  @doc("Azure subscription identifier.")
  subscriptionId?: string;

  @doc("Name of the resource group in which workspace is located.")
  resourceGroup?: string;

  @doc("Name of Azure Machine Learning workspace.")
  workspaceName?: string;

  @doc("Pool name.")
  poolName?: string;
}

@doc("Auto scale properties")
model AutoScaleProperties {
  minNodeCount?: int32;
  enabled?: boolean;
  maxNodeCount?: int32;
}

@doc("Auto pause properties")
model AutoPauseProperties {
  delayInMinutes?: int32;
  enabled?: boolean;
}

@doc("Properties of AksComputeSecrets")
model AksComputeSecretsProperties {
  @doc("Content of kubeconfig file that can be used to connect to the Kubernetes cluster.")
  userKubeConfig?: string;

  @doc("Content of kubeconfig file that can be used to connect to the Kubernetes cluster.")
  adminKubeConfig?: string;

  @doc("Image registry pull secret.")
  imagePullSecretName?: string;
}

@doc("Secrets related to a Machine Learning compute based on AKS.")
model AksComputeSecrets extends ComputeSecrets {
  ...AksComputeSecretsProperties;

  @doc("The type of compute")
  computeType: "AKS";
}

@doc("Secrets related to a Machine Learning compute based on AKS.")
model VirtualMachineSecrets extends ComputeSecrets {
  ...VirtualMachineSecretsSchema;

  @doc("The type of compute")
  computeType: "VirtualMachine";
}

model VirtualMachineSecretsSchema {
  @doc("Admin credentials for virtual machine.")
  administratorAccount?: VirtualMachineSshCredentials;
}

@doc("Properties of Databricks Compute Secrets")
model DatabricksComputeSecretsProperties {
  @doc("access token for databricks account.")
  databricksAccessToken?: string;
}

@doc("Secrets related to a Machine Learning compute based on Databricks.")
model DatabricksComputeSecrets extends ComputeSecrets {
  ...DatabricksComputeSecretsProperties;

  @doc("The type of compute")
  computeType: "Databricks";
}

@doc("Account key datastore credentials configuration.")
model AccountKeyDatastoreCredentials extends DatastoreCredentials {
  @doc("[Required] Storage account secrets.")
  @visibility("create", "update")
  secrets: AccountKeyDatastoreSecrets;

  @doc("[Required] Credential type used to authentication with storage.")
  credentialsType: "AccountKey";
}

@doc("Datastore account key secrets.")
model AccountKeyDatastoreSecrets extends DatastoreSecrets {
  @doc("Storage account key.")
  key?: string;

  @doc("[Required] Credential type used to authentication with storage.")
  secretsType: "AccountKey";
}

model AllFeatures extends MonitoringFeatureFilterBase {
  @doc("[Required] Specifies the feature filter to leverage when selecting features to calculate metrics over.")
  filterType: "AllFeatures";
}

@discriminator("filterType")
model MonitoringFeatureFilterBase {}

@doc("All nodes means the service will be running on all of the nodes of the job")
model AllNodes extends Nodes {
  @doc("[Required] Type of the Nodes value")
  nodesValueType: "All";
}

@doc("AML Token identity configuration.")
model AmlToken extends IdentityConfiguration {
  @doc("[Required] Specifies the type of identity framework.")
  identityType: "AMLToken";
}

@doc("AML token compute identity definition.")
model AmlTokenComputeIdentity extends MonitorComputeIdentityBase {
  @doc("[Required] Monitor compute identity type enum.")
  computeIdentityType: "AmlToken";
}

@doc("Monitor compute identity base definition.")
@discriminator("computeIdentityType")
model MonitorComputeIdentityBase {}

@doc("Asset input type.")
model AssetJobInput {
  @doc("Input Asset Delivery Mode.")
  @visibility("read", "create")
  mode?: InputDeliveryMode;

  @doc("[Required] Input Asset URI.")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  uri: string;
}

@doc("Asset output type.")
model AssetJobOutput {
  @doc("Output Asset Name.")
  assetName?: string;

  @doc("Output Asset Version.")
  assetVersion?: string;

  @doc("Auto delete setting of output data asset.")
  @visibility("read", "create", "update")
  autoDeleteSetting?: AutoDeleteSetting;

  @doc("Output Asset Delivery Mode.")
  @visibility("read", "create")
  mode?: OutputDeliveryMode;

  @doc("Output Asset URI.")
  uri?: string;
}

@doc("Forecast horizon determined automatically by system.")
model AutoForecastHorizon extends ForecastHorizon {
  @doc("[Required] Set forecast horizon value selection mode.")
  mode: "Auto";
}

@doc("The desired maximum forecast horizon in units of time-series frequency.")
@discriminator("mode")
model ForecastHorizon {}

@doc("""
AutoMLJob class.
Use this class for executing AutoML tasks like Classification/Regression etc.
See TaskType enum for all the tasks supported.
""")
model AutoMLJob extends JobBase {
  @doc("""
The ARM resource ID of the Environment specification for the job.
This is optional value to provide, if not provided, AutoML will default this to Production AutoML curated environment version when running the job.
""")
  @visibility("read", "create")
  environmentId?: string;

  @doc("Environment variables included in the job.")
  @visibility("read", "create")
  environmentVariables?: Record<string>;

  @doc("Mapping of output data bindings used in the job.")
  @visibility("read", "create")
  outputs?: Record<JobOutput>;

  @doc("Queue settings for the job")
  @visibility("read", "create")
  queueSettings?: QueueSettings;

  @doc("Compute Resource configuration for the job.")
  @visibility("read", "create")
  resources?: JobResourceConfiguration;

  @doc("[Required] This represents scenario which can be one of Tables/NLP/Image")
  taskDetails: AutoMLVertical;

  @doc("[Required] Specifies the type of job.")
  jobType: "AutoML";
}

@doc("Job output definition container information on where to find job output/logs.")
@discriminator("jobOutputType")
model JobOutput {
  @doc("Description for the output.")
  @visibility("read", "create")
  description?: string;
}

model QueueSettings {
  @doc("Controls the compute job tier")
  @visibility("read", "create")
  jobTier?: JobTier;

  @doc("Controls the priority of the job on a compute.")
  @visibility("read", "create")
  priority?: int32;
}

model JobResourceConfiguration extends ResourceConfiguration {
  @doc("Extra arguments to pass to the Docker run command. This would override any parameters that have already been set by the system, or in this section. This parameter is only supported for Azure ML compute types.")
  @visibility("read", "create")
  dockerArgs?: string;

  @doc("Size of the docker container's shared memory block. This should be in the format of (number)(unit) where number as to be greater than 0 and the unit can be one of b(bytes), k(kilobytes), m(megabytes), or g(gigabytes).")
  @visibility("read", "create")
  @pattern("\\d+[bBkKmMgG]")
  shmSize?: string;
}

@doc("""
AutoML vertical class.
Base class for AutoML verticals - TableVertical/ImageVertical/NLPVertical
""")
@discriminator("taskType")
model AutoMLVertical {
  @doc("Log verbosity for the job.")
  logVerbosity?: LogVerbosity;

  @doc("""
Target column name: This is prediction values column.
Also known as label column name in context of classification tasks.
""")
  targetColumnName?: string;

  @doc("[Required] Training data input.")
  trainingData: MLTableJobInput;
}

model MLTableJobInput extends JobInput {
  ...AssetJobInput;

  @doc("[Required] Specifies the type of job.")
  jobInputType: "mltable";
}

@doc("Command job definition.")
@discriminator("jobInputType")
model JobInput {
  @doc("Description for the input.")
  @visibility("read", "create")
  description?: string;
}

@doc("N-Cross validations determined automatically.")
model AutoNCrossValidations extends NCrossValidations {
  @doc("[Required] Mode for determining N-Cross validations.")
  mode: "Auto";
}

@doc("N-Cross validations value.")
@discriminator("mode")
model NCrossValidations {}

model AutoSeasonality extends Seasonality {
  @doc("[Required] Seasonality mode.")
  mode: "Auto";
}

@doc("Forecasting seasonality.")
@discriminator("mode")
model Seasonality {}

model AutoTargetLags extends TargetLags {
  @doc("[Required] Set target lags mode - Auto/Custom")
  mode: "Auto";
}

@doc("The number of past periods to lag from the target column.")
@discriminator("mode")
model TargetLags {}

@doc("Target lags rolling window determined automatically.")
model AutoTargetRollingWindowSize extends TargetRollingWindowSize {
  @doc("[Required] TargetRollingWindowSiz detection mode.")
  mode: "Auto";
}

@doc("Forecasting target rolling window size.")
@discriminator("mode")
model TargetRollingWindowSize {}

@doc("Settings for Autologger.")
model AutologgerSettings {
  @doc("[Required] Indicates whether mlflow autologger is enabled.")
  @visibility("read", "create")
  mlflowAutologger: MLFlowAutologgerState;
}

model AzMonMonitoringAlertNotificationSettings
  extends MonitoringAlertNotificationSettingsBase {
  @doc("[Required] Specifies the type of signal to monitor.")
  alertNotificationType: "AzureMonitor";
}

@discriminator("alertNotificationType")
model MonitoringAlertNotificationSettingsBase {}

@doc("Azure Blob datastore configuration.")
model AzureBlobDatastore extends Datastore {
  ...AzureDatastore;

  @doc("Storage account name.")
  @visibility("read", "create")
  accountName?: string;

  @doc("Storage account container name.")
  @visibility("read", "create")
  containerName?: string;

  @doc("Azure cloud endpoint for the storage account.")
  @visibility("read", "create")
  endpoint?: string;

  @doc("Protocol used to communicate with the storage account.")
  @visibility("read", "create")
  protocol?: string;

  @doc("Indicates which identity to use to authenticate service data access to customer's storage.")
  @visibility("read", "create")
  serviceDataAccessAuthIdentity?: ServiceDataAccessAuthIdentity;

  @doc("[Required] Storage type backing the datastore.")
  datastoreType: "AzureBlob";
}

@doc("Base definition for Azure datastore contents configuration.")
model AzureDatastore {
  @doc("Azure Resource Group name")
  resourceGroup?: string;

  @doc("Azure Subscription Id")
  subscriptionId?: string;
}

@doc("Azure Data Lake Gen1 datastore configuration.")
model AzureDataLakeGen1Datastore extends Datastore {
  ...AzureDatastore;

  @doc("Indicates which identity to use to authenticate service data access to customer's storage.")
  @visibility("read", "create")
  serviceDataAccessAuthIdentity?: ServiceDataAccessAuthIdentity;

  @doc("[Required] Azure Data Lake store name.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  storeName: string;

  @doc("[Required] Storage type backing the datastore.")
  datastoreType: "AzureDataLakeGen1";
}

@doc("Azure Data Lake Gen2 datastore configuration.")
model AzureDataLakeGen2Datastore extends Datastore {
  ...AzureDatastore;

  @doc("[Required] Storage account name.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  accountName: string;

  @doc("Azure cloud endpoint for the storage account.")
  @visibility("read", "create")
  endpoint?: string;

  @doc("[Required] The name of the Data Lake Gen2 filesystem.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  filesystem: string;

  @doc("Protocol used to communicate with the storage account.")
  @visibility("read", "create")
  protocol?: string;

  @doc("Indicates which identity to use to authenticate service data access to customer's storage.")
  @visibility("read", "create")
  serviceDataAccessAuthIdentity?: ServiceDataAccessAuthIdentity;

  @doc("[Required] Storage type backing the datastore.")
  datastoreType: "AzureDataLakeGen2";
}

@doc("Webhook details specific for Azure DevOps")
model AzureDevOpsWebhook extends Webhook {
  @doc("[Required] Specifies the type of service to send a callback")
  webhookType: "AzureDevOps";
}

@doc("Azure File datastore configuration.")
model AzureFileDatastore extends Datastore {
  ...AzureDatastore;

  @doc("[Required] Storage account name.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  accountName: string;

  @doc("Azure cloud endpoint for the storage account.")
  @visibility("read", "create")
  endpoint?: string;

  @doc("[Required] The name of the Azure file share that the datastore points to.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  fileShareName: string;

  @doc("Protocol used to communicate with the storage account.")
  @visibility("read", "create")
  protocol?: string;

  @doc("Indicates which identity to use to authenticate service data access to customer's storage.")
  @visibility("read", "create")
  serviceDataAccessAuthIdentity?: ServiceDataAccessAuthIdentity;

  @doc("[Required] Storage type backing the datastore.")
  datastoreType: "AzureFile";
}

@doc("Azure ML batch inferencing server configurations.")
model AzureMLBatchInferencingServer extends InferencingServer {
  @doc("Code configuration for AML batch inferencing server.")
  codeConfiguration?: CodeConfiguration;

  @doc("[Required] Inferencing server type for various targets.")
  serverType: "AzureMLBatch";
}

@doc("Azure ML online inferencing configurations.")
model AzureMLOnlineInferencingServer extends InferencingServer {
  @doc("Code configuration for AML inferencing server.")
  codeConfiguration?: CodeConfiguration;

  @doc("[Required] Inferencing server type for various targets.")
  serverType: "AzureMLOnline";
}

@doc("Defines an early termination policy based on slack criteria, and a frequency and delay interval for evaluation")
model BanditPolicy extends EarlyTerminationPolicy {
  @doc("Absolute distance allowed from the best performing run.")
  slackAmount?: float32;

  @doc("Ratio of the allowed distance from the best performing run.")
  slackFactor?: float32;

  @doc("[Required] Name of policy configuration")
  policyType: "Bandit";
}

@doc("Early termination policies enable canceling poor-performing runs before they complete")
@discriminator("policyType")
model EarlyTerminationPolicy {
  @doc("Number of intervals by which to delay the first evaluation.")
  delayEvaluation?: int32;

  @doc("Interval (number of runs) between policy evaluations.")
  evaluationInterval?: int32;
}

@doc("Base environment type.")
model BaseEnvironmentId extends BaseEnvironmentSource {
  @doc("[Required] Resource id accepting ArmId or AzureMlId.")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  resourceId: string;

  @doc("[Required] Base environment type.")
  baseEnvironmentSourceType: "EnvironmentAsset";
}

@doc("Properties for a Batch Pipeline Component Deployment.")
model BatchPipelineComponentDeploymentConfiguration
  extends BatchDeploymentConfiguration {
  @doc("The ARM id of the component to be run.")
  componentId?: IdAssetReference;

  @doc("The description which will be applied to the job.")
  description?: string;

  @doc("Run-time settings for the pipeline job.")
  settings?: Record<string>;

  @doc("The tags which will be applied to the job.")
  tags?: Record<string>;

  @doc("[Required] The type of the deployment")
  deploymentConfigurationType: "PipelineComponent";
}

@doc("Reference to an asset via its ARM resource ID.")
model IdAssetReference extends AssetReferenceBase {
  @doc("[Required] ARM resource ID of the asset.")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  assetId: string;

  @doc("[Required] Specifies the type of asset reference.")
  referenceType: "Id";
}

@doc("Defines a Sampling Algorithm that generates values based on previous values")
model BayesianSamplingAlgorithm extends SamplingAlgorithm {
  @doc("[Required] The algorithm used for generating hyperparameter values, along with configuration properties")
  samplingAlgorithmType: "Bayesian";
}

@doc("""
The Sampling Algorithm used to generate hyperparameter values, along with properties to
configure the algorithm
""")
@discriminator("samplingAlgorithmType")
model SamplingAlgorithm {}

model CategoricalDataDriftMetricThreshold extends DataDriftMetricThresholdBase {
  @doc("[Required] The categorical data drift metric to calculate.")
  @visibility("read", "create")
  metric: CategoricalDataDriftMetric;

  @doc("[Required] Specifies the data type of the metric threshold.")
  dataType: "Categorical";
}

@discriminator("dataType")
model DataDriftMetricThresholdBase {
  @doc("The threshold value. If null, a default value will be set depending on the selected metric.")
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

model MonitoringThreshold {
  @doc("The threshold value. If null, the set default is dependent on the metric type.")
  @visibility("read", "create")
  value?: float32;
}

model CategoricalDataQualityMetricThreshold
  extends DataQualityMetricThresholdBase {
  @doc("[Required] The categorical data quality metric to calculate.")
  @visibility("read", "create")
  metric: CategoricalDataQualityMetric;

  @doc("[Required] Specifies the data type of the metric threshold.")
  dataType: "Categorical";
}

@discriminator("dataType")
model DataQualityMetricThresholdBase {
  @doc("The threshold value. If null, a default value will be set depending on the selected metric.")
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

model CategoricalPredictionDriftMetricThreshold
  extends PredictionDriftMetricThresholdBase {
  @doc("[Required] The categorical prediction drift metric to calculate.")
  @visibility("read", "create")
  metric: CategoricalPredictionDriftMetric;

  @doc("[Required] Specifies the data type of the metric threshold.")
  dataType: "Categorical";
}

@discriminator("dataType")
model PredictionDriftMetricThresholdBase {
  @doc("The threshold value. If null, a default value will be set depending on the selected metric.")
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

@doc("Certificate datastore credentials configuration.")
model CertificateDatastoreCredentials extends DatastoreCredentials {
  @doc("Authority URL used for authentication.")
  authorityUrl?: string;

  @doc("[Required] Service principal client ID.")
  clientId: string;

  @doc("Resource the service principal has access to.")
  resourceUrl?: string;

  @doc("[Required] Service principal secrets.")
  @visibility("create", "update")
  secrets: CertificateDatastoreSecrets;

  @doc("[Required] ID of the tenant to which the service principal belongs.")
  tenantId: string;

  @doc("[Required] Thumbprint of the certificate used for authentication.")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  thumbprint: string;

  @doc("[Required] Credential type used to authentication with storage.")
  credentialsType: "Certificate";
}

@doc("Datastore certificate secrets.")
model CertificateDatastoreSecrets extends DatastoreSecrets {
  @doc("Service principal certificate.")
  certificate?: string;

  @doc("[Required] Credential type used to authentication with storage.")
  secretsType: "Certificate";
}

@doc("Classification task in AutoML Table vertical.")
model Classification extends AutoMLVertical {
  ...TableVertical;

  @doc("Positive label for binary metrics calculation.")
  positiveLabel?: string;

  @doc("Primary metric for the task.")
  primaryMetric?: ClassificationPrimaryMetrics;

  @doc("Inputs for training phase for an AutoML Job.")
  trainingSettings?: ClassificationTrainingSettings;

  @doc("[Required] Task type for AutoMLJob.")
  taskType: "Classification";
}

@doc("Classification Training related configuration.")
model ClassificationTrainingSettings extends TrainingSettings {
  @doc("Allowed models for classification task.")
  allowedTrainingAlgorithms?: ClassificationModels[];

  @doc("Blocked models for classification task.")
  blockedTrainingAlgorithms?: ClassificationModels[];
}

@doc("Training related configuration.")
model TrainingSettings {
  @doc("Enable recommendation of DNN models.")
  enableDnnTraining?: boolean;

  @doc("Flag to turn on explainability on best model.")
  enableModelExplainability?: boolean;

  @doc("Flag for enabling onnx compatible models.")
  enableOnnxCompatibleModels?: boolean;

  @doc("Enable stack ensemble run.")
  enableStackEnsemble?: boolean;

  @doc("Enable voting ensemble run.")
  enableVoteEnsemble?: boolean;

  @doc("""
During VotingEnsemble and StackEnsemble model generation, multiple fitted models from the previous child runs are downloaded.
Configure this parameter with a higher value than 300 secs, if more time is needed.
""")
  ensembleModelDownloadTimeout?: duration;

  @doc("Stack ensemble settings for stack ensemble run.")
  stackEnsembleSettings?: StackEnsembleSettings;

  @doc("""
TrainingMode mode - Setting to 'auto' is same as setting it to 'non-distributed' for now, however in the future may result in mixed mode or heuristics based mode selection. Default is 'auto'.
If 'Distributed' then only distributed featurization is used and distributed algorithms are chosen.
If 'NonDistributed' then only non distributed algorithms are chosen.
""")
  trainingMode?: TrainingMode;
}

@doc("Advances setting to customize StackEnsemble run.")
model StackEnsembleSettings {
  @doc("Optional parameters to pass to the initializer of the meta-learner.")
  stackMetaLearnerKWargs?: Record<unknown>;

  @doc("Specifies the proportion of the training set (when choosing train and validation type of training) to be reserved for training the meta-learner. Default value is 0.2.")
  stackMetaLearnerTrainPercentage?: float32;

  @doc("The meta-learner is a model trained on the output of the individual heterogeneous models.")
  stackMetaLearnerType?: StackMetaLearnerType;
}

@doc("Abstract class for AutoML tasks that use table dataset as input - such as Classification/Regression/Forecasting.")
model TableVertical {
  @doc("Columns to use for CVSplit data.")
  cvSplitColumnNames?: string[];

  @doc("Featurization inputs needed for AutoML job.")
  featurizationSettings?: TableVerticalFeaturizationSettings;

  @doc("Model/training parameters that will remain constant throughout training.")
  fixedParameters?: TableFixedParameters;

  @doc("Execution constraints for AutoMLJob.")
  limitSettings?: TableVerticalLimitSettings;

  @doc("""
Number of cross validation folds to be applied on training dataset
when validation dataset is not provided.
""")
  nCrossValidations?: NCrossValidations;

  @doc("Search space for sampling different combinations of models and their hyperparameters.")
  searchSpace?: TableParameterSubspace[];

  @doc("Settings for model sweeping and hyperparameter tuning.")
  sweepSettings?: TableSweepSettings;

  @doc("Test data input.")
  testData?: MLTableJobInput;

  @doc("""
The fraction of test dataset that needs to be set aside for validation purpose.
Values between (0.0 , 1.0)
Applied when validation dataset is not provided.
""")
  testDataSize?: float32;

  @doc("Validation data inputs.")
  validationData?: MLTableJobInput;

  @doc("""
The fraction of training dataset that needs to be set aside for validation purpose.
Values between (0.0 , 1.0)
Applied when validation dataset is not provided.
""")
  validationDataSize?: float32;

  @doc("The name of the sample weight column. Automated ML supports a weighted column as an input, causing rows in the data to be weighted up or down.")
  weightColumnName?: string;
}

@doc("Featurization Configuration.")
model TableVerticalFeaturizationSettings extends FeaturizationSettings {
  @doc("These transformers shall not be used in featurization.")
  blockedTransformers?: BlockedTransformers[];

  @doc("Dictionary of column name and its type (int, float, string, datetime etc).")
  columnNameAndTypes?: Record<string>;

  @doc("Determines whether to use Dnn based featurizers for data featurization.")
  enableDnnFeaturization?: boolean;

  @doc("""
Featurization mode - User can keep the default 'Auto' mode and AutoML will take care of necessary transformation of the data in featurization phase.
If 'Off' is selected then no featurization is done.
If 'Custom' is selected then user can specify additional inputs to customize how featurization is done.
""")
  mode?: FeaturizationMode;

  @doc("User can specify additional transformers to be used along with the columns to which it would be applied and parameters for the transformer constructor.")
  transformerParams?: Record<ColumnTransformer[]>;
}

@doc("Column transformer parameters.")
model ColumnTransformer {
  @doc("Fields to apply transformer logic on.")
  fields?: string[];

  @doc("""
Different properties to be passed to transformer.
Input expected is dictionary of key,value pairs in JSON format.
""")
  parameters?: Record<unknown>;
}

@doc("Featurization Configuration.")
model FeaturizationSettings {
  @doc("Dataset language, useful for the text data.")
  datasetLanguage?: string;
}

@doc("Fixed training parameters that won't be swept over during AutoML Table training.")
model TableFixedParameters {
  @doc("Specify the boosting type, e.g gbdt for XGBoost.")
  booster?: string;

  @doc("Specify the boosting type, e.g gbdt for LightGBM.")
  boostingType?: string;

  @doc("Specify the grow policy, which controls the way new nodes are added to the tree.")
  growPolicy?: string;

  @doc("The learning rate for the training procedure.")
  learningRate?: float32;

  @doc("Specify the Maximum number of discrete bins to bucket continuous features .")
  maxBin?: int32;

  @doc("Specify the max depth to limit the tree depth explicitly.")
  maxDepth?: int32;

  @doc("Specify the max leaves to limit the tree leaves explicitly.")
  maxLeaves?: int32;

  @doc("The minimum number of data per leaf.")
  minDataInLeaf?: int32;

  @doc("Minimum loss reduction required to make a further partition on a leaf node of the tree.")
  minSplitGain?: float32;

  @doc("The name of the model to train.")
  modelName?: string;

  @doc("Specify the number of trees (or rounds) in an model.")
  nEstimators?: int32;

  @doc("Specify the number of leaves.")
  numLeaves?: int32;

  @doc("The name of the preprocessor to use.")
  preprocessorName?: string;

  @doc("L1 regularization term on weights.")
  regAlpha?: float32;

  @doc("L2 regularization term on weights.")
  regLambda?: float32;

  @doc("Subsample ratio of the training instance.")
  subsample?: float32;

  @doc("Frequency of subsample.")
  subsampleFreq?: float32;

  @doc("Specify the tree method.")
  treeMethod?: string;

  @doc("If true, center before scaling the data with StandardScalar.")
  withMean?: boolean;

  @doc("If true, scaling the data with Unit Variance with StandardScalar.")
  withStd?: boolean;
}

@doc("Job execution constraints.")
model TableVerticalLimitSettings {
  @doc("Enable early termination, determines whether or not if AutoMLJob will terminate early if there is no score improvement in last 20 iterations.")
  enableEarlyTermination?: boolean;

  @doc("Exit score for the AutoML job.")
  exitScore?: float32;

  @doc("Maximum Concurrent iterations.")
  maxConcurrentTrials?: int32;

  @doc("Max cores per iteration.")
  maxCoresPerTrial?: int32;

  @doc("Maximum nodes to use for the experiment.")
  maxNodes?: int32;

  @doc("Number of iterations.")
  maxTrials?: int32;

  @doc("Number of concurrent sweeping runs that user wants to trigger.")
  sweepConcurrentTrials?: int32;

  @doc("Number of sweeping runs that user wants to trigger.")
  sweepTrials?: int32;

  @doc("AutoML job timeout.")
  timeout?: duration;

  @doc("Iteration timeout.")
  trialTimeout?: duration;
}

model TableParameterSubspace {
  @doc("Specify the boosting type, e.g gbdt for XGBoost.")
  booster?: string;

  @doc("Specify the boosting type, e.g gbdt for LightGBM.")
  boostingType?: string;

  @doc("Specify the grow policy, which controls the way new nodes are added to the tree.")
  growPolicy?: string;

  @doc("The learning rate for the training procedure.")
  learningRate?: string;

  @doc("Specify the Maximum number of discrete bins to bucket continuous features .")
  maxBin?: string;

  @doc("Specify the max depth to limit the tree depth explicitly.")
  maxDepth?: string;

  @doc("Specify the max leaves to limit the tree leaves explicitly.")
  maxLeaves?: string;

  @doc("The minimum number of data per leaf.")
  minDataInLeaf?: string;

  @doc("Minimum loss reduction required to make a further partition on a leaf node of the tree.")
  minSplitGain?: string;

  @doc("The name of the model to train.")
  modelName?: string;

  @doc("Specify the number of trees (or rounds) in an model.")
  nEstimators?: string;

  @doc("Specify the number of leaves.")
  numLeaves?: string;

  @doc("The name of the preprocessor to use.")
  preprocessorName?: string;

  @doc("L1 regularization term on weights.")
  regAlpha?: string;

  @doc("L2 regularization term on weights.")
  regLambda?: string;

  @doc("Subsample ratio of the training instance.")
  subsample?: string;

  @doc("Frequency of subsample")
  subsampleFreq?: string;

  @doc("Specify the tree method.")
  treeMethod?: string;

  @doc("If true, center before scaling the data with StandardScalar.")
  withMean?: string;

  @doc("If true, scaling the data with Unit Variance with StandardScalar.")
  withStd?: string;
}

model TableSweepSettings {
  @doc("Type of early termination policy for the sweeping job.")
  earlyTermination?: EarlyTerminationPolicy;

  @doc("[Required] Type of sampling algorithm.")
  samplingAlgorithm: SamplingAlgorithmType;
}

model ClassificationModelPerformanceMetricThreshold
  extends ModelPerformanceMetricThresholdBase {
  @doc("[Required] The classification model performance to calculate.")
  @visibility("read", "create")
  metric: ClassificationModelPerformanceMetric;

  @doc("[Required] Specifies the data type of the metric threshold.")
  modelType: "Classification";
}

@discriminator("modelType")
model ModelPerformanceMetricThresholdBase {
  @doc("The threshold value. If null, a default value will be set depending on the selected metric.")
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

model CocoExportSummary extends ExportSummary {
  @doc("The container name to which the labels will be exported.")
  @visibility("read")
  containerName?: string;

  @doc("The output path where the labels will be exported.")
  @visibility("read")
  snapshotPath?: string;

  @doc("[Required] The format of exported labels, also as the discriminator.")
  format: "Coco";
}

@doc("Command job definition.")
model CommandJob extends JobBase {
  @doc("Distribution configuration of the job. If set, this should be one of Mpi, Tensorflow, PyTorch, or null.")
  @visibility("read", "create")
  autologgerSettings?: AutologgerSettings;

  @doc("ARM resource ID of the code asset.")
  @visibility("read", "create")
  codeId?: string;

  @doc("[Required] The command to execute on startup of the job. eg. \"python train.py\"")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  command: string;

  @doc("Distribution configuration of the job. If set, this should be one of Mpi, Tensorflow, PyTorch, Ray, or null.")
  @visibility("read", "create")
  distribution?: DistributionConfiguration;

  @doc("[Required] The ARM resource ID of the Environment specification for the job.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  environmentId: string;

  @doc("Environment variables included in the job.")
  @visibility("read", "create")
  environmentVariables?: Record<string>;

  @doc("Mapping of input data bindings used in the job.")
  @visibility("read", "create")
  inputs?: Record<JobInput>;

  @doc("Command Job limit.")
  @visibility("read", "create")
  limits?: CommandJobLimits;

  @doc("Mapping of output data bindings used in the job.")
  @visibility("read", "create")
  outputs?: Record<JobOutput>;

  @doc("Input parameters.")
  @visibility("read")
  parameters?: Record<unknown>;

  @doc("Queue settings for the job")
  @visibility("read", "create")
  queueSettings?: QueueSettings;

  @doc("Compute Resource configuration for the job.")
  @visibility("read", "create")
  resources?: JobResourceConfiguration;

  @doc("[Required] Specifies the type of job.")
  jobType: "Command";
}

@doc("Base definition for job distribution configuration.")
@discriminator("distributionType")
model DistributionConfiguration {}

@doc("Command Job limit class.")
model CommandJobLimits extends JobLimits {
  @doc("[Required] JobLimit type.")
  jobLimitsType: "Command";
}

@discriminator("jobLimitsType")
model JobLimits {
  @doc("The max run duration in ISO 8601 format, after which the job will be cancelled. Only supports duration with precision as low as Seconds.")
  timeout?: duration;
}

@doc("Resource requirements for each container instance within an online deployment.")
model ContainerResourceRequirements {
  @doc("Container resource limit info:")
  containerResourceLimits?: ContainerResourceSettings;

  @doc("Container resource request info:")
  containerResourceRequests?: ContainerResourceSettings;
}

model ContainerResourceSettings {
  @doc("""
Number of vCPUs request/limit for container. More info:
https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
""")
  cpu?: string;

  @doc("""
Number of Nvidia GPU cards request/limit for container. More info:
https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
""")
  gpu?: string;

  @doc("""
Memory size request/limit for container. More info:
https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
""")
  memory?: string;
}

model CreateMonitorAction extends ScheduleActionBase {
  @doc("[Required] Defines the monitor.")
  @visibility("read", "create")
  monitorDefinition: MonitorDefinition;

  @doc("[Required] Specifies the action type of the schedule")
  actionType: "CreateMonitor";
}

model MonitorDefinition {
  @doc("The monitor's notification settings.")
  @visibility("read", "create")
  alertNotificationSetting?: MonitoringAlertNotificationSettingsBase;

  @doc("[Required] The ARM resource ID of the compute resource to run the monitoring job on.")
  @visibility("read", "create")
  computeConfiguration: MonitorComputeConfigurationBase;

  @doc("The ARM resource ID of either the model or deployment targeted by this monitor.")
  @visibility("read", "create")
  monitoringTarget?: MonitoringTarget;

  @doc("[Required] The signals to monitor.")
  @visibility("read", "create")
  signals: Record<MonitoringSignalBase>;
}

@doc("Monitor compute configuration base definition.")
@discriminator("computeType")
model MonitorComputeConfigurationBase {}

@doc("Monitoring target definition.")
model MonitoringTarget {
  @doc("The ARM resource ID of either the deployment targeted by this monitor.")
  @visibility("read", "create")
  deploymentId?: string;

  @doc("The ARM resource ID of either the model targeted by this monitor.")
  @visibility("read", "create")
  modelId?: string;

  @doc("[Required] The machine learning task type of the model.")
  @visibility("read", "create")
  taskType: ModelTaskType;
}

@discriminator("signalType")
model MonitoringSignalBase {
  @doc("The current notification mode for this signal.")
  @visibility("read", "create")
  mode?: MonitoringNotificationMode;

  @doc("Property dictionary. Properties can be added, but not removed or altered.")
  properties?: Record<string>;
}

model CronTrigger extends TriggerBase {
  @doc("""
[Required] Specifies cron expression of schedule.
The expression should follow NCronTab format.
""")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  expression: string;

  @doc("[Required] ")
  triggerType: "Cron";
}

model CsvExportSummary extends ExportSummary {
  @doc("The container name to which the labels will be exported.")
  @visibility("read")
  containerName?: string;

  @doc("The output path where the labels will be exported.")
  @visibility("read")
  snapshotPath?: string;

  @doc("[Required] The format of exported labels, also as the discriminator.")
  format: "CSV";
}

@doc("The desired maximum forecast horizon in units of time-series frequency.")
model CustomForecastHorizon extends ForecastHorizon {
  @doc("[Required] Forecast horizon value.")
  value: int32;

  @doc("[Required] Set forecast horizon value selection mode.")
  mode: "Custom";
}

@doc("Custom inference server configurations.")
model CustomInferencingServer extends InferencingServer {
  @doc("Inference configuration for custom inferencing.")
  inferenceConfiguration?: OnlineInferenceConfiguration;

  @doc("[Required] Inferencing server type for various targets.")
  serverType: "Custom";
}

@doc("Online inference configuration options.")
model OnlineInferenceConfiguration {
  @doc("Additional configurations")
  configurations?: Record<string>;

  @doc("Entry script or command to invoke.")
  entryScript?: string;

  @doc("The route to check the liveness of the inference server container.")
  livenessRoute?: Route;

  @doc("The route to check the readiness of the inference server container.")
  readinessRoute?: Route;

  @doc("The port to send the scoring requests to, within the inference server container.")
  scoringRoute?: Route;
}

model CustomMetricThreshold {
  @doc("[Required] The user-defined metric to calculate.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  metric: string;

  @doc("The threshold value. If null, a default value will be set depending on the selected metric.")
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

model CustomModelJobInput extends JobInput {
  ...AssetJobInput;

  @doc("[Required] Specifies the type of job.")
  jobInputType: "custom_model";
}

model CustomModelJobOutput extends JobOutput {
  ...AssetJobOutput;

  @doc("[Required] Specifies the type of job.")
  jobOutputType: "custom_model";
}

model CustomMonitoringSignal extends MonitoringSignalBase {
  @doc("[Required] ARM resource ID of the component resource used to calculate the custom metrics.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  componentId: string;

  @doc("Monitoring assets to take as input. Key is the component input port name, value is the data asset.")
  @visibility("read", "create")
  inputAssets?: Record<MonitoringInputDataBase>;

  @doc("Extra component parameters to take as input. Key is the component literal input port name, value is the parameter value.")
  @visibility("read", "create")
  inputs?: Record<JobInput>;

  @doc("[Required] A list of metrics to calculate and their associated thresholds.")
  @visibility("read", "create")
  metricThresholds: CustomMetricThreshold[];

  @doc("[Required] A list of metrics to calculate and their associated thresholds.")
  @visibility("read", "create")
  workspaceConnection: MonitoringWorkspaceConnection;

  @doc("[Required] Specifies the type of signal to monitor.")
  signalType: "Custom";
}

@doc("Monitoring input data base definition.")
@discriminator("inputDataType")
model MonitoringInputDataBase {
  @doc("Mapping of column names to special uses.")
  @visibility("read", "create")
  columns?: Record<string>;

  @doc("The context metadata of the data source.")
  @visibility("read", "create")
  dataContext?: string;

  @doc("[Required] Specifies the type of job.")
  @visibility("read", "create")
  jobInputType: JobInputType;

  @doc("[Required] Input Asset URI.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  uri: string;
}

@doc("Monitoring workspace connection definition.")
model MonitoringWorkspaceConnection {
  @doc("""
The properties of a workspace service connection to store as environment variables in the submitted jobs.
Key is workspace connection property path, name is environment variable key.
""")
  @visibility("read", "create")
  environmentVariables?: Record<string>;

  @doc("""
The properties of a workspace service connection to store as secrets in the submitted jobs.
Key is workspace connection property path, name is secret key.
""")
  @visibility("read", "create")
  secrets?: Record<string>;
}

@doc("N-Cross validations are specified by user.")
model CustomNCrossValidations extends NCrossValidations {
  @doc("[Required] N-Cross validations value.")
  value: int32;

  @doc("[Required] Mode for determining N-Cross validations.")
  mode: "Custom";
}

model CustomSeasonality extends Seasonality {
  @doc("[Required] Seasonality value.")
  value: int32;

  @doc("[Required] Seasonality mode.")
  mode: "Custom";
}

model CustomTargetLags extends TargetLags {
  @doc("[Required] Set target lags values.")
  values: int32[];

  @doc("[Required] Set target lags mode - Auto/Custom")
  mode: "Custom";
}

model CustomTargetRollingWindowSize extends TargetRollingWindowSize {
  @doc("[Required] TargetRollingWindowSize value.")
  value: int32;

  @doc("[Required] TargetRollingWindowSiz detection mode.")
  mode: "Custom";
}

model DataDriftMonitoringSignal extends MonitoringSignalBase {
  @doc("The data segment used for scoping on a subset of the data population.")
  @visibility("read", "create")
  dataSegment?: MonitoringDataSegment;

  @doc("A dictionary that maps feature names to their respective data types.")
  @visibility("read", "create")
  featureDataTypeOverride?: Record<MonitoringFeatureDataType>;

  @doc("The feature filter which identifies which feature to calculate drift over.")
  @visibility("read", "create")
  features?: MonitoringFeatureFilterBase;

  @doc("[Required] A list of metrics to calculate and their associated thresholds.")
  @visibility("read", "create")
  metricThresholds: DataDriftMetricThresholdBase[];

  @doc("[Required] The data which drift will be calculated for.")
  @visibility("read", "create")
  productionData: MonitoringInputDataBase;

  @doc("[Required] The data to calculate drift against.")
  @visibility("read", "create")
  referenceData: MonitoringInputDataBase;

  @doc("[Required] Specifies the type of signal to monitor.")
  signalType: "DataDrift";
}

model MonitoringDataSegment {
  @doc("The feature to segment the data on.")
  @visibility("read", "create")
  feature?: string;

  @doc("Filters for only the specified values of the given segmented feature.")
  @visibility("read", "create")
  values?: string[];
}

model DataImport extends DataVersionBase {
  @doc("Name of the asset for data import job to create")
  assetName?: string;

  @doc("Source data of the asset to import from")
  source?: DataImportSource;

  @doc("[Required] Specifies the type of data.")
  dataType: "uri_folder";
}

@discriminator("sourceType")
model DataImportSource {
  @doc("Workspace connection for data import source storage")
  connection?: string;
}

@doc("Reference to an asset via its path in a datastore.")
model DataPathAssetReference extends AssetReferenceBase {
  @doc("ARM resource ID of the datastore where the asset is located.")
  datastoreId?: string;

  @doc("The path of the file/directory in the datastore.")
  path?: string;

  @doc("[Required] Specifies the type of asset reference.")
  referenceType: "DataPath";
}

model DataQualityMonitoringSignal extends MonitoringSignalBase {
  @doc("A dictionary that maps feature names to their respective data types.")
  @visibility("read", "create")
  featureDataTypeOverride?: Record<MonitoringFeatureDataType>;

  @doc("The features to calculate drift over.")
  @visibility("read", "create")
  features?: MonitoringFeatureFilterBase;

  @doc("[Required] A list of metrics to calculate and their associated thresholds.")
  @visibility("read", "create")
  metricThresholds: DataQualityMetricThresholdBase[];

  @doc("[Required] The data produced by the production service which drift will be calculated for.")
  @visibility("read", "create")
  productionData: MonitoringInputDataBase;

  @doc("[Required] The data to calculate drift against.")
  @visibility("read", "create")
  referenceData: MonitoringInputDataBase;

  @doc("[Required] Specifies the type of signal to monitor.")
  signalType: "DataQuality";
}

model DatabaseSource extends DataImportSource {
  @doc("SQL Query statement for data import Database source")
  query?: string;

  @doc("SQL StoredProcedure on data import Database source")
  storedProcedure?: string;

  @doc("SQL StoredProcedure parameters")
  storedProcedureParams?: Record<string>[];

  @doc("Name of the table on data import Database source")
  tableName?: string;

  @doc("[Required] Specifies the type of data.")
  sourceType: "database";
}

model DatasetExportSummary extends ExportSummary {
  @doc("The unique name of the labeled data asset.")
  @visibility("read")
  labeledAssetName?: string;

  @doc("[Required] The format of exported labels, also as the discriminator.")
  format: "Dataset";
}

model DefaultScaleSettings extends OnlineScaleSettings {
  @doc("[Required] Type of deployment scaling algorithm")
  scaleType: "Default";
}

model EmailMonitoringAlertNotificationSettings
  extends MonitoringAlertNotificationSettingsBase {
  @doc("Configuration for notification.")
  @visibility("read", "create")
  emailNotificationSetting?: NotificationSetting;

  @doc("[Required] Specifies the type of signal to monitor.")
  alertNotificationType: "Email";
}

model EndpointScheduleAction extends ScheduleActionBase {
  @doc("""
[Required] Defines Schedule action definition details.
<see href=\"TBD\" />
""")
  @visibility("read", "create", "update")
  endpointInvocationDefinition: Record<unknown>;

  @doc("[Required] Specifies the action type of the schedule")
  actionType: "InvokeBatchEndpoint";
}

model FeatureAttributionDriftMonitoringSignal extends MonitoringSignalBase {
  @doc("[Required] A list of metrics to calculate and their associated thresholds.")
  @visibility("read", "create")
  metricThreshold: FeatureAttributionMetricThreshold;

  @doc("[Required] The data which drift will be calculated for.")
  @visibility("read", "create")
  productionData: MonitoringInputDataBase[];

  @doc("[Required] The data to calculate drift against.")
  @visibility("read", "create")
  referenceData: MonitoringInputDataBase;

  @doc("[Required] Specifies the type of signal to monitor.")
  signalType: "FeatureAttributionDrift";
}

model FeatureAttributionMetricThreshold {
  @doc("[Required] The feature attribution metric to calculate.")
  @visibility("read", "create")
  metric: FeatureAttributionMetric;

  @doc("The threshold value. If null, a default value will be set depending on the selected metric.")
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

model FeatureSubset extends MonitoringFeatureFilterBase {
  @doc("[Required] The list of features to include.")
  @visibility("read", "create")
  features: string[];

  @doc("[Required] Specifies the feature filter to leverage when selecting features to calculate metrics over.")
  filterType: "FeatureSubset";
}

model FileSystemSource extends DataImportSource {
  @doc("Path on data import FileSystem source")
  path?: string;

  @doc("[Required] Specifies the type of data.")
  sourceType: "file_system";
}

@doc("Fixed input data definition.")
model FixedInputData extends MonitoringInputDataBase {
  @doc("[Required] Specifies the type of signal to monitor.")
  inputDataType: "Fixed";
}

@doc("Forecasting task in AutoML Table vertical.")
model Forecasting extends AutoMLVertical {
  ...TableVertical;

  @doc("Forecasting task specific inputs.")
  forecastingSettings?: ForecastingSettings;

  @doc("Primary metric for forecasting task.")
  primaryMetric?: ForecastingPrimaryMetrics;

  @doc("Inputs for training phase for an AutoML Job.")
  trainingSettings?: ForecastingTrainingSettings;

  @doc("[Required] Task type for AutoMLJob.")
  taskType: "Forecasting";
}

@doc("Forecasting specific parameters.")
model ForecastingSettings {
  @doc("""
Country or region for holidays for forecasting tasks.
These should be ISO 3166 two-letter country/region codes, for example 'US' or 'GB'.
""")
  countryOrRegionForHolidays?: string;

  @doc("""
Number of periods between the origin time of one CV fold and the next fold. For
example, if `CVStepSize` = 3 for daily data, the origin time for each fold will be
three days apart.
""")
  cvStepSize?: int32;

  @doc("Flag for generating lags for the numeric features with 'auto' or null.")
  featureLags?: FeatureLags;

  @doc("""
The feature columns that are available for training but unknown at the time of forecast/inference.
If features_unknown_at_forecast_time is not set, it is assumed that all the feature columns in the dataset are known at inference time.
""")
  featuresUnknownAtForecastTime?: string[];

  @doc("The desired maximum forecast horizon in units of time-series frequency.")
  forecastHorizon?: ForecastHorizon;

  @doc("When forecasting, this parameter represents the period with which the forecast is desired, for example daily, weekly, yearly, etc. The forecast frequency is dataset frequency by default.")
  frequency?: string;

  @doc("""
Set time series seasonality as an integer multiple of the series frequency.
If seasonality is set to 'auto', it will be inferred.
""")
  seasonality?: Seasonality;

  @doc("The parameter defining how if AutoML should handle short time series.")
  shortSeriesHandlingConfig?: ShortSeriesHandlingConfiguration;

  @doc("""
The function to be used to aggregate the time series target column to conform to a user specified frequency.
If the TargetAggregateFunction is set i.e. not 'None', but the freq parameter is not set, the error is raised. The possible target aggregation functions are: \"sum\", \"max\", \"min\" and \"mean\".
""")
  targetAggregateFunction?: TargetAggregationFunction;

  @doc("The number of past periods to lag from the target column.")
  targetLags?: TargetLags;

  @doc("The number of past periods used to create a rolling window average of the target column.")
  targetRollingWindowSize?: TargetRollingWindowSize;

  @doc("The name of the time column. This parameter is required when forecasting to specify the datetime column in the input data used for building the time series and inferring its frequency.")
  timeColumnName?: string;

  @doc("""
The names of columns used to group a timeseries. It can be used to create multiple series.
If grain is not defined, the data set is assumed to be one time-series. This parameter is used with task type forecasting.
""")
  timeSeriesIdColumnNames?: string[];

  @doc("Configure STL Decomposition of the time-series target column.")
  useStl?: UseStl;
}

@doc("Forecasting Training related configuration.")
model ForecastingTrainingSettings extends TrainingSettings {
  @doc("Allowed models for forecasting task.")
  allowedTrainingAlgorithms?: ForecastingModels[];

  @doc("Blocked models for forecasting task.")
  blockedTrainingAlgorithms?: ForecastingModels[];
}

@doc("Generation safety quality metric threshold definition.")
model GenerationSafetyQualityMetricThreshold {
  @doc("[Required] Gets or sets the feature attribution metric to calculate.")
  @visibility("read", "create")
  metric: GenerationSafetyQualityMetric;

  @doc("""
Gets or sets the threshold value.
If null, a default value will be set depending on the selected metric.
""")
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

@doc("Generation safety quality monitoring signal definition.")
model GenerationSafetyQualityMonitoringSignal extends MonitoringSignalBase {
  @doc("[Required] Gets or sets the metrics to calculate and the corresponding thresholds.")
  @visibility("read", "create")
  metricThresholds: GenerationSafetyQualityMetricThreshold[];

  @doc("Gets or sets the target data for computing metrics.")
  @visibility("read", "create")
  productionData?: MonitoringInputDataBase[];

  @doc("[Required] The sample rate of the target data, should be greater than 0 and at most 1.")
  @visibility("read", "create")
  samplingRate: float32;

  @doc("Gets or sets the workspace connection ID used to connect to the content generation endpoint.")
  @visibility("read", "create")
  workspaceConnectionId?: string;

  @doc("[Required] Specifies the type of signal to monitor.")
  signalType: "GenerationSafetyQuality";
}

@doc("Generation token statistics metric threshold definition.")
model GenerationTokenStatisticsMetricThreshold {
  @doc("[Required] Gets or sets the feature attribution metric to calculate.")
  @visibility("read", "create")
  metric: GenerationTokenStatisticsMetric;

  @doc("""
Gets or sets the threshold value.
If null, a default value will be set depending on the selected metric.
""")
  @visibility("read", "create")
  threshold?: MonitoringThreshold;
}

@doc("Generation token statistics signal definition.")
model GenerationTokenStatisticsSignal extends MonitoringSignalBase {
  @doc("[Required] Gets or sets the metrics to calculate and the corresponding thresholds.")
  @visibility("read", "create")
  metricThresholds: GenerationTokenStatisticsMetricThreshold[];

  @doc("Gets or sets the target data for computing metrics.")
  @visibility("read", "create")
  productionData?: MonitoringInputDataBase;

  @doc("[Required] The sample rate of the target data, should be greater than 0 and at most 1.")
  @visibility("read", "create")
  samplingRate: float32;

  @doc("[Required] Specifies the type of signal to monitor.")
  signalType: "GenerationTokenStatistics";
}

@doc("Defines a Sampling Algorithm that exhaustively generates every value combination in the space")
model GridSamplingAlgorithm extends SamplingAlgorithm {
  @doc("[Required] The algorithm used for generating hyperparameter values, along with configuration properties")
  samplingAlgorithmType: "Grid";
}

model HdfsDatastore extends Datastore {
  @doc("The TLS cert of the HDFS server. Needs to be a base64 encoded string. Required if \"Https\" protocol is selected.")
  @visibility("read", "create")
  hdfsServerCertificate?: string;

  @doc("[Required] IP Address or DNS HostName.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  nameNodeAddress: string;

  @doc("Protocol used to communicate with the storage account (Https/Http).")
  @visibility("read", "create")
  protocol?: string;

  @doc("[Required] Storage type backing the datastore.")
  datastoreType: "Hdfs";
}

@doc("""
Image Classification. Multi-class image classification is used when an image is classified with only a single label
from a set of classes - e.g. each image is classified as either an image of a 'cat' or a 'dog' or a 'duck'.
""")
model ImageClassification extends AutoMLVertical {
  ...ImageClassificationBase;

  @doc("Primary metric to optimize for this task.")
  primaryMetric?: ClassificationPrimaryMetrics;

  @doc("[Required] Task type for AutoMLJob.")
  taskType: "ImageClassification";
}

model ImageClassificationBase extends ImageVertical {
  @doc("Settings used for training the model.")
  modelSettings?: ImageModelSettingsClassification;

  @doc("Search space for sampling different combinations of models and their hyperparameters.")
  searchSpace?: ImageModelDistributionSettingsClassification[];
}

@doc("""
Settings used for training the model.
For more information on the available settings please visit the official documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
""")
model ImageModelSettingsClassification extends ImageModelSettings {
  @doc("Image crop size that is input to the neural network for the training dataset. Must be a positive integer.")
  trainingCropSize?: int32;

  @doc("Image crop size that is input to the neural network for the validation dataset. Must be a positive integer.")
  validationCropSize?: int32;

  @doc("Image size to which to resize before cropping for validation dataset. Must be a positive integer.")
  validationResizeSize?: int32;

  @doc("""
Weighted loss. The accepted values are 0 for no weighted loss.
1 for weighted loss with sqrt.(class_weights). 2 for weighted loss with class_weights. Must be 0 or 1 or 2.
""")
  weightedLoss?: int32;
}

@doc("""
Settings used for training the model.
For more information on the available settings please visit the official documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
""")
model ImageModelSettings {
  @doc("Settings for advanced scenarios.")
  advancedSettings?: string;

  @doc("Enable AMSGrad when optimizer is 'adam' or 'adamw'.")
  amsGradient?: boolean;

  @doc("Settings for using Augmentations.")
  augmentations?: string;

  @doc("Value of 'beta1' when optimizer is 'adam' or 'adamw'. Must be a float in the range [0, 1].")
  beta1?: float32;

  @doc("Value of 'beta2' when optimizer is 'adam' or 'adamw'. Must be a float in the range [0, 1].")
  beta2?: float32;

  @doc("Frequency to store model checkpoints. Must be a positive integer.")
  checkpointFrequency?: int32;

  @doc("The pretrained checkpoint model for incremental training.")
  checkpointModel?: MLFlowModelJobInput;

  @doc("The id of a previous run that has a pretrained checkpoint for incremental training.")
  checkpointRunId?: string;

  @doc("Whether to use distributed training.")
  distributed?: boolean;

  @doc("Enable early stopping logic during training.")
  earlyStopping?: boolean;

  @doc("""
Minimum number of epochs or validation evaluations to wait before primary metric improvement
is tracked for early stopping. Must be a positive integer.
""")
  earlyStoppingDelay?: int32;

  @doc("""
Minimum number of epochs or validation evaluations with no primary metric improvement before
the run is stopped. Must be a positive integer.
""")
  earlyStoppingPatience?: int32;

  @doc("Enable normalization when exporting ONNX model.")
  enableOnnxNormalization?: boolean;

  @doc("Frequency to evaluate validation dataset to get metric scores. Must be a positive integer.")
  evaluationFrequency?: int32;

  @doc("""
Gradient accumulation means running a configured number of \"GradAccumulationStep\" steps without
updating the model weights while accumulating the gradients of those steps, and then using
the accumulated gradients to compute the weight updates. Must be a positive integer.
""")
  gradientAccumulationStep?: int32;

  @doc("""
Number of layers to freeze for the model. Must be a positive integer.
For instance, passing 2 as value for 'seresnext' means
freezing layer0 and layer1. For a full list of models supported and details on layer freeze, please
see: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
""")
  layersToFreeze?: int32;

  @doc("Initial learning rate. Must be a float in the range [0, 1].")
  learningRate?: float32;

  @doc("Type of learning rate scheduler. Must be 'warmup_cosine' or 'step'.")
  learningRateScheduler?: LearningRateScheduler;

  @doc("""
Name of the model to use for training.
For more information on the available models please visit the official documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
""")
  modelName?: string;

  @doc("Value of momentum when optimizer is 'sgd'. Must be a float in the range [0, 1].")
  momentum?: float32;

  @doc("Enable nesterov when optimizer is 'sgd'.")
  nesterov?: boolean;

  @doc("Number of training epochs. Must be a positive integer.")
  numberOfEpochs?: int32;

  @doc("Number of data loader workers. Must be a non-negative integer.")
  numberOfWorkers?: int32;

  @doc("Type of optimizer.")
  optimizer?: StochasticOptimizer;

  @doc("Random seed to be used when using deterministic training.")
  randomSeed?: int32;

  @doc("Value of gamma when learning rate scheduler is 'step'. Must be a float in the range [0, 1].")
  stepLRGamma?: float32;

  @doc("Value of step size when learning rate scheduler is 'step'. Must be a positive integer.")
  stepLRStepSize?: int32;

  @doc("Training batch size. Must be a positive integer.")
  trainingBatchSize?: int32;

  @doc("Validation batch size. Must be a positive integer.")
  validationBatchSize?: int32;

  @doc("Value of cosine cycle when learning rate scheduler is 'warmup_cosine'. Must be a float in the range [0, 1].")
  warmupCosineLRCycles?: float32;

  @doc("Value of warmup epochs when learning rate scheduler is 'warmup_cosine'. Must be a positive integer.")
  warmupCosineLRWarmupEpochs?: int32;

  @doc("Value of weight decay when optimizer is 'sgd', 'adam', or 'adamw'. Must be a float in the range[0, 1].")
  weightDecay?: float32;
}

model MLFlowModelJobInput extends JobInput {
  ...AssetJobInput;

  @doc("[Required] Specifies the type of job.")
  jobInputType: "mlflow_model";
}

@doc("""
Distribution expressions to sweep over values of model settings.
<example>
Some examples are:
```
ModelName = \"choice('seresnext', 'resnest50')\";
LearningRate = \"uniform(0.001, 0.01)\";
LayersToFreeze = \"choice(0, 2)\";
```</example>
For more details on how to compose distribution expressions please check the documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-tune-hyperparameters
For more information on the available settings please visit the official documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
""")
model ImageModelDistributionSettingsClassification
  extends ImageModelDistributionSettings {
  @doc("Image crop size that is input to the neural network for the training dataset. Must be a positive integer.")
  trainingCropSize?: string;

  @doc("Image crop size that is input to the neural network for the validation dataset. Must be a positive integer.")
  validationCropSize?: string;

  @doc("Image size to which to resize before cropping for validation dataset. Must be a positive integer.")
  validationResizeSize?: string;

  @doc("""
Weighted loss. The accepted values are 0 for no weighted loss.
1 for weighted loss with sqrt.(class_weights). 2 for weighted loss with class_weights. Must be 0 or 1 or 2.
""")
  weightedLoss?: string;
}

@doc("""
Distribution expressions to sweep over values of model settings.
<example>
Some examples are:
```
ModelName = \"choice('seresnext', 'resnest50')\";
LearningRate = \"uniform(0.001, 0.01)\";
LayersToFreeze = \"choice(0, 2)\";
```</example>
All distributions can be specified as distribution_name(min, max) or choice(val1, val2, ..., valn)
where distribution name can be: uniform, quniform, loguniform, etc
For more details on how to compose distribution expressions please check the documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-tune-hyperparameters
For more information on the available settings please visit the official documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
""")
model ImageModelDistributionSettings {
  @doc("Enable AMSGrad when optimizer is 'adam' or 'adamw'.")
  amsGradient?: string;

  @doc("Settings for using Augmentations.")
  augmentations?: string;

  @doc("Value of 'beta1' when optimizer is 'adam' or 'adamw'. Must be a float in the range [0, 1].")
  beta1?: string;

  @doc("Value of 'beta2' when optimizer is 'adam' or 'adamw'. Must be a float in the range [0, 1].")
  beta2?: string;

  @doc("Whether to use distributer training.")
  distributed?: string;

  @doc("Enable early stopping logic during training.")
  earlyStopping?: string;

  @doc("""
Minimum number of epochs or validation evaluations to wait before primary metric improvement
is tracked for early stopping. Must be a positive integer.
""")
  earlyStoppingDelay?: string;

  @doc("""
Minimum number of epochs or validation evaluations with no primary metric improvement before
the run is stopped. Must be a positive integer.
""")
  earlyStoppingPatience?: string;

  @doc("Enable normalization when exporting ONNX model.")
  enableOnnxNormalization?: string;

  @doc("Frequency to evaluate validation dataset to get metric scores. Must be a positive integer.")
  evaluationFrequency?: string;

  @doc("""
Gradient accumulation means running a configured number of \"GradAccumulationStep\" steps without
updating the model weights while accumulating the gradients of those steps, and then using
the accumulated gradients to compute the weight updates. Must be a positive integer.
""")
  gradientAccumulationStep?: string;

  @doc("""
Number of layers to freeze for the model. Must be a positive integer.
For instance, passing 2 as value for 'seresnext' means
freezing layer0 and layer1. For a full list of models supported and details on layer freeze, please
see: https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
""")
  layersToFreeze?: string;

  @doc("Initial learning rate. Must be a float in the range [0, 1].")
  learningRate?: string;

  @doc("Type of learning rate scheduler. Must be 'warmup_cosine' or 'step'.")
  learningRateScheduler?: string;

  @doc("""
Name of the model to use for training.
For more information on the available models please visit the official documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
""")
  modelName?: string;

  @doc("Value of momentum when optimizer is 'sgd'. Must be a float in the range [0, 1].")
  momentum?: string;

  @doc("Enable nesterov when optimizer is 'sgd'.")
  nesterov?: string;

  @doc("Number of training epochs. Must be a positive integer.")
  numberOfEpochs?: string;

  @doc("Number of data loader workers. Must be a non-negative integer.")
  numberOfWorkers?: string;

  @doc("Type of optimizer. Must be either 'sgd', 'adam', or 'adamw'.")
  optimizer?: string;

  @doc("Random seed to be used when using deterministic training.")
  randomSeed?: string;

  @doc("Value of gamma when learning rate scheduler is 'step'. Must be a float in the range [0, 1].")
  stepLRGamma?: string;

  @doc("Value of step size when learning rate scheduler is 'step'. Must be a positive integer.")
  stepLRStepSize?: string;

  @doc("Training batch size. Must be a positive integer.")
  trainingBatchSize?: string;

  @doc("Validation batch size. Must be a positive integer.")
  validationBatchSize?: string;

  @doc("Value of cosine cycle when learning rate scheduler is 'warmup_cosine'. Must be a float in the range [0, 1].")
  warmupCosineLRCycles?: string;

  @doc("Value of warmup epochs when learning rate scheduler is 'warmup_cosine'. Must be a positive integer.")
  warmupCosineLRWarmupEpochs?: string;

  @doc("Value of weight decay when optimizer is 'sgd', 'adam', or 'adamw'. Must be a float in the range[0, 1].")
  weightDecay?: string;
}

@doc("""
Abstract class for AutoML tasks that train image (computer vision) models -
such as Image Classification / Image Classification Multilabel / Image Object Detection / Image Instance Segmentation.
""")
model ImageVertical {
  @doc("[Required] Limit settings for the AutoML job.")
  limitSettings: ImageLimitSettings;

  @doc("Model sweeping and hyperparameter sweeping related settings.")
  sweepSettings?: ImageSweepSettings;

  @doc("Validation data inputs.")
  validationData?: MLTableJobInput;

  @doc("""
The fraction of training dataset that needs to be set aside for validation purpose.
Values between (0.0 , 1.0)
Applied when validation dataset is not provided.
""")
  validationDataSize?: float32;
}

@doc("Limit settings for the AutoML job.")
model ImageLimitSettings {
  @doc("Maximum number of concurrent AutoML iterations.")
  maxConcurrentTrials?: int32;

  @doc("Maximum number of AutoML iterations.")
  maxTrials?: int32;

  @doc("AutoML job timeout.")
  timeout?: duration;
}

@doc("Model sweeping and hyperparameter sweeping related settings.")
model ImageSweepSettings {
  @doc("Type of early termination policy.")
  earlyTermination?: EarlyTerminationPolicy;

  @doc("[Required] Type of the hyperparameter sampling algorithms.")
  samplingAlgorithm: SamplingAlgorithmType;
}

@doc("""
Image Classification Multilabel. Multi-label image classification is used when an image could have one or more labels
from a set of labels - e.g. an image could be labeled with both 'cat' and 'dog'.
""")
model ImageClassificationMultilabel extends AutoMLVertical {
  ...ImageClassificationBase;

  @doc("Primary metric to optimize for this task.")
  primaryMetric?: ClassificationMultilabelPrimaryMetrics;

  @doc("[Required] Task type for AutoMLJob.")
  taskType: "ImageClassificationMultilabel";
}

@doc("""
Image Instance Segmentation. Instance segmentation is used to identify objects in an image at the pixel level,
drawing a polygon around each object in the image.
""")
model ImageInstanceSegmentation extends AutoMLVertical {
  ...ImageObjectDetectionBase;

  @doc("Primary metric to optimize for this task.")
  primaryMetric?: InstanceSegmentationPrimaryMetrics;

  @doc("[Required] Task type for AutoMLJob.")
  taskType: "ImageInstanceSegmentation";
}

model ImageObjectDetectionBase extends ImageVertical {
  @doc("Settings used for training the model.")
  modelSettings?: ImageModelSettingsObjectDetection;

  @doc("Search space for sampling different combinations of models and their hyperparameters.")
  searchSpace?: ImageModelDistributionSettingsObjectDetection[];
}

@doc("""
Settings used for training the model.
For more information on the available settings please visit the official documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
""")
model ImageModelSettingsObjectDetection extends ImageModelSettings {
  @doc("""
Maximum number of detections per image, for all classes. Must be a positive integer.
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  boxDetectionsPerImage?: int32;

  @doc("""
During inference, only return proposals with a classification score greater than
BoxScoreThreshold. Must be a float in the range[0, 1].
""")
  boxScoreThreshold?: float32;

  @doc("""
Image size for train and validation. Must be a positive integer.
Note: The training run may get into CUDA OOM if the size is too big.
Note: This settings is only supported for the 'yolov5' algorithm.
""")
  imageSize?: int32;

  @doc("Enable computing and logging training metrics.")
  logTrainingMetrics?: LogTrainingMetrics;

  @doc("Enable computing and logging validation loss.")
  logValidationLoss?: LogValidationLoss;

  @doc("""
Maximum size of the image to be rescaled before feeding it to the backbone.
Must be a positive integer. Note: training run may get into CUDA OOM if the size is too big.
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  maxSize?: int32;

  @doc("""
Minimum size of the image to be rescaled before feeding it to the backbone.
Must be a positive integer. Note: training run may get into CUDA OOM if the size is too big.
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  minSize?: int32;

  @doc("""
Model size. Must be 'small', 'medium', 'large', or 'xlarge'.
Note: training run may get into CUDA OOM if the model size is too big.
Note: This settings is only supported for the 'yolov5' algorithm.
""")
  modelSize?: ModelSize;

  @doc("""
Enable multi-scale image by varying image size by +/- 50%.
Note: training run may get into CUDA OOM if no sufficient GPU memory.
Note: This settings is only supported for the 'yolov5' algorithm.
""")
  multiScale?: boolean;

  @doc("IOU threshold used during inference in NMS post processing. Must be a float in the range [0, 1].")
  nmsIouThreshold?: float32;

  @doc("""
The grid size to use for tiling each image. Note: TileGridSize must not be
None to enable small object detection logic. A string containing two integers in mxn format.
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  tileGridSize?: string;

  @doc("""
Overlap ratio between adjacent tiles in each dimension. Must be float in the range [0, 1).
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  tileOverlapRatio?: float32;

  @doc("""
The IOU threshold to use to perform NMS while merging predictions from tiles and image.
Used in validation/ inference. Must be float in the range [0, 1].
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  tilePredictionsNmsThreshold?: float32;

  @doc("IOU threshold to use when computing validation metric. Must be float in the range [0, 1].")
  validationIouThreshold?: float32;

  @doc("Metric computation method to use for validation metrics.")
  validationMetricType?: ValidationMetricType;
}

@doc("""
Distribution expressions to sweep over values of model settings.
<example>
Some examples are:
```
ModelName = \"choice('seresnext', 'resnest50')\";
LearningRate = \"uniform(0.001, 0.01)\";
LayersToFreeze = \"choice(0, 2)\";
```</example>
For more details on how to compose distribution expressions please check the documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-tune-hyperparameters
For more information on the available settings please visit the official documentation:
https://docs.microsoft.com/en-us/azure/machine-learning/how-to-auto-train-image-models.
""")
model ImageModelDistributionSettingsObjectDetection
  extends ImageModelDistributionSettings {
  @doc("""
Maximum number of detections per image, for all classes. Must be a positive integer.
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  boxDetectionsPerImage?: string;

  @doc("""
During inference, only return proposals with a classification score greater than
BoxScoreThreshold. Must be a float in the range[0, 1].
""")
  boxScoreThreshold?: string;

  @doc("""
Image size for train and validation. Must be a positive integer.
Note: The training run may get into CUDA OOM if the size is too big.
Note: This settings is only supported for the 'yolov5' algorithm.
""")
  imageSize?: string;

  @doc("""
Maximum size of the image to be rescaled before feeding it to the backbone.
Must be a positive integer. Note: training run may get into CUDA OOM if the size is too big.
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  maxSize?: string;

  @doc("""
Minimum size of the image to be rescaled before feeding it to the backbone.
Must be a positive integer. Note: training run may get into CUDA OOM if the size is too big.
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  minSize?: string;

  @doc("""
Model size. Must be 'small', 'medium', 'large', or 'xlarge'.
Note: training run may get into CUDA OOM if the model size is too big.
Note: This settings is only supported for the 'yolov5' algorithm.
""")
  modelSize?: string;

  @doc("""
Enable multi-scale image by varying image size by +/- 50%.
Note: training run may get into CUDA OOM if no sufficient GPU memory.
Note: This settings is only supported for the 'yolov5' algorithm.
""")
  multiScale?: string;

  @doc("IOU threshold used during inference in NMS post processing. Must be float in the range [0, 1].")
  nmsIouThreshold?: string;

  @doc("""
The grid size to use for tiling each image. Note: TileGridSize must not be
None to enable small object detection logic. A string containing two integers in mxn format.
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  tileGridSize?: string;

  @doc("""
Overlap ratio between adjacent tiles in each dimension. Must be float in the range [0, 1).
Note: This settings is not supported for the 'yolov5' algorithm.
""")
  tileOverlapRatio?: string;

  @doc("""
The IOU threshold to use to perform NMS while merging predictions from tiles and image.
Used in validation/ inference. Must be float in the range [0, 1].
Note: This settings is not supported for the 'yolov5' algorithm.
NMS: Non-maximum suppression
""")
  tilePredictionsNmsThreshold?: string;

  @doc("IOU threshold to use when computing validation metric. Must be float in the range [0, 1].")
  validationIouThreshold?: string;

  @doc("Metric computation method to use for validation metrics. Must be 'none', 'coco', 'voc', or 'coco_voc'.")
  validationMetricType?: string;
}

@doc("""
Image Object Detection. Object detection is used to identify objects in an image and locate each object with a
bounding box e.g. locate all dogs and cats in an image and draw a bounding box around each.
""")
model ImageObjectDetection extends AutoMLVertical {
  ...ImageObjectDetectionBase;

  @doc("Primary metric to optimize for this task.")
  primaryMetric?: ObjectDetectionPrimaryMetrics;

  @doc("[Required] Task type for AutoMLJob.")
  taskType: "ImageObjectDetection";
}

model ImportDataAction extends ScheduleActionBase {
  @doc("[Required] Defines Schedule action definition details.")
  @visibility("read", "create", "update")
  dataImportDefinition: DataImport;

  @doc("[Required] Specifies the action type of the schedule")
  actionType: "ImportData";
}

model JobScheduleAction extends ScheduleActionBase {
  @doc("[Required] Defines Schedule action definition details.")
  @visibility("read", "create", "update")
  jobDefinition: JobBase;

  @doc("[Required] Specifies the action type of the schedule")
  actionType: "CreateJob";
}

model KerberosCredentials {
  @doc("[Required] IP Address or DNS HostName.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  kerberosKdcAddress: string;

  @doc("[Required] Kerberos Username")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  kerberosPrincipal: string;

  @doc("[Required] Domain over which a Kerberos authentication server has the authority to authenticate a user, host or service.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  kerberosRealm: string;
}

model KerberosKeytabCredentials extends DatastoreCredentials {
  ...KerberosCredentials;

  @doc("[Required] Keytab secrets.")
  @visibility("create", "update")
  secrets: KerberosKeytabSecrets;

  @doc("[Required] Credential type used to authentication with storage.")
  credentialsType: "KerberosKeytab";
}

model KerberosKeytabSecrets extends DatastoreSecrets {
  @doc("Kerberos keytab secret.")
  kerberosKeytab?: string;

  @doc("[Required] Credential type used to authentication with storage.")
  secretsType: "KerberosKeytab";
}

model KerberosPasswordCredentials extends DatastoreCredentials {
  ...KerberosCredentials;

  @doc("[Required] Kerberos password secrets.")
  @visibility("create", "update")
  secrets: KerberosPasswordSecrets;

  @doc("[Required] Credential type used to authentication with storage.")
  credentialsType: "KerberosPassword";
}

model KerberosPasswordSecrets extends DatastoreSecrets {
  @doc("Kerberos password secret.")
  kerberosPassword?: string;

  @doc("[Required] Credential type used to authentication with storage.")
  secretsType: "KerberosPassword";
}

@doc("Properties specific to a KubernetesOnlineDeployment.")
model KubernetesOnlineDeployment extends OnlineDeployment {
  @doc("The resource requirements for the container (cpu and memory).")
  containerResourceRequirements?: ContainerResourceRequirements;

  @doc("[Required] The compute type of the endpoint.")
  endpointComputeType: "Kubernetes";
}

@doc("Properties of a labeling job for image data")
model LabelingJobImageProperties extends LabelingJobMediaProperties {
  @doc("Annotation type of image labeling job.")
  @visibility("read", "create")
  annotationType?: ImageAnnotationType;

  @doc("[Required] Media type of the job.")
  mediaType: "Image";
}

@doc("Properties of a labeling job for text data")
model LabelingJobTextProperties extends LabelingJobMediaProperties {
  @doc("Annotation type of text labeling job.")
  @visibility("read", "create")
  annotationType?: TextAnnotationType;

  @doc("[Required] Media type of the job.")
  mediaType: "Text";
}

model LakeHouseArtifact extends OneLakeArtifact {
  @doc("[Required] OneLake artifact type")
  artifactType: "LakeHouse";
}

@doc("OneLake artifact (data source) configuration.")
@discriminator("artifactType")
model OneLakeArtifact {
  @doc("[Required] OneLake artifact name")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  artifactName: string;
}

@doc("Literal input type.")
model LiteralJobInput extends JobInput {
  @doc("[Required] Literal value for the input.")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  value: string;

  @doc("[Required] Specifies the type of job.")
  jobInputType: "literal";
}

@doc("Labeling MLAssist configuration definition when MLAssist is disabled")
model MLAssistConfigurationDisabled extends MLAssistConfiguration {
  @doc("[Required] Indicates whether MLAssist feature is enabled.")
  mlAssist: "Disabled";
}

@doc("Labeling MLAssist configuration definition when MLAssist is enabled")
model MLAssistConfigurationEnabled extends MLAssistConfiguration {
  @doc("[Required] AML compute binding used in inferencing.")
  @visibility("read", "create", "update")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  inferencingComputeBinding: string;

  @doc("[Required] AML compute binding used in training.")
  @visibility("read", "create", "update")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  trainingComputeBinding: string;

  @doc("[Required] Indicates whether MLAssist feature is enabled.")
  mlAssist: "Enabled";
}

model MLFlowModelJobOutput extends JobOutput {
  ...AssetJobOutput;

  @doc("[Required] Specifies the type of job.")
  jobOutputType: "mlflow_model";
}

@doc("MLTable data definition")
model MLTableData extends DataVersionBase {
  @doc("Uris referenced in the MLTable definition (required for lineage)")
  @visibility("read", "create")
  referencedUris?: string[];

  @doc("[Required] Specifies the type of data.")
  dataType: "mltable";
}

model MLTableJobOutput extends JobOutput {
  ...AssetJobOutput;

  @doc("[Required] Specifies the type of job.")
  jobOutputType: "mltable";
}

@doc("Managed compute identity definition.")
model ManagedComputeIdentity extends MonitorComputeIdentityBase {
  @doc("Managed service identity (system assigned and/or user assigned identities)")
  identity?: ManagedServiceIdentity;

  @doc("[Required] Monitor compute identity type enum.")
  computeIdentityType: "ManagedIdentity";
}

@doc("Managed identity configuration.")
model ManagedIdentity extends IdentityConfiguration {
  @doc("Specifies a user-assigned identity by client ID. For system-assigned, do not set this field.")
  @visibility("read", "create")
  clientId?: string;

  @doc("Specifies a user-assigned identity by object ID. For system-assigned, do not set this field.")
  @visibility("read", "create")
  objectId?: string;

  @doc("Specifies a user-assigned identity by ARM resource ID. For system-assigned, do not set this field.")
  @visibility("read", "create")
  resourceId?: string;

  @doc("[Required] Specifies the type of identity framework.")
  identityType: "Managed";
}

@doc("Properties specific to a ManagedOnlineDeployment.")
model ManagedOnlineDeployment extends OnlineDeployment {
  @doc("[Required] The compute type of the endpoint.")
  endpointComputeType: "Managed";
}

@doc("Defines an early termination policy based on running averages of the primary metric of all runs")
model MedianStoppingPolicy extends EarlyTerminationPolicy {
  @doc("[Required] Name of policy configuration")
  policyType: "MedianStopping";
}

@doc("Model performance signal definition.")
model ModelPerformanceSignal extends MonitoringSignalBase {
  @doc("The data segment.")
  @visibility("read", "create")
  dataSegment?: MonitoringDataSegment;

  @doc("[Required] A list of metrics to calculate and their associated thresholds.")
  @visibility("read", "create")
  metricThreshold: ModelPerformanceMetricThresholdBase;

  @doc("[Required] The data produced by the production service which drift will be calculated for.")
  @visibility("read", "create")
  productionData: MonitoringInputDataBase[];

  @doc("[Required] The data to calculate drift against.")
  @visibility("read", "create")
  referenceData: MonitoringInputDataBase;

  @doc("[Required] Specifies the type of signal to monitor.")
  signalType: "ModelPerformance";
}

@doc("Monitor serverless spark compute definition.")
model MonitorServerlessSparkCompute extends MonitorComputeConfigurationBase {
  @doc("[Required] The identity scheme leveraged to by the spark jobs running on serverless Spark.")
  @visibility("read", "create")
  computeIdentity: MonitorComputeIdentityBase;

  @doc("[Required] The instance type running the Spark job.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  instanceType: string;

  @doc("[Required] The Spark runtime version.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  runtimeVersion: string;

  @doc("[Required] Specifies the type of signal to monitor.")
  computeType: "ServerlessSpark";
}

@doc("MPI distribution configuration.")
model Mpi extends DistributionConfiguration {
  @doc("Number of processes per MPI node.")
  @visibility("read", "create")
  processCountPerInstance?: int32;

  @doc("[Required] Specifies the type of distribution framework.")
  distributionType: "Mpi";
}

@doc("Fixed training parameters that won't be swept over during AutoML NLP training.")
model NlpFixedParameters {
  @doc("Number of steps to accumulate gradients over before running a backward pass.")
  gradientAccumulationSteps?: int32;

  @doc("The learning rate for the training procedure.")
  learningRate?: float32;

  @doc("The type of learning rate schedule to use during the training procedure.")
  learningRateScheduler?: NlpLearningRateScheduler;

  @doc("The name of the model to train.")
  modelName?: string;

  @doc("Number of training epochs.")
  numberOfEpochs?: int32;

  @doc("The batch size for the training procedure.")
  trainingBatchSize?: int32;

  @doc("The batch size to be used during evaluation.")
  validationBatchSize?: int32;

  @doc("The warmup ratio, used alongside LrSchedulerType.")
  warmupRatio?: float32;

  @doc("The weight decay for the training procedure.")
  weightDecay?: float32;
}

@doc("Stringified search spaces for each parameter. See below examples.")
model NlpParameterSubspace {
  @doc("Number of steps to accumulate gradients over before running a backward pass.")
  gradientAccumulationSteps?: string;

  @doc("The learning rate for the training procedure.")
  learningRate?: string;

  @doc("The type of learning rate schedule to use during the training procedure.")
  learningRateScheduler?: string;

  @doc("The name of the model to train.")
  modelName?: string;

  @doc("Number of training epochs.")
  numberOfEpochs?: string;

  @doc("The batch size for the training procedure.")
  trainingBatchSize?: string;

  @doc("The batch size to be used during evaluation.")
  validationBatchSize?: string;

  @doc("The warmup ratio, used alongside LrSchedulerType.")
  warmupRatio?: string;

  @doc("The weight decay for the training procedure.")
  weightDecay?: string;
}

@doc("Model sweeping and hyperparameter tuning related settings.")
model NlpSweepSettings {
  @doc("Type of early termination policy for the sweeping job.")
  earlyTermination?: EarlyTerminationPolicy;

  @doc("[Required] Type of sampling algorithm.")
  samplingAlgorithm: SamplingAlgorithmType;
}

@doc("""
Abstract class for NLP related AutoML tasks.
NLP - Natural Language Processing.
""")
model NlpVertical {
  @doc("Featurization inputs needed for AutoML job.")
  featurizationSettings?: NlpVerticalFeaturizationSettings;

  @doc("Model/training parameters that will remain constant throughout training.")
  fixedParameters?: NlpFixedParameters;

  @doc("Execution constraints for AutoMLJob.")
  limitSettings?: NlpVerticalLimitSettings;

  @doc("Search space for sampling different combinations of models and their hyperparameters.")
  searchSpace?: NlpParameterSubspace[];

  @doc("Settings for model sweeping and hyperparameter tuning.")
  sweepSettings?: NlpSweepSettings;

  @doc("Validation data inputs.")
  validationData?: MLTableJobInput;
}

model NlpVerticalFeaturizationSettings extends FeaturizationSettings {}

@doc("Job execution constraints.")
model NlpVerticalLimitSettings {
  @doc("Maximum Concurrent AutoML iterations.")
  maxConcurrentTrials?: int32;

  @doc("Maximum nodes to use for the experiment.")
  maxNodes?: int32;

  @doc("Number of AutoML iterations.")
  maxTrials?: int32;

  @doc("AutoML job timeout.")
  timeout?: duration;

  @doc("Timeout for individual HD trials.")
  trialTimeout?: duration;
}

@doc("Empty/none datastore credentials.")
model NoneDatastoreCredentials extends DatastoreCredentials {
  @doc("[Required] Credential type used to authentication with storage.")
  credentialsType: "None";
}

model NumericalDataDriftMetricThreshold extends DataDriftMetricThresholdBase {
  @doc("[Required] The numerical data drift metric to calculate.")
  metric: NumericalDataDriftMetric;

  @doc("[Required] Specifies the data type of the metric threshold.")
  dataType: "Numerical";
}

model NumericalDataQualityMetricThreshold
  extends DataQualityMetricThresholdBase {
  @doc("[Required] The numerical data quality metric to calculate.")
  @visibility("read", "create")
  metric: NumericalDataQualityMetric;

  @doc("[Required] Specifies the data type of the metric threshold.")
  dataType: "Numerical";
}

model NumericalPredictionDriftMetricThreshold
  extends PredictionDriftMetricThresholdBase {
  @doc("[Required] The numerical prediction drift metric to calculate.")
  @visibility("read", "create")
  metric: NumericalPredictionDriftMetric;

  @doc("[Required] Specifies the data type of the metric threshold.")
  dataType: "Numerical";
}

@doc("Optimization objective.")
model Objective {
  @doc("[Required] Defines supported metric goals for hyperparameter tuning")
  goal: Goal;

  @doc("[Required] Name of the metric to optimize.")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  primaryMetric: string;
}

@doc("OneLake (Trident) datastore configuration.")
model OneLakeDatastore extends Datastore {
  @doc("[Required] OneLake artifact backing the datastore.")
  @visibility("read", "create")
  artifact: OneLakeArtifact;

  @doc("OneLake endpoint to use for the datastore.")
  @visibility("read", "create")
  endpoint?: string;

  @doc("[Required] OneLake workspace name.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  oneLakeWorkspaceName: string;

  @doc("Indicates which identity to use to authenticate service data access to customer's storage.")
  @visibility("read", "create")
  serviceDataAccessAuthIdentity?: ServiceDataAccessAuthIdentity;

  @doc("[Required] Storage type backing the datastore.")
  datastoreType: "OneLake";
}

@doc("Reference to an asset via its path in a job output.")
model OutputPathAssetReference extends AssetReferenceBase {
  @doc("ARM resource ID of the job.")
  jobId?: string;

  @doc("The path of the file/directory in the job output.")
  path?: string;

  @doc("[Required] Specifies the type of asset reference.")
  referenceType: "OutputPath";
}

@doc("Package input path specified with a resource id.")
model PackageInputPathId extends PackageInputPathBase {
  @doc("Input resource id.")
  resourceId?: string;

  @doc("[Required] Input path type for package inputs.")
  inputPathType: "PathId";
}

@doc("Package input path specified as an url.")
model PackageInputPathUrl extends PackageInputPathBase {
  @doc("Input path url.")
  url?: string;

  @doc("[Required] Input path type for package inputs.")
  inputPathType: "Url";
}

@doc("Package input path specified with name and version.")
model PackageInputPathVersion extends PackageInputPathBase {
  @doc("Input resource name.")
  resourceName?: string;

  @doc("Input resource version.")
  resourceVersion?: string;

  @doc("[Required] Input path type for package inputs.")
  inputPathType: "PathVersion";
}

@doc("Pipeline Job definition: defines generic to MFE attributes.")
model PipelineJob extends JobBase {
  @doc("Inputs for the pipeline job.")
  @visibility("read", "create")
  inputs?: Record<JobInput>;

  @doc("Jobs construct the Pipeline Job.")
  @visibility("read", "create")
  jobs?: Record<Record<unknown>>;

  @doc("Outputs for the pipeline job")
  @visibility("read", "create")
  outputs?: Record<JobOutput>;

  @doc("Pipeline settings, for things like ContinueRunOnStepFailure etc.")
  @visibility("read", "create")
  settings?: Record<unknown>;

  @doc("ARM resource ID of source job.")
  @visibility("read", "create")
  sourceJobId?: string;

  @doc("[Required] Specifies the type of job.")
  jobType: "Pipeline";
}

model PredictionDriftMonitoringSignal extends MonitoringSignalBase {
  @doc("[Required] A list of metrics to calculate and their associated thresholds.")
  @visibility("read", "create")
  metricThresholds: PredictionDriftMetricThresholdBase[];

  @doc("[Required] The type of the model monitored.")
  @visibility("read", "create")
  modelType: MonitoringModelType;

  @doc("[Required] The data which drift will be calculated for.")
  @visibility("read", "create")
  productionData: MonitoringInputDataBase;

  @doc("[Required] The data to calculate drift against.")
  @visibility("read", "create")
  referenceData: MonitoringInputDataBase;

  @doc("[Required] Specifies the type of signal to monitor.")
  signalType: "PredictionDrift";
}

@doc("PyTorch distribution configuration.")
model PyTorch extends DistributionConfiguration {
  @doc("Number of processes per node.")
  processCountPerInstance?: int32;

  @doc("[Required] Specifies the type of distribution framework.")
  distributionType: "PyTorch";
}

@doc("Defines a Sampling Algorithm that generates values randomly")
model RandomSamplingAlgorithm extends SamplingAlgorithm {
  @doc("An optional positive number or e in string format to be used as base for log based random sampling")
  logbase?: string;

  @doc("The specific type of random algorithm")
  rule?: RandomSamplingAlgorithmRule;

  @doc("An optional integer to use as the seed for random number generation")
  seed?: int32;

  @doc("[Required] The algorithm used for generating hyperparameter values, along with configuration properties")
  samplingAlgorithmType: "Random";
}

@doc("Ray distribution configuration.")
model Ray extends DistributionConfiguration {
  @doc("The address of Ray head node.")
  address?: string;

  @doc("The port to bind the dashboard server to.")
  dashboardPort?: int32;

  @doc("Additional arguments passed to ray start in head node.")
  headNodeAdditionalArgs?: string;

  @doc("Provide this argument to start the Ray dashboard GUI.")
  includeDashboard?: boolean;

  @doc("The port of the head ray process.")
  port?: int32;

  @doc("Additional arguments passed to ray start in worker node.")
  workerNodeAdditionalArgs?: string;

  @doc("[Required] Specifies the type of distribution framework.")
  distributionType: "Ray";
}

@doc("Regression task in AutoML Table vertical.")
model Regression extends AutoMLVertical {
  ...TableVertical;

  @doc("Primary metric for regression task.")
  primaryMetric?: RegressionPrimaryMetrics;

  @doc("Inputs for training phase for an AutoML Job.")
  trainingSettings?: RegressionTrainingSettings;

  @doc("[Required] Task type for AutoMLJob.")
  taskType: "Regression";
}

@doc("Regression Training related configuration.")
model RegressionTrainingSettings extends TrainingSettings {
  @doc("Allowed models for regression task.")
  allowedTrainingAlgorithms?: RegressionModels[];

  @doc("Blocked models for regression task.")
  blockedTrainingAlgorithms?: RegressionModels[];
}

model RegressionModelPerformanceMetricThreshold
  extends ModelPerformanceMetricThresholdBase {
  @doc("[Required] The regression model performance metric to calculate.")
  @visibility("read", "create")
  metric: RegressionModelPerformanceMetric;

  @doc("[Required] Specifies the data type of the metric threshold.")
  modelType: "Regression";
}

model SASCredentialDto extends PendingUploadCredentialDto {
  @doc("Full SAS Uri, including the storage, container/blob path and SAS token")
  sasUri?: string;

  @doc("[Required] Credential type used to authentication with storage.")
  credentialType: "SAS";
}

@doc("SAS datastore credentials configuration.")
model SasDatastoreCredentials extends DatastoreCredentials {
  @doc("[Required] Storage container secrets.")
  @visibility("create", "update")
  secrets: SasDatastoreSecrets;

  @doc("[Required] Credential type used to authentication with storage.")
  credentialsType: "Sas";
}

@doc("Datastore SAS secrets.")
model SasDatastoreSecrets extends DatastoreSecrets {
  @doc("Storage container SAS token.")
  sasToken?: string;

  @doc("[Required] Credential type used to authentication with storage.")
  secretsType: "Sas";
}

@doc("Service Principal datastore credentials configuration.")
model ServicePrincipalDatastoreCredentials extends DatastoreCredentials {
  @doc("Authority URL used for authentication.")
  authorityUrl?: string;

  @doc("[Required] Service principal client ID.")
  clientId: string;

  @doc("Resource the service principal has access to.")
  resourceUrl?: string;

  @doc("[Required] Service principal secrets.")
  @visibility("create", "update")
  secrets: ServicePrincipalDatastoreSecrets;

  @doc("[Required] ID of the tenant to which the service principal belongs.")
  tenantId: string;

  @doc("[Required] Credential type used to authentication with storage.")
  credentialsType: "ServicePrincipal";
}

@doc("Datastore Service Principal secrets.")
model ServicePrincipalDatastoreSecrets extends DatastoreSecrets {
  @doc("Service principal secret.")
  clientSecret?: string;

  @doc("[Required] Credential type used to authentication with storage.")
  secretsType: "ServicePrincipal";
}

@doc("Spark job definition.")
model SparkJob extends JobBase {
  @doc("Archive files used in the job.")
  @visibility("read", "create")
  archives?: string[];

  @doc("Arguments for the job.")
  @visibility("read", "create")
  args?: string;

  @doc("[Required] ARM resource ID of the code asset.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  codeId: string;

  @doc("Spark configured properties.")
  @visibility("read", "create")
  conf?: Record<string>;

  @doc("[Required] The entry to execute on startup of the job.")
  @visibility("read", "create")
  entry: SparkJobEntry;

  @doc("The ARM resource ID of the Environment specification for the job.")
  @visibility("read", "create")
  environmentId?: string;

  @doc("Files used in the job.")
  @visibility("read", "create")
  files?: string[];

  @doc("Mapping of input data bindings used in the job.")
  @visibility("read", "create")
  inputs?: Record<JobInput>;

  @doc("Jar files used in the job.")
  @visibility("read", "create")
  jars?: string[];

  @doc("Mapping of output data bindings used in the job.")
  @visibility("read", "create")
  outputs?: Record<JobOutput>;

  @doc("Python files used in the job.")
  @visibility("read", "create")
  pyFiles?: string[];

  @doc("Queue settings for the job")
  @visibility("read", "create")
  queueSettings?: QueueSettings;

  @doc("Compute Resource configuration for the job.")
  @visibility("read", "create")
  resources?: SparkResourceConfiguration;

  @doc("[Required] Specifies the type of job.")
  jobType: "Spark";
}

@doc("Spark job entry point definition.")
@discriminator("sparkJobEntryType")
model SparkJobEntry {}

model SparkResourceConfiguration {
  @doc("Optional type of VM used as supported by the compute target.")
  @visibility("read", "create")
  instanceType?: string;

  @doc("Version of spark runtime used for the job.")
  @visibility("read", "create")
  runtimeVersion?: string;
}

model SparkJobPythonEntry extends SparkJobEntry {
  @doc("[Required] Relative python file path for job entry point.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  file: string;

  @doc("[Required] Type of the job's entry point.")
  sparkJobEntryType: "SparkJobPythonEntry";
}

model SparkJobScalaEntry extends SparkJobEntry {
  @doc("[Required] Scala class name used as entry point.")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  className: string;

  @doc("[Required] Type of the job's entry point.")
  sparkJobEntryType: "SparkJobScalaEntry";
}

@doc("Static input data definition.")
model StaticInputData extends MonitoringInputDataBase {
  @doc("The ARM resource ID of the component resource used to preprocess the data.")
  @visibility("read", "create")
  preprocessingComponentId?: string;

  @doc("[Required] The end date of the data window.")
  @visibility("read", "create")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  windowEnd: utcDateTime;

  @doc("[Required] The start date of the data window.")
  @visibility("read", "create")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  windowStart: utcDateTime;

  @doc("[Required] Specifies the type of signal to monitor.")
  inputDataType: "Static";
}

@doc("Sweep job definition.")
model SweepJob extends JobBase {
  @doc("Early termination policies enable canceling poor-performing runs before they complete")
  earlyTermination?: EarlyTerminationPolicy;

  @doc("Mapping of input data bindings used in the job.")
  @visibility("read", "create")
  inputs?: Record<JobInput>;

  @doc("Sweep Job limit.")
  @visibility("read", "create")
  limits?: SweepJobLimits;

  @doc("[Required] Optimization objective.")
  objective: Objective;

  @doc("Mapping of output data bindings used in the job.")
  @visibility("read", "create")
  outputs?: Record<JobOutput>;

  @doc("Queue settings for the job")
  @visibility("read", "create")
  queueSettings?: QueueSettings;

  @doc("[Required] The hyperparameter sampling algorithm")
  samplingAlgorithm: SamplingAlgorithm;

  @doc("[Required] A dictionary containing each parameter and its distribution. The dictionary key is the name of the parameter")
  searchSpace: Record<unknown>;

  @doc("[Required] Trial component definition.")
  trial: TrialComponent;

  @doc("[Required] Specifies the type of job.")
  jobType: "Sweep";
}

@doc("Sweep Job limit class.")
model SweepJobLimits extends JobLimits {
  @doc("Sweep Job max concurrent trials.")
  maxConcurrentTrials?: int32;

  @doc("Sweep Job max total trials.")
  maxTotalTrials?: int32;

  @doc("Sweep Job Trial timeout value.")
  trialTimeout?: duration;

  @doc("[Required] JobLimit type.")
  jobLimitsType: "Sweep";
}

@doc("Trial component definition.")
model TrialComponent {
  @doc("ARM resource ID of the code asset.")
  @visibility("read", "create")
  codeId?: string;

  @doc("[Required] The command to execute on startup of the job. eg. \"python train.py\"")
  @visibility("read", "create")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  command: string;

  @doc("Distribution configuration of the job. If set, this should be one of Mpi, Tensorflow, PyTorch, or null.")
  @visibility("read", "create")
  distribution?: DistributionConfiguration;

  @doc("[Required] The ARM resource ID of the Environment specification for the job.")
  @minLength(1)
  @pattern("[a-zA-Z0-9_]")
  environmentId: string;

  @doc("Environment variables included in the job.")
  @visibility("read", "create")
  environmentVariables?: Record<string>;

  @doc("Compute Resource configuration for the job.")
  @visibility("read", "create")
  resources?: JobResourceConfiguration;
}

model TargetUtilizationScaleSettings extends OnlineScaleSettings {
  @doc("The maximum number of instances that the deployment can scale to. The quota will be reserved for max_instances.")
  maxInstances?: int32;

  @doc("The minimum number of instances to always be present.")
  minInstances?: int32;

  @doc("The polling interval in ISO 8691 format. Only supports duration with precision as low as Seconds.")
  pollingInterval?: duration;

  @doc("Target CPU usage for the autoscaler.")
  targetUtilizationPercentage?: int32;

  @doc("[Required] Type of deployment scaling algorithm")
  scaleType: "TargetUtilization";
}

@doc("TensorFlow distribution configuration.")
model TensorFlow extends DistributionConfiguration {
  @doc("Number of parameter server tasks.")
  @visibility("read", "create")
  parameterServerCount?: int32;

  @doc("Number of workers. If not specified, will default to the instance count.")
  @visibility("read", "create")
  workerCount?: int32;

  @doc("[Required] Specifies the type of distribution framework.")
  distributionType: "TensorFlow";
}

@doc("""
Text Classification task in AutoML NLP vertical.
NLP - Natural Language Processing.
""")
model TextClassification extends AutoMLVertical {
  ...NlpVertical;

  @doc("Primary metric for Text-Classification task.")
  primaryMetric?: ClassificationPrimaryMetrics;

  @doc("[Required] Task type for AutoMLJob.")
  taskType: "TextClassification";
}

@doc("""
Text Classification Multilabel task in AutoML NLP vertical.
NLP - Natural Language Processing.
""")
model TextClassificationMultilabel extends AutoMLVertical {
  ...NlpVertical;

  @doc("""
Primary metric for Text-Classification-Multilabel task.
Currently only Accuracy is supported as primary metric, hence user need not set it explicitly.
""")
  @visibility("read")
  primaryMetric?: ClassificationMultilabelPrimaryMetrics;

  @doc("[Required] Task type for AutoMLJob.")
  taskType: "TextClassificationMultilabel";
}

@doc("""
Text-NER task in AutoML NLP vertical.
NER - Named Entity Recognition.
NLP - Natural Language Processing.
""")
model TextNer extends AutoMLVertical {
  ...NlpVertical;

  @doc("""
Primary metric for Text-NER task.
Only 'Accuracy' is supported for Text-NER, so user need not set this explicitly.
""")
  @visibility("read")
  primaryMetric?: ClassificationPrimaryMetrics;

  @doc("[Required] Task type for AutoMLJob.")
  taskType: "TextNER";
}

model TopNFeaturesByAttribution extends MonitoringFeatureFilterBase {
  @doc("The number of top features to include.")
  @visibility("read", "create")
  top?: int32;

  @doc("[Required] Specifies the feature filter to leverage when selecting features to calculate metrics over.")
  filterType: "TopNByAttribution";
}

@doc("Trailing input data definition.")
model TrailingInputData extends MonitoringInputDataBase {
  @doc("The ARM resource ID of the component resource used to preprocess the data.")
  @visibility("read", "create")
  preprocessingComponentId?: string;

  @doc("[Required] The time offset between the end of the data window and the monitor's current run time.")
  @visibility("read", "create")
  windowOffset: duration;

  @doc("[Required] The size of the trailing data window.")
  @visibility("read", "create")
  windowSize: duration;

  @doc("[Required] Specifies the type of signal to monitor.")
  inputDataType: "Trailing";
}

@doc("Triton inferencing server configurations.")
model TritonInferencingServer extends InferencingServer {
  @doc("Inference configuration for Triton.")
  inferenceConfiguration?: OnlineInferenceConfiguration;

  @doc("[Required] Inferencing server type for various targets.")
  serverType: "Triton";
}

model TritonModelJobInput extends JobInput {
  ...AssetJobInput;

  @doc("[Required] Specifies the type of job.")
  jobInputType: "triton_model";
}

model TritonModelJobOutput extends JobOutput {
  ...AssetJobOutput;

  @doc("[Required] Specifies the type of job.")
  jobOutputType: "triton_model";
}

@doc("Defines an early termination policy that cancels a given percentage of runs at each evaluation interval.")
model TruncationSelectionPolicy extends EarlyTerminationPolicy {
  @doc("The percentage of runs to cancel at each evaluation interval.")
  truncationPercentage?: int32;

  @doc("[Required] Name of policy configuration")
  policyType: "TruncationSelection";
}

@doc("uri-file data version entity")
model UriFileDataVersion extends DataVersionBase {
  @doc("[Required] Specifies the type of data.")
  dataType: "uri_file";
}

model UriFileJobInput extends JobInput {
  ...AssetJobInput;

  @doc("[Required] Specifies the type of job.")
  jobInputType: "uri_file";
}

model UriFileJobOutput extends JobOutput {
  ...AssetJobOutput;

  @doc("[Required] Specifies the type of job.")
  jobOutputType: "uri_file";
}

@doc("uri-folder data version entity")
model UriFolderDataVersion extends DataVersionBase {
  @doc("[Required] Specifies the type of data.")
  dataType: "uri_folder";
}

model UriFolderJobInput extends JobInput {
  ...AssetJobInput;

  @doc("[Required] Specifies the type of job.")
  jobInputType: "uri_folder";
}

model UriFolderJobOutput extends JobOutput {
  ...AssetJobOutput;

  @doc("[Required] Specifies the type of job.")
  jobOutputType: "uri_folder";
}

@doc("User identity configuration.")
model UserIdentity extends IdentityConfiguration {
  @doc("[Required] Specifies the type of identity framework.")
  identityType: "UserIdentity";
}

model AccessKeyAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionAccessKey;

  @doc("Authentication type of the connection target")
  authType: "AccessKey";
}

model WorkspaceConnectionAccessKey {
  accessKeyId?: string;
  secretAccessKey?: string;
}

@doc("""
This connection type covers the generic ApiKey auth connection categories, for examples:
AzureOpenAI:
    Category:= AzureOpenAI
    AuthType:= ApiKey (as type discriminator)
    Credentials:= {ApiKey} as Microsoft.MachineLearning.AccountRP.Contracts.WorkspaceConnection.ApiKey
    Target:= {ApiBase}
            
CognitiveService:
    Category:= CognitiveService
    AuthType:= ApiKey (as type discriminator)
    Credentials:= {SubscriptionKey} as Microsoft.MachineLearning.AccountRP.Contracts.WorkspaceConnection.ApiKey
    Target:= ServiceRegion={serviceRegion}
            
CognitiveSearch:
    Category:= CognitiveSearch
    AuthType:= ApiKey (as type discriminator)
    Credentials:= {Key} as Microsoft.MachineLearning.AccountRP.Contracts.WorkspaceConnection.ApiKey
    Target:= {Endpoint}
            
Use Metadata property bag for ApiType, ApiVersion, Kind and other metadata fields
""")
model ApiKeyAuthWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  @doc("Api key object for workspace connection credential.")
  credentials?: WorkspaceConnectionApiKey;

  @doc("Authentication type of the connection target")
  authType: "ApiKey";
}

@doc("Api key object for workspace connection credential.")
model WorkspaceConnectionApiKey {
  key?: string;
}

@doc("Custom Keys credential object")
model CustomKeys {
  @doc("Dictionary of <string>")
  keys?: Record<string>;
}

@doc("""
Category:= CustomKeys
AuthType:= CustomKeys (as type discriminator)
Credentials:= {CustomKeys} as Microsoft.MachineLearning.AccountRP.Contracts.WorkspaceConnection.CustomKeys
Target:= {any value}
Use Metadata property bag for ApiVersion and other metadata fields
""")
model CustomKeysWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  @doc("Custom Keys credential object")
  credentials?: CustomKeys;

  @doc("Authentication type of the connection target")
  authType: "CustomKeys";
}

@doc("FQDN Outbound Rule for the managed network of a machine learning workspace.")
model FqdnOutboundRule extends OutboundRule {
  destination?: string;

  @doc("Type of a managed network Outbound Rule of a machine learning workspace.")
  type: "FQDN";
}

model ManagedIdentityAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionManagedIdentity;

  @doc("Authentication type of the connection target")
  authType: "ManagedIdentity";
}

model WorkspaceConnectionManagedIdentity {
  clientId?: string;
  resourceId?: string;
}

model NoneAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  @doc("Authentication type of the connection target")
  authType: "None";
}

model PATAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionPersonalAccessToken;

  @doc("Authentication type of the connection target")
  authType: "PAT";
}

model WorkspaceConnectionPersonalAccessToken {
  pat?: string;
}

@doc("Private Endpoint destination for a Private Endpoint Outbound Rule for the managed network of a machine learning workspace.")
model PrivateEndpointDestination {
  serviceResourceId?: string;
  sparkEnabled?: boolean;

  @doc("Type of a managed network Outbound Rule of a machine learning workspace.")
  sparkStatus?: RuleStatus;

  subresourceTarget?: string;
}

@doc("Private Endpoint Outbound Rule for the managed network of a machine learning workspace.")
model PrivateEndpointOutboundRule extends OutboundRule {
  @doc("Private Endpoint destination for a Private Endpoint Outbound Rule for the managed network of a machine learning workspace.")
  destination?: PrivateEndpointDestination;

  @doc("Type of a managed network Outbound Rule of a machine learning workspace.")
  type: "PrivateEndpoint";
}

model SASAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionSharedAccessSignature;

  @doc("Authentication type of the connection target")
  authType: "SAS";
}

model WorkspaceConnectionSharedAccessSignature {
  sas?: string;
}

model ServicePrincipalAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionServicePrincipal;

  @doc("Authentication type of the connection target")
  authType: "ServicePrincipal";
}

model WorkspaceConnectionServicePrincipal {
  clientId?: string;
  clientSecret?: string;
  tenantId?: string;
}

@doc("Service Tag destination for a Service Tag Outbound Rule for the managed network of a machine learning workspace.")
model ServiceTagDestination {
  @doc("The action enum for networking rule.")
  action?: RuleAction;

  @doc("Optional, if provided, the ServiceTag property will be ignored.")
  @visibility("read")
  addressPrefixes?: string[];

  portRanges?: string;
  protocol?: string;
  serviceTag?: string;
}

@doc("Service Tag Outbound Rule for the managed network of a machine learning workspace.")
model ServiceTagOutboundRule extends OutboundRule {
  @doc("Service Tag destination for a Service Tag Outbound Rule for the managed network of a machine learning workspace.")
  destination?: ServiceTagDestination;

  @doc("Type of a managed network Outbound Rule of a machine learning workspace.")
  type: "ServiceTag";
}

model UsernamePasswordAuthTypeWorkspaceConnectionProperties
  extends WorkspaceConnectionPropertiesV2 {
  credentials?: WorkspaceConnectionUsernamePassword;

  @doc("Authentication type of the connection target")
  authType: "UsernamePassword";
}

model WorkspaceConnectionUsernamePassword {
  password?: string;
  username?: string;
}
