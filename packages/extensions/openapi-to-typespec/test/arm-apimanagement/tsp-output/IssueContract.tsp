import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Issue Contract details.")
@parentResource(ApiContract)
model IssueContract is ProxyResource<IssueContractProperties> {
  @doc("Issue identifier. Must be unique in the current API Management service instance.")
  @maxLength(256)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @key("issueId")
  @segment("issues")
  name: string;
}

@armResourceOperations
interface ApiIssue {
  @doc("Gets the details of the Issue for an API specified by its identifier.")
  get is ArmResourceRead<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

      @doc("Expand the comment attachments. ")
      @query("expandCommentsAttachments")
      expandCommentsAttachments?: boolean;
    }
  >;
  @doc("Gets the entity state (Etag) version of the Issue for an API specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<IssueContract, BaseParameters<IssueContract>>,
  ): OkResponse | ErrorResponse;
  @doc("Creates a new Issue for an API or updates an existing one.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates an existing issue for an API.")
  update is ArmCustomPatchSync<
    IssueContract,
    IssueUpdateContract,
    {
      ...BaseParameters<IssueContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes the specified Issue from an API.")
  delete is ArmResourceDeleteSync<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists all issues associated with the specified API.")
  listByService is ArmResourceListByParent<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Expand the comment attachments. ")
      @query("expandCommentsAttachments")
      expandCommentsAttachments?: boolean;

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
