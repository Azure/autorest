import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.NetworkAnalytics;
/**
 * The data product resource.
 */
model DataProduct
  is Azure.ResourceManager.TrackedResource<DataProductProperties> {
  ...ResourceNameParameter<
    Resource = DataProduct,
    KeyName = "dataProductName",
    SegmentName = "dataProducts",
    NamePattern = "^[a-z][a-z0-9]*$"
  >;
  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
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
  create is ArmResourceCreateOrReplaceAsync<DataProduct>;

  /**
   * Update data product resource.
   */
  @parameterVisibility
  update is ArmCustomPatchAsync<DataProduct, DataProductUpdate>;

  /**
   * Delete data product resource.
   */
  delete is ArmResourceDeleteWithoutOkAsync<DataProduct>;

  /**
   * List data products by resource group.
   */
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
    Record<unknown>,
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

@@maxLength(DataProduct.name, 63);
@@minLength(DataProduct.name, 3);
@@doc(DataProduct.name, "The data product resource name");
