import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Azure.Batch;

interface ApplicationOperations {
  @summary("Lists all of the applications available in the specified Account.")
  @doc("""
This operation returns only Applications and versions that are available for
use on Compute Nodes; that is, that can be used in an Package reference. For
administrator information about applications and versions that are not yet
available to Compute Nodes, use the Azure portal or the Azure Resource Manager
API.
""")
  List is Azure.Core.ResourceList<
    Application,
    {
      parameters: {
        @doc("""
The maximum number of items to return in the response. A maximum of 1000
applications can be returned.
""")
        @query
        maxresults: int32;

        @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
        @query
        timeout: int32;

        @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
        @header
        `client-request-id`: string;

        @doc("Whether the server should return the client-request-id in the response.")
        @header
        `return-client-request-id`: boolean;

        @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
        @header
        `ocp-date`: utcDateTime;
      };
    }
  >;

  @summary("Gets information about the specified Application.")
  @doc("""
This operation returns only Applications and versions that are available for
use on Compute Nodes; that is, that can be used in an Package reference. For
administrator information about Applications and versions that are not yet
available to Compute Nodes, use the Azure portal or the Azure Resource Manager
API.
""")
  Get is Azure.Core.ResourceRead<
    Application,
    {
      parameters: {
        @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
        @query
        timeout: int32;

        @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
        @header
        `client-request-id`: string;

        @doc("Whether the server should return the client-request-id in the response.")
        @header
        `return-client-request-id`: boolean;

        @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
        @header
        `ocp-date`: utcDateTime;
      };
    }
  >;
}

interface PoolOperations {
  @summary("""
Lists the usage metrics, aggregated by Pool across individual time intervals,
for the specified Account.
""")
  @doc("""
If you do not specify a $filter clause including a poolId, the response
includes all Pools that existed in the Account in the time range of the
returned aggregation intervals. If you do not specify a $filter clause
including a startTime or endTime these filters default to the start and end
times of the last aggregation interval currently available; that is, only the
last aggregation interval is returned.
""")
  ListUsageMetrics is Azure.Core.ResourceList<
    PoolUsageMetrics,
    {
      parameters: {
        @doc("""
The earliest time from which to include metrics. This must be at least two and
a half hours before the current time. If not specified this defaults to the
start time of the last aggregation interval currently available.
""")
        @query
        starttime: utcDateTime;

        @doc("""
The latest time from which to include metrics. This must be at least two hours
before the current time. If not specified this defaults to the end time of the
last aggregation interval currently available.
""")
        @query
        endtime: utcDateTime;

        @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-account-usage-metrics.
""")
        @query
        $filter: string;

        @doc("""
The maximum number of items to return in the response. A maximum of 1000
results will be returned.
""")
        @query
        maxresults: int32;

        @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
        @query
        timeout: int32;

        @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
        @header
        `client-request-id`: string;

        @doc("Whether the server should return the client-request-id in the response.")
        @header
        `return-client-request-id`: boolean;

        @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
        @header
        `ocp-date`: utcDateTime;
      };
    }
  >;

  @summary("Gets lifetime summary statistics for all of the Pools in the specified Account.")
  @doc("""
Statistics are aggregated across all Pools that have ever existed in the
Account, from Account creation to the last update time of the statistics. The
statistics may not be immediately available. The Batch service performs
periodic roll-up of statistics. The typical delay is about 30 minutes.
""")
  @route("/lifetimepoolstats")
  @get
  GetAllLifetimeStatistics is Azure.Core.Foundations.Operation<
    {
      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    PoolStatistics
  >;

  @summary("Adds a Pool to the specified Account.")
  @doc("""
When naming Pools, avoid including sensitive information such as user names or
secret project names. This information may appear in telemetry logs accessible
to Microsoft Support engineers.
""")
  @route("/pools")
  @post
  Add is Azure.Core.Foundations.Operation<
    {
      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The Pool to be added.")
      @body
      pool: BatchPool;
    },
    void
  >;

  @summary("Lists all of the Pools in the specified Account.")
  @doc("Lists all of the Pools in the specified Account.")
  @route("/pools")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-pools.
""")
      @query
      $filter: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("An OData $expand clause.")
      @query
      $expand: string;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000 Pools
can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    BatchPoolListResult
  >;

  @summary("Deletes a Pool from the specified Account.")
  @doc("""
When you request that a Pool be deleted, the following actions occur: the Pool
state is set to deleting; any ongoing resize operation on the Pool are stopped;
the Batch service starts resizing the Pool to zero Compute Nodes; any Tasks
running on existing Compute Nodes are terminated and requeued (as if a resize
Pool operation had been requested with the default requeue option); finally,
the Pool is removed from the system. Because running Tasks are requeued, the
user can rerun these Tasks by updating their Job to target a different Pool.
The Tasks can then run on the new Pool. If you want to override the requeue
behavior, then you should call resize Pool explicitly to shrink the Pool to
zero size before deleting the Pool. If you call an Update, Patch or Delete API
on a Pool in the deleting state, it will fail with HTTP status code 409 with
error code PoolBeingDeleted.
""")
  @route("/pools/{poolId}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool to delete.")
      @path
      poolId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @doc("Gets basic properties of a Pool.")
  @route("/pools/{poolId}")
  @head
  Exists is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool to get.")
      @path
      poolId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @doc("Gets information about the specified Pool.")
  @route("/pools/{poolId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool to get.")
      @path
      poolId: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("An OData $expand clause.")
      @query
      $expand: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    BatchPool
  >;

  @summary("Updates the properties of the specified Pool.")
  @doc("""
This only replaces the Pool properties specified in the request. For example,
if the Pool has a StartTask associated with it, and a request does not specify
a StartTask element, then the Pool keeps the existing StartTask.
""")
  @route("/pools/{poolId}")
  @patch
  Patch is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool to update.")
      @path
      poolId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      poolUpdate: BatchPoolUpdate;
    },
    void
  >;

  @summary("Disables automatic scaling for a Pool.")
  @doc("Disables automatic scaling for a Pool.")
  @route("/pools/{poolId}/disableautoscale")
  @post
  DisableAutoScale is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool on which to disable automatic scaling.")
      @path
      poolId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    void
  >;

  @summary("Enables automatic scaling for a Pool.")
  @doc("""
You cannot enable automatic scaling on a Pool if a resize operation is in
progress on the Pool. If automatic scaling of the Pool is currently disabled,
you must specify a valid autoscale formula as part of the request. If automatic
scaling of the Pool is already enabled, you may specify a new autoscale formula
and/or a new evaluation interval. You cannot call this API for the same Pool
more than once every 30 seconds.
""")
  @route("/pools/{poolId}/enableautoscale")
  @post
  EnableAutoScale is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool on which to enable automatic scaling.")
      @path
      poolId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      parameters: BatchPoolEnableAutoScaleParameters;
    },
    void
  >;

  @summary("Gets the result of evaluating an automatic scaling formula on the Pool.")
  @doc("""
This API is primarily for validating an autoscale formula, as it simply returns
the result without applying the formula to the Pool. The Pool must have auto
scaling enabled in order to evaluate a formula.
""")
  @route("/pools/{poolId}/evaluateautoscale")
  @post
  EvaluateAutoScale is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool on which to evaluate the automatic scaling formula.")
      @path
      poolId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      parameters: BatchPoolEvaluateAutoScaleParameters;
    },
    AutoScaleRun
  >;

  @summary("Changes the number of Compute Nodes that are assigned to a Pool.")
  @doc("""
You can only resize a Pool when its allocation state is steady. If the Pool is
already resizing, the request fails with status code 409. When you resize a
Pool, the Pool's allocation state changes from steady to resizing. You cannot
resize Pools which are configured for automatic scaling. If you try to do this,
the Batch service returns an error 409. If you resize a Pool downwards, the
Batch service chooses which Compute Nodes to remove. To remove specific Compute
Nodes, use the Pool remove Compute Nodes API instead.
""")
  @route("/pools/{poolId}/resize")
  @post
  Resize is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool to resize.")
      @path
      poolId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      parameters: BatchPoolResizeParameters;
    },
    void
  >;

  @summary("Stops an ongoing resize operation on the Pool.")
  @doc("""
This does not restore the Pool to its previous state before the resize
operation: it only stops any further changes being made, and the Pool maintains
its current state. After stopping, the Pool stabilizes at the number of Compute
Nodes it was at when the stop operation was done. During the stop operation,
the Pool allocation state changes first to stopping and then to steady. A
resize operation need not be an explicit resize Pool request; this API can also
be used to halt the initial sizing of the Pool when it is created.
""")
  @route("/pools/{poolId}/stopresize")
  @post
  StopResize is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool whose resizing you want to stop.")
      @path
      poolId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("Updates the properties of the specified Pool.")
  @doc("""
This fully replaces all the updatable properties of the Pool. For example, if
the Pool has a StartTask associated with it and if StartTask is not specified
with this request, then the Batch service will remove the existing StartTask.
""")
  @route("/pools/{poolId}/updateproperties")
  @post
  UpdateProperties is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool to update.")
      @path
      poolId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      poolUpdatePropertiesParameter: BatchPool;
    },
    void
  >;

  @summary("Removes Compute Nodes from the specified Pool.")
  @doc("""
This operation can only run when the allocation state of the Pool is steady.
When this operation runs, the allocation state changes from steady to resizing.
Each request may remove up to 100 nodes.
""")
  @route("/pools/{poolId}/removenodes")
  @post
  RemoveNodes is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool from which you want to remove Compute Nodes.")
      @path
      poolId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      parameters: NodeRemoveParameters;
    },
    void
  >;
}

interface AccountOperations {
  @summary("Lists all Virtual Machine Images supported by the Azure Batch service.")
  @doc("Lists all Virtual Machine Images supported by the Azure Batch service.")
  ListSupportedImages is Azure.Core.ResourceList<
    ImageInformation,
    {
      parameters: {
        @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-support-images.
""")
        @query
        $filter: string;

        @doc("""
The maximum number of items to return in the response. A maximum of 1000
results will be returned.
""")
        @query
        maxresults: int32;

        @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
        @query
        timeout: int32;

        @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
        @header
        `client-request-id`: string;

        @doc("Whether the server should return the client-request-id in the response.")
        @header
        `return-client-request-id`: boolean;

        @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
        @header
        `ocp-date`: utcDateTime;
      };
    }
  >;

  @doc("""
Gets the number of Compute Nodes in each state, grouped by Pool. Note that the
numbers returned may not always be up to date. If you need exact node counts,
use a list query.
""")
  ListPoolNodeCounts is Azure.Core.ResourceList<
    PoolNodeCounts,
    {
      parameters: {
        @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch.
""")
        @query
        $filter: string;

        @doc("The maximum number of items to return in the response.")
        @query
        maxresults: int32;

        @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
        @query
        timeout: int32;

        @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
        @header
        `client-request-id`: string;

        @doc("Whether the server should return the client-request-id in the response.")
        @header
        `return-client-request-id`: boolean;

        @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
        @header
        `ocp-date`: utcDateTime;
      };
    }
  >;
}

interface JobOperations {
  @summary("Gets lifetime summary statistics for all of the Jobs in the specified Account.")
  @doc("""
Statistics are aggregated across all Jobs that have ever existed in the
Account, from Account creation to the last update time of the statistics. The
statistics may not be immediately available. The Batch service performs
periodic roll-up of statistics. The typical delay is about 30 minutes.
""")
  @route("/lifetimejobstats")
  @get
  GetAllLifetimeStatistics is Azure.Core.Foundations.Operation<
    {
      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    JobStatistics
  >;

  @summary("Deletes a Job.")
  @doc("""
Deleting a Job also deletes all Tasks that are part of that Job, and all Job
statistics. This also overrides the retention period for Task data; that is, if
the Job contains Tasks which are still retained on Compute Nodes, the Batch
services deletes those Tasks' working directories and all their contents.  When
a Delete Job request is received, the Batch service sets the Job to the
deleting state. All update operations on a Job that is in deleting state will
fail with status code 409 (Conflict), with additional information indicating
that the Job is being deleted.
""")
  @route("/jobs/{jobId}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job to delete.")
      @path
      jobId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("Gets information about the specified Job.")
  @doc("Gets information about the specified Job.")
  @route("/jobs/{jobId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job.")
      @path
      jobId: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("An OData $expand clause.")
      @query
      $expand: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    BatchJob
  >;

  @summary("Updates the properties of the specified Job.")
  @doc("""
This replaces only the Job properties specified in the request. For example, if
the Job has constraints, and a request does not specify the constraints
element, then the Job keeps the existing constraints.
""")
  @route("/jobs/{jobId}")
  @patch
  Patch is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job whose properties you want to update.")
      @path
      jobId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      jobUpdate: BatchJobUpdate;
    },
    void
  >;

  @summary("Updates the properties of the specified Job.")
  @doc("""
This fully replaces all the updatable properties of the Job. For example, if
the Job has constraints associated with it and if constraints is not specified
with this request, then the Batch service will remove the existing constraints.
""")
  @route("/jobs/{jobId}")
  @put
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job whose properties you want to update.")
      @path
      jobId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      job: BatchJob;
    },
    void
  >;

  @summary("Disables the specified Job, preventing new Tasks from running.")
  @doc("""
The Batch Service immediately moves the Job to the disabling state. Batch then
uses the disableTasks parameter to determine what to do with the currently
running Tasks of the Job. The Job remains in the disabling state until the
disable operation is completed and all Tasks have been dealt with according to
the disableTasks option; the Job then moves to the disabled state. No new Tasks
are started under the Job until it moves back to active state. If you try to
disable a Job that is in any state other than active, disabling, or disabled,
the request fails with status code 409.
""")
  @route("/jobs/{jobId}/disable")
  @post
  Disable is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job to disable.")
      @path
      jobId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      parameters: BatchJobDisableParameters;
    },
    void
  >;

  @summary("Enables the specified Job, allowing new Tasks to run.")
  @doc("""
When you call this API, the Batch service sets a disabled Job to the enabling
state. After the this operation is completed, the Job moves to the active
state, and scheduling of new Tasks under the Job resumes. The Batch service
does not allow a Task to remain in the active state for more than 180 days.
Therefore, if you enable a Job containing active Tasks which were added more
than 180 days ago, those Tasks will not run.
""")
  @route("/jobs/{jobId}/enable")
  @post
  Enable is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job to enable.")
      @path
      jobId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("Terminates the specified Job, marking it as completed.")
  @doc("""
When a Terminate Job request is received, the Batch service sets the Job to the
terminating state. The Batch service then terminates any running Tasks
associated with the Job and runs any required Job release Tasks. Then the Job
moves into the completed state. If there are any Tasks in the Job in the active
state, they will remain in the active state. Once a Job is terminated, new
Tasks cannot be added and any remaining active Tasks will not be scheduled.
""")
  @route("/jobs/{jobId}/terminate")
  @post
  Terminate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job to terminate.")
      @path
      jobId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      parameters: BatchJobTerminateParameters;
    },
    void
  >;

  @summary("Adds a Job to the specified Account.")
  @doc("""
The Batch service supports two ways to control the work done as part of a Job.
In the first approach, the user specifies a Job Manager Task. The Batch service
launches this Task when it is ready to start the Job. The Job Manager Task
controls all other Tasks that run under this Job, by using the Task APIs. In
the second approach, the user directly controls the execution of Tasks under an
active Job, by using the Task APIs. Also note: when naming Jobs, avoid
including sensitive information such as user names or secret project names.
This information may appear in telemetry logs accessible to Microsoft Support
engineers.
""")
  @route("/jobs")
  @post
  Add is Azure.Core.Foundations.Operation<
    {
      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The Job to be added.")
      @body
      job: BatchJob;
    },
    void
  >;

  @summary("Lists all of the Jobs in the specified Account.")
  @doc("Lists all of the Jobs in the specified Account.")
  @route("/jobs")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs.
""")
      @query
      $filter: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("An OData $expand clause.")
      @query
      $expand: string;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000 Jobs
can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    BatchJobListResult
  >;

  @summary("Lists the Jobs that have been created under the specified Job Schedule.")
  @doc("Lists the Jobs that have been created under the specified Job Schedule.")
  @route("/jobschedules/{jobScheduleId}/jobs")
  @get
  ListFromJobSchedule is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job Schedule from which you want to get a list of Jobs.")
      @path
      jobScheduleId: string;

      @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-jobs-in-a-job-schedule.
""")
      @query
      $filter: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("An OData $expand clause.")
      @query
      $expand: string;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000 Jobs
can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    BatchJobListResult
  >;

  @summary("""
Lists the execution status of the Job Preparation and Job Release Task for the
specified Job across the Compute Nodes where the Job has run.
""")
  @doc("""
This API returns the Job Preparation and Job Release Task status on all Compute
Nodes that have run the Job Preparation or Job Release Task. This includes
Compute Nodes which have since been removed from the Pool. If this API is
invoked on a Job which has no Job Preparation or Job Release Task, the Batch
service returns HTTP status code 409 (Conflict) with an error code of
JobPreparationTaskNotSpecified.
""")
  @route("/jobs/{jobId}/jobpreparationandreleasetaskstatus")
  @get
  ListPreparationAndReleaseTaskStatus is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job.")
      @path
      jobId: string;

      @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-preparation-and-release-status.
""")
      @query
      $filter: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000 Tasks
can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    BatchJobListPreparationAndReleaseTaskStatusResult
  >;

  @summary("Gets the Task counts for the specified Job.")
  @doc("""
Task counts provide a count of the Tasks by active, running or completed Task
state, and a count of Tasks which succeeded or failed. Tasks in the preparing
state are counted as running. Note that the numbers returned may not always be
up to date. If you need exact task counts, use a list query.
""")
  @route("/jobs/{jobId}/taskcounts")
  @get
  GetTaskCounts is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job.")
      @path
      jobId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    TaskCountsResult
  >;
}

interface CertificateOperations {
  @summary("Adds a Certificate to the specified Account.")
  @doc("Adds a Certificate to the specified Account.")
  @route("/certificates")
  @post
  Add is Azure.Core.Foundations.Operation<
    {
      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The Certificate to be added.")
      @body
      certificate: Certificate;
    },
    void
  >;

  @summary("Lists all of the Certificates that have been added to the specified Account.")
  @doc("Lists all of the Certificates that have been added to the specified Account.")
  @route("/certificates")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-certificates.
""")
      @query
      $filter: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000
Certificates can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    CertificateListResult
  >;

  @summary("Cancels a failed deletion of a Certificate from the specified Account.")
  @doc("""
If you try to delete a Certificate that is being used by a Pool or Compute
Node, the status of the Certificate changes to deleteFailed. If you decide that
you want to continue using the Certificate, you can use this operation to set
the status of the Certificate back to active. If you intend to delete the
Certificate, you do not need to run this operation after the deletion failed.
You must make sure that the Certificate is not being used by any resources, and
then you can try again to delete the Certificate.
""")
  @route("/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})/canceldelete")
  @post
  CancelDeletion is Azure.Core.Foundations.Operation<
    {
      @doc("The algorithm used to derive the thumbprint parameter. This must be sha1.")
      @path
      thumbprintAlgorithm: string;

      @doc("The thumbprint of the Certificate being deleted.")
      @path
      thumbprint: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    void
  >;

  @summary("Deletes a Certificate from the specified Account.")
  @doc("""
You cannot delete a Certificate if a resource (Pool or Compute Node) is using
it. Before you can delete a Certificate, you must therefore make sure that the
Certificate is not associated with any existing Pools, the Certificate is not
installed on any Nodes (even if you remove a Certificate from a Pool, it is not
removed from existing Compute Nodes in that Pool until they restart), and no
running Tasks depend on the Certificate. If you try to delete a Certificate
that is in use, the deletion fails. The Certificate status changes to
deleteFailed. You can use Cancel Delete Certificate to set the status back to
active if you decide that you want to continue using the Certificate.
""")
  @route("/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The algorithm used to derive the thumbprint parameter. This must be sha1.")
      @path
      thumbprintAlgorithm: string;

      @doc("The thumbprint of the Certificate to be deleted.")
      @path
      thumbprint: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    void
  >;

  @doc("Gets information about the specified Certificate.")
  @route("/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The algorithm used to derive the thumbprint parameter. This must be sha1.")
      @path
      thumbprintAlgorithm: string;

      @doc("The thumbprint of the Certificate to get.")
      @path
      thumbprint: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    Certificate
  >;
}

interface FileOperations {
  @summary("Deletes the specified Task file from the Compute Node where the Task ran.")
  @doc("Deletes the specified Task file from the Compute Node where the Task ran.")
  @route("/jobs/{jobId}/tasks/{taskId}/files/{filePath}")
  @delete
  DeleteFromTask is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job that contains the Task.")
      @path
      jobId: string;

      @doc("The ID of the Task whose file you want to delete.")
      @path
      taskId: string;

      @doc("The path to the Task file or directory that you want to delete.")
      @path
      filePath: string;

      @doc("""
Whether to delete children of a directory. If the filePath parameter represents
a directory instead of a file, you can set recursive to true to delete the
directory and all of the files and subdirectories in it. If recursive is false
then the directory must be empty or deletion will fail.
""")
      @query
      recursive: boolean;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    void
  >;

  @doc("Returns the content of the specified Task file.")
  @route("/jobs/{jobId}/tasks/{taskId}/files/{filePath}")
  @get
  GetFromTask is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job that contains the Task.")
      @path
      jobId: string;

      @doc("The ID of the Task whose file you want to retrieve.")
      @path
      taskId: string;

      @doc("The path to the Task file that you want to get the content of.")
      @path
      filePath: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
The byte range to be retrieved. The default is to retrieve the entire file. The
format is bytes=startRange-endRange.
""")
      @header
      `ocp-range`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("Accept header")
      @header
      Accept: "application/json, application/octet-stream";
    },
    void
  >;

  @doc("Gets the properties of the specified Task file.")
  @route("/jobs/{jobId}/tasks/{taskId}/files/{filePath}")
  @head
  GetPropertiesFromTask is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job that contains the Task.")
      @path
      jobId: string;

      @doc("The ID of the Task whose file you want to get the properties of.")
      @path
      taskId: string;

      @doc("The path to the Task file that you want to get the properties of.")
      @path
      filePath: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("Deletes the specified file from the Compute Node.")
  @doc("Deletes the specified file from the Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/files/{filePath}")
  @delete
  DeleteFromComputeNode is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node from which you want to delete the file.")
      @path
      nodeId: string;

      @doc("The path to the file or directory that you want to delete.")
      @path
      filePath: string;

      @doc("""
Whether to delete children of a directory. If the filePath parameter represents
a directory instead of a file, you can set recursive to true to delete the
directory and all of the files and subdirectories in it. If recursive is false
then the directory must be empty or deletion will fail.
""")
      @query
      recursive: boolean;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    void
  >;

  @doc("Returns the content of the specified Compute Node file.")
  @route("/pools/{poolId}/nodes/{nodeId}/files/{filePath}")
  @get
  GetFromComputeNode is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node that contains the file.")
      @path
      nodeId: string;

      @doc("The path to the Compute Node file that you want to get the content of.")
      @path
      filePath: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
The byte range to be retrieved. The default is to retrieve the entire file. The
format is bytes=startRange-endRange.
""")
      @header
      `ocp-range`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("Accept header")
      @header
      Accept: "application/json, application/octet-stream";
    },
    void
  >;

  @doc("Gets the properties of the specified Compute Node file.")
  @route("/pools/{poolId}/nodes/{nodeId}/files/{filePath}")
  @head
  GetPropertiesFromComputeNode is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node that contains the file.")
      @path
      nodeId: string;

      @doc("The path to the Compute Node file that you want to get the properties of.")
      @path
      filePath: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("Lists the files in a Task's directory on its Compute Node.")
  @doc("Lists the files in a Task's directory on its Compute Node.")
  @route("/jobs/{jobId}/tasks/{taskId}/files")
  @get
  ListFromTask is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job that contains the Task.")
      @path
      jobId: string;

      @doc("The ID of the Task whose files you want to list.")
      @path
      taskId: string;

      @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-task-files.
""")
      @query
      $filter: string;

      @doc("""
Whether to list children of the Task directory. This parameter can be used in
combination with the filter parameter to list specific type of files.
""")
      @query
      recursive: boolean;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000 files
can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    NodeFileListResult
  >;

  @summary("Lists all of the files in Task directories on the specified Compute Node.")
  @doc("Lists all of the files in Task directories on the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}/files")
  @get
  ListFromComputeNode is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node whose files you want to list.")
      @path
      nodeId: string;

      @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-compute-node-files.
""")
      @query
      $filter: string;

      @doc("Whether to list children of a directory.")
      @query
      recursive: boolean;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000 files
can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    NodeFileListResult
  >;
}

interface JobScheduleOperations {
  @summary("Checks the specified Job Schedule exists.")
  @doc("Checks the specified Job Schedule exists.")
  @route("/jobschedules/{jobScheduleId}")
  @head
  Exists is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job Schedule which you want to check.")
      @path
      jobScheduleId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("Deletes a Job Schedule from the specified Account.")
  @doc("""
When you delete a Job Schedule, this also deletes all Jobs and Tasks under that
schedule. When Tasks are deleted, all the files in their working directories on
the Compute Nodes are also deleted (the retention period is ignored). The Job
Schedule statistics are no longer accessible once the Job Schedule is deleted,
though they are still counted towards Account lifetime statistics.
""")
  @route("/jobschedules/{jobScheduleId}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job Schedule to delete.")
      @path
      jobScheduleId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @doc("Gets information about the specified Job Schedule.")
  @route("/jobschedules/{jobScheduleId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job Schedule to get.")
      @path
      jobScheduleId: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("An OData $expand clause.")
      @query
      $expand: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    BatchJobSchedule
  >;

  @summary("Updates the properties of the specified Job Schedule.")
  @doc("""
This replaces only the Job Schedule properties specified in the request. For
example, if the schedule property is not specified with this request, then the
Batch service will keep the existing schedule. Changes to a Job Schedule only
impact Jobs created by the schedule after the update has taken place; currently
running Jobs are unaffected.
""")
  @route("/jobschedules/{jobScheduleId}")
  @patch
  Patch is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job Schedule to update.")
      @path
      jobScheduleId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      jobScheduleUpdate: BatchJobScheduleUpdate;
    },
    void
  >;

  @summary("Updates the properties of the specified Job Schedule.")
  @doc("""
This fully replaces all the updatable properties of the Job Schedule. For
example, if the schedule property is not specified with this request, then the
Batch service will remove the existing schedule. Changes to a Job Schedule only
impact Jobs created by the schedule after the update has taken place; currently
running Jobs are unaffected.
""")
  @route("/jobschedules/{jobScheduleId}")
  @put
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job Schedule to update.")
      @path
      jobScheduleId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      jobSchedule: BatchJobSchedule;
    },
    void
  >;

  @summary("Disables a Job Schedule.")
  @doc("No new Jobs will be created until the Job Schedule is enabled again.")
  @route("/jobschedules/{jobScheduleId}/disable")
  @post
  Disable is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job Schedule to disable.")
      @path
      jobScheduleId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("Enables a Job Schedule.")
  @doc("Enables a Job Schedule.")
  @route("/jobschedules/{jobScheduleId}/enable")
  @post
  Enable is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job Schedule to enable.")
      @path
      jobScheduleId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("Terminates a Job Schedule.")
  @doc("Terminates a Job Schedule.")
  @route("/jobschedules/{jobScheduleId}/terminate")
  @post
  Terminate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job Schedule to terminates.")
      @path
      jobScheduleId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("Adds a Job Schedule to the specified Account.")
  @doc("Adds a Job Schedule to the specified Account.")
  @route("/jobschedules")
  @post
  Add is Azure.Core.Foundations.Operation<
    {
      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The Job Schedule to be added.")
      @body
      jobSchedule: BatchJobSchedule;
    },
    void
  >;

  @summary("Lists all of the Job Schedules in the specified Account.")
  @doc("Lists all of the Job Schedules in the specified Account.")
  @route("/jobschedules")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-job-schedules.
""")
      @query
      $filter: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("An OData $expand clause.")
      @query
      $expand: string;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000 Job
Schedules can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    BatchJobScheduleListResult
  >;
}

interface TaskOperations {
  @summary("Adds a Task to the specified Job.")
  @doc("""
The maximum lifetime of a Task from addition to completion is 180 days. If a
Task has not completed within 180 days of being added it will be terminated by
the Batch service and left in whatever state it was in at that time.
""")
  @route("/jobs/{jobId}/tasks")
  @post
  Add is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job to which the Task is to be added.")
      @path
      jobId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The Task to be added.")
      @body
      task: BatchTask;
    },
    void
  >;

  @summary("Lists all of the Tasks that are associated with the specified Job.")
  @doc("""
For multi-instance Tasks, information such as affinityId, executionInfo and
nodeInfo refer to the primary Task. Use the list subtasks API to retrieve
information about subtasks.
""")
  @route("/jobs/{jobId}/tasks")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job.")
      @path
      jobId: string;

      @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-tasks.
""")
      @query
      $filter: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("An OData $expand clause.")
      @query
      $expand: string;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000 Tasks
can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    BatchTaskListResult
  >;

  @summary("Adds a collection of Tasks to the specified Job.")
  @doc("""
Note that each Task must have a unique ID. The Batch service may not return the
results for each Task in the same order the Tasks were submitted in this
request. If the server times out or the connection is closed during the
request, the request may have been partially or fully processed, or not at all.
In such cases, the user should re-issue the request. Note that it is up to the
user to correctly handle failures when re-issuing a request. For example, you
should use the same Task IDs during a retry so that if the prior operation
succeeded, the retry will not create extra Tasks unexpectedly. If the response
contains any Tasks which failed to add, a client can retry the request. In a
retry, it is most efficient to resubmit only Tasks that failed to add, and to
omit Tasks that were successfully added on the first attempt. The maximum
lifetime of a Task from addition to completion is 180 days. If a Task has not
completed within 180 days of being added it will be terminated by the Batch
service and left in whatever state it was in at that time.
""")
  @route("/jobs/{jobId}/addtaskcollection")
  @post
  AddCollection is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job to which the Task collection is to be added.")
      @path
      jobId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The Tasks to be added.")
      @body
      taskCollection: BatchTaskCollection;
    },
    TaskAddCollectionResult
  >;

  @summary("Deletes a Task from the specified Job.")
  @doc("""
When a Task is deleted, all of the files in its directory on the Compute Node
where it ran are also deleted (regardless of the retention time). For
multi-instance Tasks, the delete Task operation applies synchronously to the
primary task; subtasks and their files are then deleted asynchronously in the
background.
""")
  @route("/jobs/{jobId}/tasks/{taskId}")
  @delete
  Delete is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job from which to delete the Task.")
      @path
      jobId: string;

      @doc("The ID of the Task to delete.")
      @path
      taskId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("Gets information about the specified Task.")
  @doc("""
For multi-instance Tasks, information such as affinityId, executionInfo and
nodeInfo refer to the primary Task. Use the list subtasks API to retrieve
information about subtasks.
""")
  @route("/jobs/{jobId}/tasks/{taskId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job that contains the Task.")
      @path
      jobId: string;

      @doc("The ID of the Task to get information about.")
      @path
      taskId: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("An OData $expand clause.")
      @query
      $expand: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    BatchTask
  >;

  @doc("Updates the properties of the specified Task.")
  @route("/jobs/{jobId}/tasks/{taskId}")
  @put
  Update is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job containing the Task.")
      @path
      jobId: string;

      @doc("The ID of the Task to update.")
      @path
      taskId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      task: BatchTask;
    },
    void
  >;

  @summary("""
Lists all of the subtasks that are associated with the specified multi-instance
Task.
""")
  @doc("If the Task is not a multi-instance Task then this returns an empty collection.")
  @route("/jobs/{jobId}/tasks/{taskId}/subtasksinfo")
  @get
  ListSubtasks is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job.")
      @path
      jobId: string;

      @doc("The ID of the Task.")
      @path
      taskId: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    BatchTaskListSubtasksResult
  >;

  @summary("Terminates the specified Task.")
  @doc("""
When the Task has been terminated, it moves to the completed state. For
multi-instance Tasks, the terminate Task operation applies synchronously to the
primary task; subtasks are then terminated asynchronously in the background.
""")
  @route("/jobs/{jobId}/tasks/{taskId}/terminate")
  @post
  Terminate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job containing the Task.")
      @path
      jobId: string;

      @doc("The ID of the Task to terminate.")
      @path
      taskId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;

  @summary("""
Reactivates a Task, allowing it to run again even if its retry count has been
exhausted.
""")
  @doc("""
Reactivation makes a Task eligible to be retried again up to its maximum retry
count. The Task's state is changed to active. As the Task is no longer in the
completed state, any previous exit code or failure information is no longer
available after reactivation. Each time a Task is reactivated, its retry count
is reset to 0. Reactivation will fail for Tasks that are not completed or that
previously completed successfully (with an exit code of 0). Additionally, it
will fail if the Job has completed (or is terminating or deleting).
""")
  @route("/jobs/{jobId}/tasks/{taskId}/reactivate")
  @post
  Reactivate is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Job containing the Task.")
      @path
      jobId: string;

      @doc("The ID of the Task to reactivate.")
      @path
      taskId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service exactly matches the value specified by the client.
""")
      @header
      `If-Match`: string;

      @doc("""
An ETag value associated with the version of the resource known to the client.
The operation will be performed only if the resource's current ETag on the
service does not match the value specified by the client.
""")
      @header
      `If-None-Match`: string;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
been modified since the specified time.
""")
      @header
      `If-Modified-Since`: utcDateTime;

      @doc("""
A timestamp indicating the last modified time of the resource known to the
client. The operation will be performed only if the resource on the service has
not been modified since the specified time.
""")
      @header
      `If-Unmodified-Since`: utcDateTime;
    },
    void
  >;
}

interface ComputeNodeOperations {
  @summary("Adds a user Account to the specified Compute Node.")
  @doc("""
You can add a user Account to a Compute Node only when it is in the idle or
running state.
""")
  @route("/pools/{poolId}/nodes/{nodeId}/users")
  @post
  AddUser is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the machine on which you want to create a user Account.")
      @path
      nodeId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The user Account to be created.")
      @body
      user: ComputeNodeUser;
    },
    void
  >;

  @summary("Deletes a user Account from the specified Compute Node.")
  @doc("""
You can delete a user Account to a Compute Node only when it is in the idle or
running state.
""")
  @route("/pools/{poolId}/nodes/{nodeId}/users/{userName}")
  @delete
  DeleteUser is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the machine on which you want to delete a user Account.")
      @path
      nodeId: string;

      @doc("The name of the user Account to delete.")
      @path
      userName: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    void
  >;

  @summary("""
Updates the password and expiration time of a user Account on the specified
Compute Node.
""")
  @doc("""
This operation replaces of all the updatable properties of the Account. For
example, if the expiryTime element is not specified, the current value is
replaced with the default value, not left unmodified. You can update a user
Account on a Compute Node only when it is in the idle or running state.
""")
  @route("/pools/{poolId}/nodes/{nodeId}/users/{userName}")
  @put
  UpdateUser is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the machine on which you want to update a user Account.")
      @path
      nodeId: string;

      @doc("The name of the user Account to update.")
      @path
      userName: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      parameters: NodeUpdateUserParameters;
    },
    void
  >;

  @summary("Gets information about the specified Compute Node.")
  @doc("Gets information about the specified Compute Node.")
  @route("/pools/{poolId}/nodes/{nodeId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node that you want to get information about.")
      @path
      nodeId: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    ComputeNode
  >;

  @summary("Restarts the specified Compute Node.")
  @doc("You can restart a Compute Node only if it is in an idle or running state.")
  @route("/pools/{poolId}/nodes/{nodeId}/reboot")
  @post
  Reboot is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node that you want to restart.")
      @path
      nodeId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      parameters: NodeRebootParameters;
    },
    void
  >;

  @summary("Reinstalls the operating system on the specified Compute Node.")
  @doc("""
You can reinstall the operating system on a Compute Node only if it is in an
idle or running state. This API can be invoked only on Pools created with the
cloud service configuration property.
""")
  @route("/pools/{poolId}/nodes/{nodeId}/reimage")
  @post
  Reimage is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node that you want to restart.")
      @path
      nodeId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      parameters: NodeReimageParameters;
    },
    void
  >;

  @summary("Disables Task scheduling on the specified Compute Node.")
  @doc("""
You can disable Task scheduling on a Compute Node only if its current
scheduling state is enabled.
""")
  @route("/pools/{poolId}/nodes/{nodeId}/disablescheduling")
  @post
  DisableScheduling is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node on which you want to disable Task scheduling.")
      @path
      nodeId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("The parameters for the request.")
      @body
      parameters: NodeDisableSchedulingParameters;
    },
    void
  >;

  @summary("Enables Task scheduling on the specified Compute Node.")
  @doc("""
You can enable Task scheduling on a Compute Node only if its current scheduling
state is disabled
""")
  @route("/pools/{poolId}/nodes/{nodeId}/enablescheduling")
  @post
  EnableScheduling is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node on which you want to enable Task scheduling.")
      @path
      nodeId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    void
  >;

  @summary("Gets the settings required for remote login to a Compute Node.")
  @doc("""
Before you can remotely login to a Compute Node using the remote login
settings, you must create a user Account on the Compute Node. This API can be
invoked only on Pools created with the virtual machine configuration property.
For Pools created with a cloud service configuration, see the GetRemoteDesktop
API.
""")
  @route("/pools/{poolId}/nodes/{nodeId}/remoteloginsettings")
  @get
  GetRemoteLoginSettings is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node for which to obtain the remote login settings.")
      @path
      nodeId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    ComputeNodeGetRemoteLoginSettingsResult
  >;

  @summary("Gets the Remote Desktop Protocol file for the specified Compute Node.")
  @doc("""
Before you can access a Compute Node by using the RDP file, you must create a
user Account on the Compute Node. This API can only be invoked on Pools created
with a cloud service configuration. For Pools created with a virtual machine
configuration, see the GetRemoteLoginSettings API.
""")
  @route("/pools/{poolId}/nodes/{nodeId}/rdp")
  @get
  GetRemoteDesktop is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("""
The ID of the Compute Node for which you want to get the Remote Desktop
Protocol file.
""")
      @path
      nodeId: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;

      @doc("Accept header")
      @header
      Accept: "application/json, application/octet-stream";
    },
    void
  >;

  @summary("""
Upload Azure Batch service log files from the specified Compute Node to Azure
Blob Storage.
""")
  @doc("""
This is for gathering Azure Batch service log files in an automated fashion
from Compute Nodes if you are experiencing an error and wish to escalate to
Azure support. The Azure Batch service log files should be shared with Azure
support to aid in debugging issues with the Batch service.
""")
  UploadBatchServiceLogs is Azure.Core.ResourceCreateWithServiceProvidedName<
    UploadBatchServiceLogsResult,
    {
      parameters: {
        @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
        @query
        timeout: int32;

        @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
        @header
        `client-request-id`: string;

        @doc("Whether the server should return the client-request-id in the response.")
        @header
        `return-client-request-id`: boolean;

        @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
        @header
        `ocp-date`: utcDateTime;
      };
    }
  >;

  @summary("Lists the Compute Nodes in the specified Pool.")
  @doc("Lists the Compute Nodes in the specified Pool.")
  @route("/pools/{poolId}/nodes")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool from which you want to list Compute Nodes.")
      @path
      poolId: string;

      @doc("""
An OData $filter clause. For more information on constructing this filter, see
https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-nodes-in-a-pool.
""")
      @query
      $filter: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000
Compute Nodes can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    ComputeNodeListResult
  >;
}

interface ComputeNodeExtensionOperations {
  @summary("Gets information about the specified Compute Node Extension.")
  @doc("Gets information about the specified Compute Node Extension.")
  @route("/pools/{poolId}/nodes/{nodeId}/extensions/{extensionName}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains the Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node that contains the extensions.")
      @path
      nodeId: string;

      @doc("""
The name of the of the Compute Node Extension that you want to get information
about.
""")
      @path
      extensionName: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    NodeVMExtension
  >;

  @summary("Lists the Compute Nodes Extensions in the specified Pool.")
  @doc("Lists the Compute Nodes Extensions in the specified Pool.")
  @route("/pools/{poolId}/nodes/{nodeId}/extensions")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the Pool that contains Compute Node.")
      @path
      poolId: string;

      @doc("The ID of the Compute Node that you want to list extensions.")
      @path
      nodeId: string;

      @doc("An OData $select clause.")
      @query
      $select: string;

      @doc("""
The maximum number of items to return in the response. A maximum of 1000
Compute Nodes can be returned.
""")
      @query
      maxresults: int32;

      @doc("""
The maximum time that the server can spend processing the request, in seconds.
The default is 30 seconds.
""")
      @query
      timeout: int32;

      @doc("""
The caller-generated request identity, in the form of a GUID with no decoration
such as curly braces, e.g. 9C4D50EE-2D56-4CD3-8152-34347DC9F2B0.
""")
      @header
      `client-request-id`: string;

      @doc("Whether the server should return the client-request-id in the response.")
      @header
      `return-client-request-id`: boolean;

      @doc("""
The time the request was issued. Client libraries typically set this to the
current system clock time; set it explicitly if you are calling the REST API
directly.
""")
      @header
      `ocp-date`: utcDateTime;
    },
    NodeVMExtensionList
  >;
}
