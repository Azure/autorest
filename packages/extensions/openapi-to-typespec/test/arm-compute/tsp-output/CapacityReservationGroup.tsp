import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the capacity reservation group that the capacity reservations should be assigned to. Currently, a capacity reservation can only be added to a capacity reservation group at creation time. An existing capacity reservation cannot be added or moved to another capacity reservation group.
 */
model CapacityReservationGroup
  is Azure.ResourceManager.TrackedResource<CapacityReservationGroupProperties> {
  ...ResourceNameParameter<
    Resource = CapacityReservationGroup,
    KeyName = "capacityReservationGroupName",
    SegmentName = "capacityReservationGroups",
    NamePattern = ""
  >;

  /**
   * Availability Zones to use for this capacity reservation group. The zones can be assigned only during creation. If not provided, the group supports only regional resources in the region. If provided, enforces each capacity reservation in the group to be in one of the zones.
   */
  zones?: string[];
}

@armResourceOperations
interface CapacityReservationGroups {
  /**
   * The operation that retrieves information about a capacity reservation group.
   */
  get is ArmResourceRead<
    CapacityReservationGroup,
    Parameters = {
      /**
       * The expand expression to apply on the operation. 'InstanceView' will retrieve the list of instance views of the capacity reservations under the capacity reservation group which is a snapshot of the runtime properties of a capacity reservation that is managed by the platform and can change outside of control plane operations.
       */
      @query("$expand")
      $expand?: CapacityReservationGroupInstanceViewTypes;
    }
  >;

  /**
   * The operation to create or update a capacity reservation group. When updating a capacity reservation group, only tags may be modified. Please refer to https://aka.ms/CapacityReservation for more details.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<CapacityReservationGroup>;

  /**
   * The operation to update a capacity reservation group. When updating a capacity reservation group, only tags may be modified.
   */
  @parameterVisibility
  update is ArmCustomPatchSync<
    CapacityReservationGroup,
    CapacityReservationGroupUpdate
  >;

  /**
   * The operation to delete a capacity reservation group. This operation is allowed only if all the associated resources are disassociated from the reservation group and all capacity reservations under the reservation group have also been deleted. Please refer to https://aka.ms/CapacityReservation for more details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<CapacityReservationGroup>;

  /**
   * Lists all of the capacity reservation groups in the specified resource group. Use the nextLink property in the response to get the next page of capacity reservation groups.
   */
  listByResourceGroup is ArmResourceListByParent<
    CapacityReservationGroup,
    Parameters = {
      /**
       * The expand expression to apply on the operation. Based on the expand param(s) specified we return Virtual Machine or ScaleSet VM Instance or both resource Ids which are associated to capacity reservation group in the response.
       */
      @query("$expand")
      $expand?: ExpandTypesForGetCapacityReservationGroups;
    }
  >;

  /**
   * Lists all of the capacity reservation groups in the subscription. Use the nextLink property in the response to get the next page of capacity reservation groups.
   */
  listBySubscription is ArmListBySubscription<
    CapacityReservationGroup,
    Parameters = {
      /**
       * The expand expression to apply on the operation. Based on the expand param(s) specified we return Virtual Machine or ScaleSet VM Instance or both resource Ids which are associated to capacity reservation group in the response.
       */
      @query("$expand")
      $expand?: ExpandTypesForGetCapacityReservationGroups;
    }
  >;
}

@@doc(CapacityReservationGroup.name,
  "The name of the capacity reservation group."
);
@@doc(CapacityReservationGroup.properties,
  "capacity reservation group Properties."
);
@@doc(CapacityReservationGroups.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create capacity reservation Group."
);
@@doc(CapacityReservationGroups.update::parameters.properties,
  "Parameters supplied to the Update capacity reservation Group operation."
);
