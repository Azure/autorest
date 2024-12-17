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
@singleton("signup")
@parentResource(ApiManagementServiceResource)
model PortalSignupSettings
  is Azure.ResourceManager.ProxyResource<PortalSignupSettingsProperties> {
  ...ResourceNameParameter<
    Resource = PortalSignupSettings,
    KeyName = "portalsetting",
    SegmentName = "portalsettings",
    NamePattern = ""
  >;
}

@armResourceOperations
interface PortalSignupSettingsOperationGroup {
  /**
   * Get Sign Up Settings for the Portal
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("SignUpSettings_Get")
  get is ArmResourceRead<PortalSignupSettings>;

  /**
   * Gets the entity state (Etag) version of the SignUpSettings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("SignUpSettings_GetEntityTag")
  getEntityTag is ArmResourceCheckExistence<PortalSignupSettings>;

  /**
   * Create or Update Sign-Up settings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("SignUpSettings_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalSignupSettings,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<PortalSignupSettings>
  >;

  /**
   * Update Sign-Up settings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("SignUpSettings_Update")
  update is ArmCustomPatchSync<
    PortalSignupSettings,
    PatchModel = PortalSignupSettings,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    },
    Response = ArmNoContentResponse
  >;
}

@@doc(PortalSignupSettings.name, "");
@@doc(PortalSignupSettings.properties, "Sign-up settings contract properties.");
@@doc(PortalSignupSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(PortalSignupSettingsOperationGroup.update::parameters.properties,
  "Update Sign-Up settings."
);
