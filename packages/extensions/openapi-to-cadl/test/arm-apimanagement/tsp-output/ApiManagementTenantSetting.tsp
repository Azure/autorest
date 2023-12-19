import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Tenant Settings.")
@parentResource(ApiManagementService)
model ApiManagementTenantSetting
  is ProxyResource<TenantSettingsContractProperties> {
  @doc("The identifier of the settings.")
  @path
  @key("settingsType")
  @segment("settings")
  name: SettingsTypeName;
}

@armResourceOperations
interface ApiManagementTenantSettings {
  @doc("Get tenant settings.")
  get is ArmResourceRead<ApiManagementTenantSetting>;
  @doc("Public settings.")
  listByService is ArmResourceListByParent<
    ApiManagementTenantSetting,
    {
      ...BaseParameters<ApiManagementTenantSetting>;

      @doc("Not used")
      @query("$filter")
      $filter?: string;
    }
  >;
}
