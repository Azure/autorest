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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiManagementServiceResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(GroupContractProperties)
model GroupContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = GroupContract,
    KeyName = "groupId",
    SegmentName = "groups",
    NamePattern = ""
  >;

  /**
   * Group entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: GroupContractProperties;
}

@armResourceOperations
interface GroupContracts {
  /**
   * Gets the details of the group specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Group_Get")
  get is ArmResourceRead<GroupContract>;

  /**
   * Gets the entity state (Etag) version of the group specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("Group_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<GroupContract, BaseParameters<GroupContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or Updates a group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Group_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    GroupContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<GroupContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Group_Update")
  update is ArmCustomPatchSync<
    GroupContract,
    GroupUpdateParameters,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<GroupContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Group_Delete")
  delete is ArmResourceDeleteSync<
    GroupContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<GroupContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Group_ListByService")
  listByService is ArmResourceListByParent<
    GroupContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<GroupContract>;

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
    }
  >;

  /**
   * Lists a collection of user entities associated with the group.
   */
  // FIXME: GroupUser_List could not be converted to a resource operation
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("GroupUser_List")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/groups/{groupId}/users")
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
     * Group identifier. Must be unique in the current API Management service instance.
     */
    @maxLength(256)
    @minLength(1)
    @path
    groupId: string,

    /**
     * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| firstName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| lastName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| email | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| registrationDate | filter | ge, le, eq, ne, gt, lt |     |</br>| note | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
  ): ArmResponse<ApiManagementGroupUserListResult> | ErrorResponse;
}

@@maxLength(GroupContract.name, 256);
@@minLength(GroupContract.name, 1);
@@doc(GroupContract.name,
  "Group identifier. Must be unique in the current API Management service instance."
);
@@encodedName(GroupContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(GroupContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(GroupContracts.createOrUpdate::parameters.resource, "Create parameters.");
@@encodedName(GroupContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(GroupContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(GroupContracts.update::parameters.properties, "Update parameters.");
