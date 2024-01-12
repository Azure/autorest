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
@doc("disk encryption set resource.")
model DiskEncryptionSet is TrackedResource<EncryptionSetProperties> {
  @doc("The name of the disk encryption set that is being created. The name can't be changed after the disk encryption set is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters.")
  @path
  @key("diskEncryptionSetName")
  @segment("diskEncryptionSets")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
}

@armResourceOperations
interface DiskEncryptionSets {
  @doc("Gets information about a disk encryption set.")
  get is ArmResourceRead<DiskEncryptionSet>;

  @doc("Creates or updates a disk encryption set")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<DiskEncryptionSet>;

  @doc("Updates (patches) a disk encryption set.")
  update is ArmCustomPatchAsync<DiskEncryptionSet, DiskEncryptionSetUpdate>;

  @doc("Deletes a disk encryption set.")
  delete is ArmResourceDeleteAsync<DiskEncryptionSet>;

  @doc("Lists all the disk encryption sets under a resource group.")
  listByResourceGroup is ArmResourceListByParent<DiskEncryptionSet>;

  @doc("Lists all the disk encryption sets under a subscription.")
  list is ArmListBySubscription<DiskEncryptionSet>;

  @doc("Lists all resources that are encrypted with this disk encryption set.")
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
