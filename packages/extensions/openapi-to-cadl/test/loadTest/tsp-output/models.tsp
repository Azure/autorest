import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.LoadTesting;

enum PFMetrics {
  @doc("Pass fail criteria for response time metric") response_time_ms,
  @doc("Pass fail criteria for response time metric") latency,
  @doc("Pass fail criteria for error metric") error,
  @doc("Pass fail criteria for total requests") requests,
  @doc("Pass fail criteria for request rate.") requests_per_sec,
}

enum PFAgFunc {
  @doc("Criteria applies for count value") count,
  @doc("Criteria applies for given percentage value") percentage,
  @doc("Criteria applies for avg value") avg,
  @doc("Criteria applies for 50th percentile value") p50,
  @doc("Criteria applies for 90th percentile value") p90,
  @doc("Criteria applies for 95th percentile value") p95,
  @doc("Criteria applies for 99th percentile value") p99,
  @doc("Criteria applies for minimum value") min,
  @doc("Criteria applies for maximum value") max,
}

enum PFAction {
  @doc("Test will continue to run even if pass fail metric criteria metric gets failed")
  continue,
  @doc("Test run will stop if pass fail criteria metric is not passed.") stop,
}

enum PFResult {
  @doc("Given pass fail criteria metric has passed.") passed,
  @doc("Given pass fail criteria metric couldn't determine.") undetermined,
  @doc("Given pass fail criteria metric has failed.") failed,
}

enum SecretType {
  @doc("If the secret is stored in an Azure Key Vault") AKV_SECRET_URI,
  @doc("If the Plain text secret value provided") SECRET_VALUE,
}

enum CertificateType {
  @doc("If the certificate is stored in an Azure Key Vault") AKV_CERT_URI,
}

enum FileType {
  @doc("If file is jmx script") JMX_FILE,
  @doc("If file is user properties") USER_PROPERTIES,
  @doc("If file is not any of other supported type") ADDITIONAL_ARTIFACTS,
}

enum FileStatus {
  @doc("File is not validated.") NOT_VALIDATED,
  @doc("File is validated.") VALIDATION_SUCCESS,
  @doc("File validation is failed.") VALIDATION_FAILURE,
  @doc("File validation is in progress.") VALIDATION_INITIATED,
  @doc("Validation is not required.") VALIDATION_NOT_REQUIRED,
}

enum PFTestResult {
  @doc("Pass/fail criteria has passed.") PASSED,
  @doc("Pass/fail criteria is not applicable.") NOT_APPLICABLE,
  @doc("Pass/fail criteria has failed.") FAILED,
}

enum Status {
  @doc("Test run request is accepted") ACCEPTED,
  @doc("Test run is not yet started.") NOTSTARTED,
  @doc("Test run is getting provision") PROVISIONING,
  @doc("Test run is provisioned") PROVISIONED,
  @doc("Test run is getting configure") CONFIGURING,
  @doc("Test run configuration is done") CONFIGURED,
  @doc("Test run has started executing") EXECUTING,
  @doc("Test run has been executed") EXECUTED,
  @doc("Test run is getting deprovision") DEPROVISIONING,
  @doc("Test run request is deprovisioned") DEPROVISIONED,
  @doc("Test run request is finished") DONE,
  @doc("Test run request is getting cancelled") CANCELLING,
  @doc("Test run request is cancelled") CANCELLED,
  @doc("Test run request is failed") FAILED,
  @doc("Test run JMX file is validated") VALIDATION_SUCCESS,
  @doc("Test run JMX file validation is failed") VALIDATION_FAILURE,
}

enum AggregationType {
  @doc("Average value") Average,
  @doc("Total count") Count,
  @doc("Aggregation will be average in this case") None,
  @doc("Total sum") Total,
  @doc("90th percentile") Percentile90,
  @doc("95th percentile") Percentile95,
  @doc("99th percentile") Percentile99,
}

enum MetricUnit {
  @doc("No unit specified") NotSpecified,
  @doc("Percentage") Percent,
  @doc("Value count") Count,
  @doc("Seconds") Seconds,
  @doc("Milliseconds") Milliseconds,
  @doc("Bytes") Bytes,
  @doc("Bytes per second") BytesPerSecond,
  @doc("Count per second") CountPerSecond,
}

enum TimeGrain {
  @doc("5 seconds, available only if test run duration is less than 10 minutes")
  PT5S,
  @doc("10 seconds, available only if test run duration is less than 10 minutes")
  PT10S,
  @doc("1 minute") PT1M,
  @doc("5 minutes, available only if test run duration is greater than 1 minute")
  PT5M,
  @doc("1 hour, available only if test run duration is greater than 1 minute")
  PT1H,
}

enum Interval {
  @doc("5 seconds, available only if test run duration is less than 10 minutes")
  PT5S,
  @doc("10 seconds, available only if test run duration is less than 10 minutes")
  PT10S,
  @doc("1 minute") PT1M,
  @doc("5 minutes, available only if test run duration is greater than 1 minute")
  PT5M,
  @doc("1 hour, available only if test run duration is greater than 1 minute")
  PT1H,
}

@doc("Load test model")
model Test {
  @doc("Pass fail criteria for a test.")
  passFailCriteria?: PassFailCriteria;

  @doc("""
Secrets can be stored in an Azure Key Vault or any other secret store. If the
secret is stored in an Azure Key Vault, the value should be the secret
identifier and the type should be AKV_SECRET_URI. If the secret is stored
elsewhere, the secret value should be provided directly and the type should be
SECRET_VALUE.
""")
  secrets?: Record<Secret>;

  @doc("Certificates metadata")
  certificate?: CertificateMetadata;

  @doc("Environment variables which are defined as a set of <name,value> pairs.")
  environmentVariables?: Record<string>;

  @doc("The load test configuration.")
  loadTestConfiguration?: LoadTestConfiguration;

  @doc("The input artifacts for the test.")
  @visibility("read")
  inputArtifacts?: TestInputArtifacts;

  @doc("Unique test name as identifier.")
  @visibility("read")
  testId?: string;

  @doc("The test description.")
  description?: string;

  @doc("Display name of a test.")
  displayName?: string;

  @doc("Subnet ID on which the load test instances should run.")
  subnetId?: string;

  @doc("Type of the managed identity referencing the Key vault.")
  keyvaultReferenceIdentityType?: string;

  @doc("Resource Id of the managed identity referencing the Key vault.")
  keyvaultReferenceIdentityId?: string;

  @doc("The creation datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("The user that created.")
  @visibility("read")
  createdBy?: string;

  @doc("The last Modified datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("The user that last modified.")
  @visibility("read")
  lastModifiedBy?: string;
}

@doc("Pass fail criteria for a test.")
model PassFailCriteria {
  @doc("Map of id and pass fail metrics { id  : pass fail metrics }.")
  passFailMetrics?: Record<PassFailMetric>;
}

@doc("Pass fail metric")
model PassFailMetric {
  @doc("The client metric on which the criteria should be applied.")
  clientMetric?: PFMetrics;

  @doc("""
The aggregation function to be applied on the client metric. Allowed functions
- ‘percentage’ - for error metric , ‘avg’, ‘p50’, ‘p90’, ‘p95’, ‘p99’, ‘min’,
‘max’ - for response_time_ms and latency metric, ‘avg’ - for requests_per_sec,
‘count’ - for requests
""")
  aggregate?: PFAgFunc;

  @doc("The comparison operator. Supported types ‘>’, ‘<’ ")
  condition?: string;

  @doc("Request name for which the Pass fail criteria has to be applied ")
  requestName?: string;

  @doc("""
The value to compare with the client metric. Allowed values - ‘error : [0.0 ,
100.0] unit- % ’, response_time_ms and latency : any integer value unit- ms.
""")
  value?: float32;

  @doc("Action taken after the threshold is met. Default is ‘continue’.")
  action?: PFAction;

  @doc("The actual value of the client metric for the test run.")
  @visibility("read")
  actualValue?: float32;

  @doc("Outcome of the test run.")
  @visibility("read")
  result?: PFResult;
}

@doc("Secret")
model Secret {
  @doc("The value of the secret for the respective type")
  value?: string;

  @doc("Type of secret")
  type?: SecretType;
}

@doc("Certificates metadata")
model CertificateMetadata {
  @doc("The value of the certificate for respective type")
  value?: string;

  @doc("Type of certificate")
  type?: CertificateType;

  @doc("Name of the certificate.")
  name?: string;
}

@doc("The load test configuration.")
model LoadTestConfiguration {
  @doc("""
The number of engine instances to execute load test. Supported values are in
range of 1-45. Required for creating a new test.
""")
  engineInstances?: int32;

  @doc("""
If false, Azure Load Testing copies and processes your input files unmodified
across all test engine instances. If true, Azure Load Testing splits the CSV
input data evenly across all engine instances. If you provide multiple CSV
files, each file will be split evenly.
""")
  splitAllCSVs?: boolean;

  @doc("""
If true, optionalLoadTestConfig is required and JMX script for the load test is
not required to upload.
""")
  quickStartTest?: boolean;

  @doc("Optional load test config")
  optionalLoadTestConfig?: OptionalLoadTestConfig;
}

@doc("Optional load test config")
model OptionalLoadTestConfig {
  @doc("""
Test URL. Provide the complete HTTP URL. For example,
http://contoso-app.azurewebsites.net/login
""")
  endpointUrl?: string;

  @doc("No of concurrent virtual users")
  virtualUsers?: int32;

  @doc("Ramp up time")
  rampUpTime?: int32;

  @doc("Test run duration")
  duration?: int32;
}

@doc("The input artifacts for the test.")
model TestInputArtifacts {
  @doc("File info")
  configFileInfo?: FileInfo;

  @doc("File info")
  testScriptFileInfo?: FileInfo;

  @doc("File info")
  userPropFileInfo?: FileInfo;

  @doc("File info")
  inputArtifactsZipFileInfo?: FileInfo;

  @doc("Additional supported files for the test run")
  @visibility("read")
  additionalFileInfo?: FileInfo[];
}

@doc("File info")
model FileInfo {
  @doc("File URL.")
  url?: string;

  @doc("Name of the file.")
  fileName?: string;

  @doc("File type")
  fileType?: FileType;

  @doc("Expiry time of the file (ISO 8601 literal format)")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  expireDateTime?: utcDateTime;

  @doc("Validation status of the file")
  validationStatus?: FileStatus;

  @doc("Validation failure error details")
  validationFailureDetails?: string;
}

@doc("The definition of an error object.")
@error
model ErrorResponseBody {
  @doc("Error from a REST request.")
  error: Error;
}

@doc("Error from a REST request.")
model Error {
  @doc("The error code.")
  code: string;

  @doc("The error message.")
  message: string;

  @doc("The error target.")
  target?: string;

  @doc("Additional details and inner errors.")
  details?: Error[];
}

@doc("Collection of tests")
model TestsList is Azure.Core.Page<Test>;

@doc("Collection of files.")
model FileInfoList is Azure.Core.Page<FileInfo>;

@doc("Test app component")
model TestAppComponents {
  @doc("""
Azure resource collection { resource id (fully qualified resource Id e.g
subscriptions/{subId}/resourceGroups/{rg}/providers/Microsoft.LoadTestService/loadtests/{resName})
: resource object } 
""")
  components: Record<AppComponent>;

  @doc("Test identifier")
  @visibility("read")
  testId?: string;

  @doc("The creation datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("The user that created.")
  @visibility("read")
  createdBy?: string;

  @doc("The last Modified datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("The user that last modified.")
  @visibility("read")
  lastModifiedBy?: string;
}

@doc("""
An Azure resource object (Refer azure generic resource model :
https://docs.microsoft.com/en-us/rest/api/resources/resources/get-by-id#genericresource)
""")
model AppComponent {
  @doc("""
fully qualified resource Id e.g
subscriptions/{subId}/resourceGroups/{rg}/providers/Microsoft.LoadTestService/loadtests/{resName}
""")
  @visibility("read")
  resourceId?: string;

  @doc("Azure resource name, required while creating the app component.")
  resourceName?: string;

  @doc("Azure resource type, required while creating the app component.")
  resourceType?: string;

  @doc("Azure resource display name")
  displayName?: string;

  @doc("Resource group name of the Azure resource")
  @visibility("read")
  resourceGroup?: string;

  @doc("Subscription Id of the Azure resource")
  @visibility("read")
  subscriptionId?: string;

  @doc("Kind of Azure resource type")
  kind?: string;
}

@doc("Test server metrics configuration")
model TestServerMetricConfig {
  @doc("Test identifier")
  @visibility("read")
  testId?: string;

  @doc("""
Azure resource metrics collection {metric id : metrics object} (Refer :
https://docs.microsoft.com/en-us/rest/api/monitor/metric-definitions/list#metricdefinition
for metric id).
""")
  metrics?: Record<ResourceMetric>;

  @doc("The creation datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("The user that created.")
  @visibility("read")
  createdBy?: string;

  @doc("The last Modified datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("The user that last modified.")
  @visibility("read")
  lastModifiedBy?: string;
}

@doc("""
Associated metric definition for particular metrics of the azure resource (
Refer :
https://docs.microsoft.com/en-us/rest/api/monitor/metric-definitions/list#metricdefinition).
""")
model ResourceMetric {
  @doc("Unique name for metric.")
  @visibility("read")
  id?: string;

  @doc("Azure resource id.")
  resourceId: string;

  @doc("Metric name space.")
  metricNamespace: string;

  @doc("Metric description.")
  displayDescription?: string;

  @doc("The invariant value of metric name")
  name: string;

  @doc("Metric aggregation.")
  aggregation: string;

  @doc("Metric unit.")
  unit?: string;

  @doc("Azure resource type.")
  resourceType: string;
}

@doc("Load test run model")
model TestRun {
  @doc("Pass fail criteria for a test.")
  passFailCriteria?: PassFailCriteria;

  @doc("""
Secrets can be stored in an Azure Key Vault or any other secret store. If the
secret is stored in an Azure Key Vault, the value should be the secret
identifier and the type should be AKV_SECRET_URI. If the secret is stored
elsewhere, the secret value should be provided directly and the type should be
SECRET_VALUE.
""")
  secrets?: Record<Secret>;

  @doc("Certificates metadata")
  certificate?: CertificateMetadata;

  @doc("Environment variables which are defined as a set of <name,value> pairs.")
  environmentVariables?: Record<string>;

  @doc("Error details if there is any failure in load test run")
  @visibility("read")
  errorDetails?: ErrorDetails[];

  @doc("Test run statistics.")
  @visibility("read")
  testRunStatistics?: Record<TestRunStatistics>;

  @doc("The load test configuration.")
  loadTestConfiguration?: LoadTestConfiguration;

  @doc("Collection of test run artifacts")
  @visibility("read")
  testArtifacts?: TestRunArtifacts;

  @doc("Test result for pass/Fail criteria used during the test run.")
  @visibility("read")
  testResult?: PFTestResult;

  @doc("Number of virtual users, for which test has been run.")
  @visibility("read")
  virtualUsers?: int32;

  @doc("Unique test run name as identifier")
  @visibility("read")
  testRunId?: string;

  @doc("Display name of a testRun.")
  displayName?: string;

  @doc("Associated test Id.")
  testId?: string;

  @doc("The test run description.")
  description?: string;

  @doc("The test run status.")
  @visibility("read")
  status?: Status;

  @doc("The test run start DateTime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startDateTime?: utcDateTime;

  @doc("The test run end DateTime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endDateTime?: utcDateTime;

  @doc("Test run initiated time.")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  executedDateTime?: utcDateTime;

  @doc("Portal url.")
  @visibility("read")
  portalUrl?: string;

  @doc("Test run duration in milliseconds.")
  @visibility("read")
  duration?: int32;

  @doc("Subnet ID on which the load test instances should run.")
  @visibility("read")
  subnetId?: string;

  @doc("The creation datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("The user that created.")
  @visibility("read")
  createdBy?: string;

  @doc("The last Modified datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("The user that last modified.")
  @visibility("read")
  lastModifiedBy?: string;
}

@doc("Error details if there is any failure in load test run")
model ErrorDetails {
  @doc("Error details in case test run was not successfully run.")
  @visibility("read")
  message?: string;
}

@doc("Test run statistics.")
model TestRunStatistics {
  @doc("Transaction name.")
  @visibility("read")
  transaction?: string;

  @doc("Sampler count.")
  @visibility("read")
  sampleCount?: float32;

  @doc("Error count.")
  @visibility("read")
  errorCount?: float32;

  @doc("Error percentage.")
  @visibility("read")
  errorPct?: float32;

  @doc("Mean response time.")
  @visibility("read")
  meanResTime?: float32;

  @doc("Median response time.")
  @visibility("read")
  medianResTime?: float32;

  @doc("Max response time.")
  @visibility("read")
  maxResTime?: float32;

  @doc("Minimum response time.")
  @visibility("read")
  minResTime?: float32;

  @doc("90 percentile response time.")
  @visibility("read")
  pct1ResTime?: float32;

  @doc("95 percentile response time.")
  @visibility("read")
  pct2ResTime?: float32;

  @doc("99 percentile response time.")
  @visibility("read")
  pct3ResTime?: float32;

  @doc("Throughput.")
  @visibility("read")
  throughput?: float32;

  @doc("Received network bytes.")
  @visibility("read")
  receivedKBytesPerSec?: float32;

  @doc("Send network bytes.")
  @visibility("read")
  sentKBytesPerSec?: float32;
}

@doc("Collection of test run artifacts")
model TestRunArtifacts {
  @doc("The input artifacts for the test run.")
  @visibility("read")
  inputArtifacts?: TestRunInputArtifacts;

  @doc("The output artifacts for the test run.")
  outputArtifacts?: TestRunOutputArtifacts;
}

@doc("The input artifacts for the test run.")
model TestRunInputArtifacts {
  @doc("File info")
  configFileInfo?: FileInfo;

  @doc("File info")
  testScriptFileInfo?: FileInfo;

  @doc("File info")
  userPropFileInfo?: FileInfo;

  @doc("File info")
  inputArtifactsZipFileInfo?: FileInfo;

  @doc("Additional supported files for the test run")
  @visibility("read")
  additionalFileInfo?: FileInfo[];
}

@doc("The output artifacts for the test run.")
model TestRunOutputArtifacts {
  @doc("File info")
  resultFileInfo?: FileInfo;

  @doc("File info")
  logsFileInfo?: FileInfo;
}

@doc("Collection of test runs")
model TestRunsList is Azure.Core.Page<TestRun>;

@doc("Represents collection of metric namespaces.")
model MetricNamespaceCollection {
  @doc("The values for the metric namespaces.")
  value: MetricNamespace[];
}

@doc("Metric namespace class specifies the metadata for a metric namespace.")
model MetricNamespace {
  @doc("The namespace description.")
  description?: string;

  @doc("The metric namespace name.")
  name?: string;
}

@doc("Represents collection of metric definitions.")
model MetricDefinitionCollection {
  @doc("the values for the metric definitions.")
  value: MetricDefinition[];
}

@doc("Metric definition")
model MetricDefinition {
  @doc("List of dimensions")
  dimensions?: NameAndDesc[];

  @doc("The metric description")
  description?: string;

  @doc("The metric name")
  name?: string;

  @doc("The namespace the metric belongs to.")
  `namespace`?: string;

  @doc("The primary aggregation type value defining how to use the values for display.")
  primaryAggregationType?: AggregationType;

  @doc("The collection of what all aggregation types are supported.")
  supportedAggregationTypes?: string[];

  @doc("The unit of the metric.")
  unit?: MetricUnit;

  @doc("""
Metric availability specifies the time grain (aggregation interval or
frequency).
""")
  metricAvailabilities?: MetricAvailability[];
}

@doc("The name and description")
model NameAndDesc {
  @doc("The description")
  description?: string;

  @doc("The name")
  name?: string;
}

@doc("Metric availability specifies the time grain (aggregation interval or frequency)")
model MetricAvailability {
  @doc("""
The time grain specifies the aggregation interval for the metric. Expressed as
a duration 'PT1M', 'PT1H', etc.
""")
  timeGrain?: TimeGrain;
}

@doc("Filters to fetch the set of metric")
model MetricRequestPayload {
  @doc("""
Get metrics for specific dimension values. Example: Metric contains dimension
like SamplerName, Error. To retrieve all the time series data where SamplerName
is equals to HTTPRequest1 or HTTPRequest2, the DimensionFilter value will be
{\"SamplerName\", [\"HTTPRequest1\", \"HTTPRequest2\"}
""")
  filters?: DimensionFilter[];
}

@doc("Dimension name and values to filter")
model DimensionFilter {
  @doc("The dimension name")
  name?: string;

  @doc("The dimension values. Maximum values can be 20.")
  values?: string[];
}

@doc("The response to a metrics query.")
model Metrics is Azure.Core.Page<TimeSeriesElement>;

@doc("The time series returned when a data query is performed.")
model TimeSeriesElement {
  @doc("An array of data points representing the metric values.")
  data?: MetricValue[];

  @doc("The dimension values ")
  dimensionValues?: DimensionValue[];
}

@doc("Represents a metric value.")
model MetricValue {
  @doc("The timestamp for the metric value in ISO 8601 format.")
  timestamp?: string;

  @doc("The metric value.")
  value?: float32;
}

@doc("Represents a metric dimension value.")
model DimensionValue {
  @doc("The name of the dimension.")
  name?: string;

  @doc("The value of the dimension.")
  value?: string;
}

@doc("Metrics dimension values.")
model DimensionValueList is Azure.Core.Page<string>;

@doc("Test run app component")
model TestRunAppComponents {
  @doc("""
Azure resource collection { resource id (fully qualified resource Id e.g
subscriptions/{subId}/resourceGroups/{rg}/providers/Microsoft.LoadTestService/loadtests/{resName})
: resource object } 
""")
  components: Record<AppComponent>;

  @doc("Test run identifier")
  @visibility("read")
  testRunId?: string;

  @doc("The creation datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("The user that created.")
  @visibility("read")
  createdBy?: string;

  @doc("The last Modified datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("The user that last modified.")
  @visibility("read")
  lastModifiedBy?: string;
}

@doc("Test run server metrics configuration")
model TestRunServerMetricConfig {
  @doc("Test run identifier")
  @visibility("read")
  testRunId?: string;

  @doc("""
Azure resource metrics collection {metric id : metrics object} (Refer :
https://docs.microsoft.com/en-us/rest/api/monitor/metric-definitions/list#metricdefinition
for metric id).
""")
  metrics?: Record<ResourceMetric>;

  @doc("The creation datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdDateTime?: utcDateTime;

  @doc("The user that created.")
  @visibility("read")
  createdBy?: string;

  @doc("The last Modified datetime(ISO 8601 literal format).")
  @visibility("read")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastModifiedDateTime?: utcDateTime;

  @doc("The user that last modified.")
  @visibility("read")
  lastModifiedBy?: string;
}
