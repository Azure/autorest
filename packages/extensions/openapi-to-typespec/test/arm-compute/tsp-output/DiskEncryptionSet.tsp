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
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identity?: EncryptionSetIdentity;
}

@armResourceOperations
interface DiskEncryptionSets {
  /**
   * Gets information about a disk encryption set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DiskEncryptionSets_Get")
  get is ArmResourceRead<DiskEncryptionSet>;

  /**
   * Creates or updates a disk encryption set
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  @operationId("DiskEncryptionSets_CreateOrUpdate")
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
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    DiskEncryptionSet,
    PatchModel = DiskEncryptionSetUpdate,
    Response = ArmResponse<DiskEncryptionSet> | (ArmAcceptedLroResponse & {
      @bodyRoot
      _: DiskEncryptionSet;
    })
  >;

  /**
   * Deletes a disk encryption set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("DiskEncryptionSets_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    DiskEncryptionSet,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * Lists all the disk encryption sets under a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DiskEncryptionSets_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<
    DiskEncryptionSet,
    Response = ArmResponse<DiskEncryptionSetList>
  >;

  /**
   * Lists all the disk encryption sets under a subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DiskEncryptionSets_List")
  list is ArmListBySubscription<
    DiskEncryptionSet,
    Response = ArmResponse<DiskEncryptionSetList>
  >;

  /**
   * Lists all resources that are encrypted with this disk encryption set.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DiskEncryptionSets_ListAssociatedResources")
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
