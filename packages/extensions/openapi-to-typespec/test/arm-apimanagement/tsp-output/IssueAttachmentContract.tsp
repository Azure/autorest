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
@doc("Issue Attachment Contract details.")
@parentResource(IssueContract)
model IssueAttachmentContract
  is ProxyResource<IssueAttachmentContractProperties> {
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
interface IssueAttachmentContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the issue Attachment for an API specified by its identifier.")
  @operationId("ApiIssueAttachment_Get")
  get is ArmResourceRead<IssueAttachmentContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.")
  @head
  @operationId("ApiIssueAttachment_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      IssueAttachmentContract,
      BaseParameters<IssueAttachmentContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new Attachment for the Issue in an API or updates an existing one.")
  @operationId("ApiIssueAttachment_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IssueAttachmentContract,
    {
      ...BaseParameters<IssueAttachmentContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the specified comment from an Issue.")
  @operationId("ApiIssueAttachment_Delete")
  delete is ArmResourceDeleteSync<
    IssueAttachmentContract,
    {
      ...BaseParameters<IssueAttachmentContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists all attachments for the Issue associated with the specified API.")
  @operationId("ApiIssueAttachment_ListByService")
  listByService is ArmResourceListByParent<
    IssueAttachmentContract,
    {
      ...BaseParameters<IssueAttachmentContract>;

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

@@projectedName(IssueAttachmentContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(IssueAttachmentContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(IssueAttachmentContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
