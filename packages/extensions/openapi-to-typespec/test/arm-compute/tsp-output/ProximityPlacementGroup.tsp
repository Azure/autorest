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
 * Specifies information about the proximity placement group.
 */
model ProximityPlacementGroup
  is TrackedResource<ProximityPlacementGroupProperties> {
  /**
   * The name of the proximity placement group.
   */
  @path
  @key("proximityPlacementGroupName")
  @segment("proximityPlacementGroups")
  name: string;

  /**
   * Specifies the Availability Zone where virtual machine, virtual machine scale set or availability set associated with the  proximity placement group can be created.
   */
  zones?: string[];
}

@armResourceOperations
interface ProximityPlacementGroups {
  /**
   * Retrieves information about a proximity placement group .
   */
  get is ArmResourceRead<
    ProximityPlacementGroup,
    {
      ...BaseParameters<ProximityPlacementGroup>;

      /**
       * includeColocationStatus=true enables fetching the colocation status of all the resources in the proximity placement group.
       */
      @query("includeColocationStatus")
      includeColocationStatus?: string;
    }
  >;

  /**
   * Create or update a proximity placement group.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<ProximityPlacementGroup>;

  /**
   * Update a proximity placement group.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    ProximityPlacementGroup,
    ProximityPlacementGroupUpdate
  >;

  /**
   * Delete a proximity placement group.
   */
  delete is ArmResourceDeleteSync<ProximityPlacementGroup>;

  /**
   * Lists all proximity placement groups in a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ProximityPlacementGroups_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<ProximityPlacementGroup>;

  /**
   * Lists all proximity placement groups in a subscription.
   */
  listBySubscription is ArmListBySubscription<ProximityPlacementGroup>;
}

@@projectedName(ProximityPlacementGroups.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(ProximityPlacementGroups.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(ProximityPlacementGroups.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create Proximity Placement Group operation."
);
@@projectedName(ProximityPlacementGroups.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(ProximityPlacementGroups.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(ProximityPlacementGroups.update::parameters.properties,
  "Parameters supplied to the Update Proximity Placement Group operation."
);
