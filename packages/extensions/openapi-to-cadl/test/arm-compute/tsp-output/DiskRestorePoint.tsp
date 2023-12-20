import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./RestorePoint.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.Compute;
@doc("Properties of disk restore point")
@parentResource(RestorePoint)
model DiskRestorePoint is ProxyResource<DiskRestorePointProperties> {
  @doc("The name of the disk restore point created.")
  @path
  @key("diskRestorePointName")
  @segment("diskRestorePoints")
  name: string;
}

@armResourceOperations
interface DiskRestorePoint {
  @doc("Get disk restorePoint resource")
  get is ArmResourceRead<
    DiskRestorePoint,
    {
      ...BaseParameters<DiskRestorePoint>;

      @doc("The name of the restore point collection that the disk restore point belongs.")
      @path
      restorePointCollectionName: string;
    }
  >;
  @doc("Lists diskRestorePoints under a vmRestorePoint.")
  listByRestorePoint is ArmResourceListByParent<
    DiskRestorePoint,
    {
      ...BaseParameters<DiskRestorePoint>;

      @doc("The name of the restore point collection that the disk restore point belongs.")
      @path
      restorePointCollectionName: string;
    }
  >;
  @doc("Grants access to a diskRestorePoint.")
  grantAccess is ArmResourceActionAsync<
    DiskRestorePoint,
    GrantAccessData,
    AccessUri,
    {
      ...BaseParameters<DiskRestorePoint>;

      @doc("The name of the restore point collection that the disk restore point belongs.")
      @path
      restorePointCollectionName: string;
    }
  >;
  @doc("Revokes access to a diskRestorePoint.")
  revokeAccess is ArmResourceActionAsync<
    DiskRestorePoint,
    void,
    void,
    {
      ...BaseParameters<DiskRestorePoint>;

      @doc("The name of the restore point collection that the disk restore point belongs.")
      @path
      restorePointCollectionName: string;
    }
  >;
}
