import "./main.tsp";

using Azure.LoadTesting;

@@clientLocation(LoadTestAdministrationOperationGroup.createOrUpdateTest,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.deleteTest,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.getTest,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.listTests,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.uploadTestFile,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.getTestFile,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.deleteTestFile,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.listTestFiles,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.createOrUpdateAppComponents,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.getAppComponents,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.createOrUpdateServerMetricsConfig,
  "LoadTestAdministration"
);
@@clientLocation(LoadTestAdministrationOperationGroup.getServerMetricsConfig,
  "LoadTestAdministration"
);

@@clientLocation(LoadTestRunOperationGroup.createOrUpdateTestRun,
  "LoadTestRun"
);
@@clientLocation(LoadTestRunOperationGroup.getTestRun, "LoadTestRun");
@@clientLocation(LoadTestRunOperationGroup.deleteTestRun, "LoadTestRun");
@@clientLocation(LoadTestRunOperationGroup.getTestRunFile, "LoadTestRun");
@@clientLocation(LoadTestRunOperationGroup.listTestRuns, "LoadTestRun");
@@clientLocation(LoadTestRunOperationGroup.stopTestRun, "LoadTestRun");
@@clientLocation(LoadTestRunOperationGroup.listMetricNamespaces, "LoadTestRun");
@@clientLocation(LoadTestRunOperationGroup.listMetricDefinitions,
  "LoadTestRun"
);
@@clientLocation(LoadTestRunOperationGroup.listMetrics, "LoadTestRun");
@@clientLocation(LoadTestRunOperationGroup.listMetricDimensionValues,
  "LoadTestRun"
);
@@clientLocation(LoadTestRunOperationGroup.createOrUpdateAppComponents,
  "LoadTestRun"
);
@@clientLocation(LoadTestRunOperationGroup.getAppComponents, "LoadTestRun");
@@clientLocation(LoadTestRunOperationGroup.createOrUpdateServerMetricsConfig,
  "LoadTestRun"
);
@@clientLocation(LoadTestRunOperationGroup.getServerMetricsConfig,
  "LoadTestRun"
);
