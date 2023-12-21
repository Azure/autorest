import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Sign-In settings for the Developer Portal.")
@singleton("signin")
@parentResource(ApiManagementServiceResource)
model PortalSigninSettings is ProxyResource<PortalSigninSettingProperties> {
  @key("signin")
  @segment("portalsettings")
  name: string;
}

@armResourceOperations
interface SignInSettings {
  @doc("Get Sign In Settings for the Portal")
  get is ArmResourceRead<PortalSigninSettings>;
  @doc("Gets the entity state (Etag) version of the SignInSettings.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalSigninSettings,
      BaseParameters<PortalSigninSettings>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Create or Update Sign-In settings.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalSigninSettings,
    {
      ...BaseParameters<PortalSigninSettings>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Update Sign-In settings.")
  update is ArmResourcePatchSync<
    PortalSigninSettings,
    PortalSigninSettingProperties,
    {
      ...BaseParameters<PortalSigninSettings>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
}

@armResourceOperations
interface PortalSettings {
  @doc("Lists a collection of portalsettings defined within a service instance..")
  listByService is ArmResourceListByParent<PortalSigninSettings>;
}
