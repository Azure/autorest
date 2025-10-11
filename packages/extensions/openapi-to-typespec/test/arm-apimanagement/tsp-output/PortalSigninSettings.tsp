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
/** Sign-In settings for the Developer Portal. */
@singleton("signin")
@parentResource(ApiManagementServiceResource)
model PortalSigninSettings
  is Azure.ResourceManager.ProxyResource<PortalSigninSettingProperties> {
  ...ResourceNameParameter<
    Resource = PortalSigninSettings,
    KeyName = "portalsetting",
    SegmentName = "portalsettings",
    NamePattern = ""
  >;
}

@armResourceOperations
interface SignInSettings {
  /** Get Sign In Settings for the Portal */
  get is ArmResourceRead<PortalSigninSettings>;

  /** Gets the entity state (Etag) version of the SignInSettings. */
  getEntityTag is ArmResourceCheckExistence<PortalSigninSettings>;

  /** Create or Update Sign-In settings. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PortalSigninSettings,
    Parameters = {
      /** ETag of the Entity. Not required when creating an entity, but required when updating an entity. */
      @header
      `If-Match`?: string;
    },
    Response = ArmResourceUpdatedResponse<PortalSigninSettings>
  >;

  /** Update Sign-In settings. */
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    PortalSigninSettings,
    PatchModel = PortalSigninSettings,
    Parameters = {
      /** ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update. */
      @header
      `If-Match`: string;
    },
    Response = ArmNoContentResponse
  >;
}

@@doc(PortalSigninSettings.name, "");
@@doc(PortalSigninSettings.properties, "Sign-in settings contract properties.");
@@doc(SignInSettings.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(SignInSettings.update::parameters.properties, "Update Sign-In settings.");
