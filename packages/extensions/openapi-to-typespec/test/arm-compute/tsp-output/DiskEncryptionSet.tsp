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
  createOrUpdate is ArmResourceCreateOrReplaceAsync<DiskEncryptionSet>;

  /**
   * Updates (patches) a disk encryption set.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<DiskEncryptionSet, DiskEncryptionSetUpdate>;

  /**
   * Deletes a disk encryption set.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<DiskEncryptionSet>;

  /**
   * Lists all the disk encryption sets under a resource group.
   */
  listByResourceGroup is ArmResourceListByParent<DiskEncryptionSet>;

  /**
   * Lists all the disk encryption sets under a subscription.
   */
  list is ArmListBySubscription<DiskEncryptionSet>;

  /**
   * Lists all resources that are encrypted with this disk encryption set.
   */
  // FIXME: DiskEncryptionSets_ListAssociatedResources could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/diskEncryptionSets/{diskEncryptionSetName}/associatedResources")
  @get
  listAssociatedResources(
    ...ApiVersionParameter,
    ...SubscriptionIdParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the disk encryption set that is being created. The name can't be changed after the disk encryption set is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters.
     */
    @path
    diskEncryptionSetName: string,
  ): ArmResponse<ResourceUriList> | ErrorResponse;
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
