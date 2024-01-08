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
@doc("Delegation settings for a developer portal.")
@singleton("delegation")
@parentResource(ApiManagementServiceResource)
model PortalDelegationSettings
  is ProxyResource<PortalDelegationSettingsProperties> {
  @key("portalsetting")
  @segment("portalsettings")
  name: string;
}

@armResourceOperations
@projectedName("client", "DelegationSettings")
interface PortalDelegationSettings_DelegationSettings {
  @doc("Get Delegation Settings for the Portal.")
  get is ArmResourceRead<PortalDelegationSettings>;
  @doc("Gets the entity state (Etag) version of the DelegationSettings.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalDelegationSettings,
      BaseParameters<PortalDelegationSettings>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Create or Update Delegation settings.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalDelegationSettings,
    {
      ...BaseParameters<PortalDelegationSettings>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Update Delegation settings.")
  update is ArmCustomPatchSync<
    PortalDelegationSettings,
    PortalDelegationSettings,
    {
      ...BaseParameters<PortalDelegationSettings>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Gets the secret validation key of the DelegationSettings.")
  listSecrets is ArmResourceActionSync<
    PortalDelegationSettings,
    void,
    PortalSettingValidationKeyContract
  >;
}

@armResourceOperations
@projectedName("client", "PortalSettings")
interface PortalDelegationSettings_PortalSettings {
  @doc("Lists a collection of portalsettings defined within a service instance..")
  listByService is ArmResourceListByParent<PortalDelegationSettings>;
}
