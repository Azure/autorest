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
 * User details.
 */
@parentResource(ApiManagementServiceResource)
model UserContract
  is Azure.ResourceManager.ProxyResource<UserContractProperties> {
  ...ResourceNameParameter<
    Resource = UserContract,
    KeyName = "userId",
    SegmentName = "users",
    NamePattern = ""
  >;
}

@armResourceOperations
interface UserContracts {
  /**
   * Gets the details of the user specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("User_Get")
  get is ArmResourceRead<UserContract>;

  /**
   * Gets the entity state (Etag) version of the user specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("User_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<UserContract, BaseParameters<UserContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates a user.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("User_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    UserContract,
    Parameters = {
      /**
       * Send an Email notification to the User.
       */
      @query("notify")
      notify?: boolean;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the user specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("User_Update")
  update is ArmCustomPatchSync<
    UserContract,
    UserUpdateParameters,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes specific user.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("User_Delete")
  delete is ArmResourceDeleteSync<
    UserContract,
    Parameters = {
      /**
       * Whether to delete user's subscription or not.
       */
      @query("deleteSubscriptions")
      deleteSubscriptions?: boolean;

      /**
       * Send an Account Closed Email notification to the User.
       */
      @query("notify")
      notify?: boolean;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;

      /**
       * Determines the type of application which send the create user request. Default is legacy publisher portal.
       */
      @query("appType")
      appType?: AppType;
    }
  >;

  /**
   * Lists a collection of registered users in the specified service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("User_ListByService")
  listByService is ArmResourceListByParent<
    UserContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| firstName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| lastName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| email | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>| registrationDate | filter | ge, le, eq, ne, gt, lt |     |</br>| note | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| groups | expand |     |     |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * Detailed Group in response.
       */
      @query("expandGroups")
      expandGroups?: boolean;
    }
  >;

  /**
   * Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("User_GenerateSsoUrl")
  generateSsoUrl is ArmResourceActionSync<
    UserContract,
    void,
    GenerateSsoUrlResult
  >;

  /**
   * Gets the Shared Access Authorization Token for the User.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("User_GetSharedAccessToken")
  getSharedAccessToken is ArmResourceActionSync<
    UserContract,
    UserTokenParameters,
    UserTokenResult
  >;

  /**
   * Sends confirmation
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("UserConfirmationPassword_Send")
  send is ArmResourceActionNoContentSync<
    UserContract,
    void,
    Parameters = {
      /**
       * Determines the type of application which send the create user request. Default is legacy publisher portal.
       */
      @query("appType")
      appType?: AppType;
    }
  >;

  /**
   * Lists all user groups.
   */
  // FIXME: UserGroup_List could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("UserGroup_List")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/groups")
  @get
  list(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * User identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    userId: string,

    /**
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|------------------------|-----------------------------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
     */
    @query("$filter")
    $filter?: string,

    /**
     * Number of records to return.
     */
    @minValue(1)
    @query("$top")
    $top?: int32,

    /**
     * Number of records to skip.
     */
    @query("$skip")
    $skip?: int32,

    ...SubscriptionIdParameter,
  ): ArmResponse<ResourceListResult<GroupContract>> | ErrorResponse;

  /**
   * List of all user identities.
   */
  // FIXME: UserIdentities_List could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("UserIdentities_List")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/identities")
  @get
  list(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * User identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(80)
    @minLength(1)
    @path
    userId: string,

    ...SubscriptionIdParameter,
  ): ArmResponse<UserIdentityListResult> | ErrorResponse;
}

@@maxLength(UserContract.name, 80);
@@minLength(UserContract.name, 1);
@@doc(UserContract.name,
  "User identifier. Must be unique in the current API Management service instance."
);
@@doc(UserContract.properties, "User entity contract properties.");
@@doc(UserContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@doc(UserContracts.update::parameters.properties, "Update parameters.");
@@doc(UserContracts.getSharedAccessToken::parameters.body,
  "Create Authorization Token parameters."
);
