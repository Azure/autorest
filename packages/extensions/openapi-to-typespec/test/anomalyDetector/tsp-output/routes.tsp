import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AnomalyDetectorClient;

/**
 * This operation generates a model with an entire series, each point is detected
 * with the same model. With this method, points before and after a certain point
 * are used to determine whether it is an anomaly. The entire detection can give
 * user an overall status of the time series.
 */
@summary("Detect anomalies for the entire series in batch.")
@route("/timeseries/entire/detect")
@post
op detectEntireSeries is Azure.Core.Foundations.Operation<
  DetectRequest,
  EntireDetectResponse
>;

/**
 * This operation generates a model using points before the latest one. With this
 * method, only historical points are used to determine whether the target point
 * is an anomaly. The latest point detecting operation matches the scenario of
 * real-time monitoring of business metrics.
 */
@summary("Detect anomaly status of the latest point in time series.")
@route("/timeseries/last/detect")
@post
op detectLastPoint is Azure.Core.Foundations.Operation<
  DetectRequest,
  LastDetectResponse
>;

/**
 * Evaluate change point score of every series point
 */
@summary("Detect change point for the entire series")
@route("/timeseries/changepoint/detect")
@post
op detectChangePoint is Azure.Core.Foundations.Operation<
  ChangePointDetectRequest,
  ChangePointDetectResponse
>;

/**
 * Get multivariate anomaly detection result based on resultId returned by the
 * DetectAnomalyAsync api
 */
@summary("Get Multivariate Anomaly Detection Result")
op getDetectionResult is Azure.Core.ResourceRead<DetectionResult>;

/**
 * Create and train a multivariate anomaly detection model. The request must
 * include a source parameter to indicate an externally accessible Azure storage
 * Uri (preferably a Shared Access Signature Uri). All time-series used in
 * generate the model must be zipped into one single file. Each time-series will
 * be in a single CSV file in which the first column is timestamp and the second
 * column is value.
 */
@summary("Train a Multivariate Anomaly Detection Model")
@route("/multivariate/models")
@post
op trainMultivariateModel is Azure.Core.Foundations.Operation<ModelInfo, void>;

/**
 * List models of a subscription
 */
@summary("List Multivariate Models")
op listMultivariateModel is Azure.Core.ResourceList<
  ModelSnapshot,
  {
    parameters: {
      /**
       * $skip indicates how many models will be skipped.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * $top indicates how many models will be fetched.
       */
      @query("$top")
      $top?: int32 = 10;
    };
  }
>;

/**
 * Delete an existing multivariate model according to the modelId
 */
@summary("Delete Multivariate Model")
@route("/multivariate/models/{modelId}")
@delete
op deleteMultivariateModel is Azure.Core.Foundations.Operation<
  {
    /**
     * Model identifier
     */
    @path
    modelId: string;
  },
  void
>;

/**
 * Get detailed information of multivariate model, including the training status
 * and variables used in the model.
 */
@summary("Get Multivariate Model")
op getMultivariateModel is Azure.Core.ResourceRead<Model>;

/**
 * Submit detection multivariate anomaly task with the trained model of modelId,
 * the input schema should be the same with the training request. Thus request
 * will be complete asynchronously and will return a resultId for querying the
 * detection result.The request should be a source link to indicate an externally
 * accessible Azure storage Uri (preferably a Shared Access Signature Uri). All
 * time-series used in generate the model must be zipped into one single file.
 * Each time-series will be as follows: the first column is timestamp and the
 * second column is value.
 */
@summary("Detect Multivariate Anomaly")
@route("/multivariate/models/{modelId}/entire/detect")
@post
op detectAnomaly is Azure.Core.Foundations.Operation<
  {
    /**
     * Model identifier
     */
    @path
    modelId: string;

    /**
     * Detect anomaly request
     */
    @body
    body: DetectionRequest;
  },
  void
>;

/**
 * Synchronized API for anomaly detection.
 */
@summary("Detect anomalies in the last a few points of the request body")
@route("/multivariate/models/{modelId}/last/detect")
@post
op lastDetectAnomaly is Azure.Core.Foundations.Operation<
  {
    /**
     * Model identifier
     */
    @path
    modelId: string;

    /**
     * Request for last detection
     */
    @body
    body: LastDetectionRequest;
  },
  LastDetectionResult
>;
