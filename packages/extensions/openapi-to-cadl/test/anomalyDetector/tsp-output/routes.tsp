import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AnomalyDetectorClient;

@summary("Detect anomalies for the entire series in batch.")
@doc("""
This operation generates a model with an entire series, each point is detected
with the same model. With this method, points before and after a certain point
are used to determine whether it is an anomaly. The entire detection can give
user an overall status of the time series.
""")
@route("/timeseries/entire/detect")
@post
op DetectEntireSeries is Azure.Core.Foundations.Operation<
  {
    @doc("""
Time series points and period if needed. Advanced model parameters can also be
set in the request.
""")
    @body
    body: DetectRequest;
  },
  EntireDetectResponse
>;

@summary("Detect anomaly status of the latest point in time series.")
@doc("""
This operation generates a model using points before the latest one. With this
method, only historical points are used to determine whether the target point
is an anomaly. The latest point detecting operation matches the scenario of
real-time monitoring of business metrics.
""")
@route("/timeseries/last/detect")
@post
op DetectLastPoint is Azure.Core.Foundations.Operation<
  {
    @doc("""
Time series points and period if needed. Advanced model parameters can also be
set in the request.
""")
    @body
    body: DetectRequest;
  },
  LastDetectResponse
>;

@summary("Detect change point for the entire series")
@doc("Evaluate change point score of every series point")
@route("/timeseries/changepoint/detect")
@post
op DetectChangePoint is Azure.Core.Foundations.Operation<
  {
    @doc("""
Time series points and granularity is needed. Advanced model parameters can
also be set in the request if needed.
""")
    @body
    body: ChangePointDetectRequest;
  },
  ChangePointDetectResponse
>;

@summary("Get Multivariate Anomaly Detection Result")
@doc("""
Get multivariate anomaly detection result based on resultId returned by the
DetectAnomalyAsync api
""")
op GetDetectionResult is Azure.Core.ResourceRead<DetectionResult>;

@summary("Train a Multivariate Anomaly Detection Model")
@doc("""
Create and train a multivariate anomaly detection model. The request must
include a source parameter to indicate an externally accessible Azure storage
Uri (preferably a Shared Access Signature Uri). All time-series used in
generate the model must be zipped into one single file. Each time-series will
be in a single CSV file in which the first column is timestamp and the second
column is value.
""")
@route("/multivariate/models")
@post
op TrainMultivariateModel is Azure.Core.Foundations.Operation<
  {
    @doc("Training request")
    @body
    body: ModelInfo;
  },
  void
>;

@summary("List Multivariate Models")
@doc("List models of a subscription")
op ListMultivariateModel is Azure.Core.ResourceList<
  ModelSnapshot,
  {
    parameters: {
      @doc("$skip indicates how many models will be skipped.")
      @query
      $skip: int32;

      @doc("$top indicates how many models will be fetched.")
      @query
      $top: int32;
    };
  }
>;

@summary("Delete Multivariate Model")
@doc("Delete an existing multivariate model according to the modelId")
@route("/multivariate/models/{modelId}")
@delete
op DeleteMultivariateModel is Azure.Core.Foundations.Operation<
  {
    @doc("Model identifier")
    @path
    modelId: string;
  },
  void
>;

@summary("Get Multivariate Model")
@doc("""
Get detailed information of multivariate model, including the training status
and variables used in the model.
""")
op GetMultivariateModel is Azure.Core.ResourceRead<Model>;

@summary("Detect Multivariate Anomaly")
@doc("""
Submit detection multivariate anomaly task with the trained model of modelId,
the input schema should be the same with the training request. Thus request
will be complete asynchronously and will return a resultId for querying the
detection result.The request should be a source link to indicate an externally
accessible Azure storage Uri (preferably a Shared Access Signature Uri). All
time-series used in generate the model must be zipped into one single file.
Each time-series will be as follows: the first column is timestamp and the
second column is value.
""")
@route("/multivariate/models/{modelId}/entire/detect")
@post
op DetectAnomaly is Azure.Core.Foundations.Operation<
  {
    @doc("Model identifier")
    @path
    modelId: string;

    @doc("Detect anomaly request")
    @body
    body: DetectionRequest;
  },
  void
>;

@summary("Detect anomalies in the last a few points of the request body")
@doc("Synchronized API for anomaly detection.")
@route("/multivariate/models/{modelId}/last/detect")
@post
op LastDetectAnomaly is Azure.Core.Foundations.Operation<
  {
    @doc("Model identifier")
    @path
    modelId: string;

    @doc("Request for last detection")
    @body
    body: LastDetectionRequest;
  },
  LastDetectionResult
>;
