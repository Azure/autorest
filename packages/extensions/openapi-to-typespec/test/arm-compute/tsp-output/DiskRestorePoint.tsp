import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./RestorePointCollection.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/** Properties of disk restore point */
@parentResource(RestorePointCollection)
model DiskRestorePoint
  is Azure.ResourceManager.ProxyResource<DiskRestorePointProperties> {
  ...ResourceNameParameter<
    Resource = DiskRestorePoint,
    KeyName = "diskRestorePointName",
    SegmentName = "diskRestorePoints",
    NamePattern = ""
  >;
}

@armResourceOperations
interface DiskRestorePoints {
  /** Get disk restorePoint resource */
  get is ArmResourceRead<DiskRestorePoint>;

  /** Lists diskRestorePoints under a vmRestorePoint. */
  listByRestorePoint is ArmResourceListByParent<
    DiskRestorePoint,
    Response = ArmResponse<DiskRestorePointList>
  >;

  /** Grants access to a diskRestorePoint. */
  @action("beginGetAccess")
  grantAccess is ArmResourceActionAsync<
    DiskRestorePoint,
    GrantAccessData,
    ArmResponse<AccessUri>
  >;

  /** Revokes access to a diskRestorePoint. */
  @action("endGetAccess")
  revokeAccess is ArmResourceActionAsync<DiskRestorePoint, void, OkResponse>;
}

@@doc(DiskRestorePoint.name, "The name of the disk restore point created.");
@@doc(DiskRestorePoint.properties,
  "Properties of an incremental disk restore point"
);
@@doc(DiskRestorePoints.grantAccess::parameters.body,
  "Access data object supplied in the body of the get disk access operation."
);
