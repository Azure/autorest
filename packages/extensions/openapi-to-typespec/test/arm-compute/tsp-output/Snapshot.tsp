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
 * Snapshot resource.
 */
model Snapshot is Azure.ResourceManager.TrackedResource<SnapshotProperties> {
  ...ResourceNameParameter<
    Resource = Snapshot,
    KeyName = "snapshotName",
    SegmentName = "snapshots",
    NamePattern = ""
  >;

  /**
   * Unused. Always Null.
   */
  @visibility("read")
  managedBy?: string;

  /**
   * The snapshots sku name. Can be Standard_LRS, Premium_LRS, or Standard_ZRS. This is an optional parameter for incremental snapshot and the default behavior is the SKU will be set to the same sku as the previous snapshot
   */
  sku?: SnapshotSku;

  /**
   * The extended location where the snapshot will be created. Extended location cannot be changed.
   */
  extendedLocation?: ExtendedLocation;
}

@armResourceOperations
interface Snapshots {
  /**
   * Gets information about a snapshot.
   */
  get is ArmResourceRead<Snapshot>;

  /**
   * Creates or updates a snapshot.
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Snapshot>;

  /**
   * Updates (patches) a snapshot.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<Snapshot, SnapshotUpdate>;

  /**
   * Deletes a snapshot.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<Snapshot>;

  /**
   * Lists snapshots under a resource group.
   */
  listByResourceGroup is ArmResourceListByParent<Snapshot>;

  /**
   * Lists snapshots under a subscription.
   */
  list is ArmListBySubscription<Snapshot>;

  /**
   * Grants access to a snapshot.
   */
  grantAccess is ArmResourceActionAsync<Snapshot, GrantAccessData, AccessUri>;

  /**
   * Revokes access to a snapshot.
   */
  revokeAccess is ArmResourceActionAsync<Snapshot, void, void>;
}

@@doc(Snapshot.name,
  "The name of the snapshot that is being created. The name can't be changed after the snapshot is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The max name length is 80 characters."
);
@@doc(Snapshot.properties, "Snapshot resource properties.");
@@doc(Snapshots.createOrUpdate::parameters.resource,
  "Snapshot object supplied in the body of the Put disk operation."
);
@@doc(Snapshots.update::parameters.properties,
  "Snapshot object supplied in the body of the Patch snapshot operation."
);
@@doc(Snapshots.grantAccess::parameters.body,
  "Access data object supplied in the body of the get snapshot access operation."
);
