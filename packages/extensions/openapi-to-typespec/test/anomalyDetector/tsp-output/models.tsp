import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace AnomalyDetectorClient;

/**
 * Anomaly Detector API version (for example, v1.0).
 */
enum ApiVersion {
  `v1.1-preview.1`,
}

/**
 * Define the impute method, can be one of auto, previous, linear, fixed, zero,
 * notFill.
 */
enum ImputeMode {
  auto,
  previous,
  linear,
  fixed,
  zero,
  notFill,
}

/**
 * The error code.
 */
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

/**
 * An optional field, indicating how missing values will be filled. One of
 * Previous, Subsequent, Linear, Zero, Fixed, and NotFill. Cannot be set to
 * NotFill, when the alignMode is Outer.
 */
enum FillNAMethod {
  Previous,
  Subsequent,
  Linear,
  Zero,
  Fixed,
  NotFill,
}

/**
 * Optional argument, can be one of yearly, monthly, weekly, daily, hourly,
 * minutely, secondly, microsecond or none. If granularity is not present, it will
 * be none by default. If granularity is none, the timestamp property in time
 * series point can be absent.
 */
@fixed
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

/**
 * Status of detection results. One of CREATED, RUNNING, READY, and FAILED.
 */
@fixed
enum DetectionStatus {
  CREATED,
  RUNNING,
  READY,
  FAILED,
}

@fixed
enum DataSchema {
  OneTable,
  MultiTable,
}

/**
 * An optional field, indicating how we align different variables to the same
 * time-range. Either Inner or Outer.
 */
@fixed
enum AlignMode {
  Inner,
  Outer,
}

/**
 * Model status. One of CREATED, RUNNING, READY, and FAILED.
 */
@fixed
enum ModelStatus {
  CREATED,
  RUNNING,
  READY,
  FAILED,
}

/**
 * The request of entire or last anomaly detection.
 */
model DetectRequest {
  /**
   * Time series data points. Points should be sorted by timestamp in ascending
   * order to match the anomaly detection result. If the data is not sorted
   * correctly or there is duplicated timestamp, the API will not work. In such
   * case, an error message will be returned.
   */
  series: TimeSeriesPoint[];

  /**
   * Optional argument, can be one of yearly, monthly, weekly, daily, hourly,
   * minutely, secondly, microsecond or none. If granularity is not present, it will
   * be none by default. If granularity is none, the timestamp property in time
   * series point can be absent.
   */
  granularity?: TimeGranularity;

  /**
   * Custom Interval is used to set non-standard time interval, for example, if the
   * series is 5 minutes, request can be set as {"granularity":"minutely",
   * "customInterval":5}.
   */
  customInterval?: int32;

  /**
   * Optional argument, periodic value of a time series. If the value is null or
   * does not present, the API will determine the period automatically.
   */
  period?: int32;

  /**
   * Optional argument, advanced model parameter, max anomaly ratio in a time series.
   */
  maxAnomalyRatio?: float32;

  /**
   * Optional argument, advanced model parameter, between 0-99, the lower the value
   * is, the larger the margin value will be which means less anomalies will be
   * accepted.
   */
  sensitivity?: int32;

  /**
   * Used to specify how to deal with missing values in the input series, it's used
   * when granularity is not "none".
   */
  imputeMode?: ImputeMode;

  /**
   * Used to specify the value to fill, it's used when granularity is not "none" and
   * imputeMode is "fixed".
   */
  imputeFixedValue?: float32;
}

/**
 * The definition of input timeseries points.
 */
model TimeSeriesPoint {
  /**
   * Optional argument, timestamp of a data point (ISO8601 format).
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp?: utcDateTime;

  /**
   * The measurement of that point, should be float.
   */
  value: float32;
}

/**
 * The response of entire anomaly detection.
 */
model EntireDetectResponse {
  /**
   * Frequency extracted from the series, zero means no recurrent pattern has been
   * found.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  period: int32;

  /**
   * ExpectedValues contain expected value for each input point. The index of the
   * array is consistent with the input series.
   */
  expectedValues: float32[];

  /**
   * UpperMargins contain upper margin of each input point. UpperMargin is used to
   * calculate upperBoundary, which equals to expectedValue + (100 -
   * marginScale)*upperMargin. Anomalies in response can be filtered by
   * upperBoundary and lowerBoundary. By adjusting marginScale value, less
   * significant anomalies can be filtered in client side. The index of the array is
   * consistent with the input series.
   */
  upperMargins: float32[];

  /**
   * LowerMargins contain lower margin of each input point. LowerMargin is used to
   * calculate lowerBoundary, which equals to expectedValue - (100 -
   * marginScale)*lowerMargin. Points between the boundary can be marked as normal
   * ones in client side. The index of the array is consistent with the input
   * series.
   */
  lowerMargins: float32[];

  /**
   * IsAnomaly contains anomaly properties for each input point. True means an
   * anomaly either negative or positive has been detected. The index of the array
   * is consistent with the input series.
   */
  isAnomaly: boolean[];

  /**
   * IsNegativeAnomaly contains anomaly status in negative direction for each input
   * point. True means a negative anomaly has been detected. A negative anomaly
   * means the point is detected as an anomaly and its real value is smaller than
   * the expected one. The index of the array is consistent with the input series.
   */
  isNegativeAnomaly: boolean[];

  /**
   * IsPositiveAnomaly contain anomaly status in positive direction for each input
   * point. True means a positive anomaly has been detected. A positive anomaly
   * means the point is detected as an anomaly and its real value is larger than the
   * expected one. The index of the array is consistent with the input series.
   */
  isPositiveAnomaly: boolean[];

  /**
   * The severity score for each input point. The larger the value is, the more
   * sever the anomaly is. For normal points, the "severity" is always 0.
   */
  severity?: float32[];
}

/**
 * Error information returned by the API.
 */
@error
model AnomalyDetectorError {
  /**
   * The error code.
   */
  code?: AnomalyDetectorErrorCodes;

  /**
   * A message explaining the error reported by the service.
   */
  message?: string;
}

/**
 * The response of last anomaly detection.
 */
model LastDetectResponse {
  /**
   * Frequency extracted from the series, zero means no recurrent pattern has been
   * found.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  period: int32;

  /**
   * Suggested input series points needed for detecting the latest point.
   */
  suggestedWindow: int32;

  /**
   * Expected value of the latest point.
   */
  expectedValue: float32;

  /**
   * Upper margin of the latest point. UpperMargin is used to calculate
   * upperBoundary, which equals to expectedValue + (100 - marginScale)*upperMargin.
   * If the value of latest point is between upperBoundary and lowerBoundary, it
   * should be treated as normal value. By adjusting marginScale value, anomaly
   * status of latest point can be changed.
   */
  upperMargin: float32;

  /**
   * Lower margin of the latest point. LowerMargin is used to calculate
   * lowerBoundary, which equals to expectedValue - (100 - marginScale)*lowerMargin.
   *
   */
  lowerMargin: float32;

  /**
   * Anomaly status of the latest point, true means the latest point is an anomaly
   * either in negative direction or positive direction.
   */
  isAnomaly: boolean;

  /**
   * Anomaly status in negative direction of the latest point. True means the latest
   * point is an anomaly and its real value is smaller than the expected one.
   */
  isNegativeAnomaly: boolean;

  /**
   * Anomaly status in positive direction of the latest point. True means the latest
   * point is an anomaly and its real value is larger than the expected one.
   */
  isPositiveAnomaly: boolean;

  /**
   * The severity score for the last input point. The larger the value is, the more
   * sever the anomaly is. For normal points, the "severity" is always 0.
   */
  severity?: float32;
}

/**
 * The request of change point detection.
 */
model ChangePointDetectRequest {
  /**
   * Time series data points. Points should be sorted by timestamp in ascending
   * order to match the change point detection result.
   */
  series: TimeSeriesPoint[];

  /**
   * Can only be one of yearly, monthly, weekly, daily, hourly, minutely or
   * secondly. Granularity is used for verify whether input series is valid.
   */
  granularity: TimeGranularity;

  /**
   * Custom Interval is used to set non-standard time interval, for example, if the
   * series is 5 minutes, request can be set as {"granularity":"minutely",
   * "customInterval":5}.
   */
  customInterval?: int32;

  /**
   * Optional argument, periodic value of a time series. If the value is null or
   * does not present, the API will determine the period automatically.
   */
  period?: int32;

  /**
   * Optional argument, advanced model parameter, a default stableTrendWindow will
   * be used in detection.
   */
  stableTrendWindow?: int32;

  /**
   * Optional argument, advanced model parameter, between 0.0-1.0, the lower the
   * value is, the larger the trend error will be which means less change point will
   * be accepted.
   */
  threshold?: float32;
}

/**
 * The response of change point detection.
 */
model ChangePointDetectResponse {
  /**
   * Frequency extracted from the series, zero means no recurrent pattern has been
   * found.
   */
  @visibility("read")
  period?: int32;

  /**
   * isChangePoint contains change point properties for each input point. True means
   * an anomaly either negative or positive has been detected. The index of the
   * array is consistent with the input series.
   */
  isChangePoint?: boolean[];

  /**
   * the change point confidence of each point
   */
  confidenceScores?: float32[];
}

/**
 * Detection results for the given resultId.
 */
@resource("multivariate/entire/detect/{resultId}")
model DetectionResult {
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  resultId: string;

  /**
   * Multivariate anomaly detection status.
   */
  summary: DetectionResultSummary;

  /**
   * Detection result for each timestamp.
   */
  results: AnomalyState[];
}

/**
 * Multivariate anomaly detection status.
 */
model DetectionResultSummary {
  /**
   * Status of detection results. One of CREATED, RUNNING, READY, and FAILED.
   */
  status: DetectionStatus;

  /**
   * Error message when detection is failed.
   */
  errors?: ErrorResponse[];

  variableStates?: VariableState[];

  /**
   * Detection request.
   */
  setupInfo: DetectionRequest;
}

@error
model ErrorResponse {
  /**
   * The error code.
   */
  code: string;

  /**
   * The message explaining the error reported by the service.
   */
  message: string;
}

model VariableState {
  /**
   * Variable name.
   */
  variable?: string;

  /**
   * Proportion of NaN values filled of the variable.
   */
  @maxValue(1)
  filledNARatio?: float32;

  /**
   * Number of effective points counted.
   */
  effectiveCount?: int32;

  /**
   * First timestamp of the variable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  firstTimestamp?: utcDateTime;

  /**
   * Last timestamp of the variable.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastTimestamp?: utcDateTime;
}

/**
 * Detection request.
 */
model DetectionRequest {
  /**
   * Source link to the input variables. Each variable should be a csv with two
   * columns, `timestamp` and `value`. The file name of the variable will be used as
   * its name. The variables used in detection should be exactly the same with those
   * used in the training phase.
   */
  dataSource: string;

  /**
   * Top contributor count.
   */
  topContributorCount: int32;

  /**
   * A required field, indicating the start time of data for detection. Should be
   * date-time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  /**
   * A required field, indicating the end time of data for detection. Should be
   * date-time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime: utcDateTime;
}

model AnomalyState {
  /**
   * timestamp
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  timestamp: utcDateTime;

  value?: AnomalyValue;

  /**
   * Error message for the current timestamp
   */
  errors?: ErrorResponse[];
}

model AnomalyValue {
  /**
   * True if an anomaly is detected at the current timestamp.
   */
  isAnomaly: boolean;

  /**
   * Indicates the significance of the anomaly. The higher the severity, the more
   * significant the anomaly.
   */
  @maxValue(1)
  severity: float32;

  /**
   * Raw score from the model.
   */
  @maxValue(2)
  score: float32;

  interpretation?: AnomalyInterpretation[];
}

model AnomalyInterpretation {
  variable?: string;
  contributionScore?: float32;
  correlationChanges?: CorrelationChanges;
}

model CorrelationChanges {
  /**
   * correlated variables
   */
  changedVariables?: string[];
}

/**
 * Training result of a model including its status, errors and diagnostics
 * information.
 */
model ModelInfo {
  /**
   * Source link to the input variables. Each variable should be a csv file with two
   * columns, `timestamp` and `value`. By default, the file name of the variable
   * will be used as its variable name.
   */
  dataSource: string;

  dataSchema?: DataSchema;

  /**
   * A required field, indicating the start time of training data. Should be
   * date-time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  startTime: utcDateTime;

  /**
   * A required field, indicating the end time of training data. Should be date-time.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  endTime: utcDateTime;

  /**
   * An optional field. The name of the model whose maximum length is 24.
   */
  @maxLength(24)
  displayName?: string;

  /**
   * An optional field, indicating how many previous points will be used to compute
   * the anomaly score of the subsequent point.
   */
  slidingWindow?: int32;

  /**
   * An optional field, indicating the manner to align multiple variables.
   */
  alignPolicy?: AlignPolicy;

  /**
   * Model status. One of CREATED, RUNNING, READY, and FAILED.
   */
  status?: ModelStatus;

  /**
   * Error messages when failed to create a model.
   */
  errors?: ErrorResponse[];

  /**
   * Diagnostics Information for inspecting model/variable states.
   */
  diagnosticsInfo?: DiagnosticsInfo;
}

/**
 * An optional field, indicating the manner to align multiple variables.
 */
model AlignPolicy {
  /**
   * An optional field, indicating how we align different variables to the same
   * time-range. Either Inner or Outer.
   */
  alignMode?: AlignMode;

  /**
   * An optional field, indicating how missing values will be filled. One of
   * Previous, Subsequent, Linear, Zero, Fixed, and NotFill. Cannot be set to
   * NotFill, when the alignMode is Outer.
   */
  fillNAMethod?: FillNAMethod;

  /**
   * An optional field. Required when fillNAMethod is Fixed.
   */
  paddingValue?: float32;
}

/**
 * Diagnostics Information for inspecting model/variable states.
 */
model DiagnosticsInfo {
  modelState?: ModelState;
  variableStates?: VariableState[];
}

model ModelState {
  /**
   * Epoch id
   */
  epochIds?: int32[];

  trainLosses?: float32[];
  validationLosses?: float32[];
  latenciesInSeconds?: float32[];
}

/**
 * Response of listing models.
 */
@pagedResult
model ModelList {
  /**
   * List of models
   */
  @items
  models: ModelSnapshot[];

  /**
   * Current count of trained multivariate models.
   */
  currentCount: int32;

  /**
   * Max number of models that can be trained for this subscription.
   */
  maxCount: int32;

  /**
   * The link to fetch more models.
   */
  @nextLink
  nextLink?: string;
}

@resource("multivariate/models")
model ModelSnapshot {
  /**
   * Model identifier.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  modelId: string;

  /**
   * Date and time (UTC) when the model was created.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdTime: utcDateTime;

  /**
   * Date and time (UTC) when the model was last updated.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdatedTime: utcDateTime;

  /**
   * Model status. One of CREATED, RUNNING, READY, and FAILED.
   */
  status: ModelStatus;

  displayName?: string;

  /**
   * Total number of variables.
   */
  variablesCount: int32;
}

/**
 * Response of getting a model.
 */
@resource("multivariate/models/{modelId}")
model Model {
  /**
   * Model identifier.
   */
  // FIXME: (resource-key-guessing) - Verify that this property is the resource key, if not please update the model with the right one
  @key
  modelId: string;

  /**
   * Date and time (UTC) when the model was created.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  createdTime: utcDateTime;

  /**
   * Date and time (UTC) when the model was last updated.
   */
  // FIXME: (utcDateTime) Please double check that this is the correct type for your scenario.
  lastUpdatedTime: utcDateTime;

  /**
   * Training result of a model including its status, errors and diagnostics
   * information.
   */
  modelInfo?: ModelInfo;
}

model LastDetectionRequest {
  /**
   * variables
   */
  variables: VariableValues[];

  /**
   * Top contributor count.
   */
  topContributorCount: int32;
}

model VariableValues {
  /**
   * variable name
   */
  name: string;

  /**
   * timestamps
   */
  timestamps: string[];

  /**
   * values
   */
  values: float32[];
}

model LastDetectionResult {
  variableStates?: VariableState[];
  results?: AnomalyState[];
}
