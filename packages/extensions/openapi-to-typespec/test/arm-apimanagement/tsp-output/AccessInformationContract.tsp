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
/**
 * Tenant Settings.
 */
@parentResource(ApiManagementServiceResource)
model AccessInformationContract
  is ProxyResource<AccessInformationContractProperties> {
  /**
   * The identifier of the Access configuration.
   */
  @path
  @key("accessName")
  @segment("tenant")
  @visibility("read")
  name: AccessIdName;
}

@armResourceOperations
interface AccessInformationContracts {
  /**
   * Get tenant access information details without secrets.
   */
  get is ArmResourceRead<AccessInformationContract>;

  /**
   * Tenant access metadata
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      AccessInformationContract,
      BaseParameters<AccessInformationContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Update tenant access information details.
   */
  create is ArmResourceCreateOrReplaceSync<
    AccessInformationContract,
    {
      ...BaseParameters<AccessInformationContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Update tenant access information details.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    AccessInformationContract,
    AccessInformationUpdateParameters,
    {
      ...BaseParameters<AccessInformationContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Returns list of access infos - for Git and Management endpoints.
   */
  listByService is ArmResourceListByParent<
    AccessInformationContract,
    {
      ...BaseParameters<AccessInformationContract>;

      /**
       * Not used
       */
      @query("$filter")
      $filter?: string;
    }
  >;

  /**
   * Regenerate primary access key
   */
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * Regenerate secondary access key
   */
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * Get tenant access information details.
   */
  listSecrets is ArmResourceActionSync<
    AccessInformationContract,
    void,
    AccessInformationSecretsContract
  >;

  /**
   * Regenerate primary access key for GIT.
   */
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  /**
   * Regenerate secondary access key for GIT.
   */
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;
}

@@doc(AccessInformationContracts.create::parameters.resource,
  "Parameters supplied to retrieve the Tenant Access Information."
);
@@doc(AccessInformationContracts.update::parameters.properties,
  "Parameters supplied to retrieve the Tenant Access Information."
);
