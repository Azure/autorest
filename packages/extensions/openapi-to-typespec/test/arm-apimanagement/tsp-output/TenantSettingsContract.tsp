import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Tenant Settings.
 */
@parentResource(ApiManagementServiceResource)
model TenantSettingsContract
  is Azure.ResourceManager.ProxyResource<TenantSettingsContractProperties> {
  ...ResourceNameParameter<
    Resource = TenantSettingsContract,
    KeyName = "settingsType",
    SegmentName = "settings",
    NamePattern = "",
    Type = SettingsTypeName
  >;
}

@armResourceOperations
interface TenantSettingsContracts {
  /**
   * Get tenant settings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantSettings_Get")
  get is ArmResourceRead<TenantSettingsContract>;

  /**
   * Public settings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("TenantSettings_ListByService")
  listByService is ArmResourceListByParent<
    TenantSettingsContract,
    Parameters = {
      /**
       * Not used
       */
      @query("$filter")
      $filter?: string;
    },
    Response = TenantSettingsListResult
  >;
}

@@doc(TenantSettingsContract.name, "The identifier of the settings.");
@@doc(TenantSettingsContract.properties,
  "TenantSettings entity contract properties."
);
