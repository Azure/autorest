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

namespace Microsoft.Compute;
/**
 * Specifies information about the dedicated host group that the dedicated hosts should be assigned to. Currently, a dedicated host can only be added to a dedicated host group at creation time. An existing dedicated host cannot be added to another dedicated host group.
 */
model DedicatedHostGroup is TrackedResource<DedicatedHostGroupProperties> {
  /**
   * The name of the dedicated host group.
   */
  @path
  @key("hostGroupName")
  @segment("hostGroups")
  name: string;

  /**
   * Availability Zone to use for this host group. Only single zone is supported. The zone can be assigned only during creation. If not provided, the group supports all zones in the region. If provided, enforces each host in the group to be in the same zone.
   */
  zones?: string[];
}

@armResourceOperations
interface DedicatedHostGroups {
  /**
   * Retrieves information about a dedicated host group.
   */
  get is ArmResourceRead<
    DedicatedHostGroup,
    {
      ...BaseParameters<DedicatedHostGroup>;

      /**
       * The expand expression to apply on the operation. 'InstanceView' will retrieve the list of instance views of the dedicated hosts under the dedicated host group. 'UserData' is not supported for dedicated host group.
       */
      @query("$expand")
      $expand?: InstanceViewTypes;
    }
  >;

  /**
   * Create or update a dedicated host group. For details of Dedicated Host and Dedicated Host Groups please see [Dedicated Host Documentation] (https://go.microsoft.com/fwlink/?linkid=2082596)
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<DedicatedHostGroup>;

  /**
   * Update an dedicated host group.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<DedicatedHostGroup, DedicatedHostGroupUpdate>;

  /**
   * Delete a dedicated host group.
   */
  delete is ArmResourceDeleteSync<DedicatedHostGroup>;

  /**
   * Lists all of the dedicated host groups in the specified resource group. Use the nextLink property in the response to get the next page of dedicated host groups.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DedicatedHostGroups_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<DedicatedHostGroup>;

  /**
   * Lists all of the dedicated host groups in the subscription. Use the nextLink property in the response to get the next page of dedicated host groups.
   */
  listBySubscription is ArmListBySubscription<DedicatedHostGroup>;
}

@@projectedName(DedicatedHostGroups.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(DedicatedHostGroups.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(DedicatedHostGroups.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Dedicated Host Group."
);
@@projectedName(DedicatedHostGroups.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(DedicatedHostGroups.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(DedicatedHostGroups.update::parameters.properties,
  "Parameters supplied to the Update Dedicated Host Group operation."
);
