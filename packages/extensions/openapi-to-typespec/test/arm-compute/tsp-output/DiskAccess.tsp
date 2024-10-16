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
model DiskAccess
  is Azure.ResourceManager.TrackedResource<DiskAccessProperties> {
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
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    DiskAccess,
    Response = ArmResourceCreatedResponse<DiskAccess> | ArmResourceUpdatedResponse<DiskAccess> | (ArmAcceptedLroResponse & {
      @body _: DiskAccess;
    })
  >;

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
  listByResourceGroup is ArmResourceListByParent<
    DiskAccess,
    Response = DiskAccessList
  >;

  /**
   * Lists all the disk access resources under a subscription.
   */
  list is ArmListBySubscription<DiskAccess, Response = DiskAccessList>;

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
@@doc(DiskAccess.properties, "");
@@doc(DiskAccesses.createOrUpdate::parameters.resource,
  "disk access object supplied in the body of the Put disk access operation."
);
@@doc(DiskAccesses.update::parameters.properties,
  "disk access object supplied in the body of the Patch disk access operation."
);
