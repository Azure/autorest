import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.LoadTesting;

/**
 * The client metric on which the criteria should be applied.
 */
enum PFMetrics {
  /**
   * Pass fail criteria for response time metric
   */
  response_time_ms,

  /**
   * Pass fail criteria for response time metric
   */
  latency,

  /**
   * Pass fail criteria for error metric
   */
  error,

  /**
   * Pass fail criteria for total requests
   */
  requests,

  /**
   * Pass fail criteria for request rate.
   */
  requests_per_sec,
}

/**
 * The aggregation function to be applied on the client metric. Allowed functions
 * - ‘percentage’ - for error metric , ‘avg’, ‘p50’, ‘p90’, ‘p95’, ‘p99’, ‘min’,
 * ‘max’ - for response_time_ms and latency metric, ‘avg’ - for requests_per_sec,
 * ‘count’ - for requests
 */
enum PFAgFunc {
  /**
   * Criteria applies for count value
   */
  count,

  /**
   * Criteria applies for given percentage value
   */
  percentage,

  /**
   * Criteria applies for avg value
   */
  avg,

  /**
   * Criteria applies for 50th percentile value
   */
  p50,

  /**
   * Criteria applies for 90th percentile value
   */
  p90,

  /**
   * Criteria applies for 95th percentile value
   */
  p95,

  /**
   * Criteria applies for 99th percentile value
   */
  p99,

  /**
   * Criteria applies for minimum value
   */
  min,

  /**
   * Criteria applies for maximum value
   */
  max,
}

/**
 * Action taken after the threshold is met. Default is ‘continue’.
 */
enum PFAction {
  /**
   * Test will continue to run even if pass fail metric criteria metric gets failed
   */
  continue,

  /**
   * Test run will stop if pass fail criteria metric is not passed.
   */
  stop,
}

/**
 * Outcome of the test run.
 */
enum PFResult {
  /**
   * Given pass fail criteria metric has passed.
   */
  passed,

  /**
   * Given pass fail criteria metric couldn't determine.
   */
  undetermined,

  /**
   * Given pass fail criteria metric has failed.
   */
  failed,
}

/**
 * Type of secret
 */
enum SecretType {
  /**
   * If the secret is stored in an Azure Key Vault
   */
  AKV_SECRET_URI,

  /**
   * If the Plain text secret value provided
   */
  SECRET_VALUE,
}

/**
 * Type of certificate
 */
enum CertificateType {
  /**
   * If the certificate is stored in an Azure Key Vault
   */
  AKV_CERT_URI,
}

/**
 * File type
 */
enum FileType {
  /**
   * If file is jmx script
   */
  JMX_FILE,

  /**
   * If file is user properties
   */
  USER_PROPERTIES,

  /**
   * If file is not any of other supported type
   */
  ADDITIONAL_ARTIFACTS,
}

/**
 * Validation status of the file
 */
enum FileStatus {
  /**
   * File is not validated.
   */
  NOT_VALIDATED,

  /**
   * File is validated.
   */
  VALIDATION_SUCCESS,

  /**
   * File validation is failed.
   */
  VALIDATION_FAILURE,

  /**
   * File validation is in progress.
   */
  VALIDATION_INITIATED,

  /**
   * Validation is not required.
   */
  VALIDATION_NOT_REQUIRED,
}

/**
 * Test result for pass/Fail criteria used during the test run.
 */
enum PFTestResult {
  /**
   * Pass/fail criteria has passed.
   */
  PASSED,

  /**
   * Pass/fail criteria is not applicable.
   */
  NOT_APPLICABLE,

  /**
   * Pass/fail criteria has failed.
   */
  FAILED,
}

/**
 * The test run status.
 */
enum Status {
  /**
   * Test run request is accepted
   */
  ACCEPTED,

  /**
   * Test run is not yet started.
   */
  NOTSTARTED,

  /**
   * Test run is getting provision
   */
  PROVISIONING,

  /**
   * Test run is provisioned
   */
  PROVISIONED,

  /**
   * Test run is getting configure
   */
  CONFIGURING,

  /**
   * Test run configuration is done
   */
  CONFIGURED,

  /**
   * Test run has started executing
   */
  EXECUTING,

  /**
   * Test run has been executed
   */
  EXECUTED,

  /**
   * Test run is getting deprovision
   */
  DEPROVISIONING,

  /**
   * Test run request is deprovisioned
   */
  DEPROVISIONED,

  /**
   * Test run request is finished
   */
  DONE,

  /**
   * Test run request is getting cancelled
   */
  CANCELLING,

  /**
   * Test run request is cancelled
   */
  CANCELLED,

  /**
   * Test run request is failed
   */
  FAILED,

  /**
   * Test run JMX file is validated
   */
  VALIDATION_SUCCESS,

  /**
   * Test run JMX file validation is failed
   */
  VALIDATION_FAILURE,
}

/**
 * The primary aggregation type value defining how to use the values for display.
 */
enum AggregationType {
  /**
   * Average value
   */
  Average,

  /**
   * Total count
   */
  Count,

  /**
   * Aggregation will be average in this case
   */
  None,

  /**
   * Total sum
   */
  Total,

  /**
   * 90th percentile
   */
  Percentile90,

  /**
   * 95th percentile
   */
  Percentile95,

  /**
   * 99th percentile
   */
  Percentile99,
}

/**
 * The unit of the metric.
 */
enum MetricUnit {
  /**
   * No unit specified
   */
  NotSpecified,

  /**
   * Percentage
   */
  Percent,

  /**
   * Value count
   */
  Count,

  /**
   * Seconds
   */
  Seconds,

  /**
   * Milliseconds
   */
  Milliseconds,

  /**
   * Bytes
   */
  Bytes,

  /**
   * Bytes per second
   */
  BytesPerSecond,

  /**
   * Count per second
   */
  CountPerSecond,
}

/**
 * The time grain specifies the aggregation interval for the metric. Expressed as
 * a duration 'PT1M', 'PT1H', etc.
 */
enum TimeGrain {
  /**
   * 5 seconds, available only if test run duration is less than 10 minutes
   */
  PT5S,

  /**
   * 10 seconds, available only if test run duration is less than 10 minutes
   */
  PT10S,

  /**
   * 1 minute
   */
  PT1M,

  /**
   * 5 minutes, available only if test run duration is greater than 1 minute
   */
  PT5M,

  /**
   * 1 hour, available only if test run duration is greater than 1 minute
   */
  PT1H,
}

enum Interval {
  /**
   * 5 seconds, available only if test run duration is less than 10 minutes
   */
  PT5S,

  /**
   * 10 seconds, available only if test run duration is less than 10 minutes
   */
  PT10S,

  /**
   * 1 minute
   */
  PT1M,

  /**
   * 5 minutes, available only if test run duration is greater than 1 minute
   */
  PT5M,

  /**
   * 1 hour, available only if test run duration is greater than 1 minute
   */
  PT1H,
}

/**
 * Load test model
 */
model Test {
  /**
   * Pass fail criteria for a test.
   */
  passFailCriteria?: PassFailCriteria;

  /**
   * Secrets can be stored in an Azure Key Vault or any other secret store. If the
   * secret is stored in an Azure Key Vault, the value should be the secret
   * identifier and the type should be AKV_SECRET_URI. If the secret is stored
   * elsewhere, the secret value should be provided directly and the type should be
   * SECRET_VALUE.
   */
  secrets?: Record<Secret>;

  /**
   * Certificates metadata
   */
  certificate?: CertificateMetadata;

  /**
   * Environment variables which are defined as a set of <name,value> pairs.
   */
  environmentVariables?: Record<string>;

  /**
   * The load test configuration.
   */
  loadTestConfiguration?: LoadTestConfiguration;

  /**
   * The input artifacts for the test.
   */
  @visibility("read")
  inputArtifacts?: TestInputArtifacts;

  /**
   * Unique test name as identifier.
   */
  @visibility("read")
  @maxLength(50)
  @minLength(2)
  testId?: string;

  /**
   * The test description.
   */
  @maxLength(100)
  description?: string;

  /**
   * Display name of a test.
   */
  @maxLength(50)
  @minLength(2)
  displayName?: string;

  /**
   * Subnet ID on which the load test instances should run.
   */
  subnetId?: string;

  /**
   * Type of the managed identity referencing the Key vault.
   */
  keyvaultReferenceIdentityType?: string;

  /**
   * Resource Id of the managed identity referencing the Key vault.
   */
  keyvaultReferenceIdentityId?: string;

  /**
   * The creation datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * The user that created.
   */
  @visibility("read")
  createdBy?: string;

  /**
   * The last Modified datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * The user that last modified.
   */
  @visibility("read")
  lastModifiedBy?: string;
}

/**
 * Pass fail criteria for a test.
 */
model PassFailCriteria {
  /**
   * Map of id and pass fail metrics { id  : pass fail metrics }.
   */
  passFailMetrics?: Record<PassFailMetric>;
}

/**
 * Pass fail metric
 */
model PassFailMetric {
  /**
   * The client metric on which the criteria should be applied.
   */
  clientMetric?: PFMetrics;

  /**
   * The aggregation function to be applied on the client metric. Allowed functions
   * - ‘percentage’ - for error metric , ‘avg’, ‘p50’, ‘p90’, ‘p95’, ‘p99’, ‘min’,
   * ‘max’ - for response_time_ms and latency metric, ‘avg’ - for requests_per_sec,
   * ‘count’ - for requests
   */
  aggregate?: PFAgFunc;

  /**
   * The comparison operator. Supported types ‘>’, ‘<’
   */
  condition?: string;

  /**
   * Request name for which the Pass fail criteria has to be applied
   */
  requestName?: string;

  /**
   * The value to compare with the client metric. Allowed values - ‘error : [0.0 ,
   * 100.0] unit- % ’, response_time_ms and latency : any integer value unit- ms.
   */
  value?: float64;

  /**
   * Action taken after the threshold is met. Default is ‘continue’.
   */
  action?: PFAction = PFAction.continue;

  /**
   * The actual value of the client metric for the test run.
   */
  @visibility("read")
  actualValue?: float64;

  /**
   * Outcome of the test run.
   */
  @visibility("read")
  result?: PFResult;
}

/**
 * Secret
 */
model Secret {
  /**
   * The value of the secret for the respective type
   */
  value?: string;

  /**
   * Type of secret
   */
  type?: SecretType;
}

/**
 * Certificates metadata
 */
model CertificateMetadata {
  /**
   * The value of the certificate for respective type
   */
  value?: string;

  /**
   * Type of certificate
   */
  type?: CertificateType;

  /**
   * Name of the certificate.
   */
  name?: string;
}

/**
 * The load test configuration.
 */
model LoadTestConfiguration {
  /**
   * The number of engine instances to execute load test. Supported values are in
   * range of 1-45. Required for creating a new test.
   */
  engineInstances?: int32;

  /**
   * If false, Azure Load Testing copies and processes your input files unmodified
   * across all test engine instances. If true, Azure Load Testing splits the CSV
   * input data evenly across all engine instances. If you provide multiple CSV
   * files, each file will be split evenly.
   */
  splitAllCSVs?: boolean;

  /**
   * If true, optionalLoadTestConfig is required and JMX script for the load test is
   * not required to upload.
   */
  quickStartTest?: boolean;

  /**
   * Optional load test config
   */
  optionalLoadTestConfig?: OptionalLoadTestConfig;
}

/**
 * Optional load test config
 */
model OptionalLoadTestConfig {
  /**
   * Test URL. Provide the complete HTTP URL. For example,
   * http://contoso-app.azurewebsites.net/login
   */
  endpointUrl?: string;

  /**
   * No of concurrent virtual users
   */
  virtualUsers?: int32;

  /**
   * Ramp up time
   */
  rampUpTime?: int32;

  /**
   * Test run duration
   */
  duration?: int32;
}

/**
 * The input artifacts for the test.
 */
model TestInputArtifacts {
  /**
   * File info
   */
  configFileInfo?: FileInfo;

  /**
   * File info
   */
  testScriptFileInfo?: FileInfo;

  /**
   * File info
   */
  userPropFileInfo?: FileInfo;

  /**
   * File info
   */
  inputArtifactsZipFileInfo?: FileInfo;

  /**
   * Additional supported files for the test run
   */
  @visibility("read")
  additionalFileInfo?: FileInfo[];
}

/**
 * File info
 */
model FileInfo {
  /**
   * File URL.
   */
  url?: string;

  /**
   * Name of the file.
   */
  fileName?: string;

  /**
   * File type
   */
  fileType?: FileType;

  /**
   * Expiry time of the file (ISO 8601 literal format)
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expireDateTime?: utcDateTime;

  /**
   * Validation status of the file
   */
  validationStatus?: FileStatus;

  /**
   * Validation failure error details
   */
  validationFailureDetails?: string;
}

/**
 * The definition of an error object.
 */
@error
model ErrorResponseBody {
  /**
   * Error from a REST request.
   */
  error: Error;
}

/**
 * Error from a REST request.
 */
model Error {
  /**
   * The error code.
   */
  code: string;

  /**
   * The error message.
   */
  message: string;

  /**
   * The error target.
   */
  target?: string;

  /**
   * Additional details and inner errors.
   */
  details?: Error[];
}

/**
 * Collection of tests
 */
model TestsList is Azure.Core.Page<Test>;

/**
 * Collection of files.
 */
model FileInfoList is Azure.Core.Page<FileInfo>;

/**
 * Test app component
 */
model TestAppComponents {
  /**
   * Azure resource collection { resource id (fully qualified resource Id e.g
   * subscriptions/{subId}/resourceGroups/{rg}/providers/Microsoft.LoadTestService/loadtests/{resName})
   * : resource object }
   */
  components: Record<AppComponent>;

  /**
   * Test identifier
   */
  @visibility("read")
  testId?: string;

  /**
   * The creation datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * The user that created.
   */
  @visibility("read")
  createdBy?: string;

  /**
   * The last Modified datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * The user that last modified.
   */
  @visibility("read")
  lastModifiedBy?: string;
}

/**
 * An Azure resource object (Refer azure generic resource model :
 * https://docs.microsoft.com/en-us/rest/api/resources/resources/get-by-id#genericresource)
 */
model AppComponent {
  /**
   * fully qualified resource Id e.g
   * subscriptions/{subId}/resourceGroups/{rg}/providers/Microsoft.LoadTestService/loadtests/{resName}
   */
  @visibility("read")
  resourceId?: string;

  /**
   * Azure resource name, required while creating the app component.
   */
  resourceName?: string;

  /**
   * Azure resource type, required while creating the app component.
   */
  resourceType?: string;

  /**
   * Azure resource display name
   */
  displayName?: string;

  /**
   * Resource group name of the Azure resource
   */
  @visibility("read")
  resourceGroup?: string;

  /**
   * Subscription Id of the Azure resource
   */
  @visibility("read")
  subscriptionId?: string;

  /**
   * Kind of Azure resource type
   */
  kind?: string;
}

/**
 * Test server metrics configuration
 */
model TestServerMetricConfig {
  /**
   * Test identifier
   */
  @visibility("read")
  testId?: string;

  /**
   * Azure resource metrics collection {metric id : metrics object} (Refer :
   * https://docs.microsoft.com/en-us/rest/api/monitor/metric-definitions/list#metricdefinition
   * for metric id).
   */
  metrics?: Record<ResourceMetric>;

  /**
   * The creation datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * The user that created.
   */
  @visibility("read")
  createdBy?: string;

  /**
   * The last Modified datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * The user that last modified.
   */
  @visibility("read")
  lastModifiedBy?: string;
}

/**
 * Associated metric definition for particular metrics of the azure resource (
 * Refer :
 * https://docs.microsoft.com/en-us/rest/api/monitor/metric-definitions/list#metricdefinition).
 */
model ResourceMetric {
  /**
   * Unique name for metric.
   */
  @visibility("read")
  id?: string;

  /**
   * Azure resource id.
   */
  resourceId: string;

  /**
   * Metric name space.
   */
  metricNamespace: string;

  /**
   * Metric description.
   */
  displayDescription?: string;

  /**
   * The invariant value of metric name
   */
  name: string;

  /**
   * Metric aggregation.
   */
  aggregation: string;

  /**
   * Metric unit.
   */
  unit?: string;

  /**
   * Azure resource type.
   */
  resourceType: string;
}

/**
 * Load test run model
 */
model TestRun {
  /**
   * Pass fail criteria for a test.
   */
  passFailCriteria?: PassFailCriteria;

  /**
   * Secrets can be stored in an Azure Key Vault or any other secret store. If the
   * secret is stored in an Azure Key Vault, the value should be the secret
   * identifier and the type should be AKV_SECRET_URI. If the secret is stored
   * elsewhere, the secret value should be provided directly and the type should be
   * SECRET_VALUE.
   */
  secrets?: Record<Secret>;

  /**
   * Certificates metadata
   */
  certificate?: CertificateMetadata;

  /**
   * Environment variables which are defined as a set of <name,value> pairs.
   */
  environmentVariables?: Record<string>;

  /**
   * Error details if there is any failure in load test run
   */
  @visibility("read")
  errorDetails?: ErrorDetails[];

  /**
   * Test run statistics.
   */
  @visibility("read")
  testRunStatistics?: Record<TestRunStatistics>;

  /**
   * The load test configuration.
   */
  loadTestConfiguration?: LoadTestConfiguration;

  /**
   * Collection of test run artifacts
   */
  @visibility("read")
  testArtifacts?: TestRunArtifacts;

  /**
   * Test result for pass/Fail criteria used during the test run.
   */
  @visibility("read")
  testResult?: PFTestResult;

  /**
   * Number of virtual users, for which test has been run.
   */
  @visibility("read")
  virtualUsers?: int32;

  /**
   * Unique test run name as identifier
   */
  @visibility("read")
  testRunId?: string;

  /**
   * Display name of a testRun.
   */
  @maxLength(50)
  @minLength(2)
  displayName?: string;

  /**
   * Associated test Id.
   */
  @maxLength(50)
  @minLength(2)
  testId?: string;

  /**
   * The test run description.
   */
  @maxLength(100)
  description?: string;

  /**
   * The test run status.
   */
  @visibility("read")
  status?: Status;

  /**
   * The test run start DateTime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  /**
   * The test run end DateTime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  /**
   * Test run initiated time.
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  executedDateTime?: utcDateTime;

  /**
   * Portal url.
   */
  @visibility("read")
  portalUrl?: string;

  /**
   * Test run duration in milliseconds.
   */
  @visibility("read")
  duration?: int64;

  /**
   * Subnet ID on which the load test instances should run.
   */
  @visibility("read")
  subnetId?: string;

  /**
   * The creation datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * The user that created.
   */
  @visibility("read")
  createdBy?: string;

  /**
   * The last Modified datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * The user that last modified.
   */
  @visibility("read")
  lastModifiedBy?: string;
}

/**
 * Error details if there is any failure in load test run
 */
model ErrorDetails {
  /**
   * Error details in case test run was not successfully run.
   */
  @visibility("read")
  message?: string;
}

/**
 * Test run statistics.
 */
model TestRunStatistics {
  /**
   * Transaction name.
   */
  @visibility("read")
  transaction?: string;

  /**
   * Sampler count.
   */
  @visibility("read")
  sampleCount?: float64;

  /**
   * Error count.
   */
  @visibility("read")
  errorCount?: float64;

  /**
   * Error percentage.
   */
  @visibility("read")
  errorPct?: float64;

  /**
   * Mean response time.
   */
  @visibility("read")
  meanResTime?: float64;

  /**
   * Median response time.
   */
  @visibility("read")
  medianResTime?: float64;

  /**
   * Max response time.
   */
  @visibility("read")
  maxResTime?: float64;

  /**
   * Minimum response time.
   */
  @visibility("read")
  minResTime?: float64;

  /**
   * 90 percentile response time.
   */
  @visibility("read")
  pct1ResTime?: float64;

  /**
   * 95 percentile response time.
   */
  @visibility("read")
  pct2ResTime?: float64;

  /**
   * 99 percentile response time.
   */
  @visibility("read")
  pct3ResTime?: float64;

  /**
   * Throughput.
   */
  @visibility("read")
  throughput?: float64;

  /**
   * Received network bytes.
   */
  @visibility("read")
  receivedKBytesPerSec?: float64;

  /**
   * Send network bytes.
   */
  @visibility("read")
  sentKBytesPerSec?: float64;
}

/**
 * Collection of test run artifacts
 */
model TestRunArtifacts {
  /**
   * The input artifacts for the test run.
   */
  @visibility("read")
  inputArtifacts?: TestRunInputArtifacts;

  /**
   * The output artifacts for the test run.
   */
  outputArtifacts?: TestRunOutputArtifacts;
}

/**
 * The input artifacts for the test run.
 */
model TestRunInputArtifacts {
  /**
   * File info
   */
  configFileInfo?: FileInfo;

  /**
   * File info
   */
  testScriptFileInfo?: FileInfo;

  /**
   * File info
   */
  userPropFileInfo?: FileInfo;

  /**
   * File info
   */
  inputArtifactsZipFileInfo?: FileInfo;

  /**
   * Additional supported files for the test run
   */
  @visibility("read")
  additionalFileInfo?: FileInfo[];
}

/**
 * The output artifacts for the test run.
 */
model TestRunOutputArtifacts {
  /**
   * File info
   */
  resultFileInfo?: FileInfo;

  /**
   * File info
   */
  logsFileInfo?: FileInfo;
}

/**
 * Collection of test runs
 */
model TestRunsList is Azure.Core.Page<TestRun>;

/**
 * Represents collection of metric namespaces.
 */
model MetricNamespaceCollection {
  /**
   * The values for the metric namespaces.
   */
  value: MetricNamespace[];
}

/**
 * Metric namespace class specifies the metadata for a metric namespace.
 */
model MetricNamespace {
  /**
   * The namespace description.
   */
  description?: string;

  /**
   * The metric namespace name.
   */
  name?: string;
}

/**
 * Represents collection of metric definitions.
 */
model MetricDefinitionCollection {
  /**
   * the values for the metric definitions.
   */
  value: MetricDefinition[];
}

/**
 * Metric definition
 */
model MetricDefinition {
  /**
   * List of dimensions
   */
  dimensions?: NameAndDesc[];

  /**
   * The metric description
   */
  description?: string;

  /**
   * The metric name
   */
  name?: string;

  /**
   * The namespace the metric belongs to.
   */
  `namespace`?: string;

  /**
   * The primary aggregation type value defining how to use the values for display.
   */
  primaryAggregationType?: AggregationType;

  /**
   * The collection of what all aggregation types are supported.
   */
  supportedAggregationTypes?: string[];

  /**
   * The unit of the metric.
   */
  unit?: MetricUnit;

  /**
   * Metric availability specifies the time grain (aggregation interval or
   * frequency).
   */
  metricAvailabilities?: MetricAvailability[];
}

/**
 * The name and description
 */
model NameAndDesc {
  /**
   * The description
   */
  description?: string;

  /**
   * The name
   */
  name?: string;
}

/**
 * Metric availability specifies the time grain (aggregation interval or frequency)
 */
model MetricAvailability {
  /**
   * The time grain specifies the aggregation interval for the metric. Expressed as
   * a duration 'PT1M', 'PT1H', etc.
   */
  timeGrain?: TimeGrain;
}

/**
 * Filters to fetch the set of metric
 */
model MetricRequestPayload {
  /**
   * Get metrics for specific dimension values. Example: Metric contains dimension
   * like SamplerName, Error. To retrieve all the time series data where SamplerName
   * is equals to HTTPRequest1 or HTTPRequest2, the DimensionFilter value will be
   * {"SamplerName", ["HTTPRequest1", "HTTPRequest2"}
   */
  filters?: DimensionFilter[];
}

/**
 * Dimension name and values to filter
 */
model DimensionFilter {
  /**
   * The dimension name
   */
  name?: string;

  /**
   * The dimension values. Maximum values can be 20.
   */
  values?: string[];
}

/**
 * The response to a metrics query.
 */
model Metrics is Azure.Core.Page<TimeSeriesElement>;

/**
 * The time series returned when a data query is performed.
 */
model TimeSeriesElement {
  /**
   * An array of data points representing the metric values.
   */
  data?: MetricValue[];

  /**
   * The dimension values
   */
  dimensionValues?: DimensionValue[];
}

/**
 * Represents a metric value.
 */
model MetricValue {
  /**
   * The timestamp for the metric value in ISO 8601 format.
   */
  timestamp?: string;

  /**
   * The metric value.
   */
  value?: float64;
}

/**
 * Represents a metric dimension value.
 */
model DimensionValue {
  /**
   * The name of the dimension.
   */
  name?: string;

  /**
   * The value of the dimension.
   */
  value?: string;
}

/**
 * Metrics dimension values.
 */
model DimensionValueList is Azure.Core.Page<string>;

/**
 * Test run app component
 */
model TestRunAppComponents {
  /**
   * Azure resource collection { resource id (fully qualified resource Id e.g
   * subscriptions/{subId}/resourceGroups/{rg}/providers/Microsoft.LoadTestService/loadtests/{resName})
   * : resource object }
   */
  components: Record<AppComponent>;

  /**
   * Test run identifier
   */
  @visibility("read")
  testRunId?: string;

  /**
   * The creation datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * The user that created.
   */
  @visibility("read")
  createdBy?: string;

  /**
   * The last Modified datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * The user that last modified.
   */
  @visibility("read")
  lastModifiedBy?: string;
}

/**
 * Test run server metrics configuration
 */
model TestRunServerMetricConfig {
  /**
   * Test run identifier
   */
  @visibility("read")
  testRunId?: string;

  /**
   * Azure resource metrics collection {metric id : metrics object} (Refer :
   * https://docs.microsoft.com/en-us/rest/api/monitor/metric-definitions/list#metricdefinition
   * for metric id).
   */
  metrics?: Record<ResourceMetric>;

  /**
   * The creation datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  /**
   * The user that created.
   */
  @visibility("read")
  createdBy?: string;

  /**
   * The last Modified datetime(ISO 8601 literal format).
   */
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  /**
   * The user that last modified.
   */
  @visibility("read")
  lastModifiedBy?: string;
}
