import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./IssueContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Issue Comment Contract details.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(IssueContract)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  IssueCommentContractProperties
)
model IssueCommentContract extends ProxyResourceBase {
  /**
   * Comment identifier within an Issue. Must be unique in the current Issue.
   */
  @maxLength(256)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("commentId")
  @segment("comments")
  @visibility("read")
  name: string;

  /**
   * Properties of the Issue Comment.
   */
  @extension("x-ms-client-flatten", true)
  properties?: IssueCommentContractProperties;
}

@armResourceOperations
interface IssueCommentContracts {
  /**
   * Gets the details of the issue Comment for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiIssueComment_Get")
  get is ArmResourceRead<IssueCommentContract>;

  /**
   * Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("ApiIssueComment_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      IssueCommentContract,
      BaseParameters<IssueCommentContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates a new Comment for the Issue in an API or updates an existing one.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiIssueComment_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IssueCommentContract,
    {
      ...BaseParameters<IssueCommentContract>;

      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Deletes the specified comment from an Issue.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiIssueComment_Delete")
  delete is ArmResourceDeleteSync<
    IssueCommentContract,
    {
      ...BaseParameters<IssueCommentContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all comments for the Issue associated with the specified API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiIssueComment_ListByService")
  listByService is ArmResourceListByParent<
    IssueCommentContract,
    {
      ...BaseParameters<IssueCommentContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
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
}

@@encodedName(IssueCommentContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(IssueCommentContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(IssueCommentContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
