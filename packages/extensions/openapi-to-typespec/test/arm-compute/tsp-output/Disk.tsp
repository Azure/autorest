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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
model Disk extends Resource {
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

  /**
   * Disk resource properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: DiskProperties;
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
  grantAccess is ArmResourceActionAsync<Disk, GrantAccessData, AccessUri>;

  /**
   * Revokes access to a disk.
   */
  revokeAccess is ArmResourceActionAsync<Disk, void, void>;
}

@@doc(Disk.name,
  "The name of the managed disk that is being created. The name can't be changed after the disk is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The maximum name length is 80 characters."
);
@@encodedName(Disks.createOrUpdate::parameters.resource,
  "application/json",
  "disk"
);
@@extension(Disks.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "disk"
);
@@doc(Disks.createOrUpdate::parameters.resource,
  "Disk object supplied in the body of the Put disk operation."
);
@@encodedName(Disks.update::parameters.properties, "application/json", "disk");
@@extension(Disks.update::parameters.properties, "x-ms-client-name", "disk");
@@doc(Disks.update::parameters.properties,
  "Disk object supplied in the body of the Patch disk operation."
);
@@encodedName(Disks.grantAccess::parameters.body,
  "application/json",
  "grantAccessData"
);
@@extension(Disks.grantAccess::parameters.body,
  "x-ms-client-name",
  "grantAccessData"
);
@@doc(Disks.grantAccess::parameters.body,
  "Access data object supplied in the body of the get disk access operation."
);
