import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./RestorePoint.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Compute;
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
interface DiskRestorePoints {
  @doc("Get disk restorePoint resource")
  get is ArmResourceRead<DiskRestorePoint>;
  @doc("Lists diskRestorePoints under a vmRestorePoint.")
  listByRestorePoint is ArmResourceListByParent<
    DiskRestorePoint,
    {
      @doc("The name of the vm restore point that the disk disk restore point belongs.")
      @path
      vmRestorePointName: string;
    }
  >;
  @doc("Grants access to a diskRestorePoint.")
  grantAccess is ArmResourceActionAsync<
    DiskRestorePoint,
    {
      @doc("The name of the vm restore point that the disk disk restore point belongs.")
      @path
      vmRestorePointName: string;
      ...GrantAccessData;
    },
    AccessUri
  >;
  @doc("Revokes access to a diskRestorePoint.")
  revokeAccess is ArmResourceActionAsync<
    DiskRestorePoint,
    {
      @doc("The name of the vm restore point that the disk disk restore point belongs.")
      @path
      vmRestorePointName: string;
    },
    {}
  >;
}
