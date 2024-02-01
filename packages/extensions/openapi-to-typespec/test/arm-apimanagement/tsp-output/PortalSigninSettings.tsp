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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("signin")
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  PortalSigninSettingProperties
)
model PortalSigninSettings extends ProxyResourceBase {
  @key("portalsetting")
  @segment("portalsettings")
  @visibility("read")
  name: string;

  /**
   * Sign-in settings contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: PortalSigninSettingProperties;
}

@armResourceOperations
@projectedName("client", "PortalSigninSettings")
interface PortalSigninSettingsOperationGroup {
  /**
   * Get Sign In Settings for the Portal
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("SignInSettings_Get")
  get is ArmResourceRead<PortalSigninSettings>;

  /**
   * Gets the entity state (Etag) version of the SignInSettings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("SignInSettings_CreateOrUpdate")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("SignInSettings_Update")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("PortalSettings_ListByService")
  listByService is ArmResourceListByParent<PortalSigninSettings>;
}

@@projectedName(PortalSigninSettingsOperationGroup.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(PortalSigninSettingsOperationGroup.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalSigninSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@projectedName(PortalSigninSettingsOperationGroup.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(PortalSigninSettingsOperationGroup.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalSigninSettingsOperationGroup.update::parameters.properties,
  "Update Sign-In settings."
);
