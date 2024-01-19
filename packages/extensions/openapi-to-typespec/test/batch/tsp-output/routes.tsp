import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Batch;

interface ApplicationOperations {
  /**
   * This operation returns only Applications and versions that are available for
   * use on Compute Nodes; that is, that can be used in an Package reference. For
   * administrator information about applications and versions that are not yet
   * available to Compute Nodes, use the Azure portal or the Azure Resource Manager
   * API.
   */
  @summary("Lists all of the applications available in the specified Account.")
  list is Azure.Core.ResourceList<
    Application,
    {
      parameters: {
        /**
         * The maximum number of items to return in the response. A maximum of 1000
         * applications can be returned.
         */
        @maxValue(1000)
        @minValue(1)
        @query("maxresults")
        maxResults?: int32 = 1000;

        /**
         * The maximum time that the server can spend processing the request, in seconds.
         * The default is 30 seconds.
         */
        @query("timeout")
        timeout?: int32 = 30;

        /**
         * The caller-generated request identity, in the form of a GUID with no decoration
         * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
         */
        @header
        `client-request-id`?: string;

        /**
         * Whether the server should return the client-request-id in the response.
         */
        @header
        `return-client-request-id`?: boolean;

        /**
         * The time the request was issued. Client libraries typically set this to the
         * current system clock time; set it explicitly if you are calling the REST API
         * directly.
         */
        @header
        `ocp-date`?: utcDateTime;
      };
    }
  >;

  /**
   * This operation returns only Applications and versions that are available for
   * use on Compute Nodes; that is, that can be used in an Package reference. For
   * administrator information about Applications and versions that are not yet
   * available to Compute Nodes, use the Azure portal or the Azure Resource Manager
   * API.
   */
  @summary("Gets information about the specified Application.")
  get is Azure.Core.ResourceRead<
    Application,
    {
      parameters: {
        /**
         * The maximum time that the server can spend processing the request, in seconds.
         * The default is 30 seconds.
         */
        @query("timeout")
        timeout?: int32 = 30;

        /**
         * The caller-generated request identity, in the form of a GUID with no decoration
         * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
         */
        @header
        `client-request-id`?: string;

        /**
         * Whether the server should return the client-request-id in the response.
         */
        @header
        `return-client-request-id`?: boolean;

        /**
         * The time the request was issued. Client libraries typically set this to the
         * current system clock time; set it explicitly if you are calling the REST API
         * directly.
         */
        @header
        `ocp-date`?: utcDateTime;
      };
    }
  >;
}

interface PoolOperations {
  /**
   * If you do not specify a $filter clause including a poolId, the response
   * includes all Pools that existed in the Account in the time range of the
   * returned aggregation intervals. If you do not specify a $filter clause
   * including a startTime or endTime these filters default to the start and end
   * times of the last aggregation interval currently available; that is, only the
   * last aggregation interval is returned.
   */
  @summary("""
Lists the usage metrics, aggregated by Pool across individual time intervals,
for the specified Account.
""")
  listUsageMetrics is Azure.Core.ResourceList<
    PoolUsageMetrics,
    {
      parameters: {
        /**
         * The earliest time from which to include metrics. This must be at least two and
         * a half hours before the current time. If not specified this defaults to the
         * start time of the last aggregation interval currently available.
         */
        @query("starttime")
        startTime?: utcDateTime;

        /**
         * The latest time from which to include metrics. This must be at least two hours
         * before the current time. If not specified this defaults to the end time of the
         * last aggregation interval currently available.
         */
        @query("endtime")
        endTime?: utcDateTime;

        /**
         * An OData $filter clause. For more information on constructing this filter, see
         * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-account-usage-metrics.
         */
        @query("$filter")
        $filter?: string;

        /**
         * The maximum number of items to return in the response. A maximum of 1000
         * results will be returned.
         */
        @maxValue(1000)
        @minValue(1)
        @query("maxresults")
        maxResults?: int32 = 1000;

        /**
         * The maximum time that the server can spend processing the request, in seconds.
         * The default is 30 seconds.
         */
        @query("timeout")
        timeout?: int32 = 30;

        /**
         * The caller-generated request identity, in the form of a GUID with no decoration
         * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
         */
        @header
        `client-request-id`?: string;

        /**
         * Whether the server should return the client-request-id in the response.
         */
        @header
        `return-client-request-id`?: boolean;

        /**
         * The time the request was issued. Client libraries typically set this to the
         * current system clock time; set it explicitly if you are calling the REST API
         * directly.
         */
        @header
        `ocp-date`?: utcDateTime;
      };
    }
  >;

  /**
   * Statistics are aggregated across all Pools that have ever existed in the
   * Account, from Account creation to the last update time of the statistics. The
   * statistics may not be immediately available. The Batch service performs
   * periodic roll-up of statistics. The typical delay is about 30 minutes.
   */
  @summary("Gets lifetime summary statistics for all of the Pools in the specified Account.")
  @route("/lifetimepoolstats")
  @get
  getAllLifetimeStatistics is Azure.Core.Foundations.Operation<
    {
      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    PoolStatistics
  >;

  /**
   * When naming Pools, avoid including sensitive information such as user names or
   * secret project names. This information may appear in telemetry logs accessible
   * to Microsoft Support engineers.
   */
  @summary("Adds a Pool to the specified Account.")
  @route("/pools")
  @post
  add is Azure.Core.Foundations.Operation<
    {
      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The Pool to be added.
       */
      @body
      pool: BatchPool;
    },
    void
  >;

  /**
   * Lists all of the Pools in the specified Account.
   */
  @summary("Lists all of the Pools in the specified Account.")
  @route("/pools")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * An OData $filter clause. For more information on constructing this filter, see
       * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-pools.
       */
      @query("$filter")
      $filter?: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * An OData $expand clause.
       */
      @query("$expand")
      $expand?: string;

      /**
       * The maximum number of items to return in the response. A maximum of 1000 Pools
       * can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    BatchPoolListResult
  >;

  /**
   * When you request that a Pool be deleted, the following actions occur: the Pool
   * state is set to deleting; any ongoing resize operation on the Pool are stopped;
   * the Batch service starts resizing the Pool to zero Compute Nodes; any Tasks
   * running on existing Compute Nodes are terminated and requeued (as if a resize
   * Pool operation had been requested with the default requeue option); finally,
   * the Pool is removed from the system. Because running Tasks are requeued, the
   * user can rerun these Tasks by updating their Job to target a different Pool.
   * The Tasks can then run on the new Pool. If you want to override the requeue
   * behavior, then you should call resize Pool explicitly to shrink the Pool to
   * zero size before deleting the Pool. If you call an Update, Patch or Delete API
   * on a Pool in the deleting state, it will fail with HTTP status code 409 with
   * error code PoolBeingDeleted.
   */
  @summary("Deletes a Pool from the specified Account.")
  @route("/pools/{poolId}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool to delete.
       */
      @path
      poolId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * Gets basic properties of a Pool.
   */
  @route("/pools/{poolId}")
  @head
  exists is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool to get.
       */
      @path
      poolId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * Gets information about the specified Pool.
   */
  @route("/pools/{poolId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool to get.
       */
      @path
      poolId: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * An OData $expand clause.
       */
      @query("$expand")
      $expand?: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    BatchPool
  >;

  /**
   * This only replaces the Pool properties specified in the request. For example,
   * if the Pool has a StartTask associated with it, and a request does not specify
   * a StartTask element, then the Pool keeps the existing StartTask.
   */
  @summary("Updates the properties of the specified Pool.")
  @route("/pools/{poolId}")
  @patch
  patch is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool to update.
       */
      @path
      poolId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      poolUpdate: BatchPoolUpdate;
    },
    void
  >;

  /**
   * Disables automatic scaling for a Pool.
   */
  @summary("Disables automatic scaling for a Pool.")
  @route("/pools/{poolId}/disableautoscale")
  @post
  disableAutoScale is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool on which to disable automatic scaling.
       */
      @path
      poolId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    void
  >;

  /**
   * You cannot enable automatic scaling on a Pool if a resize operation is in
   * progress on the Pool. If automatic scaling of the Pool is currently disabled,
   * you must specify a valid autoscale formula as part of the request. If automatic
   * scaling of the Pool is already enabled, you may specify a new autoscale formula
   * and/or a new evaluation interval. You cannot call this API for the same Pool
   * more than once every 30 seconds.
   */
  @summary("Enables automatic scaling for a Pool.")
  @route("/pools/{poolId}/enableautoscale")
  @post
  enableAutoScale is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool on which to enable automatic scaling.
       */
      @path
      poolId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      parameters: BatchPoolEnableAutoScaleParameters;
    },
    void
  >;

  /**
   * This API is primarily for validating an autoscale formula, as it simply returns
   * the result without applying the formula to the Pool. The Pool must have auto
   * scaling enabled in order to evaluate a formula.
   */
  @summary("Gets the result of evaluating an automatic scaling formula on the Pool.")
  @route("/pools/{poolId}/evaluateautoscale")
  @post
  evaluateAutoScale is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool on which to evaluate the automatic scaling formula.
       */
      @path
      poolId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      parameters: BatchPoolEvaluateAutoScaleParameters;
    },
    AutoScaleRun
  >;

  /**
   * You can only resize a Pool when its allocation state is steady. If the Pool is
   * already resizing, the request fails with status code 409. When you resize a
   * Pool, the Pool's allocation state changes from steady to resizing. You cannot
   * resize Pools which are configured for automatic scaling. If you try to do this,
   * the Batch service returns an error 409. If you resize a Pool downwards, the
   * Batch service chooses which Compute Nodes to remove. To remove specific Compute
   * Nodes, use the Pool remove Compute Nodes API instead.
   */
  @summary("Changes the number of Compute Nodes that are assigned to a Pool.")
  @route("/pools/{poolId}/resize")
  @post
  resize is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool to resize.
       */
      @path
      poolId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      parameters: BatchPoolResizeParameters;
    },
    void
  >;

  /**
   * This does not restore the Pool to its previous state before the resize
   * operation: it only stops any further changes being made, and the Pool maintains
   * its current state. After stopping, the Pool stabilizes at the number of Compute
   * Nodes it was at when the stop operation was done. During the stop operation,
   * the Pool allocation state changes first to stopping and then to steady. A
   * resize operation need not be an explicit resize Pool request; this API can also
   * be used to halt the initial sizing of the Pool when it is created.
   */
  @summary("Stops an ongoing resize operation on the Pool.")
  @route("/pools/{poolId}/stopresize")
  @post
  stopResize is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool whose resizing you want to stop.
       */
      @path
      poolId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * This fully replaces all the updatable properties of the Pool. For example, if
   * the Pool has a StartTask associated with it and if StartTask is not specified
   * with this request, then the Batch service will remove the existing StartTask.
   */
  @summary("Updates the properties of the specified Pool.")
  @route("/pools/{poolId}/updateproperties")
  @post
  updateProperties is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool to update.
       */
      @path
      poolId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      poolUpdatePropertiesParameter: BatchPool;
    },
    void
  >;

  /**
   * This operation can only run when the allocation state of the Pool is steady.
   * When this operation runs, the allocation state changes from steady to resizing.
   * Each request may remove up to 100 nodes.
   */
  @summary("Removes Compute Nodes from the specified Pool.")
  @route("/pools/{poolId}/removenodes")
  @post
  removeNodes is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool from which you want to remove Compute Nodes.
       */
      @path
      poolId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      parameters: NodeRemoveParameters;
    },
    void
  >;
}

interface AccountOperations {
  /**
   * Lists all Virtual Machine Images supported by the Azure Batch service.
   */
  @summary("Lists all Virtual Machine Images supported by the Azure Batch service.")
  listSupportedImages is Azure.Core.ResourceList<
    ImageInformation,
    {
      parameters: {
        /**
         * An OData $filter clause. For more information on constructing this filter, see
         * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-support-images.
         */
        @query("$filter")
        $filter?: string;

        /**
         * The maximum number of items to return in the response. A maximum of 1000
         * results will be returned.
         */
        @maxValue(1000)
        @minValue(1)
        @query("maxresults")
        maxResults?: int32 = 1000;

        /**
         * The maximum time that the server can spend processing the request, in seconds.
         * The default is 30 seconds.
         */
        @query("timeout")
        timeout?: int32 = 30;

        /**
         * The caller-generated request identity, in the form of a GUID with no decoration
         * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
         */
        @header
        `client-request-id`?: string;

        /**
         * Whether the server should return the client-request-id in the response.
         */
        @header
        `return-client-request-id`?: boolean;

        /**
         * The time the request was issued. Client libraries typically set this to the
         * current system clock time; set it explicitly if you are calling the REST API
         * directly.
         */
        @header
        `ocp-date`?: utcDateTime;
      };
    }
  >;

  /**
   * Gets the number of Compute Nodes in each state, grouped by Pool. Note that the
   * numbers returned may not always be up to date. If you need exact node counts,
   * use a list query.
   */
  listPoolNodeCounts is Azure.Core.ResourceList<
    PoolNodeCounts,
    {
      parameters: {
        /**
         * An OData $filter clause. For more information on constructing this filter, see
         * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch.
         */
        @query("$filter")
        $filter?: string;

        /**
         * The maximum number of items to return in the response.
         */
        @maxValue(10)
        @minValue(1)
        @query("maxresults")
        maxResults?: int32 = 10;

        /**
         * The maximum time that the server can spend processing the request, in seconds.
         * The default is 30 seconds.
         */
        @query("timeout")
        timeout?: int32 = 30;

        /**
         * The caller-generated request identity, in the form of a GUID with no decoration
         * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
         */
        @header
        `client-request-id`?: string;

        /**
         * Whether the server should return the client-request-id in the response.
         */
        @header
        `return-client-request-id`?: boolean;

        /**
         * The time the request was issued. Client libraries typically set this to the
         * current system clock time; set it explicitly if you are calling the REST API
         * directly.
         */
        @header
        `ocp-date`?: utcDateTime;
      };
    }
  >;
}

interface JobOperations {
  /**
   * Statistics are aggregated across all Jobs that have ever existed in the
   * Account, from Account creation to the last update time of the statistics. The
   * statistics may not be immediately available. The Batch service performs
   * periodic roll-up of statistics. The typical delay is about 30 minutes.
   */
  @summary("Gets lifetime summary statistics for all of the Jobs in the specified Account.")
  @route("/lifetimejobstats")
  @get
  getAllLifetimeStatistics is Azure.Core.Foundations.Operation<
    {
      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    JobStatistics
  >;

  /**
   * Deleting a Job also deletes all Tasks that are part of that Job, and all Job
   * statistics. This also overrides the retention period for Task data; that is, if
   * the Job contains Tasks which are still retained on Compute Nodes, the Batch
   * services deletes those Tasks' working directories and all their contents.  When
   * a Delete Job request is received, the Batch service sets the Job to the
   * deleting state. All update operations on a Job that is in deleting state will
   * fail with status code 409 (Conflict), with additional information indicating
   * that the Job is being deleted.
   */
  @summary("Deletes a Job.")
  @route("/jobs/{jobId}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job to delete.
       */
      @path
      jobId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * Gets information about the specified Job.
   */
  @summary("Gets information about the specified Job.")
  @route("/jobs/{jobId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job.
       */
      @path
      jobId: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * An OData $expand clause.
       */
      @query("$expand")
      $expand?: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    BatchJob
  >;

  /**
   * This replaces only the Job properties specified in the request. For example, if
   * the Job has constraints, and a request does not specify the constraints
   * element, then the Job keeps the existing constraints.
   */
  @summary("Updates the properties of the specified Job.")
  @route("/jobs/{jobId}")
  @patch
  patch is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job whose properties you want to update.
       */
      @path
      jobId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      jobUpdate: BatchJobUpdate;
    },
    void
  >;

  /**
   * This fully replaces all the updatable properties of the Job. For example, if
   * the Job has constraints associated with it and if constraints is not specified
   * with this request, then the Batch service will remove the existing constraints.
   */
  @summary("Updates the properties of the specified Job.")
  @route("/jobs/{jobId}")
  @put
  update is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job whose properties you want to update.
       */
      @path
      jobId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      job: BatchJob;
    },
    void
  >;

  /**
   * The Batch Service immediately moves the Job to the disabling state. Batch then
   * uses the disableTasks parameter to determine what to do with the currently
   * running Tasks of the Job. The Job remains in the disabling state until the
   * disable operation is completed and all Tasks have been dealt with according to
   * the disableTasks option; the Job then moves to the disabled state. No new Tasks
   * are started under the Job until it moves back to active state. If you try to
   * disable a Job that is in any state other than active, disabling, or disabled,
   * the request fails with status code 409.
   */
  @summary("Disables the specified Job, preventing new Tasks from running.")
  @route("/jobs/{jobId}/disable")
  @post
  disable is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job to disable.
       */
      @path
      jobId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      parameters: BatchJobDisableParameters;
    },
    void
  >;

  /**
   * When you call this API, the Batch service sets a disabled Job to the enabling
   * state. After the this operation is completed, the Job moves to the active
   * state, and scheduling of new Tasks under the Job resumes. The Batch service
   * does not allow a Task to remain in the active state for more than 180 days.
   * Therefore, if you enable a Job containing active Tasks which were added more
   * than 180 days ago, those Tasks will not run.
   */
  @summary("Enables the specified Job, allowing new Tasks to run.")
  @route("/jobs/{jobId}/enable")
  @post
  enable is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job to enable.
       */
      @path
      jobId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * When a Terminate Job request is received, the Batch service sets the Job to the
   * terminating state. The Batch service then terminates any running Tasks
   * associated with the Job and runs any required Job release Tasks. Then the Job
   * moves into the completed state. If there are any Tasks in the Job in the active
   * state, they will remain in the active state. Once a Job is terminated, new
   * Tasks cannot be added and any remaining active Tasks will not be scheduled.
   */
  @summary("Terminates the specified Job, marking it as completed.")
  @route("/jobs/{jobId}/terminate")
  @post
  terminate is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job to terminate.
       */
      @path
      jobId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      parameters?: BatchJobTerminateParameters;
    },
    void
  >;

  /**
   * The Batch service supports two ways to control the work done as part of a Job.
   * In the first approach, the user specifies a Job Manager Task. The Batch service
   * launches this Task when it is ready to start the Job. The Job Manager Task
   * controls all other Tasks that run under this Job, by using the Task APIs. In
   * the second approach, the user directly controls the execution of Tasks under an
   * active Job, by using the Task APIs. Also note: when naming Jobs, avoid
   * including sensitive information such as user names or secret project names.
   * This information may appear in telemetry logs accessible to Microsoft Support
   * engineers.
   */
  @summary("Adds a Job to the specified Account.")
  @route("/jobs")
  @post
  add is Azure.Core.Foundations.Operation<
    {
      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The Job to be added.
       */
      @body
      job: BatchJob;
    },
    void
  >;

  /**
   * Lists all of the Jobs in the specified Account.
   */
  @summary("Lists all of the Jobs in the specified Account.")
  @route("/jobs")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * An OData $filter clause. For more information on constructing this filter, see
       * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs.
       */
      @query("$filter")
      $filter?: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * An OData $expand clause.
       */
      @query("$expand")
      $expand?: string;

      /**
       * The maximum number of items to return in the response. A maximum of 1000 Jobs
       * can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    BatchJobListResult
  >;

  /**
   * Lists the Jobs that have been created under the specified Job Schedule.
   */
  @summary("Lists the Jobs that have been created under the specified Job Schedule.")
  @route("/jobschedules/{jobScheduleId}/jobs")
  @get
  listFromJobSchedule is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job Schedule from which you want to get a list of Jobs.
       */
      @path
      jobScheduleId: string;

      /**
       * An OData $filter clause. For more information on constructing this filter, see
       * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs-in-a-job-schedule.
       */
      @query("$filter")
      $filter?: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * An OData $expand clause.
       */
      @query("$expand")
      $expand?: string;

      /**
       * The maximum number of items to return in the response. A maximum of 1000 Jobs
       * can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    BatchJobListResult
  >;

  /**
   * This API returns the Job Preparation and Job Release Task status on all Compute
   * Nodes that have run the Job Preparation or Job Release Task. This includes
   * Compute Nodes which have since been removed from the Pool. If this API is
   * invoked on a Job which has no Job Preparation or Job Release Task, the Batch
   * service returns HTTP status code 409 (Conflict) with an error code of
   * JobPreparationTaskNotSpecified.
   */
  @summary("""
Lists the execution status of the Job Preparation and Job Release Task for the
specified Job across the Compute Nodes where the Job has run.
""")
  @route("/jobs/{jobId}/jobpreparationandreleasetaskstatus")
  @get
  listPreparationAndReleaseTaskStatus is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job.
       */
      @path
      jobId: string;

      /**
       * An OData $filter clause. For more information on constructing this filter, see
       * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-preparation-and-release-status.
       */
      @query("$filter")
      $filter?: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * The maximum number of items to return in the response. A maximum of 1000 Tasks
       * can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    BatchJobListPreparationAndReleaseTaskStatusResult
  >;

  /**
   * Task counts provide a count of the Tasks by active, running or completed Task
   * state, and a count of Tasks which succeeded or failed. Tasks in the preparing
   * state are counted as running. Note that the numbers returned may not always be
   * up to date. If you need exact task counts, use a list query.
   */
  @summary("Gets the Task counts for the specified Job.")
  @route("/jobs/{jobId}/taskcounts")
  @get
  getTaskCounts is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job.
       */
      @path
      jobId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    TaskCountsResult
  >;
}

interface CertificateOperations {
  /**
   * Adds a Certificate to the specified Account.
   */
  @summary("Adds a Certificate to the specified Account.")
  @route("/certificates")
  @post
  add is Azure.Core.Foundations.Operation<
    {
      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The Certificate to be added.
       */
      @body
      certificate: Certificate;
    },
    void
  >;

  /**
   * Lists all of the Certificates that have been added to the specified Account.
   */
  @summary("Lists all of the Certificates that have been added to the specified Account.")
  @route("/certificates")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * An OData $filter clause. For more information on constructing this filter, see
       * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-certificates.
       */
      @query("$filter")
      $filter?: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * The maximum number of items to return in the response. A maximum of 1000
       * Certificates can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    CertificateListResult
  >;

  /**
   * If you try to delete a Certificate that is being used by a Pool or Compute
   * Node, the status of the Certificate changes to deleteFailed. If you decide that
   * you want to continue using the Certificate, you can use this operation to set
   * the status of the Certificate back to active. If you intend to delete the
   * Certificate, you do not need to run this operation after the deletion failed.
   * You must make sure that the Certificate is not being used by any resources, and
   * then you can try again to delete the Certificate.
   */
  @summary("Cancels a failed deletion of a Certificate from the specified Account.")
  @route("/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})/canceldelete")
  @post
  cancelDeletion is Azure.Core.Foundations.Operation<
    {
      /**
       * The algorithm used to derive the thumbprint parameter. This must be sha1.
       */
      @path
      thumbprintAlgorithm: string;

      /**
       * The thumbprint of the Certificate being deleted.
       */
      @path
      thumbprint: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    void
  >;

  /**
   * You cannot delete a Certificate if a resource (Pool or Compute Node) is using
   * it. Before you can delete a Certificate, you must therefore make sure that the
   * Certificate is not associated with any existing Pools, the Certificate is not
   * installed on any Nodes (even if you remove a Certificate from a Pool, it is not
   * removed from existing Compute Nodes in that Pool until they restart), and no
   * running Tasks depend on the Certificate. If you try to delete a Certificate
   * that is in use, the deletion fails. The Certificate status changes to
   * deleteFailed. You can use Cancel Delete Certificate to set the status back to
   * active if you decide that you want to continue using the Certificate.
   */
  @summary("Deletes a Certificate from the specified Account.")
  @route("/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The algorithm used to derive the thumbprint parameter. This must be sha1.
       */
      @path
      thumbprintAlgorithm: string;

      /**
       * The thumbprint of the Certificate to be deleted.
       */
      @path
      thumbprint: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    void
  >;

  /**
   * Gets information about the specified Certificate.
   */
  @route("/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The algorithm used to derive the thumbprint parameter. This must be sha1.
       */
      @path
      thumbprintAlgorithm: string;

      /**
       * The thumbprint of the Certificate to get.
       */
      @path
      thumbprint: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    Certificate
  >;
}

interface FileOperations {
  /**
   * Deletes the specified Task file from the Compute Node where the Task ran.
   */
  @summary("Deletes the specified Task file from the Compute Node where the Task ran.")
  @route("/jobs/{jobId}/tasks/{taskId}/files/{filePath}")
  @delete
  deleteFromTask is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job that contains the Task.
       */
      @path
      jobId: string;

      /**
       * The ID of the Task whose file you want to delete.
       */
      @path
      taskId: string;

      /**
       * The path to the Task file or directory that you want to delete.
       */
      @path
      filePath: string;

      /**
       * Whether to delete children of a directory. If the filePath parameter represents
       * a directory instead of a file, you can set recursive to true to delete the
       * directory and all of the files and subdirectories in it. If recursive is false
       * then the directory must be empty or deletion will fail.
       */
      @query("recursive")
      recursive?: boolean;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    void
  >;

  /**
   * Returns the content of the specified Task file.
   */
  @route("/jobs/{jobId}/tasks/{taskId}/files/{filePath}")
  @get
  getFromTask is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job that contains the Task.
       */
      @path
      jobId: string;

      /**
       * The ID of the Task whose file you want to retrieve.
       */
      @path
      taskId: string;

      /**
       * The path to the Task file that you want to get the content of.
       */
      @path
      filePath: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The byte range to be retrieved. The default is to retrieve the entire file. The
       * format is bytes=startRange-endRange.
       */
      @header
      `ocp-range`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * Accept header
       */
      @header
      accept: "application/json, application/octet-stream";
    },
    void
  >;

  /**
   * Gets the properties of the specified Task file.
   */
  @route("/jobs/{jobId}/tasks/{taskId}/files/{filePath}")
  @head
  getPropertiesFromTask is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job that contains the Task.
       */
      @path
      jobId: string;

      /**
       * The ID of the Task whose file you want to get the properties of.
       */
      @path
      taskId: string;

      /**
       * The path to the Task file that you want to get the properties of.
       */
      @path
      filePath: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * Deletes the specified file from the Compute Node.
   */
  @summary("Deletes the specified file from the Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/files/{filePath}")
  @delete
  deleteFromComputeNode is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node from which you want to delete the file.
       */
      @path
      nodeId: string;

      /**
       * The path to the file or directory that you want to delete.
       */
      @path
      filePath: string;

      /**
       * Whether to delete children of a directory. If the filePath parameter represents
       * a directory instead of a file, you can set recursive to true to delete the
       * directory and all of the files and subdirectories in it. If recursive is false
       * then the directory must be empty or deletion will fail.
       */
      @query("recursive")
      recursive?: boolean;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    void
  >;

  /**
   * Returns the content of the specified Compute Node file.
   */
  @route("/pools/{poolId}/nodes/{nodeId}/files/{filePath}")
  @get
  getFromComputeNode is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node that contains the file.
       */
      @path
      nodeId: string;

      /**
       * The path to the Compute Node file that you want to get the content of.
       */
      @path
      filePath: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The byte range to be retrieved. The default is to retrieve the entire file. The
       * format is bytes=startRange-endRange.
       */
      @header
      `ocp-range`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * Accept header
       */
      @header
      accept: "application/json, application/octet-stream";
    },
    void
  >;

  /**
   * Gets the properties of the specified Compute Node file.
   */
  @route("/pools/{poolId}/nodes/{nodeId}/files/{filePath}")
  @head
  getPropertiesFromComputeNode is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node that contains the file.
       */
      @path
      nodeId: string;

      /**
       * The path to the Compute Node file that you want to get the properties of.
       */
      @path
      filePath: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * Lists the files in a Task's directory on its Compute Node.
   */
  @summary("Lists the files in a Task's directory on its Compute Node.")
  @route("/jobs/{jobId}/tasks/{taskId}/files")
  @get
  listFromTask is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job that contains the Task.
       */
      @path
      jobId: string;

      /**
       * The ID of the Task whose files you want to list.
       */
      @path
      taskId: string;

      /**
       * An OData $filter clause. For more information on constructing this filter, see
       * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-task-files.
       */
      @query("$filter")
      $filter?: string;

      /**
       * Whether to list children of the Task directory. This parameter can be used in
       * combination with the filter parameter to list specific type of files.
       */
      @query("recursive")
      recursive?: boolean;

      /**
       * The maximum number of items to return in the response. A maximum of 1000 files
       * can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    NodeFileListResult
  >;

  /**
   * Lists all of the files in Task directories on the specified Compute Node.
   */
  @summary("Lists all of the files in Task directories on the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/files")
  @get
  listFromComputeNode is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node whose files you want to list.
       */
      @path
      nodeId: string;

      /**
       * An OData $filter clause. For more information on constructing this filter, see
       * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-compute-node-files.
       */
      @query("$filter")
      $filter?: string;

      /**
       * Whether to list children of a directory.
       */
      @query("recursive")
      recursive?: boolean;

      /**
       * The maximum number of items to return in the response. A maximum of 1000 files
       * can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    NodeFileListResult
  >;
}

interface JobScheduleOperations {
  /**
   * Checks the specified Job Schedule exists.
   */
  @summary("Checks the specified Job Schedule exists.")
  @route("/jobschedules/{jobScheduleId}")
  @head
  exists is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job Schedule which you want to check.
       */
      @path
      jobScheduleId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * When you delete a Job Schedule, this also deletes all Jobs and Tasks under that
   * schedule. When Tasks are deleted, all the files in their working directories on
   * the Compute Nodes are also deleted (the retention period is ignored). The Job
   * Schedule statistics are no longer accessible once the Job Schedule is deleted,
   * though they are still counted towards Account lifetime statistics.
   */
  @summary("Deletes a Job Schedule from the specified Account.")
  @route("/jobschedules/{jobScheduleId}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job Schedule to delete.
       */
      @path
      jobScheduleId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * Gets information about the specified Job Schedule.
   */
  @route("/jobschedules/{jobScheduleId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job Schedule to get.
       */
      @path
      jobScheduleId: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * An OData $expand clause.
       */
      @query("$expand")
      $expand?: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    BatchJobSchedule
  >;

  /**
   * This replaces only the Job Schedule properties specified in the request. For
   * example, if the schedule property is not specified with this request, then the
   * Batch service will keep the existing schedule. Changes to a Job Schedule only
   * impact Jobs created by the schedule after the update has taken place; currently
   * running Jobs are unaffected.
   */
  @summary("Updates the properties of the specified Job Schedule.")
  @route("/jobschedules/{jobScheduleId}")
  @patch
  patch is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job Schedule to update.
       */
      @path
      jobScheduleId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      jobScheduleUpdate: BatchJobScheduleUpdate;
    },
    void
  >;

  /**
   * This fully replaces all the updatable properties of the Job Schedule. For
   * example, if the schedule property is not specified with this request, then the
   * Batch service will remove the existing schedule. Changes to a Job Schedule only
   * impact Jobs created by the schedule after the update has taken place; currently
   * running Jobs are unaffected.
   */
  @summary("Updates the properties of the specified Job Schedule.")
  @route("/jobschedules/{jobScheduleId}")
  @put
  update is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job Schedule to update.
       */
      @path
      jobScheduleId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      jobSchedule: BatchJobSchedule;
    },
    void
  >;

  /**
   * No new Jobs will be created until the Job Schedule is enabled again.
   */
  @summary("Disables a Job Schedule.")
  @route("/jobschedules/{jobScheduleId}/disable")
  @post
  disable is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job Schedule to disable.
       */
      @path
      jobScheduleId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * Enables a Job Schedule.
   */
  @summary("Enables a Job Schedule.")
  @route("/jobschedules/{jobScheduleId}/enable")
  @post
  enable is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job Schedule to enable.
       */
      @path
      jobScheduleId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * Terminates a Job Schedule.
   */
  @summary("Terminates a Job Schedule.")
  @route("/jobschedules/{jobScheduleId}/terminate")
  @post
  terminate is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job Schedule to terminates.
       */
      @path
      jobScheduleId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * Adds a Job Schedule to the specified Account.
   */
  @summary("Adds a Job Schedule to the specified Account.")
  @route("/jobschedules")
  @post
  add is Azure.Core.Foundations.Operation<
    {
      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The Job Schedule to be added.
       */
      @body
      jobSchedule: BatchJobSchedule;
    },
    void
  >;

  /**
   * Lists all of the Job Schedules in the specified Account.
   */
  @summary("Lists all of the Job Schedules in the specified Account.")
  @route("/jobschedules")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * An OData $filter clause. For more information on constructing this filter, see
       * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-schedules.
       */
      @query("$filter")
      $filter?: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * An OData $expand clause.
       */
      @query("$expand")
      $expand?: string;

      /**
       * The maximum number of items to return in the response. A maximum of 1000 Job
       * Schedules can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    BatchJobScheduleListResult
  >;
}

interface TaskOperations {
  /**
   * The maximum lifetime of a Task from addition to completion is 180 days. If a
   * Task has not completed within 180 days of being added it will be terminated by
   * the Batch service and left in whatever state it was in at that time.
   */
  @summary("Adds a Task to the specified Job.")
  @route("/jobs/{jobId}/tasks")
  @post
  add is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job to which the Task is to be added.
       */
      @path
      jobId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The Task to be added.
       */
      @body
      task: BatchTask;
    },
    void
  >;

  /**
   * For multi-instance Tasks, information such as affinityId, executionInfo and
   * nodeInfo refer to the primary Task. Use the list subtasks API to retrieve
   * information about subtasks.
   */
  @summary("Lists all of the Tasks that are associated with the specified Job.")
  @route("/jobs/{jobId}/tasks")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job.
       */
      @path
      jobId: string;

      /**
       * An OData $filter clause. For more information on constructing this filter, see
       * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-tasks.
       */
      @query("$filter")
      $filter?: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * An OData $expand clause.
       */
      @query("$expand")
      $expand?: string;

      /**
       * The maximum number of items to return in the response. A maximum of 1000 Tasks
       * can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    BatchTaskListResult
  >;

  /**
   * Note that each Task must have a unique ID. The Batch service may not return the
   * results for each Task in the same order the Tasks were submitted in this
   * request. If the server times out or the connection is closed during the
   * request, the request may have been partially or fully processed, or not at all.
   * In such cases, the user should re-issue the request. Note that it is up to the
   * user to correctly handle failures when re-issuing a request. For example, you
   * should use the same Task IDs during a retry so that if the prior operation
   * succeeded, the retry will not create extra Tasks unexpectedly. If the response
   * contains any Tasks which failed to add, a client can retry the request. In a
   * retry, it is most efficient to resubmit only Tasks that failed to add, and to
   * omit Tasks that were successfully added on the first attempt. The maximum
   * lifetime of a Task from addition to completion is 180 days. If a Task has not
   * completed within 180 days of being added it will be terminated by the Batch
   * service and left in whatever state it was in at that time.
   */
  @summary("Adds a collection of Tasks to the specified Job.")
  @route("/jobs/{jobId}/addtaskcollection")
  @post
  addCollection is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job to which the Task collection is to be added.
       */
      @path
      jobId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The Tasks to be added.
       */
      @body
      taskCollection: BatchTaskCollection;
    },
    TaskAddCollectionResult
  >;

  /**
   * When a Task is deleted, all of the files in its directory on the Compute Node
   * where it ran are also deleted (regardless of the retention time). For
   * multi-instance Tasks, the delete Task operation applies synchronously to the
   * primary task; subtasks and their files are then deleted asynchronously in the
   * background.
   */
  @summary("Deletes a Task from the specified Job.")
  @route("/jobs/{jobId}/tasks/{taskId}")
  @delete
  delete is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job from which to delete the Task.
       */
      @path
      jobId: string;

      /**
       * The ID of the Task to delete.
       */
      @path
      taskId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * For multi-instance Tasks, information such as affinityId, executionInfo and
   * nodeInfo refer to the primary Task. Use the list subtasks API to retrieve
   * information about subtasks.
   */
  @summary("Gets information about the specified Task.")
  @route("/jobs/{jobId}/tasks/{taskId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job that contains the Task.
       */
      @path
      jobId: string;

      /**
       * The ID of the Task to get information about.
       */
      @path
      taskId: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * An OData $expand clause.
       */
      @query("$expand")
      $expand?: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    BatchTask
  >;

  /**
   * Updates the properties of the specified Task.
   */
  @route("/jobs/{jobId}/tasks/{taskId}")
  @put
  update is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job containing the Task.
       */
      @path
      jobId: string;

      /**
       * The ID of the Task to update.
       */
      @path
      taskId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      task: BatchTask;
    },
    void
  >;

  /**
   * If the Task is not a multi-instance Task then this returns an empty collection.
   */
  @summary("""
Lists all of the subtasks that are associated with the specified multi-instance
Task.
""")
  @route("/jobs/{jobId}/tasks/{taskId}/subtasksinfo")
  @get
  listSubtasks is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job.
       */
      @path
      jobId: string;

      /**
       * The ID of the Task.
       */
      @path
      taskId: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    BatchTaskListSubtasksResult
  >;

  /**
   * When the Task has been terminated, it moves to the completed state. For
   * multi-instance Tasks, the terminate Task operation applies synchronously to the
   * primary task; subtasks are then terminated asynchronously in the background.
   */
  @summary("Terminates the specified Task.")
  @route("/jobs/{jobId}/tasks/{taskId}/terminate")
  @post
  terminate is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job containing the Task.
       */
      @path
      jobId: string;

      /**
       * The ID of the Task to terminate.
       */
      @path
      taskId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;

  /**
   * Reactivation makes a Task eligible to be retried again up to its maximum retry
   * count. The Task's state is changed to active. As the Task is no longer in the
   * completed state, any previous exit code or failure information is no longer
   * available after reactivation. Each time a Task is reactivated, its retry count
   * is reset to 0. Reactivation will fail for Tasks that are not completed or that
   * previously completed successfully (with an exit code of 0). Additionally, it
   * will fail if the Job has completed (or is terminating or deleting).
   */
  @summary("""
Reactivates a Task, allowing it to run again even if its retry count has been
exhausted.
""")
  @route("/jobs/{jobId}/tasks/{taskId}/reactivate")
  @post
  reactivate is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Job containing the Task.
       */
      @path
      jobId: string;

      /**
       * The ID of the Task to reactivate.
       */
      @path
      taskId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service exactly matches the value specified by the client.
       */
      @header
      `If-Match`?: string;

      /**
       * An ETag value associated with the version of the resource known to the client.
       * The operation will be performed only if the resource's current ETag on the
       * service does not match the value specified by the client.
       */
      @header
      `If-None-Match`?: string;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * been modified since the specified time.
       */
      @header
      `If-Modified-Since`?: utcDateTime;

      /**
       * A timestamp indicating the last modified time of the resource known to the
       * client. The operation will be performed only if the resource on the service has
       * not been modified since the specified time.
       */
      @header
      `If-Unmodified-Since`?: utcDateTime;
    },
    void
  >;
}

interface ComputeNodeOperations {
  /**
   * You can add a user Account to a Compute Node only when it is in the idle or
   * running state.
   */
  @summary("Adds a user Account to the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/users")
  @post
  addUser is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the machine on which you want to create a user Account.
       */
      @path
      nodeId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The user Account to be created.
       */
      @body
      user: ComputeNodeUser;
    },
    void
  >;

  /**
   * You can delete a user Account to a Compute Node only when it is in the idle or
   * running state.
   */
  @summary("Deletes a user Account from the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/users/{userName}")
  @delete
  deleteUser is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the machine on which you want to delete a user Account.
       */
      @path
      nodeId: string;

      /**
       * The name of the user Account to delete.
       */
      @path
      userName: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    void
  >;

  /**
   * This operation replaces of all the updatable properties of the Account. For
   * example, if the expiryTime element is not specified, the current value is
   * replaced with the default value, not left unmodified. You can update a user
   * Account on a Compute Node only when it is in the idle or running state.
   */
  @summary("""
Updates the password and expiration time of a user Account on the specified
Compute Node.
""")
  @route("/pools/{poolId}/nodes/{nodeId}/users/{userName}")
  @put
  updateUser is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the machine on which you want to update a user Account.
       */
      @path
      nodeId: string;

      /**
       * The name of the user Account to update.
       */
      @path
      userName: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      parameters: NodeUpdateUserParameters;
    },
    void
  >;

  /**
   * Gets information about the specified Compute Node.
   */
  @summary("Gets information about the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node that you want to get information about.
       */
      @path
      nodeId: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    ComputeNode
  >;

  /**
   * You can restart a Compute Node only if it is in an idle or running state.
   */
  @summary("Restarts the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/reboot")
  @post
  reboot is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node that you want to restart.
       */
      @path
      nodeId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      parameters?: NodeRebootParameters;
    },
    void
  >;

  /**
   * You can reinstall the operating system on a Compute Node only if it is in an
   * idle or running state. This API can be invoked only on Pools created with the
   * cloud service configuration property.
   */
  @summary("Reinstalls the operating system on the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/reimage")
  @post
  reimage is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node that you want to restart.
       */
      @path
      nodeId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      parameters?: NodeReimageParameters;
    },
    void
  >;

  /**
   * You can disable Task scheduling on a Compute Node only if its current
   * scheduling state is enabled.
   */
  @summary("Disables Task scheduling on the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/disablescheduling")
  @post
  disableScheduling is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node on which you want to disable Task scheduling.
       */
      @path
      nodeId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * The parameters for the request.
       */
      @body
      parameters?: NodeDisableSchedulingParameters;
    },
    void
  >;

  /**
   * You can enable Task scheduling on a Compute Node only if its current scheduling
   * state is disabled
   */
  @summary("Enables Task scheduling on the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/enablescheduling")
  @post
  enableScheduling is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node on which you want to enable Task scheduling.
       */
      @path
      nodeId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    void
  >;

  /**
   * Before you can remotely login to a Compute Node using the remote login
   * settings, you must create a user Account on the Compute Node. This API can be
   * invoked only on Pools created with the virtual machine configuration property.
   * For Pools created with a cloud service configuration, see the GetRemoteDesktop
   * API.
   */
  @summary("Gets the settings required for remote login to a Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/remoteloginsettings")
  @get
  getRemoteLoginSettings is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node for which to obtain the remote login settings.
       */
      @path
      nodeId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    ComputeNodeGetRemoteLoginSettingsResult
  >;

  /**
   * Before you can access a Compute Node by using the RDP file, you must create a
   * user Account on the Compute Node. This API can only be invoked on Pools created
   * with a cloud service configuration. For Pools created with a virtual machine
   * configuration, see the GetRemoteLoginSettings API.
   */
  @summary("Gets the Remote Desktop Protocol file for the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/rdp")
  @get
  getRemoteDesktop is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node for which you want to get the Remote Desktop
       * Protocol file.
       */
      @path
      nodeId: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;

      /**
       * Accept header
       */
      @header
      accept: "application/json, application/octet-stream";
    },
    void
  >;

  /**
   * This is for gathering Azure Batch service log files in an automated fashion
   * from Compute Nodes if you are experiencing an error and wish to escalate to
   * Azure support. The Azure Batch service log files should be shared with Azure
   * support to aid in debugging issues with the Batch service.
   */
  @summary("""
Upload Azure Batch service log files from the specified Compute Node to Azure
Blob Storage.
""")
  uploadBatchServiceLogs is Azure.Core.ResourceCreateWithServiceProvidedName<
    UploadBatchServiceLogsResult,
    {
      parameters: {
        /**
         * The maximum time that the server can spend processing the request, in seconds.
         * The default is 30 seconds.
         */
        @query("timeout")
        timeout?: int32 = 30;

        /**
         * The caller-generated request identity, in the form of a GUID with no decoration
         * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
         */
        @header
        `client-request-id`?: string;

        /**
         * Whether the server should return the client-request-id in the response.
         */
        @header
        `return-client-request-id`?: boolean;

        /**
         * The time the request was issued. Client libraries typically set this to the
         * current system clock time; set it explicitly if you are calling the REST API
         * directly.
         */
        @header
        `ocp-date`?: utcDateTime;
      };
    }
  >;

  /**
   * Lists the Compute Nodes in the specified Pool.
   */
  @summary("Lists the Compute Nodes in the specified Pool.")
  @route("/pools/{poolId}/nodes")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool from which you want to list Compute Nodes.
       */
      @path
      poolId: string;

      /**
       * An OData $filter clause. For more information on constructing this filter, see
       * https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-nodes-in-a-pool.
       */
      @query("$filter")
      $filter?: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * The maximum number of items to return in the response. A maximum of 1000
       * Compute Nodes can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    ComputeNodeListResult
  >;
}

interface ComputeNodeExtensionOperations {
  /**
   * Gets information about the specified Compute Node Extension.
   */
  @summary("Gets information about the specified Compute Node Extension.")
  @route("/pools/{poolId}/nodes/{nodeId}/extensions/{extensionName}")
  @get
  get is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains the Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node that contains the extensions.
       */
      @path
      nodeId: string;

      /**
       * The name of the of the Compute Node Extension that you want to get information
       * about.
       */
      @path
      extensionName: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    NodeVMExtension
  >;

  /**
   * Lists the Compute Nodes Extensions in the specified Pool.
   */
  @summary("Lists the Compute Nodes Extensions in the specified Pool.")
  @route("/pools/{poolId}/nodes/{nodeId}/extensions")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The ID of the Pool that contains Compute Node.
       */
      @path
      poolId: string;

      /**
       * The ID of the Compute Node that you want to list extensions.
       */
      @path
      nodeId: string;

      /**
       * An OData $select clause.
       */
      @query("$select")
      $select?: string;

      /**
       * The maximum number of items to return in the response. A maximum of 1000
       * Compute Nodes can be returned.
       */
      @maxValue(1000)
      @minValue(1)
      @query("maxresults")
      maxResults?: int32 = 1000;

      /**
       * The maximum time that the server can spend processing the request, in seconds.
       * The default is 30 seconds.
       */
      @query("timeout")
      timeout?: int32 = 30;

      /**
       * The caller-generated request identity, in the form of a GUID with no decoration
       * such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
       */
      @header
      `client-request-id`?: string;

      /**
       * Whether the server should return the client-request-id in the response.
       */
      @header
      `return-client-request-id`?: boolean;

      /**
       * The time the request was issued. Client libraries typically set this to the
       * current system clock time; set it explicitly if you are calling the REST API
       * directly.
       */
      @header
      `ocp-date`?: utcDateTime;
    },
    NodeVMExtensionList
  >;
}
