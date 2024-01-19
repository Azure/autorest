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
 * User details.
 */
@parentResource(ApiManagementServiceResource)
model UserContract is ProxyResource<UserContractProperties> {
  /**
   * User identifier. Must be unique in the current API Management service instance.
   */
  @maxLength(80)
  @minLength(1)
  @path
  @key("userId")
  @segment("users")
  name: string;
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
      ...BaseParameters<UserContract>;

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
  @parameterVisibility("read")
  @operationId("User_Update")
  update is ArmCustomPatchSync<
    UserContract,
    UserUpdateParameters,
    {
      ...BaseParameters<UserContract>;

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
  @operationId("User_Delete")
  delete is ArmResourceDeleteSync<
    UserContract,
    {
      ...BaseParameters<UserContract>;

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
      ...BaseParameters<UserContract>;

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
      ...BaseParameters<UserContract>;

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
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * User identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|------------------------|-----------------------------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    ResourceListResult<GroupContract>
  >;

  /**
   * List of all user identities.
   */
  // FIXME: UserIdentities_List could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("UserIdentities_List")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/identities")
  @get
  list is Azure.Core.Foundations.Operation<
    {
      /**
       * The name of the resource group.
       */
      @path
      resourceGroupName: string;

      /**
       * The name of the API Management service.
       */
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      /**
       * User identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;

      /**
       * Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
       */
      @path
      subscriptionId: string;
    },
    UserIdentityListResult
  >;
}

@@projectedName(UserContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(UserContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(UserContracts.createOrUpdate::parameters.resource,
  "Create or update parameters."
);
@@projectedName(UserContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(UserContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(UserContracts.update::parameters.properties, "Update parameters.");
@@projectedName(UserContracts.getSharedAccessToken::parameters.body,
  "json",
  "parameters"
);
@@extension(UserContracts.getSharedAccessToken::parameters.body,
  "x-ms-client-name",
  "parameters"
);
@@doc(UserContracts.getSharedAccessToken::parameters.body,
  "Create Authorization Token parameters."
);
