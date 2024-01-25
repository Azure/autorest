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

namespace Microsoft.NetworkAnalytics;
/**
 * The data product resource.
 */
model DataProduct is TrackedResource<DataProductProperties> {
  /**
   * The data product resource name
   */
  @maxLength(63)
  @minLength(3)
  @pattern("^[a-z][a-z0-9]*$")
  @path
  @key("dataProductName")
  @segment("dataProducts")
  @visibility("read")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
}

@armResourceOperations
interface DataProducts {
  /**
   * Retrieve data product resource.
   */
  get is ArmResourceRead<DataProduct>;

  /**
   * Create data product resource.
   */
  create is ArmResourceCreateOrReplaceAsync<
    DataProduct,
    BaseParameters<DataProduct>,
    ArmAsyncOperationHeader
  >;

  /**
   * Update data product resource.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchAsync<
    DataProduct,
    DataProductUpdate,
    BaseParameters<DataProduct>,
    ArmLroLocationHeader
  >;

  /**
   * Delete data product resource.
   */
  delete is ArmResourceDeleteWithoutOkAsync<
    DataProduct,
    BaseParameters<DataProduct>,
    ArmLroLocationHeader
  >;

  /**
   * List data products by resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DataProducts_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<DataProduct>;

  /**
   * List data products by subscription.
   */
  listBySubscription is ArmListBySubscription<DataProduct>;

  /**
   * Assign role to the data product.
   */
  addUserRole is ArmResourceActionSync<
    DataProduct,
    RoleAssignmentCommonProperties,
    RoleAssignmentDetail
  >;

  /**
   * Generate sas token for storage account.
   */
  generateStorageAccountSasToken is ArmResourceActionSync<
    DataProduct,
    AccountSas,
    AccountSasToken
  >;

  /**
   * List user roles associated with the data product.
   */
  listRolesAssignments is ArmResourceActionSync<
    DataProduct,
    AnyObject,
    ListRoleAssignments
  >;

  /**
   * Remove role from the data product.
   */
  removeUserRole is ArmResourceActionNoContentSync<
    DataProduct,
    RoleAssignmentDetail
  >;

  /**
   * Initiate key rotation on Data Product.
   */
  rotateKey is ArmResourceActionNoContentSync<DataProduct, KeyVaultInfo>;
}
