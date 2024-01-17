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
@doc("Delegation settings for a developer portal.")
@singleton("delegation")
@parentResource(ApiManagementServiceResource)
model PortalDelegationSettings
  is ProxyResource<PortalDelegationSettingsProperties> {
  @key("portalsetting")
  @segment("portalsettings")
  name: string;
}

@armResourceOperations
@projectedName("client", "PortalDelegationSettings")
interface PortalDelegationSettingsOperationGroup {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get Delegation Settings for the Portal.")
  @operationId("DelegationSettings_Get")
  get is ArmResourceRead<PortalDelegationSettings>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the DelegationSettings.")
  @head
  @operationId("DelegationSettings_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalDelegationSettings,
      BaseParameters<PortalDelegationSettings>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or Update Delegation settings.")
  @operationId("DelegationSettings_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalDelegationSettings,
    {
      ...BaseParameters<PortalDelegationSettings>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update Delegation settings.")
  @parameterVisibility("read")
  @operationId("DelegationSettings_Update")
  update is ArmCustomPatchSync<
    PortalDelegationSettings,
    PortalDelegationSettings,
    {
      ...BaseParameters<PortalDelegationSettings>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of portalsettings defined within a service instance..")
  @operationId("PortalSettings_ListByService")
  listByService is ArmResourceListByParent<PortalDelegationSettings>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the secret validation key of the DelegationSettings.")
  @operationId("DelegationSettings_ListSecrets")
  listSecrets is ArmResourceActionSync<
    PortalDelegationSettings,
    void,
    PortalSettingValidationKeyContract
  >;
}

@@projectedName(PortalDelegationSettingsOperationGroup.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(PortalDelegationSettingsOperationGroup.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalDelegationSettingsOperationGroup.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@projectedName(PortalDelegationSettingsOperationGroup.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(PortalDelegationSettingsOperationGroup.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalDelegationSettingsOperationGroup.update::parameters.properties,
  "Update Delegation settings."
);
