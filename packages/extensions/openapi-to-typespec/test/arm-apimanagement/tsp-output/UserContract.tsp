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
@doc("User details.")
@parentResource(ApiManagementServiceResource)
model UserContract is ProxyResource<UserContractProperties> {
  @doc("User identifier. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @key("userId")
  @segment("users")
  name: string;
}

@armResourceOperations
@projectedName("client", "User")
interface UserContracts_User {
  @doc("Gets the details of the user specified by its identifier.")
  get is ArmResourceRead<UserContract>;

  @doc("Gets the entity state (Etag) version of the user specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<UserContract, BaseParameters<UserContract>>,
  ): OkResponse | ErrorResponse;

  @doc("Creates or Updates a user.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    UserContract,
    {
      ...BaseParameters<UserContract>;

      @doc("Send an Email notification to the User.")
      @query("notify")
      notify?: boolean;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  @doc("Updates the details of the user specified by its identifier.")
  update is ArmCustomPatchSync<
    UserContract,
    UserUpdateParameters,
    {
      ...BaseParameters<UserContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Deletes specific user.")
  delete is ArmResourceDeleteSync<
    UserContract,
    {
      ...BaseParameters<UserContract>;

      @doc("Whether to delete user's subscription or not.")
      @query("deleteSubscriptions")
      deleteSubscriptions?: boolean;

      @doc("Send an Account Closed Email notification to the User.")
      @query("notify")
      notify?: boolean;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;

      @doc("Determines the type of application which send the create user request. Default is legacy publisher portal.")
      @query("appType")
      appType?: AppType;
    }
  >;

  @doc("Lists a collection of registered users in the specified service instance.")
  listByService is ArmResourceListByParent<
    UserContract,
    {
      ...BaseParameters<UserContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| firstName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| lastName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| email | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>| registrationDate | filter | ge, le, eq, ne, gt, lt |     |</br>| note | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| groups | expand |     |     |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Detailed Group in response.")
      @query("expandGroups")
      expandGroups?: boolean;
    }
  >;

  @doc("Retrieves a redirection URL containing an authentication token for signing a given user into the developer portal.")
  generateSsoUrl is ArmResourceActionSync<
    UserContract,
    void,
    GenerateSsoUrlResult
  >;

  @doc("Gets the Shared Access Authorization Token for the User.")
  getSharedAccessToken is ArmResourceActionSync<
    UserContract,
    UserTokenParameters,
    UserTokenResult
  >;
}

@armResourceOperations
@projectedName("client", "UserConfirmationPassword")
interface UserContracts_UserConfirmationPassword {
  @doc("Sends confirmation")
  send is ArmResourceActionNoContentSync<
    UserContract,
    void,
    {
      ...BaseParameters<UserContract>;

      @doc("Determines the type of application which send the create user request. Default is legacy publisher portal.")
      @query("appType")
      appType?: AppType;
    }
  >;
}

@armResourceOperations
@projectedName("client", "UserGroup")
interface UserContracts_UserGroup {
  @doc("Lists all user groups.")
  // FIXME: UserGroup_List could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/groups")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("User identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|------------------------|-----------------------------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceListResult<GroupContract>
  >;
}

@armResourceOperations
@projectedName("client", "UserIdentities")
interface UserContracts_UserIdentities {
  @doc("List of all user identities.")
  // FIXME: UserIdentities_List could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/users/{userId}/identities")
  @get
  List is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("User identifier. Must be unique in the current API Management service instance.")
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    UserIdentityListResult
  >;
}
