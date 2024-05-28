import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./CapacityReservationGroup.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Specifies information about the capacity reservation.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(CapacityReservationGroup)
@includeInapplicableMetadataInPayload(false)
model CapacityReservation extends Resource {
  ...ResourceNameParameter<
    Resource = CapacityReservation,
    KeyName = "capacityReservationName",
    SegmentName = "capacityReservations",
    NamePattern = ""
  >;

  /**
   * SKU of the resource for which capacity needs be reserved. The SKU name and capacity is required to be set. Currently VM Skus with the capability called 'CapacityReservationSupported' set to true are supported. Refer to List Microsoft.Compute SKUs in a region (https://docs.microsoft.com/rest/api/compute/resourceskus/list) for supported values.
   */
  sku: Sku;

  /**
   * Availability Zone to use for this capacity reservation. The zone has to be single value and also should be part for the list of zones specified during the capacity reservation group creation. The zone can be assigned only during creation. If not provided, the reservation supports only non-zonal deployments. If provided, enforces VM/VMSS using this capacity reservation to be in same zone.
   */
  zones?: string[];

  /**
   * Properties of the Capacity reservation.
   */
  @extension("x-ms-client-flatten", true)
  properties?: CapacityReservationProperties;
}

@armResourceOperations
interface CapacityReservations {
  /**
   * The operation that retrieves information about the capacity reservation.
   */
  get is ArmResourceRead<
    CapacityReservation,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<CapacityReservation>;

      /**
       * The expand expression to apply on the operation. 'InstanceView' retrieves a snapshot of the runtime properties of the capacity reservation that is managed by the platform and can change outside of control plane operations.
       */
      @query("$expand")
      $expand?: CapacityReservationInstanceViewTypes;
    }
  >;

  /**
   * The operation to create or update a capacity reservation. Please note some properties can be set only during capacity reservation creation. Please refer to https://aka.ms/CapacityReservation for more details.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<CapacityReservation>;

  /**
   * The operation to update a capacity reservation.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<CapacityReservation, CapacityReservationUpdate>;

  /**
   * The operation to delete a capacity reservation. This operation is allowed only when all the associated resources are disassociated from the capacity reservation. Please refer to https://aka.ms/CapacityReservation for more details.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<CapacityReservation>;

  /**
   * Lists all of the capacity reservations in the specified capacity reservation group. Use the nextLink property in the response to get the next page of capacity reservations.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("CapacityReservations_ListByCapacityReservationGroup")
  listByCapacityReservationGroup is ArmResourceListByParent<CapacityReservation>;
}

@@doc(CapacityReservation.name, "The name of the capacity reservation.");
@@encodedName(CapacityReservations.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(CapacityReservations.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(CapacityReservations.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create capacity reservation."
);
@@encodedName(CapacityReservations.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(CapacityReservations.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(CapacityReservations.update::parameters.properties,
  "Parameters supplied to the Update capacity reservation operation."
);
