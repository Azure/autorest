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
 * disk access resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
model DiskAccess extends Resource {
  ...ResourceNameParameter<
    Resource = DiskAccess,
    KeyName = "diskAccessName",
    SegmentName = "diskAccesses",
    NamePattern = ""
  >;

  /**
   * The extended location where the disk access will be created. Extended location cannot be changed.
   */
  extendedLocation?: ExtendedLocation;

  @extension("x-ms-client-flatten", true)
  properties?: DiskAccessProperties;
}

@armResourceOperations
interface DiskAccesses {
  /**
   * Gets information about a disk access resource.
   */
  get is ArmResourceRead<DiskAccess>;

  /**
   * Creates or updates a disk access resource
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DiskAccess>;

  /**
   * Updates (patches) a disk access resource.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<DiskAccess, DiskAccessUpdate>;

  /**
   * Deletes a disk access resource.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<DiskAccess>;

  /**
   * Lists all the disk access resources under a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskAccesses_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<DiskAccess>;

  /**
   * Lists all the disk access resources under a subscription.
   */
  list is ArmListBySubscription<DiskAccess>;

  /**
   * Gets the private link resources possible under disk access resource
   */
  // FIXME: DiskAccesses_GetPrivateLinkResources could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/diskAccesses/{diskAccessName}/privateLinkResources")
  @get
  getPrivateLinkResources(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the disk access resource that is being created. The name can't be changed after the disk encryption set is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters.
     */
    @path
    diskAccessName: string,
  ): ArmResponse<PrivateLinkResourceListResult> | ErrorResponse;
}

@@doc(DiskAccess.name,
  "The name of the disk access resource that is being created. The name can't be changed after the disk encryption set is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters."
);
@@encodedName(DiskAccesses.createOrUpdate::parameters.resource,
  "application/json",
  "diskAccess"
);
@@extension(DiskAccesses.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "diskAccess"
);
@@doc(DiskAccesses.createOrUpdate::parameters.resource,
  "disk access object supplied in the body of the Put disk access operation."
);
@@encodedName(DiskAccesses.update::parameters.properties,
  "application/json",
  "diskAccess"
);
@@extension(DiskAccesses.update::parameters.properties,
  "x-ms-client-name",
  "diskAccess"
);
@@doc(DiskAccesses.update::parameters.properties,
  "disk access object supplied in the body of the Patch disk access operation."
);
