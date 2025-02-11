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
 * Delegation settings for a developer portal.
 */
@singleton("delegation")
@parentResource(ApiManagementServiceResource)
model PortalDelegationSettings
  is Azure.ResourceManager.ProxyResource<PortalDelegationSettingsProperties> {
  ...ResourceNameParameter<
    Resource = PortalDelegationSettings,
    KeyName = "portalsetting",
    SegmentName = "portalsettings",
    NamePattern = ""
  >;
}

@armResourceOperations
interface DelegationSettings {
  /**
   * Get Delegation Settings for the Portal.
   */
  get is ArmResourceRead<PortalDelegationSettings>;

  /**
   * Gets the entity state (Etag) version of the DelegationSettings.
   */
  getEntityTag is ArmResourceCheckExistence<PortalDelegationSettings>;

  /**
   * Create or Update Delegation settings.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalDelegationSettings,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<PortalDelegationSettings>
  >;

  /**
   * Update Delegation settings.
   */
  @parameterVisibility
  update is ArmCustomPatchSync<
    PortalDelegationSettings,
    PatchModel = PortalDelegationSettings,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    },
    Response = ArmNoContentResponse
  >;

  /**
   * Gets the secret validation key of the DelegationSettings.
   */
  listSecrets is ArmResourceActionSync<
    PortalDelegationSettings,
    void,
    ArmResponse<PortalSettingValidationKeyContract>
  >;
}

@@doc(PortalDelegationSettings.name, "");
@@doc(PortalDelegationSettings.properties,
  "Delegation settings contract properties."
);
@@doc(DelegationSettings.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(DelegationSettings.update::parameters.properties,
  "Update Delegation settings."
);
