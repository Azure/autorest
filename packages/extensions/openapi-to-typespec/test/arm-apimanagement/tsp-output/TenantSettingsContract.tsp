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
/**
 * Tenant Settings.
 */
@parentResource(ApiManagementServiceResource)
model TenantSettingsContract
  is ProxyResource<TenantSettingsContractProperties> {
  /**
   * The identifier of the settings.
   */
  @path
  @key("settingsType")
  @segment("settings")
  @visibility("read")
  name: SettingsTypeName;
}

@armResourceOperations
interface TenantSettingsContracts {
  /**
   * Get tenant settings.
   */
  get is ArmResourceRead<TenantSettingsContract>;

  /**
   * Public settings.
   */
  listByService is ArmResourceListByParent<
    TenantSettingsContract,
    {
      ...BaseParameters<TenantSettingsContract>;

      /**
       * Not used
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}
