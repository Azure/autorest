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
@doc("Delegation settings for a developer portal.")
@parentResource(ApiManagementService)
@singleton("delegation")
model ApiManagementPortalDelegationSetting
  is ProxyResource<PortalDelegationSettingsProperties> {
  @key("delegation")
  @segment("portalsettings")
  name: string;
}

@armResourceOperations
interface ApiManagementPortalDelegationSettings {
  @doc("Get Delegation Settings for the Portal.")
  get is ArmResourceRead<ApiManagementPortalDelegationSetting>;
  @doc("Gets the entity state (Etag) version of the DelegationSettings.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementPortalDelegationSetting,
      BaseParameters<ApiManagementPortalDelegationSetting>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Create or Update Delegation settings.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementPortalDelegationSetting,
    {
      ...BaseParameters<ApiManagementPortalDelegationSetting>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Update Delegation settings.")
  update is ArmResourcePatchSync<
    ApiManagementPortalDelegationSetting,
    PortalDelegationSettingsProperties,
    {
      ...BaseParameters<ApiManagementPortalDelegationSetting>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of portalsettings defined within a service instance..")
  listByApiManagementService is ArmResourceListByParent<ApiManagementPortalDelegationSetting>;
  @doc("Gets the secret validation key of the DelegationSettings.")
  listSecrets is ArmResourceActionSync<
    ApiManagementPortalDelegationSetting,
    void,
    PortalSettingValidationKeyContract
  >;
}
