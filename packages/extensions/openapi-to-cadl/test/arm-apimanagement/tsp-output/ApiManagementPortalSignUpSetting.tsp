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
@doc("Sign-Up settings for a developer portal.")
@parentResource(ApiManagementService)
@singleton("signup")
model ApiManagementPortalSignUpSetting
  is ProxyResource<PortalSignupSettingsProperties> {
  @key("signup")
  @segment("portalsettings")
  name: string;
}

@armResourceOperations
interface ApiManagementPortalSignUpSettings {
  @doc("Get Sign Up Settings for the Portal")
  get is ArmResourceRead<ApiManagementPortalSignUpSetting>;
  @doc("Gets the entity state (Etag) version of the SignUpSettings.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementPortalSignUpSetting,
      BaseParameters<ApiManagementPortalSignUpSetting>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Create or Update Sign-Up settings.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementPortalSignUpSetting,
    {
      ...BaseParameters<ApiManagementPortalSignUpSetting>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Update Sign-Up settings.")
  update is ArmResourcePatchSync<
    ApiManagementPortalSignUpSetting,
    PortalSignupSettingsProperties,
    {
      ...BaseParameters<ApiManagementPortalSignUpSetting>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of portalsettings defined within a service instance..")
  listByApiManagementService is ArmResourceListByParent<ApiManagementPortalSignUpSetting>;
}
