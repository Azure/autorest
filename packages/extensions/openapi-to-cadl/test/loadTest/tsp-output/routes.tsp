import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.LoadTesting;

interface LoadTestAdministrationOperations {
  @summary("Create a new test or update an existing test.")
  @doc("Create a new test or update an existing test.")
  @route("/tests/{testId}")
  @patch
  CreateOrUpdateTest is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;

      @doc("Load test model")
      @body
      body: Test;
    },
    Test
  >;

  @summary("Delete a test by its name.")
  @doc("Delete a test by its name.")
  @route("/tests/{testId}")
  @delete
  DeleteTest is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;
    },
    void
  >;

  @summary("Get load test details by test name")
  @doc("Get load test details by test name")
  @route("/tests/{testId}")
  @get
  GetTest is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;
    },
    Test
  >;

  @summary("""
Get all load tests by the fully qualified resource Id e.g
subscriptions/{subId}/resourceGroups/{rg}/providers/Microsoft.LoadTestService/loadtests/{resName}.
""")
  @doc("""
Get all load tests by the fully qualified resource Id e.g
subscriptions/{subId}/resourceGroups/{rg}/providers/Microsoft.LoadTestService/loadtests/{resName}.
""")
  @route("/tests")
  @get
  ListTests is Azure.Core.Foundations.Operation<
    {
      @doc("""
Sort on the supported fields in (field asc/desc) format. eg:
lastModifiedDateTime asc. Supported fields - lastModifiedDateTime
""")
      @query
      orderby: string;

      @doc("""
Prefix based, case sensitive search on searchable fields - displayName,
createdBy. For example, to search for a test, with display name is Login Test,
the search parameter can be Login.
""")
      @query
      search: string;

      @doc("""
Start DateTime(ISO 8601 literal format) of the last updated time range to
filter tests.
""")
      @query
      lastModifiedStartTime: utcDateTime;

      @doc("""
End DateTime(ISO 8601 literal format) of the last updated time range to filter
tests.
""")
      @query
      lastModifiedEndTime: utcDateTime;

      @doc("Number of results in response.")
      @query
      maxpagesize: int32;
    },
    TestsList
  >;

  @summary("""
Upload input file for a given test name. File size can't be more than 50 MB.
Existing file with same name for the given test will be overwritten. File
should be provided in the request body as application/octet-stream.
""")
  @doc("""
Upload input file for a given test name. File size can't be more than 50 MB.
Existing file with same name for the given test will be overwritten. File
should be provided in the request body as application/octet-stream.
""")
  @route("/tests/{testId}/files/{fileName}")
  @put
  UploadTestFile is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;

      @doc("Unique name for test file with file extension like : App.jmx")
      @path
      fileName: string;

      @doc("File type")
      @query
      fileType: FileType;

      @doc("The file content as application/octet-stream.")
      @body
      body: bytes;
    },
    FileInfo
  >;

  @summary("Get test file by the file name.")
  @doc("Get test file by the file name.")
  @route("/tests/{testId}/files/{fileName}")
  @get
  GetTestFile is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;

      @doc("File name with file extension like app.jmx")
      @path
      fileName: string;
    },
    FileInfo
  >;

  @summary("Delete file by the file name for a test")
  @doc("Delete file by the file name for a test")
  @route("/tests/{testId}/files/{fileName}")
  @delete
  DeleteTestFile is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;

      @doc("File name with file extension like app.jmx")
      @path
      fileName: string;
    },
    void
  >;

  @summary("Get all test files.")
  @doc("Get all test files.")
  @route("/tests/{testId}/files")
  @get
  ListTestFiles is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;
    },
    FileInfoList
  >;

  @summary("Associate an app component (collection of azure resources) to a test")
  @doc("Associate an app component (collection of azure resources) to a test")
  @route("/tests/{testId}/app-components")
  @patch
  CreateOrUpdateAppComponents is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;

      @doc("App Component model.")
      @body
      body: TestAppComponents;
    },
    TestAppComponents
  >;

  @summary("Get associated app component (collection of azure resources) for the given test.")
  @doc("Get associated app component (collection of azure resources) for the given test.")
  @route("/tests/{testId}/app-components")
  @get
  GetAppComponents is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;
    },
    TestAppComponents
  >;

  @summary("Configure server metrics for a test")
  @doc("Configure server metrics for a test")
  @route("/tests/{testId}/server-metrics-config")
  @patch
  CreateOrUpdateServerMetricsConfig is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;

      @doc("Server metric configuration model.")
      @body
      body: TestServerMetricConfig;
    },
    TestServerMetricConfig
  >;

  @summary("List server metrics configuration for the given test.")
  @doc("List server metrics configuration for the given test.")
  @route("/tests/{testId}/server-metrics-config")
  @get
  GetServerMetricsConfig is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testId: string;
    },
    TestServerMetricConfig
  >;
}

interface LoadTestRunOperations {
  @summary("Create and start a new test run with the given name.")
  @doc("Create and start a new test run with the given name.")
  @route("/test-runs/{testRunId}")
  @patch
  CreateOrUpdateTestRun is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;

      @doc("""
Existing test run identifier that should be rerun, if this is provided, the
test will run with the JMX file, configuration and app components from the
existing test run. You can override the configuration values for new test run
in the request body.
""")
      @query
      oldTestRunId: string;

      @doc("Load test run model")
      @body
      body: TestRun;
    },
    TestRun
  >;

  @summary("Get test run details by name.")
  @doc("Get test run details by name.")
  @route("/test-runs/{testRunId}")
  @get
  GetTestRun is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;
    },
    TestRun
  >;

  @summary("Delete a test run by its name.")
  @doc("Delete a test run by its name.")
  @route("/test-runs/{testRunId}")
  @delete
  DeleteTestRun is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;
    },
    void
  >;

  @summary("Get test run file by file name.")
  @doc("Get test run file by file name.")
  @route("/test-runs/{testRunId}/files/{fileName}")
  @get
  GetTestRunFile is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;

      @doc("Test run file name with file extension")
      @path
      fileName: string;
    },
    FileInfo
  >;

  @summary("Get all test runs with given filters")
  @doc("Get all test runs with given filters")
  @route("/test-runs")
  @get
  ListTestRuns is Azure.Core.Foundations.Operation<
    {
      @doc("""
Sort on the supported fields in (field asc/desc) format. eg: executedDateTime
asc. Supported fields - executedDateTime
""")
      @query
      orderby: string;

      @doc("""
Prefix based, case sensitive search on searchable fields - description,
executedUser. For example, to search for a test run, with description 500 VUs,
the search parameter can be 500.
""")
      @query
      search: string;

      @doc("Unique name of an existing load test.")
      @query
      testId: string;

      @doc("Start DateTime(ISO 8601 literal format) of test-run execution time filter range.")
      @query
      executionFrom: utcDateTime;

      @doc("End DateTime(ISO 8601 literal format) of test-run execution time filter range.")
      @query
      executionTo: utcDateTime;

      @doc("Comma separated list of test run status.")
      @query
      status: string;

      @doc("Number of results in response.")
      @query
      maxpagesize: int32;
    },
    TestRunsList
  >;

  @summary("Stop test run by name.")
  @doc("Stop test run by name.")
  @route("/test-runs/{testRunId}:stop")
  @post
  StopTestRun is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;
    },
    TestRun
  >;

  @summary("List the metric namespaces for a load test run.")
  @doc("List the metric namespaces for a load test run.")
  @route("/test-runs/{testRunId}/metric-namespaces")
  @get
  ListMetricNamespaces is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;
    },
    MetricNamespaceCollection
  >;

  @summary("List the metric definitions for a load test run.")
  @doc("List the metric definitions for a load test run.")
  @route("/test-runs/{testRunId}/metric-definitions")
  @get
  ListMetricDefinitions is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;

      @doc("Metric namespace to query metric definitions for.")
      @query
      metricNamespace: string;
    },
    MetricDefinitionCollection
  >;

  @summary("List the metric values for a load test run.")
  @doc("List the metric values for a load test run.")
  @route("/test-runs/{testRunId}/metrics")
  @post
  ListMetrics is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;

      @doc("The aggregation")
      @query
      aggregation: string;

      @doc("The interval (i.e. timegrain) of the query.")
      @query
      interval: Interval;

      @doc("Metric name")
      @query
      metricname: string;

      @doc("Metric namespace to query metric definitions for.")
      @query
      metricNamespace: string;

      @doc("""
The timespan of the query. It is a string with the following format
'startDateTime_ISO/endDateTime_ISO'.
""")
      @query
      timespan: string;

      @doc("Metric dimension filter ")
      @body
      body: MetricRequestPayload;
    },
    Metrics
  >;

  @summary("List the dimension values for the given metric dimension name.")
  @doc("List the dimension values for the given metric dimension name.")
  ListMetricDimensionValues is Azure.Core.ResourceList<
    string,
    {
      parameters: {
        @doc("The interval (i.e. timegrain) of the query.")
        @query
        interval: Interval;

        @doc("Metric name")
        @query
        metricname: string;

        @doc("Metric namespace to query metric definitions for.")
        @query
        metricNamespace: string;

        @doc("""
The timespan of the query. It is a string with the following format
'startDateTime_ISO/endDateTime_ISO'.
""")
        @query
        timespan: string;
      };
    }
  >;

  @summary("Associate an app component (collection of azure resources) to a test run")
  @doc("Associate an app component (collection of azure resources) to a test run")
  @route("/test-runs/{testRunId}/app-components")
  @patch
  CreateOrUpdateAppComponents is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;

      @doc("App Component model.")
      @body
      body: TestRunAppComponents;
    },
    TestRunAppComponents
  >;

  @summary("""
Get associated app component (collection of azure resources) for the given test
run.
""")
  @doc("""
Get associated app component (collection of azure resources) for the given test
run.
""")
  @route("/test-runs/{testRunId}/app-components")
  @get
  GetAppComponents is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;
    },
    TestRunAppComponents
  >;

  @summary("Configure server metrics for a test run")
  @doc("Configure server metrics for a test run")
  @route("/test-runs/{testRunId}/server-metrics-config")
  @patch
  CreateOrUpdateServerMetricsConfig is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;

      @doc("Server metric configuration model.")
      @body
      body: TestRunServerMetricConfig;
    },
    TestRunServerMetricConfig
  >;

  @summary("List server metrics configuration for the given test run.")
  @doc("List server metrics configuration for the given test run.")
  @route("/test-runs/{testRunId}/server-metrics-config")
  @get
  GetServerMetricsConfig is Azure.Core.Foundations.Operation<
    {
      @doc("""
Unique name for the load test run, must contain only lower-case alphabetic,
numeric, underscore or hyphen characters.
""")
      @path
      testRunId: string;
    },
    TestRunServerMetricConfig
  >;
}
