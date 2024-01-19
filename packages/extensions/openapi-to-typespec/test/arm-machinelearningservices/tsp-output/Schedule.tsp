import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(Workspace)
model Schedule is ProxyResource<ScheduleProperties> {
  /**
   * Schedule name.
   */
  @path
  @key("name")
  @segment("schedules")
  name: string;
}

@armResourceOperations
interface Schedules {
  /**
   * Get schedule.
   */
  get is ArmResourceRead<Schedule>;

  /**
   * Create or update schedule.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Schedule>;

  /**
   * Delete schedule.
   */
  delete is ArmResourceDeleteAsync<
    Schedule,
    BaseParameters<Schedule>,
    ArmLroLocationHeader
  >;

  /**
   * List schedules in specified workspace.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Schedules_List")
  list is ArmResourceListByParent<
    Schedule,
    {
      ...BaseParameters<Schedule>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Status filter for schedule.
       */
      @query("listViewType")
      listViewType?: ScheduleListViewType;
    }
  >;
}

@@projectedName(Schedules.createOrUpdate::parameters.resource, "json", "body");
@@extension(Schedules.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(Schedules.createOrUpdate::parameters.resource, "Schedule definition.");
