import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiIssue.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Issue Attachment Contract details.")
@parentResource(ApiIssue)
model ApiIssueAttachment is ProxyResource<IssueAttachmentContractProperties> {
  @doc("Attachment identifier within an Issue. Must be unique in the current Issue.")
  @maxLength(256)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("attachmentId")
  @segment("attachments")
  name: string;
}

@armResourceOperations
interface ApiIssueAttachments {
  @doc("Gets the details of the issue Attachment for an API specified by its identifier.")
  get is ArmResourceRead<ApiIssueAttachment>;
  @doc("Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiIssueAttachment,
      BaseParameters<ApiIssueAttachment>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates a new Attachment for the Issue in an API or updates an existing one.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiIssueAttachment,
    {
      ...BaseParameters<ApiIssueAttachment>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Deletes the specified comment from an Issue.")
  delete is ArmResourceDeleteSync<
    ApiIssueAttachment,
    {
      ...BaseParameters<ApiIssueAttachment>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists all attachments for the Issue associated with the specified API.")
  listByService is ArmResourceListByParent<
    ApiIssueAttachment,
    {
      ...BaseParameters<ApiIssueAttachment>;

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
