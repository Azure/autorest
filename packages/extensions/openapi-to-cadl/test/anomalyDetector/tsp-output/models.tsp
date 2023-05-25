import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace AnomalyDetectorClient;

enum ApiVersion {
  `v1.1-preview.1`,
}

enum ImputeMode {
  auto,
  previous,
  linear,
  fixed,
  zero,
  notFill,
}

enum AnomalyDetectorErrorCodes {
  InvalidCustomInterval,
  BadArgument,
  InvalidGranularity,
  InvalidPeriod,
  InvalidModelArgument,
  InvalidSeries,
  InvalidJsonFormat,
  RequiredGranularity,
  RequiredSeries,
  InvalidImputeMode,
  InvalidImputeFixedValue,
}

enum FillNAMethod {
  Previous,
  Subsequent,
  Linear,
  Zero,
  Fixed,
  NotFill,
}
@Azure.Core.fixed
enum TimeGranularity {
  yearly,
  monthly,
  weekly,
  daily,
  hourly,
  perMinute: "minutely",
  perSecond: "secondly",
  microsecond,
  none,
}
@Azure.Core.fixed
enum DetectionStatus {
  CREATED,
  RUNNING,
  READY,
  FAILED,
}
@Azure.Core.fixed
enum DataSchema {
  OneTable,
  MultiTable,
}
@Azure.Core.fixed
enum AlignMode {
  Inner,
  Outer,
}
@Azure.Core.fixed
enum ModelStatus {
  CREATED,
  RUNNING,
  READY,
  FAILED,
}

@doc("The request of entire or last anomaly detection.")
model DetectRequest {
  @doc("""
Time series data points. Points should be sorted by timestamp in ascending
order to match the anomaly detection result. If the data is not sorted
correctly or there is duplicated timestamp, the API will not work. In such
case, an error message will be returned.
""")
  series: TimeSeriesPoint[];

  @doc("""
Optional argument, can be one of yearly, monthly, weekly, daily, hourly,
minutely, secondly, microsecond or none. If granularity is not present, it will
be none by default. If granularity is none, the timestamp property in time
series point can be absent.
""")
  granularity?: TimeGranularity;

  @doc("""
Custom Interval is used to set non-standard time interval, for example, if the
series is 5 minutes, request can be set as {\"granularity\":\"minutely\",
\"customInterval\":5}.
""")
  customInterval?: int32;

  @doc("""
Optional argument, periodic value of a time series. If the value is null or
does not present, the API will determine the period automatically.
""")
  period?: int32;

  @doc("Optional argument, advanced model parameter, max anomaly ratio in a time series.")
  maxAnomalyRatio?: float32;

  @doc("""
Optional argument, advanced model parameter, between 0-99, the lower the value
is, the larger the margin value will be which means less anomalies will be
accepted.
""")
  sensitivity?: int32;

  @doc("""
Used to specify how to deal with missing values in the input series, it's used
when granularity is not \"none\".
""")
  imputeMode?: ImputeMode;

  @doc("""
Used to specify the value to fill, it's used when granularity is not \"none\"
and imputeMode is \"fixed\".
""")
  imputeFixedValue?: float32;
}

@doc("The definition of input timeseries points.")
model TimeSeriesPoint {
  @doc("Optional argument, timestamp of a data point (ISO8601 format).")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp?: utcDateTime;

  @doc("The measurement of that point, should be float.")
  value: float32;
}

@doc("The response of entire anomaly detection.")
model EntireDetectResponse {
  @doc("""
Frequency extracted from the series, zero means no recurrent pattern has been
found.
""")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  period: int32;

  @doc("""
ExpectedValues contain expected value for each input point. The index of the
array is consistent with the input series.
""")
  expectedValues: float32[];

  @doc("""
UpperMargins contain upper margin of each input point. UpperMargin is used to
calculate upperBoundary, which equals to expectedValue + (100 -
marginScale)*upperMargin. Anomalies in response can be filtered by
upperBoundary and lowerBoundary. By adjusting marginScale value, less
significant anomalies can be filtered in client side. The index of the array is
consistent with the input series.
""")
  upperMargins: float32[];

  @doc("""
LowerMargins contain lower margin of each input point. LowerMargin is used to
calculate lowerBoundary, which equals to expectedValue - (100 -
marginScale)*lowerMargin. Points between the boundary can be marked as normal
ones in client side. The index of the array is consistent with the input
series.
""")
  lowerMargins: float32[];

  @doc("""
IsAnomaly contains anomaly properties for each input point. True means an
anomaly either negative or positive has been detected. The index of the array
is consistent with the input series.
""")
  isAnomaly: boolean[];

  @doc("""
IsNegativeAnomaly contains anomaly status in negative direction for each input
point. True means a negative anomaly has been detected. A negative anomaly
means the point is detected as an anomaly and its real value is smaller than
the expected one. The index of the array is consistent with the input series.
""")
  isNegativeAnomaly: boolean[];

  @doc("""
IsPositiveAnomaly contain anomaly status in positive direction for each input
point. True means a positive anomaly has been detected. A positive anomaly
means the point is detected as an anomaly and its real value is larger than the
expected one. The index of the array is consistent with the input series.
""")
  isPositiveAnomaly: boolean[];

  @doc("""
The severity score for each input point. The larger the value is, the more
sever the anomaly is. For normal points, the \"severity\" is always 0.
""")
  severity?: float32[];
}

@doc("Error information returned by the API.")
@error
model AnomalyDetectorError {
  @doc("The error code.")
  code?: AnomalyDetectorErrorCodes;

  @doc("A message explaining the error reported by the service.")
  message?: string;
}

@doc("The response of last anomaly detection.")
model LastDetectResponse {
  @doc("""
Frequency extracted from the series, zero means no recurrent pattern has been
found.
""")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  period: int32;

  @doc("Suggested input series points needed for detecting the latest point.")
  suggestedWindow: int32;

  @doc("Expected value of the latest point.")
  expectedValue: float32;

  @doc("""
Upper margin of the latest point. UpperMargin is used to calculate
upperBoundary, which equals to expectedValue + (100 - marginScale)*upperMargin.
If the value of latest point is between upperBoundary and lowerBoundary, it
should be treated as normal value. By adjusting marginScale value, anomaly
status of latest point can be changed.
""")
  upperMargin: float32;

  @doc("""
Lower margin of the latest point. LowerMargin is used to calculate
lowerBoundary, which equals to expectedValue - (100 - marginScale)*lowerMargin.

""")
  lowerMargin: float32;

  @doc("""
Anomaly status of the latest point, true means the latest point is an anomaly
either in negative direction or positive direction.
""")
  isAnomaly: boolean;

  @doc("""
Anomaly status in negative direction of the latest point. True means the latest
point is an anomaly and its real value is smaller than the expected one.
""")
  isNegativeAnomaly: boolean;

  @doc("""
Anomaly status in positive direction of the latest point. True means the latest
point is an anomaly and its real value is larger than the expected one.
""")
  isPositiveAnomaly: boolean;

  @doc("""
The severity score for the last input point. The larger the value is, the more
sever the anomaly is. For normal points, the \"severity\" is always 0.
""")
  severity?: float32;
}

@doc("The request of change point detection.")
model ChangePointDetectRequest {
  @doc("""
Time series data points. Points should be sorted by timestamp in ascending
order to match the change point detection result.
""")
  series: TimeSeriesPoint[];

  @doc("""
Can only be one of yearly, monthly, weekly, daily, hourly, minutely or
secondly. Granularity is used for verify whether input series is valid.
""")
  granularity: TimeGranularity;

  @doc("""
Custom Interval is used to set non-standard time interval, for example, if the
series is 5 minutes, request can be set as {\"granularity\":\"minutely\",
\"customInterval\":5}.
""")
  customInterval?: int32;

  @doc("""
Optional argument, periodic value of a time series. If the value is null or
does not present, the API will determine the period automatically.
""")
  period?: int32;

  @doc("""
Optional argument, advanced model parameter, a default stableTrendWindow will
be used in detection.
""")
  stableTrendWindow?: int32;

  @doc("""
Optional argument, advanced model parameter, between 0.0-1.0, the lower the
value is, the larger the trend error will be which means less change point will
be accepted.
""")
  threshold?: float32;
}

@doc("The response of change point detection.")
model ChangePointDetectResponse {
  @doc("""
Frequency extracted from the series, zero means no recurrent pattern has been
found.
""")
  @visibility("read")
  period?: int32;

  @doc("""
isChangePoint contains change point properties for each input point. True means
an anomaly either negative or positive has been detected. The index of the
array is consistent with the input series.
""")
  isChangePoint?: boolean[];

  @doc("the change point confidence of each point")
  confidenceScores?: float32[];
}

@doc("Detection results for the given resultId.")
@resource("multivariate/entire/detect/{resultId}")
model DetectionResult {
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  resultId: string;

  @doc("Multivariate anomaly detection status.")
  summary: DetectionResultSummary;

  @doc("Detection result for each timestamp.")
  results: AnomalyState[];
}

@doc("Multivariate anomaly detection status.")
model DetectionResultSummary {
  @doc("Status of detection results. One of CREATED, RUNNING, READY, and FAILED.")
  status: DetectionStatus;

  @doc("Error message when detection is failed.")
  errors?: ErrorResponse[];
  variableStates?: VariableState[];

  @doc("Detection request.")
  setupInfo: DetectionRequest;
}

@error
model ErrorResponse {
  @doc("The error code.")
  code: string;

  @doc("The message explaining the error reported by the service.")
  message: string;
}

model VariableState {
  @doc("Variable name.")
  variable?: string;

  @doc("Proportion of NaN values filled of the variable.")
  filledNARatio?: float32;

  @doc("Number of effective points counted.")
  effectiveCount?: int32;

  @doc("First timestamp of the variable.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  firstTimestamp?: utcDateTime;

  @doc("Last timestamp of the variable.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastTimestamp?: utcDateTime;
}

@doc("Detection request.")
model DetectionRequest {
  @doc("""
Source link to the input variables. Each variable should be a csv with two
columns, `timestamp` and `value`. The file name of the variable will be used as
its name. The variables used in detection should be exactly the same with those
used in the training phase.
""")
  dataSource: string;

  @doc("Top contributor count.")
  topContributorCount: int32;

  @doc("""
A required field, indicating the start time of data for detection. Should be
date-time.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("""
A required field, indicating the end time of data for detection. Should be
date-time.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime: utcDateTime;
}

model AnomalyState {
  @doc("timestamp")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp: utcDateTime;
  value?: AnomalyValue;

  @doc("Error message for the current timestamp")
  errors?: ErrorResponse[];
}

model AnomalyValue {
  @doc("True if an anomaly is detected at the current timestamp.")
  isAnomaly: boolean;

  @doc("""
Indicates the significance of the anomaly. The higher the severity, the more
significant the anomaly.
""")
  severity: float32;

  @doc("Raw score from the model.")
  score: float32;
  interpretation?: AnomalyInterpretation[];
}

model AnomalyInterpretation {
  variable?: string;
  contributionScore?: float32;
  correlationChanges?: CorrelationChanges;
}

model CorrelationChanges {
  @doc("correlated variables")
  changedVariables?: string[];
}

@doc("""
Training result of a model including its status, errors and diagnostics
information.
""")
model ModelInfo {
  @doc("""
Source link to the input variables. Each variable should be a csv file with two
columns, `timestamp` and `value`. By default, the file name of the variable
will be used as its variable name.
""")
  dataSource: string;
  dataSchema?: DataSchema;

  @doc("""
A required field, indicating the start time of training data. Should be
date-time.
""")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  @doc("A required field, indicating the end time of training data. Should be date-time.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime: utcDateTime;

  @doc("An optional field. The name of the model whose maximum length is 24.")
  displayName?: string;

  @doc("""
An optional field, indicating how many previous points will be used to compute
the anomaly score of the subsequent point.
""")
  slidingWindow?: int32;

  @doc("An optional field, indicating the manner to align multiple variables.")
  alignPolicy?: AlignPolicy;

  @doc("Model status. One of CREATED, RUNNING, READY, and FAILED.")
  status?: ModelStatus;

  @doc("Error messages when failed to create a model.")
  errors?: ErrorResponse[];

  @doc("Diagnostics Information for inspecting model/variable states.")
  diagnosticsInfo?: DiagnosticsInfo;
}

@doc("An optional field, indicating the manner to align multiple variables.")
model AlignPolicy {
  @doc("""
An optional field, indicating how we align different variables to the same
time-range. Either Inner or Outer. 
""")
  alignMode?: AlignMode;

  @doc("""
An optional field, indicating how missing values will be filled. One of
Previous, Subsequent, Linear, Zero, Fixed, and NotFill. Cannot be set to
NotFill, when the alignMode is Outer.
""")
  fillNAMethod?: FillNAMethod;

  @doc("An optional field. Required when fillNAMethod is Fixed.")
  paddingValue?: float32;
}

@doc("Diagnostics Information for inspecting model/variable states.")
model DiagnosticsInfo {
  modelState?: ModelState;
  variableStates?: VariableState[];
}

model ModelState {
  @doc("Epoch id")
  epochIds?: int32[];
  trainLosses?: float32[];
  validationLosses?: float32[];
  latenciesInSeconds?: float32[];
}

@doc("Response of listing models.")
@pagedResult
model ModelList {
  @doc("List of models")
  @items
  models: ModelSnapshot[];

  @doc("Current count of trained multivariate models.")
  currentCount: int32;

  @doc("Max number of models that can be trained for this subscription.")
  maxCount: int32;

  @doc("The link to fetch more models.")
  @nextLink
  nextLink?: string;
}

@resource("multivariate/models")
model ModelSnapshot {
  @doc("Model identifier.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  modelId: string;

  @doc("Date and time (UTC) when the model was created.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdTime: utcDateTime;

  @doc("Date and time (UTC) when the model was last updated.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdatedTime: utcDateTime;

  @doc("Model status. One of CREATED, RUNNING, READY, and FAILED.")
  status: ModelStatus;
  displayName?: string;

  @doc("Total number of variables.")
  variablesCount: int32;
}

@doc("Response of getting a model.")
@resource("multivariate/models/{modelId}")
model Model {
  @doc("Model identifier.")
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  modelId: string;

  @doc("Date and time (UTC) when the model was created.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdTime: utcDateTime;

  @doc("Date and time (UTC) when the model was last updated.")
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdatedTime: utcDateTime;

  @doc("""
Training result of a model including its status, errors and diagnostics
information.
""")
  modelInfo?: ModelInfo;
}

model LastDetectionRequest {
  @doc("variables")
  variables: VariableValues[];

  @doc("Top contributor count.")
  topContributorCount: int32;
}

model VariableValues {
  @doc("variable name")
  name: string;

  @doc("timestamps")
  timestamps: string[];

  @doc("values")
  values: float32[];
}

model LastDetectionResult {
  variableStates?: VariableState[];
  results?: AnomalyState[];
}
