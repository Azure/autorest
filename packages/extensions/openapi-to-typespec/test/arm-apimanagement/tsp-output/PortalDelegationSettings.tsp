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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("delegation")
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  PortalDelegationSettingsProperties
)
model PortalDelegationSettings extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = PortalDelegationSettings,
    KeyName = "portalsetting",
    SegmentName = "portalsettings",
    NamePattern = ""
  >;

  /**
   * Delegation settings contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: PortalDelegationSettingsProperties;
}

@armResourceOperations
interface PortalDelegationSettingsOperationGroup {
  /**
   * Get Delegation Settings for the Portal.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DelegationSettings_Get")
  get is ArmResourceRead<PortalDelegationSettings>;

  /**
   * Gets the entity state (Etag) version of the DelegationSettings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("DelegationSettings_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalDelegationSettings,
      BaseParameters<PortalDelegationSettings>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Create or Update Delegation settings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DelegationSettings_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalDelegationSettings,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<PortalDelegationSettings>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("DelegationSettings_Update")
  update is ArmCustomPatchSync<
    PortalDelegationSettings,
    PortalDelegationSettings,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<PortalDelegationSettings>;

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
  listByService is ArmResourceListByParent<PortalDelegationSettings>;

  /**
   * Gets the secret validation key of the DelegationSettings.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DelegationSettings_ListSecrets")
  listSecrets is ArmResourceActionSync<
    PortalDelegationSettings,
    void,
    PortalSettingValidationKeyContract
  >;
}

@@doc(PortalDelegationSettings.name, "");
@@encodedName(PortalDelegationSettingsOperationGroup.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(PortalDelegationSettingsOperationGroup.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalDelegationSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@encodedName(PortalDelegationSettingsOperationGroup.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(PortalDelegationSettingsOperationGroup.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalDelegationSettingsOperationGroup.update::parameters.properties,
  "Update Delegation settings."
);
