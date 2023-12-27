import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Tenant Settings.")
@parentResource(ApiManagementServiceResource)
model TenantSettingsContract
  is ProxyResource<TenantSettingsContractProperties> {
  @doc("The identifier of the settings.")
  @key("settingsType")
  @segment("settings")
  name: SettingsTypeName;
}

@armResourceOperations
interface TenantSettings {
  @doc("Get tenant settings.")
  get is ArmResourceRead<TenantSettingsContract>;
  @doc("Public settings.")
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
