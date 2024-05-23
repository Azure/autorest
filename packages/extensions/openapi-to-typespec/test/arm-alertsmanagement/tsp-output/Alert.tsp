import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AlertsManagement;
/**
 * An alert created in alert management service.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@subscriptionResource
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(AlertProperties)
model Alert extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = Alert,
    KeyName = "alertId",
    SegmentName = "alerts",
    NamePattern = ""
  >;

  /**
   * Alert property bag
   */
  @extension("x-ms-client-flatten", true)
  properties?: AlertProperties;
}

@armResourceOperations
interface Alerts {
  /**
   * Get information related to a specific alert
   */
  getById is ArmResourceRead<Alert>;

  /**
   * List all existing alerts, where the results can be filtered on the basis of multiple parameters (e.g. time range). The results can then be sorted on the basis specific fields, with the default being lastModifiedDateTime.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Alerts_GetAll")
  getAll is ArmResourceListByParent<
    Alert,
    {
      ...Azure.ResourceManager.Foundations.SubscriptionBaseParameters;

      /**
       * Filter by target resource( which is full ARM ID) Default value is select all.
       */
      @query("targetResource")
      targetResource?: string;

      /**
       * Filter by target resource type. Default value is select all.
       */
      @query("targetResourceType")
      targetResourceType?: string;

      /**
       * Filter by target resource group name. Default value is select all.
       */
      @query("targetResourceGroup")
      targetResourceGroup?: string;

      /**
       * Filter by monitor service which generates the alert instance. Default value is select all.
       */
      @query("monitorService")
      monitorService?: MonitorService;

      /**
       * Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.
       */
      @query("monitorCondition")
      monitorCondition?: MonitorCondition;

      /**
       * Filter by severity.  Default value is select all.
       */
      @query("severity")
      severity?: Severity;

      /**
       * Filter by state of the alert instance. Default value is to select all.
       */
      @query("alertState")
      alertState?: AlertState;

      /**
       * Filter by specific alert rule.  Default value is to select all.
       */
      @query("alertRule")
      alertRule?: string;

      /**
       * Filter the alerts list by the Smart Group Id. Default value is none.
       */
      @query("smartGroupId")
      smartGroupId?: string;

      /**
       * Include context which has contextual data specific to the monitor service. Default value is false'
       */
      @query("includeContext")
      includeContext?: boolean;

      /**
       * Include egress config which would be used for displaying the content in portal.  Default value is 'false'.
       */
      @query("includeEgressConfig")
      includeEgressConfig?: boolean;

      /**
       * Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the "includeContent"  filter is selected, maximum value allowed is 25. Default value is 25.
       */
      @query("pageCount")
      pageCount?: int64;

      /**
       * Sort the query results by input field,  Default value is 'lastModifiedDateTime'.
       */
      @query("sortBy")
      sortBy?: AlertsSortByFields;

      /**
       * Sort the query results order in either ascending or descending.  Default value is 'desc' for time fields and 'asc' for others.
       */
      @query("sortOrder")
      sortOrder?: SortOrder;

      /**
       * This filter allows to selection of the fields(comma separated) which would  be part of the essential section. This would allow to project only the  required fields rather than getting entire content.  Default is to fetch all the fields in the essentials section.
       */
      @query("select")
      select?: string;

      /**
       * Filter by time range by below listed values. Default value is 1 day.
       */
      @query("timeRange")
      timeRange?: TimeRange;

      /**
       * Filter by custom time range in the format <start-time>/<end-time>  where time is in (ISO-8601 format)'. Permissible values is within 30 days from  query time. Either timeRange or customTimeRange could be used but not both. Default is none.
       */
      @query("customTimeRange")
      customTimeRange?: string;
    }
  >;

  /**
   * Change the state of an alert.
   */
  changeState is ArmResourceActionSync<
    Alert,
    string,
    Alert,
    {
      ...Azure.ResourceManager.Foundations.SubscriptionBaseParameters;

      /**
       * New state of the alert.
       */
      @query("newState")
      newState: AlertState;
    }
  >;

  /**
   * Get the history of an alert, which captures any monitor condition changes (Fired/Resolved) and alert state changes (New/Acknowledged/Closed).
   */
  // FIXME: Alerts_GetHistory could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/alerts/{alertId}/history")
  @get
  getHistory(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,

    /**
     * Unique ID of an alert instance.
     */
    @path
    alertId: string,
  ): ArmResponse<AlertModification> | ErrorResponse;
}

@@doc(Alert.name, "Unique ID of an alert instance.");
@@encodedName(Alerts.changeState::parameters.body,
  "application/json",
  "comment"
);
@@extension(Alerts.changeState::parameters.body, "x-ms-client-name", "comment");
@@doc(Alerts.changeState::parameters.body, "reason of change alert state");
