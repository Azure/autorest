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
 * Sign-In settings for the Developer Portal.
 */
@singleton("signin")
@parentResource(ApiManagementServiceResource)
model PortalSigninSettings
  is Azure.ResourceManager.ProxyResource<PortalSigninSettingProperties> {
  ...ResourceNameParameter<
    Resource = PortalSigninSettings,
    KeyName = "portalsetting",
    SegmentName = "portalsettings",
    NamePattern = ""
  >;
}

@armResourceOperations
interface PortalSigninSettingsOperationGroup {
  /**
   * Get Sign In Settings for the Portal
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("SignInSettings_Get")
  get is ArmResourceRead<PortalSigninSettings>;

  /**
   * Gets the entity state (Etag) version of the SignInSettings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("SignInSettings_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalSigninSettings,
      BaseParameters<PortalSigninSettings>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Create or Update Sign-In settings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("SignInSettings_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalSigninSettings,
    Parameters = {
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
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("SignInSettings_Update")
  update is ArmCustomPatchSync<
    PortalSigninSettings,
    PortalSigninSettings,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;
}

@@doc(PortalSigninSettings.name, "");
@@doc(PortalSigninSettings.properties, "Sign-in settings contract properties.");
@@doc(PortalSigninSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(PortalSigninSettingsOperationGroup.update::parameters.properties,
  "Update Sign-In settings."
);
