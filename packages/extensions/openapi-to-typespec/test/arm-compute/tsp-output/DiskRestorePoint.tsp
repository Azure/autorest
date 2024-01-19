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
/**
 * Properties of disk restore point
 */
@parentResource(RestorePoint)
model DiskRestorePoint is ProxyResource<DiskRestorePointProperties> {
  /**
   * The name of the disk restore point created.
   */
  @path
  @key("diskRestorePointName")
  @segment("diskRestorePoints")
  name: string;
}

@armResourceOperations
interface DiskRestorePoints {
  /**
   * Get disk restorePoint resource
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskRestorePoint_Get")
  get is ArmResourceRead<
    DiskRestorePoint,
    {
      ...BaseParameters<DiskRestorePoint>;

      /**
       * The name of the restore point collection that the disk restore point belongs.
       */
      @path
      restorePointCollectionName: string;
    }
  >;

  /**
   * Lists diskRestorePoints under a vmRestorePoint.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskRestorePoint_ListByRestorePoint")
  listByRestorePoint is ArmResourceListByParent<
    DiskRestorePoint,
    {
      ...BaseParameters<DiskRestorePoint>;

      /**
       * The name of the restore point collection that the disk restore point belongs.
       */
      @path
      restorePointCollectionName: string;
    }
  >;

  /**
   * Grants access to a diskRestorePoint.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskRestorePoint_GrantAccess")
  grantAccess is ArmResourceActionAsync<
    DiskRestorePoint,
    GrantAccessData,
    AccessUri,
    {
      ...BaseParameters<DiskRestorePoint>;

      /**
       * The name of the restore point collection that the disk restore point belongs.
       */
      @path
      restorePointCollectionName: string;
    },
    ArmLroLocationHeader
  >;

  /**
   * Revokes access to a diskRestorePoint.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DiskRestorePoint_RevokeAccess")
  revokeAccess is ArmResourceActionAsync<
    DiskRestorePoint,
    void,
    void,
    {
      ...BaseParameters<DiskRestorePoint>;

      /**
       * The name of the restore point collection that the disk restore point belongs.
       */
      @path
      restorePointCollectionName: string;
    },
    ArmLroLocationHeader
  >;
}

@@projectedName(DiskRestorePoints.grantAccess::parameters.body,
  "json",
  "grantAccessData"
);
@@extension(DiskRestorePoints.grantAccess::parameters.body,
  "x-ms-client-name",
  "grantAccessData"
);
@@doc(DiskRestorePoints.grantAccess::parameters.body,
  "Access data object supplied in the body of the get disk access operation."
);
