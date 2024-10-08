import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(Workspace)
model Schedule
  is Azure.ResourceManager.ProxyResource<ScheduleProperties, false> {
  ...ResourceNameParameter<
    Resource = Schedule,
    KeyName = "name",
    SegmentName = "schedules",
    NamePattern = ""
  >;
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
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<Schedule>;

  /**
   * List schedules in specified workspace.
   */
  list is ArmResourceListByParent<
    Schedule,
    Parameters = {
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

@@doc(Schedule.name, "Schedule name.");
@@doc(Schedule.properties, "[Required] Additional attributes of the entity.");
@@doc(Schedules.createOrUpdate::parameters.resource, "Schedule definition.");
