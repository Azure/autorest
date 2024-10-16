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
 * Disk resource.
 */
model Disk is Azure.ResourceManager.TrackedResource<DiskProperties> {
  ...ResourceNameParameter<
    Resource = Disk,
    KeyName = "diskName",
    SegmentName = "disks",
    NamePattern = ""
  >;

  /**
   * A relative URI containing the ID of the VM that has the disk attached.
   */
  @visibility("read")
  managedBy?: string;

  /**
   * List of relative URIs containing the IDs of the VMs that have the disk attached. maxShares should be set to a value greater than one for disks to allow attaching them to multiple VMs.
   */
  @visibility("read")
  managedByExtended?: string[];

  /**
   * The disks sku name. Can be Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS, Premium_ZRS, StandardSSD_ZRS, or PremiumV2_LRS.
   */
  sku?: DiskSku;

  /**
   * The Logical zone list for Disk.
   */
  zones?: string[];

  /**
   * The extended location where the disk will be created. Extended location cannot be changed.
   */
  extendedLocation?: ExtendedLocation;
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
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    Disk,
    Response = ArmResourceCreatedResponse<Disk> | ArmResourceUpdatedResponse<Disk> | (ArmAcceptedLroResponse & {
      @body _: Disk;
    })
  >;

  /**
   * Updates (patches) a disk.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<Disk, DiskUpdate>;

  /**
   * Deletes a disk.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<Disk>;

  /**
   * Lists all the disks under a resource group.
   */
  listByResourceGroup is ArmResourceListByParent<Disk, Response = DiskList>;

  /**
   * Lists all the disks under a subscription.
   */
  list is ArmListBySubscription<Disk, Response = DiskList>;

  /**
   * Grants access to a disk.
   */
  grantAccess is ArmResourceActionAsync<Disk, GrantAccessData, AccessUri>;

  /**
   * Revokes access to a disk.
   */
  revokeAccess is ArmResourceActionAsync<Disk, void, void>;
}

@@doc(Disk.name,
  "The name of the managed disk that is being created. The name can't be changed after the disk is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters."
);
@@doc(Disk.properties, "Disk resource properties.");
@@doc(Disks.createOrUpdate::parameters.resource,
  "Disk object supplied in the body of the Put disk operation."
);
@@doc(Disks.update::parameters.properties,
  "Disk object supplied in the body of the Patch disk operation."
);
@@doc(Disks.grantAccess::parameters.body,
  "Access data object supplied in the body of the get disk access operation."
);
