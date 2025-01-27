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
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
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
    Response = ArmResourceUpdatedResponse<DiskAccess> | (ArmAcceptedLroResponse & {
      @bodyRoot
      _: DiskAccess;
    }),
    LroHeaders = ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Updates (patches) a disk access resource.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<DiskAccess, PatchModel = DiskAccessUpdate>;

  /**
   * Deletes a disk access resource.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    DiskAccess,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Lists all the disk access resources under a resource group.
   */
  listByResourceGroup is ArmResourceListByParent<
    DiskAccess,
    Response = ArmResponse<DiskAccessList>
  >;

  /**
   * Lists all the disk access resources under a subscription.
   */
  list is ArmListBySubscription<
    DiskAccess,
    Response = ArmResponse<DiskAccessList>
  >;

  /**
   * Gets the private link resources possible under disk access resource
   */
  @get
  @action("privateLinkResources")
  getPrivateLinkResources is ArmResourceActionSync<
    DiskAccess,
    void,
    ArmResponse<PrivateLinkResourceListResult>
  >;
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
