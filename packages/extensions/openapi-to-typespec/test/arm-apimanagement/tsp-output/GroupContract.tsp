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
 * Contract details.
 */
@parentResource(ApiManagementServiceResource)
model GroupContract
  is Azure.ResourceManager.ProxyResource<GroupContractProperties> {
  ...ResourceNameParameter<
    Resource = GroupContract,
    KeyName = "groupId",
    SegmentName = "groups",
    NamePattern = ""
  >;
}

@armResourceOperations
interface GroupContracts {
  /**
   * Gets the details of the group specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Group_Get")
  get is ArmResourceRead<GroupContract>;

  /**
   * Gets the entity state (Etag) version of the group specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("Group_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<GroupContract, BaseParameters<GroupContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates a group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Group_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    GroupContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates the details of the group specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("Group_Update")
  update is ArmCustomPatchSync<
    GroupContract,
    GroupUpdateParameters,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes specific group of the API Management service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Group_Delete")
  delete is ArmResourceDeleteSync<
    GroupContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists a collection of groups defined within a service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Group_ListByService")
  listByService is ArmResourceListByParent<
    GroupContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| externalId | filter | eq |     |</br>
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
    },
    Response = GroupListResult
  >;

  /**
   * Lists a collection of user entities associated with the group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @operationId("GroupUser_List")
  list is ArmResourceActionSync<
    GroupContract,
    void,
    ApiManagementGroupUserListResult,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| firstName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| lastName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| email | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| registrationDate | filter | ge, le, eq, ne, gt, lt |     |</br>| note | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
    }
  >;

  /**
   * Checks that user entity specified by identifier is associated with the group entity.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("GroupUser_CheckEntityExists")
  checkEntityExists is ArmResourceActionNoContentSync<
    GroupContract,
    void,
    Parameters = {
      /**
       * User identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;
    }
  >;

  /**
   * Add existing user to existing group
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @put
  @operationId("GroupUser_Create")
  create is ArmResourceActionSync<
    GroupContract,
    void,
    ApiManagementGroupUserData,
    Parameters = {
      /**
       * User identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;
    }
  >;

  /**
   * Remove existing user from existing group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @delete
  @operationId("GroupUser_Delete")
  groupUserDelete is ArmResourceActionSync<
    GroupContract,
    void,
    void,
    Parameters = {
      /**
       * User identifier. Must be unique in the current API Management service instance.
       */
      @maxLength(80)
      @minLength(1)
      @path
      userId: string;
    }
  >;
}

@@maxLength(GroupContract.name, 256);
@@minLength(GroupContract.name, 1);
@@doc(GroupContract.name,
  "Group identifier. Must be unique in the current API Management service instance."
);
@@doc(GroupContract.properties, "Group entity contract properties.");
@@doc(GroupContracts.createOrUpdate::parameters.resource, "Create parameters.");
@@doc(GroupContracts.update::parameters.properties, "Update parameters.");
