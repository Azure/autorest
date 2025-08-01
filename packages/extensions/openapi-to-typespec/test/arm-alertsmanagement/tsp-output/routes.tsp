// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;

namespace Azure.ResourceManager.AlertsManagement;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface AlertsOperationGroup {
  /**
   * List alerts meta data information based on value of identifier parameter.
   */
  @autoRoute
  @get
  @action("alertsMetaData")
  metaData is ArmProviderActionSync<
    Response = AlertsMetaData,
    Parameters = {
      /**
       * Identification of the information to be retrieved by API call.
       */
      @query("identifier")
      identifier: Identifier;
    }
  >;
  /**
   * Get a summarized count of your alerts grouped by various parameters (e.g. grouping by 'Severity' returns the count of alerts for each severity).
   */
  @autoRoute
  @get
  @action("alertsSummary")
  getSummary is ArmProviderActionSync<
    Response = AlertsSummary,
    Scope = SubscriptionActionScope,
    Parameters = {
      /**
       * This parameter allows the result set to be grouped by input fields (Maximum 2 comma separated fields supported). For example, groupby=severity or groupby=severity,alertstate.
       */
      @query("groupby")
      groupby: AlertsSummaryGroupByFields;

      /**
       * Include count of the SmartGroups as part of the summary. Default value is 'false'.
       */
      @query("includeSmartGroupsCount")
      includeSmartGroupsCount?: boolean;

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
}
