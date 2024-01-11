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
@doc("Sign-Up settings for a developer portal.")
@singleton("signup")
@parentResource(ApiManagementServiceResource)
model PortalSignupSettings is ProxyResource<PortalSignupSettingsProperties> {
  @key("portalsetting")
  @segment("portalsettings")
  name: string;
}

@armResourceOperations
@projectedName("client", "PortalSignupSettings")
interface PortalSignupSettingsOperationGroup {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get Sign Up Settings for the Portal")
  @operationId("SignUpSettings_Get")
  get is ArmResourceRead<PortalSignupSettings>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the SignUpSettings.")
  @head
  @operationId("SignUpSettings_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalSignupSettings,
      BaseParameters<PortalSignupSettings>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or Update Sign-Up settings.")
  @operationId("SignUpSettings_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalSignupSettings,
    {
      ...BaseParameters<PortalSignupSettings>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update Sign-Up settings.")
  @operationId("SignUpSettings_Update")
  update is ArmCustomPatchSync<
    PortalSignupSettings,
    PortalSignupSettings,
    {
      ...BaseParameters<PortalSignupSettings>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists a collection of portalsettings defined within a service instance..")
  @operationId("PortalSettings_ListByService")
  listByService is ArmResourceListByParent<PortalSignupSettings>;
}
