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
 * Sign-Up settings for a developer portal.
 */
@singleton("signup")
@parentResource(ApiManagementServiceResource)
model PortalSignupSettings is ProxyResource<PortalSignupSettingsProperties> {
  @key("portalsetting")
  @segment("portalsettings")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface PortalSignupSettingsOperationGroup {
  /**
   * Get Sign Up Settings for the Portal
   */
  get is ArmResourceRead<PortalSignupSettings>;

  /**
   * Gets the entity state (Etag) version of the SignUpSettings.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalSignupSettings,
      BaseParameters<PortalSignupSettings>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Create or Update Sign-Up settings.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalSignupSettings,
    {
      ...BaseParameters<PortalSignupSettings>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Update Sign-Up settings.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    PortalSignupSettings,
    PortalSignupSettings,
    {
      ...BaseParameters<PortalSignupSettings>;

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
  listByService is ArmResourceListByParent<PortalSignupSettings>;
}

@@doc(PortalSignupSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(PortalSignupSettingsOperationGroup.update::parameters.properties,
  "Update Sign-Up settings."
);
