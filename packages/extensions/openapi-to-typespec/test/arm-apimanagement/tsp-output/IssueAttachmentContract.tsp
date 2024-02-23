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
 * Issue Attachment Contract details.
 */
@parentResource(IssueContract)
model IssueAttachmentContract
  is ProxyResource<IssueAttachmentContractProperties> {
  /**
   * Attachment identifier within an Issue. Must be unique in the current Issue.
   */
  @maxLength(256)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("attachmentId")
  @segment("attachments")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface IssueAttachmentContracts {
  /**
   * Gets the details of the issue Attachment for an API specified by its identifier.
   */
  get is ArmResourceRead<IssueAttachmentContract>;

  /**
   * Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
   */
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      IssueAttachmentContract,
      BaseParameters<IssueAttachmentContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates a new Attachment for the Issue in an API or updates an existing one.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IssueAttachmentContract,
    {
      ...BaseParameters<IssueAttachmentContract>;

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
  delete is ArmResourceDeleteSync<
    IssueAttachmentContract,
    {
      ...BaseParameters<IssueAttachmentContract>;

      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all attachments for the Issue associated with the specified API.
   */
  listByService is ArmResourceListByParent<
    IssueAttachmentContract,
    {
      ...BaseParameters<IssueAttachmentContract>;

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

@@doc(IssueAttachmentContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
