import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.LoadTesting;

interface LoadTestAdministrationOperations {
  /**
   * Create a new test or update an existing test.
   */
  @summary("Create a new test or update an existing test.")
  @route("/tests/{testId}")
  @patch
  createOrUpdateTest is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;

      /**
       * Load test model
       */
      @body
      body: Test;
    },
    Test
  >;

  /**
   * Delete a test by its name.
   */
  @summary("Delete a test by its name.")
  @route("/tests/{testId}")
  @delete
  deleteTest is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;
    },
    void
  >;

  /**
   * Get load test details by test name
   */
  @summary("Get load test details by test name")
  @route("/tests/{testId}")
  @get
  getTest is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;
    },
    Test
  >;

  /**
   * Get all load tests by the fully qualified resource Id e.g
   * subscriptions/{subId}/resourceGroups/{rg}/providers/Microsoft.LoadTestService/loadtests/{resName}.
   */
  @summary("""
Get all load tests by the fully qualified resource Id e.g
subscriptions/{subId}/resourceGroups/{rg}/providers/Microsoft.LoadTestService/loadtests/{resName}.
""")
  @route("/tests")
  @get
  listTests is Azure.Core.Foundations.Operation<
    {
      /**
       * Sort on the supported fields in (field asc/desc) format. eg:
       * lastModifiedDateTime asc. Supported fields - lastModifiedDateTime
       */
      @query("orderby")
      orderby?: string;

      /**
       * Prefix based, case sensitive search on searchable fields - displayName,
       * createdBy. For example, to search for a test, with display name is Login Test,
       * the search parameter can be Login.
       */
      @query("search")
      search?: string;

      /**
       * Start DateTime(ISO 8601 literal format) of the last updated time range to
       * filter tests.
       */
      @query("lastModifiedStartTime")
      lastModifiedStartTime?: utcDateTime;

      /**
       * End DateTime(ISO 8601 literal format) of the last updated time range to filter
       * tests.
       */
      @query("lastModifiedEndTime")
      lastModifiedEndTime?: utcDateTime;

      /**
       * Number of results in response.
       */
      @query("maxpagesize")
      maxpagesize?: int32 = 50;
    },
    TestsList
  >;

  /**
   * Upload input file for a given test name. File size can't be more than 50 MB.
   * Existing file with same name for the given test will be overwritten. File
   * should be provided in the request body as application/octet-stream.
   */
  @summary("""
Upload input file for a given test name. File size can't be more than 50 MB.
Existing file with same name for the given test will be overwritten. File
should be provided in the request body as application/octet-stream.
""")
  @route("/tests/{testId}/files/{fileName}")
  @put
  uploadTestFile is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;

      /**
       * Unique name for test file with file extension like : App.jmx
       */
      @path
      fileName: string;

      /**
       * File type
       */
      @query("fileType")
      fileType?: FileType;

      /**
       * The file content as application/octet-stream.
       */
      @body
      body: bytes;
    },
    FileInfo
  >;

  /**
   * Get test file by the file name.
   */
  @summary("Get test file by the file name.")
  @route("/tests/{testId}/files/{fileName}")
  @get
  getTestFile is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;

      /**
       * File name with file extension like app.jmx
       */
      @path
      fileName: string;
    },
    FileInfo
  >;

  /**
   * Delete file by the file name for a test
   */
  @summary("Delete file by the file name for a test")
  @route("/tests/{testId}/files/{fileName}")
  @delete
  deleteTestFile is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;

      /**
       * File name with file extension like app.jmx
       */
      @path
      fileName: string;
    },
    void
  >;

  /**
   * Get all test files.
   */
  @summary("Get all test files.")
  @route("/tests/{testId}/files")
  @get
  listTestFiles is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;
    },
    FileInfoList
  >;

  /**
   * Associate an app component (collection of azure resources) to a test
   */
  @summary("Associate an app component (collection of azure resources) to a test")
  @route("/tests/{testId}/app-components")
  @patch
  createOrUpdateAppComponents is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;

      /**
       * App Component model.
       */
      @body
      body: TestAppComponents;
    },
    TestAppComponents
  >;

  /**
   * Get associated app component (collection of azure resources) for the given test.
   */
  @summary("Get associated app component (collection of azure resources) for the given test.")
  @route("/tests/{testId}/app-components")
  @get
  getAppComponents is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;
    },
    TestAppComponents
  >;

  /**
   * Configure server metrics for a test
   */
  @summary("Configure server metrics for a test")
  @route("/tests/{testId}/server-metrics-config")
  @patch
  createOrUpdateServerMetricsConfig is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;

      /**
       * Server metric configuration model.
       */
      @body
      body: TestServerMetricConfig;
    },
    TestServerMetricConfig
  >;

  /**
   * List server metrics configuration for the given test.
   */
  @summary("List server metrics configuration for the given test.")
  @route("/tests/{testId}/server-metrics-config")
  @get
  getServerMetricsConfig is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testId: string;
    },
    TestServerMetricConfig
  >;
}

interface LoadTestRunOperations {
  /**
   * Create and start a new test run with the given name.
   */
  @summary("Create and start a new test run with the given name.")
  @route("/test-runs/{testRunId}")
  @patch
  createOrUpdateTestRun is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;

      /**
       * Existing test run identifier that should be rerun, if this is provided, the
       * test will run with the JMX file, configuration and app components from the
       * existing test run. You can override the configuration values for new test run
       * in the request body.
       */
      @query("oldTestRunId")
      oldTestRunId?: string;

      /**
       * Load test run model
       */
      @body
      body: TestRun;
    },
    TestRun
  >;

  /**
   * Get test run details by name.
   */
  @summary("Get test run details by name.")
  @route("/test-runs/{testRunId}")
  @get
  getTestRun is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;
    },
    TestRun
  >;

  /**
   * Delete a test run by its name.
   */
  @summary("Delete a test run by its name.")
  @route("/test-runs/{testRunId}")
  @delete
  deleteTestRun is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;
    },
    void
  >;

  /**
   * Get test run file by file name.
   */
  @summary("Get test run file by file name.")
  @route("/test-runs/{testRunId}/files/{fileName}")
  @get
  getTestRunFile is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;

      /**
       * Test run file name with file extension
       */
      @path
      fileName: string;
    },
    FileInfo
  >;

  /**
   * Get all test runs with given filters
   */
  @summary("Get all test runs with given filters")
  @route("/test-runs")
  @get
  listTestRuns is Azure.Core.Foundations.Operation<
    {
      /**
       * Sort on the supported fields in (field asc/desc) format. eg: executedDateTime
       * asc. Supported fields - executedDateTime
       */
      @query("orderby")
      orderby?: string;

      /**
       * Prefix based, case sensitive search on searchable fields - description,
       * executedUser. For example, to search for a test run, with description 500 VUs,
       * the search parameter can be 500.
       */
      @query("search")
      search?: string;

      /**
       * Unique name of an existing load test.
       */
      @query("testId")
      testId?: string;

      /**
       * Start DateTime(ISO 8601 literal format) of test-run execution time filter range.
       */
      @query("executionFrom")
      executionFrom?: utcDateTime;

      /**
       * End DateTime(ISO 8601 literal format) of test-run execution time filter range.
       */
      @query("executionTo")
      executionTo?: utcDateTime;

      /**
       * Comma separated list of test run status.
       */
      @query("status")
      status?: string;

      /**
       * Number of results in response.
       */
      @query("maxpagesize")
      maxpagesize?: int32 = 50;
    },
    TestRunsList
  >;

  /**
   * Stop test run by name.
   */
  @summary("Stop test run by name.")
  @route("/test-runs/{testRunId}:stop")
  @post
  stopTestRun is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;
    },
    TestRun
  >;

  /**
   * List the metric namespaces for a load test run.
   */
  @summary("List the metric namespaces for a load test run.")
  @route("/test-runs/{testRunId}/metric-namespaces")
  @get
  listMetricNamespaces is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;
    },
    MetricNamespaceCollection
  >;

  /**
   * List the metric definitions for a load test run.
   */
  @summary("List the metric definitions for a load test run.")
  @route("/test-runs/{testRunId}/metric-definitions")
  @get
  listMetricDefinitions is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;

      /**
       * Metric namespace to query metric definitions for.
       */
      @query("metricNamespace")
      metricNamespace: string;
    },
    MetricDefinitionCollection
  >;

  /**
   * List the metric values for a load test run.
   */
  @summary("List the metric values for a load test run.")
  @route("/test-runs/{testRunId}/metrics")
  @post
  listMetrics is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;

      /**
       * The aggregation
       */
      @query("aggregation")
      aggregation?: string;

      /**
       * The interval (i.e. timegrain) of the query.
       */
      @query("interval")
      interval?: Interval;

      /**
       * Metric name
       */
      @query("metricname")
      metricname: string;

      /**
       * Metric namespace to query metric definitions for.
       */
      @query("metricNamespace")
      metricNamespace: string;

      /**
       * The timespan of the query. It is a string with the following format
       * 'startDateTime_ISO/endDateTime_ISO'.
       */
      @query("timespan")
      timespan: string;

      /**
       * Metric dimension filter
       */
      @body
      body?: MetricRequestPayload;
    },
    Metrics
  >;

  /**
   * List the dimension values for the given metric dimension name.
   */
  @summary("List the dimension values for the given metric dimension name.")
  listMetricDimensionValues is Azure.Core.ResourceList<
    string,
    {
      parameters: {
        /**
         * The interval (i.e. timegrain) of the query.
         */
        @query("interval")
        interval?: Interval;

        /**
         * Metric name
         */
        @query("metricname")
        metricname: string;

        /**
         * Metric namespace to query metric definitions for.
         */
        @query("metricNamespace")
        metricNamespace: string;

        /**
         * The timespan of the query. It is a string with the following format
         * 'startDateTime_ISO/endDateTime_ISO'.
         */
        @query("timespan")
        timespan: string;
      };
    }
  >;

  /**
   * Associate an app component (collection of azure resources) to a test run
   */
  @summary("Associate an app component (collection of azure resources) to a test run")
  @route("/test-runs/{testRunId}/app-components")
  @patch
  createOrUpdateAppComponents is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;

      /**
       * App Component model.
       */
      @body
      body: TestRunAppComponents;
    },
    TestRunAppComponents
  >;

  /**
   * Get associated app component (collection of azure resources) for the given test
   * run.
   */
  @summary("""
Get associated app component (collection of azure resources) for the given test
run.
""")
  @route("/test-runs/{testRunId}/app-components")
  @get
  getAppComponents is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;
    },
    TestRunAppComponents
  >;

  /**
   * Configure server metrics for a test run
   */
  @summary("Configure server metrics for a test run")
  @route("/test-runs/{testRunId}/server-metrics-config")
  @patch
  createOrUpdateServerMetricsConfig is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;

      /**
       * Server metric configuration model.
       */
      @body
      body: TestRunServerMetricConfig;
    },
    TestRunServerMetricConfig
  >;

  /**
   * List server metrics configuration for the given test run.
   */
  @summary("List server metrics configuration for the given test run.")
  @route("/test-runs/{testRunId}/server-metrics-config")
  @get
  getServerMetricsConfig is Azure.Core.Foundations.Operation<
    {
      /**
       * Unique name for the load test run, must contain only lower-case alphabetic,
       * numeric, underscore or hyphen characters.
       */
      @maxLength(50)
      @minLength(2)
      @pattern("^[a-z0-9_-]*$")
      @path
      testRunId: string;
    },
    TestRunServerMetricConfig
  >;
}
