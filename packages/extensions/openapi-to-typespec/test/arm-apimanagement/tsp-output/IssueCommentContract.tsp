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
@doc("Issue Comment Contract details.")
@parentResource(IssueContract)
model IssueCommentContract is ProxyResource<IssueCommentContractProperties> {
  @doc("Comment identifier within an Issue. Must be unique in the current Issue.")
  @maxLength(256)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("commentId")
  @segment("comments")
  name: string;
}

@armResourceOperations
interface IssueCommentContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the issue Comment for an API specified by its identifier.")
  @operationId("ApiIssueComment_Get")
  get is ArmResourceRead<IssueCommentContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the issue Comment for an API specified by its identifier.")
  @head
  @operationId("ApiIssueComment_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      IssueCommentContract,
      BaseParameters<IssueCommentContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new Comment for the Issue in an API or updates an existing one.")
  @operationId("ApiIssueComment_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IssueCommentContract,
    {
      ...BaseParameters<IssueCommentContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the specified comment from an Issue.")
  @operationId("ApiIssueComment_Delete")
  delete is ArmResourceDeleteSync<
    IssueCommentContract,
    {
      ...BaseParameters<IssueCommentContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists all comments for the Issue associated with the specified API.")
  @operationId("ApiIssueComment_ListByService")
  listByService is ArmResourceListByParent<
    IssueCommentContract,
    {
      ...BaseParameters<IssueCommentContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;
}
