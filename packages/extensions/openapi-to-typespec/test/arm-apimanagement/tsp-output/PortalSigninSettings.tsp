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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("signin")
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  PortalSigninSettingProperties
)
model PortalSigninSettings extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = PortalSigninSettings,
    KeyName = "portalsetting",
    SegmentName = "portalsettings",
    NamePattern = ""
  >;

  /**
   * Sign-in settings contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: PortalSigninSettingProperties;
}

@armResourceOperations
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
      ...Azure.ResourceManager.Foundations.BaseParameters<PortalSigninSettings>;

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
  @parameterVisibility
  @operationId("SignInSettings_Update")
  update is ArmCustomPatchSync<
    PortalSigninSettings,
    PortalSigninSettings,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<PortalSigninSettings>;

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

@@doc(PortalSigninSettings.name, "");
@@encodedName(PortalSigninSettingsOperationGroup.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(PortalSigninSettingsOperationGroup.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalSigninSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@encodedName(PortalSigninSettingsOperationGroup.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(PortalSigninSettingsOperationGroup.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalSigninSettingsOperationGroup.update::parameters.properties,
  "Update Sign-In settings."
);
