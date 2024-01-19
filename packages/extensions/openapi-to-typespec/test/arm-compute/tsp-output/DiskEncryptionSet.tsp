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
 * disk encryption set resource.
 */
model DiskEncryptionSet is TrackedResource<EncryptionSetProperties> {
  /**
   * The name of the disk encryption set that is being created. The name can't be changed after the disk encryption set is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters.
   */
  @path
  @key("diskEncryptionSetName")
  @segment("diskEncryptionSets")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
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
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<DiskEncryptionSet, DiskEncryptionSetUpdate>;

  /**
   * Deletes a disk encryption set.
   */
  delete is ArmResourceDeleteAsync<DiskEncryptionSet>;

  /**
   * Lists all the disk encryption sets under a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskEncryptionSets_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<DiskEncryptionSet>;

  /**
   * Lists all the disk encryption sets under a subscription.
   */
  list is ArmListBySubscription<DiskEncryptionSet>;

  /**
   * Lists all resources that are encrypted with this disk encryption set.
   */
  // FIXME: DiskEncryptionSets_ListAssociatedResources could not be converted to a resource operation
  listAssociatedResources is Azure.Core.ResourceList<string>;
}

@@projectedName(DiskEncryptionSets.createOrUpdate::parameters.resource,
  "json",
  "diskEncryptionSet"
);
@@extension(DiskEncryptionSets.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "diskEncryptionSet"
);
@@doc(DiskEncryptionSets.createOrUpdate::parameters.resource,
  "disk encryption set object supplied in the body of the Put disk encryption set operation."
);
@@projectedName(DiskEncryptionSets.update::parameters.properties,
  "json",
  "diskEncryptionSet"
);
@@extension(DiskEncryptionSets.update::parameters.properties,
  "x-ms-client-name",
  "diskEncryptionSet"
);
@@doc(DiskEncryptionSets.update::parameters.properties,
  "disk encryption set object supplied in the body of the Patch disk encryption set operation."
);
