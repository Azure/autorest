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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("signup")
@parentResource(ApiManagementServiceResource)
@Azure.ResourceManager.Private.armResourceInternal(
  PortalSignupSettingsProperties
)
@includeInapplicableMetadataInPayload(false)
model PortalSignupSettings extends ProxyResourceBase {
  @key("portalsetting")
  @segment("portalsettings")
  name: string;

  /**
   * Sign-up settings contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: PortalSignupSettingsProperties;
}

@armResourceOperations
@projectedName("client", "PortalSignupSettings")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility("read")
  @operationId("SignUpSettings_Update")
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("PortalSettings_ListByService")
  listByService is ArmResourceListByParent<PortalSignupSettings>;
}

@@projectedName(PortalSignupSettingsOperationGroup.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(PortalSignupSettingsOperationGroup.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalSignupSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@projectedName(PortalSignupSettingsOperationGroup.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(PortalSignupSettingsOperationGroup.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalSignupSettingsOperationGroup.update::parameters.properties,
  "Update Sign-Up settings."
);
