import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AlertsManagement;
@doc("Set of related alerts grouped together smartly by AMS.")
@subscriptionResource
model SmartGroup is ProxyResource<SmartGroupProperties> {
  @doc("Smart group unique id. ")
  @path
  @key("smartGroupId")
  @segment("smartGroups")
  name: string;
}

@armResourceOperations
interface SmartGroups {
  @doc("Get information related to a specific Smart Group.")
  getById is ArmResourceRead<SmartGroup>;

  @doc("List all the Smart Groups within a specified subscription. ")
  getAll is ArmResourceListByParent<
    SmartGroup,
    {
      ...BaseParameters<SmartGroup>;

      @doc("Filter by target resource( which is full ARM ID) Default value is select all.")
      @query("targetResource")
      targetResource?: string;

      @doc("Filter by target resource group name. Default value is select all.")
      @query("targetResourceGroup")
      targetResourceGroup?: string;

      @doc("Filter by target resource type. Default value is select all.")
      @query("targetResourceType")
      targetResourceType?: string;

      @doc("Filter by monitor service which generates the alert instance. Default value is select all.")
      @query("monitorService")
      monitorService?: MonitorService;

      @doc("Filter by monitor condition which is either 'Fired' or 'Resolved'. Default value is to select all.")
      @query("monitorCondition")
      monitorCondition?: MonitorCondition;

      @doc("Filter by severity.  Default value is select all.")
      @query("severity")
      severity?: Severity;

      @doc("Filter by state of the smart group. Default value is to select all.")
      @query("smartGroupState")
      smartGroupState?: AlertState;

      @doc("Filter by time range by below listed values. Default value is 1 day.")
      @query("timeRange")
      timeRange?: TimeRange;

      @doc("Determines number of alerts returned per page in response. Permissible value is between 1 to 250. When the \"includeContent\"  filter is selected, maximum value allowed is 25. Default value is 25.")
      @query("pageCount")
      pageCount?: int32;

      @doc("Sort the query results by input field. Default value is sort by 'lastModifiedDateTime'.")
      @query("sortBy")
      sortBy?: SmartGroupsSortByFields;

      @doc("Sort the query results order in either ascending or descending.  Default value is 'desc' for time fields and 'asc' for others.")
      @query("sortOrder")
      sortOrder?: SortOrder;
    }
  >;

  @doc("Change the state of a Smart Group.")
  changeState is ArmResourceActionSync<
    SmartGroup,
    void,
    SmartGroup,
    {
      ...BaseParameters<SmartGroup>;

      @doc("New state of the alert.")
      @query("newState")
      newState: AlertState;
    }
  >;

  @doc("Get the history a smart group, which captures any Smart Group state changes (New/Acknowledged/Closed) .")
  // FIXME: SmartGroups_GetHistory could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/providers/Microsoft.AlertsManagement/smartGroups/{smartGroupId}/history")
  @get
  GetHistory is Azure.Core.Foundations.Operation<
    {
      @doc("The ID of the target subscription.")
      @minLength(1)
      @path
      subscriptionId: string;

      @doc("Smart group unique id. ")
      @path
      smartGroupId: string;
    },
    SmartGroupModification
  >;
}
