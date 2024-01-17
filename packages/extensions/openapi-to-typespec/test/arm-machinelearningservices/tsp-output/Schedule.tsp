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
@doc("Azure Resource Manager resource envelope.")
@parentResource(Workspace)
model Schedule is ProxyResource<ScheduleProperties> {
  @doc("Schedule name.")
  @path
  @key("name")
  @segment("schedules")
  name: string;
}

@armResourceOperations
interface Schedules {
  @doc("Get schedule.")
  get is ArmResourceRead<Schedule>;

  @doc("Create or update schedule.")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Schedule>;

  @doc("Delete schedule.")
  delete is ArmResourceDeleteAsync<
    Schedule,
    BaseParameters<Schedule>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List schedules in specified workspace.")
  @operationId("Schedules_List")
  list is ArmResourceListByParent<
    Schedule,
    {
      ...BaseParameters<Schedule>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Status filter for schedule.")
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
