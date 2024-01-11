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
@doc("Sign-In settings for the Developer Portal.")
@singleton("signin")
@parentResource(ApiManagementServiceResource)
model PortalSigninSettings is ProxyResource<PortalSigninSettingProperties> {
  @key("portalsetting")
  @segment("portalsettings")
  name: string;
}

@armResourceOperations
@projectedName("client", "PortalSigninSettings")
interface PortalSigninSettingsOperationGroup {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get Sign In Settings for the Portal")
  @operationId("SignInSettings_Get")
  get is ArmResourceRead<PortalSigninSettings>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the SignInSettings.")
  @head
  @operationId("SignInSettings_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalSigninSettings,
      BaseParameters<PortalSigninSettings>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or Update Sign-In settings.")
  @operationId("SignInSettings_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalSigninSettings,
    {
      ...BaseParameters<PortalSigninSettings>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update Sign-In settings.")
  @operationId("SignInSettings_Update")
  update is ArmCustomPatchSync<
    PortalSigninSettings,
    PortalSigninSettings,
    {
      ...BaseParameters<PortalSigninSettings>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of portalsettings defined within a service instance..")
  @operationId("PortalSettings_ListByService")
  listByService is ArmResourceListByParent<PortalSigninSettings>;
}
