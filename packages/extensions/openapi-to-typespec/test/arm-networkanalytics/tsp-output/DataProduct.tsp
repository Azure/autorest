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
@doc("The data product resource.")
model DataProduct is TrackedResource<DataProductProperties> {
  @doc("The data product resource name")
  @maxLength(63)
  @minLength(3)
  @pattern("^[a-z][a-z0-9]*$")
  @path
  @key("dataProductName")
  @segment("dataProducts")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
}

@armResourceOperations
interface DataProducts {
  @doc("Retrieve data product resource.")
  get is ArmResourceRead<DataProduct>;

  @doc("Create data product resource.")
  create is ArmResourceCreateOrUpdateAsync<
    DataProduct,
    BaseParameters<DataProduct>,
    ArmAsyncOperationHeader
  >;

  @doc("Update data product resource.")
  update is ArmCustomPatchAsync<
    DataProduct,
    DataProductUpdate,
    BaseParameters<DataProduct>,
    ArmLroLocationHeader
  >;

  @doc("Delete data product resource.")
  delete is ArmResourceDeleteWithoutOkAsync<
    DataProduct,
    BaseParameters<DataProduct>,
    ArmLroLocationHeader
  >;

  @doc("List data products by resource group.")
  listByResourceGroup is ArmResourceListByParent<DataProduct>;

  @doc("List data products by subscription.")
  listBySubscription is ArmListBySubscription<DataProduct>;

  @doc("Assign role to the data product.")
  addUserRole is ArmResourceActionSync<
    DataProduct,
    RoleAssignmentCommonProperties,
    RoleAssignmentDetail
  >;

  @doc("Generate sas token for storage account.")
  generateStorageAccountSasToken is ArmResourceActionSync<
    DataProduct,
    AccountSas,
    AccountSasToken
  >;

  @doc("List user roles associated with the data product.")
  listRolesAssignments is ArmResourceActionSync<
    DataProduct,
    Record<unknown>,
    ListRoleAssignments
  >;

  @doc("Remove role from the data product.")
  removeUserRole is ArmResourceActionNoContentSync<
    DataProduct,
    RoleAssignmentDetail
  >;

  @doc("Initiate key rotation on Data Product.")
  rotateKey is ArmResourceActionNoContentSync<DataProduct, KeyVaultInfo>;
}
