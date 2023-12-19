import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Sign-In settings for the Developer Portal.")
@parentResource(ApiManagementService)
@singleton("signin")
model ApiManagementPortalSignInSetting
  is ProxyResource<PortalSigninSettingProperties> {
  @key("signin")
  @segment("portalsettings")
  name: string;
}

@armResourceOperations
interface ApiManagementPortalSignInSettings {
  @doc("Get Sign In Settings for the Portal")
  get is ArmResourceRead<ApiManagementPortalSignInSetting>;
  @doc("Gets the entity state (Etag) version of the SignInSettings.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementPortalSignInSetting,
      BaseParameters<ApiManagementPortalSignInSetting>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Create or Update Sign-In settings.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementPortalSignInSetting,
    {
      ...BaseParameters<ApiManagementPortalSignInSetting>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Update Sign-In settings.")
  update is ArmResourcePatchSync<
    ApiManagementPortalSignInSetting,
    PortalSigninSettingProperties,
    {
      ...BaseParameters<ApiManagementPortalSignInSetting>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of portalsettings defined within a service instance..")
  listByApiManagementService is ArmResourceListByParent<ApiManagementPortalSignInSetting>;
}
