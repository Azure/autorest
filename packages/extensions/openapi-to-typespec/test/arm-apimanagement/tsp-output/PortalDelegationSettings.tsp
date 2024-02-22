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
 * Delegation settings for a developer portal.
 */
@singleton("delegation")
@parentResource(ApiManagementServiceResource)
model PortalDelegationSettings
  is ProxyResource<PortalDelegationSettingsProperties> {
  @key("portalsetting")
  @segment("portalsettings")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface PortalDelegationSettingsOperationGroup {
  /**
   * Get Delegation Settings for the Portal.
   */
  get is ArmResourceRead<PortalDelegationSettings>;

  /**
   * Gets the entity state (Etag) version of the DelegationSettings.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalDelegationSettings,
      BaseParameters<PortalDelegationSettings>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Create or Update Delegation settings.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalDelegationSettings,
    {
      ...BaseParameters<PortalDelegationSettings>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Update Delegation settings.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    PortalDelegationSettings,
    PortalDelegationSettings,
    {
      ...BaseParameters<PortalDelegationSettings>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of portalsettings defined within a service instance..
   */
  listByService is ArmResourceListByParent<PortalDelegationSettings>;

  /**
   * Gets the secret validation key of the DelegationSettings.
   */
  listSecrets is ArmResourceActionSync<
    PortalDelegationSettings,
    void,
    PortalSettingValidationKeyContract
  >;
}

@@doc(PortalDelegationSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(PortalDelegationSettingsOperationGroup.update::parameters.properties,
  "Update Delegation settings."
);
