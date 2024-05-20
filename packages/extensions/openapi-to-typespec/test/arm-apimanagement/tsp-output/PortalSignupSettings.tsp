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
 * Sign-Up settings for a developer portal.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("signup")
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  PortalSignupSettingsProperties
)
model PortalSignupSettings extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = PortalSignupSettings,
    KeyName = "portalsetting",
    SegmentName = "portalsettings",
    NamePattern = ""
  >;

  /**
   * Sign-up settings contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: PortalSignupSettingsProperties;
}

@armResourceOperations
interface PortalSignupSettingsOperationGroup {
  /**
   * Get Sign Up Settings for the Portal
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("SignUpSettings_Get")
  get is ArmResourceRead<PortalSignupSettings>;

  /**
   * Gets the entity state (Etag) version of the SignUpSettings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("SignUpSettings_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalSignupSettings,
      BaseParameters<PortalSignupSettings>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Create or Update Sign-Up settings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("SignUpSettings_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalSignupSettings,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<PortalSignupSettings>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("SignUpSettings_Update")
  update is ArmCustomPatchSync<
    PortalSignupSettings,
    PortalSignupSettings,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<PortalSignupSettings>;

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
  listByService is ArmResourceListByParent<PortalSignupSettings>;
}

@@doc(PortalSignupSettings.name, "");
@@encodedName(PortalSignupSettingsOperationGroup.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(PortalSignupSettingsOperationGroup.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalSignupSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@encodedName(PortalSignupSettingsOperationGroup.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(PortalSignupSettingsOperationGroup.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalSignupSettingsOperationGroup.update::parameters.properties,
  "Update Sign-Up settings."
);
