import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.LoadTesting;

@@clientLocation(LoadTestAdministrationOperationGroup.createOrUpdateTest,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.createOrUpdateTest,
  "CreateOrUpdateTest"
);
@@clientLocation(LoadTestAdministrationOperationGroup.deleteTest,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.deleteTest, "DeleteTest");
@@clientLocation(LoadTestAdministrationOperationGroup.getTest,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.getTest, "GetTest");
@@clientLocation(LoadTestAdministrationOperationGroup.listTests,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.listTests, "ListTests");
@@clientLocation(LoadTestAdministrationOperationGroup.uploadTestFile,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.uploadTestFile,
  "UploadTestFile"
);
@@clientLocation(LoadTestAdministrationOperationGroup.getTestFile,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.getTestFile, "GetTestFile");
@@clientLocation(LoadTestAdministrationOperationGroup.deleteTestFile,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.deleteTestFile,
  "DeleteTestFile"
);
@@clientLocation(LoadTestAdministrationOperationGroup.listTestFiles,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.listTestFiles,
  "ListTestFiles"
);
@@clientLocation(LoadTestAdministrationOperationGroup.createOrUpdateAppComponents,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.createOrUpdateAppComponents,
  "CreateOrUpdateAppComponents"
);
@@clientLocation(LoadTestAdministrationOperationGroup.getAppComponents,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.getAppComponents,
  "GetAppComponents"
);
@@clientLocation(LoadTestAdministrationOperationGroup.createOrUpdateServerMetricsConfig,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.createOrUpdateServerMetricsConfig,
  "CreateOrUpdateServerMetricsConfig"
);
@@clientLocation(LoadTestAdministrationOperationGroup.getServerMetricsConfig,
  "LoadTestAdministration"
);
@@clientName(LoadTestAdministrationOperationGroup.getServerMetricsConfig,
  "GetServerMetricsConfig"
);

@@clientLocation(LoadTestRunOperationGroup.createOrUpdateTestRun,
  "LoadTestRun"
);
@@clientName(LoadTestRunOperationGroup.createOrUpdateTestRun,
  "CreateOrUpdateTestRun"
);
@@clientLocation(LoadTestRunOperationGroup.getTestRun, "LoadTestRun");
@@clientName(LoadTestRunOperationGroup.getTestRun, "GetTestRun");
@@clientLocation(LoadTestRunOperationGroup.deleteTestRun, "LoadTestRun");
@@clientName(LoadTestRunOperationGroup.deleteTestRun, "DeleteTestRun");
@@clientLocation(LoadTestRunOperationGroup.getTestRunFile, "LoadTestRun");
@@clientName(LoadTestRunOperationGroup.getTestRunFile, "GetTestRunFile");
@@clientLocation(LoadTestRunOperationGroup.listTestRuns, "LoadTestRun");
@@clientName(LoadTestRunOperationGroup.listTestRuns, "ListTestRuns");
@@clientLocation(LoadTestRunOperationGroup.stopTestRun, "LoadTestRun");
@@clientName(LoadTestRunOperationGroup.stopTestRun, "StopTestRun");
@@clientLocation(LoadTestRunOperationGroup.listMetricNamespaces, "LoadTestRun");
@@clientName(LoadTestRunOperationGroup.listMetricNamespaces,
  "ListMetricNamespaces"
);
@@clientLocation(LoadTestRunOperationGroup.listMetricDefinitions,
  "LoadTestRun"
);
@@clientName(LoadTestRunOperationGroup.listMetricDefinitions,
  "ListMetricDefinitions"
);
@@clientLocation(LoadTestRunOperationGroup.listMetrics, "LoadTestRun");
@@clientName(LoadTestRunOperationGroup.listMetrics, "ListMetrics");
@@clientLocation(LoadTestRunOperationGroup.listMetricDimensionValues,
  "LoadTestRun"
);
@@clientName(LoadTestRunOperationGroup.listMetricDimensionValues,
  "ListMetricDimensionValues"
);
@@clientLocation(LoadTestRunOperationGroup.createOrUpdateAppComponents,
  "LoadTestRun"
);
@@clientName(LoadTestRunOperationGroup.createOrUpdateAppComponents,
  "CreateOrUpdateAppComponents"
);
@@clientLocation(LoadTestRunOperationGroup.getAppComponents, "LoadTestRun");
@@clientName(LoadTestRunOperationGroup.getAppComponents, "GetAppComponents");
@@clientLocation(LoadTestRunOperationGroup.createOrUpdateServerMetricsConfig,
  "LoadTestRun"
);
@@clientName(LoadTestRunOperationGroup.createOrUpdateServerMetricsConfig,
  "CreateOrUpdateServerMetricsConfig"
);
@@clientLocation(LoadTestRunOperationGroup.getServerMetricsConfig,
  "LoadTestRun"
);
@@clientName(LoadTestRunOperationGroup.getServerMetricsConfig,
  "GetServerMetricsConfig"
);
