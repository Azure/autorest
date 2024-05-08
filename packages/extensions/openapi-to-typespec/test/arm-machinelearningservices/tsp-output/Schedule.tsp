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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Workspace)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(ScheduleProperties)
model Schedule extends ProxyResourceBase {
  /**
   * Schedule name.
   */
  @path
  @key("name")
  @segment("schedules")
  @visibility("read")
  name: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: ScheduleProperties;
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
  delete is ArmResourceDeleteAsync<Schedule>;

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

@@encodedName(Schedules.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(Schedules.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(Schedules.createOrUpdate::parameters.resource, "Schedule definition.");
