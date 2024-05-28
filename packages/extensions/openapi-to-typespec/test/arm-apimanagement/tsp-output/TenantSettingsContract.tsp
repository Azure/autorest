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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  TenantSettingsContractProperties
)
model TenantSettingsContract extends Foundations.ProxyResource {
  /**
   * The identifier of the settings.
   */
  @path
  @key("settingsType")
  @segment("settings")
  @visibility("read")
  name: SettingsTypeName;

  /**
   * TenantSettings entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: TenantSettingsContractProperties;
}

@armResourceOperations
interface TenantSettingsContracts {
  /**
   * Get tenant settings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantSettings_Get")
  get is ArmResourceRead<TenantSettingsContract>;

  /**
   * Public settings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TenantSettings_ListByService")
  listByService is ArmResourceListByParent<
    TenantSettingsContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<TenantSettingsContract>;

      /**
       * Not used
       */
      @query("$filter")
      $filter?: string;
    }
  >;
}
