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
 * Disk resource.
 */
model Disk is TrackedResource<DiskProperties> {
  /**
   * The name of the managed disk that is being created. The name can't be changed after the disk is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters.
   */
  @path
  @key("diskName")
  @segment("disks")
  name: string;

  /**
   * List of relative URIs containing the IDs of the VMs that have the disk attached. maxShares should be set to a value greater than one for disks to allow attaching them to multiple VMs.
   */
  @visibility("read")
  managedByExtended?: string[];

  /**
   * The Logical zone list for Disk.
   */
  zones?: string[];

  /**
   * The extended location where the disk will be created. Extended location cannot be changed.
   */
  extendedLocation?: ExtendedLocation;

  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ManagedBy;
}

@armResourceOperations
interface Disks {
  /**
   * Gets information about a disk.
   */
  get is ArmResourceRead<Disk>;

  /**
   * Creates or updates a disk.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Disk>;

  /**
   * Updates (patches) a disk.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<Disk, DiskUpdate>;

  /**
   * Deletes a disk.
   */
  delete is ArmResourceDeleteAsync<Disk>;

  /**
   * Lists all the disks under a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Disks_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<Disk>;

  /**
   * Lists all the disks under a subscription.
   */
  list is ArmListBySubscription<Disk>;

  /**
   * Grants access to a disk.
   */
  grantAccess is ArmResourceActionAsync<
    Disk,
    GrantAccessData,
    AccessUri,
    BaseParameters<Disk>,
    ArmLroLocationHeader
  >;

  /**
   * Revokes access to a disk.
   */
  revokeAccess is ArmResourceActionAsync<
    Disk,
    void,
    void,
    BaseParameters<Disk>,
    ArmLroLocationHeader
  >;
}

@@projectedName(Disks.createOrUpdate::parameters.resource, "json", "disk");
@@extension(Disks.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "disk"
);
@@doc(Disks.createOrUpdate::parameters.resource,
  "Disk object supplied in the body of the Put disk operation."
);
@@projectedName(Disks.update::parameters.properties, "json", "disk");
@@extension(Disks.update::parameters.properties, "x-ms-client-name", "disk");
@@doc(Disks.update::parameters.properties,
  "Disk object supplied in the body of the Patch disk operation."
);
@@projectedName(Disks.grantAccess::parameters.body, "json", "grantAccessData");
@@extension(Disks.grantAccess::parameters.body,
  "x-ms-client-name",
  "grantAccessData"
);
@@doc(Disks.grantAccess::parameters.body,
  "Access data object supplied in the body of the get disk access operation."
);
