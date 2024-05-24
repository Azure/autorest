import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./IssueContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Issue Attachment Contract details.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(IssueContract)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  IssueAttachmentContractProperties
)
model IssueAttachmentContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = IssueAttachmentContract,
    KeyName = "attachmentId",
    SegmentName = "attachments",
    NamePattern = "^[^*#&+:<>?]+$"
  >;

  /**
   * Properties of the Issue Attachment.
   */
  @extension("x-ms-client-flatten", true)
  properties?: IssueAttachmentContractProperties;
}

@armResourceOperations
interface IssueAttachmentContracts {
  /**
   * Gets the details of the issue Attachment for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiIssueAttachment_Get")
  get is ArmResourceRead<IssueAttachmentContract>;

  /**
   * Gets the entity state (Etag) version of the issue Attachment for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("ApiIssueAttachment_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      IssueAttachmentContract,
      BaseParameters<IssueAttachmentContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates a new Attachment for the Issue in an API or updates an existing one.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiIssueAttachment_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IssueAttachmentContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<IssueAttachmentContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ApiIssueAttachment_Delete")
  delete is ArmResourceDeleteSync<
    IssueAttachmentContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<IssueAttachmentContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiIssueAttachment_ListByService")
  listByService is ArmResourceListByParent<
    IssueAttachmentContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<IssueAttachmentContract>;

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

@@maxLength(IssueAttachmentContract.name, 256);
@@minLength(IssueAttachmentContract.name, 1);
@@doc(IssueAttachmentContract.name,
  "Attachment identifier within an Issue. Must be unique in the current Issue."
);
@@encodedName(IssueAttachmentContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(IssueAttachmentContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(IssueAttachmentContracts.createOrUpdate::parameters.resource,
  "Create parameters."
);
