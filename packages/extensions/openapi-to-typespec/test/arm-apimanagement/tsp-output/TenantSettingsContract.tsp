import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
@doc("Tenant Settings.")
@parentResource(ApiManagementServiceResource)
model TenantSettingsContract
  is ProxyResource<TenantSettingsContractProperties> {
  @doc("The identifier of the settings.")
  @path
  @key("settingsType")
  @segment("settings")
  name: SettingsTypeName;
}

@armResourceOperations
interface TenantSettingsContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get tenant settings.")
  @operationId("TenantSettings_Get")
  get is ArmResourceRead<TenantSettingsContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Public settings.")
  @operationId("TenantSettings_ListByService")
  listByService is ArmResourceListByParent<
    TenantSettingsContract,
    {
      ...BaseParameters<TenantSettingsContract>;

      @doc("Not used")
      @query("$filter")
      $filter?: string;
    }
  >;
}
