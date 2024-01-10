import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./RestorePoint.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

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
interface DiskRestorePoints {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get disk restorePoint resource")
  @operationId("DiskRestorePoint_Get")
  get is ArmResourceRead<
    DiskRestorePoint,
    {
      ...BaseParameters<DiskRestorePoint>;

      @doc("The name of the restore point collection that the disk restore point belongs.")
      @path
      restorePointCollectionName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists diskRestorePoints under a vmRestorePoint.")
  @operationId("DiskRestorePoint_ListByRestorePoint")
  listByRestorePoint is ArmResourceListByParent<
    DiskRestorePoint,
    {
      ...BaseParameters<DiskRestorePoint>;

      @doc("The name of the restore point collection that the disk restore point belongs.")
      @path
      restorePointCollectionName: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Grants access to a diskRestorePoint.")
  @operationId("DiskRestorePoint_GrantAccess")
  grantAccess is ArmResourceActionAsync<
    DiskRestorePoint,
    GrantAccessData,
    AccessUri,
    {
      ...BaseParameters<DiskRestorePoint>;

      @doc("The name of the restore point collection that the disk restore point belongs.")
      @path
      restorePointCollectionName: string;
    },
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Revokes access to a diskRestorePoint.")
  @operationId("DiskRestorePoint_RevokeAccess")
  revokeAccess is ArmResourceActionAsync<
    DiskRestorePoint,
    void,
    void,
    {
      ...BaseParameters<DiskRestorePoint>;

      @doc("The name of the restore point collection that the disk restore point belongs.")
      @path
      restorePointCollectionName: string;
    },
    ArmLroLocationHeader
  >;
}
