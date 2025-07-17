import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using AnomalyDetectorClient;

@@clientName(detectEntireSeries, "DetectEntireSeries");
@@clientName(detectLastPoint, "DetectLastPoint");
@@clientName(detectChangePoint, "DetectChangePoint");
@@clientName(getDetectionResult, "GetDetectionResult");
@@clientName(trainMultivariateModel, "TrainMultivariateModel");
@@clientName(listMultivariateModel, "ListMultivariateModel");
@@clientName(deleteMultivariateModel, "DeleteMultivariateModel");
@@clientName(getMultivariateModel, "GetMultivariateModel");
@@clientName(detectAnomaly, "DetectAnomaly");
@@clientName(lastDetectAnomaly, "LastDetectAnomaly");
