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
 * Sign-In settings for the Developer Portal.
 */
@singleton("signin")
@parentResource(ApiManagementServiceResource)
model PortalSigninSettings is ProxyResource<PortalSigninSettingProperties> {
  @key("portalsetting")
  @segment("portalsettings")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface PortalSigninSettingsOperationGroup {
  /**
   * Get Sign In Settings for the Portal
   */
  get is ArmResourceRead<PortalSigninSettings>;

  /**
   * Gets the entity state (Etag) version of the SignInSettings.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalSigninSettings,
      BaseParameters<PortalSigninSettings>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Create or Update Sign-In settings.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalSigninSettings,
    {
      ...BaseParameters<PortalSigninSettings>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Update Sign-In settings.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    PortalSigninSettings,
    PortalSigninSettings,
    {
      ...BaseParameters<PortalSigninSettings>;

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
  listByService is ArmResourceListByParent<PortalSigninSettings>;
}

@@doc(PortalSigninSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(PortalSigninSettingsOperationGroup.update::parameters.properties,
  "Update Sign-In settings."
);
