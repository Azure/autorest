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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(UserContractProperties)
model UserContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = UserContract,
    KeyName = "userId",
    SegmentName = "users",
    NamePattern = ""
  >;

  /**
   * User entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: UserContractProperties;
}

@armResourceOperations
interface UserContracts {
  /**
   * Gets the details of the user specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("User_Get")
  get is ArmResourceRead<UserContract>;

  /**
   * Gets the entity state (Etag) version of the user specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("User_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<UserContract, BaseParameters<UserContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates a user.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("User_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    UserContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<UserContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("User_Update")
  update is ArmCustomPatchSync<
    UserContract,
    UserUpdateParameters,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<UserContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("User_Delete")
  delete is ArmResourceDeleteSync<
    UserContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<UserContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("User_ListByService")
  listByService is ArmResourceListByParent<
    UserContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<UserContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("User_GenerateSsoUrl")
  generateSsoUrl is ArmResourceActionSync<
    UserContract,
    void,
    GenerateSsoUrlResult
  >;

  /**
   * Gets the Shared Access Authorization Token for the User.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("User_GetSharedAccessToken")
  getSharedAccessToken is ArmResourceActionSync<
    UserContract,
    UserTokenParameters,
    UserTokenResult
  >;

  /**
   * Sends confirmation
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("UserConfirmationPassword_Send")
  send is ArmResourceActionNoContentSync<
    UserContract,
    void,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<UserContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
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
@@encodedName(UserContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(UserContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(UserContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@encodedName(UserContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(UserContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(UserContracts.update::parameters.properties, "Update parameters.");
@@encodedName(UserContracts.getSharedAccessToken::parameters.body,
  "application/json",
  "parameters"
);
@@extension(UserContracts.getSharedAccessToken::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(UserContracts.getSharedAccessToken::parameters.body,
  "Create Authorization Token parameters."
);
