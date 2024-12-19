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
 * disk encryption set resource.
 */
model DiskEncryptionSet
  is Azure.ResourceManager.TrackedResource<EncryptionSetProperties> {
  ...ResourceNameParameter<
    Resource = DiskEncryptionSet,
    KeyName = "diskEncryptionSetName",
    SegmentName = "diskEncryptionSets",
    NamePattern = ""
  >;

  /**
   * The managed identity for the disk encryption set. It should be given permission on the key vault before it can be used to encrypt disks.
   */
  identity?: EncryptionSetIdentity;
}

@armResourceOperations
interface DiskEncryptionSets {
  /**
   * Gets information about a disk encryption set.
   */
  get is ArmResourceRead<DiskEncryptionSet>;

  /**
   * Creates or updates a disk encryption set
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    DiskEncryptionSet,
    Response = ArmResourceUpdatedResponse<DiskEncryptionSet> | (ArmAcceptedLroResponse & {
      @bodyRoot
      _: DiskEncryptionSet;
    }),
    LroHeaders = ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
  >;

  /**
   * Updates (patches) a disk encryption set.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<
    DiskEncryptionSet,
    PatchModel = DiskEncryptionSetUpdate
  >;

  /**
   * Deletes a disk encryption set.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    DiskEncryptionSet,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Lists all the disk encryption sets under a resource group.
   */
  listByResourceGroup is ArmResourceListByParent<
    DiskEncryptionSet,
    Response = ArmResponse<DiskEncryptionSetList>
  >;

  /**
   * Lists all the disk encryption sets under a subscription.
   */
  list is ArmListBySubscription<
    DiskEncryptionSet,
    Response = ArmResponse<DiskEncryptionSetList>
  >;

  /**
   * Lists all resources that are encrypted with this disk encryption set.
   */
  @get
  @action("associatedResources")
  listAssociatedResources is ArmResourceActionSync<
    DiskEncryptionSet,
    void,
    ArmResponse<ResourceUriList>
  >;
}

@@doc(DiskEncryptionSet.name,
  "The name of the disk encryption set that is being created. The name can't be changed after the disk encryption set is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters."
);
@@doc(DiskEncryptionSet.properties, "");
@@doc(DiskEncryptionSets.createOrUpdate::parameters.resource,
  "disk encryption set object supplied in the body of the Put disk encryption set operation."
);
@@doc(DiskEncryptionSets.update::parameters.properties,
  "disk encryption set object supplied in the body of the Patch disk encryption set operation."
);
