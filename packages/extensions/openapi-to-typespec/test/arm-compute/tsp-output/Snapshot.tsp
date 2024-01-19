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
 * Snapshot resource.
 */
model Snapshot is TrackedResource<SnapshotProperties> {
  /**
   * The name of the snapshot that is being created. The name can't be changed after the snapshot is created. Supported characters for the name are a-z, A-Z, 0-9, _ and -. The max name length is 80 characters.
   */
  @path
  @key("snapshotName")
  @segment("snapshots")
  name: string;

  /**
   * The extended location where the snapshot will be created. Extended location cannot be changed.
   */
  extendedLocation?: ExtendedLocation;

  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ManagedBy;
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
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<Snapshot, SnapshotUpdate>;

  /**
   * Deletes a snapshot.
   */
  delete is ArmResourceDeleteAsync<Snapshot>;

  /**
   * Lists snapshots under a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Snapshots_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<Snapshot>;

  /**
   * Lists snapshots under a subscription.
   */
  list is ArmListBySubscription<Snapshot>;

  /**
   * Grants access to a snapshot.
   */
  grantAccess is ArmResourceActionAsync<
    Snapshot,
    GrantAccessData,
    AccessUri,
    BaseParameters<Snapshot>,
    ArmLroLocationHeader
  >;

  /**
   * Revokes access to a snapshot.
   */
  revokeAccess is ArmResourceActionAsync<
    Snapshot,
    void,
    void,
    BaseParameters<Snapshot>,
    ArmLroLocationHeader
  >;
}

@@projectedName(Snapshots.createOrUpdate::parameters.resource,
  "json",
  "snapshot"
);
@@extension(Snapshots.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "snapshot"
);
@@doc(Snapshots.createOrUpdate::parameters.resource,
  "Snapshot object supplied in the body of the Put disk operation."
);
@@projectedName(Snapshots.update::parameters.properties, "json", "snapshot");
@@extension(Snapshots.update::parameters.properties,
  "x-ms-client-name",
  "snapshot"
);
@@doc(Snapshots.update::parameters.properties,
  "Snapshot object supplied in the body of the Patch snapshot operation."
);
@@projectedName(Snapshots.grantAccess::parameters.body,
  "json",
  "grantAccessData"
);
@@extension(Snapshots.grantAccess::parameters.body,
  "x-ms-client-name",
  "grantAccessData"
);
@@doc(Snapshots.grantAccess::parameters.body,
  "Access data object supplied in the body of the get snapshot access operation."
);
